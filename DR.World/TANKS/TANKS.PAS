{ Lion Studio 1998 }
{ *** ��p� TANKS - ���ࠡ�⪠ �� 23.08.2001 *** }
{$G+}
Uses Crt,Dos,GameKeyb,Gr_Mcga,RunError,
     TanksCfg,TankGame,Control;


{ ���� ��楤�� Delay }
procedure Delay( MilliSeconds : real) ;
var Tptr : ^longint ; Finish : longint ;
begin
  Tptr := Ptr(Seg0040, $006C);
  Finish := Tptr^ + Round(18.2*MilliSeconds/1000.0);
  repeat until Tptr^ > Finish;
end;

{ *********************************************************************** }
{ * *                     � � � � � � � � �                           * * }
{ *********************************************************************** }
Const EnemyCol : Array [1..7] of Byte=(10,0,14,12,13,9,15);

{ - �������� ��६���� - }
Var PlayersWin:Boolean; { ��p��� �p�諨 �p����� }
    WinStep:Byte; { ���� �p�襤訥 � �먣p�� }

{ +++ ��宦����� ��p����p� ����p� �p������ +++ }
Function Lim( Value,Min,Max:Byte ):Boolean;
  Begin
    Lim:=((Value>=Min) And (Value<=Max));
  End;

{ +++ ��p�������� ������ ����� ��p�� +++ }
Function Pusto ( X1,Y1,X2,Y2 : Byte ):Boolean;
  Var X,Y:Byte; Result:Boolean;
  Begin
    Result := True;
    For X := X1 to X2 do
      For Y := Y1 to Y2 do
        If Level [ Y , X ] <> sPusto then Result := False;
    Pusto := Result;
  End;

{ +++ ����⪠ ���窠 ��p�� +++ }
Procedure ClearLevel ( X1,Y1,X2,Y2:Byte );
  Var X,Y:Byte;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        Level [ Y , X ] := sPusto;
  End;

{ +++ �뢥�� ��쥪� �� ��p�� +++ }
Procedure PutObject ( Sprite,_X,_Y,Size : Byte );
  Var X,Y:Byte;
  Begin
    For X:=0 to (Size-1) do
      For Y:=0 to (Size-1) do
        Level [ _Y + Y , _X + X ] := Sprite + Y * Size + X ;
  End;

{ +++ �p���p��� �� ����稥 ��쥪� +++ }
Function CheckObject(X1,Y1,X2,Y2,_Object,Size:Byte ):Boolean;
  Var X,Y:Byte; Result:Boolean;
  Begin
    Result:=False;
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        Begin
          If ((Level[Y,X]>=_Object) And
              (Level[Y,X]<(_Object+Size))) then Result:=True;
        End;
    CheckObject:=Result;
  End;

{ +++ ������ ������ �p��� +++ }
Procedure NewBonus;
  Var X,Y,N,BonusType:Byte;
  Begin
    X:=Random(63)+1; Y:=Random(47)+1;
    If ((Random(2)=1) And Pusto(X,Y,X+1,Y+1)) then
      Begin
        N:=2;
        if random(12)=0 then N:=0;
        if random(9)=0 then N:=3;
        if random(4)=0 then N:=1;
        BonusType:=sFireBonus+N*4;
        PutObject ( BonusType , X , Y , 2 );
      End;
  End;

{ *********************************************************************** }
{ * *                           C � � � � �                           * * }
{ *********************************************************************** }

