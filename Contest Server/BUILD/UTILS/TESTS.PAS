{ >>> Программа генерирования тестов <<< }
Uses Tools;

Function Select:Byte;
  Var Temp:Byte;
  Begin
    Write(' Выберите тип тестов : ');
    Readln(Temp);
    Select:=Temp;
  End;

{ ---=== Случайные числа в диапазоне [0..N] ===--- }
 Function LongRandom( N:LongInt ):LongInt;
   Var A,B,C:Real;
   Begin
     A:=Random($0FFFF); B:=Random($0FFFF); C:=$0FFFF;
     LongRandom:=Round((A*B*N)/(C*C));
   End;

Var T:Text; Test:Byte;

Procedure OpenFile;
  Begin
    Assign(T,'INPUT'+AddNumStr(Test,'0',2)+'.TXT');
    Rewrite(T);
  End;

Var Tests:Byte; Max,MinN,MaxN,Num,Count:LongInt;
Begin
  MkDir('TEMPTEST');
  ChDir('TEMPTEST');
  Randomize;
  Writeln('>>> Программа генерирования тестов <<<');
  Write('Введите количество тестов : '); Readln(Tests);
 { Основное меню }
  Writeln(' 1. Первое число - Количество чисел, Далее - Целые числа');
  Writeln(' 2. Фиксированное число чисел в файле (числа - целые)');
  Case Select of
   1: { Первое число - Количество чисел, Далее - Целые числа }
    Begin
      Write('Максимальное количество чисел : '); Readln(Max);
      Write('Минимальное возможное число : '); Readln(MinN);
      Write('Максимальное возможное число : '); Readln(MaxN);
      For Test:=1 to Tests do
        Begin
          OpenFile;
          Num:=1+Random(Max);
          Writeln(T,Num);
          For Count:=1 to Num do
            Writeln(T,MinN+LongRandom(MaxN-MinN+1));
          Close(T);
        End;
    End;
   2: { Одно число в файле }
    Begin
      Write('Количество чисел : '); Readln(Num);
      Write('Минимальное возможное число : '); Readln(MinN);
      Write('Максимальное возможное число : '); Readln(MaxN);
      For Test:=1 to Tests do
        Begin
          OpenFile;
          For Count:=1 to Num do
            Writeln(T,MinN+LongRandom(MaxN-MinN+1));
          Close(T);
        End;
    End;
  End;
  ChDir('..');
End.







