Uses Drivers,Objects,Views,Dialogs,Menus,App,ColorSel,StdDlg,Editors,Consts;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                          ���� �メ窶甌�                           � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                        ��Г��┘ �メ窶甌�                         � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

 Procedure CreateStrings;
   Var S:PStrListMaker;
   Begin
     S:=New(PStrListMaker,Init(10000,100));
     S^.Put(sNoMem,'�� 紜���モ ���閧� か� ��▲琥キ�� ��ム�罔�.');
     S^.Put(sErrorReading,'�荐！� 艪キ�� %s.');
     S^.Put(sErrorWriting,'�荐！� ����瓱 %s.');
     S^.Put(sErrorCreating,'�荐！� 甌Г���� %s.');
     S^.Put(sModified,'%s ├�キキ. ��縲���碎 ?');
     S^.Put(sSaveUntitled,'��縲���碎 ���� ?');
     S^.Put(sStrNotFound,'�矗��� �� ���ぅ��.');
     S^.Put(sReplace,'���キ�碎 ?');
     S^.Put(sErrorHelp,'���� ����薑 �� ぎ痰祚キ.');
     S^.Put(sErrorOpenDesk,'�� ��ｃ �皖琺碎 ∇ガキ�覃 ����.');
     S^.Put(sErrorReadingDesk,'�荐！� 艪キ�� ∇ガキ���� �����.');
     S^.Put(sDeskInvalid,'�荐！� : �爛�キ�覃 ���� ��∇ウぅ�.');
     S^.Put(sErrorDeskCreate,'�� ��ｃ 甌Г�碎 ∇ガキ�覃 ����.');
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
       NewSubMenu('~�~���',hcFile,NewMenu(
         NewItem('~�~��覃','',kbNoKey,cmNew,hcNew,
         NewItem('~�~皖琺碎','F3',kbF3,cmOpen,hcOpen,
         NewItem('~�~�縲���碎','F2',kbF2,cmSave,hcSave,
         NewItem('~�~�縲���碎 ���','',kbNoKey,cmSaveAs,hcSaveAs,
         NewItem('~S~�縲���碎 ≡�','',kbNoKey,cmSaveAll,hcSaveAll,
         NewLine(
         NewItem('~�~�キ�碎 �������','',kbNoKey,cmChangeDir,hcChangeDir,
         NewItem('~�~���� DOS','',kbNoKey,cmDosShell,hcDosShell,
         NewItem('~�~諷��','Alt+X',kbAltX,cmQuit,hcExit,
         nil)))))))))),
       NewSubMenu('~�~イ��皋牀���┘',hcNoContext,NewMenu(
         NewItem('~�~皖��','',kbAltBack,cmUndo,hcUndo,
         NewLine(
         NewItem('~�~諤ェ�碎','Shift+Del',kbShiftDel,cmCut,hcCut,
         NewItem('~�~���牀��碎','Ctrl+Ins',kbCtrlIns,cmCopy,hcCopy,
         NewItem('~�~痰�※碎','Shift+Ins',kbShiftIns,cmPaste,hcPaste,
         NewItem('~�~����碎','Ctrl+Del',kbCtrlDel,cmClear,hcClear,
         NewLine(
         NewItem('~�~�����碎 ＜筌� �゜キ�','',kbNoKey,cmShowClip,hcShowClip,
         nil))))))))),
       NewSubMenu('~�~��瓷', hcNoContext,NewMenu(
         NewItem('~�~瓷�碎...','',kbNoKey,cmFind,hcNoContext,
         NewItem('~�~��キ�碎...','',kbNoKey,cmReplace,hcNoContext,
         NewItem('~�~牀ぎ�Θ碎 ���瓷','',kbNoKey,cmSearchAgain,hcNoContext,
         nil)))),
       NewSubMenu('~�~���',hcWindows,NewMenu(
         NewItem('~�~��Θ碎 �ムク�罐�','',kbNoKey,cmTile,hcTile,
         NewItem('~�~��Θ碎 ��瓷�ぎ�','',kbNoKey,cmCascade,hcCascade,
         NewItem('~�~��琺碎 ≡�','',kbNoKey,cmCloseAll,hcCloseAll,
         NewLine(
         NewItem('~�~�Кム/�ムガラキ┘','Ctrl+F5',kbCtrlF5, cmResize, hcResize,
         NewItem('~�~��瓱�├�牀��碎','F5',kbF5,cmZoom,hcZoom,
         NewItem('~�~�イ竡薀�','F6',kbF6,cmNext,hcNext,
         NewItem('~�~爛るゃ薀�','Shift+F6',kbShiftF6,cmPrev,hcPrev,
         NewItem('~�~��琺碎','Alt+F3',kbAltF3,cmClose,hcClose,
         nil)))))))))),
       NewSubMenu('~�~�痰牀���',hcOptions,NewMenu(
         NewItem('~�~謌��...', '',kbNoKey,cmMouse,hcOMouse,
         NewItem('~�~▲��...', '',kbNoKey,cmColors,hcOColors,
         NewLine(
         NewItem('~�~������碎 甌痰�鎰┘','',kbNoKey,cmSaveDesktop,hcOSaveDesktop,
         NewItem('~�~�瘁����※碎 甌痰�鎰┘','',kbNoKey,cmRetrieveDesktop,hcORestoreDesktop,
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
         NewStatusKey('~Alt-X~ �諷��', kbAltX, cmQuit,
         NewStatusKey('~F1~ ����蛹', kbF1, cmHelp,
         NewStatusKey('~F3~ �皖琺碎', kbF3, cmOpen,
         NewStatusKey('~Alt-F3~ ���琺碎', kbAltF3, cmClose,
         NewStatusKey('~F5~ ���瓱�├�牀��碎', kbF5, cmZoom,
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
     P:=New(PFileDialog,Init('*.*','�皖琺碎 ����',
       '~�~��',fdOpenButton + fdHelpButton + fdNoLoadDir,100));
     P^.HelpCtx:=hcFOFileOpenDBox;
     RezFile.Put(P,'FileOpenDialog');
     Dispose(P,Done);
   End;

 Procedure CreateAboutDialog;
   Var R:TRect; D:PDialog;
   Begin
     R.Assign(0,0,40,11);
     D:=New(PDialog,Init(R,'� 蹍������'));
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
         Insert(New(PButton,Init(R,'��',cmOk,bfDefault)));
       End;
     RezFile.Put(D,'AboutDialog');
     Dispose(D,Done);
   End;

 Procedure CreateColorSelDialog;
   Var R:TRect; D:PDialog;
   Begin
     D:=New(PColorDialog,Init('',
       ColorGroup('���',           DesktopColorItems(nil),
       ColorGroup('�キ�',          MenuColorItems(nil),
       ColorGroup('�������',       DialogColorItems(dpGrayDialog, nil),
       ColorGroup('�イ��皰�',      WindowColorItems(wpBlueWindow, nil),
       ColorGroup('ASCII ��゛���', WindowColorItems(wpGrayWindow, nil),
       ColorGroup('���キ��瑕',
         WindowColorItems(wpCyanWindow,
           ColorItem('�ィ�き�',22,nil)),
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
     D:=New(PDialog,Init(R,'���瓷'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,32,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~�~オ痰 か� ���瓷�',Control)));
         R.Assign(32,3,35,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,5,35,7);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~�~�Й���碎 爛��痰�',
           NewSItem('~�~��瓷 �發カ讚諷 甄��', nil)))));
         R.Assign(14,9,24,11);
         Insert(New(PButton,Init(R,'��',cmOk,bfDefault)));
         Inc(R.A.X,12); Inc(R.B.X,12);
         Insert(New(PButton,Init(R,'�皙キ�',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D, 'FindDialog');
     Dispose(D, Done);
   End;

 Procedure CreateReplaceDialog;
   Var D:PDialog; Control:PView; R:TRect;
   Begin
     R.Assign(0,0,40,16);
     D:=New(PDialog,Init(R,'���キ�'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,34,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~�~瓷�碎 皀�痰',Control)));
         R.Assign(34,3,37,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,6,34,7);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,5,12,6);
         Insert(New(PLabel,Init(R,'~�~��覃 皀�痰',Control)));
         R.Assign(34,6,37,7);
         Insert(New(PHistory,Init(R,PInputLine(Control),11)));
         R.Assign(3,8,37,12);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~�~�Й���碎 爛��痰�',
           NewSItem('~�~��瓷 �發カ讚諷 甄��',
           NewSItem('~�~��牀� � ���キ�',
           NewSItem('~�~��キ�碎 ≡�', nil)))))));
         R.Assign(17, 13, 27, 15);
         Insert(New(PButton,Init(R,'��',cmOk,bfDefault)));
         R.Assign(28, 13, 38, 15);
         Insert(New(PButton,Init(R,'�皙キ�',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D,'ReplaceDialog');
     Dispose(D,Done);
   End;

 Procedure CreateSaveAsDialog;
   Var D:PDialog;
   Begin
     D:=New(PFileDialog,Init('*.*','��縲���碎 ���','~�~��',
       fdOkButton + fdHelpButton + fdNoLoadDir, 101));
     RezFile.Put(D,'SaveAsDialog');
     Dispose(D,Done);
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                      �甅�↓�� 蹍������                          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

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
