Uses Objects,Menus,Views,Drivers,Dialogs,App,Editors,Cyr,Polynoms;

{$I POLY.PAS}

Const
  cmSave      = 1001;
  cmLoad      = 1002;
  cmAdd       = 1003;
  cmEdit      = 1004;
  cmDel       = 1005;
  cmWork      = 1006;
  cmFindRoots = 1007;
  cmPolynom   = 1008;

{ ---=== String List ===--- }
Procedure RefreshList(ListControl:PView);
  Var Cur : PPolyList;
      StringList : PStringCollection;
  Begin
    StringList:=New(PStringCollection,Init(20,20));
    Cur := PolyList;
    While Cur <> nil do
      Begin
        StringList^.Insert(NewStr(Cur^.Name));
        Cur := Cur^.Next;
      End;
    PListBox(ListControl)^.NewList(StringList);
  End;

{ ---=== Edit Line ===--- }
Var GControl: PView;

Type
  PEditLine = ^TEditLine;
  TEditLine = Object(TInputLine)
    Procedure HandleEvent( Var Event:TEvent ); Virtual;
  end;

Procedure TEditLine.HandleEvent( Var Event:TEvent );
  Var S:String[30];
  Begin
    Inherited HandleEvent(Event);
    If (Event.What = evBroadcast) and (Event.command=cmListItemSelected) then
      Begin
        S:=PListBox(Event.InfoPtr)^.GetText(PListBox(Event.InfoPtr)^.Focused,
                                            high(s));
        DisposeStr(Data);
        Data:=NewStr(s);
        RefreshList(gControl);
        DrawView;
        ClearEvent(Event);
      End;
  End;

{ ---=== Edit Window ===--- }
Type
  PEditWindow = ^TEditWindow;
  TEditWindow = Object(TDialog)
    EditLine : PEditLine;
    Constructor Init;
    Procedure HandleEvent( Var Event:TEvent ); Virtual;
  End;

Constructor TEditWindow.Init;
var
  R: TRect;
  Control: PView;
  ScrollBar: PScrollBar;
begin
  R.Assign(0, 0, 50, 15);
  inherited Init(R, 'Редактирование списка полиномов');
  Options := Options or ofCentered;
  R.Assign(3, 3, 40, 4);
  EditLine := New(PEditline,Init(R,130));
  Control := EditLine;
  Control^.EventMask := Control^.EventMask or evBroadcast or evCommand;
  Insert(Control);
  R.Assign(35, 3, 49, 5);
  Insert(New(PButton, Init(R, '~С~оздать', cmAdd, bfDefault)));
  R.Assign(2, 2, 27, 3);
  Insert(New(PLabel, Init(R, 'Введите ~и~мя полинома:', Control)));
  R.Assign(34, 5, 35, 11);
  New(ScrollBar, Init(R));
  Insert(ScrollBar);
  R.Assign(3, 5, 47, 11);
  gControl := New(PListBox, Init(R, 1, ScrollBar));
  Insert(gControl);
  RefreshList(gControl);
  R.Assign(2, 4, 25, 5);
  Insert(New(PLabel, Init(R, 'Список полиномов:', gControl)));
  R.Assign(5, 12, 23, 14);
  Insert(New(PButton, Init(R, '~У~далить',cmDel, bfNormal)));
  R.Assign(27, 12, 45, 14);
  Insert(New(PButton, Init(R, '~Р~едактировать',cmEdit, bfNormal)));
  SelectNext(False);
End;

Procedure TEditWindow.HandleEvent( Var Event:TEvent );
  Var Temp :String;
  Begin
    Inherited HandleEvent(Event);
    If Event.What <> evCommand then Exit;
    If Event.What = evCommand then
      Begin
         Case Event.Command of
           cmAdd       :
             Begin
               Temp:=EditLine^.Data^;
               If Temp<>'' then
                 PolyListAddEnd(PolyList,Temp,nil);
             End;
           cmEdit      : ;
           cmDel       :
             {Temp.S:=GetText(PListBox(Event.InfoPtr)^.Focused)}
           ;
         Else
           Exit;
         End;
         RefreshList(gControl);
         DrawView;
         ClearEvent(Event);
      End;
  End;

{ * * * Status Line * * * }

Type
  PNewStatusLine=^TNewStatusLine;
  TNewStatusLine=
    Object(TStatusLine)
      Function Hint(AHelpCtx:Word):String;Virtual;
    End;

Function TNewStatusLine.Hint;
Begin
   Hint:='Hint';
End;

{ ---=== Application ===--- }
Type
  TNewApplication = Object(TApplication)
    Constructor Init;
    Procedure InitMenuBar; Virtual;
    Procedure InitStatusLine; Virtual;
    Procedure HandleEvent( Var Event:TEvent ); Virtual;
  End;

 Constructor TNewApplication.Init;
   Begin
     Inherited Init;
     CyrPatch;
     InsertWindow(New(PEditWindow,Init));
   End;

 Procedure TNewApplication.InitMenuBar;
   Var R:TRect;
   Begin
     GetExtent(R);
     R.B.Y:=R.A.Y+1;
     MenuBar:=New(PMenuBar,Init(R,NewMenu(
       NewSubMenu('~Ф~айл',hcNoContext,NewMenu(
         NewItem('~С~охранить состояние','F2',kbF2,cmSave,hcNew,
         NewItem('~В~осстановить состояние','F3',kbF3,cmLoad,hcNew,
         NewLine(
         NewItem('~В~ыход','Alt-X',kbAltX,cmQuit,hcExit,
         Nil))))),
       NewItem('~П~олином','',kbNoKey,cmPolynom,hcNew,
       NewItem('~Р~абота','',kbNoKey,cmWork,hcNew,
       NewSubMenu('~Д~ействия',hcNoContext,NewMenu(
         NewItem('~П~оиск корней','',kbNoKey,cmFindRoots,hcNew,
         Nil)),
       Nil)))))));
   End;

Procedure TNewApplication.InitStatusLine;
  Var
    R:TRect;
Begin
   GetExtent(R);
   R.A.Y:=R.B.Y-1;
   StatusLine:=New(PNewStatusLine,Init(R,NewStatusDef(0,$FFFF,
    StdStatusKeys(
    NewStatusKey('~Alt+X~ Exit',kbAltX,cmQuit,
    Nil)),Nil)));
End;

 Procedure TNewApplication.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If Event.What <> evCommand then Exit;
     If Event.What = evCommand then
       Case Event.Command of
         cmSave      :;
         cmLoad      :;
         cmAdd       :;
         cmEdit      :;
         cmDel       :;
         cmWork      :;
         cmFindRoots :;
        { Добавляем диалог редактирования списка полиномов }
         cmPolynom   : InsertWindow(New(PEditWindow,Init));
       Else
         Exit;
       End;
     ClearEvent(Event);
   End;

Var NewApppication : TNewApplication;
Begin
  PolyListAddBeg(PolyList,'TEST',nil);
  PolyListAddBeg(PolyList,'Polynom!',nil);
  NewApppication.Init;
  NewApppication.Run;
  NewApppication.Done;
  PolyListDelAll(PolyList);
End.