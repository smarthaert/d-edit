unit Main_fm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, DXClass, StdCtrls, Wave, DXSounds, ShellAPI, EGM24;

type
  TShipPoint=record
   bShip:byte;
   bX:byte;
   bY:byte;
   bValue:byte;
   fDead:boolean;
  End;
  TFieldArray=array [0..11,0..11] of byte;
  TMap=record
   fPrimary:boolean;
   faOut:TFieldArray;
   aShipMap:array [1..20] of TShipPoint;
  End;
  TShipMapping=(smVertical,smHorizontal);
  TfmMain = class(TForm)
    tmFade: TDXTimer;
    pnMODPlayer: TPanel;
    tmDirection: TTimer;
    wShot: TDXWave;
    dxSound: TDXSound;
    wHumm: TDXWave;
    wBegin: TDXWave;
    wDead: TDXWave;
    wPoint: TDXWave;
    wSmash: TDXWave;
    tmCyberBrain: TTimer;
    wHaha: TDXWave;
    edName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tmFadeTimer(Sender: TObject; LagCount: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmDirectionTimer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmCyberBrainTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActivateMenu;
    procedure ToggleMenu;
    procedure DrawCursor;
    procedure DrawMenu(var bm:TBitmap);
    procedure RedrawMenu;
    procedure DrawNet(x,y:integer;var bm:TBitmap;fActive:boolean);
    procedure DrawField;
    procedure InitField(var sm:TMap);
    procedure DrawItems(x,y:integer;sm:TMap;var bm:TBitmap);
    function DrawShip(bx,by,n,ns:byte;var sm:TMap;Mapping:TShipMapping):boolean;
    function TestPoint(bx,by:byte;sm:TMap):boolean;
    function TestPointEx(bx,by:byte;sm:TMap):boolean;
    procedure EscDown;
    function ActivateShot(var sm:TMap;bx,by,bFillPoint:byte):byte;
    procedure Sound(wb:TDirectSoundBuffer);
    procedure InitCyberBrain;
    procedure InitFields;
    procedure PlayMusic;
    procedure DrawDigits(x,y:integer;var bm:TBitmap;iValue:integer);
    procedure DrawOptions;
    procedure SetStdOptions;
    procedure MusicIt;
    function GetReadyShips(m:TMap):string;
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
//    procedure NCPaint(var M:TWMNCPAINT); message WM_NCPAINT;
  public
    { Public declarations }
  end;

function CreateIt(parms:string):pointer; stdcall; external 'SeaWars.DLL' name 'ModPlug_CreateEx'; {give her sum life!}
function LoadIt(plug:pointer;filename:string):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_Load'; {load her}
function PlayIt(it:pointer):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_Play'; {play it!}
function SetW(plug:pointer;hand:hwnd):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_SetWindow'; {assigns the plugin to the control}
function IsRead(plug:pointer):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_IsReady'; {am i ready to rocknroll?}
function DestroyIt(plug:pointer):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_Destroy'; {destroys pointer and player}
function StopIt(plug:pointer):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_Stop'; {stops the mod player}
function SetPos(plug:pointer;pos:word):boolean; stdcall; external 'SeaWars.DLL' name 'ModPlug_SetCurrentPosition'; {set position}
function GetMaxPos(plug:pointer):word; stdcall; external 'SeaWars.DLL' name 'ModPlug_GetMaxPosition'; {position}
function GetCurPos(plug:pointer):word; stdcall; external 'SeaWars.DLL' name 'ModPlug_GetCurrentPosition'; {position}
function GetVersion:longint; stdcall; external 'SeaWars.DLL' name 'ModPlug_GetVersion';

const
  cMenuX=225;
  cMenuY=97;
  cNet=20;
  cNetX=15;
  cNetY=40;
  cNetDim=10;
  dmInit=0;
  dmShowMainMenu=3;
  dmDelay=9;
  dmStartGame=10;
  dmNewGame=12;
  dmFadeBack=15;
  dmGameOver=17;
  dmOptions=18;
  dmFadeMain=21;
  dmYourName=22;
  cUnvisiblePoint=10;
  cFontSize=16;

var
// Global variables
  fmMain: TfmMain;
  bmMain,bmBack,bmPaint,bmNet,bmTemp1,bmTemp2,bmTemp3:TBitmap;
  iBattles,iIndex,iMenuItems,iNMenu,iMenu,iDemoMode,iFade,iFadeStep:integer;
  fName,fGameOver,fBattle,fPlayer2,fBattleOver,fPause,fGame,fMenu,fFade,
  fCloseEnabled
   :boolean;
  sCheatCode,sStartPath,sTitle,sPlayer1,sPlayer2:string;
  mField1,mField2:TMap;
  bWins1,bWins2:byte;
  fFont:TFont;
// Sound and music variables
  fMM:boolean;
  pMODPlayer:pointer;
  wbHaha,wbSmash,wbBegin,wbDead,wbShot,wbPoint,wbHumm:TDirectSoundBuffer;
// Mouse variables
  bMouseX,bMouseY:byte;
// Saved variables
  iMaxScore,iGameSpeed:integer;
  fMusic,fSound,fDrawPoints:boolean;
// Stored variables
  iSMaxScore,iSGameSpeed:integer;
  fSMusic,fSSound,fSDrawpoints:boolean;    
// CyberBrain variables
  aPoints:array[0..3] of TPoint;
  pOld:TPoint;
  iPointsCount:integer;
  fKill:boolean;

implementation

{$R *.DFM}

{procedure TfmMain.NCPaint(var M:TWMNCPAINT);
 var
  h:hDC;
  hBr:hBrush;
  iHCaption,iWCaption,iWFrame,iHFrame:integer;
begin
 h:=GetWindowDC(Handle);
 iWFrame:=(Width-ClientWidth) div 2;
 iWCaption:=Width;
 iHCaption:=Height-ClientHeight-iWFrame;
 iHFrame:=ClientHeight;
 hBr:=CreateSolidBrush(clBlue);

 FillRect(h,Rect(0,0,iWCaption,iHCaption),hBr);
 FillRect(h,Rect(0,
                 iHCaption+iHFrame,
                 iWCaption,
                 iHCaption+iHFrame+iWFrame),hBr);

 ReleaseDC(Handle,h)
end;}

function TfmMain.GetReadyShips(m:TMap):string;
 const
  d='_ ';
 var
  s:string;
begin
 s:='';
 If NOT m.aShipMap[1].fDead Then s:='4 ' Else s:=d;
 If NOT m.aShipMap[5].fDead Then s:=s+'3 ' Else s:=s+d;
 If NOT m.aShipMap[8].fDead Then s:=s+'3 ' Else s:=s+d;
 If NOT m.aShipMap[11].fDead Then s:=s+'2 ' Else s:=s+d;
 If NOT m.aShipMap[13].fDead Then s:=s+'2 ' Else s:=s+d;
 If NOT m.aShipMap[15].fDead Then s:=s+'2 ' Else s:=s+d;
 If NOT m.aShipMap[17].fDead Then s:=s+'1 ' Else s:=s+d;
 If NOT m.aShipMap[18].fDead Then s:=s+'1 ' Else s:=s+d;
 If NOT m.aShipMap[19].fDead Then s:=s+'1 ' Else s:=s+d;
 If NOT m.aShipMap[20].fDead Then s:=s+'1 ' Else s:=s+d;
 GetReadyShips:=s
end;

procedure TfmMain.MusicIt;
begin
 If fMusic Then PlayIt(pMODPlayer) Else StopIt(pMODPlayer)
end;

procedure TfmMain.SetStdOptions;
begin
 iMaxScore:=3;
 iGameSpeed:=4;
 fMusic:=true;
 fSound:=true;
 fDrawPoints:=false;
 sPlayer1:='Player'
end;

procedure TfmMain.DrawOptions;
begin
 bmImage.Handle:=LoadBitmap(hInstance,'BMOPTS');
 With bmMain, Canvas do
  Begin
   FillRect(Rect(0,0,Width div 2,Height));
   Draw(15,20,bmImage);
   bmImage.Handle:=LoadBitmap(hInstance,'BMSELOPT');
   If fMusic Then Draw(28,42,bmImage);
   If fSound Then Draw(28,61,bmImage);
   If fDrawPoints Then Draw(28,118,bmImage)
  End;
 DrawDigits(194,194,bmMain,iMaxScore);
 DrawDigits(178,213,bmMain,iGameSpeed)
end;

procedure TfmMain.DrawDigits(x,y:integer;var bm:TBitmap;iValue:integer);
 var
  i:integer;
  s:string;
begin
 bmImage.Handle:=LoadBitmap(hInstance,'BMDIGITS');
 s:=IntToStr(iValue);
 For i:=1 to Length(s) do
  Begin
   iValue:=StrToInt(s[i]);
   bm.Canvas.CopyRect(Rect(x,y,x+bmImage.Width div 10,y+bmImage.Height),
                      bmImage.Canvas,
                      Rect(iValue*(bmImage.Width div 10),0,
                           iValue*(bmImage.Width div 10)+bmImage.Width div 10,
                           bmImage.Height));
   Inc(x,bmImage.Width div 10)
  End                         
end;

procedure TfmMain.PlayMusic;
begin
 SetPos(pMODPlayer,336);
 If fMM Then
  Begin
   wbBegin.Free;
   wbDead.Free;
   wbShot.Free;
   wbSmash.Free;
   wbPoint.Free;
   wbHumm.Free;
   wbHaha.Free;
   dxSound.Finalize
  End;
 If fMusic Then PlayIt(pMODPlayer)
end;

procedure TfmMain.InitFields;
begin
 InitField(mField1);
 mField1.fPrimary:=true;
 InitField(mField2);
 mField2.fPrimary:=false
end;

procedure TfmMain.Sound(wb:TDirectSoundBuffer);
begin
 If (NOT fMM) OR (NOT fSound) Then Exit;
 wb.Stop;
 wb.Position:=0;
 wb.Play;

end;

function TfmMain.ActivateShot(var sm:TMap;bx,by,bFillPoint:byte):byte;
 var
  i,j:byte;
  f:boolean;
  asf:byte;
 procedure MakeDead(iIndex:integer);
  begin
   sm.aShipMap[iIndex].fDead:=true;
   With sm do
    Begin
     If faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by-1]=0 Then
      faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by-1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx,aShipMap[iIndex].by-1]=0 Then
      faOut[aShipMap[iIndex].bx,aShipMap[iIndex].by-1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by-1]=0 Then
      faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by-1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by]=0 Then
      faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by+1]=0 Then
      faOut[aShipMap[iIndex].bx+1,aShipMap[iIndex].by+1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx,aShipMap[iIndex].by+1]=0 Then
      faOut[aShipMap[iIndex].bx,aShipMap[iIndex].by+1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by+1]=0 Then
      faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by+1]:=bFillPoint;
     If faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by]=0 Then
      faOut[aShipMap[iIndex].bx-1,aShipMap[iIndex].by]:=bFillPoint
    End
  end;
