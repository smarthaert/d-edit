Uses Objects,Views,Dialogs,App,Drivers,editors;

Const
  cmPickClicked = 1001;
  cmAddExam     = 1002;

{ ---=== Список возможных экзаменов ===--- }
 Type
   PExamsColl = ^TExamsColl;
   TExamsColl = Object(TStringCollection)
     Constructor Init;
   End;

 Constructor TExamsColl.Init;
   Begin
     Inherited Init(10,10);
     Insert(NewStr('Высшая Математика'));
     Insert(NewStr('Химия'));
     Insert(NewStr('ОАиПр'));
     Insert(NewStr('Иностранный Язык'));
   End;

 Var ExamsList:PExamsColl;

{ ---===}
Var GControl: PView;
    S  : String[30];

 Type
   PPickLine = ^TPickLine;
   TPickLine = object(TMemo)
     Procedure HandleEvent(var Event: TEvent); virtual;
   End;

 Procedure TPickLine.HandleEvent( Var Event:TEvent );
 VAR
   Count:Integer;
 begin
   inherited HandleEvent(Event);
   if (Event.What = evBroadcast) and (Event.command=cmListItemSelected) then
     begin
       S:=PListBox(Event.InfoPtr)^.GetText(PListBox(Event.InfoPtr)^.Focused,
                                           high(s));
       with PListBox(Event.InfoPtr)^ do
       begin
         s := s + #13;
         InsertText(@s[1],length(s),false);
       end;
       DrawView;
       ClearEvent(Event);
     end;
 end;

{ ---=== Окно редактирования экзаменов ===--- }
 Type
   PExamsWindow = ^TExamsWindow;
   TExamsWindow = Object(TDialog)
     Constructor Init;
   End;

 Constructor TExamsWindow.Init;
   Var
     R:TRect;
     Control: PView;
     ScrollBar: PScrollBar;
   Begin
     R.Assign(0, 0, 40, 15);
     Inherited Init(R, 'Pick List Window');
     Options := Options or ofCentered;
     R.Assign(5, 2, 35, 4);
  Control := New(Ppickline,Init(R,NIL,NIL,NIL,130));
  Control^.EventMask := Control^.EventMask or evBroadcast;
  Insert(Control);
  R.Assign(34, 5, 35, 11);
  New(ScrollBar, Init(R));
  Insert(ScrollBar);
  R.Assign(5, 5, 34, 11);
  gControl := New(PListBox, Init(R, 1, ScrollBar));
  Insert(gControl);
  PListBox(gControl)^.NewList(ExamsList);
  R.Assign(4, 4, 12, 5);
  Insert(New(PLabel, Init(R, 'Items:', Control)));
  R.Assign(15, 12, 25, 14);
  Insert(New(PButton, Init(R, '~Q~uit', cmQuit, bfDefault)));
  R.Assign(27, 12, 37, 14);
  Insert(New(PButton, Init(R, '~A~dd', cmAddExam, bfDefault)));
end;

{ ---=== Основная Программа ===--- }
 Type
    TDecApp = Object(TApplication)
      ExamsWindow:PExamsWindow;
      Constructor Init;
    End;

 Constructor TDecApp.Init;
   Begin
     Inherited Init;
     ExamsList := New(PExamsColl,Init);
     ExamsWindow := New(PExamsWindow, Init);
     InsertWindow(ExamsWindow);
   End;

Var DecApp:TDecApp;
Begin
  DecApp.Init;
  DecApp.Run;
  DecApp.Done;
End.