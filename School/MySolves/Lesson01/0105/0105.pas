var n, dec : longint;  { � ��६����� dec �࠭���� k-�� �⥯��� ����⪨ }
    A, k, p, i: integer;  { p - ������⢮ k-������ �ᥫ }
begin
  readln(n);
  k:=1;
  dec:=10;
  p:=10;
 
  while p >= n do
    begin
      n:=n-p;                { 㬥��蠥� �� }
      inc(k);                   { k - �᫮ ��� � �᫠� � }
      dec:=dec*10;              { ��砫� �鸞}
      p:=dec - dec div 10;
    end;  
  
  A := n div k + dec div 10;
  
  dec := 1;
  for i:= 1 to k - n mod k do dec:=dec*10;
 { ����塞 10k - n mod k }       
  writeln((A mod dec) div (dec*10));
end.
