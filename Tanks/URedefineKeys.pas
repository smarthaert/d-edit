unit URedefineKeys;

interface

Uses DXInput,UUnits,UMyMenu,Pointers,Graphics,SysUtils,Windows,Dialogs;

Const
  MaxPressKeyDelay=200;
  KeysFile='keys.dat';

Type
  TPlayerKeys=Array [TPlayerControlKey] of Word;
  TPlayersKeys=Array [1..2] of TPlayerKeys;
  TRedefineKeysMenu=Class(TObject)
  Private
    procedure SetCurrentPlayer(const Value: Byte);
  Private
    MainMenu,PlayerMenu:TMyMenu;
    FCurrentPlayer:Byte;
    PressKey:Boolean;
    Changing:TPlayerControlKey;
    PressKeyDelay:Integer;
    Property CurrentPlayer:Byte
      Read FCurrentPlayer
      Write SetCurrentPlayer;
    Function MainMenuInput(MoveCount:Integer):Boolean;
    Procedure PlayerMenuInput(MoveCount:Integer);
    Procedure ShowKeys;
  Public
    DefaultKeys,CurrentKeys:TPlayersKeys;
    Constructor Create(DXInput:TDXInput);
    Destructor Destroy; Override;
    Function Step(MoveCount:Integer):Boolean;
    Function TrySave:Boolean;
    Function TryLoad:Boolean;
  End;

Var RedefineKeysMenu:TRedefineKeysMenu;

Function KeyName(N:Word):ShortString;
Function NameToPlayerControlKey(N:ShortString;Var K:TPlayerControlKey):Boolean;

implementation

Function NameToPlayerControlKey(N:ShortString;Var K:TPlayerControlKey):Boolean;
Begin
  Result:=True;
  If N='UP'       then K:=pkUP    Else
  If N='DOWN'     then K:=pkDOWN  Else
  If N='LEFT'     then K:=pkLEFT  Else
  If N='RIGHT'    then K:=pkRIGHT Else
  If N='FIRE'     then K:=pkFIRE1 Else
  If N='AUTOFIRE' then K:=pkFIRE2 Else
  Result:=False;
End;

Function KeyName(N:Word):ShortString;
Begin
  Result:='KEY '+IntToStr(N);
  If (N>=32)And(N<=127) then Result:=Chr(N);
  {If ((N>=Ord('A'))And(N<=Ord('Z')))Or((N>=Ord('0'))And(N<=Ord('9'))) then
    Begin
      Result:=Chr(N);
      Exit;
    End;}
  If (N>=96)And(N<=105) then
    Begin
      Result:='NUMPAD '+IntToStr(N-96);
      Exit;
    End;
  If (N>=112)And(N<=135) then
    Begin
      Result:='F'+IntToStr(N-111);
      Exit;
    End;
  Case N of
  (*{ Virtual Keys, Standard Set }
  VK_LBUTTON = 1;
  VK_RBUTTON = 2;
  VK_CANCEL = 3;
  VK_MBUTTON = 4;  { NOT contiguous with L & RBUTTON }
  VK_CLEAR = 12;
  VK_MENU = 18;
  VK_CAPITAL = 20;
  VK_KANA = 21;
  VK_HANGUL = 21;
  VK_JUNJA = 23;
  VK_FINAL = 24;
  VK_HANJA = 25;
  VK_KANJI = 25;
  VK_CONVERT = 28;
  VK_NONCONVERT = 29;
  VK_ACCEPT = 30;
  VK_MODECHANGE = 31;
  //VK_PRIOR = 33;
  //VK_NEXT = 34;
  VK_SELECT = 41;
  //VK_PRINT = 42;
  VK_EXECUTE = 43;
  VK_SNAPSHOT = 44;
  VK_HELP = 47;
  VK_LWIN = 91;
  VK_RWIN = 92;
  VK_APPS = 93;
  //VK_DECIMAL = 110;
  //VK_DIVIDE = 111;
  VK_NUMLOCK = 144;
  VK_SCROLL = 145;
{ VK_L & VK_R - left and right Alt, Ctrl and Shift virtual keys.
  Used only as parameters to GetAsyncKeyState() and GetKeyState().
  No other API or message will distinguish left and right keys in this way. }
  VK_LSHIFT = 160;
  VK_RSHIFT = 161;
  VK_LCONTROL = 162;
  VK_RCONTROL = 163;
  VK_LMENU = 164;
  VK_RMENU = 165;
  VK_PROCESSKEY = 229;
  VK_ATTN = 246;
  VK_CRSEL = 247;
  VK_EXSEL = 248;
  VK_EREOF = 249;
  VK_PLAY = 250;
  VK_ZOOM = 251;
  VK_NONAME = 252;
  VK_PA1 = 253;
  VK_OEM_CLEAR = 254;
    VK_MULTIPLY :Result:='NUMPAD *' ;
    VK_SEPARATOR:Result:='NUMPAD /' ;
  *)
    VK_RETURN   :Result:='ENTER'    ;
    VK_BACK     :Result:='BACKSPACE';
    VK_TAB      :Result:='TAB'      ;
    VK_SHIFT    :Result:='SHIFT'    ;
    VK_CONTROL  :Result:='CONTROL'  ;
    VK_PAUSE    :Result:='PAUSE'    ;
    VK_ESCAPE   :Result:='ESC'      ;
    VK_SPACE    :Result:='SPACE'    ;
    VK_END      :Result:='END'      ;
    VK_HOME     :Result:='HOME'     ;
    VK_LEFT     :Result:='LEFT'     ;
    VK_UP       :Result:='UP'       ;
    VK_RIGHT    :Result:='RIGHT'    ;
    VK_DOWN     :Result:='DOWN'     ;
    VK_INSERT   :Result:='INSERT'   ;
    VK_DELETE   :Result:='DELETE'   ;
    VK_ADD      :Result:='NUMPAD +' ;
    VK_SUBTRACT :Result:='NUMPAD -' ;
    VK_DECIMAL  :Result:='NUMPAD .' ;
    VK_DIVIDE   :Result:='NUMPAD /' ;
    VK_PRIOR    :Result:='PAGE UP'  ;
    VK_NEXT     :Result:='PAGE DOWN';
    VK_PRINT    :Result:='NUMPAD *' ;
  End;