Type TFire=Object
       X,Y:Byte; { ���p������ }
       F:Array[1..2,1..2] of Byte; { ��� ��� �p��⮬ }
       Direct:Byte; { ���p������� }
       Speed:Byte; { ���p���� ����� }
       Nation:Byte; { �p������������ ⠭�� }
       Constructor Init(_X,_Y,_Direct,_Speed:Byte);
       Procedure PutFon;
       Procedure GetFon;
       Procedure Step; { ��p��������� ᭠p鸞 }
      End;

 { + ���樠������ ᭠p鸞 + }
  Constructor TFire.Init;
    Begin
      X:=_X; Y:=_Y; Direct:=_Direct; Speed:=_Speed; GetFon;
    End;

 { + ��p��� ᭠p� + }
  Procedure TFire.PutFon;
    Var XV,YV:Byte;
    Begin
      For XV:=1 to 2 do
        For YV:=1 to 2 do
          Level[Y+YV-1,X+XV-1]:=F[YV,XV];
    End;

 { + ��p�� 䮭 ��� ᭠p冷� + }
  Procedure TFire.GetFon;
    Var XV,YV:Byte;
    Begin
      For XV:=1 to 2 do
        For YV:=1 to 2 do
          Case Level[Y+YV-1,X+XV-1] of
            sFire..sFire+3 , sAFire..sAFire+3 , sPlayer1..sPlayer1+63 ,
            sPlayer2..sPlayer2+63 , sAnti..sAnti+63 , sBoom..sBoom+15 :
                  F[YV,XV]:=sPusto;
            sWFire..sWFire+3 , sAWFire..sAWFire+3 :
                  F[YV,XV]:=sWater;
            Else
              F[YV,XV]:=Level[Y+YV-1,X+XV-1];
           End;
    End;

 { - � � � � � � � � � � � �  � � � � � � � - }
  Procedure TFire.Step;
    Var I,J,XV,YV:Byte;
    Begin
     { �᫨ ᭠p� ���p����� }
      If Direct=dStop then
         Begin
           Direct:=dNo;
           PutFon;
         End;
     { �᫨ ᭠p� ������� }
      If Direct<dNo then
        Begin
          PutFon;
         { ������� ᭠p� }
          For I:=1 to Speed do
            Begin
              XV:=X; YV:=Y;
              Case Direct of
                dUp   :  Dec(Y);
                dDown :  Inc(Y);
                dLeft :  Dec(X);
                dRight:  Inc(X);
               End;
              If (not Lim(Y,1,47) Or not Lim(X,1,63)) then
                Begin
                  Direct:=dNo;
                  I:=Speed;
                End;
             { �⮫�������� � �p㣨� ᭠p冷� }
              If (Direct<dNo) then
                Begin
                  If (CheckObject(X,Y,X+1,Y+1,sFire,4) Or
                      CheckObject(X,Y,X+1,Y+1,sWFire,4) Or
                      CheckObject(X,Y,X+1,Y+1,sAFire,4) Or
                      CheckObject(X,Y,X+1,Y+1,sAWFire,4)) then
                    Begin
                      Direct:=dStop;
                      I:=Speed;
                      X:=XV; Y:=YV;
                    End;
                  If (CheckObject(X,Y,X+1,Y+1,sPlayer2,64) And (Nation<>2)) Or
                     (CheckObject(X,Y,X+1,Y+1,sPlayer1,64) And (Nation<>1)) Or
                     (CheckObject(X,Y,X+1,Y+1,sAnti,64)) then
                    Begin
                      Direct:=dStop;
                      I:=Speed;
                    End;
                End;
             { ��p� ᭠p鸞 � �⥭� }
              If ((Direct<dNo) and
                   CheckObject(X,Y,X+1,Y+1,sWall,1) or
                   CheckObject(X,Y,X+1,Y+1,sIWall,4)) then
                 Begin
                   Case Direct of
                     dUp   : For XV:=(X-1) to (X+2) do
                               If Level[Y,XV]=sWall then Level[Y,XV]:=sPusto;
                     dDown : For XV:=(X-1) to (X+2) do
                               If Level[Y+1,XV]=sWall then Level[Y+1,XV]:=sPusto;
                     dLeft : For YV:=(Y-1) to (Y+2) do
                               If Level[YV,X]=sWall then Level[YV,X]:=sPusto;
                     dRight: For YV:=(Y-1) to (Y+2) do
                               If Level[YV,X+1]=sWall then Level[YV,X+1]:=sPusto;
                    End;
                   Direct:=dNo;
                End;
            End;
         { �뢮��� ᭠p� }
          If (Direct<dNo)or(Direct=dStop) then
            Begin
              GetFon;
              If Nation=0 then
                  Begin I:=sAFire; J:=sAWFire; End
                Else
                  Begin I:=sFire; J:=sWFire; End;
              For XV:=X to (X+1) do
                For YV:=Y to (Y+1) do
                  If Level[YV,XV]=sWater then
                           Level[YV,XV]:=J+(XV-X)+(YV-Y)*2 Else Level[YV,XV]:=I+(XV-X)+(YV-Y)*2;
            End;
        End;
    End;

{ *********************************************************************** }
{ * *                             � � � �                             * * }
{ *********************************************************************** }

