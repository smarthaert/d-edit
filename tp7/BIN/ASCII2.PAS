{ Вывод ASCII-таблицы символов в файл }
var i:integer;
begin
  writeln('Write to "ASCII.txt"...');
  assign(output,'ASCII.txt');
  rewrite(output);
  for i:=32 to 255 do begin
    write(i, ' ',chr(i),'  ');
    if (i-31) mod 23 = 0 then
      writeln;
  end;
  close(output);
end.