End;

{ TRedefineKeysMenu }

constructor TRedefineKeysMenu.Create(DXInput: TDXInput);
Const
  CKeys:Array[1..2,TPlayerControlKey] of TDXInputState=
    (
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isUp      ,isDown    ,isLeft    ,isRight   ,isButton1 ,isButton2 ),
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isButton10,isButton11,isButton12,isButton13,isButton14,isButton15)
    );
Var
  I:Byte;
  K:TPlayerControlKey;
begin
  inherited Create;
  {Initialize keys}
  With DXInput.Keyboard do
    For I:=1 to 2 do
      For K:=pkUP to pkFIRE2 do
        DefaultKeys[I,K]:=KeyAssigns[CKeys[I,K],0];
  CurrentKeys:=DefaultKeys;
  {Try load}
  If Not TryLoad then
    CurrentKeys:=DefaultKeys;

  FCurrentPlayer:=0;
  PressKey:=False;
  PressKeyDelay:=0;
  Changing:=pkUP;
  {Main menu}
  MainMenu:=TMyMenu.MyCreate(Nil,200,40);
  MainMenu.AddTextItem('1 PLAYER KEYS');
  MainMenu.AddTextItem('2 PLAYER KEYS');
  MainMenu.AddTextItem('SAVE KEYS');
  MainMenu.AddTextItem('LOAD KEYS');
  MainMenu.AddTextItem('DEFAULT KEYS');
  MainMenu.AddTextItem('RETURN');
  {Player keys menu}
  PlayerMenu:=TMyMenu.MyCreate(Nil,200,40);
  PlayerMenu.AddValueItem('UP','');
  PlayerMenu.AddValueItem('DOWN','');
  PlayerMenu.AddValueItem('LEFT','');
  PlayerMenu.AddValueItem('RIGHT','');
  PlayerMenu.AddValueItem('FIRE','');
  PlayerMenu.AddValueItem('AUTOFIRE','');
  PlayerMenu.AddTextItem('DEFAULT KEYS');
  PlayerMenu.AddTextItem('RETURN');
end;

destructor TRedefineKeysMenu.Destroy;
begin
  PlayerMenu.Free;
  MainMenu.Free;
  inherited;
end;