Type TTank=Object
       X,Y:Byte; { ���p������ }
       Direct:Byte; { ���p������� }
       NumberFires:Byte; { ������⢮ ᭠p冷� (1-3) }
       Fires:Array[1..3] of TFire; { ���p�� }
       Energy:Byte; { ���p��� }
       Procedure Clear; { ����⪠ ��p����p�� ⠭�� }
       Constructor Init(_Y,_X:Byte); { ���樠������ ��p����p�� ⠭�� }
       Procedure Step; { ��� ⠭�� }
     End;

 { - � � � � � � � �  � � � � � � � � � � - }
  Procedure TTank.Clear;
    Begin
      Direct:=dNo;
      Fires[1].Direct:=dNo; Fires[2].Direct:=dNo; Fires[3].Direct:=dNo;
      Fires[1].Nation:=0; Fires[2].Nation:=0; Fires[3].Nation:=0;
    End;

 { - � � � � � � � � � � � � �  � � � � � - }
  Constructor TTank.Init(_Y,_X:Byte);
    Begin
      X:=_X; Y:=_Y; Direct:=dDown; Energy:=3;
    End;

 { - � � �  � � � � � - }
  Procedure TTank.Step;
    Var XC,YC,XP,YP,A:Byte;
    Begin
      Fires[1].Step;
     { ����⮦���� ⠭�� }
      If Direct=dStop then
        Begin
          ClearLevel(X,Y,X+3,Y+3);
          Direct:=dNo;
        End;
      If Direct<dNo then
        Begin
         { �p���p�� �� 㭨�⮦���� }
          If (CheckObject(X,Y,X+3,Y+3,sFire,4) And (Energy>0)) then Dec(Energy);
         { ��p� ⠭�� }
          If Energy=0 then
            Begin
              Direct:=dStop;
              NewBonus;
            End;
         { ��p���� ⠭�� }
          ClearLevel(X,Y,X+3,Y+3);
          { ��p��������� ⠭�� }
          XP:=X; YP:=Y;
          Case Direct of
            dUp   : Dec(Y);
            dDown : Inc(Y);
            dLeft : Dec(X);
            dRight: Inc(X);
          End;
          A:=1;
          If (Y=0) or (X=0) or (Y=46) or (X=62) then A:=0;

          If A=1 then
            If not Pusto(X,Y,X+3,Y+3) then A:=0;

          If (A=1) And (random(20)=0) then A:=0;

          If A=0 then
            Begin
              X:=XP; Y:=YP;
              Direct:=Random(4);
            End;
          If Fires[1].Direct=dNo+4 then
            Begin
              Case Direct of
                dUp   : Fires[1].Init(X+1,Y  ,Direct,2);
                dDown : Fires[1].Init(X+1,Y+2,Direct,2);
                dLeft : Fires[1].Init(X  ,Y+1,Direct,2);
                dRight: Fires[1].Init(X+2,Y+1,Direct,2);
               End;
            End;
          If Lim(Fires[1].Direct,dNo,dNo+3) then Inc(Fires[1].Direct);
         { �뢮� ⠭�� }
          PutObject ( sAnti + Direct * 16 , X , Y , 4 );
          IF Direct=dStop then PutObject ( sBoom , X , Y , 4 );
        End;
    End;

{ *********************************************************************** }
{ * *           � � � � � � � �  � � � � � � � � � � �                * * }
{ *********************************************************************** }

Type Sprite = Array [0..15] of Byte;
Type TScreen = Object
     { ��ࠩ�� ���� }
      Sprites : Array [0..255] of Sprite;
     { ���樠������ �ࠩ⮢ }
      Constructor InitSprites;
     { �p�p�ᮢ�� ��஢��� ���� }
      Procedure Show;
    End;

 { + ���樠������ �p��⮢ + }
  Constructor TScreen.InitSprites;
    Var F:File;
    Begin
      OpenFileRE(F,'Data','DATA\Tanks.Dat');
      BlockRead(F,Sprites,4096);
      Close(F);
    End;

