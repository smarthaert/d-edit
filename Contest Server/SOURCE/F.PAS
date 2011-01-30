{  Задача F (Длинная арифметика)  }
{ =============================== }
Var T:Text; Result:String; N,I:Word;
Begin
  Assign(T,'INPUT.TXT');
  Reset(T);
  Readln(T,Result);
  Close(T);
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  Repeat
   { Одно действие }
    N:=Ord(Result[1])-Ord('0');
    Result[1]:='0';
    I:=Length(Result);
    While N > 0 do
      Begin
        N:=N+(Ord(Result[I])-Ord('0'));
        Result[I]:=Chr((N mod 10)+Ord('0'));
        N:=N div 10;
        Dec(I);
      End;
    While Result[1]='0' do Result:=Copy(Result,2,Length(Result)-1);
    Writeln(T,Result);
  Until Length(Result)=1;
  Close(T);
End.