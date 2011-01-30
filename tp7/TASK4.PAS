{$DEFINE FileIO}
Uses TaskUnit;

{ ---=== Вывод задания ===--- }
 Procedure WriteTask;
   Begin
     Writeln('Из множества прямых M, заданных коэфициентами уравнения A*X + B*Y + C*Z,');
     Writeln('сформировать множество прямых P, расстояние от которых до точки A(Xa,Ya)');
     Writeln('удоветвлетворяет пеееннму условию, и преобразовать множество P');
     Writeln('в соответствии с заданным требованием.');
   End;

{ ---=== Глобальные переменные ===--- }
 Var M : Array [1..1000] of TLine;
     _Type,SortType : Word;
     A : TPoint;

{ ---=== Ввод исходных данных ===--- }
 Procedure InputData;
   Var I:Word; MNum:Word;
   Begin
     Assign(Input,'INPUT.TXT');
     Reset(Input);
    { Точка A }
     Read(A.X); Read(A.Y);
    { Прямые }
     Read(MNum);
     For I:=1 to MNum do
       Begin Read(M[I].A); Read(M[I].B); Read(M[I].C); End;
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
       LenArray^[I].Len := LineToPoint(M[I],A);
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
                 Writeln(A:0:7,' * X + ',B:0:7,' * Y + ',C:0:7,' = 0');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
       2: { Убывание расстояний }
         Repeat
           Temp:=GetMax;
           If Temp<>0 then
             With M[Temp] do
               Begin
                 Writeln(A:0:7,' * X + ',B:0:7,' * Y + ',C:0:7,' = 0');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
     End;
     Close(Output);
   End;

{ ---=== Основная программа ===--- }
Begin
  WriteTask;
  InputData;
  CountLen;
  Work(_Type);
  OutputData;
  DoneLenArray;
End.

{
INPUT.TXT
1 1
3
0 1 1
0 1 2
0 1 3
1
1 2
}