begin
 If fDrawPoints Then bFillPoint:=73;
 asf:=0;
 If sm.faOut[bx,by]>4 Then
  Begin
   Sound(wbHumm);
   ActivateShot:=asf;
   Exit
  End;
 sm.faOut[bx,by]:=73;
 DrawField;
 FormPaint(Self);
 Sound(wbShot);
 f:=fPlayer2;
 fPlayer2:=NOT fPlayer2;
 For i:=1 to 20 do
  If (sm.aShipMap[i].bx=bx) AND (sm.aShipMap[i].by=by) Then
   Begin
    asf:=1;
    j:=(sm.aShipMap[i].bShip MOD 10)-1;
    sm.faOut[bx,by]:=77;
    Case sm.aShipMap[i].bShip DIV 10 of
     1: MakeDead(i);
     2: If (sm.faOut[sm.aShipMap[11+j*2].bx,sm.aShipMap[11+j*2].by]=77) AND
           (sm.faOut[sm.aShipMap[11+j*2+1].bx,sm.aShipMap[11+j*2+1].by]=77) Then
         Begin
          MakeDead(11+j*2);
          MakeDead(11+j*2+1)
         End;
     3: If (sm.faOut[sm.aShipMap[5+j*3].bx,sm.aShipMap[5+j*3].by]=77) AND
           (sm.faOut[sm.aShipMap[5+j*3+1].bx,sm.aShipMap[5+j*3+1].by]=77) AND
           (sm.faOut[sm.aShipMap[5+j*3+2].bx,sm.aShipMap[5+j*3+2].by]=77) Then
         Begin
          MakeDead(5+j*3);
          MakeDead(5+j*3+1);
          MakeDead(5+j*3+2)
         End;
     4: If (sm.faOut[sm.aShipMap[1].bx,sm.aShipMap[1].by]=77) AND
           (sm.faOut[sm.aShipMap[2].bx,sm.aShipMap[2].by]=77) AND
           (sm.faOut[sm.aShipMap[3].bx,sm.aShipMap[3].by]=77) AND
           (sm.faOut[sm.aShipMap[4].bx,sm.aShipMap[4].by]=77) Then
         Begin
          MakeDead(1);
          MakeDead(2);
          MakeDead(3);
          MakeDead(4)
         End
    End;
    If sm.aShipMap[i].fDead Then
     Begin
      asf:=2;
      Sound(wbDead);
      Sound(wbSmash)
     End;
    Sound(wbPoint);
    fPlayer2:=f;
    Break
   End;
 DrawField;
 FormPaint(Self);
 j:=0;
 For i:=1 to 20 do
  If sm.aShipMap[i].fDead Then Inc(j);
 If j=20 Then
  Begin
   tmCyberBrain.Enabled:=false;
   mField2.fPrimary:=true;
   fBattle:=false;
   fBattleOver:=true;
   fPause:=false;
   DrawField;
   FormPaint(Self);
   Sound(wbBegin);
   If fPlayer2 Then Inc(bWins2) Else Inc(bWins1);
   If (bWins2=iMaxScore) OR (bWins1=iMaxScore) Then fGameOver:=true; 
   Inc(iBattles);
   InitFields
  End;
 ActivateShot:=asf 
end;

procedure TfmMain.EscDown;
begin
 tmFade.Enabled:=false;
 If fMenu AND fGame AND (iNMenu<>3) Then
  If fBattle Then
   Begin
    fMenu:=false;
    iDemoMode:=dmStartGame;
    Exit
   End
  Else
   If iNMenu=1 Then
    Begin
     fMenu:=false;
     iDemoMode:=dmNewGame;
     Exit
    End;
 tmCyberBrain.Enabled:=false;
 ToggleMenu
end;


function TfmMain.TestPoint(bx,by:byte;sm:TMap):boolean;
 var
  f:boolean;
begin
 f:=true;
 If (bx>cNetDim) OR (by>cNetDim) OR (sm.faOut[bx,by]<>0) Then f:=false;
 TestPoint:=f
end;

function TfmMain.TestPointEx(bx,by:byte;sm:TMap):boolean;
 var
  f:boolean;
begin
 f:=true;
 If (bx>cNetDim) OR (by>cNetDim) OR (sm.faOut[bx,by]>4) Then f:=false;
 TestPointEx:=f
