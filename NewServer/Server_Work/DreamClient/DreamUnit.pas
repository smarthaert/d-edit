unit DreamUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, StdCtrls, Buttons, Mask, ToolEdit, Monitor_Xml,
  ExtCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, User_xml, RXCtrls, RXSpin, Arhive_Xml;

type
  TF = class(TForm)
    PageControl1: TPageControl;
    MonitorTS: TTabSheet;
    MessagesTS: TTabSheet;
    ChooseProblem: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    SubmitButton: TButton;
    SubmitTS: TTabSheet;
    Label4: TLabel;
    Label3: TLabel;
    ChooseLanguage: TComboBox;
    MonitorDG: TDrawGrid;
    OptionsTS: TTabSheet;
    Edit1: TEdit;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    SourcePath: TFilenameEdit;
    XMLDocument1: TXMLDocument;
    Timer: TTimer;
    CellHeight: TRxSpinEdit;
    CellHeightLabel: TRxLabel;
    AArhive: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure SubmitButtonClick(Sender: TObject);
    procedure MonitorDGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SourcePathChange(Sender: TObject);
    procedure ChooseLanguageChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CellHeightChange(Sender: TObject);
    procedure AArhiveDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AArhiveRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure AArhiveSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    FontScale : Extended;
    { Public declarations }
  end;
Type
  TSendMessage = Function (Path, _Message : String): Boolean; StdCall;
  TAcceptMessage = Function (User_ID : Integer) : String; StdCall;


var
  F: TF;
  UserMonitor : IXMLMONITORType;
  UserConfig : IXMLConfigType;
  UserArhive : IXMLArhiveType;
  Len_User, Len_Message : Longint;
  LibHandle   : THandle;
  SendUserMessage : TSendMessage;
  AcceptMessage : TAcceptMessage;

implementation

uses MessageUnit;

{$R *.dfm}

procedure TF.FormCreate(Sender: TObject);
Var i : Longint;
begin
  LibHandle := LoadLibrary(PChar('Dir.dll'));
  @SendUserMessage := GetProcAddress(LibHandle, 'SendMessage');
  @AcceptMessage := GetProcAddress(LibHandle, 'AcceptMessage');
  If (@AcceptMessage = nil) or (@SendMessage = nil) then
    Begin
      ShowMessage('Can''t load "Dir.dll"');
      Exit;
    End;

  // Грузим конфиги
  UserConfig  := LoadConfig('User.xml');
  UserMonitor := LoadMonitor('monitor.xml');
  UserArhive  := LoadArhive('Arhive.xml');
  // Загрузили конфиги

  F.ChooseLanguage.Clear;
  For i:=0 to UserConfig.Compilers.Count-1 do
    F.ChooseLanguage.AddItem(UserConfig.Compilers.Compilator[i].Name,nil);

  F.ChooseProblem.Clear;
  For i:=0 to UserConfig.Problems.Count-1 do
     F.ChooseProblem.AddItem(UserConfig.Problems.Problem[i].Litera+'. '+
                             UserConfig.Problems.Problem[i].Name,nil);

  MonitorDg.ColCount := UserMonitor.PROBLEMS.Count+4;
  MonitorDg.RowCount := UserMonitor.USERS.Count+1;
  AArhive.RowCount := UserArhive.Messages.Count+1;
  AArhive.ColCount := 4;

  SubmitButton.Enabled := False;
  SourcePath.Enabled :=False;
  CellHeightChange(Self);

end;

procedure TF.SubmitButtonClick(Sender: TObject);
Var   _Submit : TStrings;
      My_Id : Longint;
