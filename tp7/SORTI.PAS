var
  Num,i,j,Temp : integer;
  A : array [1..100] of integer;
begin
  Write('Num = ');
  ReadLn(Num);
  for i:=1 to Num do begin
    Write('A[',i,'] = '); ReadLn(A[i]);
  end;
  for i:=1 to Num do
    for j:=1 to Num do
      if A[i] < A[j] then begin
        Temp := A[j];
        A[j] := A[i];
        A[i] := Temp;
      end;
  for i:=1 to Num do
    Writeln(A[i]);
end.