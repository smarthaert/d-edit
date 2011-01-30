Uses CRT,Video,GameKeyb,RunError;

const timedeleting=50;
      TimeDeletingMove=10;
      StepAnthMove=2;

Var Pole : Array [1..30,1..18] of Byte;

{ - Подвижный обьект - }
Type
  TAction = (doNo,doUp,doDown,doLeft,doRight);
  TMoveObj = Object
    XC,YC : Byte;
    Direct : Boolean;
    Action : TAction;
    ActionStep : Word;
    Constructor Init( _XC,_YC:Byte );
    Procedure StartAction( _Action:TAction );
  End;

Constructor TMoveObj.Init;
  Begin
    XC:=_XC;
    YC:=_YC;
    Direct:=False;
    StartAction(doNo);
  End;

Procedure TMoveObj.StartAction( _Action:TAction );
  Begin
    Action     := _Action;
    ActionStep := 0;
    Case Action of
      doUp:    Dec(YC);
      doDown:  Inc(YC);
      doLeft:  Dec(XC);
      doRight: Inc(XC);
    End;
  End;

{ - Герой - }
Type
  TPlayer = Object(TMoveObj)
  End;
Var Player : TPlayer;

{ - Антигерой - }
Type
  TBeast = Object(TMoveObj)
    Sost:Byte;
    Constructor Init( _XC,_YC:Byte );
    procedure step;
    procedure deput;
    procedure put;
  End;

Constructor TBeast.Init( _XC,_YC:Byte );
  Begin
    Inherited Init(_XC,_YC);
    Sost:=0;
  End;

Var StepAnth:Byte;

Procedure TBeast.Step;
  Function GoTest(xc,yc:byte):boolean;
    Begin
      GoTest:=(pole[XC,YC]=0)or
              (pole[XC,YC]=4)or
              (pole[XC,YC]=12)or
              (pole[XC,YC]=3)or
              (pole[XC,YC]=2)or
              (pole[XC,YC]=5)or
              (pole[XC,YC]=8)or
              (pole[XC,YC]=9)or
              (pole[XC,YC]=13)or
              (pole[XC,YC]=14);
   End;
 Var Cmd:byte; Flag:Boolean;
 Begin
   deput;
   if sost>=255-TimeDeletingMove then
      Begin
        if sost<255 then Inc(sost) else
           Begin
             sost:=0;
             StartAction(doUp);
             if Direct then
               Begin
                 if XC>1 then
                   Begin
                     if gotest(XC-1,YC) then
                       StartAction(doLeft)
                     else
                       Begin
                         Direct:=not Direct;
                         StartAction(doDown);
                       End;
                   End
                 else
                   Begin
                     Direct:=not Direct;
                     StartAction(doDown);
                   End;
               End
               else
               Begin
                    if XC<30 then
                    Begin
                         if gotest(XC+1,YC) then
                         StartAction(doRight)
                         else
                         Begin
                              Direct:=not Direct;
                              StartAction(doDown);
                         End;
                    End
                    else
                         Begin
                              Direct:=not Direct;
                              StartAction(doDown);
                         End;
               End;
          End;
     end;
     Flag:=True;
     if YC<18 then
     if ((pole[XC,YC+1]=0) or (pole[XC,YC+1]=3) or (pole[XC,YC+1]=12))and((pole[XC,YC]=0)or(pole[XC,YC]=3)) then
     Begin
       Flag:=False;
       StartAction(doDown);
       sost:=random(2);
     end;
     If Flag then
     Begin
          If StepAnth=0 then
          if (pole[XC,YC]=0)or(pole[XC,YC]=4)or(pole[XC,YC]=3) then
          Begin
               cmd:=0;
               case sost of
               0:
               Begin
                    if ((Player.YC<YC)or((Player.XC>XC)and Direct)or
                       ((Player.XC<XC)and not Direct))and(cmd=0) then
                         Begin
                    if pole[XC,YC]=4 then
                           if gotest(XC,YC-1) then
                           Begin
                             sost:=random(2);
                             cmd:=3;
                           End;
                    if (XC>Player.XC) and(cmd=0) then
                    Begin
                          cmd:=1;
                          sost:=1;
                    End;
                    if (XC<Player.XC) and(cmd=0) then
                    Begin
                          cmd:=2;
                          sost:=1;
                    End;
                         End;
                    if (Player.YC>YC)and(cmd=0) then
                      if gotest(XC,YC+1) then
                      Begin
                        sost:=1;
                        cmd:=4;
                      End;
                    if (XC>Player.XC) and(cmd=0) then
                    Begin
                          cmd:=1;
                          sost:=1;
                    End;
                    if (XC<Player.XC) and(cmd=0) then
                    Begin
                          cmd:=2;
                          sost:=1;
                    End;
                    if cmd=0 then sost:=1;
               End;
               1:
               Begin
                         if (Player.YC>YC)and(cmd=0) then
                           if gotest(XC,YC+1) then
                           Begin
                             sost:=1;
                             cmd:=4;
                           End;
                    if pole[XC,YC]=4 then
                    if ((Player.YC<YC){or((Player.XC>XC)and Direct)or((Player.XC<XC)and not Direct)})and(cmd=0) then
                           if gotest(XC,YC-1) then
                           Begin
                             sost:=0;
                             cmd:=3;
                           End;
                    if Direct and(cmd=0) then
                    Begin
                      if XC>1 then
                        if gotest(XC-1,YC) then
                          cmd:=1 else
                          Begin
                                if XC<30 then
                                if gotest(XC+1,YC) then
                                cmd:=2 else sost:=1;
                          End
                          else cmd:=2;
                    End;
                    if not Direct and(cmd=0) then
                    Begin
                      if XC<30 then
                        if gotest(XC+1,YC) then
                          cmd:=2 else
                          Begin
                                if XC>1 then
                                if gotest(XC-1,YC) then
                                cmd:=1 else sost:=1;
                          End
                          else cmd:=1;
                    End;
                    if {(Player.YC>YC)and}(cmd=0) then
                           if gotest(XC,YC+1) then
                           Begin
                             sost:=random(2);
                             cmd:=4;
                           End;
                    if pole[XC,YC]=4 then
                    if {((Player.YC<YC)or((Player.XC>XC)and not Direct)or((Player.XC<XC)and Direct))and}(cmd=0) then
                           if gotest(XC,YC-1) then
                           Begin
                             sost:=0;
                             cmd:=3;
                           End;
               End;
          end;
               case cmd of
               1:
       Begin
            if Direct then
            Begin
                 if (XC>1) then
                 if gotest(XC-1,YC) then
                    StartAction(doLeft);
            end
            else Direct:=true;
       end;
               2:
       Begin
            if not Direct then
            Begin
                 if (XC<30) then
                 if gotest(XC+1,YC) then
                    StartAction(doRight);
            end
            else Direct:=false;
       end;
               3:
            if YC>1 then
            if (pole[XC,YC]=4) and (gotest(XC,YC-1)) then
            Begin
                    StartAction(doUp);
            end;
               4:
            if YC<18 then
            if gotest(XC,YC+1) then
            Begin
                    StartAction(doDown);
            end;
               End;
          End;
     End;
     put;
