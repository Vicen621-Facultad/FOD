{Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de versión del kernel, cantidad de desarrolladores y descripción. El nombre de las distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:

  a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si la distribución existe en el archivo o falso en caso contrario.

  b. AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.

  c. BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir se debe informar “Distribución no existente”.}
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