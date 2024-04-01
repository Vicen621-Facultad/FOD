{Realizar un algoritmo que cree un archivo de números enteros no ordenados y 
permita incorporar datos al archivo. Los números son ingresados desde teclado. 
La carga finaliza cuando se ingresa el número 30000, que no debe incorporarse al archivo. 
El nombre del archivo debe ser proporcionado por el usuario desde teclado.

Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el ejercicio 1, 
informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados. 
El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. 
Además, el algoritmo deberá listar el contenido del archivo en pantalla.}

program P1E1;

type
    archivo = file of integer;

procedure crearArchivo();
var
    arch: archivo;
    i: integer;
    nombre_fisico: string[20];
begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre_fisico); {Leo el nombre del archivo}

    assign(arch, nombre_fisico); {Enlazo el archivo con su nombre}
    Rewrite(arch); {Creo el archivo}

    write('Ingrese un numero, o 30000 para terminar el programa: ');
    readln(i); {leo i}
    while (i <> 30000) do begin {Mientras i != 30000}
        write(arch, i); {Escribo i en el archivo}

        write('Ingrese un numero, o 30000 para terminar el programa: ');
        readln(i); {leo i}
    end;
    close(arch) {Cierro el archivo}
end;

{Recibe un archivo e imprime sus contenidos en pantalla}
procedure listarArchivo(var arch: archivo);
var
    i: integer;
begin
    {Abro el archivo}
    reset(arch);

    writeln('------------------------');
    writeln('Contendios del archivo: ');
    {Mientras no llegue al final del archivo leo y escribo en pantalla}
    while (not EOF(arch)) do begin
        read(arch, i);
        writeln(i);
    end;
    writeln('------------------------');

    {Cierro el archivo}
    close(arch);
end;

{Recibe un archivo e imprime cuantos numeros son menores a 1500}
procedure menoresA1500Archivo(var arch: archivo);
var
    cant, act: integer;
begin
    {Abro el archivo}
    reset(arch);

    cant := 0; {Inicializo cant}
    {Mientras no llegue al final del archivo}
    while (not EOF(arch)) do begin
        {Leo el numero actual}
        read(arch, act);
        if (act < 1500) then
            cant := cant + 1; {Sumo 1 a cant si act < 1500}
    end;
    writeln('La cantidad de numeros menores a 1500 son: ', cant);

    close(arch);
end;

{Recibe un archivo e imprime el promedio de todos los numeros}
procedure promedioArchivo(var arch: archivo);
var
    total, act: integer;
    promedio: real;
begin
    {Abro el archivo}
    reset(arch);
    
    {Inicializo variables}
    total := 0;

    {Mientras no llegue al final del archivo}
    while (not EOF(arch)) do begin
        read(arch, act); {Leo el siguiente numero}
        total := total + act; {Lo sumo al total}
    end;
    {Divido el total por la cantidad de datos que tiene el archivo para obtener el promedio}
    promedio := total / fileSize(arch);
    writeln('El promedio del archivo es: ', promedio:2:2);

    {Cierro el archivo}
    close(arch);
end;

procedure leerArchivo();
var
    arch: archivo;
    nombre_fisico: string;
begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre_fisico); {Leo el nombre del archivo}

    assign(arch, nombre_fisico); {Asigno el archivo a la variable}
    menoresA1500Archivo(arch);
    promedioArchivo(arch);
    listarArchivo(arch);
end;

begin
    crearArchivo();
    leerArchivo();
end.