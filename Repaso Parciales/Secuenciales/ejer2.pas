program Ejer2;
const
  VALOR_ALTO = '999999'
  CANT_ARCHIVOS = 3;

type
  producto = record
    codigo: String[6];
    codigo_barras, descripcion: String[50];
    nombre, categoria: String[20];
    stock_actual, stock_minimo: integer
  end;

  pedido = record
    codigo: String[6];
    cantidad: integer;
    descripcion: String[50];
  end;
  
  maestro = file of producto;
  detalle = file of pedido;
  arr_pedido = array[1..CANT_ARCHIVOS] of pedido;
  arr_detalle = array[1..CANT_ARCHIVOS] of detalle;

procedure leer(var det: detalle; var ped: pedido);
begin
  if (not eof(det)) then
    read(det, ped);
  else
    ped.codigo := VALOR_ALTO;
end;

procedure minimo(var detalles: arr_detalle; var pedidos: arr_pedido; var min: pedido);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (pedidos[i].codigo <= pedidos[posMin].codigo) then
      posMin := i;
  end;

  min := pedidos[posMin];
  leer(detalles[posMin], pedidos[posMin]);
end;

procedure actualizarMaestro(var mae: maestro; var detalles: arr_detalle);
var
  pedidos: arr_pedido;
  regm: producto;
  aux, min: pedido;
  i: integer;
begin
  Reset(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], pedidos[i]);
  end;

  read(mae, regm);
  minimo(detalles, pedidos, min);
  while (min.codigo <> VALOR_ALTO) do begin
    aux.codigo := min.codigo;
    aux.cantidad := 0;

    while (aux.codigo = min.codigo) do begin
      aux.cantidad := aux.cantidad + min.cantidad;
      minimo(detalles, pedidos, min);
    end;

    while (aux.cod <> regm.cod) do
      read(mae, regm);

      
    if regm.cantidad >= aux.cantidad then
      regm.cantidad := regm.cantidad - aux.cantidad
    else begin
      WriteLn('No se pudo completar el pedido para el producto ', aux.codigo, ' faltaron ', (aux.cantidad - regm.cantidad), ' productos')
      regm.cantidad := 0;
    end;

    if (regm.cantidad < regm.stock_minimo) then
      WriteLn('El producto ', regm.codigo, ' quedo por debajo del stock minimo y es de la categoria ', regm.categoria);

    seek(mae, filePos(mae) - 1);
    Write(mae, regm);

    if (not eof(mae)) then
      Read(mae, regm);
  end;
end;

var
  mae: maestro;
  detalles: arr_detalle;
begin
  actualizarMaestro(mae, detalles);
end;