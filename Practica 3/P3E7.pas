{Se cuenta con un archivo que almacena información sobre especies de aves en vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave, descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa que elimine especies de aves, para ello se recibe por teclado las especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá implementar dos procedimientos, uno que marque los registros a borrar y posteriormente otro procedimiento que compacte el archivo, quitando los registros marcados. Para quitar los registros se deberá copiar el último registro del archivo en la posición del registro a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}
program P3E7;

type
  reg_especie = record
    codigo: integer;
    nombre, familia, descripcion, zona: String;
  end;

  archivo = file of reg_especie;

function eliminar(var arch: archivo; cod: integer): integer;
var
  especie: reg_especie;
  found: boolean;
  reg_pos: integer;
begin
  found := false;
  reg_pos := -1;

  Seek(arch, 0);
  while (not eof(arch) and not found) do begin
    Read(arch, especie);

    if (especie.codigo = cod) then begin
      especie.nombre := '*' + especie.nombre;
      reg_pos := filePos(arch);
      Seek(arch, reg_pos - 1);
      Write(arch, especie);
      found := true;
    end;
  end;

  eliminar := reg_pos;
end;

procedure compactarArchivo(var arch: archivo; reg_pos: integer);
var
  especie: reg_especie;
begin
  Seek(arch, fileSize(arch) - 1);
  Read(arch, especie);
  Seek(arch, reg_pos - 1);
  Write(arch, especie);
  Seek(arch, fileSize(arch) - 1);
  Truncate(arch);
end;

procedure eliminarEspecies(var arch: archivo);
var
  cod, reg_pos: integer;
begin
  Reset(arch);
  
  Write('Ingrese el codigo de especie a eliminar: '); ReadLn(cod);
  while (cod <> -1) do begin
    reg_pos := eliminar(arch, cod);
    if (reg_pos <> -1) then
      compactarArchivo(arch, reg_pos);
    
    Write('Ingrese el codigo de especie a eliminar: '); ReadLn(cod);
  end;

  Close(arch);
end;

procedure exportarArchivo(var arch: archivo);
var
  especie: reg_especie;
  txt: Text;
begin
  Assign(txt, 'especies.txt');
  Rewrite(txt);
  Reset(arch);

  WriteLn(txt, 'codigo|nombre|familia|descripcion|zona');
  while (not eof(arch)) do begin
    Read(arch, especie);
    WriteLn(txt, especie.codigo, '|', especie.nombre, '|', especie.familia, '|', especie.descripcion, '|', especie.zona);
  end;
  WriteLn('--- Los datos fueron exportados al archivo "especies.txt" ---');

  Close(txt);
  Close(arch);
end;

var
  arch: archivo;
begin
  Assign(arch, 'maestro.dat');
  eliminarEspecies(arch);
  exportarArchivo(arch);
end.