end;

function TfmMain.DrawShip(bx,by,n,ns:byte;var sm:TMap;Mapping:TShipMapping):boolean;
 var
  i,j:byte;
  f:boolean;
begin
 f:=false;
 If n=1 Then
  If TestPoint(bx,by,sm) Then
   Begin
    sm.faOut[bx,by]:=n;
    sm.aShipMap[iIndex].bx:=bx;
    sm.aShipMap[iIndex].by:=by;
    sm.aShipMap[iIndex].bShip:=n*10+ns;
    sm.aShipMap[iIndex].bValue:=sm.faOut[bx,by];
    Inc(iIndex);
    f:=true
   End
  Else Begin End
 Else
  Case Mapping of
   smVertical: Begin
                If TestPoint(bx,by,sm) Then
                 For i:=1 to n-2 do
                  If NOT TestPoint(bx,by+i,sm) Then
                   Begin
                    DrawShip:=f;
                    Exit
                   End
                  Else Begin End
                Else
                 Begin
                  DrawShip:=f;
                  Exit
                 End;
                If TestPoint(bx,by+n-1,sm) Then
                 Begin
                  With sm do
                   Begin
                    faOut[bx,by]:=n;
                    aShipMap[iIndex].bx:=bx;
                    aShipMap[iIndex].by:=by;
                    aShipMap[iIndex].bShip:=n*10+ns;
                    aShipMap[iIndex].bValue:=6
                   End;
                  Inc(iIndex);
                  For i:=1 to n-2 do
                   Begin
                    With sm do
                     Begin
                      faOut[bx,by+i]:=n;
                      aShipMap[iIndex].bx:=bx;
                      aShipMap[iIndex].by:=by+i;
                      aShipMap[iIndex].bShip:=n*10+ns;
                      aShipMap[iIndex].bValue:=2
                     End;
                    Inc(iIndex);
                   End;
                  With sm do
                   Begin
                    faOut[bx,by+n-1]:=n;
                    aShipMap[iIndex].bx:=bx;
                    aShipMap[iIndex].by:=by+n-1;
                    aShipMap[iIndex].bShip:=n*10+ns;
                    aShipMap[iIndex].bValue:=7
                   End;
                  Inc(iIndex);
                  f:=true
                 End
               End;
   smHorizontal: Begin
                  If TestPoint(bx,by,sm) Then
                   For i:=1 to n-2 do
                    If NOT TestPoint(bx+i,by,sm) Then
                     Begin
                      DrawShip:=f;
                      Exit
                     End
                    Else Begin End
                  Else
                   Begin
                    DrawShip:=f;
                    Exit
                   End;
                  If TestPoint(bx+n-1,by,sm) Then
                   Begin
                    With sm do
                     Begin
                      faOut[bx,by]:=n;
                      aShipMap[iIndex].bx:=bx;
                      aShipMap[iIndex].by:=by;
                      aShipMap[iIndex].bShip:=n*10+ns;
                      aShipMap[iIndex].bValue:=4
                     End;
                    Inc(iIndex);
                    For i:=1 to n-2 do
                     Begin
                      With sm do
                       Begin
                        faOut[bx+i,by]:=n;
                        aShipMap[iIndex].bx:=bx+i;
                        aShipMap[iIndex].by:=by;
                        aShipMap[iIndex].bShip:=n*10+ns;
                        aShipMap[iIndex].bValue:=3
                       End;
                      Inc(iIndex)
                     End;
                    With sm do
                     Begin
                      faOut[bx+n-1,by]:=n;
                      aShipMap[iIndex].bx:=bx+n-1;
                      aShipMap[iIndex].by:=by;
                      aShipMap[iIndex].bShip:=n*10+ns;
                      aShipMap[iIndex].bValue:=5
                     End;
                    Inc(iIndex);
                    f:=true
                   End
                 End
  End;
 If f Then
  For i:=1 to cNetDim do
   For j:=1 to cNetDim do
    If (sm.faOut[i,j]>0) and (sm.faOut[i,j]<5) Then
     With sm do
      Begin
       If faOut[i-1,j-1]=0 Then faOut[i-1,j-1]:=cUnvisiblePoint;
       If faOut[i,j-1]=0 Then faOut[i,j-1]:=cUnvisiblePoint;
       If faOut[i+1,j-1]=0 Then faOut[i+1,j-1]:=cUnvisiblePoint;
       If faOut[i+1,j]=0 Then faOut[i+1,j]:=cUnvisiblePoint;
       If faOut[i+1,j+1]=0 Then faOut[i+1,j+1]:=cUnvisiblePoint;
       If faOut[i,j+1]=0 Then faOut[i,j+1]:=cUnvisiblePoint;
       If faOut[i-1,j+1]=0 Then faOut[i-1,j+1]:=cUnvisiblePoint;
       If faOut[i-1,j]=0 Then faOut[i-1,j]:=cUnvisiblePoint
      End;
 DrawShip:=f
end;

procedure TfmMain.InitField(var sm:TMap);
 var
  i,j,k,l:byte;
  smg:TShipMapping;
begin
 ZeroMemory(@sm,SizeOf(sm));
 iIndex:=1;
 For l:=1 to 4 do
  Begin
   For k:=1 to l do
    Begin
     Repeat
      smg:=smVertical;
      If Random(2)=0 Then smg:=smHorizontal;
      i:=Random(cNetDim)+1;
      j:=Random(cNetDim)+1;
     Until DrawShip(i,j,5-l,k,sm,smg)
    End
  End;
 For i:=1 to cNetDim do For j:=1 to cNetDim do
  If sm.faOut[i,j]=cUnvisiblePoint Then sm.faOut[i,j]:=0
end;

procedure TfmMain.ActivateMenu;
 var
  i:integer;
begin
 Case iNMenu of
  1: Case iMenu of // SELECT
      0: // New game
       Begin
        i:=IDYES;
        If fGame Then
         i:=MessageBox(Handle,'Old game not finished. Are You sure?','Sea Wars - New game',
                       mb_IconExclamation+mb_YesNoCancel);
        If i=IDCANCEL Then Exit;
        iDemoMode:=dmNewGame;
        If i=IDYES Then
         Begin
          InitFields;
          iBattles:=0;
          bWins1:=0;
          bWins2:=0;
          fGame:=true;
          fGameOver:=false;
          sPlayer2:='CyberCaptain';
          iDemoMode:=dmYourName
         End
        Else
         If fPause OR fBattle Then
          Begin
           EscDown;
           Exit
          End;
        fMenu:=false;
        fBattle:=false
       End;
      1: // Controls
       Begin
        MessageBox(Handle,'Sorry... It not work yet!','Sea Wars - Controls',mb_IconExclamation);
       End;
      2: // Options
       Begin
        fMenu:=False;
        iDemoMode:=dmOptions
       End;
      3: Close // Quit
     End;
  2: Case iMenu of // MAP
      0: Begin // Play!
          iDemoMode:=dmStartGame;
          fMenu:=false
         End;
      1: Begin // Generate
          InitField(mField1);
          mField1.fPrimary:=true;
          bmMain.Canvas.FillRect(Rect(cNetX,cNetY,cNetX+cNet*cNetDim+2,cNetY+cNet*cNetDim+2));
          DrawNet(cNetX,cNetY,bmMain,true);
          DrawItems(cNetX,cNetY,mField1,bmMain);
          FormPaint(Self)
         End;
      2: MessageBox(Handle,'Sorry... It not work yet!','Sea Wars - Manual',mb_IconExclamation);
      3: Begin // End game
          If MessageBox(Handle,'Are You sure?','Sea Wars - End game',
                        mb_IconExclamation+mb_YesNo)=IDNO Then Exit;
          fGame:=false;
          EscDown
         End 
     End;
  3: Case iMenu of // OPTIONS
      0: EscDown; // Apply
      1: Begin // Reset to default
          SetStdOptions;
          fMusic:=fMM;
          fSound:=fMM;
          MusicIt;
          DrawOptions;
          FormPaint(Self)
         End;
      2: Begin
          MessageBox(Handle,'Sorry... It not work yet!','Sea Wars - Net game',mb_IconExclamation)
         End;
      3: Begin // Cancel
          iMaxScore:=iSMaxScore;
          iGameSpeed:=iSGameSpeed;
          fMusic:=fSMusic;
          fSound:=fSSound;
          fDrawPoints:=fSDrawPoints;
          MusicIt;
          EscDown
         End
     End
 End
