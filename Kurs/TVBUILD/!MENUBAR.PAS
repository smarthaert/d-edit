Uses Objects,Menus,Views,Drivers,App;

Type
  TNewApplication = Object(TApplication)
    Procedure InitMenuBar; Virtual;
  End;

 Procedure TNewApplication.InitMenuBar;
  {$I _MENUBAR.INC}

Var NewApppication : TNewApplication;
Begin
  NewApppication.Init;
  NewApppication.Run;
  NewApppication.Done;
End.