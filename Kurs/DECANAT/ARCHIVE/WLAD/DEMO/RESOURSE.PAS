Uses Drivers,Objects,Views,Dialogs,Menus,App,ColorSel,StdDlg,Editors,Consts;

{ ����������������������������������������������������������������������ͻ }
{ � �                          ���� �����ᮢ                           � � }
{ ����������������������������������������������������������������������ͼ }

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

{ ����������������������������������������������������������������������ͻ }
{ � �                        �������� �����ᮢ                         � � }
{ ����������������������������������������������������������������������ͼ }

 Procedure CreateStrings;
   Var S:PStrListMaker;
   Begin
     S:=New(PStrListMaker,Init(10000,100));
     S^.Put(sNoMem,'�� 墠⠥� ����� ��� �����襭�� ����樨.');
     S^.Put(sErrorReading,'�訡�� �⥭�� %s.');
     S^.Put(sErrorWriting,'�訡�� ����� %s.');
     S^.Put(sErrorCreating,'�訡�� ᮧ����� %s.');
     S^.Put(sModified,'%s �������. ���࠭��� ?');
     S^.Put(sSaveUntitled,'���࠭��� 䠩� ?');
     S^.Put(sStrNotFound,'��ப� �� �������.');
     S^.Put(sReplace,'�������� ?');
     S^.Put(sErrorHelp,'���� ����� �� ����㯥�.');
     S^.Put(sErrorOpenDesk,'�� ���� ������ �६���� 䠩�.');
     S^.Put(sErrorReadingDesk,'�訡�� �⥭�� �६������ 䠩��.');
     S^.Put(sDeskInvalid,'�訡�� : �६���� 䠩� ���०���.');
     S^.Put(sErrorDeskCreate,'�� ���� ᮧ���� �६���� 䠩�.');
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
         NewItem('~�~���','',kbNoKey,cmNew,hcNew,
         NewItem('~�~�����','F3',kbF3,cmOpen,hcOpen,
         NewItem('~�~��࠭���','F2',kbF2,cmSave,hcSave,
         NewItem('~�~��࠭��� ���','',kbNoKey,cmSaveAs,hcSaveAs,
         NewItem('~S~��࠭��� ��','',kbNoKey,cmSaveAll,hcSaveAll,
         NewLine(
         NewItem('~�~������ ��⠫��','',kbNoKey,cmChangeDir,hcChangeDir,
         NewItem('~�~���� DOS','',kbNoKey,cmDosShell,hcDosShell,
         NewItem('~�~�室','Alt+X',kbAltX,cmQuit,hcExit,
         nil)))))))))),
       NewSubMenu('~�~�����஢����',hcNoContext,NewMenu(
         NewItem('~�~⪠�','',kbAltBack,cmUndo,hcUndo,
         NewLine(
         NewItem('~�~�१���','Shift+Del',kbShiftDel,cmCut,hcCut,
         NewItem('~�~���஢���','Ctrl+Ins',kbCtrlIns,cmCopy,hcCopy,
         NewItem('~�~�⠢���','Shift+Ins',kbShiftIns,cmPaste,hcPaste,
         NewItem('~�~������','Ctrl+Del',kbCtrlDel,cmClear,hcClear,
         NewLine(
         NewItem('~�~������� ���� ������','',kbNoKey,cmShowClip,hcShowClip,
         nil))))))))),
       NewSubMenu('~�~���', hcNoContext,NewMenu(
         NewItem('~�~᪠��...','',kbNoKey,cmFind,hcNoContext,
         NewItem('~�~�������...','',kbNoKey,cmReplace,hcNoContext,
         NewItem('~�~த������ ����','',kbNoKey,cmSearchAgain,hcNoContext,
         nil)))),
       NewSubMenu('~�~���',hcWindows,NewMenu(
         NewItem('~�~������ ��९�楩','',kbNoKey,cmTile,hcTile,
         NewItem('~�~������ ��᪠���','',kbNoKey,cmCascade,hcCascade,
         NewItem('~�~������ ��','',kbNoKey,cmCloseAll,hcCloseAll,
         NewLine(
         NewItem('~�~�����/��६�饭��','Ctrl+F5',kbCtrlF5, cmResize, hcResize,
         NewItem('~�~��ᨬ���஢���','F5',kbF5,cmZoom,hcZoom,
         NewItem('~�~�����饥','F6',kbF6,cmNext,hcNext,
         NewItem('~�~।��饥','Shift+F6',kbShiftF6,cmPrev,hcPrev,
         NewItem('~�~������','Alt+F3',kbAltF3,cmClose,hcClose,
         nil)))))))))),
       NewSubMenu('~�~���ன��',hcOptions,NewMenu(
         NewItem('~�~�誠...', '',kbNoKey,cmMouse,hcOMouse,
         NewItem('~�~���...', '',kbNoKey,cmColors,hcOColors,
         NewLine(
         NewItem('~�~�������� ���ﭨ�','',kbNoKey,cmSaveDesktop,hcOSaveDesktop,
         NewItem('~�~���⠭����� ���ﭨ�','',kbNoKey,cmRetrieveDesktop,hcORestoreDesktop,
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
         NewStatusKey('~Alt-X~ ��室', kbAltX, cmQuit,
         NewStatusKey('~F1~ ������', kbF1, cmHelp,
         NewStatusKey('~F3~ ������', kbF3, cmOpen,
         NewStatusKey('~Alt-F3~ �������', kbAltF3, cmClose,
         NewStatusKey('~F5~ ���ᨬ���஢���', kbF5, cmZoom,
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
     P:=New(PFileDialog,Init('*.*','������ ����',
       '~�~��',fdOpenButton + fdHelpButton + fdNoLoadDir,100));
     P^.HelpCtx:=hcFOFileOpenDBox;
     RezFile.Put(P,'FileOpenDialog');
     Dispose(P,Done);
   End;

 Procedure CreateAboutDialog;
   Var R:TRect; D:PDialog;
   Begin
     R.Assign(0,0,40,11);
     D:=New(PDialog,Init(R,'� �ணࠬ��'));
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
       ColorGroup('����',          MenuColorItems(nil),
       ColorGroup('�������',       DialogColorItems(dpGrayDialog, nil),
       ColorGroup('�������',      WindowColorItems(wpBlueWindow, nil),
       ColorGroup('ASCII ⠡���', WindowColorItems(wpGrayWindow, nil),
       ColorGroup('���������',
         WindowColorItems(wpCyanWindow,
           ColorItem('�������',22,nil)),
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
     D:=New(PDialog,Init(R,'����'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,32,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~�~���� ��� ���᪠',Control)));
         R.Assign(32,3,35,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,5,35,7);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~�~������� ॣ����',
           NewSItem('~�~��� �⤥���� ᫮�', nil)))));
         R.Assign(14,9,24,11);
         Insert(New(PButton,Init(R,'��',cmOk,bfDefault)));
         Inc(R.A.X,12); Inc(R.B.X,12);
         Insert(New(PButton,Init(R,'�⬥��',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D, 'FindDialog');
     Dispose(D, Done);
   End;

 Procedure CreateReplaceDialog;
   Var D:PDialog; Control:PView; R:TRect;
   Begin
     R.Assign(0,0,40,16);
     D:=New(PDialog,Init(R,'������'));
     With D^ do
       Begin
         Options:=Options Or ofCentered;
         R.Assign(3,3,34,4);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,2,15,3);
         Insert(New(PLabel,Init(R,'~�~᪠�� ⥪��',Control)));
         R.Assign(34,3,37,4);
         Insert(New(PHistory,Init(R,PInputLine(Control),10)));
         R.Assign(3,6,34,7);
         Control:=New(PInputLine,Init(R,80));
         Insert(Control);
         R.Assign(2,5,12,6);
         Insert(New(PLabel,Init(R,'~�~��� ⥪��',Control)));
         R.Assign(34,6,37,7);
         Insert(New(PHistory,Init(R,PInputLine(Control),11)));
         R.Assign(3,8,37,12);
         Insert(New(PCheckBoxes, Init(R,
           NewSItem('~�~������� ॣ����',
           NewSItem('~�~��� �⤥���� ᫮�',
           NewSItem('~�~���� � ������',
           NewSItem('~�~������� ��', nil)))))));
         R.Assign(17, 13, 27, 15);
         Insert(New(PButton,Init(R,'��',cmOk,bfDefault)));
         R.Assign(28, 13, 38, 15);
         Insert(New(PButton,Init(R,'�⬥��',cmCancel,bfNormal)));
         SelectNext(False);
       End;
     RezFile.Put(D,'ReplaceDialog');
     Dispose(D,Done);
   End;

 Procedure CreateSaveAsDialog;
   Var D:PDialog;
   Begin
     D:=New(PFileDialog,Init('*.*','���࠭��� ���','~�~��',
       fdOkButton + fdHelpButton + fdNoLoadDir, 101));
     RezFile.Put(D,'SaveAsDialog');
     Dispose(D,Done);
   End;

{ ����������������������������������������������������������������������ͻ }
{ � �                      �᭮���� �ணࠬ��                          � � }
{ ����������������������������������������������������������������������ͼ }

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