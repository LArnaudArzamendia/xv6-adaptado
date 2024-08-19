# Tarea 1 - Llamadas al sistema e implementación de una shell

Para comprender con mayor claridad cómo funciona un sistema operativo, en la primera parte de este curso trabajarás con un kernel real. El kernel es una adaptación del de Unix versión 6 (1975), llamada xv6, que puede ejecutar en hardware x86 moderno, pues Unix versión 6 corría en un computador [PDP-11](https://en.wikipedia.org/wiki/PDP-11) en 1975. Dado que la gran parte de Unix fue escrita en el lenguaje de programación C, fue portado a lo largo de su historia a muchas arquitecturas, y ello es lo que permite que podamos trabajar con el en esta tarea.

La primera parte de esta tarea consiste en implementar una llamada al sistema bastante sencilla, lo cual te permitirá familiarizarte con programación y depuración de kernel ("_kernel hacking_"), y conocer la forma cómo son implementadas las llamadas y el comportamiento del sistema operativo para responder a ellas.

En la segunda parte de la tarea, implementarás un intérprete de comandos (shell) para xv6 utilizando llamadas al sistema típicas de Unix.

## Modalidad de trabajo

Esta tarea deberá ser resuelta en parejas. La totalidad del trabajo debe realizarse en el repositorio clonado después de aceptar la invitación en GitHub classroom. Para la entrega, se considerará la última revisión en el repositorio anterior a la fecha y hora de entrega. Para las partes 1 y 2 de la tarea las fechas de entrega son las siguientes:

* Primera parte (30% de la nota): 29 de agosto, 23:59 hrs.
* Segunda parte (70% de la nota): 12 de septiembre, 23:59 hrs.

# Primera Parte: Llamada **getreadcount()** (30% de la nota final)

La primera parte de esta tarea consiste en agregar una llamada de sistema al kernel de xv6, de nombre `getreadcount()`. Esta llamada retorna cuántas veces la llamada al sistema `read()` ha sido invocada por procesos de usuario desde el momento en que el kernel ha sido iniciado.

La nueva llamada al sistema debe tener la siguiente firma:

```c
int getreadcount(void)
```

El valor de retorno es el de un contador que debe implementarse internamente en el kernel, el cual debe ser incrementado cada vez que un proceso llama a
`read()`.

## Sincronización

Hemos visto en clases el problema de sincronización que ocurre cuando existen múltiples procesos concurrentes accediendo un recurso compartido. En nuestro caso, el recurso compartido es un contador de llamadas a `read()` que existe en espacio de kernel. Este problema, conocido como "condición de carrera" o _race condition_ lo vimos en la clase 1, en donde mostrábamos dos threads en un proceso de usuario que incrementaban un contador compartido, y los resultados erróneos que se obtenían cuando no había sincronización entre threads (ver AD:2.3).

Para implementar correctamente `getreadcount()`, el acceso al contador - tanto para lecturas como escrituras - tiene que ser sincronizado; para esto, una condición necesaria es que exista _exclusión mutua_ para acceder al contador. Es decir, se debe asegurar que a lo sumo un proceso a la vez (rutina de servicio de interrupción en el kernel) pueda leer o escribir al contador.

Para implementar el contador sincronizado, deberás inicializar y usar un _spinlock_ en el kernel. De lo contrario, las cuentas informadas por la llamada podrían ser inconsistentes. 

En `proc.c` existe una estructura que contiene la tabla de procesos del sistema, llamada `ptable`, y uno de los miembros de esta estructura es un spinlock. La inicialización se hace en la función `pinit` en `proc.c`. Busca todas las ocurrencias de `ptable.lock` en `proc.c` y podrás ver cómo dicho spinlock es utilizado. NO USES `ptable.lock` para sincronizar el acceso al contador, CREA UN NUEVO SPINLOCK PARA ESTO. La implementación de spinlocks la encuentras en `spinlock.{c,h}`. Para adquirir un spinlock usas la operación `acquire`, y para liberarlo `release`. Ambas operaciones requieren un puntero al spinlock.

## Consejos

Puedes revisar un playlist de YouTube con [vídeos](https://youtube.com/playlist?list=PL3yryPU8iwGO2IsoEa_F8_zIytuHIHV37) que explican todo lo necesario para comenzar comenzar tu _kernel hacking_ después de clonar el repositorio con el código base de la tarea. Son tres vídeos en el playlist y el último sobre planificación de procesos y sincronización es útil que lo veas, incluso sin haber visto aún la materia en clases.

Una manera de comenzar a hackear un base de código relativamente grande como la de xv6 es buscar partes similares a lo que requieres hacer, y luego copiar y modificar éstas. Podrías buscar otra llamada al sistema, como `getpid()` u otra llamada sencilla. Luego, la copias en la forma que consideres útil, y la modificas para que se ajuste a los requisitos de la tarea.

La mayor parte del tiempo la dedicarás a entender el código. No es mucho el código que deberás implementar en la tarea.

Puedes usar el debugger gdb para trazar la ejecución del código del kernel. Para ello, recuerda compilar xv6 con el comando `make qemu-gdb`. Esto compilará y ejecutará xv6, y te permitirá depurarlo utilizando gdb remoto, desde otro terminal. Para ejecutar gdb, simplemente ingresas el comando `gdb kernel` en el directorio en donde se encuentre el código fuente de xv6.

## Compilación, Ejecución y Depuración

Primero debemos estar seguros de que el set de herramientas de compilación necesario está instalado y operativo en nuestro ambiente de desarrollo. Para compilar xv6 y los programas de usuario, es necesario contar con un compilador GCC que genere binarios ejecutables para arquitectura Intel i386 de 32 bits, y en formato Executable and Linkable Format (ELF). Este formato es el nativo utilizado por Linux, entonces, si compilas en Linux (o Windows con WSL) normalmente no necesitarás instalar nada aparte.  

**Instrucciones específicas para compilar en Linux**

Para compilar en Linux, asegúrate de contar con GCC operativo. Respecto al código de xv6, asegúrate de que las líneas 37 y 38 del `Makefile` en el directorio raíz de este repositorio estén comentadas, y la línea 40 esté descomentada y se vea así:

```Makefile
TOOLPREFIX = 
```

En Linux se usa el GCC nativo instalado y por ello se deja el prefijo de herramientas GCC en blanco.

**Instrucciones específicas para compilar en macOS**

Si usas un Mac, con procesador Intel o ARM, tendrás que instalar una versión de GCC que genere binarios Intel de 32 bits en formato ELF.

Si usas Mac, debes tener homebrew instalado. Luego, instalas GCC para i386-elf, con los siguientes comandos:

```sh
brew tap nativeos/i386-elf-toolchain
brew install nativeos/i386-elf-toolchain/i386-elf-binutils
brew install nativeos/i386-elf-toolchain/i386-elf-gcc
```

Luego, debes ir al `Makefile` en la raíz de este repositorio y descomentar la línea 37, que dice:

```Makefile
TOOLPREFIX = i386-elf-
```

Esto activará la variable `TOOLPREFIX` con el prefijo `i386-elf` para gcc y binutils, programas que se requieren para compilar correctamente xv6. Si no usas Mac, asegúrate de que dicha línea está comentada. 

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

## Test Automatizado

Contamos con un tester automatizado para probar la implementación de `getreadcount()` Para obtenerlo debes clonar [este repositorio](https://github.com/icc3201-202420/icc3201-syscalls_tester.git) en el **directorio padre de donde has clonado el código base de tarea**. Es decir, el repositorio con casos de prueba debe quedar en un directorio hermano en jerarquía al código de la tarea.

Para ejecutar un test que permite probar `getreadcount()` en forma automatizada, ingresa el siguiente comando en el directorio en donde has clonado el repositorio de xv6:

```sh
prompt> ./test-getreadcounts.sh 
```

Si implementaste todo correctamente, debieras ver un resultado diciendo que tu kernel ha pasado las pruebas. En caso contrario, podría haber algo incorrecto, por ejemplo, la sincronización para acceder al contador. Puedes ver los resultados de las pruebas en el directorio `tests-out` (en archivos `.out` y `.err`).

El script de pruebas hace una compilación completa del código fuente de xv6 usando un makefile llamado `Makefile.test`, el cual es una variante autogenerada del `Makefile` original que incluye tests que son copiados al directorio `user` de xv6. Es posible correr tests directamente desde el shell de xv6 compilando el código con: 

```sh
prompt> cd src/ prompt> make -f Makefile.test qemu-nox
```

Puedes suprimir la recompilación de xv6 en las pruebas usando el flag `-s`. Esto te debiera permitir realizar pruebas más rápidamente.

```sh
prompt> ./test-getreadcounts.sh -s
```

Hay otros flags para pruebas disponibles en la [documentación](https://github.com/remzi-arpacidusseau/ostep-projects/blob/master/tester/README.md).

# Segunda Parte: Intérprete de comandos (Shell) (70% de la nota final)

Ahora, tu tarea es crear una shell de Unix sencilla. Una shell es un programa esencial para contar con una interfaz de línea de comandos, y es central para cualquier ambiente de programación con Unix y C. Saber cómo usar una shell es importante para cualquier usuario de este tipo de ambiente, pero en nuestro caso, iremos más allá, enfocándonos en entender cómo implementar una shell.

Los objetivos específicos de esta tarea son los siguientes:

* Continuar familiarizándote con programación en ambiente Unix/Linux.
* Aprender cómo crear, destruir y administrar procesos.
* Entender cómo funciona una shell.

## Interacción básica con una shell

La manera de operación básica de una shell es la siguiente: la shell comienza presentando al usuario un símbolo o _prompt_ (generalmente `$` en Unix), y el usuario tipea un comando. Si el comando es válido, entonces la shell crea un proceso hijo que ejecuta el comando y al terminar el proceso, vuelve a aparecer el símbolo esperando mayor input del usuario. Si el comando no es válido, entonces la shell muestra un mensaje de error, p.ej., "_command not found_", y vuelve a aparecer el símbolo.

La operación descrita arriba corresponde al modo interactivo de una shell, y es implementado mediante un ciclo que sólo termina cuando el usuario introduce el comando `exit`. Una shell también puede operar en modo _batch_ ("por lotes") recibiendo un archivo como parámetro desde la línea de comandos. En esta tarea, sólo implementarás el modo interactivo en la shell, sin modo batch. 

## Funciones de la shell a implementar

La shell implementarás debe incorporar las siguientes funcionalidades:

1. Comando `echo`: El comando `echo` recibe argumentos por la línea de comando y los imprime en la salida. Ejemplo:
```sh
$ echo esta shell es muy simple
esta shell es muy simple 
```
2. Lista de comandos: Una shell puede recibir una lista de varios comandos separados por `;`. Con esto, los comandos son ejecutados en forma consecutiva. Ejemplo:
```sh
$ echo 1; echo 2; echo 3
1
2
3
```
3. Comandos en paralelo: La shell puede recibir varios comandos separados por & y esto los ejecuta en paralelo. Es decir, por cada comando la shell lanza un proceso hijo y desde cada proceso hijo se ejecuta uno de los comandos.
4. Redirección de salida a archivo: La salida de un comando puede ser redirigida a un archivo en vez de la salida estándar. Para esto, se añade el operador `>` al comando, seguido por el archivo de salida. Ejemplo:
```sh
$ echo "esta es una prueba de redireccion" > salida.txt
$ cat salida.txt # muestra el texto pasado como argumento a echo
```
5. Redirección de la entrada desde archivo: La entrada de un comando puede ser redirigida desde un archivo en vez de la entrada estándar. Para esto, se añade el operador `<` al comando, seguido por el archivo de entrada. Ejemplo:
```sh
$ wc < README
50 329 2286
```
Cabe notar que el comando `wc` (cuenta palabras, líneas, caracteres y bytes; ver `man wc` para detalles sobre funcionamiento) tendría el mismo resultado omitiendo la redirección y pasando directamente el nombre de archivo de entrada como argumento:
```sh
$ wc README
50 329 2286
```
6. Uso de _pipes_: El uso de pipes en la consola permite que la _salida_ del proceso iniciado por el comando a la izquierda del pipe pueda ser utilizada como _entrada_ del proceso iniciado por el comando a la derecha. Ejemplo: 
```sh
$ ls | wc
21 84 520
```

## Detalles sobre la Implementación

El sistema operativo que utilizarás en esta tarea, xv6, tiene un programa shell cuyo código puedes encontrar en `user/sh.c`. Obviamente, no es la idea de esta tarea que copies la implementación de aquel programa de consola. De hecho, el programa shell que se te pide implementar es más simple. De todos modos, es útil que estudies el código fuente en `sh.c` para entender cómo implementar cuestiones como ejecución paralela de comandos, redirección y pipes. La implementación de tu shell la debes hacer en `user/nsh.c`.

En el libro AD, [sección 5.4](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-api.pdf) aparece explicado cómo funciona la redirección de E/S en Unix y cómo puede utilizarse en implementar un programa de shell.

Dado que en xv6 no hay una biblioteca estándar de C completa, tendrás ciertas limitaciones para implementar, por ejemplo, el procesamiento del input de comandos, pues no podrás disponer de funciones como `getline`. En `user/user.h` podrás ver aparte de system calls, algunas funciones que son típicamente parte de la biblioteca estándar de C, implementadas en `user/ulib.c`. La función `gets` permite leer una línea desde la entrada estándar. Además, puedes encontrar implementación de funciones de procesamiento de input en ejemplos del libro blanco de Kernighan y Ritchie ("The C Programming Language"). Alguien ha publicado [todos los ejemplos del libro resueltos en GitHub](https://github.com/ptdecker/cbasics), incluyendo del capítulo 5, en donde se pueden encontrar varios ejercicios de procesamiento de input de texto, e incluso reimplementación de funciones de procesamiento de strings que hay en la biblioteca estándar de C.

Debes utilizar las _system calls_ estándar de Unix, como `fork`, `exec`, `wait`, `open`, `close` y `pipe` para implementar las funcionalidades de la shell.

Es recomendable que primero utilices arreglos estáticos (no usar `malloc`) para leer input desde la línea de comandos, fijando un tamaño límite de línea (p.ej., 100 caracteres), debido a la dificultad que puede surgir al depurar la correcta liberación de la memoria y dereferenciación de punteros. Una vez que estés seguro(a) de que el funcionamiento de tu programa es correcto, puedes comenzar a incorporar arreglos dinámicamente asignados con `malloc`.

## Casos de prueba (75% de segunda parte)

Tu programa shell será probado mediante varios casos de prueba (se indica puntaje de cada caso de prueba entre corchetes):

1. [.5] Un comando echo, p.ej., `echo hello goodbye`.
2. [.5] Ejecución del comando grep, p.ej., `grep constitute README`.
3. [.5] Ejecución de un comando, seguido de otro en dos líneas de input consecutivas.
4. [1.0] Redirección de la salida, p.ej., `echo xxxx > file`.
5. [1.0] Redirección de la entrada, p.ej., `cat < file`.
6. [.5] Redirección simultánea de entrada y salida, p.ej., `grep pointers < README > testsh.out`.
7. [1.0] Prueba de pipes, p.ej., `cat filename | cat`
8. [.5] Prueba de pipes y redirección, p.ej.,  `grep suggestions < README | wc > testsh.out`
9. [.5] Ejecución de muchos comandos para verificar que descriptores de archivo se cierran correctamente.

El programa `user/testsh.c` permite realizar todas las pruebas anteriores. Es invocable en xv6 de la siguiente manera:

```sh
./testsh nsh
```

No es necesario que implementes funcionalidad más allá de los ejemplos listados arriba. Es decir, no habrá líneas de comando con más de un pipe, ni comandos con paréntesis, ni uso del comando `cd`. El directorio de trabajo de la shell será el directorio raíz del sistema de archivos de xv6 y no se podrá cambiar.

## Informe de Segunda Parte (25% de segunda parte)

La segunda parte de la tarea requiere un informe, con el siguiente formato:

* Archivo INFORME.md en el directorio raíz del código fuente de xv6. Al inicio, el archivo debe contener los nombres de los integrantes del grupo.
* Debe contener las siguientes secciones: "Procesamiento de input", "Redirección de entrada y salida", "Pipes". Cada sección debe explicar cómo se implementó cada una de dichas funcionalidades, con referencias al código fuente, indicando números de línea. Se puede usar el [formato markdown de GitHub en que se encuentra escrito este mismo archivo](https://guides.github.com/features/mastering-markdown/) para mostrar ejemplos de código, etc.




