{Corte de control}
{https://github.com/MatiasGuaymas/FOD/blob/main/Parciales/Enunciados/Archivos/Archivos%20Enunciados.docx}
program parcial4;

const
  VALOR_ALTO = 9999;

type
  venta = record
    sucursal, autor, isbn, ejemplar: integer;
  end;

  archivo = file of venta;

procedure crearArchivo(var mae: archivo);
var
    txt: text;
    info: venta;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(mae, 'ventas.dat');
    rewrite(mae);
    while(not eof(txt)) do begin
      with info do begin
        readln(txt, sucursal, autor, isbn, ejemplar);
        write(mae, info);
      end;
    end;
    writeln('Archivo binario creado');
    close(txt);
    close(mae);
end;

procedure leer(var arch: archivo; var v: venta);
begin
  if (not eof(arch)) then
    read(arch, v)
  else
    v.sucursal := VALOR_ALTO;
end;

procedure corteControl(var arch: archivo; nombre: String);
var
  txt: Text;
  v, actual: venta;
  cant_total, cant_suc, cant_autor, cant_isbn: integer; 
begin
  Assign(txt, nombre);
  Reset(arch);
  Rewrite(txt);
  cant_total := 0;

  leer(arch, v);
  while (v.sucursal <> VALOR_ALTO) do begin
    actual.sucursal := v.sucursal;
    cant_suc := 0;

    WriteLn(txt, 'Codigo de sucursal: ', actual.sucursal);

    while (actual.sucursal = v.sucursal) do begin
      actual.autor := v.autor;
      cant_autor := 0;
      
      WriteLn(txt, '    Codigo de autor: ', actual.autor);

      while (actual.sucursal = v.sucursal) and (actual.autor = v.autor) do begin
        actual.isbn := v.isbn;
        cant_isbn := 0;

        while (actual.sucursal = v.sucursal) and (actual.autor = v.autor) and (actual.isbn = v.isbn) do begin
          cant_isbn := cant_isbn + 1;
          leer(arch, v);
        end;

        WriteLn(txt, '        ISBN: ', actual.isbn, '. Total de ejemplares vendidos del libro: ', cant_isbn);
        cant_autor := cant_autor + cant_isbn;
      end;

      WriteLn(txt, '    Total de ejemplares vendidos del autor: ', cant_autor);
      cant_suc := cant_suc + cant_autor;
    end;

    WriteLn(txt, 'Total de ejemplares vendidos en la sucursal: ', cant_suc);
    cant_total := cant_total + cant_suc;
  end;

  WriteLn(txt, 'TOTAL GENERAL DE EJEMPLARES VENDIDOS EN CADENA: ', cant_total);

  Close(arch);
  Close(txt);
end;

var
  arch: archivo;
begin
  Assign(arch, 'ventas.dat');
  corteControl(arch, 'ventas.txt');
end.