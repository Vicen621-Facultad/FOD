program ejer8;

const
  CANT_ARCHIVOS = 3;
  VALOR_ALTO = '9999';

type
  acceso = record
    cod: String[4];
    nombre: String[20];
    fechaYHora: String[16]; // dd/mm/AAAA HH:MM
  end;

  accesos_proceso = record
    cod: String[4];
    nombre: String[20];
    cant_accesos: integer;
  end;

  maestro = file of accesos_proceso;
  detalle = file of acceso;
  arr_detalle = array[1..CANT_ARCHIVOS] of detalle;
  arr_acceso = array[1..CANT_ARCHIVOS] of acceso;

procedure leer(var det: detalle; var acc: acceso);
begin
  if (not eof(det)) then
    read(det, acc)
  else
    acc.cod := VALOR_ALTO;
end;

procedure minimo(var detalles: arr_detalle; var accesos: arr_acceso; var min: acceso);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (accesos[i].cod < accesos[posMin].cod) then
      posMin := i;
  end;

  min := accesos[posMin];
  leer(detalles[min], accesos[min]);
end;

procedure merge(var mae: maestro; var detalles: arr_detalle);
var
  accesos: arr_acceso;
  aux, min: acceso;
  regm: accesos_proceso;
  i: integer;
begin
  Rewrite(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], accesos[i]);
  end;

  minimo(detalles, accesos, min);
  while min.cod <> VALOR_ALTO do begin
    aux.cod := min.cod;
    aux.nombre := min.nombre;
    aux.cant_accesos := 0;

    while (min.cod = aux.cod) do begin
      aux.cant_accesos := aux.cant_accesos + 1;
      minimo(detalles, accesos, min);
    end;

    write(mae, regm);
  end;
end;

var
  mae: maestro;
  detalles: arr_detalle;
begin
  Assign(mae, 'accesos.dat');
  Assign(detalles[1], 'detalle1.dat');
  Assign(detalles[2], 'detalle2.dat');
  Assign(detalles[3], 'detalle3.dat');
  merge(mae, detalles);
end;