Uses CRT;

Var Map : Array [1..100,1..100] of Byte;
    N,M : Integer;

{ Вывод на экран шахматного поля }
Procedure ShowMap( X,Y:Byte{текущая позиция коня} );
  Var I,J:Byte;
  Begin
    For I:=1 to N do
      For J:=1 to M do
        Begin
          GotoXY(I,J);
          If ((I=X) And (J=Y)) then TextColor(11);
          Write(Map[I,J]);
          If ((I=X) And (J=Y)) then TextColor(7);
        End;
    ReadKey;
  End;

{ Получено ли решение ? }
Var Solve : Boolean;

{ Очередной ход коня }
Procedure NewMove( X,Y,Step:Integer );
  Begin
    If Solve then Exit; { Если решение уже получено -> Делать нечего }
   { Проверка на выход за пределы поля }
    If ((X < 1) Or (Y < 1) Or (X > N) Or (Y > M)) then Exit;
    If Map[X,Y] = 1 then Exit; { Если мы здесь уже были ? }
    If Map[X,Y] = 2 then { Если это начальная клетка ? }
      Begin
        If Step > N*M then Begin Solve:=True; Exit; End; { Hайдено решение ! }
        If Step > 1 then Exit; { Если не превый ход ! }
      End
    Else
      Map[X,Y] := 1; { Отмечаем пройденные клетки }
    ShowMap(X,Y); { Показываем карту }
    NewMove(X+2,Y+1,Step+1); { Лошадью ходи, лошадью ! }
    NewMove(X+2,Y-1,Step+1);
    NewMove(X-2,Y+1,Step+1);
    NewMove(X-2,Y-1,Step+1);
    NewMove(X+1,Y+2,Step+1);
    NewMove(X-1,Y+2,Step+1);
    NewMove(X+1,Y-2,Step+1);
    NewMove(X-1,Y-2,Step+1);
    Map[X,Y] := 0; { Разотмечаем обратно }
  End;

Begin
  ClrScr;
  Randomize;
  Solve := False;
  N := 4;
  M := 4;
  Map[1,1] := 2;
  NewMove(1,1,1);
  GotoXY(20,1);
  Writeln('Solve ',Solve);
End.