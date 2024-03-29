Uses CRT;

Var Map : Array [1..100,1..100] of Byte;
    N,M : Integer;

{ �뢮� �� ��࠭ �嬠⭮�� ���� }
Procedure ShowMap( X,Y:Byte{⥪��� ������ ����} );
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

{ ����祭� �� �襭�� ? }
Var Solve : Boolean;

{ ��।��� 室 ���� }
Procedure NewMove( X,Y,Step:Integer );
  Begin
    If Solve then Exit; { �᫨ �襭�� 㦥 ����祭� -> ������ ��祣� }
   { �஢�ઠ �� ��室 �� �।��� ���� }
    If ((X < 1) Or (Y < 1) Or (X > N) Or (Y > M)) then Exit;
    If Map[X,Y] = 1 then Exit; { �᫨ �� ����� 㦥 �뫨 ? }
    If Map[X,Y] = 2 then { �᫨ �� ��砫쭠� ���⪠ ? }
      Begin
        If Step > N*M then Begin Solve:=True; Exit; End; { H������ �襭�� ! }
        If Step > 1 then Exit; { �᫨ �� �ॢ� 室 ! }
      End
    Else
      Map[X,Y] := 1; { �⬥砥� �ன����� ���⪨ }
    ShowMap(X,Y); { �����뢠�� ����� }
    NewMove(X+2,Y+1,Step+1); { ��蠤�� 室�, ��蠤�� ! }
    NewMove(X+2,Y-1,Step+1);
    NewMove(X-2,Y+1,Step+1);
    NewMove(X-2,Y-1,Step+1);
    NewMove(X+1,Y+2,Step+1);
    NewMove(X-1,Y+2,Step+1);
    NewMove(X+1,Y-2,Step+1);
    NewMove(X-1,Y-2,Step+1);
    Map[X,Y] := 0; { ����⬥砥� ���⭮ }
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