Uses Objects,Drivers,Menus,Views,Dialogs,App;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ฎญไจฃใเ ๆจ๏                            ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Const
   cfgFilename = 'WLAD.CFG';
   cfgAutosave = '[AutosaveTime]';
   cfgSSaver   = '[ScreenSaverActivateTime]';
   cfgProjects = '[Projects]';
   cfgEnd      = '[EndOfFile]';

 Var AutosaveTime,SSaverTime : LongInt;

 Type
   PStringBuffer = ^TStringBuffer;
   TStringBuffer = Array [1..$0FFFF div SizeOf(String)] of String;

 Var Projects : PStringBuffer; ProjectsNum : Byte;

 Type
   TConfig = Object
     ConfigFile : Text;
     Constructor Load;
     Destructor Save;
   End;

 Var Config : TConfig;

 Constructor TConfig.Load;
   Var Command,S:String;
   Begin
     New(Projects);
     Assign(ConfigFile,cfgFileName);
     Reset(ConfigFile);
     ProjectsNum:=0;
     Repeat
       Readln(ConfigFile,Command);
       If Command = cfgAutosave then Readln(ConfigFile,AutosaveTime);
       If Command = cfgSSaver   then Readln(ConfigFile,SSaverTime);
       If Command = cfgProjects then
         Repeat
           Readln(ConfigFile,S);
           If S<>cfgEnd then
             Begin Inc(ProjectsNum); Projects^[ProjectsNum]:=S; End;
         Until ((S=cfgEnd) Or EOF(ConfigFile));
     Until EOF(ConfigFile);
     Close(ConfigFile);
   End;

 Destructor TConfig.Save;
   Var I:Byte;
   Begin
     Assign(ConfigFile,cfgFileName);
     Rewrite(ConfigFile);
     Writeln(ConfigFile,cfgAutosave);
     Writeln(ConfigFile,AutosaveTime);
     Writeln(ConfigFile,cfgSSaver);
     Writeln(ConfigFile,SSaverTime);
     Writeln(ConfigFile,cfgProjects);
     For I:=1 to ProjectsNum do Writeln(ConfigFile,Projects^[I]);
     Writeln(ConfigFile,cfgEnd);
     Close(ConfigFile);
     Dispose(Projects);
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                             เฎฅชโ                               ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   TProject = Object
     Path : String;
     Constructor Init( _Path_:String );
     Destructor Done;
     Procedure Save;
   End;

 Var Project : TProject;

 Constructor TProject.Init( _Path_:String );
   Begin
   End;

 Destructor TProject.Done;
   Begin
   End;

 Procedure TProject.Save;
   Begin
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ฅญ๎ เฎฅชโ๋                            ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   PProjects = ^TProjects;
   TProjects = Object(TStringCollection)
     Constructor Init;
   End;

 Constructor TProjects.Init;
   Var I:Byte; T:Text; S:String;
   Begin
     Inherited Init(10,10);
     For I:=1 to ProjectsNum do
       Begin
         Assign(T,Projects^[I]+'FILE_ID.DIZ');
         Reset(T);
         Readln(T,S);
         Close(T);
         Insert(NewStr(S));
       End;
   End;

 Type
   PPrjLine = ^TPrjLine;
   TPrjLine = Object(TInputLine)
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
   End;

 Procedure TPrjLine.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If Event.What = evBroadcast then
       If Event.Command = cmListItemSelected then
         Begin
           With PListBox(Event.InfoPtr)^ do
             Data^:=GetText(Focused,30);
           DrawView;
           ClearEvent(Event);
         End;
   End;

 Type
   PPrjWin = ^TPrjWin;
   TPrjWin = Object(TDialog)
     Constructor Init;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
   End;

 Constructor TPrjWin.Init;
   Var R:TRect; Control:PView; ScrollBar:PScrollBar;
   Begin
     R.Assign(0,0,43,15);
     Inherited Init(R,'‘ฏจแฎช จฌฅ๎้จๅแ๏ ฏเฎฅชโฎข');
     Options := Options or ofCentered;
     R.Assign(5,2,38,3);
     Control := New(PPrjLine,Init(R,30));
     Control^.EventMask := Control^.EventMask or evBroadcast;
     Insert(Control);
     R.Assign(4,1,13,2);
     Insert(New(PLabel,Init(R,'๋กเ ญ :', Control)));
     R.Assign(37,5,38,11);
     New(ScrollBar,Init(R));
     Insert(ScrollBar);
     R.Assign(5,5,37,11);
     Control := New(PListBox,Init(R,1,ScrollBar));
     Insert(Control);
     PListBox(Control)^.NewList(New(PProjects,Init));
     R.Assign(4,4,14,5);
     Insert(New(PLabel,Init(R,'เฎฅชโ๋ :',Control)));
     R.Assign(11,12,21,14);
     Insert(New(PButton,Init(R,'~~โฌฅญ ',cmCancel,bfNormal)));
     R.Assign(21,12,31,14);
     Insert(New(PButton,Init(R,'~~ฎข๋ฉ',cmNew,bfNormal)));
     R.Assign(31,12,41,14);
     Insert(New(PButton,Init(R,'~~กงฎเ',cmOpen,bfNormal)));
     R.Assign(1,12,11,14);
     Insert(New(PButton,Init(R,'~~',cmOK,bfDefault)));
   End;

 Procedure TPrjWin.HandleEvent( Var Event:TEvent );
   Begin
     If Event.What = evCommand then
       Case Event.Command of
         cmOK   : ;
         cmNew  : ;
         cmOpen : ;
       End;
     Inherited HandleEvent(Event);
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                           ‘ฎก๋โจ๏                                ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Const
   cmTasksLast   = 1000;
   cmTasksNow    = 1001;
   cmTasksFuture = 1002;
   cmEveryDay    = 1003;
   cmEveryWeek   = 1004;
   cmAutoSave    = 1005;
   cmSSaver      = 1006;
   cmOpenPrj     = 1007;
   cmSavePrj     = 1008;
   cmClosePrj    = 1009;
   cmCreateTab   = 1010;
   cmOpenTab     = 1011;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                        •เ ญจโฅซ์ ชเ ญ                           ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   PSSaverWin = ^TSSaverWin;
   TSSaverWin = Object(TDialog)
     SSaver : PInputLine;
     Constructor Init;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
   End;

 Constructor TSSaverWin.Init;
   Var R:TRect; Cluster: PCluster; S:String;
   Begin
     R.Assign(0,0,40,7);
     Inherited Init(R,'•เ ญจโฅซ์ ํชเ ญ ');
     Options := Options Or ofCentered;
     R.Assign(24,2,37,3);
     SSaver:=New(PInputLine,Init(R,14));
     Str(SSaverTime,S);
     SSaver^.SetData(S);
     Insert(SSaver);
     R.Assign(2,2,24,3);
     Insert(New(PLabel,Init(R,'~~เฅฌ๏ แเ ก โ๋ข ญจ๏ : ',SSaver)));
     R.Assign(7,4,17,6);
     Insert(New(PButton,Init(R,'~~',cmOK,bfDefault)));
     R.Assign(23,4,33,6);
     Insert(New(PButton,Init(R,'~~โฌฅญ ',cmCancel,bfNormal)));
     SelectNext(True);
   End;

 Procedure TSSaverWin.HandleEvent( Var Event:TEvent );
   Var S:String; Error:Integer;
   Begin
     If Event.What = evCommand then
       If Event.Command = cmOK then
         Begin
           SSaver^.GetData(S);
           Val(S,SSaverTime,Error);
         End;
     Inherited HandleEvent(Event);
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          €ขโฎแฎๅเ ญฅญจฅ                          ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   PAutosaveWin = ^TAutosaveWin;
   TAutosaveWin = Object(TDialog)
     Autosave : PInputLine;
     Constructor Init;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
   End;

 Constructor TAutosaveWin.Init;
   Var R:TRect; Cluster: PCluster; S:String;
   Begin
     R.Assign(0,0,40,7);
     Inherited Init(R,'€ขโฎแฎๅเ ญฅญจฅ');
     Options := Options Or ofCentered;
     R.Assign(27,2,37,3);
     Autosave:=New(PInputLine,Init(R,8));
     Str(AutosaveTime,S);
     Autosave^.SetData(S);
     Insert(Autosave);
     R.Assign(2,2,26,3);
     Insert(New(PLabel,Init(R,'~~ฅเจฎค  ขโฎแฎๅเ ญฅญจ๏ : ',Autosave)));
     R.Assign(7,4,17,6);
     Insert(New(PButton,Init(R,'~~',cmOK,bfDefault)));
     R.Assign(23,4,33,6);
     Insert(New(PButton,Init(R,'~~โฌฅญ ',cmCancel,bfNormal)));
     SelectNext(True);
   End;

 Procedure TAutosaveWin.HandleEvent( Var Event:TEvent );
   Var S:String; Error:Integer;
   Begin
     If Event.What = evCommand then
       If Event.Command = cmOK then
         Begin
           Autosave^.GetData(S);
           Val(S,AutosaveTime,Error);
         End;
     Inherited HandleEvent(Event);
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                            Office                                ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Type
   TOffice = Object(TApplication)
     Procedure InitMenuBar; Virtual;
     Procedure InitStatusLine; Virtual;
     Procedure HandleEvent( Var Event:TEvent ); Virtual;
     Procedure SaveProject;
     Procedure CloseProject;
   End;

 Procedure TOffice.InitMenuBar;
   Var R:TRect;
   Begin
     GetExtent(R);
     R.B.Y := R.A.Y + 1;
     MenuBar:=New(PMenuBar,Init(R,NewMenu(
       NewSubMenu('~~เฎฅชโ',hcNoContext,NewMenu(
         NewItem('~~โชเ๋โ์',        'F3',kbF3   ,cmOpenPrj,    hcNoContext,
         NewItem('~‘~ฎๅเ ญจโ์',      'F2',kbF2   ,cmSavePrj,    hcNoContext,
         NewItem('~~ ชเ๋โ์',          '',kbNoKey,cmClosePrj,   hcNoContext,
         NewLine(
         NewItem('~€~ขโฎแฎๅเ ญฅญจฅ',   '',kbNoKey,cmAutoSave,   hcNoContext,
         NewItem('~•~เ ญจโฅซ์ ํชเ ญ ', '',kbNoKey,cmSSaver,     hcNoContext,
         NewLine(
         NewItem('~~๋ๅฎค',       'Alt+X',kbAltX ,cmQuit,       hcNoContext,
         nil))))))))),
       NewSubMenu('~’~ กซจๆ ',hcNoContext,NewMenu(
         NewItem('~‘~ฎงค โ์',          '',kbNoKey,cmCreateTab,  hcNoContext,
         NewItem('~~โชเ๋โ์',          '',kbNoKey,cmOpenTab,    hcNoContext,
         nil))),
{       NewSubMenu('~~ซ ญ๋',hcNoContext,NewMenu(
         NewItem('~~ ขฅเ้ฅญญ๋ฅ คฅซ ', '',kbNoKey,cmTasksLast,  hcNoContext,
         NewItem('~’~ฅชใ้จฅ คฅซ ',     '',kbNoKey,cmTasksNow,   hcNoContext,
         NewItem('~~ซ ญ๋ ญ  กใคใ๎้ฅฅ','',kbNoKey,cmTasksFuture,hcNoContext,
         NewLine(
         NewItem('~…~ฆฅคญฅขญ๋ฅ คฅซ ',  '',kbNoKey,cmEveryDay,   hcNoContext,
         NewItem('~…~ฆฅญฅคฅซ์ญ๋ฅ คฅซ ','',kbNoKey,cmEveryWeek,  hcNoContext,
         nil))))))),}
       nil)))));
   End;

 Procedure TOffice.InitStatusLine;
   Var R:TRect;
   Begin
     GetExtent(R);
     R.A.Y := R.B.Y - 1;
     New(StatusLine,Init(R,
       NewStatusDef(0,$EFFF,
         NewStatusKey('~Alt+R~  งฌฅเ ชฎซฎญชจ',kbAltR,cmResize,
         NewStatusKey('~Alt+X~ ๋ๅฎค',kbAltX,cmQuit,
         StdStatusKeys(nil))),
       nil)));
   End;

 Procedure TOffice.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If Event.What = evCommand then
       Begin
         Case Event.Command of
           cmOpenPrj  : ExecuteDialog(New(PPrjWin,Init),nil);
           cmSavePrj  : SaveProject;
           cmClosePrj : CloseProject;
           cmAutosave : ExecuteDialog(New(PAutosaveWin,Init),nil);
           cmSSaver   : ExecuteDialog(New(PSSaverWin,Init),nil);
         Else
           Exit;
         End;
         ClearEvent(Event);
       End;
   End;

 Procedure TOffice.SaveProject;
   Begin
   End;

 Procedure TOffice.CloseProject;
   Begin
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                       แญฎขญ ๏ เฎฃเ ฌฌ                          ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

Var Office : TOffice;
Begin
  Config.Load;
  Office.Init;
  Office.Run;
  Office.Done;
  Config.Save;
End.
