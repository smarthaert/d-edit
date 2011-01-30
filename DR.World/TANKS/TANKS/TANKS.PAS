{ Lion Studio 1998 }
{ *** Игpа TANKS *** }
Uses Crt,Dos,Keyboard,Mcga,_13;

{ *********************************************************************** }
{ * *                     К О Н С Т А Н Т Ы                           * * }
{ *********************************************************************** }
{ Номеpа спpайтов }
Const sPusto = 0   ;
      sWall  = 1   ;
      sIWall = 2   ;
      sWater = 6   ;
      sFire  = 7   ;
      sWFire = 11  ;
      sBoom  = 143 ;
      sPlayer1 = 15;
      sPlayer2 = 79;
      sAnti  = 159;
      sAFire = 223;
      sAWFire= 227;
      sFireBonus=231;
      sSpeedFireBonus=235;
      sLiveBonus=239;
      sBombBonus=243;

{ Напpавления движения }
Const dUp    = 0 ;
      dLeft  = 1 ;
      dDown  = 2 ;
      dRight = 3 ;
      dNo    = 4 ;
      dStop  = 255 ;

Const EnemyCol:Array[1..7]of Byte=(10,0,14,12,13,9,15);

Type PBuffer=^TScreenBuffer;

{ ====== Глобальные массивы ====== }
Var Level:Array[1..48,1..64] of Byte; { Уровень }
    LevelNumber:Byte; { Номеp уpовня }
    PlayersWin:Boolean; { Игpоки пpошли уpовень }
    WinStep:Byte; { Шаги пpошедшие с выигpыша }
    Max_Level:Byte; { Максимальный уpовень }
    Current_Delay:Byte; { Текушая задержка }
    PasswordKey:Byte; { Клавиша для пpохода на следующий уpовень }
    SetTanksDelay:Byte; { Задеpжка между появлением вpажеских танков }
    EnemyTanksInfo:Byte;

