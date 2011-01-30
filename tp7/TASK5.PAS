Uses TaskUnit;

{ ---=== Глобальные переменные ===--- }
 Var M : Array [1..1000] of TPoint;
     _Type,SortType : Word;
     A : TLine;

{ ---=== Ввод исходных данных ===--- }
 Procedure InputData;
   Var I:Word; MNum:Word;
   Begin
     Assign(Input,'INPUT.TXT');
     Reset(Input);
    { Линия A }
     Read(A.A); Read(A.B); Read(A.C);
    { Прямые }
     Read(MNum);
     For I:=1 to MNum do
       Begin Read(M[I].X); Read(M[I].Y); End;
     InitLenArray(MNum);
    { Тип задания }
     ReadCountLenTaskType(SortType,_Type,B,C);
     Close(Input);
   End;

{ ---=== Подсчет расстояний ===--- }
 Procedure CountLen;
   Var I:Word;
   Begin
     For I:=1 to LenNum do
       LenArray^[I].Len := LineToPoint(A,M[I]);
   End;

{ ---=== Вывод данных ===--- }
 Procedure OutputData;
   Var Temp:Word;
   Begin
     Assign(Output,'OUTPUT.TXT');
     Rewrite(Output);
     Case SortType of
       1: { Возрастание расстояний }
         Repeat
           Temp:=GetMin;
           If Temp<>0 then
             With M[Temp] do
               Begin
                 Writeln('(',X:0:7,',',Y:0:7,')');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
       2: { Убывание расстояний }
         Repeat
           Temp:=GetMax;
           If Temp<>0 then
             With M[Temp] do
               Begin
                 Writeln('(',X:0:7,',',Y:0:7,')');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
     End;
     Close(Output);
   End;

{ ---=== Основная программа ===--- }
Begin
  InputData;
  CountLen;
  Work(_Type);
  OutputData;
  DoneLenArray;
End.
{
INPUT.TXT
0 1 1
2
1 1
2 2
1
4 0
}