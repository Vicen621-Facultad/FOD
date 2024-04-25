{Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
    a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
    ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
    correspondientes a los celulares deben contener: código de celular, nombre,
    descripción, marca, precio, stock mínimo y stock disponible.
    
    b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
    stock mínimo.
    
    c. Listar en pantalla los celulares del archivo cuya descripción contenga una
    cadena de caracteres proporcionada por el usuario.
    
    d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
    “celulares.txt” con todos los celulares del mismo. El archivo de texto generado
    podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
    debería respetar el formato dado para este tipo de archivos en la NOTA 3.
    
    e. Añadir uno o más celulares al final del archivo con sus datos ingresados por
    teclado.
    
    f. Modificar el stock de un celular dado.
    
    g. Exportar el contenido del archivo binario a un archivo de texto denominado:
    ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: Las búsquedas deben realizarse por nombre de celular.
NOTA 3: El archivo de carga debe editarse de manera que cada celular se especifique en
        tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
        marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
        nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
        “celulares.txt”.}
program P1E5;

type
    celular = record
        cod, stock_min, stock_disp: integer;
        precio: real;
        nombre, descripcion, marca: String[40];
    end;

    arch_celulares = file of celular;

procedure leerCelular(var cel: celular);
begin
    Write('Ingrese el codigo del celular (-1 para terminar): '); ReadLn(cel.cod);
    if (cel.cod <> -1) then begin
        Write('Ingrese el nombre: '); ReadLn(cel.nombre);
        Write('Ingrese la marca: '); ReadLn(cel.marca);
        Write('Ingrese la descripcion: '); ReadLn(cel.descripcion);
        Write('Ingrese el precio: '); ReadLn(cel.precio);
        Write('Ingrese el stock minimo: '); ReadLn(cel.stock_min);
        Write('Ingrese el stock actual: '); ReadLn(cel.stock_disp);
    end;
end;

procedure imprimirCelular(cel: celular);
begin
    WriteLn(
        'Codigo: ', cel.cod,
        ', nombre: ', cel.nombre, 
        ', marca: ', cel.marca, 
        ', descripcion: ', cel.descripcion, 
        ', precio: ', cel.precio:2:2, 
        ', stock minimio: ', cel.stock_min,
        ', stock disponible: ', cel.stock_disp
    );
end;

procedure crearArchivo(var arch: arch_celulares);
var
    txt: Text;
    cel: celular;
begin
    Assign(txt, 'temp/celulares.txt');
    Reset(txt);
    Rewrite(arch);

    while (not eof(txt)) do begin
        ReadLn(txt, cel.cod, cel.precio, cel.marca);
        ReadLn(txt, cel.stock_disp, cel.stock_min, cel.descripcion);
        ReadLn(txt, cel.nombre);

        Write(arch, cel);
    end;

    WriteLn('--- Archivo de celulares creado exitosamente! ---');
    Close(txt);
    Close(arch);
end;

procedure mostrarMenorQueStockMin(var arch: arch_celulares);
var
    cel: celular;
begin
    Reset(arch);
    
    while (not eof(arch)) do begin
        Read(arch, cel);
        if (cel.stock_disp < cel.stock_min) then
            imprimirCelular(cel);
    end;

    close(arch);
end;

procedure substringDescripcion(var arch: arch_celulares);
var
    substring: String[40];
    cel: celular;
begin
    Write('Ingrese el string a buscar: '); ReadLn(substring);
    Reset(arch);

    while (not eof(arch)) do begin
        Read(arch, cel);
        if (pos(substring, cel.descripcion) <> 0) then
            imprimirCelular(cel);
    end;

    Close(arch);
end;

procedure exportarInformacion(var arch: arch_celulares);
var
    txt: text;
    cel: celular;
begin
    Assign(txt, 'temp/celulares.txt');
    Rewrite(txt);
    Reset(arch);

    while (not eof(arch)) do begin
        Read(arch, cel);
        WriteLn(txt, cel.cod, ' ', cel.precio, ' ', cel.marca);
        WriteLn(txt, cel.stock_disp, ' ', cel.stock_min, ' ', cel.descripcion);
        WriteLn(txt, cel.nombre);
    end;
    WriteLn('--- Los datos fueron exportados al archivo "celulares.txt" ---');

    Close(arch);
    Close(txt);
end;

procedure anadirCelulares(var arch: arch_celulares);
var
    cel: celular;
begin
    Reset(arch);
    Seek(arch, fileSize(arch));

    leerCelular(cel);
    while (cel.cod <> -1) do begin
        Write(arch, cel);
        leerCelular(cel);
    end;

    WriteLn('--- Celulares agregados con exitos al archivo! ---');
    Close(arch);
end;

procedure modificarStock(var arch: arch_celulares);
var
    cel: celular;
    nom: String[40];
    found: boolean;
begin
    Reset(arch);
    Write('Ingrese el nombre del telefono que quiere modificar: '); ReadLn(nom);

    found := false;
    while (not eof(arch)) and (not found) do begin
        Read(arch, cel);
        // Busco por medios matches
        if (pos(nom, cel.nombre) <> 0) then
            found := true;
    end;

    if (found) then begin
        Seek(arch, filePos(arch) - 1);
        Write('Ingrese el stock actualizado: '); ReadLn(cel.stock_disp);
        Write(arch, cel);
        WriteLn('--- Stock del telefono ', cel.nombre, ' actualizado con exito! ---');
    end
    else
        WriteLn('--- ERROR: Celular no encontrado! ---');

    Close(arch);
end;

procedure exportarSinStock(var arch: arch_celulares);
var
    txt: Text;
    cel: celular;
begin
    Assign(txt, 'temp/SinStock.txt');
    Rewrite(txt);
    Reset(arch);

    while (not eof(arch)) do begin
        Read(arch, cel);
        if (cel.stock_disp = 0) then
            WriteLn(txt, cel.cod, ' ', cel.nombre, ' ', cel.marca, ' ', cel.descripcion, ' ', cel.precio, ' ', cel.stock_min, ' ', cel.stock_disp);
    end;

    WriteLn('--- Los datos fueron exportados al archivo "SinStock.txt" ---');

    Close(arch);
    Close(txt);
end;

var
    opc: byte;
    arch: arch_celulares;
    fileName: String[40];
begin
    fileName := '';
    WriteLn('CELULARES');

    repeat
        WriteLn;
        WriteLn('0. Terminar el programa');
        WriteLn('1. Importar informacion desde archivo de texto');
        WriteLn('2. Mostrar celulares con stock menor al minimo');
        WriteLn('3. Buscar celular por descripcion');
        WriteLn('4. Exportar informacion a archivo de texto');
        // Ejercicio 6
        WriteLn('5. Añadir celulares');
        WriteLn('6. Modificar stock de un celular');
        WriteLn('7. Exportar celulares sin stock');

        Write('Ingrese la opcion deseada: '); ReadLn(opc);
        WriteLn;

        if (opc <> 0) and (fileName = '') then begin
            Write('Ingrese el nombre del archivo binario: '); ReadLn(fileName);
            fileName := 'temp/' + fileName;
            Assign(arch, fileName);
        end;

        case opc of
            1: crearArchivo(arch);
            2: mostrarMenorQueStockMin(arch);
            3: substringDescripcion(arch);
            4: exportarInformacion(arch);
            5: anadirCelulares(arch);
            6: modificarStock(arch);
            7: exportarSinStock(arch);
        end;
    until (opc = 0)
end.
