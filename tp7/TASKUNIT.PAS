{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                  С п б Г Э Т У   А С О И У                    │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }
Unit TaskUnit;

Interface

{ ---=== Максимальное число типа Real ===--- }
 Const MaxReal = 1.7e38;

{ ---=== Точка ===--- }
 Type TPoint = Record
        X,Y : Real;
      End;

{ ---=== Прямая ===--- }
 Type TLine = Record
        A,B,C : Real;
      End;

{ ---=== Список длин ===--- }
 Type TLen = Record Len:Real; Present:Boolean; End;
      TLenArray = Array [1..$0FFFF div SizeOf(TLen)] of TLen;
      PLenArray = ^TLenArray;

 Var LenArray : PLenArray;
     LenNum : Word;

 Procedure InitLenArray( _LenNum_:Word );
 Procedure DoneLenArray;

{ ---=== Границы ===--- }
 Var B,C : Real;

{ ---=== Расстояние от точки до прямой ===--- }
 Function LineToPoint( Line:TLine; Point:TPoint ):Real;

{ ---=== Расстояние от точки до точки ===--- }
 Function PointToPoint( Point1,Point2:TPoint ):Real;

{ ---=== Прочитать тип задания (Задания на подсчет длины) ===--- }
 Procedure ReadCountLenTaskType( Var SortType,_Type:Word; Var B,C:Real );

{ ---=== Выбор минимального ===--- }
 Function GetMin : Word;

{ ---=== Выбор максимального ===--- }
 Function GetMax : Word;

{ ---=== Отбор длин ===--- }
 Procedure Work( _Type_:Word );
 
Implementation

{ ---=== Список длин ===--- }
 Procedure InitLenArray( _LenNum_:Word );
   Begin
     LenNum:=_LenNum_;
     GetMem(LenArray,LenNum*SizeOf(TLen));
   End;

 Procedure DoneLenArray;
   Begin
     FreeMem(LenArray,LenNum*SizeOf(TLen));
   End;

{ ---=== Расстояние от точки до прямой ===--- }
 Function LineToPoint( Line:TLine; Point:TPoint ):Real;
   Begin
     LineToPoint:=(Line.A*Point.X+Line.B*Point.Y+Line.C) /
                   Sqrt(Sqr(Line.A)+Sqr(Line.B));
   End;

{ ---=== Расстояние от точки до точки ===--- }
 Function PointToPoint( Point1,Point2:TPoint ):Real;
   Begin
     PointToPoint:=Sqrt(Sqr(Point1.X-Point2.X)+Sqr(Point1.X-Point2.X));
   End;

{ ---=== Прочитать тип задания (Задания на подсчет длины) ===--- }
 Procedure ReadCountLenTaskType( Var SortType,_Type:Word; Var B,C:Real );
   Begin
     Read(SortType);
     Read(_Type);
     Case _Type of
       3: Read(B); { Меньше заданной величины }
       4: Read(B); { Больше заданной величины }
       5: Begin Read(B); Read(C); End; { Принадлежит заданному интервалу }
       6: Begin Read(B); Read(C); End; { Лежит вне заданного интервала }
     End;
   End;

{ ---=== Выбор минимального ===--- }
 Function GetMin : Word;
   Var I:Word; MinR:Real;
   Begin
     GetMin:=0;
     MinR:=MaxReal;
     For I:=1 to LenNum do
       If (LenArray^[I].Present And (LenArray^[I].Len < MinR)) then
         Begin
           MinR:=LenArray^[I].Len;
           GetMin:=I;
         End;
   End;

{ ---=== Выбор максимального ===--- }
 Function GetMax : Word;
   Var I:Word; MaxR:Real;
   Begin
     GetMax:=0;
     MaxR:=-MaxReal;
     For I:=1 to LenNum do
       If (LenArray^[I].Present And (LenArray^[I].Len > MaxR)) then
         Begin
           MaxR:=LenArray^[I].Len;
           GetMax:=I;
         End;
   End;

{ ---=== Отбор длин ===--- }
 Procedure Work( _Type_:Word );
   Var I,Temp:Word;
   Begin
     Case _Type_ of
       1: { Наименьшее }
         Begin
           For I:=1 to LenNum do LenArray^[I].Present:=True;
           Temp:=GetMin; LenArray^[Temp].Present:=False; B:=LenArray^[Temp].Len;
           While (LenArray^[GetMin].Len = B) do LenArray^[GetMin].Present:=False;
           For I:=1 to LenNum do LenArray^[I].Present:=Not LenArray^[I].Present;
         End;
       2: { Наибольшее }
         Begin
           For I:=1 to LenNum do LenArray^[I].Present:=True;
           Temp:=GetMax; LenArray^[Temp].Present:=False; B:=LenArray^[Temp].Len;
           While (LenArray^[GetMax].Len = B) do LenArray^[GetMax].Present:=False;
           For I:=1 to LenNum do LenArray^[I].Present:=Not LenArray^[I].Present;
         End;
       3: { Меньше заданной величины }
         For I:=1 to LenNum do LenArray^[I].Present := (LenArray^[I].Len < B);
       4: { Больше заданной величины }
         For I:=1 to LenNum do LenArray^[I].Present := (LenArray^[I].Len > B);
       5: { Принадлежит заданному интервалу }
         For I:=1 to LenNum do LenArray^[I].Present := ((LenArray^[I].Len > B) And (LenArray^[I].Len < C));
       6: { Лежит вне заданного интервала }
         For I:=1 to LenNum do LenArray^[I].Present := ((LenArray^[I].Len < B) Or (LenArray^[I].Len > C));
     End;
   End;

End.
