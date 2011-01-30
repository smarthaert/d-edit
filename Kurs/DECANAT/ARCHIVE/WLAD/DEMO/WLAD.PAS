Uses Objects, Drivers, Memory, App, Views, Menus, Dialogs, StdDlg, Globals,
  Gadgets, Dos, MsgBox, Equ, Tools, TreeWin, Colors, Assoc, Trash,
  FileFind;


{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                              Office                              ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   TOffice = Object(TApplication)
     Heap: PHeapView;
     TrashCan: PTrashCan;
     ExitDir: String;
     Constructor Init;
     Destructor Done; Virtual;
     Procedure Idle; Virtual;
     Procedure InitMenuBar; Virtual;
     Procedure InitStatusLine; Virtual;
     Procedure ToggleVideoMode;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
     Procedure OutOfMemory; Virtual;
   End;


 Constructor TOffice.Init;
   Var R:TRect; H:Word; CurDir:PathStr;
   Begin
     RezStream:=New(PProtectedStream,Init('WLAD.DLG',stOpenRead,4096));
     If RezStream^.Status <> stOK then
       Begin
         PrintStr('ฅ ฌฎฃใ ฎโชเ๋โ์ ไ ฉซ เฅแใเแฎข.');
         Halt(1);
       End;
     RezFile.Init(RezStream);
    { = = = REGISTER = = = }
     RegisterObjects;
     RegisterViews;
     RegisterMenus;
     RegisterDialogs;
     RegisterApp;
     RegisterStdDlg;
     RegisterGlobals;
     RegisterType(RStringList);
     RegisterAssociations;
    { = = = RESOURSE = = = }
     RezStrings:=PStringList(RezFile.Get('Strings'));
     If RezStrings = nil then
       Begin
         PrintStr('Unable to read resources from resource file.');
         Halt(1);
       End;
     Inherited Init;
     InitAssociations;

  GetExtent(R);
  Dec(R.B.X);
  R.A.X := R.B.X - 9; R.A.Y := R.B.Y - 1;
  Heap := New(PHeapView, Init(R));
  Insert(Heap);

  Desktop^.GetExtent(R);
  Dec(R.B.Y); Inc(R.A.X);
  R.A.Y := R.B.Y - 3;
  R.B.X := R.A.X + 5;
  TrashCan := New(PTrashCan, Init(R));
  with TrashCan^ do
  Begin
    Options := Options or (ofSelectable + ofTopSelect);
    EventMask := EventMask or evBroadcast;
  End;
  Desktop^.Insert(TrashCan);

  ConfigRec.Video := ScreenMode and smFont8x8;
  ReadConfig;
  if ConfigRec.Video <> (ScreenMode and smFont8x8) then
    ToggleVideoMode;

  { by defaut, open a directory window to the current drive }
  GetDir(0, CurDir);
  InsertTreeWindow(CurDir[1]);
End;

destructor TOffice.Done;
Begin
  DoneAssociations;
  Dispose(Heap, Done);
  Dispose(TrashCan, Done);
{$I-}
  if ExitDir <> '' then
  Begin
    if ExitDir[Length(ExitDir)] = ':' then ExitDir := ExitDir + '\';
    ChDir(ExitDir);
  End;
{$I+}
  inherited Done;
  DoneMemory;
End;

Procedure TOffice.Idle;
const
  FileListCmds : TCommandSet =
    [cmExecute, cmViewAsHex, cmViewAsText, cmViewCustom, cmCopy, cmDelete,
     cmRename, cmChangeAttr, cmReverseTags, cmClearTags, cmTagPerCard,
     cmAssociate];
var
  TopWindow: PWindow;
Begin
  inherited Idle;

  TopWindow := Message(Desktop, evBroadcast, cmTopWindow, nil);
  if TopWindow = nil then
  Begin
    DisableCommands(FileListCmds);
    DisableCommands([cmExitHere]);
  End
  else
  Begin
    EnableCommands([cmExitHere]);
    if Message(TopWindow, evBroadcast, cmFileListFocused, nil) <> nil then
      EnableCommands(FileListCmds)
    else
      DisableCommands(FileListCmds);
  End;

  { This app defines a new type of event, evIdle.  This event type is }
  { generated once every idle cycle.                                  }
  Message(Desktop, evIdle, 0, nil);

  if Heap <> nil then Heap^.Update;
End;

 Procedure TOffice.InitMenuBar;
   Begin
     MenuBar:=PMenuBar(RezFile.Get('MenuBar'));
   End;

 Procedure TOffice.InitStatusLine;
  Var R:TRect;
  Begin
    StatusLine := PHCStatusLine(RezFile.Get('StatusLine'));
    GetExtent(R);
    R.A.Y := R.B.Y - 1;
    StatusLine^.Locate(R);
  End;

Procedure TOffice.ToggleVideoMode;
var
  NewMode: Word;
  R: TRect;
Begin
  NewMode := ScreenMode xor smFont8x8;
  if NewMode and smFont8x8 <> 0 then ShadowSize.X := 1
  else ShadowSize.X := 2;
  SetScreenMode(NewMode);
  GetExtent(R);
  Heap^.MoveTo(R.B.X - 9, R.B.Y - 1);
  Desktop^.GetExtent(R);
  TrashCan^.MoveTo(R.A.X + 1, R.B.Y - 4);
  ConfigRec.Video := ScreenMode and smFont8x8;
End;

Procedure TOffice.HandleEvent(var Event: TEvent);
var
  NewDrive: Char;
Begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  Begin
    case Event.Command of
      cmNewWindow:
        Begin
          NewDrive := SelectDrive;
          if NewDrive <> ' ' then InsertTreeWindow(NewDrive);
          ClearEvent(Event);
        End;
      cmBeginSearch: BeginSearch;
      cmInstallViewer : InstallViewer;
      cmDisplayOptions : SetDisplayPrefs;
      cmSaveConfig : SaveConfig;
      cmTile : Tile;
      cmCascade : Cascade;
      cmCloseAll: Message(Desktop, evBroadcast, cmCloseAll, nil);
      cmDosShell : DosShell;
      cmRun : RunDosCommand('');
      cmVideoMode: ToggleVideoMode;
      cmExitHere:
        Begin
          Message(Desktop, evBroadcast, cmGetCurrentDir, @ExitDir);
          EndModal(cmQuit);
          ClearEvent(Event);
        End;
      cmColorChange: SelectNewColors;
    End;
  End;
End;

Procedure TOffice.OutOfMemory;
Begin
  MessageBox('There is not enough memory to complete this operation.',
    nil, mfError+mfOKButton);
End;


{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                      แญฎขญ ๏ เฎฃเ ฌฌ                           ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

Var Office : TOffice;
Begin
  Office.Init;
  Office.Run;
  Office.Done;
End.
