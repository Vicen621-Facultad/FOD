{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program P2E1;

const
  VALOR_ALTO = '9999';

type
  comision = record
    cod: String[4];
    nombre: String[20];
    monto: real;
  end;

  detalle = file of comision;

procedure leer(var archivo: detalle; var dato: comision);
begin
  if (not EOF(archivo)) then
    read(archivo, dato)
  else
    dato.cod := VALOR_ALTO;
end;

var
  merge, det: detalle;
  name: String[20];
  com, aux: comision;
begin
  Assign(merge, 'archivo_final.dat');
  Write('Ingrese el nombre del archivo: '); ReadLn(name);
  Assign(det, name);
  Rewrite(merge);
  Reset(det);

  leer(det, com);
  while (com.cod <> VALOR_ALTO) do begin
    aux := com;
    aux.monto := 0;

    while (aux.cod = com.cod) do begin
      aux.monto := aux.monto + com.monto;
      leer(det, com)
    end;

    write(merge, aux);
  end;

  WriteLn('Todas las comisiones han sido guardadas con exito!');
  Close(merge);
  Close(det);
end.
