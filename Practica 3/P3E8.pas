program P3E8;

type
  reg_dist = record
    nombre, descripcion: String[45];
    lanzamiento, kernel, desarrolladores: integer;
  end;

  archivo = file of reg_dist;

procedure leerDistribucion(var dist: reg_dist);
begin
  Write('Ingrese el nombre de la distribucion: '); ReadLn(dist.nombre);
  dist.descripcion := '';
  dist.lanzamiento := 2000;
  dist.kernel := 10;
  dist.desarrolladores := 20;
end;

function ExisteDistribucion(var arch: archivo; nombre: String): boolean;
var
  dist: reg_dist;
begin
  dist.nombre := '';
  while (not eof(arch) and (dist.nombre <> nombre)) do
    Read(arch, dist);
  
  ExisteDistribucion := (dist.nombre = nombre);
end;

procedure AltaDistribucion(var arch: archivo);
var
  cabecera, dist: reg_dist;
begin
  Reset(arch);
  Read(arch, cabecera);

  leerDistribucion(dist);

  if (ExisteDistribucion(arch, dist.nombre)) then begin
    WriteLn('--- Ya existe la distribucion ---');
    Close(arch);
    exit;
  end;

  if (cabecera.desarrolladores >= 0) then begin
    Seek(arch, fileSize(arch));
    Write(arch, dist);
  end
  else begin  
    //Lista invertida;
    Seek(arch, (cabecera.desarrolladores * -1) - 1);
    Read(arch, cabecera);
    Seek(arch, filePos(arch) - 1);
    Write(arch, dist);
    Seek(arch, 0);
    Write(arch, cabecera);
  end;
  Close(arch);
end;

procedure BajaDistribucion(var arch: archivo);
var
  nombre: String[45];
  cabecera: reg_dist;
begin
  Reset(arch);
  Read(arch, cabecera);
  Write('Ingrese el nombre de la distribucion a borrar: '); ReadLn(nombre);

  if (not ExisteDistribucion(arch, nombre)) then begin
    WriteLn('--- Distribucion no existente ---');
    Close(arch);
    exit;
  end;

  Seek(arch, filePos(arch) - 1);
  Write(arch, cabecera);
  cabecera.desarrolladores := filePos(arch) * -1;
  Seek(arch, 0);
  Write(arch, cabecera);
  WriteLn('--- Distribucion ', nombre, ' borrada exitosamente ---');

  Close(arch);
end;

procedure exportarArchivo(var arch: archivo);
var
  dist: reg_dist;
  txt: Text;
begin
  Assign(txt, 'distribuciones.txt');
  Rewrite(txt);
  Reset(arch);

  WriteLn(txt, 'nombre|desarrolladores');
  while (not eof(arch)) do begin
    Read(arch, dist);
    WriteLn(txt, dist.nombre, '|', dist.desarrolladores);
  end;
  WriteLn('--- Los datos fueron exportados al archivo "distribuciones.txt" ---');

  Close(txt);
  Close(arch);
end;

var
  arch: archivo;
  dist: reg_dist;
  i: integer;
begin
  Assign(arch, 'distribuciones.dat');
  for i := 1 to 5 do
    AltaDistribucion(arch);

  BajaDistribucion(arch);

  exportarArchivo(arch);
end.