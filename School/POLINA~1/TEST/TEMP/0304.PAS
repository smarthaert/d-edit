var s: string;
    m, i, k, c: integer;
begin
  readln(m);
  for i:=1 to 255 do s:=s+' ';
  for i:=1 to m do
    begin
      readln(k);
      c:=1;
      while s[c] <> ' ' do inc(c);
      s[c]:='(';
      s[c + k + 1]:=')';
    end;
  c:=1;
  while s[c] <> ' ' do inc(c);
  delete(s, c, length(s) - c + 1);
  writeln(s);
end.