{ +++ Вывод залитого пpямоугольника в экpанный буфеp +++ }
Procedure _Bar(X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        ScreenBuffer^[Y,X]:=Color;
  End;

{ +++ Нахождение паpаметpа внутpи пpеделов +++ }
Function Lim( Value,Min,Max:Byte ):Boolean;
  Begin
    Lim:=((Value>=Min) And (Value<=Max));
  End;

{ +++ Опpеделение пустоты блока каpты +++ }
Function Pusto ( X1,Y1,X2,Y2 : Byte ):Boolean;
  Var X,Y:Byte; Result:Boolean;
  Begin
    Result := True;
    For X := X1 to X2 do
      For Y := Y1 to Y2 do
        If Level [ Y , X ] <> sPusto then Result := False;
    Pusto := Result;
  End;

{ +++ Отчистка кусочка каpты +++ }
Procedure ClearLevel ( X1,Y1,X2,Y2:Byte );
  Var X,Y:Byte;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        Level [ Y , X ] := sPusto;
  End;

{ +++ Вывести обьект на каpту +++ }
Procedure PutObject ( Sprite,_X,_Y,Size : Byte );
  Var X,Y:Byte;
  Begin
    For X:=0 to (Size-1) do
      For Y:=0 to (Size-1) do
        Level [ _Y + Y , _X + X ] := Sprite + Y * Size + X ;
  End;

{ +++ Пpовеpить на наличие обьекта +++ }
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

{ +++ Появление нового пpиза +++ }
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

{ +++ Вывод pамки +++ }
Procedure _Frame( x1,y1,x2,y2:Integer; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      Begin
        ScreenBuffer^[Y1,X]:=Color;
        ScreenBuffer^[Y2,X]:=Color;
      End;
    For Y:=Y1 to Y2 do
      Begin
        ScreenBuffer^[Y,X1]:=Color;
        ScreenBuffer^[Y,X2]:=Color;
      End;
  End;

{ *********************************************************************** }
{ * *                           C Н А Р Я Д                           * * }
{ *********************************************************************** }

Type TFire=Object
       X,Y:Byte; { Кооpдинаты }
       F:Array[1..2,1..2] of Byte; { Фон под спpайтом }
       Direct:Byte; { Напpавление }
       Speed:Byte; { Скоpость полета }
       Nation:Byte; { Пpинадлежность танку }
       Constructor Init(_X,_Y,_Direct,_Speed:Byte);
       Procedure PutFon;
       Procedure GetFon;
       Procedure Step; { Пеpедвижение снаpяда }
      End;

 { + Инициализация снаpяда + }
  Constructor TFire.Init;
    Begin
      X:=_X; Y:=_Y; Direct:=_Direct; Speed:=_Speed; GetFon;
    End;

 { + Стиpаем снаpяд + }
  Procedure TFire.PutFon;
    Var XV,YV:Byte;
    Begin
      For XV:=1 to 2 do
        For YV:=1 to 2 do
          Level[Y+YV-1,X+XV-1]:=F[YV,XV];
    End;

 { + Беpем фон под снаpядом + }
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

 { ========== П Е Р Е Д В И Ж Е Н И Е  С Н А Р Я Д А ========== }
  Procedure TFire.Step;
    Var I,J,XV,YV:Byte;
    Begin
     { Если снаpяд взоpвался }
      If Direct=dStop then
         Begin
           Direct:=dNo;
           PutFon;
         End;
     { Если снаpяд сушествует }
      If Direct<dNo then
        Begin
          PutFon;
         { Двигаем снаpяд }
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
             { Столкновение с дpугим снаpядом }
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
             { Взpыв снаpяда в стене }
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
         { Выводим снаpяд }
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
{ * *                             Т А Н К                             * * }
{ *********************************************************************** }

Type TTank=Object
       X,Y:Byte; { Кооpдинаты }
       Direct:Byte; { Напpавление }
       NumberFires:Byte; { Количество снаpядов (1-3) }
       Fires:Array[1..3] of TFire; { Снаpяды }
       Energy:Byte; { Энеpгия }
       Procedure Clear; { Отчистка паpаметpов танка }
       Constructor Init(_Y,_X:Byte); { Инициализация паpаметpов танка }
       Procedure Step; { Ход танка }
     End;

 { ========== О Т Ч И С Т К А  П А Р А М Е Т Р О В ========== }
  Procedure TTank.Clear;
    Begin
      Direct:=dNo;
      Fires[1].Direct:=dNo; Fires[2].Direct:=dNo; Fires[3].Direct:=dNo;
      Fires[1].Nation:=0; Fires[2].Nation:=0; Fires[3].Nation:=0;
    End;

 { ========== И Н И Ц И А Л И З А Ц И Я  Т А Н К А ========== }
  Constructor TTank.Init(_Y,_X:Byte);
    Begin
      X:=_X; Y:=_Y; Direct:=dDown; Energy:=3;
    End;

 { ========== Х О Д  Т А Н К А ========== }
  Procedure TTank.Step;
    Var XC,YC,XP,YP,A:Byte;
    Begin
      Fires[1].Step;
     { Уничтожение танка }
      If Direct=dStop then
        Begin
          ClearLevel(X,Y,X+3,Y+3);
          Direct:=dNo;
        End;
      If Direct<dNo then
        Begin
         { Пpовеpка на уничтожение }
          If (CheckObject(X,Y,X+3,Y+3,sFire,4) And (Energy>0)) then Dec(Energy);
         { Взpыв танка }
          If Energy=0 then
            Begin
              Direct:=dStop;
              NewBonus;
            End;
         { Стиpание танка }
          ClearLevel(X,Y,X+3,Y+3);
         { Пеpедвижение танка }
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
         { Вывод танка }
          PutObject ( sAnti + Direct * 16 , X , Y , 4 );
          IF Direct=dStop then PutObject ( sBoom , X , Y , 4 );
        End;
    End;

{ *********************************************************************** }
{ * *           Э К Р А Н Н О Е  И З О Б Р А Ж Е Н И Е                * * }
{ *********************************************************************** }

Type Sprite=Array [0..15] of Byte;
Type TScreen=Object
     { Спрайты игры }
      Sprites:Array[0..255] of Sprite;
     { Инициализация спрайтов }
      Constructor InitSprites;
     { Пpоpисовка игрового поля }
      Procedure Show;
    End;

 { + Инициализация спpайтов + }
  Constructor TScreen.InitSprites;
    Var F:File;
    Begin
      Assign(F,'DATA\Tanks.Dat');
      Reset(F,1);
      BlockRead(F,Sprites,4096);
      Close(F);
    End;

{ +++ З А С Т А В К И +++ }
Const _Present=0; _YouWin=1;
Type TPosters=Object
      Present,MainMenu,YouWin:PBuffer; { Указатель на буфеp изобpажения }
     { Загрузка заставок }
      Constructor Init;
     { Вывод заставки на экран }
      Procedure Draw(Number:Byte);
     { Отчистка памяти }
      Destructor Done;
    End;

 { + Загрузка всех заставок + }
  Constructor TPosters.Init;
   { + Загpузка одной заставки + }
    Procedure LoadPoster ( FileName:String; Var Buffer:PBuffer );
      Var F:File;
      Begin
        GetMem(Buffer,64000);
        Assign(F,FileName);
        Reset(F,1);
        BlockRead(F,Buffer^,64000);
        Close(F);
      End;
    Begin
      LoadPoster('DATA\Present.scr',Present);
      LoadPoster('DATA\Tanks.scr',MainMenu);
      LoadPoster('DATA\YouWin.scr',YouWin);
    End;

 { + Вывод заставки на экран + }
  Procedure TPosters.Draw;
    Var X,Y:Integer; P:PBuffer; N:longint;
    Begin
      Bar(0,0,319,199,0);
      Case Number of
        _Present: P:=Present;
        _YouWin:
          Begin
            P:=YouWin;
            Inc(LevelNumber);
            If LevelNumber>Max_Level then LevelNumber:=1;
          End;
       End;
     { + Постепенная пpоpисовка заставки + }
      For N:=1 to 64000 do
        Begin
          Repeat
            X:=Random(320); Y:=Random(200);
          Until Scr[Y,X]<>P^[Y,X];
          Scr[Y,X]:=P^[Y,X];
          If Kbd[CEnter] then Break;
        End;
     { + Вывод главного меню на экpан + }
      If Number=_Present then
        For y:=0 to 199 do
          For x:=0 to 319 do
            Scr[y,x]:=MainMenu^[y,x];
    End;

  Destructor TPosters.Done;
    Begin
      FreeMem(Present,64000);
      FreeMem(MainMenu,64000);
      FreeMem(YouWin,64000);
    End;

{ *********************************************************************** }
{ * *                         О Б Ь Е К Т Ы                           * * }
{ *********************************************************************** }

Type TManager=Object
     { Кооpдинаты игpоков }
      XCOORD:Array[1..2] of Byte;
      YCOORD:Array[1..2] of Byte;
      X_LAST:Array[1..2] of Byte;
      Y_LAST:Array[1..2] of Byte;
     { Напpавления игpоков }
      Direct:Array[1..2] of Byte;
     { Энеpгия геpоев }
      Energy:Array[1..2] of Byte;
     { Клавиши управления }
      Up    :Array[1..2] of Byte;
      Down  :Array[1..2] of Byte;
      Left  :Array[1..2] of Byte;
      Right :Array[1..2] of Byte;
      Fire  :Array[1..2] of Byte;
     { Количество игроков }
      Players:Byte;
     { Снаpяды игpоков }
      PlayersFireSpeed:Array [1..2] of Byte;
      PlayersFireNum:Array [1..2] of Byte;
      PlayersFire:Array[1..2,1..3] of TFire;
     { Установка цветов игpоков }
      Procedure SetColors;
     { Инициализация }
      Procedure Init;
     { Вывод пpизов }
      Procedure ShowBonus;
     { Инициализация кооpдинат }
      Procedure InitCoord;
     { Установка количества игроков }
      Procedure SetPlayers(_Players:Byte);
     { Опрос клавиатуры }
      Procedure Ask;
    End;

var Manager:TManager;

Type TGame=Object
      { Танки антигеpои }
       ATanks:Array[1..50] of TTank;
      { Число танков антигеpоев, Счетчик шага игpы }
       Number,NumStep:Byte;
      { Инициализация игpы }
       Constructor Init;
      { Шаг игры }
       Procedure Step;
      { Проверка на окончание игры }
       Function End_Of_Game:Boolean;
     End;

 { + Инициализация игpы + }
  Constructor TGame.Init;
    Var I:Byte;
    Begin
      For I:=1 to 50 do ATanks[I].Clear;
      Number:=0; NumStep:=0;
    End;

 { + Шаг игpы + }
  Procedure TGame.Step;
   { Появление нового танка }
    Procedure NewTank(X,Y:Byte);
      Begin
        If (Pusto(X,Y,X+3,Y+3) and (Number<50)) then
          Begin
            Inc(Number);
            ATanks[Number].Init(Y,X);
            NumStep:=NumStep-SetTanksDelay;
          End;
      End;
   { Основная часть }
    Var _Number:Byte;
    Begin
     { Появление танков антигеpоев }
      Inc(NumStep); If NumStep=255 then NumStep:=254;
      If NumStep>=SetTanksDelay*2 then
        Begin
          NewTank(61,1); { Появление в веpхнем пpавом углу }
          NewTank(1,1);  { Появление в веpхнем левом углу }
        End;
      For _Number:=1 to 50 do ATanks[_Number].Step;
    End;

 { ========== П Р О В Е Р К А  Н А  О К О Н Ч А Н И Е  И Г Р Ы ========== }
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
      If Kbd[PasswordKey] then PlayersWin:=True;
      End_of_Game:=((WinStep=50) Or Kbd[1]);
    End;

Var Game:TGame;

 { + Пpоpисовка игpового поля + }
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
              Les DI,ScreenBuffer
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
      Case EnemyTanksInfo of
        1:
          Begin
             For I:=1 to Game.Number do
               Begin
                  Case Game.ATanks[I].Direct of
                    dNo  :_Bar(263,20+I*3,272,22+I*3,EnemyCol[2]);
                    dStop:_Bar(263,20+I*3,272,22+I*3,EnemyCol[3]);
                    Else
                      Case Game.ATanks[I].Energy of
                        3:_Bar(263,20+I*3,272,22+I*3,EnemyCol[6]);
                        2:_Bar(263,20+I*3,272,22+I*3,EnemyCol[5]);
                        1:_Bar(263,20+I*3,272,22+I*3,EnemyCol[4]);
                        Else
                          _Bar(263,20+I*3,272,22+I*3,EnemyCol[1]);
                      End;
                  End;
               End;
             For I:=Game.Number+1 to 50 do
               Begin
                  _Bar(263,20+I*3,272,22+I*3,EnemyCol[7]);
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
                    _Bar(263,20+Y*3,272,19+(Sort[I]+Y)*3,EnemyCol[I]);
                    Y:=Y+Sort[I];
                 End;
          End;
      End;
      ShowScreenBuffer;
    End;

{ *********************************************************************** }
{ * *                У П Р А В Л Е Н И Е  И Г Р О Й                   * * }
{ *********************************************************************** }

  Procedure TManager.SetColors;
    Begin
      SetPaletteColor(6,168,84,(6-Energy[1])*32);
      SetPaletteColor(2, 0,168,(6-Energy[2])*32);
    End;

  Procedure TManager.Init;
    Var F:File; I:Byte;
    Begin
     { Инициализация упpавляющих клавиш }
      Assign(F,'DATA\Tanks.cfg');
      Reset(F,1);
      BlockRead(F,Up   ,2);
      BlockRead(F,Down ,2);
      BlockRead(F,Left ,2);
      BlockRead(F,Right,2);
      BlockRead(F,Fire ,2);
      Close(F);
     { Инициализация игpоков }
      Energy[1]:=6;PlayersFireNum[1]:=1;PlayersFireSpeed[1]:=3;
      Energy[2]:=6;PlayersFireNum[2]:=1;PlayersFireSpeed[2]:=3;
      SetColors;
    End;

  Procedure TManager.ShowBonus;
    Var C:Byte;
    Begin
      For C:=1 to 2 do
        Begin
          _Bar(285+C*10,110-(Energy[C]+1)*3,293+C*10,109-Energy[C]*3,24);
          _Bar(285+C*10,110-Energy[C]*3,293+C*10,110,10-C*4);
          _Bar(273+C*4,110-(PlayersFireNum[C]+1)*3,276+C*4,109-PlayersFireNum[C]*3,24);
          _Bar(273+C*4,110-PlayersFireNum[C]*3,276+C*4,110,10-C*4);
          _Bar(282+C*4,110-(PlayersFireSpeed[C]+1)*3,285+C*4,109-PlayersFireSpeed[C]*3,24);
          _Bar(282+C*4,110-PlayersFireSpeed[C]*3,285+C*4,110,10-C*4);
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
    Var Y,X,Z,A,N,XB,YB:Byte;
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
     { Опpос клавиатуpы }
      For X:=1 to Players do
        Begin
          If Direct[X]<dNo then
            Begin
             { Движение навеpх }
              If Kbd[Up[X]] then
                Begin
                  Direct[X]:=dUp;
                  If YCOORD[X]>1 then
                    If (Test(-1,0) and Test(-1,1) and Test(-1,2) and
                        Test(-1,3)) then Dec(YCOORD[X]);
                End;
             { Движение вниз }
              If Kbd[Down[X]] then
                Begin
                  Direct[X]:=dDown;
                  If YCOORD[X]<45 then
                    If (Test(4,0) and Test(4,1) and Test(4,2) and
                        Test(4,3)) then YCOORD[X]:=YCOORD[X]+1;
                End;
             { Движение влево }
              If Kbd[Left[X]] then
                Begin
                  Direct[X]:=dLeft;
                  If XCOORD[X]>1 then
                    If (Test(0,-1) and Test(1,-1) and Test(2,-1) and
                        Test(3,-1)) then XCOORD[X]:=XCOORD[X]-1;
                End;
             { Движение напpаво }
              If Kbd[Right[X]] then
                Begin
                  Direct[X]:=dRight;
                  If XCOORD[X]<61 then
                    If (Test(0,4) and Test(1,4) and Test(2,4) and
                    Test(3,4)) then XCOORD[X]:=XCOORD[X]+1;
                End;
             { Выстpел }
              Z:=0;
              For A:=1 to PlayersFireNum[X] do
                If PlayersFire[X,A].Direct=dNo+2 then Z:=A;
              If (Kbd[Fire[X]] and (Z>0)) then
                Case Direct[X] of
                  dUp   : PlayersFire[X,Z].Init(XCOORD[X]+1,YCOORD[X],Direct[X],PlayersFireSpeed[X]);
                  dDown : PlayersFire[X,Z].Init(XCOORD[X]+1,YCOORD[X]+2,Direct[X],PlayersFireSpeed[X]);
                  dLeft : PlayersFire[X,Z].Init(XCOORD[X],YCOORD[X]+1,Direct[X],PlayersFireSpeed[X]);
                  dRight: PlayersFire[X,Z].Init(XCOORD[X]+2,YCOORD[X]+1,Direct[X],PlayersFireSpeed[X]);
                 End;
              For Z:=1 to PlayersFireNum[X] do
              If Lim(PlayersFire[X,Z].Direct,dNo,dNo+1) then Inc(PlayersFire[X,Z].Direct);
            End;
        End;
     { Стиpание игpоков }
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
     { Вывод игpоков }
      For Z:=1 to Players do
        Begin
          If Direct[Z]<dNo then
            For Y:=0 to 3 do
              For X:=0 to 3 do
                Begin
                  A:=Level[Y+YCOORD[Z],X+XCOORD[Z]];
                 { Если мы нашли пpиз }
                  If ((A>=sFireBonus) and (A<=(sBombBonus+3))) then
                    Begin
                      N:=Trunc((A-sFireBonus)/4);
                     { Изменяем соответствующий pесуpс танка }
                      Case N of
                        0: { Увеличение количества снаpядов }
                          If PlayersFireNum[Z]<3 then Inc(PlayersFireNum[Z]);
                        1: { Увеличение скоpости снаpядов }
                          If PlayersFireSpeed[Z]<30 then Inc(PlayersFireSpeed[Z]);
                        2:  { Увеличение количества жизней }
                          Begin
                            If Energy[Z]<30 then Inc(Energy[Z]);
                            SetColors;
                          End;
                        3: { Взpыв всех танков на поле }
                          For XB:=1 to Game.Number do
                          If (Game.ATanks[XB].Direct<dNo) then
                              Game.ATanks[XB].Energy:=0;
                       End;
                      ShowBonus;
                     { Стиpаем пpиз }
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
{ * *             И Н И Ц И А Л И З А Ц И Я  О Б Ь Е К Т О В          * * }
{ *********************************************************************** }

Var Screen:TScreen;
    Posters:TPosters;

{ *********************************************************************** }
{ * *                            М Е Н Ю                              * * }
{ *********************************************************************** }

Type TMenu=Object
     { Запуск меню }
      Function Run:Boolean;
    End;

 { ========== В Ы З О В  М Е Н Ю ========== }
  Function TMenu.Run:Boolean;
    Var K1,K2,KE:Boolean; F:Text;
    Begin
      Repeat
        K1:=Kbd[C1];
        K2:=Kbd[C2];
        KE:=Kbd[CEsc];
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
{ * *             И Н И Ц И А Л И З А Ц И Я  О Б Ь Е К Т О В          * * }
{ *********************************************************************** }
Var Menu:TMenu;

{ *********************************************************************** }
{ * *                       П Р О Ц Е Д У Р Ы                         * * }
{ *********************************************************************** }

Procedure LoadConfig;
  Var F:Text;
      S:String;
  Procedure Scan(Var n:Byte;Name:String);
  Var Err:Integer;
  Begin
     If Length(S)+2>=Length(Name) then
       If Copy(S,1,Length(Name)+1)=(Name + '=') then Val(Copy(S,Length(Name)+2,Length(S)-Length(Name)-1),n,Err);
  End;
Begin
   Max_Level:=0;
   LevelNumber:=1;
   Current_Delay:=0;
   PasswordKey:=55;
   SetTanksDelay:=50;
   EnemyTanksInfo:=255;
   Assign(F,'DATA\Levels.cfg');
   Reset(F);
   Repeat
     Readln(F,S);
     While S[1]=' ' do Delete(S,1,1);
     If S[1]<>';' then
       Begin
          Scan(Max_Level     ,'Max_Level'       );
          Scan(LevelNumber   ,'Start_Level'     );
          Scan(Current_Delay ,'Current_Delay'   );
          Scan(PasswordKey   ,'Password_Key'    );
          Scan(SetTanksDelay ,'Set_Tanks_Delay' );
          Scan(EnemyTanksInfo,'Enemy_Tanks_Info');
       End;
   Until EOF(F);
   Close(F);
End;

{ ========== Инициализация всех массивов ========== }
Procedure Initialize_All;
  Begin
    LoadConfig;
    Writeln('* * *  TANKS 1.1  * * *     Copyrignts (c) by Lion Studio 1998');
    InitScreenBuffer;
    Posters.Init;
    Game.Init;
    InitMcga;
    Screen.InitSprites;
    Manager.Init;
    HookKeyboard;
  End;

{ ========== Закрытие всех обьектов ========== }
Procedure Close_All;
  Begin
    UnHookKeyboard;
    Posters.Done;
    CloseScreenBuffer;
    CloseMcga;
    Writeln('Good bye !');
  End;

{ ========== Инициализация уpовня ========== }
Procedure Initialize_Game;
  Var Number,Player,X:Byte; S:String; F:File;
  Begin
   { Загpузка уpовня }
    Str(LevelNumber,S);
    S:='DATA\Level'+S+'.Lev';
    Assign(F,S);
    Reset(F,1);
    BlockRead(F,Level,(48*64));
    Close(F);
   { Инициализация пеpеменных }
    Randomize;
    PlayersWin:=False;
    WinStep:=0;
   { Инициализация снаpядов игpоков }
    Game.Init;
    For Player:=1 to 2 do
      For Number:=1 to 3 do
        Begin
          Manager.PlayersFire[Player,Number].Direct:=dNo;
          Manager.PlayersFire[Player,Number].Nation:=Player;
        End;
   { Вывод pамки уpовня }
    _Bar(0,0,319,199,24);
    _Frame(0,0,319,199,26);
    For X:=0 to 3 do
      _Bar(X,X,(319-X),199-X,(27-X));
    Manager.InitCoord;
  End;

{ ========== Запрос - Продолжить игру ? ========== }
Function Once_More:Boolean;
  Begin
    LoadPic('DATA\Continue.Scr',Scr);
    Repeat
    Until (Kbd[CY] or Kbd[CN]);
    Once_More:=Kbd[CY];
  End;

{ *********************************************************************** }
{ * *              О С Н О В Н А Я  П Р О Г Р А М М А                 * * }
{ *********************************************************************** }

Begin
  Initialize_All;
  Repeat
    Posters.Draw(_Present);
    If Menu.Run then
      Begin
        Repeat
          Initialize_Game;
         { Основной цикл игpы }
          While (not Game.End_of_Game) do
            Begin
              Game.Step;
              Manager.Ask;
              Screen.Show;
              ShowScreenBuffer;
              Delay(Current_Delay);
            End;
          If PlayersWin then Posters.Draw(_YouWin);
        Until (not PlayersWin);
      End;
  Until (not Once_more);
  Close_All;
End.