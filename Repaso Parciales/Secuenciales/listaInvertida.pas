program listaInvertida;

type
  reg = record
    cod: integer;
    campo: String[20];
  end;

  archivo = file of reg;

procedure altaListaInvertida(var arch: archivo; registro: reg);
var
  cabecera: reg;
begin
  Reset(arch);
  Read(arch, cabecera);

  if (cabecera.cod >= 0) then begin
    Seek(arch, fileSize(arch));
    Write(arch, registro);
  end
  else begin
    Seek(arch, (cabecera.cod * -1) - 1);
    read(arch, cabecera);
    Seek(arch, filePos(arch) - 1);
    Write(arch, registro);
    Seek(arch, 0);
    Write(arch, cabecera);
  end;
  Close(arch);
end;

procedure bajaListaInvertida(var arch: archivo; cod: integer);
var
  cabecera, busqueda: reg;
begin
  Reset(arch);
  Read(arch, cabecera);

  busqueda.cod := -1;
  while (not eof(arch)) and (busqueda.cod <> cod) do
    read(arch, busqueda);
  
  if (busqueda.cod = cod) then begin
    Seek(arch, filePos(arch) - 1);
    Write(arch, cabecera);
    cabecera.cod := filePos(arch) * -1;
    Seek(arch, 0);
    Write(arch, cabecera);
  end;
  Close(arch);
end;


begin

end.