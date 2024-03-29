{ ���ᯮ��㥬 Turbo Professional �� ������ ������ ;) }
Uses TPCRT,TPString,TPEdit,TPWindow;

{ ---=== ������� ⠡���� ===--- }
 Const MaxI = 10; MaxJ = 76;

{ ---=== ��� ������ (�᭮���� � �६�����) ===--- }
 Var Map : Array [1..MaxI,1..MaxJ] of Boolean; { ��� �� ���� ?! }
     TempMap : Array [1..MaxI,1..MaxJ] of Boolean;

{ ��������������������������������������������������������������������ѻ }
{ ��                           � �ணࠬ��                            �� }
{ ��������������������������������������������������������������������ϼ }

 Procedure About;
   Begin
     Writeln('>>> �᫨ ���� ��㣮� �� �������� �����, �������, �������� ! <<<');
     Writeln('ESC - ��室 �� �ணࠬ�� [Escape]');
     Writeln('��५�窨 - ��६�饭�� �� �����');
     Writeln('Enter - ������஢���� �����樥�� (�����襭�� ����� - Enter)');
     Writeln('N - ����⮦���� �������饩 � ᮧ����� ����� ������');
     Writeln('S - ���࠭���� ������ � ⥪�⮢�� 䠩� [Save]');
     Writeln('L - ����㧪� ������ �� ⥪�⮢��� 䠩�� [Load]');
     Writeln('R - ��� ����� [Run Life]');
     Writeln('C - ����� 蠣�� ����� ! (�� ������ ������)');
     Writeln('[!] This program was protected by Russian and International Laws [!]');
   End;

