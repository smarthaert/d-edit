Uses TPString,TPCrt,TPCmd,TPWindow,TPMenu,TPPick;

{ --- ���ᠭ�� ⨯�� ������ --- }
type
    TInf = record
       NGroup : LongInt;
          Fam : String;
         Name : String;
        BYear : LongInt;
       SummaS : LongInt;
       SrBall : Real;
       MRaspr : String;
          end;
    TFRec = record
       Adr : Word;
       Inf : TInf;
           end;
    TFile=file of TFRec;

{ --- ��� 䠩�� � ����� �� ࠡ�⠥� --- }
Const FileName : String = 'Notebook.dat';

{ --- ������ ��������� --- }
Const ItemExist = $FFFF;

{ --- �������� ������� --- }
Const
  cmFileWatch  = 1;
  cmSearchStud = 2;
  cmAddStud    = 3;
  cmDelStud    = 4;
  cmSummaStip  = 5;
  cmExit       = 6;

{ --- ���� ���� ������ --- }
Var  F : TFile;

{ --- ���樠������ ���� Turbo Professional --- }
procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '�Ȼ�ͺ';

begin
  ClrScr;
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(4,3,1,Horizontal,Frame1,Color1,'(C) 9331 International');
    MenuMode(False, True, False);
    MenuWidth(69);
    MenuItem('����� � ᯨ᪮�',3,1,1,'����� � ����� ������ ��㤥�⮢');
    SubMenu(7,5,1,Vertical,Frame1,Color1,'');
      MenuMode(False, True, False);
      MenuItem('��ᬮ�� ᯨ᪠',1,1,cmFileWatch,'��ᬮ�� ᯨ᪠ ��㤥�⮢');
      MenuItem('�������� ��㤥��',2,1,cmAddStud,'���������� ��㤥�� � ���� ������');
      MenuItem('������� ��㤥��',3,1,cmDelStud,'�������� ��㤥�� �� ���� ������');
      MenuItem('���� ��㤥��',4,1,cmSearchStud,'���� ��㤥�� � ���� ������ �� 䠬����');
      MenuItem('�⨯�����',5,1,cmSummaStip,'������ �㬬� �⨯����� �� ��㯯��');
      PopSublevel;
    MenuItem('��室',52,1,cmExit,'��室 � ����樮���� ���⥬�');
    PopSublevel;

  ResetMenu(M);
end;

{ --- ���� 楫��� �᫠ --- }
Procedure EnterInteger( Str:String; Var N:LongInt );
  Var Error:Integer; S:String;
  Begin
    Repeat
      Write(Str);
      Readln(S);
      Val(S,N,Error);
      If Error<>0 then Writeln('�訡��: ���ࠢ���� �ଠ� �᫠');
    Until Error = 0;
  End;

{ --- ���� ����⢨⥫쭮�� �᫠ --- }
Procedure EnterReal( Str:String; Var N:Real );
  Var Error:Integer; S:String;
  Begin
    Repeat
      Write(Str);
      Readln(S);
      Val(S,N,Error);
      If Error<>0 then Writeln('�訡��: ���ࠢ���� �ଠ� �᫠');
    Until Error = 0;
  End;

{ --- ���뢠�� 䠩� --- }
procedure FOpen;
Var R:TFRec;
begin
 Assign(F,FileName);
{$I-}
 Reset(F); { �᫨ 䠩� ���� => ���뢠�� ��� }
{$I+}
 if IoResult<>0 then { � �᫨ ��� ��� => ������� ���� ���⮩ }
  begin
   Rewrite(F);
   R.Adr:=0;
   Write(F,R);
  end;
end;

{ --- �⥭�� �� 䠩�� --- }
Procedure ReadRec( Pos:Word; Var R:TFRec );
  Begin
    Seek(F,Pos);
    Read(F,R);
  End;

{ --- ������ � 䠩� --- }
Procedure WriteRec( Pos:Word; Var R:TFRec );
  Begin
    Seek(F,Pos);
    Write(F,R);
  End;

{ --- ��⠢�� ������� �� ᢮����� ���� --- }
Procedure InsFRec( Inf:TInf );
var Deleted,NextDeleted:Word; R:TFRec;
begin
 ReadRec(0,R);
{ �᫨ � ��� ��� 㤠������ ����ᥩ }
 if R.Adr = 0 then
  begin
   R.Inf := Inf;
   R.Adr := ItemExist;
   WriteRec(FileSize(F),R);
  end
{ �᫨ � ��� ���� 㤠����� ����� }
 else
  begin
   Deleted := R.Adr;
   ReadRec(Deleted,R);
   NextDeleted := R.Adr;
   R.Inf := Inf;
   R.Adr := ItemExist;
   WriteRec(Deleted,R);
   R.Adr := NextDeleted;
   WriteRec(0,R);
  end;
end;

