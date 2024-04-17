program P3E1;

Uses sysutils;

var
    emp_num: integer;
    nombres: array[1..10] of String;
    apellidos: array[1..10] of String;

type
    empleado = record
        num, edad: integer;
        dni: String[8];
        nombre, apellido: String[40];
    end;

    archEmpleados = file of empleado;

procedure cargarDatosDeGeneracion();
begin
    emp_num := 1;
    nombres[1] := 'Vicente';
    nombres[2] := 'Martin';
    nombres[3] := 'Felipe';
    nombres[4] := 'Juan';
    nombres[5] := 'Joaquina';
    nombres[6] := 'Marietta';
    nombres[7] := 'Federico';
    nombres[8] := 'Luis';
    nombres[9] := 'Nadia';
    nombres[10] := 'Diana';

    apellidos[1] := 'Garcia';
    apellidos[2] := 'Lopez';
    apellidos[3] := 'Gonzalez';
    apellidos[4] := 'Campitelli';
    apellidos[5] := 'Feijoo';
    apellidos[6] := 'Marti';
    apellidos[7] := 'Perez';
    apellidos[8] := 'Palazzo';
    apellidos[9] := 'Escudero';
    apellidos[10] := 'Barragan';
end;

procedure leerEmpleado(var emp: empleado);
begin
    emp.num := emp_num;
    emp_num := emp_num + 1;
    emp.nombre := nombres[Random(10) + 1];
    emp.apellido := apellidos[Random(10) + 1];
    emp.edad := Random(30) + 18;
    emp.dni := IntToStr(Random(25000000) + 21000000);

    WriteLn('Numero de empleado: ', emp.num);
    WriteLn('Nombre del empleado: ', emp.nombre);
    WriteLn('Apellido del empleado: ', emp.apellido);
    WriteLn('Edad del empleado: ', emp.edad);
    WriteLn('DNI del empleado: ', emp.DNI);
    WriteLn;
end;

procedure imprimirEmpleado(emp: empleado);
begin
    WriteLn(
        'Nombre: ', emp.nombre, 
        ', apellido: ', emp.apellido, 
        ', numero de empleado: ', emp.num, 
        ', edad: ', emp.edad, 
        ', dni: ', emp.dni
    );
end;

procedure crearArchivoDeEmpleados(var arch: archEmpleados);
var
    emp: empleado;
    aux: integer;
begin
    Rewrite(arch);
    Randomize;
    aux := 1;
    repeat
        leerEmpleado(emp);
        write(arch, emp);
        Write('Ingrese 1 para ingresar otro empleado, 0 para terminar: '); ReadLn(aux);
    until aux = 0;
    WriteLn('--- Archivo creado exitosamente! ---');
    close(arch);
end;

procedure filtrarEmpleados(var arch: archEmpleados; opc: byte);
var
    filter: String[40];
    emp: empleado;
begin
    Write('Ingrese el string por el cual filtrar (case sensitive): '); ReadLn(filter);
    Reset(arch);
    WriteLn;
    WriteLn('Empleados: ');
    while (not eof(arch)) do begin
        Read(arch, emp);
        if ((opc = 1) and (emp.nombre = filter)) or ((opc = 2) and (emp.apellido = filter)) then
            imprimirEmpleado(emp)
    end;
    close(arch);
end;

procedure imprimirEmpleados(var arch: archEmpleados);
var
    emp: empleado;
begin
    WriteLn('Empleados: ');
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch, emp);
        imprimirEmpleado(emp)
    end;
    close(arch);
end;

procedure imprimirEmpleadosMayor70(var arch: archEmpleados);
var
    emp: empleado;
begin
    WriteLn('Empleados: ');
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch, emp);
        if (emp.edad > 70) then
            imprimirEmpleado(emp)
    end;
    close(arch);
end;

//Ejercicio 4
procedure anadirEmpleados(var arch: archEmpleados);
var
    emp, other: empleado;
    exists: boolean;
begin
    Reset(arch);
    leerEmpleado(emp);
    while (emp.apellido <> 'fin') do begin
        exists := false;
        
        Seek(arch, 0); // Vuelvo al principio del archivo para ver si el empleado existe
        while (not eof(arch)) and (not exists) do begin
            read(arch, other);
            if (other.num = emp.num) then
                exists := true
        end;

        if (exists) then
            WriteLn('--- ERROR: Ese empleado ya existe! ---')
        else begin
            Seek(arch, fileSize(arch));
            write(arch, emp);
        end;

        leerEmpleado(emp);
    end;
    WriteLn('--- Empleados agregados con exito! ---');
    Close(arch);
end;

procedure modificarEdad(var arch: archEmpleados);
var 
    emp: empleado;
    aux: integer;
    found: boolean;
