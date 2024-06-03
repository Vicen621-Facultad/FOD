program ejer10;

const
  VALOR_ALTO = 9999;

type
  venta = record
    categoria, marca, modelo, cant: integer;
  end;

  archivo = file of venta;

procedure leer(var arch: archivo; var v: venta);
begin
  if (not eof(arch)) then
    read(arch, v);
  else
    v.cant := VALOR_ALTO;
end;

procedure corteControl(var arch: archivo);
var
  txt: Text;
  v, actual: venta;
begin
  
end;