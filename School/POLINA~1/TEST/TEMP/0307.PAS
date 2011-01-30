var
  a: array[0..1, 1..100] of integer;
  m, x, pos: array[0..1] of integer;
  n, dim, i, j: integer;
begin
  readln(n);
  for i:=0 to 1 do
    begin
      readln(m[i]);
      for j:=1 to m[i] do readln(a[i,j]);
    end;

  x[0]:=0;
  x[1]:=0;

  dim:=0;
  pos[0]:=0;
  pos[1]:=0;

  for i:=1 to m[0] + m[1] do
    begin
      inc(pos[dim]);
      for j:= 1 to a[dim, pos[dim]]
        do begin
             inc(x[dim]);
             writeln(x[0], ' ' , x[1]);
           end;
      dim:= 1 - dim;
    end;
end.