begin
    Write('Ingrese el numero del empleado que desea modificar: '); ReadLn(aux);
    
    Reset(arch);
    found := false;
    
    while(not eof(arch)) and (not found) do begin
        read(arch, emp);
        if (emp.num = aux) then
            found := true;
    end;

    if (found) then begin
        // Vuelvo a la posicion del registro que acabo de leer
        Seek(arch, filePos(arch) - 1);
        Write('Ingrese la nueva edad del empleado: '); ReadLn(emp.edad);
        Write(arch, emp);
        WriteLn('--- Edad del empleado ', emp.num, ' actualizada con exito! ---');
    end
    else
        WriteLn('--- ERROR: Empleado no encontrado! ---');

    Close(arch);
end;

procedure exportarAtxt(var arch: archEmpleados);
var
    emp: empleado;
    txt: Text;
begin
    Assign(txt, 'temp/todos_empleados.txt');
    Rewrite(txt);
    Reset(arch);

    while (not eof(arch)) do begin
        read(arch, emp);
        WriteLn(txt, emp.num, ' ', emp.nombre, ' ', emp.apellido, ' ', emp.edad, ' ', emp.dni);
    end;
    WriteLn('--- Los datos fueron exportados al archivo "todos_empleados.txt" ---');

    Close(txt);
    Close(arch);
end;

procedure exportarSinDNIAtxt(var arch: archEmpleados);
var
    emp: empleado;
    txt: Text;
begin
    Assign(txt, 'temp/faltaDNIEmpleado.txt');
    Rewrite(txt);
    Reset(arch);

    while (not eof(arch)) do begin
        read(arch, emp);
        if (emp.dni = '00') then
            WriteLn(txt, emp.num, ' ', emp.nombre, ' ', emp.apellido, ' ', emp.edad, ' ', emp.dni);
    end;
    WriteLn('--- Los datos fueron exportados al archivo "faltaDNIEmpleado.txt" ---');
    
    Close(txt);
    Close(arch);
end;

procedure eliminarEmpleado(var arch: archEmpleados);
var
    emp: empleado;
    aux, posFounded, posLast: integer;
    found: boolean;
begin
    Write('Ingrese el numero del empleado que desea eliminar: '); ReadLn(aux);
    
    Reset(arch);
    found := false;
    
    while(not eof(arch)) and (not found) do begin
        read(arch, emp);
        if (emp.num = aux) then
            found := true;
    end;

    if (found) then begin
        // Guardo la posicion del registro encontrado
        posFounded := filePos(arch) - 1;
        posLast := fileSize(arch) - 1;
        // Voy a la posicion del ultimo registro
        Seek(arch, posLast);
        // Leo el ultimo registro
        Read(arch, emp);
        // Voy a la posicion del registro encontrado
        Seek(arch, posFounded);
        // Escribo el ultimo registro en la posicion del registro encontrado
        Write(arch, emp);
        // Voy a la posicion anterior del ultimo registro
        Seek(arch, posLast);
        // Borro el archivo
        Truncate(arch);
        
        WriteLn('--- Empleado ', aux, ' eliminado con exito! ---');
    end
    else
        WriteLn('--- ERROR: Empleado no encontrado! ---');

    Close(arch);
end;

var
    opc: byte;
    fileName: String[40];
    arch: archEmpleados;
begin
    fileName := '';

    cargarDatosDeGeneracion();
    WriteLn('EMPLEADOS');

    repeat
        WriteLn;
        WriteLn('0. Terminar el programa');
        WriteLn('1. Crear un archivo de empleados');
        WriteLn('2. Mostrar empleados por nombre/apellido');
        WriteLn('3. Mostrar todos los empleados');
        WriteLn('4. Mostrar en pantalla los empleados mayores de 70 años');
        WriteLn('5. Añadir empleados a un archivo ya creado');
        WriteLn('6. Modificar la edad de un empleado');
        WriteLn('7. Exportar informacion');
        WriteLn('8. Exportar empleados sin DNI');
        WriteLn('9. Eliminar empleado');

        Write('Ingrese el numero de opcion: '); ReadLn(opc);
        
        if (opc <> 0) and (fileName = '') then begin
            WriteLn;
            Write('Ingrese el nombre del archivo: '); ReadLn(fileName);
            fileName := 'temp/' + fileName;
            Assign(arch, fileName);
        end;

        case opc of 
            1: crearArchivoDeEmpleados(arch);
            2: begin
                WriteLn;
                WriteLn('1. Filtrar por nombre');
                WriteLn('2. Filtrar por apellido');
                write('Ingrese el numero de opcion: '); ReadLn(opc);
                filtrarEmpleados(arch, opc);
            end;
            3: imprimirEmpleados(arch);
            4: imprimirEmpleadosMayor70(arch);
            // Ejercicio 4
            5: anadirEmpleados(arch);
            6: modificarEdad(arch);
            7: exportarAtxt(arch);
            8: exportarSinDNIAtxt(arch);
            9: eliminarEmpleado(arch);
        end;
    until(opc = 0);
end.