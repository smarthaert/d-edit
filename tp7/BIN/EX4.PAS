Uses CRT;
Type arr10x10 = array [1..10,1..10] of integer;
Var a:arr10x10;
i,j:byte;

Procedure PosMinIn2dArr (inarr:arr10x10);
          Var str,col,i,j:byte;
          buf:integer;
          Begin
          buf:=a[1,1];str:=1;col:=1;
          For i:=1 To 10 Do
          For j:=1 To 10 Do
          If buf>inarr[i,j] then Begin buf:=inarr[i,j];str:=i;col:=j; End;
          Writeln('MuHuMaJIbHbIu 3JIeMeHT:');
          Writeln('CTPoKa ',str);
          Writeln('CToJI6eu, ',col);
          End;

Begin
Randomize;ClrScr;{O4ucTKa 3KPaHa}
{3anucb 4uceJI B MaccuB}
For i:=1 To 10 Do
For j:=1 To 10 Do
Begin
a[i,j]:=Random(MaxInt);
Write('a[',i:2,',',j:2,']=',a[i,j]:6,' ');
End;
{\\\\\\\\\\\\\\\\\\\\\\}
Writeln;
PosMinIn2dArr(a);Readln;
End.