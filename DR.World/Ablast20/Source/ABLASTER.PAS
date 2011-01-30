{
                ÕÍÍÄ úù* Alien Blaster v2.0 *ùú ÄÍÍ¸
                ³  Programmed by Peter Moraliyski  ³
                ³(C) Copyright, All rights reserved³
                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ Written on 04 Nov.'98
   ***********************************************************************
   The source code is freeware and you're welcome to distribute it under
   the following conditions:
     ş Do not alter the author's name and/or the copyright information
     ş Credit me if you use the code or portion(s) from it
     ş Do not distribute with commercial purpouse
   Comments and suggestions are welcomed! Please report program bugs!

   Contact information:
   ~~~~~~~~~~~~~~~~~~~~
   URL: http://members.xoom.com/moraliyski/
   E-MAIL: ppm@freemail.c3.hu
   ICQ: 10657470
   ************************************************************************
}

Program AlienBlaster;
{$I abmain.pas}
{$I abcredit.pas}

Const MenuPcx = 'data\menu.pcx';
      ArrowPcx = 'data\arrow.pcx';

Type ChoiceType = (PlayGame, ShowCredits, LeaveGame);
Var Choice : ChoiceType;

{Load next level}
Procedure GotoNextLevel;
  Var Message1 : String;

begin
  Event:= NoEvent;
  Inc(CurrentLevel);
  Case LoadLevel(CurrentLevel, True) of
    Success : Begin {load next level}
      Message1:= 'LEVEL ' + IntToStr(CurrentLevel);
      Flip(VirtualScreen2^, Display^);
      OutPut((ScreenWidth - Length(Message1) * Font.Width) Div 2, (ScreenHeight - Font.Width) Div 2, Message1, Display);
      Delay(1000);
    End;
    FileNotFound : Begin {last level completed (no more levels left)}
      Message('CONGRATULATIONS!');
      Event:= LastLevelCompleted;
      CurrentLevel:= 0;
    End;
    Else Quit(CantLoadLevel, 'Can''t load level ' + inttostr(currentlevel) + '!'); {error reading file}
  End;
End;

{Show main menu}
Procedure MainMenu;
  Label ByPass;
  Const Stars = 300; {number of stars}
  Type StarRecord = Array[1..Stars] of Record {coordinates}
                                         X, Y : Integer;
                                         Z : Real;
                                        End;

  Var MenuSprite, ArrowSprite : SpriteRecord;
      StarX, StarY, Run : Word;
      StarColor : Byte;
      Star : ^StarRecord;

  {Initallize all stars}
  Procedure InitStars;
    Var Run : Word;

  Begin
    For Run:= 0 to 19 Do SetRGB(255 - Run, Run * 3, Run * 3, Run * 3); {setup palette}
    For Run:= 1 to Stars Do
    With Star^[Run] Do
    Begin {set on random locations}
      X:= Random(80);
      If Random(2) = 1 Then X:= -X;
      Y:= Random(50);
      If Random(2) = 1 Then Y:= -Y;
      Z:= Run;
    End;
  End;

  {Show stars}
  Procedure PlotStars;
    Var Run : Word;

  Begin
    For Run:= 1 to Stars Do
    With Star^[Run] Do
    Begin
      Z:= Z - 5;
      If Z <= 0 Then Z:= Stars; {set star further if it reached us}
      StarColor:= 236 + Trunc(Z) Div (Stars Div 20); {the further the star, the darker it gets}
      StarX:= 160 + Trunc((X Shl 8) / Z); {convert 3D to 2D coordinates...}
      StarY:= 100 + Trunc((Y Shl 8) / Z);
      If ((StarX >= 0) And (StarX <= ScreenWidth)) And ((StarY >= 0) And (StarY <= ScreenHeight)) Then {in display range?}
      PutPixel(StarX, StarY,StarColor, VirtualScreen1);
    End;
  End;

Begin
  With MenuSprite Do LoadImage(MenuPcx, Width, Height, Palette, Data);
  With ArrowSprite Do LoadImage(ArrowPcx, Width, Height, Palette, Data);
  SetPalette;
  New(Star); {setup stars...}
  InitStars;
  Repeat
    For Run:= 0 to ArrowSprite.Height Div ArrowSprite.Width - 1 Do {loop from the first to the last frame}
    Begin
      If KeyPressed Then {input?}
      Case ReadKey of {get input}
        kEsc : Quit(Success, GameTitle + LastUpdate);
        kEnter : Goto ByPass;
        kExtended : Case ReadKey of {move arrow}
                     kUp   : If Choice > PlayGame Then Dec(Choice);
                     kDown : If Choice < LeaveGame Then Inc(Choice);
                   End;
      End;
      Clear(0, Seg(VirtualScreen1^));
      PlotStars;
      With MenuSprite Do
      PutSprite((ScreenWidth - Width) Div 2, (ScreenHeight - Height) Div 2, Width, Height, Data, VirtualScreen1);
      With ArrowSprite Do
      PutSprite((ScreenWidth - MenuSprite.Width) Div 2 - Width - 2, (ScreenHeight - arrowSprite.width) div 2 +
               (Byte(Choice) - 1) * (menusprite.height div 3), Width, Width, Ptr(Seg(Data^), Ofs(Data^) + Width * Width * Run),
                VirtualScreen1);
      OutPut((ScreenWidth - (Length(GameTitle) + Length(Programmer) + 4) * Font.Width) Div 2, ScreenHeight - Font.Width,
             UpperStr(GameTitle) + ' BY ' + UpperStr(Programmer), VirtualScreen1); {show title}
      Flip(VirtualScreen1^, Display^);
      Delay(50);
    End;
  Until False;
  ByPass:
  With MenuSprite Do FreeMem(Data, Width * Height); {release used memory...}
  With ArrowSprite Do FreeMem(Data, Width * Height);
  Dispose(Star);
End;

Begin
  Initallization; {prepare...}
  SetMode(GraphicsMode);
  Repeat
    GetMem(VirtualScreen1, BufferSize); {setup main menu}
    New(Palette);
    LoadFont;
    Choice:= PlayGame;
    Repeat {make a choice}
      MainMenu;
      Case Choice of
        ShowCredits : Credits; {show credits}
        LeaveGame : Quit(Success, GameTitle + LastUpdate);
      End;
    Until Choice = PlayGame;
    Clear(0, Vga);
    LoadBackground; {load graphics...}
    LoadSprites;
    SetPalette;
    CurrentLevel:= 0;
    Player.Lifes:= DefaultLifes;
    Repeat
      GotoNextLevel; {jump to a new level}
      If Event <> LastLevelCompleted Then STARTGAME; {play the game}
      If Event = GameOver Then Message('GAME OVER'); {inform the player if all lifes are lost}
    Until Event in [GameHalted, GameOver, LastLevelCompleted];
    EraseAll;
  Until False;
End.