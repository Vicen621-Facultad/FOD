program P4E1;

const
  M = 4;
type
  alumno = record
    nombre, apellido: String[30];
    legajo: String[6];
    dni: String[8];
    ingreso: integer;
  end;

  nodo = record
    cant_claves: integer;
    claves: array[1..M-1] of alumno;
    hijos: array[1..M] of integer;
  end;

  arbol = file of nodo;