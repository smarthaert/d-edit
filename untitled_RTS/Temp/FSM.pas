unit FSM;

interface
uses controls,Classes,DXDraws,Dxmisc;

type
  TGameScene = (
                 gsNone,
                 gsIntro,
                 gsMainMenu,
                 gsMainGame,
                 gsGameOver,
                 gsGameFinished                 
                );
  TGameSubScene = (
                   gssNone,
                   gssMenu
                  );

  TGameState = class(TState)
  Private
   { Private Section }
  Protected
   { Protected Section }
   // Allows for cached images
   fImageList : TDXImageList;

   // handles advancing to the next Scene
   Procedure Done(Scene : TGameScene);overload; virtual;
   Procedure Done; overload; virtual;
  Public
   { Public Section }
   // the scene type
   FScene : TGameScene;
   // the state to change the state machine to, processed by a call to done
   fNextState : TGameScene;
   FSubScene : TGameSubScene;
   // indicates whether FScene should display graphics and do special processing
   DoSpecialProcessing : boolean;

   Constructor Create; Override;
   Destructor Destroy; Override;

   Procedure Initialize; virtual;
   Procedure Finalize; virtual;
   Procedure Execute; override;
   Procedure RenderGraphics; virtual;

   Procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
   Procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
   Procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;

   Procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
   Procedure KeyUp(var Key: Word; Shift: TShiftState);virtual;
   Procedure KeyPress(var Key : char); virtual;

  Published
   { Published Section }
  end; {TGameState}

  TGameStateMachine  = class(TStateMachine)
  Private
   { Private Section }
  Protected
   { Protected Section }
   FScene     : TGameScene;
   FNextScene : TGameScene;

   Procedure SetCurrentScene(AScene : TGameScene);
  Public
   { Public Section }

   Constructor Create;

   Procedure StartScene(AScene : TGameScene);
   Procedure EndScene;

   Procedure ToNextScene; // advances to the next scene if it doesnt = gsNone
   Property CurrentScene : TGameScene read FScene write SetCurrentScene;
   Property NextScene : TGameScene read FNextScene write FNextScene;

  Published
   { Published Section }
  end; {TGameStateMachine}

  TgsNone = class(TGameState)
  Public
   { Public Section }
   Constructor Create; override;
  end;

  TgsIntro = class(TGameState) end;
  TgsMainMenu = class(TGameState) end;
  TgsMainGame = class(TGameState) end;
  TgsGameFinished = class(TGameState) end;
  TgsGameOver = class(TGameState) end;

const
  gsIntroGraphics        = 'gsIntro.dxg';        {'GameTitl.dxg'}
  gsMainMenuGraphics     = 'gsMainMenu.dxg';     {'MainMenu.dxg'}
  gsMainGameGraphics     = 'gsMainGame.dxg';     {'.dxg'}// not used(not done)
  gsMainGameMenuGraphics = 'gsGameMenu.dxg';     {'GameMenu.dxg'}// not used
  gsGameOverGraphics     = 'gsGameOver.dxg';     {'.dxg'}// not used (not done)
  gsGameFinishedGraphics = 'gsGameFinishedS.dxg';{'GameOver.dxg'}
implementation
uses sysutils,Dxinput,Main;

Const
 DXInputButton = [isButton1, isButton2, isButton3,
 isButton4, isButton5, isButton6, isButton7, isButton8, isButton9, isButton10, isButton11,
 isButton12, isButton13, isButton14, isButton15, isButton16, isButton17, isButton18,
 isButton19, isButton20, isButton21, isButton22, isButton23, isButton24, isButton25,
 isButton26, isButton27, isButton28, isButton29, isButton30, isButton31, isButton32];
// -----------------------------------------------------------------------------
// TGameState
// -----------------------------------------------------------------------------

Constructor TGameState.Create;
begin
Inherited create;
fImageList := TDXImageList.create(nil);
fImageList.DXDraw := Mainform.DXDraw;
DoSpecialProcessing := true;
end; {Create}

Destructor TGameState.Destroy;
begin
FreeAndNil(fImageList);
Inherited Destroy;
end; {Destroy}

Procedure TGameState.Initialize;
begin
end; {Initialize}

Procedure TGameState.Finalize;
begin
end; {Finalize}

Procedure TGameState.Done(Scene : TGameScene);
begin
with TGameStateMachine(StateMachine) do
  NextScene := Scene;
end; {Done}

Procedure TGameState.Done;
begin
with TGameStateMachine(StateMachine) do
  NextScene := fNextState;
end;

Procedure TGameState.Execute;
begin
end; {Execute}

Procedure TGameState.RenderGraphics;
begin
end; {RenderGraphics}

Procedure TGameState.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end; {MouseDown}

Procedure TGameState.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end; {MouseUp}

Procedure TGameState.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end; {MouseMove}

Procedure TGameState.KeyDown(var Key: Word; Shift: TShiftState);
begin
end; {KeyDown}

Procedure TGameState.KeyUp(var Key: Word; Shift: TShiftState);
begin
end; {KeyUp}

Procedure TGameState.KeyPress(var Key : char);
begin
end; {KeyPress}

// -----------------------------------------------------------------------------
//  TgsNone
// -----------------------------------------------------------------------------

Constructor TgsNone.Create;
begin
Inherited create;
FScene := gsNone;
FSubScene := gssNone;
end;

// -----------------------------------------------------------------------------
// TGameStateMachine
// -----------------------------------------------------------------------------

Constructor TGameStateMachine.Create;
begin
Inherited Create;
AddState(TgsNone.create);
StartScene(gsNone);
end; {Create}

Procedure TGameStateMachine.SetCurrentScene(AScene : TGameScene);
begin
TGameState(CurrentState).finalize;
StartScene(AScene);
end; {SetCurrentScene}

Procedure TGameStateMachine.StartScene(AScene : TGameScene);
var
 Index : integer;
begin
for Index := 0 to StateList.Count - 1 do
  begin
  if TGameState(StateList[Index]).FScene = AScene then
    begin
    CurrentState := StateList[Index];
    FScene := AScene;
    with MainForm.DXInput do
      States := States - DXInputButton;
    try
     TGameState(CurrentState).Initialize;
     exit;
    except
     // the state caused an exception on Initialize, this means the state cant be used
     // cause the game to end
     StartScene(gsGameFinished);
     // make sure the app closes immediently
     TGameState(CurrentState).DoSpecialProcessing := false;
     // re-raise the exception
     raise;
    end;
    end;
  end;
end; {StartScene}

Procedure TGameStateMachine.EndScene;
begin
TGameState(CurrentState).finalize;
StartScene(gsNone);
end; {EndScene}

Procedure TGameStateMachine.ToNextScene;
begin
if FNextScene <> gsNone then
  begin
  StartScene(FNextScene);
  FNextScene := gsNone;
  end;
end; {ToNextScene}

end.
