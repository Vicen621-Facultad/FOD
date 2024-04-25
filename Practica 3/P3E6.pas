program P3E6;

type
  reg_prenda = record
    cod, stock: integer;
    descripcion, colores, tipo: String[45];
    precio: real;
  end;

  archivo = file of reg_prenda;

procedure actualizarMaestro(var maestro, detalle: archivo);
var
  prenda_det, prenda: reg_prenda;
  found: boolean;
begin
  Reset(maestro);
  Reset(detalle);

  while (not eof(detalle)) do begin
    Read(detalle, prenda_det);

    Seek(maestro, 0);
    found := false;
    while (not eof(maestro) and (not found)) do begin
      Read(maestro, prenda);

      if (prenda_det.cod = prenda.cod) then begin
        prenda.stock := -1;
        seek(maestro, filePos(maestro) - 1);
        write(maestro, prenda);
        found := true;
      end;
    end;
  end;

  Close(detalle);
  Close(maestro);
end;

procedure compactacion(var arch: archivo; nombre: String);
var
  nuevo: archivo;
  prenda: reg_prenda;
begin
  Assign(nuevo, 'nuevo.dat');
  Rewrite(nuevo);
  Reset(arch);

  while (not eof(arch)) do begin
    Read(arch, prenda);
    if (prenda.stock >= 0) then
      Write(nuevo, prenda);
  end;

  Close(arch);
  Close(nuevo);
  Rename(nuevo, nombre);
end;


var
  arch, detalle: archivo;
  nombre: String;
begin
  Write('Ingrese el nombre del archivo: '); ReadLn(nombre);
  Assign(arch, nombre);
  Assign(detalle, 'temp/detalle.dat');
  actualizarMaestro(arch, detalle);
  compactacion(arch, nombre);
end.