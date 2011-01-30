{ * MATH.PAS - Базовые математические операции * }
Unit Math;

Interface

{$N+} { 8087 mode on :) }
Type Real = Double; { Для ускорения расчетов }
Function Tan( X:Real ):Real; { Тангенс }

Implementation

Function Tan( X:Real ):Real; { Тангенс }
  Begin
    Tan:=Sin(x)/Cos(X);
  End;

End.