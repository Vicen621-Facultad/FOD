program ejer7;
const
  CANTIDAD_ARCHIVOS = 5;
  VALOR_ALTO = '9999';

type
  datos_padre = record
    nombre, apellido: String[30];
    dni: String[8];
  end;

  direccion = record
    calle: String[20];
    nro: integer;
    piso: integer;
    departamento: char,
    ciudad: String[20];
  end;

  nacimiento = record
    numero: integer;
    nombre, apellido: String[30];
    dir: direccion;
    medico: String[20];
    madre, padre: datos_padre;
  end;

  fallecimiento = record
    partida_nacimiento: integer;
    dni: String[8];
    nombre, apellido: String[30];
    medico: String[20];
    fecha: String[10]; // dd/mm/AAAA
    hora: String[5]; // MM:ss
    lugar: String[20];
  end;

  persona = record
    
  end;
