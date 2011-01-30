Uses TPWindow;

Var Window : Pointer;
Begin
  MakeWindow(Window,1,1,40,3,True,True,True,$07,$07,$07,
    'Введите фамилию студента');
  DisplayWindow(Window);
  Readln;
  KillWindow(Window);
End.