function TRedefineKeysMenu.MainMenuInput(MoveCount: Integer): Boolean;
Var R:ShortInt;
begin
  Result:=False;
  R:=MainMenu.Input(MoveCount);
  If R=0 then Exit;
  With MainMenu do
    Begin
      If Items[NumSel].Name='1 PLAYER KEYS' then CurrentPlayer:=1;
      If Items[NumSel].Name='2 PLAYER KEYS' then CurrentPlayer:=2;
      If CurrentPlayer<>0 then Exit;
      If Items[NumSel].Name='DEFAULT KEYS' then CurrentKeys:=DefaultKeys;
      If Items[NumSel].Name='LOAD KEYS' then
        If Not TryLoad then
          ShowMessage('Load keys failed');
      If Items[NumSel].Name='SAVE KEYS' then
        If Not TrySave then
          ShowMessage('Save keys failed');
      If Items[NumSel].Name='RETURN' then Result:=True;
    End;
end;

procedure TRedefineKeysMenu.PlayerMenuInput(MoveCount: Integer);
Var R:ShortInt;
    I:Integer;
begin
  If PressKey then
    Begin
      If Not HandleTimeDec(PressKeyDelay,MoveCount) then Exit;
      For I:=1 to 255 do
        If MyDXInput.Keyboard.Keys[I] then
          Begin
            PressKey:=False;
            CurrentKeys[CurrentPlayer,Changing]:=I;
            ShowKeys;
            Exit;
          End;
      Exit;
    End;
  R:=PlayerMenu.Input(MoveCount);
  If R=0 then Exit;
  With PlayerMenu do
    Begin
      If Items[NumSel].Name='RETURN' then
       Begin
         CurrentPlayer:=0;
         Exit;
       End;
      If Items[NumSel].Name='DEFAULT KEYS' then
        Begin
          CurrentKeys[CurrentPlayer]:=DefaultKeys[CurrentPlayer];
          ShowKeys;
        End;
      If Items[NumSel].Typ<>itValue then Exit;
      If NameToPlayerControlKey(Items[NumSel].Name,Changing) then
        Begin
          PressKey:=True;
          Items[NumSel].Value:='<PRESS>';
          PressKeyDelay:=MaxPressKeyDelay;
          Exit;
        End;
    End;
end;

procedure TRedefineKeysMenu.SetCurrentPlayer(const Value: Byte);
begin
  FCurrentPlayer := Value;
  ShowKeys;
end;

procedure TRedefineKeysMenu.ShowKeys;
Var
  I:Integer;
  K:TPlayerControlKey;
begin
  If FCurrentPlayer=0 then Exit;
  With PlayerMenu do
    For I:=0 to Count-1 do
      Begin
        If Items[I].Typ<>itValue then Continue;
        If NameToPlayerControlKey(Items[I].Name,K) then Items[I].Value:=KeyName(CurrentKeys[FCurrentPlayer,K]);
      End;
end;

function TRedefineKeysMenu.Step;
begin
  Result:=False;
  If Not MyDXDraw.CanDraw then Exit;
  With MyDXDraw.Surface.Canvas do
    Begin
      Brush.Style:=bsClear;
      Font.Color:=clYellow;
      Font.Style:=[fsBold];
      If CurrentPlayer=0 then
        TextOut(250,10,'REDEFINE KEYS')
        Else
        TextOut(250,10,'PLAYER '+IntToStr(CurrentPlayer)+' KEYS');
      Font.Style:=[];
    End;
  If CurrentPlayer=0 then
    MainMenu.Paint(MyDXDraw.Surface.Canvas)
    Else
    PlayerMenu.Paint(MyDXDraw.Surface.Canvas);
  MyDXDraw.Surface.Canvas.Release;
  If CurrentPlayer=0 then
    Result:=MainMenuInput(MoveCount)
    Else
    PlayerMenuInput(MoveCount);
end;

function TRedefineKeysMenu.TryLoad: Boolean;
Var
  F:File;
  R:Integer;
begin
  Result:=True;
  Assign(F,KeysFile);
  {$I-}
  Reset(F,1);
  If IOResult<>0 then
    Result:=False
    Else
    Begin
      BlockRead(F,CurrentKeys,SizeOf(CurrentKeys),R);
      If R<SizeOf(CurrentKeys) then Result:=False;
      Close(F)
    End;
  {$I+}
end;

function TRedefineKeysMenu.TrySave: Boolean;
Var
  F:File;
  R:Integer;
begin
  Result:=True;
  Assign(F,KeysFile);
  {$I-}
  Rewrite(F,1);
  If IOResult<>0 then
    Result:=False
    Else
    Begin
      BlockWrite(F,CurrentKeys,SizeOf(CurrentKeys),R);
      If R<SizeOf(CurrentKeys) then Result:=False;
      Close(F)
    End;
  {$I+}
end;

end.
