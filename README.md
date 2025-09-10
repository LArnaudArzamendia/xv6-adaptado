# Tarea 1 - Llamadas al sistema e implementación de una shell

En esta primera tarea del curso trabajarás directamente con un kernel real. El kernel utilizado es una adaptación de Unix versión 6 (1975), llamada xv6, que ha sido portada a la arquitectura x86 para ejecutarse en hardware moderno. El Unix original corría en un [PDP-11](https://en.wikipedia.org/wiki/PDP-11), y su código fuente estaba escrito en C, lo que permitió su portabilidad a distintas arquitecturas y hoy hace posible que podamos experimentar con él en este curso.

El objetivo de la tarea es introducirte en la programación a nivel de kernel (kernel hacking) y en la implementación de algoritmos de planificación de procesos. Para ello, la tarea se divide en dos etapas:

* Parte 1.1 – Fecha de entrega 5/9 23:59 - Llamadas al sistema: deberás implementar nuevas syscalls en xv6 (`waitx`, `setgroup`, `getgroup`). Esta parte te permitirá comprender cómo se agregan funcionalidades al sistema operativo, cómo se comunican los programas de usuario con el kernel, y cómo se manejan estructuras internas de procesos.
* Parte 1.2 – Fecha de entrega 22/9 23:59 -  Planificador FSS (Fair Share Scheduler): utilizando las llamadas implementadas en la primera parte, modificarás el scheduler por defecto de xv6 para implementar un planificador basado en grupos, de manera que los procesos se repartan el tiempo de CPU en proporciones justas según su pertenencia a un grupo. Esta parte te permitirá observar de manera práctica cómo los algoritmos de planificación afectan al comportamiento del sistema.

De esta forma, pasarás desde implementar llamadas básicas hasta alterar un componente central del sistema operativo: el scheduler. Esto te dará una visión concreta de cómo las abstracciones que estudias a nivel teórico (llamadas al sistema, procesos, planificación) se materializan en código real de un kernel.

## Índice

- [Modalidad de trabajo](#modalidad-de-trabajo)
- [Tarea 1.1: Nuevas llamadas al sistema (50% de la nota final)](#tarea-11-nuevas-llamadas-al-sistema-50-de-la-nota-final)
  - [waitx()](#waitx)
  - [setgroup()](#setgroup)
  - [getgroup()](#getgroup)
  - [Primeros pasos](#primeros-pasos)
  - [Compilación, Ejecución y Depuración](#compilación-ejecución-y-depuración)
  - [Requisitos Específicos](#tarea-11-requisitos-específicos)
  - [Test Automatizado](#test-automatizado)
  - [Compilación en macOS](#instrucciones-específicas-para-compilar-en-macos)
- [Declaración de uso de LLMs (Parte 1)](#declaración-de-uso-de-llms)
- [Tarea 1.2: Implementación de Fair Share Scheduling (FSS)](#tarea-12-implementación-de-fair-share-scheduling-fss-en-xv6)
  - [Descripción técnica de FSS](#descripción-técnica-de-fair-share-scheduling-fss-stride-scheduling)
  - [Desarrollo de la Tarea](#desarrollo-de-la-tarea-50-de-la-nota)
  - [Casos de prueba](#casos-de-prueba-35-de-la-nota)
  - [Informe de Segunda Parte](#informe-de-segunda-parte-15-de-la-nota)
- [Declaración de uso de LLMs (Parte 2)](#declaración-de-uso-de-llms-1)

## Modalidad de trabajo

Esta tarea deberá ser resuelta en parejas. La totalidad del trabajo debe realizarse en el repositorio clonado después de aceptar la invitación en GitHub classroom. Para la entrega, se considerará la última revisión en el repositorio anterior a la fecha y hora de entrega. Para las partes 1 y 2 de la tarea las fechas de entrega son las siguientes:

* Primera parte (1.1, 50% de la nota): 5 de septiembre, 23:59 hrs.
* Segunda parte (1.2, 50% de la nota): 22 de septiembre, 23:59 hrs.

# Tarea 1.1: Nuevas Llamadas al Sistema para Implementar FSS

En esta primera parte deberás agregar tres nuevas llamadas al sistema al kernel de xv6.  
El objetivo es familiarizarse con la implementación de *syscalls* y preparar las herramientas necesarias para la segunda parte de la tarea.

## `waitx()`

La llamada `waitx()` es una extensión de la llamada estándar `wait()`.  
Además de esperar a que un proceso hijo termine, devuelve información sobre el tiempo de CPU y el tiempo de espera que acumuló dicho hijo durante su ejecución.

**Firma de la llamada:**

```c
int waitx(int *wtime, int *rtime);
```

* `wtime`: tiempo total que el proceso hijo pasó en estado de espera (runnable pero no ejecutándose).
* `rtime`: tiempo total que el proceso hijo pasó en ejecución en la CPU.
* Valor de retorno: el PID del hijo terminado (igual que `wait()`), o `-1` en caso de error o si no hay hijos.

## `setgroup()`

La llamada `setgroup()` asigna un proceso a un grupo de planificación.
Esto permitirá que, en la segunda parte de la tarea, el planificador _Fair Share Scheduler_(FSS) reparta la CPU entre grupos en lugar de hacerlo entre procesos individuales.

Firma de la llamada:

```c
int setgroup(int pid, int gid);
```

* `pid`: identificador del proceso cuyo grupo será modificado.
* `gid`: identificador del grupo al cual se desea asignar el proceso.
* Valor de retorno: 0 si la operación fue exitosa, o `-1` en caso de error (por ejemplo, si el proceso con pid no existe).

## `getgroup()`

La llamada `getgroup()` permite consultar a qué grupo de planificación pertenece un proceso.

Firma de la llamada:

```c
int getgroup(int pid);
```

* `pid`: identificador del proceso.
* Valor de retorno: el `gid` del proceso en caso de éxito, o `-1` en caso de error (por ejemplo, si el proceso con `pid` no existe).

## Primeros pasos

Puedes revisar un [playlist de YouTube](https://youtube.com/playlist?list=PL3yryPU8iwGO2IsoEa_F8_zIytuHIHV37) con tres vídeos que explican todo lo necesario para comenzar tu *kernel hacking* después de clonar el repositorio con el código base de la tarea.  

El último vídeo, sobre planificación de procesos y sincronización, también es útil que lo veas, incluso si aún no hemos abordado completamente la materia en clases.

Una manera de comenzar a hackear un código base relativamente grande como el de xv6 es buscar partes similares a lo que necesitas hacer, y luego **copiar y modificar** esas partes.  

Por ejemplo:  

- Puedes estudiar la implementación de una syscall simple como `getpid()`, para ver la estructura completa de cómo se define, se conecta en la tabla de llamadas y se implementa en el kernel.  
- En el caso de `waitx()`, resulta útil revisar el código de `wait()`, ya que `waitx()` es esencialmente una versión extendida que, además de esperar a que un hijo termine, reporta tiempos de CPU (*rtime*) y de espera (*wtime*).

La mayor parte del esfuerzo se concentrará en **comprender el código existente** y realizar las modificaciones necesarias. La cantidad de código nuevo a escribir es relativamente pequeña.

Finalmente, recuerda que puedes usar el debugger **gdb** para trazar la ejecución del kernel.  

- Compila y ejecuta xv6 en modo depuración con:  

```bash
make qemu-gdb
```

Luego, en otra terminal, ejecuta:

```bash
gdb kernel
```

Esto abrirá gdb en modo remoto, conectado a xv6, y te permitirá inspeccionar paso a paso cómo funciona tu código dentro del kernel.

Dentro del kernel no se puede usar `printf()` como en programas de usuario, pero se dispone de funciones equivalentes. La más usada es `cprintf()`, que permite imprimir mensajes en la consola para depuración, con un formato similar a `printf()`. En cambio, la función `panic()` se utiliza cuando ocurre un error crítico del cual el kernel no puede recuperarse: imprime un mensaje, muestra información de depuración y detiene la ejecución del sistema. Ambas funciones son herramientas fundamentales para comprender qué ocurre dentro del kernel durante el desarrollo de la tarea.

## Compilación, Ejecución y Depuración

Primero debemos estar seguros de que el set de herramientas de compilación necesario está instalado y operativo en nuestro ambiente de desarrollo. Para compilar xv6 y los programas de usuario, es necesario contar con un compilador GCC que genere binarios ejecutables para arquitectura Intel i386 de 32 bits, y en formato Executable and Linkable Format (ELF). Este formato es el nativo utilizado por Linux, entonces, si compilas en Linux (o Windows con WSL) normalmente no necesitarás instalar nada aparte.  

**Instrucciones específicas para compilar en Linux**

Para compilar en Linux, asegúrate de contar con GCC operativo. Respecto al código de xv6, asegúrate de que las líneas 37 y 38 del `Makefile` en el directorio raíz de este repositorio estén comentadas, y la línea 40 esté descomentada y se vea así:

```Makefile
TOOLPREFIX = 
```

En Linux se usa el GCC nativo instalado y por ello se deja el prefijo de herramientas GCC en blanco.

## Tarea 1.1: Requisitos Específicos

### 1) `struct proc` (archivo: `kernel/proc.h`) (.5 punto)
Debes **extender** la estructura del proceso con contadores de tiempo y un identificador de grupo:

- `int rtime;` — tiempo total en **RUNNING** (ticks de CPU).
- `int wtime;` — tiempo total en **RUNNABLE** (ticks esperando CPU).
- `int stime;` — (opcional) tiempo total en **SLEEPING** (útil para depurar).
- `int gid;` — identificador de **grupo** de planificación.

Los primeros tres campos serán leídos/escritos por `waitx`. El campo `gid` es requerido por las otras dos _system calls_ que debes implementar.

Para facilitar la contabilidad del tiempo, el kernel de xv6 ya se encuentra parcialmente modificado para realizar contabilidad de ticks (un tick ocurre cada 10 ms aproximadamente; esto se define en `kernel/lapic.c`) de los procesos. La contabilidad de ticks es implementada en la función `tick_accounting` en `kernel/proc.c`. Esta función itera por toda la tabla de procesos, y debe incrementar (i.e., sumar 1) a los campos `rtime`, `wtime` y `stime` del PCB de cada proceso - dependiendo de cuál sea su estado (`RUNNING`, `RUNNABLE` y `SLEEPING`). **Estas operaciones de incremento están pendientes; tú debes implementarlas una vez que definas los campos `rtime`, `wtime` y `stime` en `struct proc`.**

El manejador de traps en `kernel/trap.c` (ver caso `T_IRQ0 + IRQ_TIMER` en función `trap`) llama a la función `tick_accounting` cada vez que hay una interrupción de timer.

### 2) Inicialización y herencia de campos (archivo: `kernel/proc.c`) (1.0 punto)
Asegúrate de **inicializar** y **mantener** coherentes los campos nuevos:

- En `allocproc()`:
  - inicializa `p->rtime = p->wtime = p->stime = 0;`
  - inicializa `p->gid = 0;` (grupo por defecto)
- En `fork()`:
  - hereda `np->gid = curproc->gid;`
  - opcionalmente vuelve a poner a cero los contadores del **hijo** (`np->rtime = np->wtime = np->stime = 0;`), según el diseño que uses para medir desde el *fork*.

Nota SMP: estos campos se actualizan de forma segura bajo `ptable.lock` (en `tick_accounting` provisto).

### 3) `waitx`: datos expuestos al espacio de usuario (2.0 puntos)
`waitx` retorna el **PID** del hijo terminado y escribe en los punteros de usuario `wtime`/`rtime` los totales del hijo:

- En `kernel/proc.c`:
  - Implementa `int waitx(int *wtime, int *rtime)` análogo a `wait()`, copiando `p->wtime` y `p->rtime` **antes** de liberar el `struct proc` del hijo.
- En `kernel/sysproc.c`:
  - Wrapper `int sys_waitx(void)` que obtiene dos punteros con `argptr()` y llama a `waitx(...)`.

**Enlaces de syscall** (ver punto 5): agrega número, tabla y prototipo.

### 4) `setgroup` / `getgroup`: acceso a `gid` de un proceso (1.0 punto)
Necesitas una operación de kernel para **asignar** y otra para **consultar** el grupo:

- En `kernel/proc.c`:
  - `int setgroup_k(int pid, int gid)` — busca el proceso por `pid` bajo `ptable.lock` y setea `p->gid = gid`. Retorna `0`/`-1`.
  - `int getgroup_k(int pid)` — retorna el `gid` del proceso (o `-1` si no existe).

- En `kernel/sysproc.c`:
  - `int sys_setgroup(void)` — obtiene `pid` y `gid` con `argint()` y llama a `setgroup_k(...)`.
  - `int sys_getgroup(void)` — obtiene `pid` con `argint()` y llama a `getgroup_k(...)`.

Política de permisos mínima: puedes permitir solo `pid == getpid()` para `setgroup`, o permitir al padre cambiar el grupo de sus hijos. Define y documenta tu elección.

### 5) Cableado de *syscalls* (archivos varios) (1.0 punto)
Para que el espacio de usuario invoque las nuevas llamadas:

- `kernel/syscall.h`: define `SYS_waitx`, `SYS_setgroup`, `SYS_getgroup` con números **no utilizados**.
- `kernel/syscall.c`: 
  - declara `extern int sys_waitx(void);`, `extern int sys_setgroup(void);`, `extern int sys_getgroup(void);`
  - agrega las entradas en la tabla `syscalls[]` en los índices `SYS_*` respectivos.
- `user/user.h`: prototipos de usuario:
```c
int waitx(int *wtime, int *rtime);
int setgroup(int pid, int gid);
int getgroup(int pid);
```

En `kernel/usys.S`, tienes que agregar:

```c
SYSCALL(waitx)
SYSCALL(setgroup)
SYSCALL(getgroup)
```

### 6) Locks y Consistencia (.5 punto)

* Toda lectura/modificación de `struct proc` en estas rutinas debe realizarse bajo `ptable.lock` (como ya hace `wait()`).
* `tick_accounting` (provisto) también usa ptable.lock. Evita hacerla dentro de otras regiones críticas ajenas (por ejemplo, no dentro de `tickslock`).

## Test Automatizado

Contamos con un test automatizado en espacio de usuario para la parte 1. El programa con la funcionalidad de test se llama `p1_syscalls_test` y puede ser invocado desde la shell de xv6:

```sh
$./p1_syscalls_test
```

**La compilación de `p1_syscalls_test` la tienes que activar descomentando la línea correspondiente en el `Makefile` (línea 190 aprox)**:

```Makefile
#	$U/_p1_syscalls_test\
```

El programa crea hijos en distintos grupos, cada hijo se auto-asigna su `gid` con `setgroup`(`getpid()`, `gid`), le avisa al padre su `pid` y `gid` por pipe, hace algo de trabajo (CPU o I/O), y termina.

El padre usa `waitx(&w, &r)` para recoger tiempos y muestra una tabla `pid` / `gid` / `rtime` / `wtime`. Además, valida que setgroup haya surtido efecto.

Ejemplos:

```sh
$ p1_syscalls_test
pid	gid	rtime	wtime
16	1	3	0
17	2	3	3

$ p1_syscalls_test 2 2
pid	gid	rtime	wtime
5	1	2	0
6	1	3	2
7	2	2	5
8	2	3	7
# 2 hijos en gid=1 (CPU), 2 hijos en gid=2 (CPU)

$ p1_syscalls_test 2 2 mixed
pid	gid	rtime	wtime
10	1	3	0
11	1	3	3
12	2	0	126
13	2	0	126
# 2 hijos en gid=1 (CPU), 2 hijos en gid=2 con carga de "I/O"
```

Qué comprueba:

* `setgroup(getpid(), gid)` funciona (el hijo lo aplica sobre sí mismo).
* `getgroup(pid)` devuelve el `gid` esperado (si se consulta antes de que el hijo termine).
* `waitx(&w,&r)` devuelve PID y llena `wtime`/`rtime` con valores coherentes (>0 para `rtime` y/o `wtime`, según la carga).

Nota: `getgroup(pid)` después de `waitx` probablemente devuelve `-1` porque el hijo ya fue liberado; por eso el programa usa un _pipe_ (canal de comunicación inter-procesos) para conocer `gid` de cada `pid` antes de recolectarlos.

**Instrucciones específicas para compilar en macOS**

Si usas un Mac, con procesador Intel o ARM, tendrás que instalar una versión de GCC que genere binarios Intel de 32 bits en formato ELF.

Si usas Mac, debes tener homebrew instalado. Luego, instalas GCC para i686-elf, con el siguiente comando:

```sh
brew install i686-elf-gcc
```

Luego, debes ir al `Makefile` en la raíz de este repositorio y descomentar la línea 37, que dice:

```Makefile
TOOLPREFIX = i686-elf-
```

Esto activará la variable `TOOLPREFIX` con el prefijo `i686-elf` para gcc y binutils, programas que se requieren para compilar correctamente xv6. Si no usas Mac, asegúrate de que dicha línea está comentada. 

**Compilar e iniciar xv6**

Para compilar e iniciar xv6, en el directorio en donde se encuentra el código de la tarea, se debe ejecutar el siguiente comando:

```sh 
prompt> make qemu-nox 
```

Para cerrar qemu, se debe presionar la combinación de teclas `Ctrl-a-x`.

Si se desea depurar el kernel con gdb, se debe compilar y ejecutar con 

```sh 
prompt> make qemu-nox-gdb
```

En un terminal paralelo, en el directorio del código base de la tarea se debe ejecutar gdb:

```sh
prompt> gdb kernel
```

Algunas operaciones comunes con gdb son las siguientes:

* `c` para continuar la depuración. **Siempre se debe ingresar este comando cuando se inicia gdb**
* `b archivo:linea` para fijar un _breakpoint_ en cierto `archivo` y `linea` del mismo.
* `backtrace` (o `bt`) para mostrar un resumen de cómo ha sido la ejecución hasta el momento.
* `info registers` muestra el estado de registros de la CPU.
* `print`, `p` o `inspect` son útiles para evaluar una expresión.
*  Más información aquí: http://web.mit.edu/gnu/doc/html/gdb_10.html

En el kernel, puedes imprimir mensajes de depuración utilizando la función `cprintf`, la cual admite strings de formato similares a `printf` de la biblioteca estándar. Puedes ver los detalles de implementación en `kernel/console.c`.

Además, existe la función `panic` que permite detener la ejecución del kernel cuando ocurre una situación de error. Esta función muestra una traza de la ejecución hasta el momento en que es ejecutada. Los valores que muestra pueden ser buscados en `kernel/kernel.asm` para comprender cómo pudo haberse ejecutado la función.

## Declaración de uso de LLMs

En esta parte de la tarea está permitido el uso de LLMs, pero se debe declarar su uso. Para detalles sobre forma y usos permitidos de LLMs, revisar la última sección de este documento. Si no se entrega un informe apropiado al respecto, el grupo perderá el derecho a que su trabajo sea evaluado.

# Tarea 1.2: Implementación de Fair Share Scheduling (FSS) en xv6

En esta segunda parte de la tarea, el foco estará en la planificación de procesos. Los sistemas operativos modernos cuentan con planificadores sofisticados, que buscan repartir la CPU de manera eficiente y justa entre los distintos procesos y usuarios. Uno de estos algoritmos es **Fair Share Scheduling (FSS)**, cuyo objetivo es que el tiempo de CPU se distribuya de manera proporcional entre *grupos de procesos* en lugar de hacerlo entre procesos individuales.

Para implementar FSS en xv6, utilizarás las llamadas al sistema desarrolladas en la primera parte de la tarea (`waitx`, `setgroup`, `getgroup`). Estas syscalls te permitirán:

* Medir el uso real de CPU de cada proceso y grupo.
* Asignar procesos a distintos grupos de planificación.
* Consultar a qué grupo pertenece cada proceso.

El planificador FSS en xv6 debe garantizar que la CPU se reparta equitativamente según los grupos, de modo que si existen dos grupos con distinta cantidad de procesos, ambos reciban una fracción del procesador de acuerdo a su participación relativa, independientemente del número de procesos que contengan.

Los objetivos específicos de esta segunda parte son:

* Comprender cómo se implementa un algoritmo de planificación en el kernel.  
* Utilizar estructuras de datos y syscalls para administrar procesos en grupos de planificación.  
* Implementar una variante del algoritmo de planificación _Fair Share Scheduling_ (FSS).  
* Evaluar empíricamente tu implementación utilizando programas de prueba diseñados para medir la equidad en el reparto de CPU.  

## Descripción técnica de Fair Share Scheduling (FSS): Stride Scheduling

Una forma práctica de implementar FSS es mediante el algoritmo de **stride scheduling**, que se basa en los siguientes conceptos:

- **Stride**: cada grupo recibe un valor de stride, calculado como `L / share`, donde `L` es una constante grande (por ejemplo, 10,000) y `share` representa la participación del grupo (en nuestro caso, todos los grupos tienen igual participación inicial, por lo que `share = 1`).
- **Pass**: cada grupo mantiene un contador llamado *pass value*, que representa el "crédito acumulado" de CPU que ha recibido.  
- **Selección**: en cada decisión de planificación, se selecciona el grupo con el menor valor de *pass*. Luego, ese grupo ejecuta uno de sus procesos y su *pass* se incrementa en su `stride`.

De esta forma, los grupos se alternan en función de sus *pass values*, logrando un reparto proporcional y estable en el tiempo.

### Procesos dentro de un grupo

Una vez que el planificador selecciona un grupo para ejecutar, debe elegirse un proceso dentro de dicho grupo. Para simplificar, puedes utilizar un esquema **round-robin** (FIFO) entre los procesos del grupo.

### Estructuras requeridas

Para implementar FSS necesitarás:

- Mantener información de cada proceso sobre a qué grupo pertenece (ya implementado en la primera parte con `setgroup`/`getgroup`).
- Mantener una estructura global que registre, para cada grupo:
  - `gid` (identificador del grupo).
  - `stride` (incremento de *pass* cada vez que le corresponde CPU).
  - `pass` (valor acumulado que define el orden en que será planificado).

### Objetivo del algoritmo

El resultado esperado es que, al ejecutar programas de prueba que consumen intensivamente CPU, el tiempo total de CPU usado por los procesos de cada grupo sea consistente con el reparto **justo** definido por FSS. Por ejemplo, si existen dos grupos, deberían repartirse la CPU aproximadamente en 50% y 50%, independientemente del número de procesos en cada uno.

## Desarrollo de la Tarea (50% de la nota)

En esta parte implementarás **Fair Share Scheduling** modificando principalmente el **planificador** de xv6. A continuación se indican los **puntos del kernel** que debes revisar/tocar y el **flujo mínimo** para que tu FSS funcione.

### 1) Dónde trabajar

- **`kernel/proc.c`**
  - `scheduler()` ← **aquí va el núcleo de FSS** (selección por grupo).
  - (Opcional) Helpers: `fss_pick_group()`, `fss_pick_proc_in_group()`, etc.
  - `fork()` / `allocproc()` ← aseguran herencia/valor por defecto de `gid`.
- **`kernel/proc.h`**
  - `struct proc` ya tiene `gid` (Parte 1) y contadores (`rtime`, `wtime`, …).
  - Define una **estructura por grupo** (p. ej. `struct group`) y una pequeña tabla global.
- **`kernel/defs.h`**
  - Prototipos de tus helpers FSS (si no los defines `static`).

### 2) Estructuras mínimas

Define una tabla de grupos simple:

```c
// proc.h
#define NGROUPS 16
#define FSS_BIG 100000

struct group {
  int  gid;        // identificador de grupo
  int  active;     // 1 si el slot está en uso
  uint pass;       // valor de “crédito” acumulado
  uint stride;     // FSS_BIG / share (usa share=1 en esta tarea)
  int  rr_cursor;  // índice para round-robin dentro del grupo
};

extern struct group gtable[NGROUPS];
```

Inicializa al boot (p. ej. en `pinit()`):

* Marca todos inactivos.
* Asegura `gid=0` activo (los procesos nacen en 0 si no cambias nada).
* `stride = FSS_BIG` (shares iguales).

### 3) Integración con setgroup / creación de procesos

- En `allocproc()` y **después** de asignar `p->gid`, llama a un helper tipo `fss_group_ensure(p->gid)` que:  
- Busca el grupo en `gtable` y lo marca activo si no existe.  
- En `fork()`, **hereda** `np->gid = currproc->gid` y vuelve a asegurar el grupo.  
- En `userinit()` (primer proceso):  
```c
p->gid = 0;
fss_group_ensure(0);
```

antes de marcarlo `RUNNABLE`.

Con esto te evitas estados donde hay procesos con `gid` válido pero sin grupo “activo” en la tabla.

### 4) Lógica del scheduler() (núcleo de FSS)

Con `ptable.lock` tomado:

1. Elegir grupo con menor pass que tenga al menos un proceso en estado `RUNNABLE`.
2. Elegir proceso dentro del grupo (round-robin sobre `ptable.proc[]` filtrando por `gid` y `state==RUNNABLE`).
3. Marcar `p->state = RUNNING`, hacer `swtch` (despachar proceso escogido).
4. Al volver del `swtch`, incrementar `pass` del grupo:
 * Versión simple y suficiente):
 ```c
 g->pass += g->stride;
 ```
5. Soltar `ptable.lock` y continuar el bucle.

Para robustez del algoritmo:

* Si no hay grupo elegible, `release(&ptable.lock); continue;` (no imprimas en loop).
* Si un grupo fue elegido pero ningún `RUNNABLE` se encuentra (carrera), suelta el lock y continúa.

### 5) Concurrencia y locks (Ejecución con Multiprocesador; SMP)

* Mantén ptable.lock durante:
  * Selección de grupo, selección de proceso y cambio de state a `RUNNING`.
* Es normal que con **CPUS>1** dos CPUs elijan el mismo grupo si hay varios `RUNNABLE` en él; el algoritmo se **auto-corrige** porque ese grupo acumula pass más rápido.

### 6) Política de shares (simplificada)

En esta tarea usa shares iguales para todos los grupos:
 * `stride = FSS_BIG / 1`.

### 7) Funciones pre-implementadas

En `proc.h/.c` se incluyen algunas funciones de apoyo para la implementación del scheduler **Fair Share Scheduling (FSS)**.  
Algunas están completas y otras se entregan como *stubs* (esqueleto con comentarios), para que ustedes las implementen.  

Estas funciones sirven para manejar la tabla de grupos (`gtable`) y los procesos asociados a cada grupo, de modo que el scheduler pueda decidir qué grupo y qué proceso ejecutar.

#### `static void fss_init_groups(void)`  
**Estado:** completa  

Inicializa la tabla de grupos (`gtable`).  
Deja todos los grupos como inactivos (`active = 0`) y asegura que el sistema parte sin grupos registrados.  
Se llama al inicio del kernel.

#### `static struct group* fss_group_lookup(int gid)`  
**Estado:** completa  

Busca en la tabla de grupos (`gtable`) un grupo activo cuyo identificador (`gid`) coincida con el argumento.  
- Si lo encuentra, retorna un puntero a ese grupo.  
- Si no lo encuentra, retorna `0`.  

Es útil cuando se necesita consultar si un grupo ya está registrado en el sistema.

#### `static struct group* fss_group_ensure(int gid)`  
**Estado:** *stub*  

Garantiza que exista un grupo con el `gid` dado.  
- Si ya existe, lo retorna directamente.  
- Si no existe, busca un slot libre en la `gtable`, inicializa un nuevo grupo (activo, con `pass = 0`, `stride = FSS_BIG` y `rr_cursor = 0`) y lo retorna.  
- Si no hay espacio en la `gtable`, retorna `0` (caso muy poco común en xv6).  

👉 Esta función es la forma estándar de asegurarse de que un `gid` tenga un grupo válido en memoria.

#### `static int fss_group_has_runnable(struct group *g)`  
**Estado:** *stub*  

Verifica si un grupo tiene **al menos un proceso en estado RUNNABLE**.  
- Recorre la tabla de procesos (`ptable.proc`) y busca procesos cuyo `gid` coincida con el del grupo y estén en estado `RUNNABLE`.  
- Retorna `1` si encuentra alguno, o `0` si no hay procesos listos para correr en ese grupo.  

Esta función permite saber si un grupo puede ser considerado por el scheduler.

#### `static struct group* fss_pick_group(void)`  
**Estado:** *stub*  

Selecciona el **grupo candidato a ejecutar** según FSS.  
- Recorre todos los grupos activos en la `gtable`.  
- Descarta los grupos sin procesos RUNNABLE.  
- Elige el grupo con el **menor valor de `pass`** (el que ha consumido menos CPU en términos relativos).  
- Si no hay grupos válidos, retorna `0`.  

Es la función que decide **qué grupo tiene el turno de CPU**.

#### `static struct proc* fss_pick_proc_in_group(struct group *g)`  
**Estado:** *stub*  

Selecciona un proceso dentro de un grupo dado, usando **round-robin**:  
- Comienza desde la posición `rr_cursor` del grupo.  
- Busca un proceso `RUNNABLE` en `ptable.proc` con el mismo `gid`.  
- Si encuentra uno, lo retorna y actualiza `rr_cursor` para la próxima vez.  
- Si no encuentra en la primera pasada, envuelve y busca desde el inicio hasta `rr_cursor`.  
- Si no hay ninguno, retorna `0`.  

Permite repartir la CPU de manera justa **entre los procesos de un mismo grupo**.

### Resumen del rol de estas funciones

- **Inicialización y lookup:** `fss_init_groups`, `fss_group_lookup`, `fss_group_ensure`  
- **Chequeo de procesos disponibles:** `fss_group_has_runnable`  
- **Selección de grupo y proceso:** `fss_pick_group`, `fss_pick_proc_in_group`

En conjunto, estas funciones permiten que el scheduler FSS:
1. Mantenga los grupos organizados.  
2. Elija el grupo menos favorecido en CPU (`pass` más bajo).  
3. Dentro de ese grupo, elija un proceso en orden circular (round-robin).  

## Casos de prueba (35% de la nota)

Para evaluar la correcta implementación del planificador **Fair Share Scheduler (FSS)**, se entrega una herramienta de pruebas llamada **fss_bench** junto con un script de automatización **grade.sh**.  

### Herramienta fss_bench

`fss_bench` es un programa de usuario que genera una carga controlada de procesos, asignándolos a distintos grupos de planificación y ejecutando patrones de trabajo (CPU-bound o con pausas `sleep`). Al finalizar, el programa imprime para cada proceso:

- `pid`: identificador del proceso.
- `gid`: identificador del grupo al que pertenece.
- `rtime`: tiempo total en CPU (ticks).
- `wtime`: tiempo total esperando (ticks).

Además, reporta el total de tiempo de CPU usado por cada grupo y el reparto porcentual observado.

**La compilación de `fss_bench` la tienes que activar descomentando la línea correspondiente en el Makefile (línea 190 aprox):**

```Makefile
#	$U/_fss_bench\
```

### Script grade.sh

El script `grade.sh` debe invocarse en el sistema operativo host (no en qemu):

```sh
./grade.sh
```

Este script automatiza la ejecución de `fss_bench` bajo distintos escenarios de prueba, compara los resultados con lo esperado y reporta si se cumple la política de reparto justo de CPU.  
En esta tarea se consideran únicamente **dos casos de prueba**:  

#### Caso C1: CPU-bound (1 vs 3 procesos)

- Configuración: un grupo A con 1 proceso intensivo en CPU, y un grupo B con 3 procesos también intensivos en CPU.  
- Objetivo: el FSS debe repartir el tiempo de CPU entre grupos de forma justa (≈50% para A y ≈50% para B), independientemente del número de procesos en cada grupo.  
- Tolerancia: se acepta un rango de ±10% en el reparto observado.  

#### Caso C2: Carga mixta (2 vs 2 procesos)

- Configuración: un grupo A con 2 procesos CPU-bound, y un grupo B con 2 procesos que combinan CPU y llamadas a `sleep`.  
- Objetivo: aun cuando los procesos de B hagan pausas, el planificador debe garantizar que, en promedio, el grupo B reciba aproximadamente el mismo porcentaje de CPU que el grupo A (≈50% / 50%).  
- Tolerancia: nuevamente se acepta un rango de ±10%.  

### Interpretación de resultados

El script imprimirá los resultados de cada caso. Un ejemplo típico de salida es:

```sh
pid gid rtime wtime
4 1 399 401
5 2 170 667
6 2 154 723
7 2 156 723

GROUP A (gid=1) CPU total rtime: 399
GROUP B (gid=2) CPU total rtime: 480
CPU share A/B: 45% / 55% (tolerance_share=10%)
```

Si la implementación cumple con los objetivos de FSS, el script marcará el caso como aprobado.  

## Informe de Segunda Parte (15% de la nota)

La segunda parte de la tarea requiere un informe, con el siguiente formato:

* Archivo **INFORME.md** en el directorio raíz del código fuente de xv6.
* Al inicio del archivo deben aparecer los nombres completos de los integrantes del grupo.
* El informe debe contener las siguientes secciones, cada una explicando cómo se implementó la funcionalidad respectiva.  
* En cada sección se deben incluir referencias al código fuente modificado, indicando números de línea relevantes.  
* Se recomienda utilizar el [formato markdown de GitHub](https://guides.github.com/features/mastering-markdown/) para mostrar ejemplos de código y fragmentos.

### Secciones requeridas

1. **Cambios en estructuras de datos**  
   Explicar qué campos se agregaron en las estructuras principales (por ejemplo `struct proc` y `struct gtable`).  
   Indicar cómo se inicializan esos campos y en qué partes del kernel.  

2. **Integración con syscalls `setgroup` y `getgroup`**  
   Describir cómo se utilizan estas llamadas en la asignación de grupos.  
   Explicar cómo se asegura la creación de grupos en `allocproc`, `fork` y `userinit`.  

3. **Modificaciones en `scheduler()`**  
   Explicar cómo se cambió la lógica de selección de procesos para implementar FSS.  
   Indicar cómo se elige el grupo, cómo se mantiene la variable `pass`, y cómo se realiza la selección de procesos dentro de un grupo.  

4. **Manejo de concurrencia y locks**  
   Describir qué decisiones se tomaron respecto a `ptable.lock` y cómo se asegura consistencia entre CPUs.  

5. **Pruebas realizadas**  
   Explicar cómo se usaron los programas de prueba (`p1_syscalls_test`, `fss_bench`, `grade.sh`) para validar la implementación.  
   Mostrar ejemplos de ejecuciones que demuestren que el reparto de CPU cumple con lo esperado.  

---

El informe no debe ser extenso; basta con **unas pocas páginas** que expliquen las ideas principales y dejen constancia de que el grupo entendió cómo y por qué funciona su implementación.

## Declaración de uso de LLMs

En esta tarea se permite el uso de modelos de lenguaje (LLMs), como ChatGPT, GitHub Copilot, Claude, Gemini, entre otros.  
El uso de estas herramientas debe ser **declarado explícitamente** en el archivo `INFORME.md`, en una sección llamada **Uso de LLMs**.

En dicha sección, el grupo debe indicar:

* **Herramienta utilizada**: nombre y versión aproximada (ejemplo: *ChatGPT GPT-4, GitHub Copilot*).  
* **Propósito del uso**: breve descripción de para qué se utilizó (ejemplo: apoyo conceptual, generación de ejemplos de código, ayuda en redacción del informe, depuración de errores, etc.).  
* **Fragmentos incorporados**: en caso de integrar código sugerido por un LLM, especificar cuáles fragmentos fueron usados y en qué archivo/función se encuentran.

### Restricciones

El uso de LLMs debe guiarse por las siguientes reglas:

1. **Responsabilidad del grupo**  
   Los integrantes siguen siendo plenamente responsables de **entender, justificar y defender** todo el código y documentación entregada, aunque hayan usado un LLM como apoyo.

2. **Uso permitido**  
   - Solicitar explicaciones conceptuales.  
   - Generar ejemplos de código que luego fueron **adaptados y comprendidos**.  
   - Apoyo en redacción de documentación (ejemplo: `INFORME.md`).  

3. **Uso no permitido**  
   - Entregar código generado automáticamente sin comprenderlo ni probarlo.  
   - Modificar el benchmark o los scripts de pruebas para pasar los casos sin implementar realmente el scheduler.  
   - Omitir la declaración de uso.  

4. **Evaluación**  
   Declarar el uso de LLMs de manera transparente **no afecta negativamente la nota**.  
   Por el contrario, si se muestra cómo se adaptó lo generado para alcanzar una solución funcional, esto puede considerarse un aspecto positivo.