{ +++ � � � � � � � � +++ }
Const _Present=0; _YouWin=1;
Type TPosters = Object
      Present,MainMenu,YouWin:PScreenBuffer; { �����⥫� �� ���p ����p������ }
     { ����㧪� ���⠢�� }
      Constructor Init;
     { �뢮� ���⠢�� �� ��࠭ }
      Procedure Draw(Number:Byte);
     { ����⪠ ����� }
      Destructor Done;
    End;

 { + ����㧪� ��� ���⠢�� + }
  Constructor TPosters.Init;
   { + ���p㧪� ����� ���⠢�� + }
    Procedure LoadPoster ( FileName:String; Var Buffer:PScreenBuffer );
      Var F:File;
      Begin
        GetMem(Buffer,64000);
        Writeln('[LoadPoster] "',FileName,'" MemAvail = ',MemAvail);
        OpenFileRE(F,'Poster',FileName);
        BlockRead(F,Buffer^,64000);
        Close(F);
      End;
    Begin
      If Show_Poster = 1 then LoadPoster('DATA\Images\Present.scr',Present);
      LoadPoster('DATA\Images\Tanks.scr',MainMenu);
      LoadPoster('DATA\Images\YouWin.scr',YouWin);
    End;

 { + �뢮� ���⠢�� �� ��࠭ + }
  Procedure TPosters.Draw;
    Var X,Y:Integer; P:PScreenBuffer; N:longint;
    Begin
      Bar(0,0,319,199,0);
      Case Number of
        _Present: P:=Present;
        _YouWin:
          Begin
            P:=YouWin;
            Inc(Start_Level);
            If Start_Level>Max_Level then Start_Level:=1;
          End;
       End;
     { + ���⥯����� �p�p�ᮢ�� ���⠢�� + }
      For N:=1 to 64000 do
        Begin
          Repeat
            X:=Random(320); Y:=Random(200);
          Until Scr[Y,X]<>P^[Y,X];
          Scr[Y,X]:=P^[Y,X];
          If Keys[cEnter] then Break;
        End;
     { + �뢮� �������� ���� �� ��p�� + }
      If Number=_Present then
        For y:=0 to 199 do
          For x:=0 to 319 do
            Scr[y,x]:=MainMenu^[y,x];
    End;

  Destructor TPosters.Done;
    Begin
      If Show_Poster = 1 then FreeMem(Present,64000);
      FreeMem(MainMenu,64000);
      FreeMem(YouWin,64000);
    End;

{ *********************************************************************** }
{ * *                         � � � � � � �                           * * }
{ *********************************************************************** }

Type TManager = Object(TControl)
     { ���p������ ��p���� }
      XCOORD : Array[1..2] of Byte;
      YCOORD : Array[1..2] of Byte;
      X_LAST : Array[1..2] of Byte;
      Y_LAST : Array[1..2] of Byte;
     { ���p������� ��p���� }
      Direct:Array[1..2] of Byte;
     { ���p��� ��p��� }
      Energy:Array[1..2] of Byte;
     { ������⢮ ��ப�� }
      Players:Byte;
     { ���p�� ��p���� }
      PlayersFireSpeed:Array [1..2] of Byte;
      PlayersFireNum:Array [1..2] of Byte;
      PlayersFire:Array[1..2,1..3] of TFire;
     { ��⠭���� 梥⮢ ��p���� }
      Procedure SetColors;
     { ���樠������ }
      Procedure Init;
     { �뢮� �p���� }
      Procedure ShowBonus;
     { ���樠������ ���p����� }
      Procedure InitCoord;
     { ��⠭���� ������⢠ ��ப�� }
      Procedure SetPlayers(_Players:Byte);
     { ���� ���������� }
      Procedure Ask;
    End;

var Manager:TManager;

