{-= Level Editor for Alien Blaster =-}

Program Editor;
{$I abmain.pas}

Const ProgramTitle = 'Level Editor v1.0';
      NothingEntered = '';
      NotSaved = 0;

var LevelSettingsModified, GameSettingsModified : Boolean;
    Focus : RecordPointer;

{Pop up usage information}
Procedure ShowHelp; Forward;

{Update screen}
Procedure Update;
  Var FocusColor : Byte;
      Level : String;

Begin
  FocusColor:= Random(256);
  Level:= 'LEVEL:';
  If CurrentLevel = NotSaved Then Level:= Level + '(UNTITLED)'
  Else Level:= Level + IntToStr(CurrentLevel);
  With Focus^, Enemies.SpaceShip Do
  Begin
    With Focus^ Do
    Output(0, ScreenHeight - Font.Width + 1, 'X:' + IntToStr(Trunc(X)) + ' Y:' + IntToStr(Trunc(Y)), VirtualScreen1); {state}
    Output((ScreenWidth - Length(Level) * Font.Width) Div 2, ScreenHeight - Font.Width + 1, Level, VirtualScreen1);
    If LevelSettingsModified Then
    Output(ScreenWidth - 8 * Font.Width, ScreenHeight - Font.Width + 1, 'MODIFIED', VirtualScreen1);
    With Enemies Do PutSprites(FirstEnemy, Spaceship); {set all enemies}
    PutPixel(Trunc(X), Trunc(Y), FocusColor, VirtualScreen1); {show focus...}
    PutPixel(Trunc(X) + 1, Trunc(Y), FocusColor, VirtualScreen1);
    PutPixel(Trunc(X), Trunc(y) + 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 1, Trunc(Y), FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 2 , Trunc(Y), FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 1, Trunc(Y) + 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X), Trunc(Y) + Height - 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X), Trunc(Y) + Height - 2, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + 1, Trunc(Y) + Height - 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 1, Trunc(Y) + Height - 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 2, Trunc(Y) + Height - 1, FocusColor, VirtualScreen1);
    PutPixel(Trunc(X) + Width - 1, Trunc(Y) + Height - 2, FocusColor, VirtualScreen1);
  End;
End;

Procedure ShowHelp;
Begin
  Flip(VirtualScreen2^, Display^);
  With Font Do
  Begin {misc}
    Output((ScreenWidth + 1 - (Length(ProgramTitle) + 5 + Length(GameTitle)) * Width) Div 2, Width *  0,
            UpperStr(ProgramTitle) + ' FOR ' + UpperStr(GameTitle), Display);
    Output(0, Width *  1, 'BY ' + UpperStr(Programmer) + ' (' + UpperStr(EMail) + ')', Display);
    Output((ScreenWidth - 11 * Width) Div 2, Width *  3, '- HELP -', Display);
    Output(0, Width *  5, '(EDTING MODE)', Display);
    Output(0, Width *  6, ' ESC:QUIT EDITOR   ENTER:PLAY', Display);
    Output(0, Width *  7, '   +:SELECT NEXT       -:SELECT PREVIOUS', Display);
    Output(0, Width *  8, ' INS:CREATE NEW      DEL:ERASE SELECTED', Display);
    Output(0, Width *  9, 'PGUP:MOVE TO TOP    PGDN:MOVE TO BOTTOM  ', Display);
    Output(0, Width *  10, 'HOME:MOVE TO LEFT    END:MOVE TO RIGHT', Display);
    Output(0, Width * 11, '  F1:HELP SCREEN      F2:NEW LEVEL', Display);
    Output(0, Width * 12, '  F3:GAME SETTINGS    F4:LEVEL SETTINGS', Display);
    Output(0, Width * 13, '  F5:OPEN LEVEL       F6:SAVE LEVEL', Display);

    Output((ScreenWidth - 37 * Width) Div 2, Width * 15, 'USE THE ARROW KEYS TO MOVE THE CURSOR', Display);

    Output(0, Width * 17, '(PLAYING MODE)', Display);
    Output(0, Width * 18, 'ESC:QUIT GAME', Display);
    With GameSettings Do {keys}
    Begin
      Output(0, width * 19, UpperStr(Key(Left)) + ':MOVE LEFT', Display);
      Output(0, Width * 20, UpperStr(Key(Right)) + ':MOVE RIGHT', Display);
      Output(0, Width * 21, UpperStr(Key(Shoot)) + ':SHOOT', Display);
    End;
    ReadKey;
  End;
End;

{Edit text string or exit if nothing was entered}
Function EditString(Var Variable; Size : Byte; Var Modified : Boolean; Output : String) : boolean;
 Var Input : String;

