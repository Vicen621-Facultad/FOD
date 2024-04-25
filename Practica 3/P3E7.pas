program P3E7;

type
  reg_especie = record
    codigo: integer;
    nombre, familia, descripcion, zona: String;
  end;

  archivo = file of reg_especie;

procedure eliminarEspecies(var arch: archivo);
var
  cod, reg_pos: integer;
  especie: reg_especie;
  found: boolean;
begin
  Reset(arch);
  
  Write('Ingrese el codigo de especie a eliminar: '); ReadLn(cod);
  while (cod <> 500000) do begin
    reg_pos := eliminar(arch, cod);
    if (reg_pos <> -1) then
      compactarArchivo(arch, reg_pos);
  end;

  Close(arch);
end;

procedure eliminar(var arch: archivo; cod: integer): integer;
var
  especie: reg_especie;
  found: boolean;
  pos: integer;
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
  Seek(fileSize(arch) - 1);
  Truncate(arch);
end;

var
  arch: archivo;
begin
  Assign(arch, 'especies.dat');
  eliminarEspecies(arch);
end.