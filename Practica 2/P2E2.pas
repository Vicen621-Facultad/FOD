{Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a.  Actualizar el archivo maestro de la siguiente manera:
    i.  Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
        y se decrementa en uno la cantidad de materias sin final aprobado.

    ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
        final.

b.  Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
    aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
    es un reporte de salida (no se usa con fines de carga), debe informar todos los
    campos de cada alumno en una sola línea del archivo de texto.

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.}

program P2E2;

const
  VALOR_ALTO = '9999';

type
  alumno = record
    cod: String[4];
    nombre, apellido: String[30];
    cursadas, final_aprobado: integer;
  end;

  materia = record
    cod: String[4];
    aprobacion: String[7]; // cursada o final
  end;

  detalle = file of materia;
  maestro = file of alumno;

procedure leerAlumno(var alu: alumno);
begin
  Write('Ingrese el codigo de alumno (-1 para terminar): '); ReadLn(alu.cod);
  if (alu.cod <> '-1') then begin
    Write('Ingrese el nombre: '); ReadLn(alu.nombre);
    Write('Ingrese el apellido: '); ReadLn(alu.apellido);
    Write('Ingrese cant de cursadas aprobadas: '); ReadLn(alu.cursadas);
    Write('Ingrese cant de finales aprobados: '); ReadLn(alu.final_aprobado);
  end;
end;

procedure leerMateria(var mat: materia);
begin
  Write('Ingrese el codigo de alumno (-1 para terminar): '); ReadLn(mat.cod);
  if (mat.cod <> '-1') then
    Write('Ingrese el metodo de aprobacion (final o cursada): '); ReadLn(mat.aprobacion);
end;

procedure writeMaster(var archivo: maestro);
var
  alu: alumno;
begin
  Rewrite(archivo);
  leerAlumno(alu);
  while (alu.cod <> '-1') do begin
    write(archivo, alu);
    leerAlumno(alu);
  end;
  close(archivo);
end;

procedure writeDetail(var archivo: detalle);
var
  mat: materia;
  fileName: String[20];
begin
  Write('Ingrese el nombre del archivo detalle: '); ReadLn(fileName);
  Assign(archivo, fileName);

  Rewrite(archivo);
  leerMateria(mat);
  while (mat.cod <> '-1') do begin
    write(archivo, mat);
    leerMateria(mat);
  end;
  close(archivo);
end;

procedure leer(var archivo: detalle; var mat: materia);
begin
  if (not eof(archivo)) then
    read(archivo, mat)
  else
    mat.cod := VALOR_ALTO;
end;

procedure updateMaster(var mae: maestro; var det: detalle);
var
  fileName: String[20];
  alu: alumno;
  mat: materia;
  aux: String[4];
  finales, cursadas: integer;
begin
  Write('Ingrese el nombre del archivo detalle: '); ReadLn(fileName);
  Assign(det, fileName);
  
  Reset(mae);
  Reset(det);

  read(mae, alu);
  leer(det, mat);

  while(mat.cod <> VALOR_ALTO) do begin
    aux := mat.cod;
    finales := 0; cursadas := 0;

    while (aux = mat.cod) do begin
      if (mat.aprobacion = 'cursada') then
        cursadas := cursadas + 1
      else
        finales := finales + 1;
      
      leer(det, mat);
    end;

    while (alu.cod <> aux) do
      read(mae, alu);
    
    alu.final_aprobado := alu.final_aprobado + finales;
    alu.cursadas := alu.cursadas + cursadas - finales;

    seek(mae, filepos(mae) - 1);
    write(mae, alu);

    if (not eof(mae)) then
      read(mae, alu);
  end;

  close(mae);
  close(det);
end;

procedure reportTxt(var archivo: maestro);
var
  alu: alumno;
  txt: Text;
begin
  Assign(txt, 'reporte.txt');
  Rewrite(txt);
  Reset(archivo);
  WriteLn(txt, 'Codigo | Nombre | Apellido | Cursadas | Finales Aprobados');

  while (not eof(archivo)) do begin
    read(archivo, alu);
    if (alu.final_aprobado > alu.cursadas) then
      WriteLn(txt, alu.cod, ' | ', alu.nombre, ' | ', alu.apellido, ' | ', alu.cursadas, ' | ', alu.final_aprobado);
  end;
  WriteLn('Reporte hecho con exito!');

  Close(archivo);
  Close(txt);
end;

var
  mae: maestro;
  det: detalle;
  opc: byte;
  fileName: String[20];
begin
  fileName := '';
  WriteLn('ALUMNOS');

  repeat
    WriteLn;
    WriteLn('0. Terminar Programa.');
    WriteLn('1. Actualizar el arhivo maestro con el archivo detalle.');
    WriteLn('2. Hacer un reporte de los alumnos que tienen mas finales que cursadas aprobadas.');
    WriteLn('3. Crear maestro');
    WriteLn('4. Crear detalle');
    Write('Ingrese el numero de opcion deseada: '); ReadLn(opc);
    WriteLn;

    if (opc <> 0) and (opc <> 4) and (fileName = '') then begin
      Write('Ingrese el nombre del archivo maestro: '); ReadLn(fileName);
      Assign(mae, fileName);
    end;

    case opc of
      1: updateMaster(mae, det);
      2: reportTxt(mae);
      3: writeMaster(mae);
      4: writeDetail(det);
    end;
  until (opc = 0);
end.