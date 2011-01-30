Unit Fix;

Interface

Function FixMul(A,B:LongInt):LongInt;
Function FixSqr(A:LongInt):LongInt;
Function FixDiv(A,B:LongInt):LongInt;
Function FixSin(A:LongInt):LongInt;
Function FixCos(A:LongInt):LongInt;
Function FixAbs(A:LongInt):LongInt;
Function FixSQRT(A:LongInt):LongInt;

Procedure InitSinCos;
Function Real2Fix(R:Real):LongInt;
Function Fix2Real(F:LongInt):Real;
Function Int2Fix(I:Integer):LongInt;
Function Fix2Int(F:LongInt):Integer;

Var SinTable:Array [0..128] Of Integer;

Implementation

{$L Fix}

Function FixMul;External;
Function FixSqr;External;
Function FixDiv;External;
Function FixSin;External;
Function FixCos;External;
Function FixAbs;External;
Function FixSQRT;External;

Procedure InitSinCos;

Var I:Integer;

Begin
     For I:=0 To 128 Do
         SinTable[I]:=Round(Sin(I*Pi/64)*$200);
End;

Function Real2Fix;

Begin
     Real2Fix:=Round(R*$200);
End;

Function Fix2Real;

Begin
     Fix2Real:=F/$200;
End;

Function Int2Fix;

Begin
     Int2Fix:=LongInt(I)*$200;
End;

Function Fix2Int;

Begin
     Fix2Int:=F Div $200;
End;

End.