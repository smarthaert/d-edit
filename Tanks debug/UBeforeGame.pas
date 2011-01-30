unit UBeforeGame;

interface

Uses UMyMenu,Classes,Graphics,Pointers,SysUtils;

Type
  TBeforeGameScreen=Class(TComponent)
  Public
    Menu:TMyMenu;
    GameType,Skill:Integer;
    Constructor Create(AOwner:TComponent);Override;
    Destructor Destroy;Override;
    Function Step(MoveCount:Integer):Integer;
  End;

Var
  BeforeGameScreen:TBeforeGameScreen;

implementation

Uses Main,UUnits;

Const
  NGameTypeCount=5;
  NGameType:Array [1..NGameTypeCount] of String=('1 PL','2 PL','COOP','DM','DUEL');
  NSkillCount=15;
  DefaultSkill=2;

{ TBeforeGameScreen }

constructor TBeforeGameScreen.Create(AOwner: TComponent);
begin
  inherited;
  Menu:=TMyMenu.MyCreate(Self,200,5);
  GameType:=3;
  Skill:=DefaultSkill;
  Menu.AddTextItem('START');
  Menu.AddValueItem('GAME TYPE',NGameType[GameType]);
  Menu.AddValueItem('SKILL',IntToStr(Skill));
  Menu.AddValueItem('MAP',MapName);
  Menu.AddTextItem('EXIT');
end;

destructor TBeforeGameScreen.Destroy;
begin
  FreeAndNil(Menu);
  inherited;
end;

Function TBeforeGameScreen.Step;
Var R:ShortInt;
begin
  With Menu do
    Begin
      Result:=0;
      If Not MyDXDraw.CanDraw then Exit;
      Menu.Paint(MyDXDraw.Surface.Canvas);
      { Copyrights }
      With MyDXDraw.Surface.Canvas do
        Begin
          Font.Color:=clWhite;
          Font.Style:=[fsItalic];
          TextOut(20,420,'This program is freeware');
          TextOut(20,440,'stkolj.narod.ru');
          Font.Style:=[];
        End;
      MyDXDraw.Surface.Canvas.Release;
      R:=Input(MoveCount);
      If R=0 then Exit;
      If R=1 then
        If Items[NumSel].Name='START' then
          Begin
            Result:=1;
            CoopPlay:=True;
            If (NGameType[GameType]='DUEL') Or
               (NGameType[GameType]='DM'  ) then
              CoopPlay:=False;
            WithoutEnemy:=(NGameType[GameType]='DUEL');
            PlayersCount:=pcTwoPlayers;
            If NGameType[GameType]='1 PL' then
              PlayersCount:=pcPlayer1;
            If NGameType[GameType]='2 PL' then
              PlayersCount:=pcPlayer2;
            GameSkill:=Skill;
          End;
      If Items[NumSel].Name='GAME TYPE' then
        Begin
          Inc(GameType,R);
          If GameType<1 then GameType:=NGameTypeCount;
          If GameType>NGameTypeCount then GameType:=1;
          Items[NumSel].Value:=NGameType[GameType];
        End;
      If Items[NumSel].Name='SKILL' then
        Begin
          Inc(Skill,R);
          If Skill<1 then Skill:=NSkillCount;
          If Skill>NSkillCount then Skill:=1;
          Items[NumSel].Value:=IntToStr(Skill);
        End;
      If Items[NumSel].Name='EXIT' then
        Result:=2;
    End;
end;

end.