End;

procedure TBeast.deput;
var n:byte;
Begin
     case pole[XC,YC] of
     15,16:n:=12;
     6,10:n:=0;
     7,11:n:=4;
     17,18:n:=3;
     end;
     pole[XC,YC]:=n;
end;
procedure TBeast.put;
var n:byte;
Begin
     if (pole[XC,YC]=12) and (sost<255-TimeDeletingMove) then sost:=255-TimeDeletingMove;
     if Direct then
     case pole[XC,YC] of
     0,2,13,8,14:n:=10;
     4,9,5:n:=11;
     12:n:=16;
     3:n:=18;
     End
     else
     case pole[XC,YC] of
     0,2,13,8,14:n:=6;
     4,9,5:n:=7;
     12:n:=15;
     3:n:=17;
     End;
     pole[XC,YC]:=n;
End;


Var Beasts : Array [1..1000] of TBeast;
    BeastNum : Word;


type TDeleting=record
     XC,YC,Time:byte;
end;

Var ColGold,command,ColDeletings:byte;
    DirectPlayer:boolean;
    Deletings:array [1..timedeleting] of TDeleting;
procedure loadpole(FileName:string);
var F:File;
    i,j:byte;
Begin
     OpenFileRE(F,'Pole',FileName);
     BlockRead(F,pole,Sizeof(pole));
     Close(F);
     ColGold:=0;
     BeastNum:=0;
     for i:=1 to 30 do
     for j:=1 to 18 do
         Case pole[i,j] of
         3:Inc(ColGold);
         6,7,10,11:
         Begin
              Inc(BeastNum);
              Beasts[BeastNum].Init(I,J);
         End;
         2,5,8,9:
           Player.Init(i,j);
         End;
End;
procedure puthero(dir:boolean);
var n:byte;
    str,del:boolean;
