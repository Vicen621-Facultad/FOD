{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program P2E4;

const
  VALOR_ALTO = 'ZZZZZZZZ';

type
  provincia = record
    nombre: String[20];
    alfabetizados, encuestados: integer;
  end;

  censo = record
    nombre: String[20];
    cod, alfabetizados, encuestados: integer;
  end;

  maestro = file of provincia;
  detalle = file of censo;

procedure leer(var det: detalle; var regd: censo);
begin
  if (not eof(det)) then
    read(det, regd)
  else
    regd.nombre := VALOR_ALTO;
end;

procedure minimo(var det1, det2: detalle; var reg1, reg2, min: censo);
begin
  if (reg1.nombre <= reg2.nombre) then begin
    min := reg1;
    leer(det1, reg1);
  end
  else begin
    min := reg2;
    leer(det2, reg2);
  end;

  WriteLn(min.nombre);
end;

procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle);
var
  regm, aux: provincia;
  reg1, reg2, min: censo;
begin
  Reset(mae);
  Reset(det1);
  Reset(det2);

  read(mae, regm);
  leer(det1, reg1); leer(det2, reg2);
  minimo(det1, det2, reg1, reg2, min);
  while (min.nombre <> VALOR_ALTO) do begin
    aux.nombre := min.nombre;
    aux.alfabetizados := 0;
    aux.encuestados := 0;

    while (aux.nombre = min.nombre) do begin
      aux.alfabetizados := aux.alfabetizados + min.alfabetizados;
      aux.encuestados := aux.encuestados + min.encuestados;
      minimo(det1, det2, reg1, reg2, min);
    end;

    while (aux.nombre <> regm.nombre) do
      read(mae, regm);
    
    regm.alfabetizados := aux.alfabetizados;
    regm.encuestados := aux.encuestados;

    seek(mae, filepos(mae) - 1);
    write(mae, regm);
    WriteLn('Provincia ' + regm.nombre + ' terminada');

    if (not eof(mae)) then
      read(mae, regm);
  end;

  close(mae);
  close(det1);
  close(det2);
end;

var
  mae: maestro;
  det1, det2: detalle;
begin
  Assign(mae, 'temp/maestro.dat');
  Assign(det1, 'temp/detalle_1.dat'); Assign(det2, 'temp/detalle_2.dat');
  actualizarMaestro(mae, det1, det2);
end.