end;

procedure TfmMain.DrawField;
 var
  s:string;
  iX,iY,iFS:integer;
  fs:TFontStyles;
begin
 ReadBitmap24(bmBack,'BMBACK');
 If NOT fBattleOver Then
  Begin
   DropShadow24(cNetX-4,5,cNet*cNetDim+9,cNet*cNetDim+cNetY,bmBack,140);
   DropShadow24(bmBack.Width-cNet*cNetDim-cNetX-4,5,
                cNet*cNetDim+9,cNet*cNetDim+cNetY,bmBack,150)
  End
 Else
  DropShadow24(0,0,bmBack.Width,bmBack.Height,bmBack,150);
 DrawNet(cNetX,cNetY,bmBack,fPlayer2);
 DrawItems(cNetX,cNetY,mField1,bmBack);
 DrawNet(bmBack.Width-cNet*cNetDim-cNetX,cNetY,bmBack,NOT fPlayer2);
 DrawItems(bmBack.Width-cNet*cNetDim-cNetX,cNetY,mField2,bmBack);
 With bmBack.Canvas do
  If fBattleOver Then
   Begin
    DropShadow24(0,0,bmBack.Width,bmBack.Height,bmBack,150);
    If fPlayer2 Then s:=sPlayer2 Else s:=sPlayer1;
    s:='BATTLE OVER - '+s+' wins!!!';
    iFS:=Font.Size;
    fs:=Font.Style;
    Font.Size:=cFontSize;
    Font.Style:=[];
    iX:=(Width-TextWidth(s)) div 2;
    iY:=(cNetY-TextHeight(s)) div 2;
    SetBkMode(Handle,TRANSPARENT);
    TextOut(iX,iY,s);
    Font.Size:=iFS;
    Font.Style:=fs
   End
  Else
   Begin
    SetBkMode(Handle,TRANSPARENT);
    s:=GetReadyShips(mField1);
    TextOut(cNetX,5,sPlayer1+'''s fleet');
    TextOut(cNetX,cNetY-TextHeight(s)-2,s);
    s:=GetReadyShips(mField2);
    TextOut(bmBack.Width-cNet*cNetDim-cNetX,5,sPlayer2+'''s fleet');
    TextOut(bmBack.Width-cNet*cNetDim-cNetX,cNetY-TextHeight(s)-2,s)
   End
end;

procedure TfmMain.DrawItems(x,y:integer;sm:TMap;var bm:TBitmap);
 var
  i,j:byte;
  c:TColor;
 procedure SetStdPen;
  begin
   bm.Canvas.Pen.Color:=clLime;
   bm.Canvas.Pen.Width:=3
  end;
 procedure LeftLine;
  begin
   With bm, Canvas do
    Begin
     MoveTo(x+(sm.aShipMap[i].bx-1)*cNet+1,y+(sm.aShipMap[i].by-1)*cNet+1);
     LineTo(x+(sm.aShipMap[i].bx-1)*cNet+1,y+(sm.aShipMap[i].by-1)*cNet+cNet-1)
    End
  end;
 procedure RightLine;
  begin
   With bm, Canvas do
    Begin
     MoveTo(x+(sm.aShipMap[i].bx-1)*cNet+cNet-1,y+(sm.aShipMap[i].by-1)*cNet+1);
     LineTo(x+(sm.aShipMap[i].bx-1)*cNet+cNet-1,y+(sm.aShipMap[i].by-1)*cNet+cNet-1)
    End
  end;
 procedure TopLine;
  begin
   With bm, Canvas do
    Begin
     MoveTo(x+(sm.aShipMap[i].bx-1)*cNet+1,y+(sm.aShipMap[i].by-1)*cNet+1);
     LineTo(x+(sm.aShipMap[i].bx-1)*cNet+cNet-1,y+(sm.aShipMap[i].by-1)*cNet+1)
    End
  end;
 procedure BottomLine;
  begin
   With bm, Canvas do
    Begin
     MoveTo(x+(sm.aShipMap[i].bx-1)*cNet+1,y+(sm.aShipMap[i].by-1)*cNet+cNet-1);
     LineTo(x+(sm.aShipMap[i].bx-1)*cNet+cNet-1,y+(sm.aShipMap[i].by-1)*cNet+cNet-1)
    End
  end;
begin
 c:=bm.Canvas.Pen.Color;
 For i:=1 to 20 do
  If sm.aShipMap[i].fDead OR sm.fPrimary Then
   Case sm.aShipMap[i].bValue of
    1: Begin
        SetStdPen;
        LeftLine;
        RightLine;
        TopLine;
        BottomLine
       End;
    2: Begin
        SetStdPen;
        LeftLine;
        RightLine
       End;
    3: Begin
        SetStdPen;
        TopLine;
        BottomLine
       End;
    4: Begin
        SetStdPen;
        LeftLine;
        TopLine;
        BottomLine
       End;
    5: Begin
        SetStdPen;
        RightLine;
        TopLine;
        BottomLine
       End;
    6: Begin
        SetStdPen;
        LeftLine;
        RightLine;
        TopLine
       End;
    7: Begin
        SetStdPen;
        LeftLine;
        RightLine;
        BottomLine
       End
   End;
 With bm, Canvas do
  For i:=0 to 9 do
   For j:=0 to 9 do
    Case sm.faOut[i+1,j+1] of
     73: Begin
          Pixels[x+i*cNet+(cNet div 2),y+j*cNet+(cNet div 2)]:=c;
          Pixels[x+i*cNet+(cNet div 2),y+j*cNet+(cNet div 2)-1]:=c;
          Pixels[x+i*cNet+(cNet div 2)-1,y+j*cNet+(cNet div 2)]:=c;
          Pixels[x+i*cNet+(cNet div 2),y+j*cNet+(cNet div 2)+1]:=c;
          Pixels[x+i*cNet+(cNet div 2)+1,y+j*cNet+(cNet div 2)]:=c
         End;
     77: Begin
          Pen.Color:=clRed;
          Pen.Width:=3;
          MoveTo(x+3+i*cNet,y+3+j*cNet);
          LineTo(x+cNet-3+i*cNet,y+cNet-3+j*cNet);
          MoveTo(x+3+i*cNet,y+cNet-3+j*cNet);
          LineTo(x+cNet-3+i*cNet,y+3+j*cNet)
         End
    End;
 bm.Canvas.Pen.Color:=c
end;

procedure TfmMain.DrawNet(x,y:integer;var bm:TBitmap;fActive:boolean);
 var
  c:integer;
begin
 With bm, Canvas do
  Begin
   CopyMode:=cmSrcPaint;
   Draw(x-1,y-1,bmNet);
   CopyMode:=cmSrcCopy;
   If fActive Then
    Begin
     c:=Pen.Color;
     Dec(x,3);
     Dec(y,3);
     Pen.Width:=1;
     Pen.Color:=$007777FF;
     MoveTo(x,y);
     LineTo(x+cNet*cNetDim+6,y);
     LineTo(x+cNet*cNetDim+6,y+cNet*cNetDim+6);
     LineTo(x,y+cNet*cNetDim+6);
     LineTo(x,y);
     Pen.Color:=c     
    End
  End
end;

procedure TfmMain.RedrawMenu;
begin
 DrawMenu(bmMain);
 DrawCursor;
 FormPaint(Self)
end;

procedure TfmMain.DrawMenu(var bm:TBitMap);
begin
 Case iNMenu of
  1: bmImage.Handle:=LoadBitMap(hInstance,'BMMENU');
  2: bmImage.Handle:=LoadBitMap(hInstance,'BMSBMENU');
  3: bmImage.Handle:=LoadBitMap(hInstance,'BMOMENU')
 End;
 iMenuItems:=bmImage.Height div 29; 
 bm.Canvas.Draw(cMenuX,cMenuY,bmImage)
end;

procedure TfmMain.DrawCursor;
begin
 Case iNMenu of
  1: bmImage.Handle:=LoadBitMap(hInstance,'BMSMENU');
  2: bmImage.Handle:=LoadBitMap(hInstance,'BMSSMENU');
  3: bmImage.Handle:=LoadBitMap(hInstance,'BMSOMENU')
 End;
 bmMain.Canvas.CopyRect
  (Rect(cMenuX,cMenuY+iMenu*29,cMenuX+bmImage.Width,iMenu*29+cMenuY+29),
  bmImage.Canvas,Rect(0,iMenu*29,bmImage.Width,iMenu*29+29))
end;

procedure TfmMain.ToggleMenu;
 var
  f:boolean;
begin
 f:=fMenu;
 fMenu:=false;
 iDemoMode:=dmShowMainMenu;
 bmImage.Handle:=LoadBitmap(hInstance,'BMLOGO2');
 If (NOT fBattle) AND (NOT fBattleOver) OR f Then
  Begin
   iDemoMode:=dmFadeMain;
   If GetCurPos(pMODPlayer)<336 Then
    Begin
     Caption:=sTitle;
     SetPos(pMODPlayer,336)
    End;
   Exit
  End
 Else
  If fBattle AND (iNMenu<>3) Then
   Begin
    fPause:=true;
    PlayMusic
   End;
 iFade:=0;
 fFade:=true
end;

procedure TfmMain.FormCreate(Sender: TObject);
 var
  f:file;
  i,j:integer;
begin
 With edName do
  Begin
   Font.Name:='Tahoma';
   Font.Size:=10;
   Width:=142;
   Height:=16;
   Visible:=false
  End;
 sStartPath:=ExtractFilePath(ParamStr(0));
 ClientWidth:=450;
 ClientHeight:=250;
 Color:=clBlack;
 Cursor:=3;
 pMODPlayer:=CreateIt('hidden|true');
 SetW(pMODPlayer,pnMODPlayer.Handle);
 LoadIt(pMODPlayer,sStartPath+'\SeaWars.dat');
 SetPos(pMODPlayer,64);
 PlayIt(pMODPlayer);
 fMM:=true;
 If (NOT IsRead(pMODPlayer)) OR (GetCurPos(pMODPlayer)=0) Then
  Begin
   MessageBox(Handle,'Error in sound subsystem! Sound effects and music disabled.'#13#13'Press Esc key or click right mouse button on game window to continue.',
              'Sea Wars',mb_IconError);
   fMM:=false
  End;
 bmMain:=TBitmap.Create;
 bmBack:=TBitmap.Create;
 bmPaint:=TBitmap.Create;
 bmNet:=TBitmap.Create;
 bmTemp1:=TBitmap.Create;
 bmTemp2:=TBitmap.Create;
 bmTemp3:=TBitmap.Create; 
 With bmTemp1, Canvas do
  Begin
   Brush.Color:=clBlack;
   PixelFormat:=pf24bit
  End;
 With bmTemp2, Canvas do
  Begin
   Brush.Color:=clBlack;
   PixelFormat:=pf24bit
  End;
 With bmTemp3, Canvas do
  Begin
   Brush.Color:=clBlack;
   PixelFormat:=pf24bit
  End;
 With bmNet, Canvas do
  Begin
   Brush.Color:=clBlack;
   Pen.Color:=$00FFF0F0;
   Width:=cNet*cNetDim+4;
   Height:=cNet*cNetDim+4;
   Pen.Width:=2;
   MoveTo(1,1);
   LineTo(cNet*cNetDim+2,1);
   LineTo(cNet*cNetDim+2,cNet*cNetDim+2);
   LineTo(1,cNet*cNetDim+2);
   LineTo(1,1);
   For i:=1 to 9 do
    For j:=1 to cNet*cNetDim div 2-1 do
     Pixels[1+i*cNet,1+j*2]:=Pen.Color;
   For i:=1 to 9 do
    For j:=1 to cNet*cNetDim div 2-1 do
     Pixels[1+j*2,1+i*cNet]:=Pen.Color
  End;
 With bmBack do
  Begin
   Canvas.Brush.Color:=clBlack;
   Canvas.Pen.Color:=$00FFF0F0;
   Canvas.Font.Name:='Tahoma';
   Canvas.Font.Size:=10;
   Canvas.Font.Style:=[fsBold];
   Canvas.Font.Color:=Canvas.Pen.Color;
   PixelFormat:=pf24bit;
   Width:=ClientWidth;
   Height:=ClientHeight
  End;
 With bmMain do
  Begin
   Canvas.Brush.Color:=clBlack;
   Canvas.Pen.Color:=$00FFF0F0;
   Canvas.Font.Name:='Tahoma';
   Canvas.Font.Style:=[];
   Canvas.Font.Size:=cFontSize;
   Canvas.Font.Color:=Canvas.Pen.Color;
   PixelFormat:=pf24bit;
   Width:=ClientWidth;
   Height:=ClientHeight
  End;
 With bmPaint do
  Begin
   Canvas.Brush.Color:=clBlack;  
   PixelFormat:=pf24bit;
   Width:=ClientWidth;
   Height:=ClientHeight
  End;
 ReadBitmap24(bmTemp2,'BMAXS');
 ReadBitmap24(bmTemp3,'BMAPRES');
 With bmMain do
  Begin
   Canvas.Draw((Width-bmTemp2.Width) div 2,
               Height div 2 -bmTemp2.Height,bmTemp2);
   Canvas.Draw((Width-bmTemp3.Width) div 2,Height div 2 +40,bmTemp3)
  End;
 ReadBitmap24(bmTemp1,'BMBACK');
 FadeBitmap24(bmTemp1,bmBack,bmBack,200);
 ReadBitmap24(bmTemp2,'BMLOGO1');
 ReadBitmap24(bmTemp3,'BMLOGO1M');
 DrawBitmap24(9,219,bmTemp2,bmTemp3,bmBack);
 sTitle:='Sea Wars';
 Randomize;
 Screen.Cursors[1]:=LoadCursor(hInstance,'CRACROSS');
 Screen.Cursors[2]:=LoadCursor(hInstance,'CRHAND');
 Screen.Cursors[3]:=LoadCursor(hInstance,'CRMAIN');
 sCheatCode:='';
 AssignFile(f,sStartPath+'\SeaWars.cfg');
 Try
  Reset(f,1);
  BlockRead(f,fMusic,1);
  BlockRead(f,fSound,1);
  BlockRead(f,fDrawPoints,1);
  BlockRead(f,iMaxScore,4);
  BlockRead(f,iGameSpeed,4);
  SetLength(sPlayer1,FileSize(f)-11);
  BlockRead(f,sPlayer1[1],Length(sPlayer1));
  CloseFile(f);
 Except
  SetStdOptions;
 End;
 If NOT fMM Then
  Begin
   fMusic:=false;
   fSound:=false
  End;
 iMenu:=0;
 fMenu:=false;
 fGame:=false;
 iFade:=255;
 iFadeStep:=3;
 fFade:=true;
 iDemoMode:=dmInit;
 fCloseEnabled:=false
end;

procedure TfmMain.FormPaint(Sender: TObject);
begin
 If tmFade.Enabled Then
  FadeBitmap24(bmMain,bmBack,bmPaint,Lo(iFade))
 Else
  If iFade=0 Then
   bmPaint.Canvas.Draw(0,0,bmBack)
  Else
   bmPaint.Canvas.Draw(0,0,bmMain);
 Canvas.Draw(0,0,bmPaint)
end;

procedure TfmMain.tmFadeTimer(Sender: TObject; LagCount: Integer);
begin
 If fFade then
  Begin
   Dec(iFade,iFadeStep);
   If iFade<0 Then
    Begin
     iFade:=0;
     tmFade.Enabled:=false
    End
  End
 Else
  Begin
   Inc(iFade,iFadeStep);
   If iFade>255 Then
    Begin
     iFade:=255;
     tmFade.Enabled:=false
    End
  End;
 FormPaint(Self)
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 var
  p:TPoint;  
begin
 If fCloseEnabled Then Halt;
 If tmFade.Enabled Then If iDemoMode>dmShowMainMenu-1 Then Exit;
 If Key=27 Then Begin EscDown; Exit End;
 If fMenu Then
  Case Key of
   38: // Up
    Begin
     If iMenu=0 Then iMenu:=iMenuItems-1 Else Dec(iMenu);
     RedrawMenu
    End;
   40: // Down
    Begin
     If iMenu=iMenuItems-1 Then iMenu:=0 Else Inc(iMenu);
     RedrawMenu
    End;
   13: ActivateMenu
  End
 Else
  If fBattle OR fBattleOver Then
   Begin
    Case Key of
     32: mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0); // Space
     38: If bMouseY>0 then Dec(bMouseY);            // Up
     40: If bMouseY<cNetDim-1 then Inc(bMouseY);    // Down
     37: If bMouseX>0 then Dec(bMouseX);            // Left
     39: If bMouseX<cNetDim-1 then Inc(bMouseX)     // Right
    End;
    Case Key of
     32,38,40,37,39:
      Begin
       p:=ClientToScreen(Point(ClientWidth-cNet*cNetDim-cNetX,cNetY));
       Inc(p.X,(cNet div 2)+bMouseX*cNet);
       Inc(p.Y,(cNet div 2)+bMouseY*cNet);
       SetCursorPos(p.X,p.Y)
      End
    End   
   End