begin
  { Проверка на наличие файла }
  If not FileExists(F.SourcePath.Text) then
    Begin
      MessageDlg('File "'+F.SourcePath.Text+'" not found!',
        mtConfirmation, [mbOK], 0);
      Exit;
    End;
  My_ID:= 1;
  If MessageDlg('Are you want submit your solution for "'+
      F.ChooseProblem.Text + '" ?',
       mtConfirmation, [mbYes, mbNo{, mbIgnore, mbRetry}], 0) = mrYes Then
    Begin
      _Submit:= TStringList.Create;
      _Submit.LoadFromFile(F.SourcePath.Text);
      _Submit.Add(IntToStr(ChooseProblem.ItemIndex+1));
      _Submit.Add(ChooseLanguage.Text);
      _Submit.Add(ExtractFileExt(SourcePath.Text));
       SendUserMessage(UserConfig.Paths.Queue, _Submit.Text);
      _Submit.Free;
    End;
end;

procedure TF.MonitorDGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
// var Center:Boolean;
var S : String;
begin
// TDrawGrid
  If (ARow = 0) And (ACol=0) then Len_User:=0;
  IF (ARow = 1) then
           MonitorDg.ColWidths[0] := Monitordg.Width - Len_User-25;
  if ARow = 0 then begin
    MonitorDg.Canvas.Font.Name := 'Arial';
    MonitorDg.FixedColor:= $00991E17;
    MonitorDg.Canvas.Font.Style := [fsBold];
    MonitorDg.Canvas.Font.Size := Round(20*FontScale);
    MonitorDg.Canvas.Font.Color := clWhite;
    S := '';
    if ACol = UserMonitor.PROBLEMS.Count+1 then S:='Solved';
    if ACol = UserMonitor.PROBLEMS.Count+2 then S:='Time';
    if ACol = UserMonitor.PROBLEMS.Count+3 then S:='Rank';
    if S<>'' then
      Begin
        MonitorDg.ColWidths[ACol] := MonitorDg.Canvas.TextWidth(S)-Round(20*FontScale);
        Len_User := Len_User + MonitorDg.ColWidths[ACol];
      End;

    if ((ACol>=1) and (ACol<=UserMonitor.PROBLEMS.Count)) then begin
      S := UserMonitor.PROBLEMS.Problem[ACol-1].Litera;
      MonitorDg.ColWidths[ACol] := 32;
      Len_User := Len_User + MonitorDg.ColWidths[ACol];
    end;
  end else begin
    if ACol = 0 then begin { Это UserName }
      if ((ARow>0) and (ARow <= UserMonitor.USERS.Count)) then begin
        MonitorDg.Font.Name := 'Tahoma';
        MonitorDg.Canvas.Brush.Color := clWhite;
//        MonitorDg.Canvas.Font.Style := [fsBold];
        MonitorDg.Canvas.Font.Size := Round(10*FontScale);
        MonitorDg.Canvas.Font.Color := clBlack;
        S := UserMonitor.USERS.USER[ARow-1].Data.U_Name;
      end;
    end;
  end;
  MonitorDg.Canvas.Font.Size := Round(10*FontScale);
  { Рисуем "плюсики" и "минусики" }
  If (ARow > 0) And (ACol > 0) And (ACol <= UserMonitor.PROBLEMS.Count) then begin
    S:= UserMonitor.USERS.USER[ARow-1].Submits.Submit[ACol-1].NUM_Submits;
    MonitorDg.Canvas.Font.Style := [fsBold];
    if S[1]='+' then
      MonitorDg.Canvas.Font.Color := clGreen
    else begin{ if S[1]='-' and others }
      if S='-' then
        MonitorDg.Canvas.Font.Color := clBlack
      else
        MonitorDg.Canvas.Font.Color := clRed;
    end;
  end;

  If (ARow > 0) And (ACol = UserMonitor.PROBLEMS.Count+1)  then
      S:= IntToStr(UserMonitor.USERS.USER[ARow-1].Data.Solved);
  If (ARow > 0) And (ACol = UserMonitor.PROBLEMS.Count+2)  then
      S:= IntToStr(UserMonitor.USERS.USER[ARow-1].Data.Time);
  If (ARow > 0) And (ACol = UserMonitor.PROBLEMS.Count+3)  then
      S:= IntToStr(UserMonitor.USERS.USER[ARow-1].Data.Rank);
  {}
  MonitorDg.Canvas.TextOut(
    (Rect.Left + Rect.Right  - MonitorDg.Canvas.TextWidth(S)) div 2,
    (Rect.Top  + Rect.Bottom + MonitorDg.Canvas.Font.Height) div 2, S );