Type TGame=Object
      { ����� ��⨣�p�� }
       ATanks:Array[1..50] of TTank;
      { ��᫮ ⠭��� ��⨣�p���, ���稪 蠣� ��p� }
       Number,NumStep:Byte;
      { ���樠������ ��p� }
       Constructor Init;
      { ��� ���� }
       Procedure Step;
      { �஢�ઠ �� ����砭�� ���� }
       Function End_Of_Game:Boolean;
     End;

 { + ���樠������ ��p� + }
  Constructor TGame.Init;
    Var I:Byte;
    Begin
      For I:=1 to 50 do ATanks[I].Clear;
      Number:=0; NumStep:=0;
    End;

 { + ��� ��p� + }
  Procedure TGame.Step;
   { ������ ������ ⠭�� }
    Procedure NewTank(X,Y:Byte);
      Begin
        If (Pusto(X,Y,X+3,Y+3) and (Number<50)) then
          Begin
            Inc(Number);
            ATanks[Number].Init(Y,X);
            NumStep:=NumStep-Set_Tanks_Delay;
          End;
      End;
   { �᭮���� ���� }
    Var _Number:Byte;
    Begin
     { ������ ⠭��� ��⨣�p��� }
      Inc(NumStep); If NumStep=255 then NumStep:=254;
      If NumStep>=Set_Tanks_Delay*2 then
        Begin
          NewTank(61,1); { ������ � ��p孥� �p���� 㣫� }
          NewTank(1,1);  { ������ � ��p孥� ����� 㣫� }
        End;
      For _Number:=1 to 50 do ATanks[_Number].Step;
    End;

 { - � � � � � � � �  � �  � � � � � � � � �  � � � � - }
  Function TGame.End_Of_Game:Boolean;
    Var Flag:Boolean; I:Byte;
    Begin
      If Number=50 then
        Begin
          Flag:=True;
          For I:=1 to 50 do If ATanks[I].Direct<>dNo then Flag:=False;
          If Flag then Begin PlayersWin:=True; End;
        End;
      If ((((Manager.Direct[1]=dNo) and
           ((Manager.Direct[2]=dNo) or
            (Manager.Players=1)))) or
             PlayersWin) then Inc(WinStep);
      If Keys[Password_Key] then PlayersWin:=True;
      End_of_Game:=((WinStep=50) Or Keys[cEsc]);
    End;

Var Game:TGame;

 { + �p�p�ᮢ�� ��p����� ���� + }
  Procedure TScreen.Show;
    Var X,Y:Word; P:Pointer;
        I:Byte;
        Sort:Array[1..7]of Byte;
    Begin
      For Y:=1 to 48 do
        For X:=1 to 64 do
          Begin
            P:=@Sprites[Level[Y,X]];
            Asm
              Push DS
              Lds SI,P
              Les DI,DoubleBuffer
              Mov BX,Y
              Shl BX,8
              Mov CX,BX
              Mov AX,X
              Add BX,AX
              Shl BX,2
              Add BX,CX
              Add DI,BX
              Mov CL,4
             @@C:
              Mov DX,DS:[SI]
              Mov ES:[DI],DX
              Add SI,2
              Add DI,2
              Mov DX,DS:[SI]
              Mov ES:[DI],DX
              Add SI,2
              Add DI,318
              Dec CL
              JNZ @@C
              Pop DS
            End;
          End;
      Case Enemy_Tanks_Info of
        1:
          Begin
             For I:=1 to Game.Number do
               Begin
                  Case Game.ATanks[I].Direct of
                    dNo  :BarDB(263,20+I*3,272,22+I*3,EnemyCol[2]);
                    dStop:BarDB(263,20+I*3,272,22+I*3,EnemyCol[3]);
                    Else
                      Case Game.ATanks[I].Energy of
                        3:BarDB(263,20+I*3,272,22+I*3,EnemyCol[6]);
                        2:BarDB(263,20+I*3,272,22+I*3,EnemyCol[5]);
                        1:BarDB(263,20+I*3,272,22+I*3,EnemyCol[4]);
                        Else
                          BarDB(263,20+I*3,272,22+I*3,EnemyCol[1]);
                      End;
                  End;
               End;
             For I:=Game.Number+1 to 50 do
               Begin
                  BarDB(263,20+I*3,272,22+I*3,EnemyCol[7]);
               End;
          End;
        2,255:
          Begin
             For I:=1 to 7 do
               Sort[I]:=0;
             Sort[7]:=50-Game.Number;
             For I:=1 to Game.Number do
               Begin
                  Case Game.ATanks[I].Direct of
                    dNo  :Inc(Sort[2]);
                    dStop:Inc(Sort[3]);
                    Else
                      Case Game.ATanks[I].Energy of
                        3:Inc(Sort[6]);
                        2:Inc(Sort[5]);
                        1:Inc(Sort[4]);
                        Else
                          Inc(Sort[1]);
                      End;
                  End;
               End;
             Y:=0;
             For I:=1 to 7 do
               If Sort[I]>0 then
                 Begin
                    BarDB(263,20+Y*3,272,19+(Sort[I]+Y)*3,EnemyCol[I]);
                    Y:=Y+Sort[I];
                 End;
          End;
      End;
      Gr_MCGA.Show;
    End;