end;

procedure TfmMain.tmDirectionTimer(Sender: TObject);
 var
  s:string;
  i,j:integer;
begin
 Case iDemoMode of
  0: If GetCurPos(pMODPlayer)>=136 Then
      Begin
       tmFade.Enabled:=true;
       Inc(iDemoMode)
      End;
  1: If GetCurPos(pMODPlayer)>=270 Then
      Begin
       Inc(iDemoMode);
       Caption:=sTitle;
       bmMain.Canvas.Draw(0,0,bmTemp1);
       ReadBitmap24(bmTemp3,'BMLOGO2M');       
       ReadBitmap24(bmTemp2,'BMLOGO2');
       DrawBitmap24(133,80,bmTemp2,bmTemp3,bmMain);
       iFadeStep:=84;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  2: If GetCurPos(pMODPlayer)>=336 Then
      Begin
       Inc(iDemoMode);
       With bmBack do
        Begin
         Canvas.FillRect(Rect(0,0,Width,Height));
         Canvas.Draw(133,80,bmImage)
        End;
       iFadeStep:=8;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  3: If NOT tmFade.Enabled Then // Show Menu
      Begin
       MusicIt;      
       Inc(iDemoMode);
       With bmMain do
        Begin
         Canvas.FillRect(Rect(0,0,bmMain.Width,bmMain.Height));
         Canvas.Draw((225-bmImage.Width) div 2 +3,
                     (125-bmImage.Height) div 2,bmImage);
         bmImage.Handle:=LoadBitmap(hInstance,'BMLOGO4');
         Canvas.Draw(15,140,bmImage)
        End;
       iFadeStep:=40;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  4: If NOT tmFade.Enabled Then
      Begin
       Inc(iDemoMode);
       With bmBack do
        Begin
         Canvas.Draw(0,0,bmMain);
         bmImage.Handle:=LoadBitMap(hInstance,'BMBMENU');
         Canvas.Draw(225,0,bmImage)
        End;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  5: If NOT tmFade.Enabled Then
      Begin
       Inc(iDemoMode);
       With bmMain do
        Begin
         Canvas.Draw(0,0,bmBack);
         bmImage.Handle:=LoadBitMap(hInstance,'BMMMENU');
         Canvas.Draw(260,30,bmImage)
        End;
       iFadeStep:=40;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  6: If NOT tmFade.Enabled Then
      Begin
       Inc(iDemoMode);
       bmBack.Canvas.Draw(0,0,bmMain);
       iNMenu:=1;
       DrawMenu(bmBack);
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  7: If NOT tmFade.Enabled Then
      Begin
       Inc(iDemoMode);
       bmMain.Canvas.Draw(0,0,bmBack);
       bmImage.Handle:=LoadBitmap(hInstance,'BMLOGO42');
       bmMain.Canvas.Draw(40,200,bmImage);
       DrawCursor;
       fFade:=NOT fFade;
       tmFade.Enabled:=true
      End;
  8: If NOT tmFade.Enabled Then
      Begin
       iDemoMode:=dmDelay;
       fMenu:=true
      End;
  9: Begin End; // Delay
  10: If NOT tmFade.Enabled Then // Start Game
       Begin
        StopIt(pMODPlayer);
        If fMM Then
         Begin
          dxSound.Initialize;
          wbBegin:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbBegin.LoadFromWave(wBegin.Wave);
          wbDead:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbDead.LoadFromWave(wDead.Wave);
          wbShot:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbShot.LoadFromWave(wShot.Wave);
          wbSmash:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbSmash.LoadFromWave(wSmash.Wave);
          wbPoint:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbPoint.LoadFromWave(wPoint.Wave);
          wbHumm:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbHumm.LoadFromWave(wHumm.Wave);
          wbHaha:=TDirectSoundBuffer.Create(dxSound.DSound);
          wbHaha.LoadFromWave(wHaha.Wave)
         End;
        Inc(iDemoMode);
        If NOT fBattle Then
         Begin
          fPlayer2:=Random(2)=1;
          InitCyberBrain
         End;
        fBattleOver:=false;
        DrawField;
        iFadeStep:=40;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  11: If NOT tmFade.Enabled Then
       Begin
        iDemoMode:=dmDelay;
        fBattle:=true;
        fPause:=false;
        Sound(wbBegin);
        tmCyberBrain.Interval:=iGameSpeed*110;
        tmCyberBrain.Enabled:=true
       End;
  12: If NOT tmFade.Enabled Then // New Game
       Begin
        Inc(iDemoMode);
        bmImage.Handle:=LoadBitmap(hInstance,'BMBMENU');
        With bmBack, Canvas do
         Begin
          FillRect(Rect(0,0,Width,Height));
          Draw(225,0,bmImage);
          bmImage.Handle:=LoadBitmap(hInstance,'BMSMMENU');
          Draw(290,30,bmImage)
         End;
        iNMenu:=2;
        DrawMenu(bmBack);
        iFadeStep:=40;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  13: If NOT tmFade.Enabled Then
       Begin
        Inc(iDemoMode);
        With bmMain, Canvas do
         Begin
          Draw(0,0,bmBack);
          bmImage.Handle:=LoadBitmap(hInstance,'BMSCORE');
          Draw(29,12,bmImage)
         End;
        DrawDigits(88,13,bmMain,iBattles); 
        DrawDigits(175,13,bmMain,bWins1);
        DrawDigits(192,13,bmMain,bWins2);
        DrawNet(cNetX,cNetY,bmMain,true);
        DrawItems(cNetX,cNetY,mField1,bmMain);
        DrawCursor;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  14: If NOT tmFade.Enabled Then
       Begin
        iDemoMode:=dmDelay;
        fMenu:=true
       End;
  15: If NOT tmFade.Enabled Then // Fade bmBack (to bmMain)
       Begin
        iFadeStep:=16;
        Inc(iDemoMode);
        If fGame Then
         If fGameOver then
          iDemoMode:=dmGameOver
         Else
          Begin
           iDemoMode:=dmNewGame;
           iFadeStep:=40
          End;
        bmMain.Canvas.FillRect(Rect(0,0,ClientWidth,ClientHeight));
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  16: If NOT tmFade.Enabled Then ToggleMenu;       
  17: If NOT tmFade.Enabled Then // Game Over
       Begin
        iDemoMode:=dmDelay;
        SetBkMode(bmBack.Canvas.Handle,TRANSPARENT);        
        With bmBack, Canvas do
         Begin
          bmImage.Handle:=LoadBitmap(hInstance,'BMGOVER');
          Draw(0,0,bmImage);
          i:=Font.Size;
          Font.Size:=cFontSize;
          Font.Style:=[];
          s:='Battles in war - '+IntToStr(iBattles)+'     Score - '+
             IntToStr(bWins1)+':'+IntToStr(bWins2);
          TextOut((Width-TextWidth(s)) div 2,
                  Height div 2,s);
          If fPlayer2 Then s:=sPlayer2 Else s:=sPlayer1;
          s:='Winner - '+s;
          TextOut((Width-TextWidth(s)) div 2,
                  (Height div 2)+(((Height div 2)-TextHeight(s)) div 2),s);
          Font.Style:=[fsBold];
          Font.Size:=i
         End;
        fGame:=false;
        fBattleOver:=false;
        iFadeStep:=16;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  18: If NOT tmFade.Enabled Then // Options
       Begin
        Inc(iDemoMode);
        bmImage.Handle:=LoadBitmap(hInstance,'BMBMENU');
        With bmBack, Canvas do
         Begin
          FillRect(Rect(0,0,Width,Height));
          Draw(225,0,bmImage);
          bmImage.Handle:=LoadBitmap(hInstance,'BMOMMENU');
          Draw(240,30,bmImage)
         End;
        iNMenu:=3;
        DrawMenu(bmBack);
        iFadeStep:=40;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  19: If NOT tmFade.Enabled Then
       Begin
        Inc(iDemoMode);
        bmMain.Canvas.Draw(0,0,bmBack);
        DrawOptions;
        DrawCursor;
        fFade:=NOT fFade;
        tmFade.Enabled:=true
       End;
  20: If NOT tmFade.Enabled Then
       Begin
        iDemoMode:=dmDelay;
        iSMaxScore:=iMaxScore;
        iSGameSpeed:=iGameSpeed;
        fSMusic:=fMusic;
        fSSound:=fSound;
        fSDrawPoints:=fDrawPoints;
        fMenu:=true
       End;
  21: If NOT tmFade.Enabled Then // Fade bmMain (to bmBack)
       Begin
        iFadeStep:=40;
        iDemoMode:=dmShowMainMenu;
        bmBack.Canvas.FillRect(Rect(0,0,ClientWidth,ClientHeight));
        fFade:=true;
        iFade:=255;
        tmFade.Enabled:=true
       End;
  22: Begin // Your Name
       Inc(iDemoMode);
       iFadeStep:=48;
       bmBack.Canvas.Draw(0,0,bmMain);
       bmImage.Handle:=LoadBitmap(hInstance,'BMNAME');
       With bmMain, Canvas do
        Begin
         i:=(Width-bmImage.Width) div 2;
         j:=(Height-bmImage.Height) div 2;
         DropShadow24(i+6,j+6,bmImage.Width,bmImage.Height,bmMain,150);
         Draw(i,j,bmImage);
         edName.Left:=i+9;
         edName.Top:=j+36;
         fFont:=Font;
         bmMain.Canvas.Font:=edName.Font;
         TextOut(edName.Left,edName.Top,sPlayer1);
         Font:=fFont
        End;
       fFade:=false;
       iFade:=0;
       tmFade.Enabled:=true
      End;
  23: If NOT tmFade.Enabled Then
       Begin
        Inc(iDemoMode);
        fName:=true;
        edName.Text:=sPlayer1;
        edName.Visible:=true;
        edName.SetFocus
       End;
  24: If NOT fName Then iDemoMode:=dmNewGame
 End
