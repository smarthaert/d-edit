{ * MATH.PAS - ������ ��⥬���᪨� ����樨 * }
Unit Math;

Interface

{$N+} { 8087 mode on :) }
Type Real = Double; { ��� �᪮७�� ���⮢ }
Function Tan( X:Real ):Real; { ������� }

Implementation

Function Tan( X:Real ):Real; { ������� }
  Begin
    Tan:=Sin(x)/Cos(X);
  End;

End.