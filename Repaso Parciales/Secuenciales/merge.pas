program merge;
const
  VALOR_ALTO = 9999;
  CANT_ARCHIVOS = 10;

type
  reg_det = record
    campo: integer;
    campo2: integer;
    campo3: integer;
  end;

  reg_mae = record
    campo, campo2: integer;
  end;

  maestro = file of reg_mae;
  detalle = file of reg_det;
  arr_det = array[1..CANT_ARCHIVOS] of detalle;
  arr_reg = array[1..CANT_ARCHIVOS] of reg_det;

procedure leer(var det: detalle; var reg: reg_det);
begin
  if (not eof(det)) then
    read(det, reg);
  else
    reg.campo := VALOR_ALTO;
end;

procedure minimo(var detalles: arr_det; var registros: arr_reg; var min: reg_det);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (registros[i].campo < registros[posMin].campo) then
      posMin := i;
  end;

  min := registros[posMin];
  leer(detalles[posMin], registros[posMin]);
end;

procedure merge(var mae: maestro; var detalles: arr_det);
var
  registros: arr_reg;
  min: reg_det;
  regm: reg_mae;
  i: integer;
begin
  Rewrite(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], registros[i]);
  end;

  minimo(detalles, registros, min);
  while (min.campo <> VALOR_ALTO) do begin
    regm.campo := min.campo;
    regm.campo2 := 0;

    while (regm.campo = min.campo) do begin
      regm.campo2 := regm.campo2 + min.campo2;
      minimo(detalles, registros, min);
    end;

    Write(mae, regm);
  end;
end;

begin

end.