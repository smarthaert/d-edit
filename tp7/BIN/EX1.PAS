Uses CRT;
Type arr10 = array [1..10] of integer;
Var a:arr10;
i:byte;

Function MaxInArr (inarr:arr10):integer;
         Var buf:integer;
             i:byte;
         Begin
         buf:=inarr[1];
         For i:=2 To 10 Do
         If buf<inarr[i] then buf:=inarr[i];
         MaxInArr:=buf;
         End;

Begin
Randomize;ClrScr;
For i:=1 To 10 Do
Begin
a[i]:=Random(MaxInt);
Writeln('a[',i:2,']=',a[i]:5);
End;
Writeln;
Write('MaxInArr(a)=',MaxInArr(a));Readln;
End.