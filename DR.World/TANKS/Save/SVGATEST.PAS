Uses DOS,CRT;

Var R:Registers;
    A:Array [1..$FFFF] of Byte Absolute $A000:$0000;
    I:Integer;
Begin
  R.AX := $4F02;
  R.BX := $0101;
  Intr($10,R);
  Mem[$A000:$1000] := 15;
  For I:=639 to 1281 do A[I]:=15;
  R.AX := $4F05;
  R.BX := $0000;
  R.DX := $0005;
  Intr($10,R);
  For I:=1 to 641 do A[I]:=15;
  ReadKey;
End.