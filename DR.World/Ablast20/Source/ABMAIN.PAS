{-= Main part of Alien Blaster =-}

Uses ABGraf, Dos, Crt;
{$I abconst.pas}
{$I abmisc.pas}

Type
     RecordPointer = ^LinkedList; {predefined record for a pointer-linked array (PLA)}
     LinkedList = Record
       X, Y : Real; {coordinates}
       Frame : ^Real; {only used by explosions}
       Next, Previous : RecordPointer; {nodes}
     End;

     LevelSettingsRecord = Record {header part of a level-file}
       RandomShoot : Word; {the bigger the value the more often enemies will shoot}
       EnemysHorizOffset, EnemysVertOffset : Real; {offsets}
     End;

     GameSettingsRecord = Record {configuration}
       Left, Right, Shoot : Byte; {keys}
       PlayersHorizOffset, BulletOffset, {offsets}
       FrameDelay : Real; {delay between frames}
     End;

     SpriteRecord = Record {sprites}
       Width, Height : Word;
       Data : Pointer; {buffer}
     End;

     ExplosionRecord = Record {explosions}
       FirstExplosion : RecordPointer; {pointer to first element}
       ExplosionSprite : SpriteRecord;
     End;

     EnemyRecord = Record
       FirstEnemy, FirstBullet : RecordPointer; {pointer to first element}
       HorizDirection, VertDirection : ShortInt; {directions (-1=left, 0=none, 1=right}
       SpaceShip, BulletSprite : SpriteRecord; {sprites}
     End;

     PlayerRecord = Record
       X, Y : Real; {coordinates}
       FirstBullet : RecordPointer; {pointer to first element}
       Spaceship, BulletSprite : SpriteRecord; {sprites}
       Lifes : Word; {lifes}
     End;

Var OldTimerHandler, OldKbdHandler : Procedure; {pointers to hooked interrupts}
    Player : PlayerRecord;
    Enemies : EnemyRecord;
    Explosions : ExplosionRecord;
    Palette : PalettePointer; {save VGA palette}
    Font : SpriteRecord; {font of the game}
    OldExitProc, {old on-exit handler}
    VirtualScreen1, VirtualScreen2 : Pointer; {virtual screen buffers}
    LevelSettings : LevelSettingsRecord;
    GameSettings : GameSettingsRecord;
    Shooting, {indicates if the fire button is beeing pressed}
    Bussy : Boolean; {indiactes if the new tiemr interrupt is not idle}
    CurrentLevel : Word; {current level (first level is 1)}
    CurrentRecord : RecordPointer;
    Event : EventType; {will equal the id of the occured event and thus terminating the game}
    Pressed : Byte; {hold the value of a pressed key}
    Pause, {only used by the new keyboard handler}
    Paused : Boolean; {indicates the state of the game}

Procedure Create(Var FirstRecord : RecordPointer); Forward;
Procedure SetBullet(X1, Y1 : Real; Var FirstRecord : RecordPointer); Forward;
Procedure NewTimerHandler; Interrupt; Forward;
Procedure Quit(ExitCode : Byte; Message : String); Forward;

{*** GRAPHICS HANDLING ***}

{Show a text string}
Procedure OutPut(X, Y : Word; Message : String; Buffer : Pointer);
  Var Run, Char : Byte;

Begin
  With Font Do
  For Run:= 1 to Length(Message) Do
  Begin
    Case Message[Run] Of {get letter order}
      'A'..'Z' : Char:= Ord(Message[run]) - 65;
      '0'..'9' : Char:= 26 + Ord(Message[run]) - 48;
      '?' : Char:= 36; '!' : Char:= 37; '(' : Char:= 38; ')' : Char:= 39; '@' : Char:= 40;
      '.' : Char:= 41; ':' : Char:= 42; ',' : Char:= 43; '/' : Char:= 44; #39 : Char:= 45;
      '-' : Char:= 46; '+' : Char:= 47; #32 : Continue;
    End;
    PutSprite(X + (Run - 1) * Width, Y, Width, Width, Ptr(Seg(Font.Data^), Ofs(Font.Data^) + Width * Width * Char), Buffer);
  End;
End;

{Pop up a message}
Function Message(Message1 : String) : char;
Begin
  Flip(VirtualScreen2^, Display^);
  With Font Do OutPut((ScreenWidth - Length(Message1) * Width) Div 2, (ScreenHeight - Width) Div 2, Message1, Display);
  Message:= UpCase(ReadKey); {wait for a keypress and return it's value}
End;

{Set new 256 color palette}
Procedure SetPalette;
  Var Run : Byte;

Begin
  Clear(0, Vga);
  For Run:= 0 to 255 Do
  With Palette^[Run] Do SetRGB(Run, Red, Green, Blue);
End;

{Load a PCX image}
Function LoadImage(Path : String; Var Width, Height : Word; Var Palette : PalettePointer; Var Buffer : Pointer) : ShortInt;
  Var F : File;
      Run : Word;

begin
  If OpenFile(F, Path) <> Success Then Quit(CantOpenFile, 'Error! Can''t load "' + Path + '"'); {can't open?}
  GetPcxDimensions(F, Width, Height); {get width and height}
  If MaxAvail < Width * Height Then Quit(CantOpenFile, 'Error! Not enough memory'); {not enough memory}
  GetMem(Buffer, Width * Height); {allocate memory for new buffer and put the image into it}
  LoadPcxPalette(F, Palette);
  LoadPcx(F, Width, Height, Buffer);
  Close(F);
  LoadImage:= Success;
End;

{Load font}
Procedure LoadFont;
Begin
  With Font Do LoadImage(FontPcx, Width, Height, Palette, Data);
End;

{Load background}
Procedure LoadBackground;
  Var Width, Height : Word;

Begin
  LoadImage(BackgroundPcx, Width, Height, Palette, VirtualScreen2);
End;

{Load all sprites}
Procedure LoadSprites;
Begin
  With Enemies Do
  Begin
    With SpaceShip Do LoadImage(Enemypcx, Width, Height, Palette, Data);
    With BulletSprite Do LoadImage(EnemyBulletPcx, Width, Height, Palette, Data);
  End;
  With Player Do
  Begin
    With SpaceShip Do LoadImage(PlayerPcx, Width, Height, Palette, Data);
    With BulletSprite Do LoadImage(PlayerBulletPcx, Width, Height, Palette, Data);
  End;
  With Explosions, ExplosionSprite Do
  LoadImage(ExplosionPcx, Width, Height, Palette, Data);
End;

{*** POINTER AND PLA HANDLING ***}

{Link new record to PLA}
Procedure Create(Var FirstRecord : RecordPointer);
  Var TempRecord : RecordPointer;

Begin
  New(Temprecord);
  With TempRecord^ do
  Begin {setup nodes}
    Next:= FirstRecord;
    FirstRecord^.Previous:= TempRecord;
    FirstRecord:= TempRecord;
  End;
End;

{Erase an element from PLA}
Procedure Erase(Var CurrentRecord, FirstRecord : RecordPointer);
  Var TempRecord : RecordPointer;

Begin
  TempRecord:= CurrentRecord;
  With CurrentRecord^ Do
  Begin {setup nodes...}
    If CurrentRecord = FirstRecord Then FirstRecord:= FirstRecord^.Next
    Else
    Begin
      Previous^.Next:= Next;
      Next^.Previous:= Previous;
    End;
    CurrentRecord:= Next;
    Dispose(TempRecord); {erase}
  End;
End;

{Erase player's bullets}
Procedure ErasePlayersBullets;
  Var TempRecord : RecordPointer;

Begin
  With Player Do
  Begin
    TempRecord:= FirstBullet;
    While TempRecord <> Nil Do Erase(TempRecord, FirstBullet);
  End;
End;

{Erase all enemies}
Procedure EraseEnemies;
  Var TempRecord : RecordPointer;

Begin
  With Enemies Do
  Begin
    TempRecord:= FirstBullet;
    While TempRecord <> Nil Do Erase(TempRecord, FirstBullet); {erase bullets}
    TempRecord:= FirstEnemy;
    While TempRecord <> Nil Do Erase(TempRecord, FirstEnemy); {erase spaceships}
  End;
End;

{Erase all explosions}
Procedure EraseExplosions;
  Var TempRecord : RecordPointer;

Begin
  With Explosions Do
  Begin
    TempRecord:= FirstExplosion;
    While TempRecord <> Nil Do
    Begin
      Dispose(TempRecord^.Frame); {erase...}
      Erase(TempRecord, FirstExplosion);
    End;
  End;
End;

{Release all PLAs and the rest used memory for the game}
Procedure EraseAll;
Begin
  If VirtualScreen1 <> Nil Then
  Begin
    FreeMem(VirtualScreen1, BufferSize);
    VirtualScreen1:= Nil;
  End;
  If VirtualScreen2 <> Nil Then
  Begin
    FreeMem(VirtualScreen2, BufferSize);
    VirtualScreen2:= Nil;
  End;
  With Font Do
  If Data <> Nil Then
  Begin
    FreeMem(Data, Width * Height);
    Data:= Nil;
  End;
  With Explosions.ExplosionSprite Do
  If Data <> Nil Then
  Begin
    FreeMem(Data, Width * Height);
    Data:= Nil;
  End;
  With Player Do
  Begin
    With Spaceship Do
    If Data <> Nil Then
    Begin
      FreeMem(Data, Width * Height);
      Data:= Nil;
    End;
    With BulletSprite Do
    If Data <> Nil Then
    Begin
      FreeMem(Data, Width * Height);
      Data:= Nil;
    End;
  End;
  With Enemies, SpaceShip Do
  Begin
    With SpaceShip Do
    If Data <> Nil Then
    Begin
      FreeMem(Data, Width * Height);
      Data:= Nil;
    End;
    With BulletSprite Do
    If Data <> Nil Then
    Begin
      FreeMem(Data, Width * Height);
      Data:= Nil;
    End;
  End;
  ErasePlayersBullets;
  EraseEnemies;
  EraseExplosions;
  Dispose(Palette);
  If Palette <> Nil Then Palette:= Nil;
End;

{*** SPRITE HANDLING ***}

{Link new bullet to the rest}
Procedure SetBullet(X1, Y1 : Real; Var FirstRecord : RecordPointer);
Begin
  Create(FirstRecord);
  With FirstRecord^ Do
  Begin {setup it's coordinates}
    X:= X1;
    Y:= Y1;
  End;
End;

{Put a sprite in the specified buffer at the specified coordinates}
Procedure PutSprites(FirstRecord : RecordPointer; Sprite : SpriteRecord);
  Var TempRecord : RecordPointer;

begin
  TempRecord:= FirstRecord;
  While TempRecord <> Nil Do
  With TempRecord^, Sprite Do
  Begin
    Putsprite(Trunc(X), Trunc(Y), Width, Height, Data, VirtualScreen1);
    TempRecord:= Next;
  End;
End;

{Set all explosions in the specified buffer}
Procedure PutExplosions;
  Var Explosion : RecordPointer;

Begin
  Explosion:= Explosions.FirstExplosion;
  While Explosion <> Nil Do
  With Explosion^, Explosions.ExplosionSprite Do
  Begin
    PutSprite(Trunc(X), Trunc(Y), Width, Width, Ptr(Seg(Data^), Ofs(data^) + Width * Width * Trunc(Frame^)), VirtualScreen1);
    Explosion:= Next;
  End;
End;

{Link new explosion to the rest}
Procedure SetExplosion(X1, Y1 : Real);
Begin
  Create(Explosions.FirstExplosion);
  With Explosions.FirstExplosion^ Do
  Begin {setup the new explosion}
    X:= X1;
    Y:= Y1;
    New(Frame);
    Frame^:= 0;
  End;
End;

{*** EVENTS AND INTERRUPT HANDLING ***}

{Handle player-died event}
Procedure KillPlayer;
Begin
  With Player Do
  Begin
    If Lifes > 0 Then Dec(Lifes);
    SetExplosion(X, Y);
  End;
End;

{Handle enemy-destoried event}
Procedure KillEnemy(Var Enemy : RecordPointer);
Begin
  With Enemy^ Do SetExplosion(X, Y);
  With Enemies Do
  Begin
    Erase(Enemy, FirstEnemy);
    If FirstEnemy = Nil Then {no more enemies left?}
    Begin {simply clear all objects on the screen}
      ErasePlayersBullets;
      EraseEnemies;
    End;
  End;
End;

{New keyboard handler}
Procedure NewKeyboardHandler; Interrupt;
  var Input : Byte;

  {Pop up usage informaton}
  Procedure ShowHelp;
  Begin
    With Font Do
    Begin {misc. information}
      Flip(VirtualScreen2^, Display^);
      OutPut((ScreenWidth - Length(GameTitle) * Width) Div 2, Width * 0, UpperStr(GameTitle), Display);
      OutPut((ScreenWidth - (3 + Length(Programmer) + Length(EMail) + 2)  * Width) Div 2, Width * 1, 'BY ' +
             UpperStr(Programmer) + '(' + UpperStr(EMail) + ')', Display);
      OutPut((ScreenWidth - 8 * Width) Div 2, Width * 3, '- HELP -', Display);
      OutPut((ScreenWidth - 8 * Width) Div 2, Width * 5, 'ESC:QUIT', Display);
      With GameSettings Do
      Begin {keys}
        OutPut((ScreenWidth - (Length(Key(Left)) + 10) * Width) Div 2, Width * 6,
               UpperStr(Key(Left)) + ':MOVE LEFT', Display);
        OutPut((ScreenWidth - (Length(Key(Right)) + 11) * Width) Div 2, Width * 7,
               UpperStr(Key(Right)) + ':MOVE RIGHT', Display);
        OutPut((ScreenWidth - (Length(Key(Shoot)) + 5) * Width) Div 2, Width * 8,
               UpperStr(Key(Shoot)) + ':SHOOT', Display);
      End;
    End;
    ReadKbdPort;
  End;

Begin
  Input:= Port[$60]; {read directly from the port}
  If Input = 225 Then {pause pressed?}
  Begin
    Pause:= Not Pause;
    If Not Pause Then {interrupt executed for second time?}
    Paused:= Not Paused; {change state}
    Port[$20]:= $20; {end of interrupt}
  End Else
  Begin
    With GameSettings Do
    Begin
      If Input =  Shoot Then Shooting:= True; {shoot if key is pressed}
      If Input =  Shoot + 128 Then Shooting:= False; {don't shoot in key is released}
      If Input in [Left, Left + 128, Right, Right + 128, 1, Ord(kF1)] Then Pressed:= Input; {get input}
    End;
    Inline($9C); {pushf}
    OldKbdHandler;
    If Input = Ord(kF1) Then ShowHelp;
    FlushKbdBuffer;
  End;
End;

{Return to OS}
Procedure Quit(ExitCode : Byte; Message : String);
Begin
  SetMode(TextMode);
  WriteLn(Message);
  Halt(Byte(ExitCode));
End;

{Determine if collision occured between two objects}
Function Collision(X1, Y1, Width1, Height1, X2, Y2, Width2, Height2 : Word) : Boolean;
Begin
  If (X1 + Width1 - 1 >= x2) And (X1 <= X2 + Width2 - 1) And (Y1 + Height1 - 1 >= y2) And (Y1 <= Y2 + Height2 - 1) Then
  Collision:= True Else Collision:= False;
End;

{New exit handler}
Procedure NewExitProc;
Begin
  SetDefaultSpeed; {restore state}
  SetIntVec($1C, @OldTimerHandler);
  SetIntVec($9, @OldKbdHandler);
  EraseAll;
  If ExitCode <> Success Then {run-time error occured?}
  Begin {acknowledge user}
    SetMode(TextMode);
    WriteLn('Run-time error ', ExitCode, ' at ', Seg(ErrorAddr^), ':', Ofs(ErrorAddr^));
  End;
  ExitProc:= OldExitProc;
  If ExitCode <> Success Then Halt(255) Else Halt;
End;

{New timer handler}
Procedure NewTimerHandler;

  {Determine if player was killed}
  Function PlayerKilled : Boolean;
  Begin
    PlayerKilled:= False;
    With CurrentRecord^ Do
    If Collision(Trunc(X), Trunc(Y), Enemies.BulletSprite.Width, Enemies.BulletSprite.Height,
                 Trunc(Player.X), Trunc(Player.Y), Player.SpaceShip.Width, Player.SpaceShip.Height) Then
    Begin {handle event}
      PlayerKilled:= True;
      Erase(CurrentRecord, Enemies.FirstBullet);
      KillPlayer;
    End;
  End;

  {Determine if an enemy was killed}
  Function EnemyKilled : Boolean;
    Var Enemy : RecordPointer;
    Label ByPass;

  Begin
    Enemy:= Enemies.FirstEnemy;
    While Enemy <> Nil Do
    With CurrentRecord^ Do
    If Collision(Trunc(X), trunc(Y), Player.BulletSprite.Width, Player.BulletSprite.Height,
                 Trunc(Enemy^.X), Trunc(Enemy^.Y), Enemies.SpaceShip.Width, Enemies.SpaceShip.Height) Then
    Begin {handle event}
      Erase(CurrentRecord, Player.FirstBullet);
      KillEnemy(Enemy);
      EnemyKilled:= True;
      Goto ByPass;
    End Else Enemy:= Enemy^.Next;
    EnemyKilled:= False;
    ByPass:
  End;

  {React on keypress}
  Procedure HandleKbdEvents;
  Begin
    With Player, GameSettings Do
    Begin
      If Pressed = 1{esc} Then Event:= GameHalted;
      If Enemies.FirstEnemy <> Nil Then {still enemies left?}
      Begin
        If Pressed = Left Then
        If X - PlayersHorizOffset >= 0 Then X:= X - Trunc(PlayersHorizOffset) Else X:= 0; {move left}
        If Pressed = Right Then If X + PlayersHorizOffset <= ScreenWidth - SpaceShip.Width Then {move right}
        X:= X + Trunc(PlayersHorizOffset) Else X:= ScreenWidth - SpaceShip.Width;
        If Shooting Then {shooting?}
        If FirstBullet = Nil Then SetBullet(X + (SpaceShip.Width - BulletSprite.Width) Div 2,
                                            Y - BulletSprite.Height, Player.FirstBullet){fire if no bullets are already flying}
        Else If FirstBullet^.Y < ScreenHeight Div 2 Then SetBullet(X + (SpaceShip.Width - BulletSprite.Width) Div 2,
        {check the distance between two bullets and fire}          Y - BulletSprite.Height, Player.FirstBullet);
      End Else If Lifes > 0 Then Y:= Y - 1; {move player's spaceship to the top of the screen (if alive)}
    End;
  End;

  {Simulate enemy's behaveour}
  Procedure HandleEnemies;
    Var XOutOfRange, YOutOfRange : Boolean;
        Label GoBack;

  Begin
    GoBack:
    XOutOfRange:= False;
    YOutOfRange:= False;
    CurrentRecord:= Enemies.FirstEnemy;
    While CurrentRecord <> Nil Do
    With CurrentRecord^, Enemies.SpaceShip Do
    Begin
      X:= X + LevelSettings.EnemysHorizOffset * Enemies.HorizDirection; {move to the right and backwards...}
      If (X + Width > ScreenWidth) or (X < 0) Then XOutOfRange:= True;
      Y:= Y + LevelSettings.EnemysVertOffset * Enemies.VertDirection; {move to the bottom and backwards...}
      If (Y + Height > ScreenHeight) or (Y < 0) Then YOutOfRange:= True;
      If Random(LevelSettings.RandomShoot) = 0 Then {shoot at a random time}
      SetBullet(Trunc(X) + (Width - Enemies.BulletSprite.Width) Div 2, Y + Height, Enemies.FirstBullet);
      If Collision(Trunc(X), Trunc(Y), Enemies.SpaceShip.Width, Enemies.SpaceShip.Height,
                   Trunc(Player.X), Trunc(Player.Y), Player.SpaceShip.Width, Player.SpaceShip.Height) Then
      Begin {player hitted}
        KillPlayer;
        KillEnemy(CurrentRecord);
      End Else CurrentRecord:= Next;
    End;
    If (XOutOfRange) or (YOutOfRange) Then {screen range exceeded?}
    Begin
      If XOutOfRange Then Enemies.HorizDirection:= -Enemies.HorizDirection
      Else Enemies.VertDirection:= -Enemies.VertDirection;
      Goto GoBack;
    End;
  End;

  {Update all active explosions}
  Procedure HandleExplosions;
  Begin
    CurrentRecord:= Explosions.FirstExplosion;
    While CurrentRecord <> Nil Do
    With CurrentRecord^, Explosions.ExplosionSprite Do
    Begin
      Frame^:= Frame^ + GameSettings.FrameDelay;
      If Frame^ > Height Div Width Then {explosion done?}
      Begin {erase it and handle results}
        Dispose(Frame);
        Erase(CurrentRecord, Explosions.FirstExplosion);
        If Enemies.FirstEnemy = Nil Then Event:= LevelCompleted;
        If Player.Lifes = 0 Then Event:= GameOver;
      End Else CurrentRecord:= Next;
    End;
  End;

  {Update all active enemy's bullets}
  Procedure HandleEnemysBullets;
  Begin
    CurrentRecord:= Enemies.FirstBullet;
    While CurrentRecord <> Nil Do
    Begin
      With Enemies.BulletSprite Do
      PutSprite(Trunc(CurrentRecord^.X), Trunc(CurrentRecord^.Y), Width, Height, Data, VirtualScreen1);
      CurrentRecord^.Y:= CurrentRecord^.Y + GameSettings.BulletOffset;
      If CurrentRecord^.Y > ScreenHeight Then Erase(CurrentRecord, Enemies.FirstBullet) {out of range}
      Else If Not PlayerKilled Then CurrentRecord:= CurrentRecord^.Next;
    End;
  End;

  {Update all active player's bullets}
  Procedure HandlePlayersBullets;
  Begin
    CurrentRecord:= Player.FirstBullet;
    While CurrentRecord <> Nil Do
    Begin
      CurrentRecord^.Y:= CurrentRecord^.Y - GameSettings.BulletOffset;
      If CurrentRecord^.Y + Player.BulletSprite.Height < 0 Then Erase(CurrentRecord, Player.FirstBullet) {out of range}
      Else If Not EnemyKilled Then CurrentRecord:= CurrentRecord^.Next;
    End;
  End;

Begin
  If (Not Bussy) And (Not Paused) Then {not already bussy and game isn't paused?}
  Begin {move objects and handle events...}
    Bussy:= True;
    HandleKbdEvents;
    HandleEnemies;
    HandleExplosions;
    HandleEnemysBullets;
    HandlePlayersBullets;
    Bussy:= False;
  End;
  Inline($9C); {pushf}
  OldTimerHandler;
End;

{*** INITALLIZATION AND SETUP ***}

{Setup player}
Procedure SetupPlayer;
Begin
  With Player, SpaceShip Do
  Begin
    X:= (ScreenWidth - Width) Div 2; {set in the middle at the bottom of the screen...}
    Y:= ScreenHeight - Height;
    FirstBullet:= Nil;
  End;
End;

{Setup enemies}
Procedure SetupEnemies;
Begin
  With Enemies Do
  Begin
    FirstEnemy:= Nil;
    FirstBullet:= Nil;
    HorizDirection:= 1; {direction=left}
    VertDirection:= 1; {direction=down}
  End;
End;

{Load the requested level and set new settings if asked}
Function LoadLevel(Level : Word; LoadSettings : Boolean) : Byte;
  Var Enemy : RecordPointer;
      Result : Byte;
      CurrentTimerHandler, CurrentKbdHandler : Procedure; {current interrupts}
      F : File;

Begin
  GetIntVec($9, @CurrentKbdHandler); {save current interrupts and restore the old ones...}
  GetIntVec($1C, @CurrentTimerHandler);
  SetIntVec($9, @OldKbdHandler);
  SetIntVec($1C, @OldTimerHandler);
  Result:= OpenFile(F, LevelFile + IntToStr(Level)); {try to open file}
  If Result <> Success Then {failed?}
  Begin {return...}
    LoadLevel:= Result;
    SetIntVec($9, @CurrentKbdHandler);
    SetIntVec($1C, @CurrentTimerHandler);
    Exit;
  End;
  ErasePlayersBullets; {erase everything and prepare the level...}
  EraseEnemies;
  EraseExplosions;
  SetupPlayer;
  SetupEnemies;
  If LoadSettings Then BlockRead(F, LevelSettings, SizeOf(LevelSettingsRecord)) {load settings if requested}
  Else Seek(F, SizeOf(LevelSettings)); {go to spaceships-position section}
  While Not Eof(F) Do
  With Enemies, Enemy^ Do
  Begin {create and setup the enemies}
    Create(Enemies.FirstEnemy);
    BlockRead(F, FirstEnemy^.X, SizeOf(X));
    BlockRead(F, FirstEnemy^.Y, SizeOf(Y));
  End;
  Close(F); {restore old game state...}
  SetIntVec($9, @CurrentKbdHandler);
  SetIntVec($1C, @CurrentTimerHandler);
  LoadLevel:= Success;
End;

{Initallize game}
Procedure Initallization;

  {Load setup file if avelable}
  Procedure Loadsetup;
    Var F : File;

  Begin
    If OpenFile(F, SettingsFile) <> Success Then Exit;
    Blockread(F, GameSettings, SizeOf(GameSettingsRecord));
    Close(F);
  End;

Begin
  GetIntVec($9, @OldKbdHandler);
  GetIntVec($1C, @OldTimerHandler);
  OldExitProc:= ExitProc;
  ExitProc:= @NewExitProc;
  Randomize;
  With GameSettings Do {set defaults}
  Begin
    Left:= Ord(kLeft);
    Right:= Ord(kRight);
    Shoot:= Ord(kCtrl);
    BulletOffset:= 1;
    PlayersHorizOffset:= 1;
    FrameDelay:= 0.1;
  End;
  With LevelSettings Do {set defaults}
  Begin
    RandomShoot:= 800;
    EnemysHorizOffset:= 0.8;
    EnemysVertOffset:= 0.005;
  End;
  LoadSetup;
  SetSpeed(Speed); {change timer frequency}
  TypeMatic(0, 0); {change typematic rate}
End;

Procedure STARTGAME;
Begin
  Event:= NoEvent; {reset default state...}
  Pressed:= 129;
  SetIntVec($1C, @NewTimerHandler); {setup new handlers...}
  SetIntVec($9, @NewKeyboardHandler);
  Repeat
    Flip(VirtualScreen2^, VirtualScreen1^); {animation step 1 - set background}
    If Not Paused Then
    OutPut(0, ScreenHeight - Font.Width + 1, 'LIFES:' + IntToStr(Player.Lifes) + ' LEVEL:' + IntToStr(CurrentLevel),
           VirtualScreen1) Else OutPut(0, ScreenHeight - Font.Width + 1, 'PAUSED', VirtualScreen1); {current state}
    {animation step 2 - set all active objects}
    With Player, SpaceShip Do
    Begin
      PutSprite(Trunc(X), Trunc(Y), Width, Height, Data, VirtualScreen1);
      PutSprites(FirstBullet, BulletSprite);
    End;
    With Enemies Do
    Begin
      PutSprites(FirstEnemy, Spaceship);
      PutSprites(FirstBullet, BulletSprite);
    End;
    PutExplosions;
    Flip(VirtualScreen1^, Display^); {animation step 3 - show the result on the screen}
  Until ((Event = LevelCompleted) And (Player.Y < -Player.SpaceShip.Height)) or
        ((Event = GameOver) And (Explosions.FirstExplosion = Nil)) or (Event = GameHalted);
  SetIntVec($1C, @OldTimerHandler); {restore hooked interrupts...}
  SetIntVec($9, @OldKbdHandler);
End;