begin
  Case Size Of
    SizeOf(Real) : Write(Output + ' (' + RealToStr(Real(Variable)) + '):');
    SizeOf(Word) : Write(Output + ' (' + RealToStr(Word(Variable)) + '):');
  End;
  ReadLn(Input);
  If Input = NothingEntered Then EditString:= False
  Else
  Begin
    Case Size Of
      SizeOf(Real) : Real(Variable):= StrToReal(Input);
      SizeOf(Word) : Word(Variable):= Word(Round(StrToReal(Input)));
    End;
    Editstring:= True;
    Modified:= True;
  End;
End;

{Edit settings}
Procedure EditGameSettings;

  {Get key or exit if esc was pressed}
  Procedure EditKey(Var Which : Byte; Message : String);
    Var Input : Byte;

  Begin
    Write(Message);
    Input:= ReadKbdPort;
    If Input <> 1{esc} Then
    Begin
      GameSettingsModified:= True;
      Which:= Input;
      Write(Key(Input));
    End;
    WriteLn;
  End;

Begin
  SetMode(TextMode);
  WriteLn('- GAME SETTINGS -');
  With GameSettings Do
  Begin
    EditKey(Left, 'Move left (' + Key(Left) + '):');
    EditKey(Right, 'Move rigth (' + Key(Right) + '):');
    EditKey(Shoot, 'Fire (' + Key(Shoot) + '):');
    EditString(BulletOffset, SizeOf(BulletOffset), GameSettingsModified, 'Bullet offset');
    EditString(PlayersHorizoffset, SizeOf(PlayersHorizOffset), GameSettingsModified, 'Player offset');
    EditString(FrameDelay, SizeOf(FrameDelay), GameSettingsModified, 'Frame delay');
  End;
  SetMode(GraphicsMode);
  SetPalette;
End;

{Modify level settings}
Procedure EditLevelSettings;
Begin
  SetMode(TextMode);
  WriteLn('- LEVEL SETTINGS -');
  With LevelSettings Do
  Begin
    EditString(RandomShoot, SizeOf(RandomShoot), LevelSettingsModified, 'Random shoot');
    EditString(EnemysHorizOffset, SizeOf(EnemysHorizOffset), LevelSettingsModified, 'Enemy X offset');
    EditString(EnemysVertOffset, SizeOf(EnemysVertOffset), LevelSettingsModified, 'Enemy Y offset');
  End;
  SetMode(GraphicsMode);
  SetPalette;
End;

{Load level}
Procedure Load;
  Label TryAgain;
  Var Enemy : RecordPointer;
      Modified : Boolean;
      Entered : Word;

Begin
  SetMode(TextMode);
  WriteLn('- LOAD -');
  TryAgain:
  Entered:= CurrentLevel;
  If EditString(Entered, SizeOf(CurrentLevel), Modified, 'Level') Then
  Begin
    If LoadLevel(Entered, True) <> Success Then
    Begin
      WriteLn('Error: Can not load level!');
      Goto TryAgain;
    End;
    CurrentLevel:= Entered;
    LevelSettingsModified:= False;
    Focus:= Enemies.FirstEnemy;
  End;
  SetMode(GraphicsMode);
  SetPalette;
End;

{Save level without asking for filename}
Function SaveDirect(Level : Word) : Integer;
  Var Enemy : RecordPointer;
      F : File;

Begin
  Assign(F, LevelFile + IntToStr(Level));
  {$I-} ReWrite(F, 1); {$I+}
  If IOResult <> Success Then
  Begin
    SaveDirect:= CantCreateFile;
    Exit;
  End;
  BlockWrite(F, LevelSettings, SizeOf(LevelSettingsRecord));
  Enemy:= Enemies.FirstEnemy;
  While Enemy <> Nil Do
  With Enemy^ Do
  Begin
    BlockWrite(F, X, SizeOf(X));
    BlockWrite(F, Y, SizeOf(Y));
    Enemy:= Next;
  End;
  Close(F);
  SaveDirect:= Success;
End;

{Ask for filename and save level}
Procedure Save;
  Label TryAgain;
  Var Temp : Word;
      Modified : Boolean;
      F : File;

Begin
  SetMode(TextMode);
  WriteLn('- SAVE -');
  TryAgain:
  Temp:= CurrentLevel;
  If EditString(Temp, SizeOf(CurrentLevel), Modified, 'Level') Then
  Begin
    If OpenFile(F, LevelFile + IntToStr(Temp)) = Success Then
    Begin
      Close(F);
      Write('Level exists! Overwrite?');
      If Not (UpCase(ReadKey) In [kEnter, kYes]) Then
      Begin
        WriteLn('No');
        Goto TryAgain;
      End;
    End;
    If SaveDirect(Temp) <> Success Then
    Begin
      Writeln('Error! Can''t save level');
      Exit;
    End Else LevelSettingsModified:= False;
    LoadLevel(Temp, False); {solving the first-in-last-out problem with pointers}
    SaveDirect(Temp);
    LoadLevel(Temp, False);
  End;
  CurrentLevel:= Temp;
  SetMode(GraphicsMode);
  SetPalette;
