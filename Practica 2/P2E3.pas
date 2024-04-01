{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
    ● Ambos archivos están ordenados por código de producto.
    ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
      archivo detalle.
    ● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program P2E3;

const
  VALOR_ALTO = 9999;

type
  producto = record
    cod, actual, minimo: integer;
    nombre: String[20];
    precio: real;
  end;

  venta = record
    cod, cant: integer;
  end;

  maestro = file of producto;
  detalle = file of venta;

procedure readProduct(var prod: producto; var codigo: integer;);
begin
  WriteLn;
  Write('Ingrese el nombre del producto ("ZZZ" para terminar): '); ReadLn(prod.nombre);
  if (prod.nombre <> 'ZZZ') or (codigo = 9998) then begin
    codigo := codigo + 1;
    prod.cod := codigo; WriteLn('Codigo de producto: ', prod.cod);
    prod.precio := Random * 100; WriteLn('Precio: ', prod.precio:2:2);
    prod.actual := Random(20) + 1; WriteLn('Stock actual: ', prod.actual);
    prod.minimo := Random(10) + 1; WriteLn('Stock minimo: ', prod.minimo);
  end;
end;

procedure writeMaster(var mae: maestro);
var
  prod: producto;
  codigo: integer;
begin
  codigo := 0;
  Rewrite(mae);
  readProduct(prod, codigo);
  while (prod.nombre <> 'ZZZ') do begin
    Write(mae, prod);
    readProduct(prod, codigo);
  end;
  Close(mae);
end;

procedure readVenta(var v: venta);
begin
  WriteLn;
  Write('Ingrese el codigo del producto vendido (9999 para terminar): '); ReadLn(v.cod);
  if (v.cod <> 9999) then begin
    v.cant := Random(5) + 1; WriteLn('Cantidad vendida: ', v.cant);
  end;
end;

procedure writeDetail(var det: detalle);
var
  v: venta;
begin
  Rewrite(det);
  readVenta(v);
  while (v.cod <> 9999) do begin
    Write(det, v);
    readVenta(v);
  end;
  Close(det);
end;

procedure leer(var det: detalle; var regd: venta);
begin
  if (not eof(det)) then
    read(det, regd)
  else
    regd.cod := VALOR_ALTO;
end;

procedure updateMaster(var mae: maestro; var det: detalle);
var
  regm: producto;
  regd: venta;
  aux, total: integer;
begin
  Reset(mae);
  Reset(det);

  read(mae, regm);
  leer(det, regd);
  while (regd.cod <> VALOR_ALTO) do begin
    aux := regd.cod;
    total := 0;

    while (aux = regd.cod) do begin
      total := total + regd.cant;
      leer(det, regd);
    end;

    while (regm.cod <> aux) do
      read(mae, regm);
    
    regm.actual := regm.actual - total;
    seek(mae, filepos(mae) - 1);
    write(mae, regm);

    if (not eof(mae)) then
      read(mae, regm);
  end;
end;

procedure writeReport(var mae: maestro);
var
  prod: producto;
  txt: Text;
begin
  Assign(txt, 'temp/report.txt');
  Rewrite(txt);
  WriteLn(txt, 'Codigo | Nombre | Precio | Stock Actual | Stock Minimo');

  Reset(mae);
  while (not eof(mae)) do begin
    read(mae, prod);
    if (prod.actual < prod.minimo) then
      WriteLn(txt, prod.cod, ' | ', prod.nombre, ' | ', prod.precio:2:2, ' | ', prod.actual, ' | ', prod.minimo, ' | ');
  end;
  Close(mae);
  Close(txt);
end;

procedure writeDet(var mae: detalle);
var
  v: venta;
  txt: Text;
begin
  Assign(txt, 'temp/ventas.txt');
  Rewrite(txt);
  WriteLn(txt, 'Codigo | Cantidad vendida');

  Reset(mae);
  while (not eof(mae)) do begin
    read(mae, v);
    WriteLn(txt, v.cod, ' | ', v.cant);
  end;
  Close(mae);
  Close(txt);
end;

var
  det: detalle;
  mae: maestro;
  opc: byte;
begin
  Randomize;
  Assign(mae, 'var/maestro.dat');
  Assign(det, 'var/detalle.dat');
  WriteLn('NEGOCIO DE LIMPIEZA');

  repeat
    WriteLn;
    WriteLn('0. Terminar programa.');
    WriteLn('1. Actualizar archivo maestro.');
    WriteLn('2. Listar productos con stock menor al minimo.');
    WriteLn('3. Crear maestro.');
    WriteLn('4. Crear detalle.');
    Write('Ingrese el numero de opcion deseada: '); ReadLn(opc);
    WriteLn;

    case opc of
      1: updateMaster(mae, det);
      2: writeReport(mae);
      3: writeMaster(mae);
      4: writeDetail(det);
    end;
  until (opc = 0);
end.