Begin
     if pole[Player.XC,Player.YC]=3 then
       Begin
          Dec(ColGold);
          Sound(800);
       End;
     str:=(pole[Player.XC,Player.YC]=4);
     del:=(pole[Player.XC,Player.YC]=12);
     if dir then
        begin
             if str then n:=9 else if del then n:=14 else n:=8;
        end
        else
        begin
             if str then n:=5 else if del then n:=13 else n:=2;
        end;
     pole[Player.XC,Player.YC]:=n;
End;
procedure deputhero;
var n:byte;
    str,del:boolean;
Begin
     str:=((pole[Player.XC,Player.YC]=5)or
           (pole[Player.XC,Player.YC]=9));
     del:=((pole[Player.XC,Player.YC]=13)or
           (pole[Player.XC,Player.YC]=14));
     if str then n:=4 else if del then n:=12 else n:=0;
     pole[Player.XC,Player.YC]:=n;
End;
procedure StepDeletings;
var i:byte;
Begin
     i:=1;
     while i<=ColDeletings do
     Begin
          Inc(Deletings[i].Time);
          if Deletings[i].Time>=TimeDeleting then
          begin
               pole[Deletings[i].XC,Deletings[i].YC]:=1;
               Deletings[i]:=Deletings[ColDeletings];
               Dec(ColDeletings);
          end
          else Inc(i);
     End;
End;

procedure showpole;
var i,j:byte;
Begin
     for i:=1 to 30 do
     for j:=1 to 18 do
         showpoleklet(i,j,pole[i,j]);
End;

procedure StepAnths;
var i:byte;
Begin
     i:=1;
     Inc(StepAnth);
     If StepAnth>=StepAnthMove then
       StepAnth:=0;
     while i<=BeastNum do
     Begin
          if pole[Beasts[i].XC,Beasts[i].YC]=1 then
          Begin
               Beasts[i]:=Beasts[BeastNum];
               Dec(BeastNum);
          End
          else
          Begin
               Beasts[i].Step;
               Inc(i);
          End;
     End;

End;

Procedure YouKilled;
Var I:Byte;
Begin
   puthero(DirectPlayer);
   For I:=1 to 5 do
     Begin
        Sound(I*100+300);
        Delay(100);
        NoSound;
        Sound(I*100+200);
        Delay(100);
        NoSound;
        Sound(I*100+100);
        Delay(100);
        NoSound;
        Delay(100);
     End;
   Delay(1000);
End;

Procedure YouWin;
Var I:Byte;
Begin
   puthero(DirectPlayer);
   For I:=1 to 5 do
     Begin
        Sound(I*300+600);
        Delay(50);
        NoSound;
        Sound(I*300+100);
        Delay(150);
        NoSound;
        Sound(I*300+300);
        Delay(100);
        NoSound;
        Delay(100);
     End;
   Delay(1000);
End;

Procedure PlayerControl;
  Begin
    if Keys[cLeft ] and (Command=0) then command:=1;
    if Keys[cRight] and (Command=0) then command:=2;
    if Keys[cUp   ] and (Command=0) then command:=3;
    if Keys[cDown ] and (Command=0) then command:=4;
    if Keys[cSpace] and (Command=0) then command:=5;
    if Keys[cHome ] and (Command=0) then command:=6;
    if Keys[cPgUp ] and (Command=0) then command:=7;
    if Keys[cEnd  ] and (Command=0) then command:=8;
    if Keys[cPgDn ] and (Command=0) then command:=9;
    If Keys[cEsc] then RuntimeError('Esc нажали!');
  End;

Procedure PlayerStep;
  Var I:Byte;
  Begin
    Command:=0;
    For I:=1 to 10 do
      Begin
        showpole;
        PlayerControl;
        delay(5);
      End;
    deputhero;
  End;

