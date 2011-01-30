Uses CRT;
Type arr10x10 = array [1..10,1..10] of integer;
Var a:arr10x10;
i,j:byte;

Function NumStrMinIn2dArr (inarr:arr10x10):byte;
         Var num,i,j:byte;
         buf:integer;
         Begin
         buf:=a[1,1];num:=1;
         For i:=1 To 10 Do
         For j:=1 To 10 Do
         If buf>inarr[i,j] then Begin buf:=inarr[i,j];num:=i; End;
         NumStrMinIn2dArr:=num;
         End;

Begin
Randomize;ClrScr;
For i:=1 To 10 Do
For j:=1 To 10 Do
Begin
a[i,j]:=Random(MaxInt);
Write('a[',i:2,',',j:2,']=',a[i,j]:6,' ');
End;
Writeln;
Write('NumStrMinIn2dArr(a)=',NumStrMinIn2dArr(a));Readln;
End.