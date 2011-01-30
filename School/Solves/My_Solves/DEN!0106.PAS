var a: array[0..49] of 0..9;
    n, i, j:0..50;
    p: byte;  {число "в уме"}
begin
  readln(n);
  {будем записывать цифры в массив так, чтобы номер ячейки совпадал со степенью десятки в данном разряде}
  for i:=n-1 downto 0 do readln(a[i]);
  while n>1 do
    begin
      p:=a[n-1];  {вычеркиваемая цифра}
	 dec(n);
      j:=0;       {позиция в числе}
      while p>0 do
        begin
          p:=p+a[j];
          a[j]:=p mod 10;
          p:=p div 10;
          inc(j);
          if (j>n-1) and (p>0) {а вдруг мы вылезли }
            then begin         {за пределы числа}
                   a[j]:=0;
                   n:=j+1; 
                 end;
        end;
      for i:=n-1 downto 0 do write(a[j]);
      writeln;
    end;
end.
