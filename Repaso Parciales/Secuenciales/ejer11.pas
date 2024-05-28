program ejer11;

const
  CANT_ARCHIVOS = 25;
  VALOR_ALTO = '9999';

type
  venta = record
    ticket: integer;
    cod_producto: String[4];
    cant: integer;
  end;

  producto = record
    cod: String[4];
    descripcion: String[30];
    cant, stock_min: integer;
    precio: real;
  end;

  maestro = file of producto;
  detalle = file of venta;
  arr_detalles = array[1..CANT_ARCHIVOS] of detalle;
  arr_ventas = array[1..CANT_ARCHIVOS] of venta;

procedure leer(var det: detalle; var v: venta);
begin
  if not eof(det) then
    read(det, v);
  else
    v.cod_producto := VALOR_ALTO;
end;

procedure minimo(var detalles: arr_detalles; var ventas: arr_ventas; var min: venta);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (ventas[i].cod_producto < ventas[posMin].cod_producto) then
      posMin := i;
  end;

  min := ventas[posMin];
  leer(detalles[posMin], ventas[posMin]);
end;

procedure actualizarMaestro(var mae: maestro; var detalles: arr_detalles);
var
  regm: producto;
  ventas: arr_ventas;
  aux, min: venta;
  i: integer;
begin
  Reset(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], ventas[i]);
  end;

  read(mae, regm);
  minimo(detalles, ventas, min);
  while (min.cod_producto <> VALOR_ALTO) do begin
    aux.cod_producto := min.cod_producto;
    aux.cant := 0;

    while (min.cod_producto = aux.cod_producto) do begin
      aux.cant := aux.cant + min.cant;
      minimo(detalles, ventas, min);
    end;

    while (regm.cod <> aux.cod_producto) do
      read(mae, regm);

    regm.cant := rem.cant - aux.cant;
    Seek(mae, filePos(mae) - 1);
    Write(mae, regm);

    if not eof(mae) then
      read(mae, regm);
  end;
end;