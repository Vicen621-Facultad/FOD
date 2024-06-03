program ejer10;

const
  VALOR_ALTO = 9999;

type
  venta = record
    categoria, marca, modelo, cant: integer;
  end;

  archivo = file of venta;

procedure leer(var arch: archivo; var v: venta);
begin
  if (not eof(arch)) then
    read(arch, v)
  else
    v.categoria := VALOR_ALTO;
end;

procedure corteControl(var arch: archivo; var txt: Text);
var
  v, actual: venta;
  total_cat, total_marca, total_modelo: integer;
begin
  Reset(arch);
  Rewrite(txt);

  leer(arch, v);

  while (v.categoria <> VALOR_ALTO) do begin
    actual.categoria := v.categoria;
    total_cat := 0;

    while (actual.categoria = v.categoria) do begin
      actual.marca := v.marca;
      total_marca := 0;

      while (actual.categoria = v.categoria) and (actual.marca = v.marca) do begin
        actual.modelo := v.modelo;
        total_modelo := 0;

        while (actual.categoria = v.categoria) and (actual.marca = v.marca) and (actual.modelo = v.modelo) do begin
          total_modelo := total_modelo + v.cant;
          leer(arch, v);
        end;

        WriteLn(txt, '        ', actual.modelo, ': ', total_modelo);
        total_marca := total_marca + total_modelo;
      end;

      WriteLn(txt, '    ', actual.marca, ': ', total_marca);
      total_cat := total_cat + total_marca;
    end;
      WriteLn(txt, actual.categoria, ': ', total_cat);
  end;

  Close(arch);
  Close(txt);
end;

var
  txt: Text;
  arch: archivo;
begin
  Assign(txt, 'data.txt');
  Assign(arch, 'archivo.dat');
  corteControl(arch, txt);
end.