end;

procedure TF.SourcePathChange(Sender: TObject);
begin
  SubmitButton.Enabled := FileExists(SourcePath.FileName);
end;

procedure TF.ChooseLanguageChange(Sender: TObject);
Var i: Longint;
begin
  For i:=0 to UserConfig.Compilers.Count -1 do
     If ChooseLanguage.Text = UserConfig.Compilers.Compilator[i].Name then SourcePath.Filter:= UserConfig.Compilers.Compilator[i].Name + ' ('+
                              UserConfig.Compilers.Compilator[i].Mask+')|'+UserConfig.Compilers.Compilator[i].Mask;
  SourcePath.Enabled:=True;
end;

procedure TF.FormResize(Sender: TObject);
begin
  MonitorDG.Repaint;
  AArhive.Repaint;
end;

procedure TF.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 1 then MonitorDg.SetFocus;
end;

procedure TF.CellHeightChange(Sender: TObject);
begin
  if CellHeight.Text <> '' then begin
    MonitorDG.DefaultRowHeight := Round(CellHeight.Value);
    AArhive.DefaultRowHeight := Round(CellHeight.Value);
    FontScale := CellHeight.Value / 18;
  end;
end;

procedure TF.AArhiveDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Var S_A: String;
begin
  If (ARow = 0) And (ACol=0) then Len_Message:=0;
  If ARow=1 then AArhive.ColWidths[2] := AArhive.Width - Len_Message -20;

  If ARow = 0 Then
    Begin
       AArhive.FixedColor:= $00991E17;
       AArhive.Canvas.Font.Name := 'Arial';
       AArhive.Canvas.Font.Style := [fsBold];
       AArhive.Canvas.Font.Size := Round(12*FontScale);
       AArhive.Canvas.Font.Color := clWhite;
       S_A := '';
       if ACol = 0 then S_A:=' № ';
       if ACol = 1 then S_A:='   Problem Name   ';
       if ACol = 2 then S_A:='Message';
       if ACol = 3 then S_A:='  Time  ';
       if S_A<>'' then
          Begin
               IF ACol<>2 then AArhive.ColWidths[ACol] := AArhive.Canvas.TextWidth(S_A);
               If ACol<>2 then Len_Message := Len_Message + AArhive.ColWidths[ACol];
          End;
    End;
  If ARow > 0 then
    Begin
        AArhive.Canvas.Font.Name := 'Tahoma';
        AArhive.Canvas.Brush.Color := clWhite;
        AArhive.Canvas.Font.Style := [fsBold];
        AArhive.Canvas.Font.Size := Round(10*FontScale);
        AArhive.Canvas.Font.Color := clBlack;
        if (ACol = 0) And (ARow>=1) and (ARow <= UserArhive.Messages.Count) then
                 S_A := UserArhive.Messages._Message[ARow-1].Litera+'.'+
                      IntToStr(UserArhive.Messages._Message[ARow-1].Num);
        Case ACol of
          1 : S_A:= UserArhive.Messages._Message[Arow-1].Name;
          2 : S_A:= UserArhive.Messages._Message[Arow-1].Answer;
          3 : S_A:= IntToStr(UserArhive.Messages._Message[Arow-1].Time);
        End;
    End;
  AArhive.Canvas.Font.Size := Round(10*FontScale);
  AArhive.Canvas.TextOut(
    (Rect.Left + Rect.Right  - AArhive.Canvas.TextWidth(S_A)) div 2,
    (Rect.Top  + Rect.Bottom + AArhive.Canvas.Font.Height) div 2, S_A);
end;

procedure TF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeLibrary(LibHandle);
end;

procedure TF.AArhiveRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
begin
 //sdjhkhs
end;