var i:byte;
Var LevelList:Text; LevelNum:Byte; LevelFileName:String;
Begin
  InitVideo;
  StepAnth:=0;
  InitInt09;
  OpenTextRE(LevelList,'Level list','Levels\Levels.ini');
  Repeat
    Read(LevelList,LevelNum); Readln(LevelList,LevelFileName);
    While LevelFileName[1]=' ' do Delete(LevelFileName,1,1);
    LoadPole(LevelFileName);
    showpole;
    DirectPlayer:=false;
    ColDeletings:=0;
    repeat
      PlayerStep;
      if ((pole[Player.XC,Player.YC+1]=0) or (pole[Player.XC,Player.YC+1]=3)or(pole[Player.XC,Player.YC+1]=12))
        and not(pole[Player.XC,Player.YC]=4) then
       Begin
          Inc(Player.YC);
          Sound(4000-Player.YC*150);
       End
     else
     Begin
     Case command of
     1:
       Begin
            if DirectPlayer then
            Begin
                 if (Player.XC>1) then
                 if (pole[Player.XC-1,Player.YC]=0) or (pole[Player.XC-1,Player.YC]=4)
                    or (pole[Player.XC-1,Player.YC]=3)or (pole[Player.XC-1,Player.YC]=12) then
                    Player.StartAction(doLeft);
            end
            else DirectPlayer:=true;
       end;
     2:
       Begin
            if not DirectPlayer then
            Begin
                 if (Player.XC<30) then
                 if (pole[Player.XC+1,Player.YC]=0) or (pole[Player.XC+1,Player.YC]=4)
                    or (pole[Player.XC+1,Player.YC]=3)or (pole[Player.XC+1,Player.YC]=12) then
                    Player.StartAction(doRight);
            end
            else DirectPlayer:=false;
       end;
     3:
       Begin
            if (pole[Player.XC,Player.YC]=4) and (Player.YC>1) then
            if (pole[Player.XC,Player.YC-1]=4)or(pole[Player.XC,Player.YC-1]=12)or
               (pole[Player.XC,Player.YC-1]=0)or(pole[Player.XC,Player.YC-1]=3) then Dec(Player.YC);
       End;
     4:
       Begin
            if (Player.YC<18) then
            if (pole[Player.XC,Player.YC+1]=4)or(pole[Player.XC,Player.YC+1]=12)or
               (pole[Player.XC,Player.YC+1]=0)or(pole[Player.XC,Player.YC+1]=3) then
              Player.StartAction(doDown);
       End;
     5:
       Begin
            if DirectPlayer then
            Begin
                 if (Player.XC>1) then
                 if (pole[Player.XC-1,Player.YC+1]=1) then
                 Begin
                      pole[Player.XC-1,Player.YC+1]:=12;
                      Inc(ColDeletings);
                      Deletings[ColDeletings].XC:=Player.XC-1;
                      Deletings[ColDeletings].YC:=Player.YC+1;
                      Deletings[ColDeletings].Time:=0;
                      Sound(100);
                 end;
            End
            Else
            Begin
                 if (Player.XC<30) then
                 if (pole[Player.XC+1,Player.YC+1]=1) then
                 Begin
                      pole[Player.XC+1,Player.YC+1]:=12;
                      Inc(ColDeletings);
                      Deletings[ColDeletings].XC:=Player.XC+1;
                      Deletings[ColDeletings].YC:=Player.YC+1;
                      Deletings[ColDeletings].Time:=0;
                      Sound(100);
                 end;
            End;
       End;
     6:
       Begin
          DirectPlayer:=true;
       end;
     7:
       Begin
          DirectPlayer:=false;
       end;
     8:
       Begin
          if (Player.XC>1) then
            if (pole[Player.XC-1,Player.YC]=0) or (pole[Player.XC-1,Player.YC]=4)
              or (pole[Player.XC-1,Player.YC]=3)or (pole[Player.XC-1,Player.YC]=12) then
                Player.StartAction(doLeft);
       end;
     9:
       Begin
          if (Player.XC<30) then
            if (pole[Player.XC+1,Player.YC]=0) or (pole[Player.XC+1,Player.YC]=4)
              or (pole[Player.XC+1,Player.YC]=3)or (pole[Player.XC+1,Player.YC]=12) then
              Player.StartAction(doRight);
       end;
     end;
     end;
     puthero(DirectPlayer);
     StepAnths;
     StepDeletings;
     Delay(20);
     NoSound;
     until Keys[CEsc] or
       (Player.YC=18) or (pole[Player.XC,Player.YC]=1) or
       (pole[Player.XC,Player.YC]=6) or
       (pole[Player.XC,Player.YC]=7) or
       (pole[Player.XC,Player.YC]=10) or
       (pole[Player.XC,Player.YC]=11) or
       ((pole[Player.XC,Player.YC]>=15) And
       (pole[Player.XC,Player.YC]<=18)) or
       ((ColGold=0)And(BeastNum=0));
     showpole;
     If (Player.YC=18) or (pole[Player.XC,Player.YC]=1)or
       (pole[Player.XC,Player.YC]=6) or
       (pole[Player.XC,Player.YC]=7) or
       (pole[Player.XC,Player.YC]=10) or
       (pole[Player.XC,Player.YC]=11) or
       ((pole[Player.XC,Player.YC]>=15) And
       (pole[Player.XC,Player.YC]<=18)) then YouKilled;
     If ((ColGold=0)And(BeastNum=0)) then YouWin;
  Repeat
  Until Keys[cEsc] or Keys[cEnter];
  Until not Keys[cEnter];
  DoneVideo;
  RestoreInt09;
End.
