program truncate;

type
  reg = record
    campo1, campo2: integer;
  end;

  archivo = file of reg;

procedure compactarArchivo(var arch: archivo; reg_pos: integer);
var
  registro: reg;
begin
  Seek(arch, fileSize(arch) - 1);
  Read(arch, registro);
  Seek(arch, reg_pos - 1);
  Write(arch, registro);
  Seek(arch, fileSize(arch) - 1);
  Truncate(arch);
end;

begin

end.