{ *********************************************************************** }
{ * *                � � � � � � � � � �  � � � � �                   * * }
{ *********************************************************************** }

  Procedure TManager.SetColors;
    Begin
      SetPaletteColor(6,168,84,(6-Energy[1])*8);
      SetPaletteColor(2, 0,168,(6-Energy[2])*8);
    End;

  Procedure TManager.Init;
    Var F:File; I:Byte;
    Begin
      LoadKeys('DATA\CtrlKeys.dat');
     { ���樠������ ��p���� }
      Energy[1]:=6;PlayersFireNum[1]:=1;PlayersFireSpeed[1]:=3;
      Energy[2]:=6;PlayersFireNum[2]:=1;PlayersFireSpeed[2]:=3;
      SetColors;
    End;

  Procedure TManager.ShowBonus;
    Var C:Byte;
    Begin
      For C:=1 to 2 do
        Begin
          BarDB(285+C*10,110-(Energy[C]+1)*3,293+C*10,109-Energy[C]*3,24);
          BarDB(285+C*10,110-Energy[C]*3,293+C*10,110,10-C*4);
          BarDB(273+C*4,110-(PlayersFireNum[C]+1)*3,276+C*4,109-PlayersFireNum[C]*3,24);
          BarDB(273+C*4,110-PlayersFireNum[C]*3,276+C*4,110,10-C*4);
          BarDB(282+C*4,110-(PlayersFireSpeed[C]+1)*3,285+C*4,109-PlayersFireSpeed[C]*3,24);
          BarDB(282+C*4,110-PlayersFireSpeed[C]*3,285+C*4,110,10-C*4);
        End;
    End;

  Procedure TManager.InitCoord;
    Var Z:Byte;
    Begin
      For Z:=1 to 2 do
        Begin
          If Direct[Z]=dNo then PlayersFireSpeed[Z]:=3;
          If Direct[Z]=dNo then PlayersFireNum[Z]:=1;
          If Energy[Z]<10 then Energy[Z]:=Energy[Z]+3;
          Direct[Z]:=dUp; YCOORD[Z]:=45;
        End;
      XCOORD[1]:=37; XCOORD[2]:=25;
      SetColors;
      ShowBonus;
    End;

  Procedure TManager.SetPlayers(_Players:Byte);
    Begin
      Players:=_Players;
    End;

  Procedure TManager.Ask;
    Var Y,X,Z,A,N,XB,YB,NewDirect:Byte;
    Function Test(_X,_Y:ShortInt):Boolean;
      Begin
        Test:=((Level[YCOORD[X]+_X,XCOORD[X]+_Y]=sPusto) Or
              Lim(Level[YCOORD[X]+_X,XCOORD[X]+_Y],sFireBonus,sBombBonus+3));
      End;
    Procedure EraseBonus(_X,_Y:ShortInt);
      Var XV,YV:Byte;
      Begin
        XV:=X+XCOORD[Z]+_X; YV:=Y+YCOORD[Z]+_Y;
        ClearLevel(XV,YV,XV+1,YV+1);
      End;
    Begin
      For X:=1 to 2 do
        For Z:=1 to PlayersFireNum[X] do
          PlayersFire[X,Z].Step;
      For Z:=1 to 2 do
        Begin
          X_LAST[Z]:=XCOORD[Z];
          Y_LAST[Z]:=YCOORD[Z];
        End;
     { ��p�� ��������p� }
      For X:=1 to Players do
        Begin
          NewDirect:=dNo;
          If Direct[X]<dNo then
            Begin
             { �������� ����p� }
              If Keys[Up[X]] then NewDirect:=dUp;
             { �������� ���� }
              If Keys[Down[X]] then NewDirect:=dDown;
             { �������� ����� }
              If Keys[Left[X]] then NewDirect:=dLeft;
             { �������� ���p��� }
              If Keys[Right[X]] then NewDirect:=dRight;
             { ����p�� }
              Z:=0;
              For A:=1 to PlayersFireNum[X] do
                If PlayersFire[X,A].Direct=dNo+2 then Z:=A;
              If (Keys[Fire[X]] and (Z>0)) then
                Case Direct[X] of
                  dUp   : PlayersFire[X,Z].Init(XCOORD[X]+1,YCOORD[X],Direct[X],PlayersFireSpeed[X]);
                  dDown : PlayersFire[X,Z].Init(XCOORD[X]+1,YCOORD[X]+2,Direct[X],PlayersFireSpeed[X]);
                  dLeft : PlayersFire[X,Z].Init(XCOORD[X],YCOORD[X]+1,Direct[X],PlayersFireSpeed[X]);
                  dRight: PlayersFire[X,Z].Init(XCOORD[X]+2,YCOORD[X]+1,Direct[X],PlayersFireSpeed[X]);
                 End;
              For Z:=1 to PlayersFireNum[X] do
              If Lim(PlayersFire[X,Z].Direct,dNo,dNo+1) then Inc(PlayersFire[X,Z].Direct);
              If NewDirect<>dNo then
                Begin
                   If NewDirect<>Direct[X] then
                     Begin
                        Direct[X]:=NewDirect;
                     End
                     Else
                       Case NewDirect of
                         dUp:{ �������� ����p� }
                           Begin
                              If YCOORD[X]>1 then
                                If (Test(-1,0) and Test(-1,1) and Test(-1,2) and
                                    Test(-1,3)) then Dec(YCOORD[X]);
                           End;
                         dDown:{ �������� ���� }
                           Begin
                             If YCOORD[X]<45 then
                               If (Test(4,0) and Test(4,1) and Test(4,2) and
                                   Test(4,3)) then YCOORD[X]:=YCOORD[X]+1;
                           End;
                         dLeft:{ �������� ����� }
                           Begin
                              If XCOORD[X]>1 then
                                If (Test(0,-1) and Test(1,-1) and Test(2,-1) and
                                    Test(3,-1)) then XCOORD[X]:=XCOORD[X]-1;
                           End;
                         dRight:{ �������� ���p��� }
                           Begin
                              If XCOORD[X]<61 then
                                If (Test(0,4) and Test(1,4) and Test(2,4) and
                                    Test(3,4)) then XCOORD[X]:=XCOORD[X]+1;
                           End;
                       End;
                End;
            End;
        End;
     { ��p���� ��p���� }
      For Z:=1 to Players do
        Begin
          If Direct[Z]=dStop then
            Begin
              ClearLevel(XCOORD[Z],YCOORD[Z],XCOORD[Z]+3,YCOORD[Z]+3);
              Direct[Z]:=dNo;
            End;
          If Direct[Z]<dNo then
            Begin
              If CheckObject(X_LAST[Z],Y_LAST[Z],X_LAST[Z]+3,Y_LAST[Z]+3,sAFire,4) then
                Begin
                  Dec(Energy[Z]);
                  If PlayersFireSpeed[Z]>3 then Dec(PlayersFireSpeed[Z]);
                  SetColors;
                  ShowBonus;
                End;
              ClearLevel(X_LAST[Z],Y_LAST[Z],X_LAST[Z]+3,Y_LAST[Z]+3);
              If Energy[Z]=0 then Direct[Z]:=dStop;
            End;
        End;
     { �뢮� ��p���� }
      For Z:=1 to Players do
        Begin
          If Direct[Z]<dNo then
            For Y:=0 to 3 do
              For X:=0 to 3 do
                Begin
                  A:=Level[Y+YCOORD[Z],X+XCOORD[Z]];
                 { �᫨ �� ��諨 �p�� }
                  If ((A>=sFireBonus) and (A<=(sBombBonus+3))) then
                    Begin
                      N:=Trunc((A-sFireBonus)/4);
                     { �����塞 ᮮ⢥�����騩 p���p� ⠭�� }
                      Case N of
                        0: { �����祭�� ������⢠ ᭠p冷� }
                          If PlayersFireNum[Z]<3 then Inc(PlayersFireNum[Z]);
                        1: { �����祭�� ᪮p��� ᭠p冷� }
                          If PlayersFireSpeed[Z]<30 then Inc(PlayersFireSpeed[Z]);
                        2:  { �����祭�� ������⢠ ������ }
                          Begin
                            If Energy[Z]<30 then Inc(Energy[Z]);
                            SetColors;
                          End;
                        3: { ��p� ��� ⠭��� �� ���� }
                          For XB:=1 to Game.Number do
                          If (Game.ATanks[XB].Direct<dNo) then
                              Game.ATanks[XB].Energy:=0;
                       End;
                      ShowBonus;
                     { ��p��� �p�� }
                      N:=(A-sFireBonus)-N*4;
                      Case  N of
                        0: EraseBonus(0 , 0);
                        1: EraseBonus(-1, 0);
                        2: EraseBonus(0 ,-1);
                        3: EraseBonus(-1,-1);
                       End;
                    End;
                Case Z Of
                  1: Level[Y+YCOORD[1],X+XCOORD[1]]:=sPlayer1+X+Y*4+Direct[1]*16;
                  2: Level[Y+YCOORD[2],X+XCOORD[2]]:=sPlayer2+X+Y*4+Direct[2]*16;
                 End;
              End;
          If Direct[Z]=dStop then
            PutObject(sBoom,XCOORD[Z],YCOORD[Z],4)
        End;
    End;

