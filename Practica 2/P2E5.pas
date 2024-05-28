{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program P2E5;

Uses sysutils;

const
  VALOR_ALTO = '9999';
  CANT_ARCHIVOS = 30;

type
  producto = record
    cod: String[4];
    nombre: String[20];
    descripcion: String[100];
    disponible, minimo: integer;
    precio: real;
  end;

  venta = record
    cod: String[4];
    cant: integer;
  end;

  maestro = file of producto;
  detalle = file of venta;
  arr_detalle = array[1..CANT_ARCHIVOS] of detalle;
  arr_venta = array[1..CANT_ARCHIVOS] of venta;

procedure leer(var det: detalle; var v: venta);
begin
  if (not eof(det)) then
    read(det, v)
  else
    v.cod := VALOR_ALTO;
end;

procedure minimo(var detalles: arr_detalle; var ventas: arr_venta; var min: venta);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (ventas[i].cod <= ventas[posMin].cod) then
      posMin := i;
  end;

  min := ventas[posMin];
  leer(detalles[posMin], ventas[posMin]);
end;

procedure actualizarMaestro(var mae: maestro; var detalles: arr_detalle);
var
  ventas: arr_venta;
  regm: producto;
  aux, min: venta;
  i: integer;
begin
  // Abro archivos e inicializo el array
  Reset(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], ventas[i]);
  end;

  read(mae, regm);
  minimo(detalles, ventas, min);
  while (min.cod <> VALOR_ALTO) do begin
    aux.cod := min.cod;
    aux.cant := 0;

    while (aux.cod = min.cod) do begin
      aux.cant := aux.cant + min.cant;
      minimo(detalles, ventas, min);
    end;

    while (aux.cod <> regm.cod) do
      read(mae, regm);

    regm.disponible := regm.disponible - aux.cant;
    seek(mae, filePos(mae) - 1);
    Write(mae, regm);

    WriteLn('Nombre: ', regm.nombre, ' | disponible: ', regm.disponible);

    if (not eof(mae)) then
      Read(mae, regm);
  end;

  // Cierro los archivos
  close(mae);
  for i := 1 to CANT_ARCHIVOS do
    Close(detalles[i]);
end;

procedure crearReporte(var mae: maestro);
var
  prod: producto;
  txt: Text;
begin
  Assign(txt, 'temp/reporte.txt');
  Reset(mae);
  Rewrite(txt);
  WriteLn(txt, 'Nombre | Descripcion | Stock Disponible | Precio');

  while (not eof(mae)) do begin
    read(mae, prod);
    if (prod.minimo > prod.disponible) then
      WriteLn(txt, prod.nombre, ' | ', prod.descripcion, ' | ', prod.disponible, ' | ', prod.precio:2:2);
  end;

  Close(txt);
  Close(mae);
end;

var
  mae: maestro;
  detalles: arr_detalle;
  prod: producto;
  i: integer;
begin
  Assign(mae, 'temp/maestro.dat');
  // asigno todos los detalles
  for i := 1 to CANT_ARCHIVOS do
    Assign(detalles[i], 'temp/detalle_' + IntToStr(i) + '.dat');
  
  actualizarMaestro(mae, detalles);
  crearReporte(mae);
end.