procedure TF.TimerTimer(Sender: TObject);
Var M : IXMLMessageType;
    F : TextFile;
    S, _MM, S2, S3, S4 : String;
    Ch : Char;
    Us_ID, Pr_ID, I, J, BasePr_Num, BaseUs_Num : Longint;
    Fl : Boolean;
begin
   If FileExists(UserConfig.Paths.Queue+'\Answer.msg') then
      Begin
        M := UserArhive.Messages.Add;
        AssignFile(F,UserConfig.Paths.Queue+'\Answer.msg');
        Reset(F);
        { ?????????? ????????????: }
        Readln(F,S);
        { User_Name : Pavlik }
        Readln(F,S);
        { User_ID : 1 }
        Repeat Read(F,Ch); Until Ch=':';
        Readln(F,Us_ID);
        { Problem Name : A+B Problem }
        Readln(F,S);
        { Problem ID : 1 }
        Repeat Read(F,Ch); Until Ch=':';
        Readln(F,Pr_ID);
        { ????? ??????? : Accepted }
        Repeat Read(F,Ch); Until Ch=':'; Read(F,Ch);
        Readln(F,_MM);
        CloseFile(F);
        {}
        BasePr_Num := -1;
        For i:=0 to UserConfig.Problems.Count-1 do
          If UserConfig.Problems.Problem[i].ID = Pr_ID then begin
            BasePr_Num := i;
            break;
          end;
        if BasePr_Num=-1 then ShowMessage('Не нашел проблему!');
        M.Litera:= UserConfig.Problems.Problem[Basepr_Num].Litera;
        M.Name:= UserConfig.Problems.Problem[Basepr_Num].Name;
        M.Time := 0;
        M.Answer := _MM;
        M.Num :=4;
        {}
        AssignFile(F,'Arhive.xml'); Rewrite(F);
//        ShowMessage(UserArhive.XML);
//        UserArhive.Messages.Count-1 - Последняя только что добавленная мессага
//m     Выодим форматируемйй XML т.к. эта собака сама его не форматирует
        S:= UserArhive.Messages._Message[UserArhive.Messages.Count-1].XML;
        S2 := '';
        Fl:=True;
        For i:=1 to Length(S) do
          Begin
            If S[i] ='/' then fl := True;
            If (S[i]='>') And not Fl then S2 := S2 + S[i];
            If S[i]= '>' then
              Begin
                 If ((S[i-1] ='e') or (S[i-1] ='a') or (S[i-1] ='r')) And Fl then
                    Begin
                                S2 := S2 + S[i] + #$D#$A#9#9#9;
                                fl:=False;
                    End;
                 If (S[i-1]='m') And Fl then
                   Begin
                      S2 := S2 + S[i] + #$D#$A#9#9;
                      Fl:=False;
                   End;
              End Else
            S2 := S2 + S[i];  // StrPos
          End;
        SetLength(S2,Length(S2)-5);
        WriteLn(F,'<Arhive>'+#$D#$A#9+'<Messages>');
        For i:=0 to UserArhive.Messages.Count-2 do
          Begin
            S4:='';
            S3 := UserArhive.Messages._Message[i].XML;
            For j:=1 To Length(S3) do
                 If S3[j]=#$A then
                    If S3[j+1] =#9 then
                      Begin
                         S4:=S4+#$A#9#9;
                      End
                    else
                      Begin
                         S4 := S4 + #$A#9#9;
                      End
                 Else S4 := S4 + S3[j];
            Writeln(F, #9#9 + S4);
          End;
        Write(F,#9#9 + S2);
        Writeln(F,#$D#$A#9 + '</Messages>');
        Writeln(F,'</Arhive>');
        CloseFile(F);
        //Вывели
        //Удаляем Ансвер
        DeleteFile(UserConfig.Paths.Queue+'\Answer.msg');
        UserArhive := LoadArhive('Arhive.xml');
        Mf.Init(UserArhive.Messages.Count-1);
        MF.Showmodal;
      End;
end;

procedure TF.AArhiveSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  MF.Init(ARow-1);
  Mf.ShowModal;
end;

end.