{ *********************************************************************** }
{ * *             � � � � � � � � � � � � �  � � � � � � � �          * * }
{ *********************************************************************** }

Var Screen:TScreen;
    Posters:TPosters;

{ *********************************************************************** }
{ * *                            � � � �                              * * }
{ *********************************************************************** }

Type TMenu=Object
     { ����� ���� }
      Function Run:Boolean;
    End;

 { - � � � � �  � � � � - }
  Function TMenu.Run:Boolean;
    Var K1,K2,KE:Boolean; F:Text;
    Begin
      Repeat
        K1:=Keys[c1];
        K2:=Keys[c2];
        KE:=Keys[cEsc];
        If K1 then Manager.SetPlayers(1);
        If K2 then Manager.SetPlayers(2);
      Until (K1 or K2 or KE);
      If not KE then
          Run:=True
        Else
          Run:=False;
      Manager.Init;
    End;

{ *********************************************************************** }
{ * *             � � � � � � � � � � � � �  � � � � � � � �          * * }
{ *********************************************************************** }
Var Menu:TMenu;

{ *********************************************************************** }
{ * *                       � � � � � � � � �                         * * }
{ *********************************************************************** }

{ - ���樠������ ��� ���ᨢ�� - }
Procedure Initialize_All;
  Begin
    Writeln('* * *  TANKS 1.1(new!)  * * *     Copyrignts (c) by Lion Studio 1998');
    INI.Run('Tanks.ini');
    New(DoubleBuffer);
    Posters.Init;
    Game.Init;
    InitMcga;
    Screen.InitSprites;
    Manager.Init;
    GameKeyb.InitInt09;
  End;

