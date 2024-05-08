program P4E3;

const
  M = 4;
type
  alumno = record
    nombre, apellido: String[30];
    legajo: String[6];
    dni: String[8];
    ingreso: integer;
  end;

  reg_node = record
    dni: String[8];
    nrr: integer;
  end;

  // TODO: Preguntar si este nodo esta bien así
  nodo = record
    hoja_anterior: integer;
    cant_claves: integer;
    claves: array[1..M-1] of reg_node;
    hijos: array[1..M] of integer;
  end;

  arbol = file of nodo;

begin
end.