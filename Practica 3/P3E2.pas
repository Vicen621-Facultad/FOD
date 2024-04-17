program P3E2;

uses sysutils;

var
    asis_num: integer;
    nombres: array[1..10] of String;
    apellidos: array[1..10] of String;

const
    MARCA_BORRADO = '@';

type
    asistente = record
        num, dni: integer;
        nombre, apellido, email, telefono: String[40];
    end;

    archAsistentes = file of asistente;

procedure leerAsistente(var asis: asistente);
begin
    asis.num := asis_num;
    asis_num := asis_num + 1;
    asis.nombre := nombres[Random(10) + 1];
    asis.apellido := apellidos[Random(10) + 1];
    asis.email := asis.nombre + asis.apellido + '@gmail.com';
    asis.dni := Random(25000000) + 21000000;
    asis.telefono := '221 ' + IntToStr(Random(999999) + 1000000);

    WriteLn('Numero de asistente: ', asis.num);
    WriteLn('Nombre del asistente: ', asis.nombre);
    WriteLn('Apellido del asistente: ', asis.apellido);
    WriteLn('Email del asistente: ', asis.email);
    WriteLn('DNI del asistente: ', asis.DNI);
    WriteLn;
end;

procedure cargarDatosDeGeneracion();
begin
    asis_num := 980;
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

procedure crearArchivo(var arch: archAsistentes);
var
    asis: asistente;
    aux: integer;
begin
    Rewrite(arch);
    Randomize;
    aux := 1;
    repeat
        leerAsistente(asis);
        write(arch, asis);
        Write('Ingrese 1 para ingresar otro empleado, 0 para terminar: '); ReadLn(aux);
    until aux = 0;
    WriteLn('--- Archivo creado exitosamente! ---');
    close(arch);
end;

procedure eliminarMenor1000(var arch: archAsistentes);
var
    asis: asistente;
begin
    Reset(arch);

    while (not eof(arch)) do begin
        Read(arch, asis);
        if (asis.num < 1000) then
            asis.nombre := MARCA_BORRADO + asis.nombre;
        Seek(arch, filePos(arch) - 1);
        Write(arch, asis);
    end;

    Close(arch);
end;

procedure exportarAtxt(var arch: archAsistentes);
var
    asis: asistente;
    txt: Text;
begin
    Assign(txt, 'temp/todos_asistentes.txt');
    Rewrite(txt);
    Reset(arch);

    WriteLn(txt, 'nro | nombre | apellido | dni | email | telefono');
    while (not eof(arch)) do begin
        read(arch, asis);
        WriteLn(txt, asis.num, ' | ', asis.nombre, ' | ', asis.apellido, ' | ', asis.dni, ' | ', asis.email, ' | ', asis.telefono);
    end;
    WriteLn('--- Los datos fueron exportados al archivo "todos_asistentes.txt" ---');

    Close(txt);
    Close(arch);
end;

var
    opc: byte;
    fileName: String[40];
    arch: archAsistentes;
begin
    fileName := '';

    cargarDatosDeGeneracion();
    WriteLn('ASISTENTES');

    repeat
        WriteLn('0. Terminar el programa.');
        WriteLn('1. Generar archivo.');
        WriteLn('2. Eliminar asistentes con nro < 1000.');
        WriteLn('3. Exportar datos.');

        Write('Ingrese el numero de opcion deseado: '); ReadLn(opc);
        
        if (opc <> 0) and (fileName = '') then begin
            WriteLn;
            Write('Ingrese el nombre del archivo: '); ReadLn(fileName);
            fileName := 'temp/' + fileName;
            Assign(arch, fileName);
        end;

        case opc of 
            1: crearArchivo(arch);
            2: eliminarMenor1000(arch);
            3: exportarAtxt(arch);
        end;
    until opc = 0;
end.