{ - �����⨥ ��� ��쥪⮢ - }
Procedure Close_All;
  Begin
    GameKeyb.RestoreInt09;
    Posters.Done;
    Dispose(DoubleBuffer);
    DoneMcga;
    Writeln('Good bye!');
  End;

{ - ���樠������ �p���� - }
Procedure Initialize_Game;
  Var Number,Player,X:Byte; S:String; F:File;
  Begin
   { ���p㧪� �p���� }
    Str(Start_Level,S);
    S:='DATA\Levels\Level'+S+'.Lev';
    OpenFileRE(F,'Level',S);
    BlockRead(F,Level,(48*64));
    Close(F);
   { ���樠������ ��p������� }
    Randomize;
    PlayersWin:=False;
    WinStep:=0;
   { ���樠������ ᭠p冷� ��p���� }
    Game.Init;
    For Player:=1 to 2 do
      For Number:=1 to 3 do
        Begin
          Manager.PlayersFire[Player,Number].Direct:=dNo;
          Manager.PlayersFire[Player,Number].Nation:=Player;
        End;
   { �뢮� p���� �p���� }
    BarDB(0,0,319,199,24);
    FrameDB(0,0,319,199,26);
    For X:=0 to 3 do
      BarDB(X,X,(319-X),199-X,(27-X));
    Manager.InitCoord;
  End;

{ - ����� - �த������ ���� ? - }
Function Once_More:Boolean;
  Var Pal:RGBPalette;
  Begin
    LoadPic('DATA\Images\Continue.Scr',Scr,Pal);
    Repeat Until (Keys[cY] or Keys[cN]);
    Once_More:=Keys[cY];
  End;

{ *********************************************************************** }
{ * *              � � � � � � � �  � � � � � � � � �                 * * }
{ *********************************************************************** }
Begin
  Initialize_All;
  Repeat
    Posters.Draw(_Present);
    If Menu.Run then
      Begin
        Repeat
          Initialize_Game;
         { �᭮���� 横� ��p� }
          While (not Game.End_of_Game) do
            Begin
              Game.Step;
              Manager.Ask;
              Screen.Show;
              Gr_MCGA.Show;
              Delay(Current_Delay);
            End;
          If PlayersWin then Posters.Draw(_YouWin);
        Until (not PlayersWin);
      End;
  Until (not Once_more);
  Close_All;
End.              