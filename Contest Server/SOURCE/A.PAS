{  Задача A (Наибольший общий делитель)  }
{ ====================================== }
Var A : Array [1..10] of LongInt;
    NOD,Max : LongInt;
    N,I,NumMax1,NumMax2 : Byte;
    T : Text;
Begin
 { Ввод данных }
  Assign(T,'INPUT.TXT');
  Reset(T);
  Readln(T,N);
  For I:=1 to N do
    Readln(T,A[I]);
  Close(T);
 { Нахождение НОД методом Евклида }
  Repeat
   { Находим максимальный член последовательности }
    Max:=-1;
    For I:=1 to N do
      If A[I] > Max then
        Begin
          Max:=A[I];
          NumMax1:=I;
        End;
   { Находим второй по величине член последовательности }
    Max:=-1;
    For I:=1 to N do
      If ((A[I] > Max) And (I <> NumMax1)) then
        Begin
          Max:=A[I];
          NumMax2:=I;
        End;
   { Вычитаем }
    A[NumMax1]:=A[NumMax1] - A[NumMax2];
  Until A[NumMax2]=0;
  NOD:=A[NumMax1];
 { Вывод результата }
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  Writeln(T,NOD);
  Close(T);
End.

