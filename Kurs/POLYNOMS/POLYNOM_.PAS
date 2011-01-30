Unit Polynom_;

Interface

  Uses Polynoms;

  Var Q:Text;

 { = = = Действительное Число Как Строка = = = }
  Function Real_As_String( R:Real_Type ):String;

 { = = = Комплексное Число Как Строка = = = }
  Function Complex_As_String( C:Complex ):String;

 { = = = Вывод Полинома на Экран = = = }
  Procedure Show_Polynom( P:Polynom );

 { = = = Вывод Массива Действительных Чисел = = = }
  Procedure Show_Array( P:Array_Of_Real );

 { = = = Вывод Полинома на Экран = = = }
  Procedure _Show_Polynom( P:Polynom );

 { = = = Вывод Массива Действительных Чисел = = = }
  Procedure _Show_Array( P:Array_Of_Real );

Implementation

{ = = = Действительное Число Как Строка = = = }
Function Real_As_String( R:Real_Type ):String;
  Var Result:String;
  Begin
    Str(R:0:0,Result);
    Real_As_String:=Result;
  End;

{ = = = Комплексное Число Как Строка = = = }
Function Complex_As_String( C:Complex ):String;
  Var Result:String;
  Begin
    Result:=Real_As_String(C^.Re);
    If C^.Im>0 then Result:=Result+'+'+Real_As_String(C^.Im)+'i';
    If C^.Im<0 then Result:=Result+Real_As_String(C^.Im)+'i';
    Complex_As_String:=Result;
  End;

{ = = = Вывод Полинома на Экран = = = }
Procedure Show_Polynom( P:Polynom );
  Var I:Word;
  Begin
    Write('Polynom :  Deg = ',P^.Deg,'	Coef : ');
    For I:=P^.Deg downto 0 do Write(P^.G(I):0:4,'; ');
    Writeln;
  End;

{ = = = Вывод Массива Действительных Чисел = = = }
Procedure Show_Array( P:Array_Of_Real );
  Var I:Word;
  Begin
    Write(' Array : ');
    For I:=1 to P^.Num do Write(P^.G(I):0:8,'; ');
    Writeln;
  End;

{ = = = Вывод Полинома на Экран = = = }
Procedure _Show_Polynom( P:Polynom );
  Var I:Word;
  Begin
    Write(Q,'P:  Deg = ',P^.Deg,'  Coef : ');
    For I:=P^.Deg downto 0 do Write(Q,P^.G(I):0:4,'; ');
  End;

{ = = = Вывод Массива Действительных Чисел = = = }
Procedure _Show_Array( P:Array_Of_Real );
  Var I:Word;
  Begin
    Write(Q,'A: ');
    For I:=1 to P^.Num do Write(Q,P^.G(I):0:8,'; ');
  End;

End.