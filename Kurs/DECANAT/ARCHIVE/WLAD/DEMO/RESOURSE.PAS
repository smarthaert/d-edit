Uses Drivers,Objects,Views,Dialogs,Menus,App,ColorSel,StdDlg,Editors,Consts;

{ ╔═╤══════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                          Файл Ресурсов                           │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════════╧═╝ }

 Type
   PProtectedStream = ^TProtectedStream;
   TProtectedStream = Object(TBufStream)
     Procedure Error( Code,Info:Integer ); Virtual;
   End;

  Procedure TProtectedStream.Error( Code,Info:Integer );
    Begin
      Writeln('Error in stream: Code = ', Code, ' Info = ', Info);
      Halt(1);
    End;

 Var RezFile:TResourceFile;
     RezStream:PStream;

{ ╔═╤══════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                        Создание Ресурсов                         │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════════╧═╝ }

 Procedure CreateStrings;
   Var S:PStrListMaker;
   Begin
     S:=New(PStrListMaker,Init(10000,100));
     S^.Put(sNoMem,'Не хватает памяти для завершения операции.');
     S^.Put(sErrorReading,'Ошибка чтения %s.');
     S^.Put(sErrorWriting,'Ошибка записи %s.');
     S^.Put(sErrorCreating,'Ошибка создания %s.');
     S^.Put(sModified,'%s изменен. Сохранить ?');
     S^.Put(sSaveUntitled,'Сохранить файл ?');
     S^.Put(sStrNotFound,'Строка не найдена.');
     S^.Put(sReplace,'Заменить ?');
     S^.Put(sErrorHelp,'Файл помощи не доступен.');
     S^.Put(sErrorOpenDesk,'Не могу открыть временный файл.');
     S^.Put(sErrorReadingDesk,'Ошибка чтения временного файла.');
     S^.Put(sDeskInvalid,'Ошибка : Временный файл поврежден.');
     S^.Put(sErrorDeskCreate,'Не могу создать временный файл.');
     RezFile.Put(S,'Strings');
     Dispose(S,Done);
   End;

 Procedure CreateMenu;
   Var R:TRect; P:PView;
   Begin
     R.Assign(0,0,80,1);
     P:=New(PMenuBar,Init(R,NewMenu(
       NewSubMenu('~'#240'~', hcSystem, NewMenu(
         NewItem('~A~bout', '', kbNoKey, cmAbout, hcSAbout,
         NewLine(
         NewItem('~P~uzzle', '', kbNoKey, cmPuzzle, hcSPuzzle,
         NewItem('Ca~l~endar', '', kbNoKey, cmCalendar, hcSCalendar,
         NewItem('Ascii ~t~able', '', kbNoKey, cmAsciiTab, hcSAsciiTable,
         NewItem('~C~alculator', '', kbNoKey, cmCalculator, hcCalculator,
         nil))))))),
       NewSubMenu('~Ф~айл',hcFile,NewMenu(
         NewItem('~Н~овый','',kbNoKey,cmNew,hcNew,
         NewItem('~О~ткрыть','F3',kbF3,cmOpen,hcOpen,
         NewItem('~С~охранить','F2',kbF2,cmSave,hcSave,
         NewItem('~С~охранить как','',kbNoKey,cmSaveAs,hcSaveAs,
         NewItem('~S~охранить все','',kbNoKey,cmSaveAll,hcSaveAll,
         NewLine(
         NewItem('~С~менить каталог','',kbNoKey,cmChangeDir,hcChangeDir,
         NewItem('~С~еанс DOS','',kbNoKey,cmDosShell,hcDosShell,
         NewItem('~В~ыход','Alt+X',kbAltX,cmQuit,hcExit,
         nil)))))))))),
       NewSubMenu('~Р~едактирование',hcNoContext,NewMenu(
         NewItem('~О~ткат','',kbAltBack,cmUndo,hcUndo,
         NewLine(
         NewItem('~В~ырезать','Shift+Del',kbShiftDel,cmCut,hcCut,
         NewItem('~К~опировать','Ctrl+Ins',kbCtrlIns,cmCopy,hcCopy,
         NewItem('~В~ставить','Shift+Ins',kbShiftIns,cmPaste,hcPaste,
         NewItem('~У~далить','Ctrl+Del',kbCtrlDel,cmClear,hcClear,
         NewLine(
         NewItem('~П~оказать буфер обмена','',kbNoKey,cmShowClip,hcShowClip,
         nil))))))))),
       NewSubMenu('~П~оиск', hcNoContext,NewMenu(
         NewItem('~И~скать...','',kbNoKey,cmFind,hcNoContext,
         NewItem('~З~аменить...','',kbNoKey,cmReplace,hcNoContext,
         NewItem('~П~родолжить поиск','',kbNoKey,cmSearchAgain,hcNoContext,
         nil)))),
       NewSubMenu('~О~кна',hcWindows,NewMenu(
         NewItem('~У~ложить Черепицей','',kbNoKey,cmTile,hcTile,
         NewItem('~У~ложить Каскадом','',kbNoKey,cmCascade,hcCascade,
         NewItem('~З~акрыть все','',kbNoKey,cmCloseAll,hcCloseAll,
         NewLine(
         NewItem('~Р~азмер/Перемещение','Ctrl+F5',kbCtrlF5, cmResize, hcResize,
         NewItem('~М~аксимизировать','F5',kbF5,cmZoom,hcZoom,
         NewItem('~С~ледующее','F6',kbF6,cmNext,hcNext,
         NewItem('~П~редыдущее','Shift+F6',kbShiftF6,cmPrev,hcPrev,
         NewItem('~З~акрыть','Alt+F3',kbAltF3,cmClose,hcClose,
         nil)))))))))),
       NewSubMenu('~Н~астройки',hcOptions,NewMenu(
         NewItem('~М~ышка...', '',kbNoKey,cmMouse,hcOMouse,
         NewItem('~Ц~вета...', '',kbNoKey,cmColors,hcOColors,
         NewLine(
         NewItem('~З~апомнить состояние','',kbNoKey,cmSaveDesktop,hcOSaveDesktop,
         NewItem('~В~осстановить состояние','',kbNoKey,cmRetrieveDesktop,hcORestoreDesktop,
         nil)))))),
         nil)))))))));
     RezFile.Put(P,'MenuBar');
     Dispose(P,Done);
   End;

 Procedure CreateStatusLine;
   Var R:TRect; P:PView;
   Begin
     R.Assign(0,24,80,25);
     P:=New(PStatusLine,Init(R,
       NewStatusDef(0, $FFFF,
         NewStatusKey('~Alt-X~ Выход', kbAltX, cmQuit,
         NewStatusKey('~F1~ Помощь', kbF1, cmHelp,
         NewStatusKey('~F3~ Открыть', kbF3, cmOpen,
         NewStatusKey('~Alt-F3~ Закрыть', kbAltF3, cmClose,
         NewStatusKey('~F5~ Максимизировать', kbF5, cmZoom,
         NewStatusKey('', kbF10, cmMenu,
         NewStatusKey('', kbCtrlF5, cmResize,
         nil))))))),
       nil)));
     RezFile.Put(P,'StatusLine');
     Dispose(P,Done);
   End;

 Procedure CreateFileOpenDialog;
   Var P:PView;
   Begin
     P:=New(PFileDialog,Init('*.*','Открыть Файл',
       '~И~мя',fdOpenButton + fdHelpButton + fdNoLoadDir,100));
     P^.HelpCtx:=hcFOFileOpenDBox;
     RezFile.Put(P,'FileOpenDialog');
     Dispose(P,Done);
   End;

 Procedure CreateAboutDialog;
   Var R:TRect; D:PDialog;
   Begin
     R.Assign(0,0,40,11);
     D:=New(PDialog,Init(R,'О Программе'));
     With D^ do
       Begin
         Options := Options Or ofCentered;
         R.Grow(-1,-1);
         Dec(R.B.Y,3);
         Insert(New(PStaticText,Init(R,
           #13 + ^C'Wlad Office'#13 +
           #13 + ^C'Copyright (c) 1999'#13 +
           #13 + ^C'Roman International')));
         R.Assign(15,8,25,10);
         Insert(New(PButton,Init(R,'Да',cmOk,bfDefault)));
       End;
     RezFile.Put(D,'AboutDialog');
     Dispose(D,Done);
   End;

 Procedure CreateColorSelDialog;
   Var R:TRect; D:PDialog;
   Begin
     D:=New(PColorDialog,Init('',
       ColorGroup('Фон',           DesktopColorItems(nil),
       ColorGroup('Меню',          MenuColorItems(nil),
       ColorGroup('Диалоги',       DialogColorItems(dpGrayDialog, nil),
       ColorGroup('Редактор',      WindowColorItems(wpBlueWindow, nil),
       ColorGroup('ASCII таблица', WindowColorItems(wpGrayWindow, nil),
       ColorGroup('Календарь',
         WindowColorItems(wpCyanWindow,
           ColorItem('Сегодня',22,nil)),
           nil))))))));
       D^.HelpCtx := hcOCColorsDBox;
       RezFile.Put(D,'ColorSelectDialog');
       Dispose(D,Done);
   End;

 Procedure CreateChDirDialog;
   Var R:TRect; D:PDialog;
   Begin
     D:=New(PChDirDialog,Init(cdNormal + cdHelpButton + cdNoLoadDir,101));
     D^.HelpCtx:=hcFCChDirDBox;
     RezFile.Put(D,'ChDirDialog');
     Dispose(D,Done);
   End;

 Procedure CreateFindDialog;
   Var D:PDialog; Control:PView; R:TRect;
   Begin
     R.Assign(0,0,38,12);
     D:=New(PDialog,Init(R,'Поиск'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,32,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~Т~екст для поиска',Control)));
         R.Assign(32,3,35,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,5,35,7);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~Р~азличать регистр',
           NewSItem('~П~оиск отдельных слов', nil)))));
         R.Assign(14,9,24,11);
         Insert(New(PButton,Init(R,'Да',cmOk,bfDefault)));
         Inc(R.A.X,12); Inc(R.B.X,12);
         Insert(New(PButton,Init(R,'Отмена',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D, 'FindDialog');
     Dispose(D, Done);
   End;

 Procedure CreateReplaceDialog;
   Var D:PDialog; Control:PView; R:TRect;
   Begin
     R.Assign(0,0,40,16);
     D:=New(PDialog,Init(R,'Замена'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,34,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~И~скать текст',Control)));
         R.Assign(34,3,37,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,6,34,7);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,5,12,6);
         Insert(New(PLabel,Init(R,'~Н~овый текст',Control)));
         R.Assign(34,6,37,7);
         Insert(New(PHistory,Init(R,PInputLine(Control),11)));
         R.Assign(3,8,37,12);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~Р~азличать регистр',
           NewSItem('~П~оиск отдельных слов',
           NewSItem('~З~апрос о замене',
           NewSItem('~З~аменить все', nil)))))));
         R.Assign(17, 13, 27, 15);
         Insert(New(PButton,Init(R,'Да',cmOk,bfDefault)));
         R.Assign(28, 13, 38, 15);
         Insert(New(PButton,Init(R,'Отмена',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D,'ReplaceDialog');
     Dispose(D,Done);
   End;

 Procedure CreateSaveAsDialog;
   Var D:PDialog;
   Begin
     D:=New(PFileDialog,Init('*.*','Сохранить как','~И~мя',
       fdOkButton + fdHelpButton + fdNoLoadDir, 101));
     RezFile.Put(D,'SaveAsDialog');
     Dispose(D,Done);
   End;

{ ╔═╤══════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                      Основная Программа                          │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════════╧═╝ }

Begin
 { ---=== INIT ===--- }
  RezStream:=New(PProtectedStream,Init('WLAD.DLG',stCreate,4096));
  RezFile.Init(RezStream);
 { ---=== REGISTER ===--- }
  RegisterObjects;
  RegisterType(RStrListMaker);
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterStdDlg;
  RegisterColorSel;
 { ---=== CREATE ===--- }
  CreateStrings;
  CreateMenu;
  CreateStatusLine;
  CreateFileOpenDialog;
  CreateAboutDialog;
  CreateColorSelDialog;
  CreateChDirDialog;
  CreateFindDialog;
  CreateReplaceDialog;
  CreateSaveAsDialog;
 { ---=== DONE ===--- }
  RezFile.Done;
End.