{ --- ���������� ��㤥�� --- }
Procedure AddStud;
Var Pole:TInf; Window:WindowPtr; S:String;
Begin
 MakeWindow(Window,1,3,60,18,true,true,false,$1E,$1f,$1e,' ����� �� ��㤥��� ');
 Repeat
  EraseTopWindow;
  DisplayWindow(Window);
  GoToXY(1,3);
  EnterInteger('��㯯�: ',Pole.NGroup);
  Write('�������: '); ReadLn(Pole.Fam);
  Write('���: '); ReadLn(Pole.Name);
  EnterInteger('��� ஦�����: ',Pole.BYear);
  EnterInteger('�㬬� �⨯�����: ',Pole.SummaS);
  EnterReal('�।��� ����: ',Pole.SrBall);
  Write('���� ��।������: '); Readln(Pole.MRaspr);
  InsFRec(Pole);
  Writeln; Writeln('��㤥�� �������� !');
  Writeln; Writeln('< Enter - �த�������  ��㣠� ������ - ���� >');
 Until ReadKey <> #13;
 KillWindow(Window);
End;

{ --- �뢮� ���� � ���ଠ樥� � ��㤥�� --- }
Procedure StudShow( Var Window:Pointer; R:TInf );
 Begin
  MakeWindow(Window,40,3,80,12,true,true,false,$1E,$1f,$1e,' ����� �� ��㤥��� ');
  DisplayWindow(Window);
  With R do
   Begin
    Writeln('�������:             ',Fam);
    Writeln('���:                 ',Name);
    Writeln('��� ஦�����:        ',BYear);
    Writeln('��㯯�:              ',NGroup);
    Writeln('�㬬� �⨯�����:     ',SummaS);
    Writeln('�।��� ����:        ',SrBall:0:3);
    Write  ('���� ��।������: ',MRaspr);
   End;
 End;

{ --- ���� ��㤥�� �� 䠬���� --- }
Function Search_Student( Fam:String ):LongInt;
  Var R:TFRec;
  Begin
    Search_Student := 0;
    Seek(F,1);
    While Not EOF(F) do
     Begin
       Read(F,R);
       If ((R.Adr = ItemExist) And (R.Inf.Fam = Fam)) then
         Begin
           Search_Student := FilePos(F)-1;
           Break;
         End;
     End;
  End;

{ --- ���� ��㤥�� �� 䠬���� --- }
Procedure SearchStud;
var Str : String;
    Window,Window2 : Pointer;
    R : TFRec;
    T : LongInt;
begin
 MakeWindow(Window,1,3,39,18,true,true,false,$1E,$1f,$1e,
   ' ���� ��㤥�� �� 䠬���� ');
 EraseTopWindow;
 DisplayWindow(Window);
 Writeln('������ 䠬���� ��㤥��: '); Readln(Str);
 T := Search_Student(Str);
 If T = 0 then
  Writeln('������ �� �⮬� ��㤥��� ��� ')
 Else
  Begin
   ReadRec(T,R);
   StudShow(Window2,R.Inf);
  End;
 ActivateTiledWindow(Window);
 Writeln; Writeln('<������ ������� ��� �த�������>');
 ReadKey;
 If T<>0 then KillWindow(Window2);
 KillWindow (Window);
end;

{ --- ����஢�� 䠩�� �� �।���� ����� --- }
Procedure Sortirovka;
Var
 I,J,D:integer;
 A,B:TFRec;
Begin
 D := FileSize(F)-1;
 for I:=1 to (D-1) do
   for J:=(I+1) to D do
    begin
     ReadRec(I,A);
     ReadRec(J,B);
     if ((A.Inf.SrBall < B.Inf.SrBall) And
         (A.Adr = ItemExist) And (B.Adr = ItemExist)) then
      Begin
       WriteRec(J,A);
       WriteRec(I,B);
      End;
    end;
End;

{ --- ��᫮ ��㤥�⮢ � ᯨ᪥ --- }
Function Stud_Num:LongInt;
  Var Counter:LongInt; R:TFRec;
  Begin
    Counter := 0;
    Seek(F,0);
    While Not EOF(F) do
      Begin
        Read(F,R);
        If R.Adr = ItemExist then Inc(Counter);
      End;
    Stud_Num := Counter;
  End;

{ --- ��㤥�� ����� N --- }
Procedure Stud_Get( Var StudRec:TFRec; N:LongInt );
  Var Counter:LongInt; R:TFRec;
  Begin
    Counter := 0;
    Seek(F,0);
    While Not EOF(F) do
      Begin
        Read(F,R);
        If R.Adr = ItemExist then Inc(Counter);
        If Counter = N then Break;
      End;
    StudRec := R;
  End;

{ --- �㭪��, ��������� �� ������ ������ --- }
Function StrFunc( N:Integer ):String; Far;
  Var R:TFRec; C:LongInt;
  Begin
    Stud_Get(R,N);
    StrFunc := Pad(Long2Str(R.Inf.NGroup),6) + '� ' + R.Inf.Fam;
  End;

{ --- ��࠭�� ��㤥�� --- }
Var Selected : Word;
    About_Window : WindowPtr;

