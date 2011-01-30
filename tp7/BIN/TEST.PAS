var T : set of Byte;
  i : integer;
begin
  T := T + [2] + [3];
  T := T - [3];
  T := T - [2];
  writeln( T = [] );
  for i:=low(Byte) to High(Byte) do
    if i in T then
      write(' ',i);
  writeln;
end.