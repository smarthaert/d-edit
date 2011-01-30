Uses Objects,Validate,Menus,Drivers,Views,Dialogs,App,Dlg,Calc,
     Calendar,StdDlg;

Const
 { ---=== HC ===--- }
  hcSystem     = $0101;
  hcAbout      = $0102;
  hcLoad       = $0103;
  hcCalendar   = $0104;
  hcCalculator = $0105;
  hcTeachers   = $0106;
  hcExams      = $0107;
  hcGroups     = $0108;
 { ---=== CM ====--- }
  cmAbout      = $0101;
  cmLoad       = $0102;
  cmCalendar   = $0103;
  cmCalculator = $0104;

Type
  TExams = Object(TApplication)
    Constructor Init;
    Procedure InitMenuBar; Virtual;
    Procedure HandleEvent( Var Event:TEvent ); Virtual;
    Procedure About;
  End;

Constructor TExams.Init;
  Begin
    Inherited Init;
{    Insert(CreateTeachersDialog);}
  End;

Procedure TExams.InitMenuBar;
  Var R:TRect;
  Begin
    GetExtent(R);
    R.B.Y := R.A.Y+1;
    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~С~истема', hcSystem, NewMenu(
        NewItem('~С~охранить состояние','F2', kbF2, cmSave, hcSave,
        NewItem('~В~осстановить состояние','F3', kbF3, cmLoad, hcLoad,
        NewItem('С~м~енить каталог','', kbNoKey, cmChangeDir, hcChangeDir,
        NewLine(
        NewItem('К~а~лендарь','', kbNoKey, cmCalendar, hcCalendar,
        NewItem('~К~алькулятор','', kbNoKey, cmCalculator, hcCalculator,
        NewLine(
        NewItem('~О~ программе','', kbNoKey, cmAbout, hcAbout,
        nil))))))))),
      NewSubMenu('~П~реподаватели', hcTeachers, NewMenu(
        NewItem('К~а~лендарь','', kbNoKey, cmCalendar, hcCalendar,
        NewItem('~К~алькулятор','', kbNoKey, cmCalculator, hcCalculator,
        nil))),
      NewSubMenu('~Э~кзамены', hcExams, NewMenu(
        NewItem('К~а~лендарь','', kbNoKey, cmCalendar, hcCalendar,
        NewItem('~К~алькулятор','', kbNoKey, cmCalculator, hcCalculator,
        nil))),
      NewSubMenu('~Г~руппы', hcGroups, NewMenu(
        NewItem('К~а~лендарь','', kbNoKey, cmCalendar, hcCalendar,
        NewItem('~К~алькулятор','', kbNoKey, cmCalculator, hcCalculator,
        nil))),
      nil)))))));
  End;

Procedure TExams.About;
  Var D:PDialog; Control:PView; R:TRect;
  Begin
    R.Assign(0, 0, 40, 11);
    D := New(PDialog, Init(R, 'О программе'));
    With D^ do
      Begin
        Options := Options or ofCentered;
        R.Grow(-1, -1);
        Dec(R.B.Y, 3);
        Insert(New(PStaticText, Init(R,
          #13 +
           ^C'Планирование Расписания Экзаменов'#13 +
          #13 +
           ^C'Copyright (c) 2000'#13 +
          #13 +
           ^C'Step by Step International')));
        R.Assign(15, 8, 25, 10);
        Insert(New(PButton, Init(R, 'O~K', cmOk, bfDefault)));
      End;
    If ValidView(D) <> nil then
      Begin
        Desktop^.ExecView(D);
        Dispose(D, Done);
      End;
  End;

Procedure TExams.HandleEvent( Var Event:TEvent );
  Begin
    Inherited HandleEvent(Event);
    Case Event.What of
      evCommand:
        Case Event.Command of
          cmChangeDir: ExecuteDialog(New(PChDirDialog, Init(cdNormal, 0)), nil);
          cmCalculator: InsertWindow(New(PCalculator, Init));
          cmCalendar: InsertWindow(New(PCalendarWindow, Init));
          cmAbout: About;
        Else
          Exit;
        End;
    Else
      Exit;
    End;
    ClearEvent(Event);
  End;

Var Application:TExams;
Begin
  Application.Init;
  Application.Run;
  Application.Done;
End.
