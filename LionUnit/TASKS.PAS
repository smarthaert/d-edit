Unit Tasks;

{$N+}

Interface

 Uses CRT;

 { - Функция конвертирует число в строку (LongInt->String) - }
  Function Int2Str( L:LongInt ):String;

  Var FTemp,FNumVar,FSeria,FData,FAnswer:Text;
      NumTask,NumVar:LongInt;
      DataFName,AnswerFName:String;
      Seria:LongInt;

  Procedure InitSystem;
  Procedure CloseSystem;

  Function NOD( A,B:LongInt ):LongInt;

 { - Генерация целого числа на отрезке [A,B] - }
  Function RND( A,B:LongInt ):LongInt;

 { - Подсчет количества определенных символов с строке - }
  Function Count( C:Char; S:String ):Byte;

 { - Десятичное число в другой системе счисления - }
  Function Conv( ConvBase,Num:LongInt ):String;

Implementation

{ - Функция конвертирует число в строку (LongInt->String) - }
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
   End;

 Procedure InitSystem;
   Begin
     TextColor(7); Writeln; Writeln;
    { Hомера задания в общем списке }
     Assign(FTemp,'temp.txt');
    {$I-} Reset(FTemp); {$I+}
     If IOResult=0 then Readln(FTemp,NumTask) Else NumTask:=1;
     Rewrite(FTemp); Writeln(FTemp,NumTask+1); Close(FTemp);
    { Hомер серии }
     Assign(FSeria,'Seria.txt');
    {$I-} Reset(FSeria); {$I+}
     If IOResult=0 then
       Begin Readln(FSeria,Seria); Close(FSeria); End
       Else Seria:=01012001;
     RandSeed:=Seria;
    { Чтение количества вариантов }
     Assign(FNumVar,'NumVar.tex');
    {$I-} Reset(FNumVar); {$I+}
     If IOResult=0 then
       Begin Readln(FNumVar,NumVar); Close(FNumVar); End
     Else
       NumVar:=20;
     Writeln('Число вариантов -> ',NumVar);
    { Открытие файла данных и файла ответов }
     DataFName:='Data'+Int2Str(NumTask)+'.tex';
     AnswerFName:='Answer'+Int2Str(NumTask)+'.tex';
     Writeln('Файл данных: ',DataFName);
     Writeln('Файл ответов: ',AnswerFName);
     Assign(FData,DataFName); Rewrite(FData);
     Assign(FAnswer,AnswerFName); Rewrite(FAnswer);
   End;

 Procedure CloseSystem;
   Begin
    { Закрытие файлов и выход }
     Close(FData); Close(FAnswer);
     TextColor(Green); Writeln('Генератор N ',NumTask,' отработал');
     TextColor(7); Writeln;
   End;

 Function NOD( A,B:LongInt ):LongInt;
   Var X,Y:LongInt;
   Begin
     X:=A; Y:=B;
     Repeat
       If X > Y then X:=X mod Y Else Y:=Y mod X;
     Until (X=0) Or (Y=0);
     If X=0 then NOD:=Y;
     If Y=0 then NOD:=X;
   End;

 Function RND( A,B:LongInt ):LongInt;
   Begin
     RND:=A+Random(B-A+1);
   End;

{ - Подсчет количества определенных символов с строке - }
Function Count( C:Char; S:String ):Byte;
  Var Cn,I:Byte;
  Begin
    Cn:=0;
    For I:=1 to Length(S) do If S[I]=C then Inc(Cn);
    Count:=Cn;
  End;

{ - Десятичное число в другой системе счисления - }
Function Conv( ConvBase,Num:LongInt ):String;
  Var N:LongInt; Res,S:String;
  Begin
    N:=Num;
    Res:='';
    While N > 0 do
      Begin
        Str(N mod ConvBase,S);
        Res:=S+Res;
        N:=N div ConvBase;
      End;
    If Res = '' then Res:='0';
    Conv:=Res;
  End;

End.