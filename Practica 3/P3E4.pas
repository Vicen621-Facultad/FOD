program P3E4;

type
  reg_flor = record
    nombre: String[45];
    codigo: integer;
  end;

  tArchFlores = file of reg_flor;

procedure crearArchivo(var arch: tArchFlores);
var
  flor: reg_flor;
begin
  Rewrite(arch);
  flor.codigo := 0;
  Write(arch, flor);
  Close(arch);
end;

procedure agregarFlor(var arch: tArchFlores; nombre: String; codigo: integer);
var
  flor, cabecera: reg_flor;
begin
  Reset(arch);
  Read(arch, cabecera);

  flor.nombre := nombre;
  flor.codigo := codigo;

  if (cabecera.codigo = 0) then begin
    Seek(arch, fileSize(arch));
    Write(arch, flor);
  end
  else begin
    Seek(arch, (cabecera.codigo * -1) - 1);
    Read(arch, cabecera);
    Seek(arch, filePos(arch) - 1);
    Write(arch, flor);
    Seek(arch, 0);
    Write(arch, cabecera);
  end;

  Close(arch);
end;

procedure eliminar(var arch: tArchFlores; flor: reg_flor);
var
    aux, cabecera: reg_flor;
    found: boolean;
begin
  Reset(arch);
  Read(arch, cabecera);

  found := false;
  while (not eof(arch) and not found) do begin
    Read(arch, aux);
    if (aux.codigo = flor.codigo) then
      found := true;
  end;

  if (found) then begin
    Seek(arch, filePos(arch) - 1);
    Write(arch, cabecera);
    cabecera.codigo := filePos(arch) * -1;
    Seek(arch, 0);
    Write(arch, cabecera);
  end
  else
    WriteLn('--- ERROR: No se ha encontrado la flor! ---');
  
  Close(arch);
end;

procedure exportarArchivo(var arch: tArchFlores);
var
  flor: reg_flor;
  txt: Text;
begin
  Assign(txt, 'temp/flores.txt');
  Rewrite(txt);
  Reset(arch);

  WriteLn(txt, 'codigo|nombre');
  while (not eof(arch)) do begin
    Read(arch, flor);
    WriteLn(txt, flor.codigo, '|', flor.nombre);
  end;
  WriteLn('--- Los datos fueron exportados al archivo "flores.txt" ---');

  Close(txt);
  Close(arch);
end;

procedure listarArchivo(var arch: tArchFlores);
var
  flor: reg_flor;
begin
  Reset(arch);
  while (not eof(arch)) do begin
    Read(arch, flor);
    if (flor.codigo > 0) then
      WriteLn('codigo: ', flor.codigo, ' nombre: ', flor.nombre);
  end;
  Close(arch);
end;

var
  arch: tArchFlores;
  flor: reg_flor;
begin
  Assign(arch, 'temp/flores.dat');
  crearArchivo(arch);

  agregarFlor(arch, 'rosa', 20);
  agregarFlor(arch, 'girasol', 5);
  agregarFlor(arch, 'tulipan', 19);
  agregarFlor(arch, 'margarita', 230);
  agregarFlor(arch, 'orquidea', 124);
  agregarFlor(arch, 'lirio', 1021);
  agregarFlor(arch, 'hortensia', 201);

  listarArchivo(arch);

  flor.codigo := 1021;
  eliminar(arch, flor);

  listarArchivo(arch);

  agregarFlor(arch, 'amapola', 321);
  exportarArchivo(arch);
end.