{Realizar un programa que genere un archivo de novelas filmadas durante el presente año. De cada novela se registra: código, género, nombre, duración, director y precio. El programa debe presentar un menú con las siguientes opciones:

  a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se utiliza la técnica de lista invertida para recuperar espacio libre en el archivo. Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista. Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela, el cual indica que no hay espacio libre dentro del archivo.

  b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a., se utiliza lista invertida para recuperación de espacio. En particular, para el campo de  ́enlace ́ de la lista, se debe especificar los números de registro referenciados con signo negativo, (utilice el código de novela como enlace).Una vez abierto el archivo, brindar operaciones para:
    i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el espacio libre. Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5, se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la posición 5. Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.
    
    ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.

    iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, en el campo código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.

  c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el usuario.}
program P3E3;

type
  novela = record
    codigo, duracion: integer;
    genero, nombre, director: String[50];
    precio: real;
  end;

  archivo = file of novela;

procedure leerNovela(var nov: novela);
begin
  nov.precio := Random() * 100;
  nov.duracion := Random(100) + 90;
  WriteLn('Duracion: ', nov.duracion);
  WriteLn('Precio: ', nov.precio:2:2);

  Write('Ingrese el codigo de novela (0 para terminar): '); ReadLn(nov.codigo);
  Write('Ingrese el nombre del director: '); ReadLn(nov.director);
  Write('Ingrese el titulo: '); ReadLn(nov.nombre);
  Write('Ingrese el genero: '); ReadLn(nov.genero);
end;

procedure crearArchivo(var arch: archivo);
var
  nov: novela;
begin
  Rewrite(arch);
  nov.codigo := 0;
  Write(arch, nov); // Escribo cabecera de lista

  leerNovela(nov);
  while (nov.codigo > 0) do begin
    Write(arch, nov);
    leerNovela(nov);
  end;

  Close(arch);
end;

procedure altaNovela(var arch: archivo);
var
  nov: novela;
  posLista: integer;
begin
  Reset(arch);

  Read(arch, nov);
  WriteLn(nov.codigo < 0);
  if (nov.codigo < 0) then begin
    posLista := (-1 * nov.codigo) - 1; // Paso la posicion de la lista a positivo y le resto 1 para ir al reg anterior y poder leerlo bien
    Seek(arch, posLista); // Voy al registro en el archivo
    Read(arch, nov); // leo el registro
    Seek(arch, 0); // Voy a la cabecera de la lista
    Write(arch, nov); // Escribo el archivo eliminado en la cabecera
    Seek(arch, posLista) // Voy a donde tengo que escribir el registro nuevo
  end
  else
    Seek(arch, FileSize(arch));
    
  leerNovela(nov);
  Write(arch, nov);
  Close(arch);
end;

procedure modificarDatos(var nov: novela);
var
  aux: novela;
begin
  aux.duracion := -1;
  aux.precio := -1;
  aux.genero := '';
  aux.director := '';
  aux.nombre := '';

  Write('Ingrese la nueva duracion (-1 para no modificar): '); ReadLn(aux.duracion);
  Write('Ingrese el nuevo precio (-1 para no modificar): '); ReadLn(aux.precio);
  Write('Ingrese el nuevo genero (-1 para no modificar): '); ReadLn(aux.genero);
  Write('Ingrese el nuevo director (-1 para no modificar): '); ReadLn(aux.director);
  Write('Ingrese el nuevo nombre (-1 para no modificar): '); ReadLn(aux.nombre);

  if (aux.duracion <> -1) then
    nov.duracion := aux.duracion;
  if (aux.precio <> -1) then
    nov.precio := aux.precio;
  if (aux.genero <> '-1') then
    nov.genero := aux.genero;
  if (aux.director <> '-1') then
    nov.director := aux.director;
  if (aux.nombre <> '-1') then
    nov.nombre := aux.nombre;
end;

procedure modificarDatosNovela(var arch: archivo);
var
  nov: novela;
  codigo: integer;
  found: boolean;
begin
  Reset(arch);
  Write('Ingrese el codigo de la novela a modificar: '); ReadLn(codigo);

  found := false;
  while (not eof(arch)) and (not found) do begin
    Read(arch, nov);
    WriteLn(nov.codigo);
    if (nov.codigo = codigo) then
      found := true;
  end;

  if (found) then begin
    modificarDatos(nov);
    Seek(arch, FilePos(arch) - 1);
    Write(arch, nov);
  end
  else
    WriteLn('--- ERROR: No se ha encontrado la novela! ---');

  Close(arch);
end;

procedure eliminarNovela(var arch: archivo);
var
  nov, cabecera: novela;
  codigo, posRegister: integer;
  found: boolean;
begin
  Reset(arch);
  Read(arch, cabecera);
  Write('Ingrese el codigo de novela que desea eliminar: '); ReadLn(codigo);

  found := false;
  while (not eof(arch)) and (not found) do begin
    Read(arch, nov);
    if (nov.codigo = codigo) then
      found := true;
  end;

  if (found) then begin
    Seek(arch, filePos(arch) - 1); // Voy al registro anterior para escribir el header
    Write(arch, cabecera); // Escribio el antiguo header en el registro borrado
    cabecera.codigo := filePos(arch) * -1; // Actualizo el header
    Seek(arch, 0);
    Write(arch, cabecera); // Escribo el header en la posicion 0
    WriteLn('--- Novela ', nov.nombre, ' eliminada exitosamente! ---');
  end
  else
    WriteLn('--- ERROR: No se ha encontrado la novela! ---');

  close(arch);
end;

procedure mantenimientoArchivo(var arch: archivo);
var
  opc: byte;
begin
  repeat
    WriteLn;
    WriteLn('0. Volver al menu anterior.');
    WriteLn('1. Agregar una novela.');
    WriteLn('2. Modificar una novela');
    WriteLn('3. Borrar una novela');

    Write('Ingrese el numero de opcion deseada: '); ReadLn(opc);
    WriteLn;

    case opc of
      1: altaNovela(arch);
      2: modificarDatosNovela(arch);
      3: eliminarNovela(arch);
    end;
  until opc = 0;
end;

procedure exportarArchivo(var arch: archivo);
var
  nov: novela;
  txt: Text;
begin
  Assign(txt, 'temp/novelas.csv');
  Rewrite(txt);
  Reset(arch);

  WriteLn(txt, 'codigo|nombre|genero|director|duracion|precio');
  while (not eof(arch)) do begin
    Read(arch, nov);
    WriteLn(txt, nov.codigo, '|', nov.nombre, '|', nov.genero, '|', nov.director, '|', nov.duracion, '|', nov.precio:2:2);
  end;
  WriteLn('--- Los datos fueron exportados al archivo "todos_asistentes.txt" ---');

  Close(txt);
  Close(arch);
end;

var
  opc: byte;
  arch: archivo;
  fileName: String[40];
begin
  fileName := '';
  WriteLn('NOVELAS');

  repeat
    WriteLn;
    WriteLn('0. Terminar programa.');
    WriteLn('1. Crear y cargar archivo.');
    WriteLn('2. Mantenimiento de archivo');
    WriteLn('3. Exportar a novelas.txt');

    Write('Ingrese el numero de opcion deseada: '); ReadLn(opc);
    WriteLn;

    if (opc <> 0) and (fileName = '') then begin
      Write('Ingrese el nombre del archivo: '); ReadLn(fileName);
      fileName := 'temp/' + fileName;
      Assign(arch, fileName);
    end;

    case opc of
      1: crearArchivo(arch);
      2: mantenimientoArchivo(arch);
      3: exportarArchivo(arch);
    end;
  until opc = 0;
end.