program P1E7;

type
    novela = record
        codigo: integer;
        precio: real;
        genero: String[20];
        titulo: String[50];
    end;

    arch_novelas = file of novela;

procedure crearArchivo(var arch: arch_novelas);
var
    txt: Text;
    nov: novela;
begin
    Assign(txt, 'temp/novelas.txt');
    Reset(txt);
    Rewrite(arch);

    while (not eof(txt)) do begin
        ReadLn(txt, nov.codigo, nov.precio, nov.genero);
        ReadLn(txt, nov.titulo);
        Write(arch, nov);
    end;

    close(txt);
    close(arch);
end;

procedure leerNovela(var nov: novela);
begin
    Write('Ingrese el codigo de novela (-1 para terminar): '); ReadLn(nov.codigo);
    if (nov.codigo <> -1) then begin
        Write('Ingrese el titulo: '); ReadLn(nov.titulo);
        Write('Ingrese el genero: '); ReadLn(nov.genero);
        Write('Ingrese el precio: '); ReadLn(nov.precio);
    end;
end;

procedure agregarNovelasTeclado(var arch: arch_novelas);
var
    nov: novela;
begin
    Reset(arch);
    Seek(arch, fileSize(arch));
    
    leerNovela(nov);
    while (nov.codigo <> -1) do begin
        Write(arch, nov);
        leerNovela(nov);
    end;

    WriteLn('--- Novelas agregadas con exito! ---');

    close(arch);
end;

procedure agregarNovelasTxt(var arch: arch_novelas);
var
    nov: novela;
    txt: text;
    nom_txt: String[20];
begin
    Write('Ingrese el nombre del archivo de texto del cual leer las novelas: '); ReadLn(nom_txt);
    Assign(txt, nom_txt);
    Reset(txt);
    Reset(arch);
    Seek(arch, fileSize(arch));

    while (not eof(txt)) do begin
        ReadLn(txt, nov.codigo, nov.precio, nov.genero);
        ReadLn(txt, nov.titulo);
        Write(arch, nov);
    end;

    close(txt);
    close(arch);
end;

procedure editarNovela(var arch: arch_novelas; opc: byte);
var
    nov: novela;
    cod: integer;
    found: boolean;
begin
    Write('Ingrese el codigo de la novela que desea modificar: '); ReadLn(cod);
    Reset(arch);

    found := false;
    while (not eof(arch)) and (not found) do begin
        Read(arch, nov);
        if (nov.codigo = cod) then
            found := true;
    end;

    if (found) then begin
        case opc of
            1: begin
                Write('Ingrese el nuevo titulo: '); ReadLn(nov.titulo);
            end;
            2: begin
                Write('Ingrese el nuevo precio: '); ReadLn(nov.precio);
            end;
            3: begin
                Write('Ingrese el nuevo genero: '); ReadLn(nov.genero);
            end;
        end;

        Seek(arch, filePos(arch) - 1);
        Write(arch, nov);
        WriteLn('--- Novela ', nov.titulo, ' actualizada con exito! ---');
    end
    else
        WriteLn('--- ERROR: No se ha encontrado la novela! ---');
    
    close(arch);
end;

procedure exportarInformacion(var arch: arch_novelas);
var
    txt: text;
    nov: novela;
begin
    Assign(txt, 'temp/novelas_exp.txt');
    Rewrite(txt);
    Reset(arch);

    while (not eof(arch)) do begin
        Read(arch, nov);
        WriteLn(txt, nov.codigo, ' ', nov.titulo, ' ', nov.genero, ' ', nov.precio:2:2);
    end;
    WriteLn('--- Los datos fueron exportados al archivo "novelas_exp.txt" ---');

    Close(arch);
    Close(txt);
end;

var
    opc: byte;
    arch: arch_novelas;
    fileName: String[20];
begin
    fileName := '';
    WriteLn('NOVELAS');
    
    repeat
        WriteLn;
        WriteLn('0. Terminar el programa');
        WriteLn('1. Crear archivo binario a partir de archivo de texto');
        WriteLn('2. Agregar novelas por teclado');
        WriteLn('3. Agregar novelas desde un archivo de texto');
        WriteLn('4. Modificar novela');
        WriteLn('5. Exportar informacion'); // debug
        Write('Ingrese el numero de opcion: '); ReadLn(opc);
        WriteLn;

        if (opc <> 0) and (fileName = '') then begin
            Write('Ingrese el nombre del archivo: '); ReadLn(fileName);
            fileName := 'temp/' + fileName;
            Assign(arch, fileName);
        end;

        case opc of
            1: crearArchivo(arch);
            2: agregarNovelasTeclado(arch);
            3: agregarNovelasTxt(arch);
            4: begin
                WriteLn('0. Retroceder');
                WriteLn('1. Editar Titulo');
                WriteLn('2. Editar Precio');
                WriteLn('3. Editar genero');
                Write('Ingrese el numero de opcion: '); ReadLn(opc);

                if (opc <> 0) then
                    editarNovela(arch, opc);
            end;
            5: exportarInformacion(arch);
        end;
    until (opc = 0);
end.