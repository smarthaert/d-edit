Uses Objects,Menus,Views,Drivers,Dialogs,MsgBox,App,Cyr,_Const,_Dialogs;

{ ---=== Основная Программа ===--- }
 Type
   TMathLab = Object (TApplication)
     Constructor Init;
     Procedure InitMenuBar; Virtual;
     Procedure InitStatusLine; Virtual;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
     Procedure MatrixCreate;
     Procedure MatrixEdit( NSize,MSize:Byte );
     Procedure About;
   End;

 Constructor TMathLab.Init;
   Begin
     Inherited Init;
     CyrPatch;
   End;

 Procedure TMathLab.InitMenuBar;
   Var R:TRect;
   Begin
     GetExtent(R);
     R.B.Y:=R.A.Y+1;
    { Основное меню системы }
     MenuBar := New(PMenuBar,Init(R,NewMenu(
       NewSubMenu('~Ф~айл',hcNoContext,NewMenu(
         NewItem('~О~ программе','Alt+0',kbAlt0,cmAbout,hcAbout,
         NewLine(
         NewItem('В~ы~ход','Alt+X',kbAltX,cmQuit,hcExit,
         nil)))),
       NewSubMenu('~М~атрица',hcNoContext,NewMenu(
         NewItem('~С~оздать','Alt+M',kbAltM,cmMatrixCreateDialog,hcMatrixCreateDialog,
         NewLine(
         NewItem('Вычесть единичную матрицу','',kbNoKey,cmMatrixDecE,hcMatrixDecE,
         NewItem('Транспонировать','',kbNoKey,cmMatrixTranspon,hcMatrixTranspon,
         NewItem('Возвести в степень','',kbNoKey,cmMatrixStep,hcMatrixStep,
         NewItem('Симметричная матрица','',kbNoKey,cmMatrixSimm,hcMatrixSimm,
         NewItem('Кососимметричная матрица','',kbNoKey,cmMatrixCososimm,hcMatrixCososimm,
         nil)))))))),
       nil)))));
   End;

 Procedure TMathLab.InitStatusLine;
   Var R:TRect;
   Begin
     GetExtent(R);
     R.A.Y := R.B.Y - 1;
     New(StatusLine,Init(R,
       HelpStr(hcAbout,'О программе',
       HelpStr(hcMatrixCreateDialog,'Создание прямоугольной матрицы m*n',
       HelpStr(hcMatrixDecE,'Вычесть из исходной матрицы еденичную матрицу',
       HelpStr(hcMatrixTranspon,'Создать транспонированную матрицу',
       HelpStr(hcMatrixStep,'Возвести матрицу в степень M',
       HelpStr(hcMatrixSimm,'Создать симметричную матрицу из элементов над главной диагональю',
       HelpStr(hcMatrixCososimm,'Создать кососимметричную матрицу из элементов под главной диагональю',
       NewStatusDef(0,$EFFF,
         NewStatusKey('Выход ~Alt-X~',kbAltX,cmQuit,
         StdStatusKeys(nil)),
       nil))))))))));
   End;

 Procedure TMathLab.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If (Event.What And evCommand)<>0 then
       Begin
         Case Event.Command of
           cmMatrixCreateDialog : MatrixCreate;
           cmMatrixEditDialog   :
             MatrixEdit(Event.InfoWord div $100,Event.InfoWord mod $100);
           cmAbout              : About;
         Else
           Exit;
       End;
       ClearEvent(Event);
     End;
   End;

 Procedure TMathLab.MatrixCreate;
   Var P:PMatrixCreateDialog; R:TRect;
   Begin
     Desktop^.GetExtent(R);
     P:=New(PMatrixCreateDialog,Init(R));
     InsertWindow(P);
   End;

 Procedure TMathLab.MatrixEdit;
   Var P:PMatrixEditDialog; R:TRect;
   Begin
     Desktop^.GetExtent(R);
     P:=New(PMatrixEditDialog,Init(R,NSize,MSize));
     InsertWindow(P);
   End;

 Procedure TMathLab.About;
   Var D:PDialog; R:TRect;
   Begin
     R.Assign(0,0,40,12);
     D := New(PDialog,Init(R,'About'));
     With D^ do
       Begin
         Options := Options Or ofCentered;
         R.Grow(-1,-1);
         Dec(R.B.Y,3);
         Insert(New(PStaticText,Init(R,
           #13 + ^C'Основы Алгоритмизации и Программирования'#13 +
           #13 + ^C'Курсовая работа'#13 +
           #13 + ^C'СпбГЭТУ группа 9331')));
         R.Assign(15,9,25,11);
         Insert(New(PButton,Init(R,'O~K',cmOk,bfDefault)));
       End;
     If ValidView(D)<>nil then
       Begin
         Desktop^.ExecView(D);
         Dispose(D, Done);
       End;
   End;

Var MathLab:TMathLab; StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  MathLab.Init;
  MathLab.Run;
  MathLab.Done;
  If MemAvail<>StartMem then Writeln('Memory Error !');
End.