{Realizar un programa que presente un menú con opciones para:
    a. Crear un archivo de registros no ordenados de empleados y completarlo con
    datos ingresados desde teclado. De cada empleado se registra: número de
    empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
    DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
    
    b. Abrir el archivo anteriormente generado y
        i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
        determinado, el cual se proporciona desde el teclado.
        ii. Listar en pantalla los empleados de a uno por línea.
        iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
    
    c. Añadir uno o más empleados al final del archivo con sus datos ingresados por
    teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
    un número de empleado ya registrado (control de unicidad).
    
    d. Modificar la edad de un empleado dado.
    
    e. Exportar el contenido del archivo a un archivo de texto llamado
    “todos_empleados.txt”.
    
    f. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
    que no tengan cargado el DNI (DNI en 00).
NOTA 1: Las búsquedas deben realizarse por número de empleado.
NOTA 2: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario}

program P1E3;

type
    empleado = record
        num, edad: integer;
        dni: String[8];
        nombre, apellido: String[40];
    end;

    archEmpleados = file of empleado;

procedure leerEmpleado(var emp: empleado);
begin
    write('Ingrese numero de empleado: '); ReadLn(emp.num);
    write('Ingrese nombre: '); ReadLn(emp.nombre);
    write('Ingrese Apellido (fin para terminar): '); ReadLn(emp.apellido);
    write('Ingrese edad: '); ReadLn(emp.edad);
    write('Ingrese DNI: '); ReadLn(emp.dni);
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
begin
    Rewrite(arch);
    leerEmpleado(emp);
    while (emp.apellido <> 'fin') do begin
        write(arch, emp);
        leerEmpleado(emp);
    end;
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

var
    opc: byte;
    fileName: String[40];
    arch: archEmpleados;
begin
    fileName := '';

    WriteLn('EMPLEADOS');

    repeat
        WriteLn;
        WriteLn('0. Terminar el programa');
        WriteLn('1. Crear un archivo de empleados');
        WriteLn('2. Mostrar empleados por nombre/apellido');
        WriteLn('3. Mostrar todos los empleados');
        WriteLn('4. Mostrar en pantalla los empleados mayores de 70 años');
        // Ejercicio 4
        WriteLn('5. Añadir empleados a un archivo ya creado');
        WriteLn('6. Modificar la edad de un empleado');
        WriteLn('7. Exportar informacion');
        WriteLn('8. Exportar empleados sin DNI');

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
        end;
    until(opc = 0);
end.