Procedure Show_Information; Far;
  Var R:TFRec; Temp:WindowPtr;
  Begin
    Temp := CurrentWindow;
    KillTiledWindow(About_Window);
    Stud_Get(R,Selected);
    StudShow(About_Window,R.Inf);
    ActivateTiledWindow(Temp);
  End;

Procedure FileWatch;
  Var Palette:PickColorArray;
  Begin
    Palette[WindowAttr] := $07;
    Palette[FrameAttr]  := $07;
    Palette[HeaderAttr] := $0F;
    Palette[SelectAttr] := $70;
    Palette[AltNormal]  := $0F;
    Palette[AltHigh]    := $0F;
    If Stud_Num = 0 then Exit;
    PickUserPtr := Addr(Show_Information);
    Repeat
      PickWindow(Addr(StrFunc),Stud_Num,1,1,40,20,True,Palette,
        '��ᬮ�� ᯨ᪠ ��㤥�⮢',Selected);
    Until PickCmdNum = PKSExit;
    KillTiledWindow(About_Window);
  End;

{ --- �������� ��㤥�� --- }
Procedure DelStud;
  Var UdalStud:String; Window:WindowPtr; T:LongInt; R1,R2:TFRec;
  Begin
    MakeWindow(Window,1,3,60,18,true,true,false,$1E,$1f,$1e,' �������� ');
    DisplayWindow(Window);
    GoToXY(1,3);
    Write('������ 䠬���� ��㤥��: '); Readln(UdalStud);
    T := Search_Student(UdalStud);
    If T<>0 then
      Begin
        ReadRec(0,R1);
        ReadRec(T,R2);
        R2.Adr := R1.Adr;
        R1.Adr := T;
        WriteRec(0,R1);
        WriteRec(T,R2);
        Writeln('��㤥�� �ᯥ譮 㤠��� !');
      End
    Else
      Writeln('�訡��: ������ �� �⮬� ��㤥��� ��� !');
    Writeln('<������ ������� ��� �த�������>');
    ReadKey;
    KillWindow(Window);
  End;

{ --- C㬬� �⨯����� --- }
Procedure SummaStip;
  Procedure Out( S:String );
    Begin
      If WhereY = 20 then
        Begin
          Write('<������ ������� ��� �த�������>');
          ReadKey;
          ClrScr;
        End;
      Writeln(S);
    End;
  Var Exclude,Min:Integer; Window:WindowPtr; R:TFRec; Sum,AllSum:LongInt;
  Begin
    Exclude := -1;
    MakeWindow(Window,1,3,60,24,true,true,false,$1E,$1f,$1e,' �㬬� �⨯����� ');
    DisplayWindow(Window);
    AllSum := 0;
    Repeat
      Min := MaxInt;
     { ���᭥��� ����� �������쭮� ��㯯� }
      Seek(F,0);
      While Not EOF(F) do
        Begin
          Read(F,R);
          If ((R.Adr = ItemExist) And
              (R.Inf.NGroup > Exclude) And
              (R.Inf.NGroup < Min)) then
            Min := R.Inf.NGroup;
        End;
      Exclude := Min;
     { �뢮� �㬬� �� ��࠭ }
      Seek(F,0);
      Sum := 0;
      If Min < MaxInt then Out('---=== ��㯯� '+Long2Str(Min)+' ===---');
      While Not EOF(F) do
        Begin
          Read(F,R);
          If ((R.Adr = ItemExist) And
              (R.Inf.NGroup = Min)) then
            With R.Inf do
              Begin
                Out(Pad(Fam,17)+Pad(Name,10)+Long2Str(SummaS));
                AllSum := AllSum + SummaS;
                Sum := Sum + SummaS;
                Min := R.Inf.NGroup;
              End;
        End;
      If Min < MaxInt then Out('�㬬� �� ��㯯� '+Long2Str(Min)+': '
                               +Long2Str(Sum));
    Until Min = MaxInt;
    Out('---=== �� �ᥬ ��㯯�� ===---');
    Out('�⮣���� �㬬�: '+Long2Str(AllSum));
    ReadKey;
    KillWindow(Window);
  End;

{ --- �᭮���� �ணࠬ�� --- }
var
  M : Menu;
  Key : MenuKey;
  Ch : Char;
begin
  TextColor(7);
  TextBackGround(0);
  Repeat
    ClrScr;
    InitMenu(M);
    Key := MenuChoice(M, Ch);
    EraseMenu(M, False);
   { ���뢠�� 䠩� }
    FOpen;
   { ������ �㦭�� ������ }
    Case Key of
      cmFileWatch  : FileWatch;
      cmSearchStud : SearchStud;
      cmAddStud    : AddStud;
      cmDelStud    : DelStud;
      cmSummaStip  : SummaStip;
    end;
   { ����뢠�� 䠩� }
    Close(F);
   { ���� �� �㤥� ������� ��室� }
  Until Key = cmExit;
end.