End;

{Save game settings}
Function SaveGameSettings : Integer;
  Var F : File;
      Result : Integer;

Begin
  Assign(F, SettingsFile);
  {$i-} ReWrite(F, 1); {$i+}
  Result:= IOResult;
  If Result <> Success Then
  Begin
    SaveGameSettings:= Result;
    Exit;
  End;
  SaveGameSettings:= Success;
  BlockWrite(F, GameSettings, SizeOf(GameSettings));
  Close(F);
End;

{Reset focus}
Procedure InitFocus;
Begin
  LevelSettingsModified:= False;
  CurrentLevel:= NotSaved;
  With Enemies Do
  Begin
    Create(FirstEnemy);
    FirstEnemy^.X:= 0;
    FirstEnemy^.Y:= 0;
    Focus:= FirstEnemy;
  End;
End;

{Handle input}
Procedure HandleKbdInput;
  Var Input : Char;

Begin
  Input:= ReadKey;
  With Enemies, Focus^ Do
  Case Input of
    kEsc : Begin
             If LevelSettingsModified Then
             Case Message('SAVE LEVEL?') of
               kYes, kEnter : Save;
               kEsc : Exit;
             End;
             If GameSettingsModified Then
             Case Message('SAVE SETTINGS?') of
               kYes, kEnter : If SaveGameSettings <> Success Then Message('ERROR! CAN''T SAVE SETTINGS!');
               kEsc : Exit;
             End;
             Quit(Success, ProgramTitle + LastUpdate);
             End;
    kEnter : Begin
               Player.Lifes:= DefaultLifes;
               SetupPlayer;
               SaveDirect(NotSaved); {solve the first-in-last-out problem by pointers...}
               LoadLevel(NotSaved, False);
               SaveDirect(NotSaved);
               LoadLevel(NotSaved, False);
               STARTGAME;
               If LoadLevel(NotSaved, False) <> Success Then
               Quit(CantLoadLevel, 'Can''t load ' + LevelFile + RealToStr(CurrentLevel) + ' level!');
               {Focus:= Enemies.FirstEnemy;}
             End;
    kPlus : If Next <> Nil Then Focus:= Next;
    kMinus : If Focus <> FirstEnemy Then Focus:= Previous;
    kExtended : Begin
      Input:= Readkey;
      If Input In [kIns, kDel, kLeft, kRight, kUp, kDown, kPgUp, kPgDn, kHome, kEnd] Then LevelSettingsModified:= True;
      Case Input Of
        kPgUp : Y:= 0;
        kPgDn : Y:= ScreenHeight + 1 - SpaceShip.Height;
        kHome : X:= 0;
        kEnd : X:= ScreenWidth + 1 - SpaceShip.Width;
        kUp : If Y > 0 Then Y:= Y - 1;
        kDown : If y + SpaceShip.Height - 1 < ScreenHeight Then Y:= Y + 1;
        kLeft : If X > 0 Then X:= X - 1;
        kRight : If X + SpaceShip.Width - 1 < ScreenWidth Then X:= X + 1;
        kF1 : ShowHelp;
        kF2 : Begin
                If LevelSettingsModified Then
                Case Message('SAVE LEVEL?') of
                  kYes, kEnter : Save;
                  kEsc : Exit;
                End;
                EraseEnemies;
                InitFocus;
              End;
        kF3 : EditGameSettings;
        kF4 : EditLevelSettings;
        kF5 : Begin
                If LevelSettingsModified Then
                Case Message('SAVE LEVEL?') of
                  kYes, kEnter : Save;
                  kEsc : Exit;
                End;
                Load;
              End;
        kF6 : Save;
        kDel : If Not ((Focus = FirstEnemy) And (Focus^.Next = Nil)) Then
               Begin
                 Erase(Focus, FirstEnemy);
                 If Focus = Nil Then Focus:= Previous;
               End;
        kIns : Begin
                 Create(FirstEnemy);
                 FirstEnemy^.X:= X;
                 FirstEnemy^.Y:= Y;
                 Focus:= FirstEnemy;
               End;
      End;
    End;
  End;
End;

BEGIN
  Initallization; {initallize and prapare...}
  SetupEnemies;
  GetMem(VirtualScreen1, BufferSize);
  New(Palette);
  SetMode(GraphicsMode);
  LoadFont;
  LoadBackground;
  LoadSprites;
  SetPalette;
  InitFocus;
  Repeat
    While Not Keypressed Do
    Begin {update screen}
      Flip(VirtualScreen2^, VirtualScreen1^);
      Update;
      Flip(VirtualScreen1^, Display^);
    End;
    HandleKbdInput; {react on input}
  Until False;
END.