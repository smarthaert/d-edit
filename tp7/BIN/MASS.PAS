 uses crt;
 const
     N = 6;
 var a: array [1..N] of integer;
     b: array [1..N] of integer;
     c: array [1..N] of integer;

     i,j,count,temp: integer;
Begin
ClrScr;
For i:=1 to N do
 begin
  writeln('vvedite element');
  readln(a[i])
 end;

For i:=1 to N do
 begin
  write(a[i],' ');
 end;


For i:=1 to N do
 begin
  count := 1;
  For j:=1 to N do begin
   if (a[i] > a[j]) then count:= count+1;
    b[i]:=count
   end;
 end;

For i:=1 to N do
 begin
    c[b[i]]:=a[i];
 end;

 writeln;

For i:=1 to N do
 begin
  write(c[i],' ');
 end;

readln;
End.