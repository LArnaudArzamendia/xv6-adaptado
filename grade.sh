#!/usr/bin/env bash
# grade.sh — FSS grader (xv6 x86) simplificado: C1 y C2, 1 QEMU por caso
set -euo pipefail

# ---------- Casos ----------
# C1: 1 proceso en A vs 3 en B (CPU-bound)
CASE1_DURATION=800;  CASE1_NA=1; CASE1_NB=3; CASE1_MODE="cpu";   CASE1_TOL_SHARE=10; CASE1_TOL_PERPROC=20; CASE1_STAGGERB=0
# C2: 2 procesos en A (CPU) vs 2 en B (I/O) — reparto 50/50
CASE2_DURATION=1200; CASE2_NA=2; CASE2_NB=2; CASE2_MODE="mixed"; CASE2_TOL_SHARE=8;  CASE2_TOL_PERPROC=20; CASE2_STAGGERB=0

# ---------- Timeout y build ----------
EXPECT_TIMEOUT=${EXPECT_TIMEOUT:-80}

echo "[grade] Construyendo artefactos: user/fs.img kernel/xv6.img ..."
make -s user/fs.img kernel/xv6.img

# Si existe print-qemu-cmd en tu Makefile, úsalo. Si no, fallback a 'make qemu-nox'
QEMU_CMD_DEFAULT="$(make -s print-qemu-cmd 2>/dev/null || true)"
[[ -z "$QEMU_CMD_DEFAULT" ]] && QEMU_CMD_DEFAULT="make qemu-nox"

# ---------- Runner (1 QEMU por caso, con log) ----------
run_one_logged() {
  local label="$1"
  local cmd="$2"
  local logfile="$(mktemp -t ${label//[^A-Za-z0-9]/_}.XXXXXX.log)"

  echo
  echo "[grade] === $label ==="
  echo "[grade] CMD: $cmd"
  echo "[grade] Log: $logfile"

  EXPECT_TIMEOUT="$EXPECT_TIMEOUT" \
  QEMU_CMD_DEFAULT="$QEMU_CMD_DEFAULT" \
  CASE_CMD="$cmd" \
  LOGFILE="$logfile" \
  expect <<'EOF' || true
proc def {name value} {
  if {![info exists ::env($name)] || $::env($name) eq ""} { set ::env($name) $value }
}
def EXPECT_TIMEOUT 80
def QEMU_CMD_DEFAULT "make qemu-nox"
def CASE_CMD "echo missing CASE_CMD"
def LOGFILE "/tmp/fss_case.log"

log_file -a $env(LOGFILE)
set timeout $env(EXPECT_TIMEOUT)

set qemu_cmd $env(QEMU_CMD_DEFAULT)
puts "\[grade/expect] Spawning: $qemu_cmd"
spawn -noecho sh -c $qemu_cmd

# Esperar al shell de xv6
expect {
  -re {init:\ starting\ sh} { exp_continue }
  -re {\$\ $} {}
  timeout { puts "\[grade/expect] TIMEOUT esperando prompt inicial"; exit 2 }
  eof     { puts "\[grade/expect] EOF antes del prompt inicial";   exit 3 }
}

# Ejecutar el caso
set casecmd $env(CASE_CMD)
puts "\[grade/expect] Running: $casecmd"
send -- "$casecmd\r"

# Esperar el RESULT
set got "TIMEOUT"
expect {
  -re {RESULT:\ (PASS|FAIL)} {
    set got $expect_out(1,string)
    puts "\[grade/expect] RESULT => $got"
  }
  timeout { puts "\[grade/expect] RESULT => TIMEOUT" }
  eof     { puts "\[grade/expect] RESULT => EOF" }
}

# Salir de QEMU (si sigue vivo)
catch { send -- "\r" } _
catch { send "\001x" } _
expect eof
EOF

  # Extraer el resultado del log
  local res
  res="$(grep -Eo 'RESULT => (PASS|FAIL|TIMEOUT|EOF)' "$logfile" | tail -n1 | awk '{print $3}' || true)"
  [[ -z "$res" ]] && res="TIMEOUT"
  echo "[grade] $label => $res"

  # Guardar estado en variables globales PASS/FAIL
  if [[ "$res" == "PASS" ]]; then
    echo "PASS" > "${logfile}.status"
    return 0
  else
    echo "FAIL" > "${logfile}.status"
    return 1
  fi
}

# ---------- Armar comandos ----------
C1="fss_bench $CASE1_DURATION $CASE1_NA $CASE1_NB $CASE1_MODE $CASE1_TOL_SHARE $CASE1_TOL_PERPROC $CASE1_STAGGERB -q"
C2="fss_bench $CASE2_DURATION $CASE2_NA $CASE2_NB $CASE2_MODE $CASE2_TOL_SHARE $CASE2_TOL_PERPROC $CASE2_STAGGERB -q"

# ---------- Ejecutar ----------
PASS=0; FAIL=0
run_one_logged "C1(1v3,cpu)"   "$C1" && ((PASS++)) || ((FAIL++))
run_one_logged "C2(2v2,mixed)" "$C2" && ((PASS++)) || ((FAIL++))

# ---------- Resumen ----------
echo
echo "[grade] PASS: $PASS"
echo "[grade] FAIL/TIMEOUT: $FAIL"

if [[ "$FAIL" -eq 0 && "$PASS" -ge 2 ]]; then
  echo "[grade] ✅ TODOS LOS CASOS PASARON"
  exit 0
else
  echo "[grade] ❌ HAY CASOS FALLIDOS O TIMEOUT"
  exit 1
fi
