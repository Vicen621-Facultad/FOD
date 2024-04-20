program P3E3;

type
  novela = record
    codigo, duracion: integer;
    genero, nombre, director: String[50];
    precio: real;
  end;

procedure leerNovela(var nov: novela);
begin
  
end;

procedure crearArchivo(var arch: archivo);
var
  nov: novela;
begin
  Rewrite(arch);
  nov.cod := 0;
  Write(arch, nov); // Escribo cabecera de lista

  leerNovela(nov);
  while (nov.cod > 0) do begin
    Write(arch, nov);
    leerNovela(nov);
  end;

  Close(arch);
end;

procedure mantenimientoArchivo(var arch: archivo);
begin

end;

procedure exportarArchivo(var arch: archivo);
var
  nov: novela;
  txt: Text;
begin
  Assign(txt, 'temp/novelas.csv');
  Rewrite(txt);
  Reset(arch);

  WriteLn(txt, 'codigo|nombre|genero|director|duracion|precio');
  while (not eof(arch)) do begin
    Read(arch, nov);
    WriteLn(arch, nov.codigo, '|', nov.nombre, '|', nov.genero, '|', nov.director, '|', nov.duracion, '|', nov.precio);
  end;
  WriteLn('--- Los datos fueron exportados al archivo "todos_asistentes.txt" ---');

  Close(txt);
  Close(arch);
end;

var
  opc: byte;
begin
  WriteLn('NOVELAS');

  repeat
    WriteLn;
    WriteLn('0. Terminar programa.');
    WriteLn('1. Crear y cargar archivo.');
    WriteLn('2. Mantenimiento de archivo');
    WriteLn('3. Exportar a novelas.txt');

    Write('Ingrese el numero de opcion deseada: '); ReadLn(opc);
    WriteLn;

    if (opc <> 0) and (fileName = '') then begin
      Write('Ingrese el nombre del archivo: '); ReadLn(fileName);
      fileName := 'temp/' + fileName;
      Assign(arch, fileName);
    end;

    case of opc
      1: crearArchivo(arch);
      2: mantenimientoArchivo(arch);
      3: exportarArchivo(arch);
    end;
  until opc = 0;
end.