end;

procedure TfmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
 var
  i:integer; 
begin
 If fCloseEnabled Then Exit;
 i:=iMenu;
 If fMenu then
  If PtInRect(Rect(cMenuX,cMenuY,450,cMenuY+iMenuItems*29),Point(X,Y)) Then
   Begin
    iMenu:=(Y-cMenuY) div 29;
    If i<>iMenu Then RedrawMenu;
    Cursor:=2
   End
  Else
   If ((iNMenu=3) AND (PtInRect(Rect(26,40,42,56),Point(X,Y)) OR
                       PtInRect(Rect(26,59,42,75),Point(X,Y)) OR
                       PtInRect(Rect(26,115,42,132),Point(X,Y)) OR
                       PtInRect(Rect(26,192,56,208),Point(X,Y)) OR
                       PtInRect(Rect(26,211,56,227),Point(X,Y)))) OR
      ((iNMenu=1) AND (PtInRect(Rect(40,200,190,212),Point(X,Y)) OR
                       PtInRect(Rect(58,214,172,224),Point(X,Y))))
   Then
    Cursor:=2                   
   Else
    Cursor:=3
 Else
  If fBattle and NOT fPause Then
   If PtInRect(Rect(bmBack.Width-cNet*cNetDim-cNetX,cNetY,
                    bmBack.Width-cNetX,cNetY+cNet*cNetDim),Point(X,Y))
   Then
    Cursor:=1
   Else
    Cursor:=3
  Else
   Cursor:=3