{ ��������������������������������������������������������������������ѻ }
{ ��                        ����� � ����楩                         �� }
{ ��������������������������������������������������������������������ϼ }

 Procedure NewTable;
   Var I,J:Word;
   Begin
     For I:=1 to MaxI do
       For J:=1 to MaxJ do
         Begin
           Map     [I,J] := False;
           TempMap [I,J] := Not Map[I,J];
         End;
   End;

 Procedure SaveTable;
   Var Window:WindowPtr; Escaped:Boolean;
       FileName:String; T:Text; I,J:Byte;
   Begin
     MakeWindow(Window,10,10,70,12,True,True,True,$07,$07,$07,
       ' ���࠭���� ������ � ⥪�⮢�� 䠩� ');
     DisplayWindow(Window);
     FileName := 'LIFE.TXT';
     ReadString('������ ��� 䠩��: ',
       11,12,20,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then
       Begin
         Assign(T,FileName);
        {$I-}
         Rewrite(T);
         If IOResult<>0 then
           Begin
             Write('[!!!]: �� ���� ᮧ���� 䠩� ! ������ ���� ������� ...'); ReadKey;
             KillWindow(Window); Close(T); Exit;
           End;
         For I:=1 to MaxI do
           Begin
             For J:=1 to MaxJ do
               Write(T,Ord(Map[I,J]));
             Writeln(T);
           End;
         Close(T);
        {$I+}
         Write('>>> ���࠭��� ! <<< ������ ���� ������� ...'); ReadKey;
       End;
     KillWindow(Window);
   End;
 Procedure LoadTable;
   Var Window:WindowPtr; Escaped:Boolean;
       FileName,S:String; T:Text; I,J:Byte;
   Begin
     MakeWindow(Window,10,10,70,12,True,True,True,$07,$07,$07,
       ' ����㧪� ������ �� ⥪�⮢��� 䠩�� ');
     DisplayWindow(Window);
     FileName := 'LIFE.TXT';
     ReadString('������ ��� 䠩��: ',
       11,12,20,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then
       Begin
         Assign(T,FileName);
        {$I-}
         Reset(T);
         If IOResult<>0 then
           Begin
             Write('[!!!]: �� ���� ������ 䠩� ! ������ ���� ������� ...'); ReadKey;
             KillWindow(Window); Close(T); Exit;
           End;
         For I:=1 to MaxI do
           Begin
             If IOResult<>0 then
               Begin
                 Write('[!!!]: �� ���� ������ 䠩� ! ������ ���� ������� ...'); ReadKey;
                 KillWindow(Window); Close(T); Exit;
               End;
             Readln(T,S);
             For J:=1 to MaxJ do
               Begin
                 Case S[J] of
                   '0': Map[I,J]:=False;
                   '1': Map[I,J]:=True;
                 End;
                 TempMap[I,J] := Not Map[I,J];
               End;
           End;
         Close(T);
        {$I+}
         Write('>>> ����㦥�� ! <<< ������ ���� ������� ...'); ReadKey;
       End;
     KillWindow(Window);
   End;

{ ��������������������������������������������������������������������ѻ }
{ ��                          ������ �����                          �� }
{ ��������������������������������������������������������������������ϼ }

{ �᫨ �������,�� ࠡ��� ᤥ���� �����, �� ���६���� �㤥� ��㤭�. }
{ � �᫨ �� ��� ��� ��㤭�, ����� �믮����� �� ��᮫�⭮ ����������. }

Procedure CopyMap;
  Var I,J:Word;
  Begin
    For I:=1 to MaxI do
      For J:=1 to MaxJ do
        TempMap[I,J] := Map[I,J];
  End;

Function Get( I,J:Integer ):Byte;
  Var A,B:Word;
  Begin
    A:=I; B:=J;
   { ��������� ��� � ���� �� }
    If A > MaxI then A := 1;
    If A < 1    then A := MaxI;
    If B > MaxJ then B := 1;
    If B < 1    then B := MaxJ;
   { ����蠥� ���祭�� }
    Get := Ord(TempMap[A,B]);
  End;

Procedure Life;
  Var Friends,I,J:Byte;
 Begin
   { - ���� �� �ᥬ ���⪠� - }
    For I:=1 to MaxI do
      For J:=1 to MaxJ do
        Begin
         { ������ ������⢠ �ᥤ�� }
          Friends:=Get(I-1,J-1)+Get(I,J-1)+Get(I+1,J-1)+Get(I+1,J)+
                   Get(I+1,J+1)+Get(I,J+1)+Get(I-1,J+1)+Get(I-1,J);
         { - �ࠢ��� ����� ! - }
         { ������ "�� �������⢠" :( }
          If Friends < 2 then Map[I,J]:=False;
         { ������ "�� �᭮��" :( }
          If Friends > 3 then Map[I,J]:=False;
         { �������� ����� ���⪨ ! :) }
          If Friends = 3 then Map[I,J]:=True;
        End;
End;

{ ��������������������������������������������������������������������ѻ }
{ ��                      �뢮� ������ �� ��࠭                      �� }
{ ��������������������������������������������������������������������ϼ }

 Var CurI, CurJ : Byte;

 Procedure Sym( I,J:Integer );
   Begin
     GotoXY(J,I);
     Case Map[I,J] of
       False: Write(' ');
       True:  Write('#');
     End;
   End;

 Procedure ShowTable;
   Var I,J:Integer;
   Begin
     For I:=1 to MaxI do
       For J:=1 to MaxJ do
         Begin
           If ((I=CurI) And (J=CurJ)) then
             TextAttr:=$70 Else TextAttr:=$07;
           Sym(I,J);
         End;
     TextAttr := $07;
     CopyMap;
   End;

{ ��������������������������������������������������������������������ѻ }
{ ��                           ���� ⠡����                           �� }
{ ��������������������������������������������������������������������ϼ }

 Procedure CursorMove;
   Begin
     Case ReadKey of
       #72: Dec(CurI);
       #75: Dec(CurJ);
       #77: Inc(CurJ);
       #80: Inc(CurI);
     End;
     If CurJ > MaxJ then CurJ:=1;
     If CurJ < 1    then CurJ:=MaxJ;
     If CurI > MaxI then CurI:=1;
     If CurI < 1    then CurI:=MaxI;
   End;

{ ---=== ������஢���� ������ ===--- }
 Procedure EditTable;
   Var Window:WindowPtr; Escaped:Boolean; Key:Char;
   Begin
     MakeWindow(Window,2,12,79,24,True,True,True,$07,$07,$07,
       ' ���� ����� ');
     DisplayWindow(Window);
     NewTable;
     CurI:=1; CurJ:=1; { ���砫� �� ��室���� � ����� ���孥� 㣫� }
     Repeat
       ShowTable;
       Key := UpCase(ReadKey);
      { - �믮��塞 ����室��� ����⢨� - }
       Case Key of
         #00: CursorMove;
         #13: Map[CurI,CurJ]:=Not Map[CurI,CurJ];
         'N': NewTable;
         'S': SaveTable;
         'L': LoadTable;
         'R': Life;
         'C':
           Begin
             Repeat
               Life;
               ShowTable;
             Until KeyPressed;
             ReadKey;
           End;
       End;
      { ���� �� �� �멤�� �� ������ ESC :�) }
     Until Key = #27;
     KillWindow(Window);
   End;

{ ��������������������������������������������������������������������ѻ }
{ ��                        �᭮���� �ணࠬ��                        �� }
{ ��������������������������������������������������������������������ϼ }
Var Window:WindowPtr;
Begin
 { - ������� ���誮 �ணࠬ�� - }
  MakeWindow(Window,1,1,80,25,True,True,True,$07,$07,$07,
    ' ��� "�����" ');
  DisplayWindow(Window);
 { - ����⠥� � ���� �ணࠬ�� - }
  About; { ������ � ��᪠� � �ணࠬ�� }
  EditTable; { � ⥯��� ।����㥬 ⠡���� }
 { - ����뢠�� ���誮 �ணࠬ�� - }
  KillWindow(Window);
End.