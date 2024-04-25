{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
  1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
  2. Idem anterior para los recuperados.
  3. Los casos activos se actualizan con el valor recibido en el detalle.
  4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
program P2E7;

Uses sysutils;

const
  VALOR_ALTO = '9999';
  CANT_ARCHIVOS = 2;
type
  dato_detalle = record
    localidad, cepa: String[4];
    activos, nuevos, recuperados, fallecidos: integer;
  end;

  dato_maestro = record
    cod_localidad, cod_cepa: String[4];
    nom_localidad, nom_cepa: String[30];
    activos, nuevos, recuperados, fallecidos: integer;
  end;

  detalle = file of dato_detalle;
  maestro = file of dato_maestro;

  arr_detalle = array[1..CANT_ARCHIVOS] of detalle;
  arr_datos = array[1..CANT_ARCHIVOS] of dato_detalle;

procedure leer(var det: detalle; var dato: dato_detalle);
begin
  if (not eof(det)) then
    read(det, dato)
  else
    dato.localidad := VALOR_ALTO;
end;

procedure leerMae(var mae: maestro; var dato: dato_maestro);
begin
  if (not eof(mae)) then
    read(mae, dato)
  else
    dato.cod_localidad := VALOR_ALTO;
end;

procedure minimo(detalles: arr_detalle; var datos: arr_datos; var min: dato_detalle);
var
  i, pos_min: integer;
begin
  pos_min := 1;
  for i := 1 to CANT_ARCHIVOS do begin
    if (datos[i].localidad < datos[pos_min].localidad) or 
      ((datos[i].localidad = datos[pos_min].localidad) and (datos[i].cepa <= datos[pos_min].cepa)) then
      pos_min := i;
  end;

  min := datos[pos_min];
  leer(detalles[pos_min], datos[pos_min]);
end;

procedure actualizarValores(var regm: dato_maestro; datos: dato_detalle);
begin
  regm.fallecidos := regm.fallecidos + datos.fallecidos;
  regm.recuperados := regm.recuperados + datos.recuperados;
  regm.activos := datos.activos;
  regm.nuevos := datos.nuevos;
end;

procedure actualizarMaestro(var mae: maestro; var detalles: arr_detalle);
var
  i: integer;
  datos: arr_datos;
  regm: dato_maestro;
  min, aux: dato_detalle;
begin
  Reset(mae);
  for i := 1 to CANT_ARCHIVOS do begin
    Reset(detalles[i]);
    leer(detalles[i], datos[i]);
  end;

  read(mae, regm);
  minimo(detalles, datos, min);
  while (min.localidad <> VALOR_ALTO) do begin
    aux.localidad := min.localidad;
    aux.fallecidos := 0; aux.activos := 0; aux.nuevos := 0; aux.recuperados := 0;

    while (aux.localidad = min.localidad) do begin
      aux.cepa := min.cepa;
      while (aux.localidad = min.localidad) and (aux.cepa = min.cepa) do begin
        aux.fallecidos := aux.fallecidos + min.fallecidos;
        aux.activos := aux.activos + min.activos;
        aux.nuevos := aux.nuevos + min.nuevos;
        aux.recuperados := aux.recuperados + min.recuperados;
        minimo(detalles, datos, min);
      end;

      while (regm.cod_localidad <> aux.localidad) and (regm.cod_cepa <> aux.cepa) do
        read(mae, regm);

      actualizarValores(regm, aux);
      Seek(mae, filePos(mae) - 1);
      write(mae, regm);
      
      if (not eof(mae)) then
        Read(mae, regm);
    end;
  end;
end;

function informar(var mae: maestro): integer;
var
  count, count_loc: integer;
  localidad: String[4];
  regm: dato_maestro;
begin
  count := 0;
  leerMae(mae, regm);
  while (regm.cod_localidad <> VALOR_ALTO) do begin
    localidad := regm.cod_localidad;
    count_loc := 0;

    while (localidad = regm.cod_localidad) do begin
      count_loc := count_loc + regm.activos;
      leerMae(mae, regm);
    end;

    if (count_loc > 50) then
      count := count + 1;
  end;

  informar := count;
end;

var
  mae: maestro;
  detalles: arr_detalle;
  i: integer;
begin
  Assign(mae, 'temp/maestro.dat');
  // asigno todos los detalles
  for i := 1 to CANT_ARCHIVOS do
    Assign(detalles[i], 'temp/detalle_' + IntToStr(i) + '.dat');
  
  actualizarMaestro(mae, detalles);
  WriteLn('Cantidad de localidades con mas de 50 casos activos: ', informar(mae));
end.