end;

procedure TfmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 var
  bMax:byte;
  s:string;
  c:char;
begin
 If fCloseEnabled Then Halt;
 If tmFade.Enabled Then If iDemoMode>dmShowMainMenu-1 Then Exit;
 If mbRight=Button Then Begin EscDown; Exit End; 
 If fName then
  Begin
   c:=#13;
   edNameKeyPress(Sender,c);
   Exit
  End;
 If mbLeft=Button Then
  If fMenu Then
   If PtInRect(Rect(cMenuX,cMenuY,450,cMenuY+iMenuItems*29),Point(X,Y)) Then
    ActivateMenu
   Else
    Case iNMenu Of
     3: Begin
         s:='Sound effects and music disabled';
         If PtInRect(Rect(26,40,42,56),Point(X,Y)) Then
          If NOT fMM Then
           MessageBox(Handle,PChar(s),'Sea Wars - Music',mb_IconError)
          Else
           Begin
            fMusic:=NOT fMusic;
            MusicIt
           End;
         If PtInRect(Rect(26,59,42,75),Point(X,Y)) Then
          If fMM Then
           fSound:=NOT fSound
          Else
           MessageBox(Handle,PChar(s),'Sea Wars - Sound effects',mb_IconError);
         If PtInRect(Rect(26,115,42,132),Point(X,Y)) Then fDrawPoints:=NOT fDrawPoints;
         If PtInRect(Rect(26,192,41,208),Point(X,Y)) Then Dec(iMaxScore);
         If PtInRect(Rect(42,192,56,208),Point(X,Y)) Then Inc(iMaxScore);
         If PtInRect(Rect(26,211,41,227),Point(X,Y)) Then Dec(iGameSpeed);
         If PtInRect(Rect(42,211,56,227),Point(X,Y)) Then Inc(iGameSpeed);
         bMax:=0;
         If fGame Then
          If bWins1>bWins2 Then
           bMax:=bWins1
          Else
           bMax:=bWins2;
         If iMaxScore=bMax Then iMaxScore:=bMax+1;
         If iMaxScore=10 Then iMaxScore:=9;
         If iGameSpeed=0 Then iGameSpeed:=1;
         If iGameSpeed=10 Then iGameSpeed:=9;
         DrawOptions;
         FormPaint(Self)
        End;
     1: Begin
         If PtInRect(Rect(40,200,190,212),Point(X,Y)) Then
          ShellExecute(0,'open',PChar('http://imc.perm.ru/dumbs'),nil,nil,sw_Show);
         If PtInRect(Rect(58,214,172,224),Point(X,Y)) Then
          ShellExecute(0,'open',PChar('mailto:dumbs@perm.raid.ru?Subject=About Sea Wars!'),nil,nil,sw_Show)
        End
    End       
  Else
   If fBattle and NOT fPause Then
    If fPlayer2 Then
     Sound(wbHumm)
    Else
     If PtInRect(Rect(bmBack.Width-cNet*cNetDim-cNetX,cNetY,
                      bmBack.Width-cNetX,cNetY+cNet*cNetDim),Point(X,Y)) Then
      ActivateShot(mField2,((x-(bmBack.Width-cNet*cNetDim-cNetX)) div cNet)+1,
                           ((y-cNetY) div cNet)+1,0)
     Else
      Begin

      End                      
   Else
    If fBattleOver Then
     Begin
      PlayMusic;
      iDemoMode:=dmFadeBack
     End
    Else
     If fGameOver Then iDemoMode:=dmFadeBack
end;

procedure TfmMain.tmCyberBrainTimer(Sender: TObject);
 var
  bx,by,bi,bj1,bj2:byte;
 procedure ErasePoint(bIndex:byte);
  begin
   Dec(iPointsCount);
   aPoints[bIndex]:=aPoints[iPointsCount];
   aPoints[iPointsCount]:=Point(0,0)
  end;
begin
 If NOT fPlayer2 Then Exit;
 bi:=0;
 If NOT fKill then
  Repeat
   bx:=Random(cNetDim)+1;
   by:=Random(cNetDim)+1
  Until mField1.faOut[bx,by]<5
 Else
  Begin
   bi:=Random(iPointsCount);
   bx:=aPoints[bi].x;
   by:=aPoints[bi].y
  End;
 Case ActivateShot(mField1,bx,by,cUnvisiblePoint) of
  0: If fKill Then ErasePoint(bi);
  1: If fKill Then
      If pOld.x=bx Then
       Begin
        If by>pOld.y Then
         If TestPointEx(bx,by+1,mField1) Then
          Inc(aPoints[bi].y)
         Else
          ErasePoint(bi)
        Else
         If TestPointEx(bx,by-1,mField1) Then
          Dec(aPoints[bi].y)
         Else
          ErasePoint(bi);
        For bj1:=0 to 3 do For bj2:=0 to iPointsCount-1 do
         If aPoints[bj2].x<>pOld.x Then Begin ErasePoint(bj2); Break End
       End
      Else
       Begin
        If bx>pOld.x Then
         If TestPointEx(bx+1,by,mField1) Then
          Inc(aPoints[bi].x)
         Else
          ErasePoint(bi)
        Else
         If TestPointEx(bx-1,by,mField1) Then
          Dec(aPoints[bi].x)
         Else
          ErasePoint(bi);
        For bj1:=0 to 3 do For bj2:=0 to iPointsCount-1 do
         If aPoints[bj2].y<>pOld.y Then Begin ErasePoint(bj2); Break End
        End
     Else
      Begin
       fKill:=true;
       If TestPointEx(bx-1,by,mField1) Then
        Begin
         aPoints[iPointsCount]:=Point(bx-1,by);
         Inc(iPointsCount)
        End;
       If TestPointEx(bx,by-1,mField1) Then
        Begin
         aPoints[iPointsCount]:=Point(bx,by-1);
         Inc(iPointsCount)
        End;
       If TestPointEx(bx+1,by,mField1) Then
        Begin
         aPoints[iPointsCount]:=Point(bx+1,by);
         Inc(iPointsCount)
        End;
       If TestPointEx(bx,by+1,mField1) Then
        Begin
         aPoints[iPointsCount]:=Point(bx,by+1);
         Inc(iPointsCount)
        End;
       pOld:=Point(bx,by)
      End;
  2: InitCyberBrain
 End
end;

procedure TfmMain.InitCyberBrain;
begin
 ZeroMemory(@aPoints,SizeOf(aPoints));
 ZeroMemory(@pOld,SizeOf(pOld));
 fKill:=false;
 iPointsCount:=0
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
 var
  f:file;
begin
 If fCloseEnabled Then Halt;
 If fGame Then
  CanClose:=MessageBox(Handle,'Game not finished. Are You sure?',
                       'Sea Wars - Quit',mb_IconExclamation+mb_YesNo)=IDYES
 Else
  CanClose:=true;
 If CanClose Then
  Begin
   Caption:='Shutting down...';
   bmImage.Handle:=LoadBitmap(hInstance,'BMABOUT');
   iFade:=0;
   bmBack.Canvas.Draw(0,0,bmImage);
   FormPaint(Self);
   fCloseEnabled:=true;
   tmDirection.Enabled:=false;
   tmFade.Enabled:=false;
   edName.Visible:=false;
   CanClose:=false;
   DestroyIt(pMODPlayer);
   Cursor:=crDefault;   
   AssignFile(f,sStartPath+'\SeaWars.cfg');
   Try
    Rewrite(f,1);
    BlockWrite(f,fMusic,1);
    BlockWrite(f,fSound,1);
    BlockWrite(f,fDrawPoints,1);
    BlockWrite(f,iMaxScore,4);
    BlockWrite(f,iGameSpeed,4);
    BlockWrite(f,sPlayer1[1],Length(sPlayer1));
    CloseFile(f);
   Except

   End
  End
end;

procedure TfmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
 If fBattle Then
  If Key=#8 Then
   sCheatCode:=''
  Else
   If Key>#32 Then
    Begin
     sCheatCode:=sCheatCode+UpCase(Key);
     If sCheatCode='BATTLEMASTER' Then
      Begin
       sCheatCode:='';
       mField2.fPrimary:=true;
       DrawField;
       FormPaint(Self);
       Sound(wbHaha)
      End
    End
end;

procedure TfmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key=32 Then mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0)
end;

procedure TfmMain.edNameKeyPress(Sender: TObject; var Key: Char);
begin
 If Key<>#13 Then Exit;
 fName:=false;
 sPlayer1:=edName.Text;
 bmMain.Canvas.FillRect(Rect(edName.Left,edName.Top,
                        edName.Left+edName.Width,edName.Top+edName.Height));
 edName.Visible:=false
end;

end.
