unit TersterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, FmxUtils, Tester_Xml;

type
  TForm1 = class(TForm)
    XMLDocument1: TXMLDocument;
    Tetter_Kill: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Tetter_KillClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TTester = Class(TThread)
    Public
       Submit : Tstrings;
    Protected
      Procedure Execute; override;
  End;

Var
  Form1: TForm1;
  Config : IXMLTESTERType;
  Run_Res: TRunResult;
  Tester : TTester;

//----------------------------- Functions & procedures

Procedure LoadConfig(FileName : String);
Function MakeMask(Test_Num : Longint;Mask : String): String;
Procedure Plus(Var Num : string);
Procedure WriteAnswer(Result : Integer);
Procedure ClearQueue;

implementation
{$R *.dfm}



procedure TTester.Execute;
Var i : Longint;
   FileName_in, FileName_out, S : String;
   pr : Integer;
begin
                (*
                      1  - Problem ID
                      2  - Ќомер теста
                      C:\Pavlik\ETUClub\Testers\01\Queue\00000011.exe  - Path
                *)
If Not FileExists('tester.xml') then ShowMessage('ќтсутствует конфиг: '+FileName_In);
Submit:= TStringList.Create;
LoadConfig('E:\Server_Work\NEW_Tester\Tester.xml');
While True do Begin
  If Not FileExists(Config.PATHS.MAIN+'\Submit.msg') Then
    Begin
      Continue;
      SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
      Priority := tpIdle; // ставим относительный низкий приоритет
    End;
  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
  Priority := tpHighest; // ставим относительный высокий приоритет
  Submit.Clear;
  Submit.LoadFromFile(Config.PATHS.MAIN+'\Submit.msg');
  For i:=0 to Config.PROBLEMS.Count-1 do
    If Config.PROBLEMS.PROBLEM[i].ID = StrToInt(Submit.Strings[0]) then
      Begin
        Pr:=i;
        Break;
      End;
  FileName_in := MakeMask(StrToInt(Submit.Strings[1]),
                  Config.PROBLEMS.PROBLEM[i].TEST_IN);
  FileName_out := MakeMask(StrToInt(Submit.Strings[1]),
                  Config.PROBLEMS.PROBLEM[i].TEST_OUT);
  CopyFile(Config.PROBLEMS.PROBLEM[Pr].PATH+'\'+FileName_In,
           Config.PATHS.QUEUE+'\'+Config.PROBLEMS.PROBLEM[Pr].INPUT_FILE);
  Run_Res:=Run(Submit.Strings[2],Config.PATHS.QUEUE,'',
               IntToStr(Config.PROBLEMS.PROBLEM[pr].TIMELIMIT));
  If Run_Res._Answer=_OK then
    Begin
      {$I-}
      Run(Config.PROBLEMS.PROBLEM[pr].TESTER,'',
          Config.PROBLEMS.PROBLEM[pr].PATH+'\'+FileName_in+' '+
          Config.PATHS.QUEUE+'\'+Config.PROBLEMS.PROBLEM[pr].OUTPUT_FILE+' '+
          Config.PROBLEMS.PROBLEM[pr].PATH+'\'+FileName_out+ ' '+
          Config.PATHS.QUEUE+'\'+'Test_Ans.txt','10');
      {$I+}
      Submit.Clear;
      Submit.LoadFromFile(Config.PATHS.QUEUE+'\Test_Ans.txt');
      S:=Submit.Strings[0];
      i:=1;
      While not ((S[i]<='9') And (S[i]>='0')) do Inc(i);
      WriteAnswer(StrToInt(S[i]));
    End;
End;
  Submit.Free;
end;

{************************ Class TTester  ****************************}

Procedure LoadConfig(FileName: String);
Begin
End;

Function MakeMask(Test_Num : Longint; Mask: String) : String;
Var FileName, Number : String;
    I : Longint;
Begin
  i:=1;
  FileName:='';
  While Mask[i]<>'[' do
    Begin
      FileName := FileName+ Mask[i];
      Inc(I);
    End;
  Inc(i);
  Number:='';
  While Mask[i]<>'.' do
    Begin
      if (Mask[i]>='0')and (Mask[i]<='9') then Number := Number + Mask[i];
      Inc(I);
    End;
  While StrToInt(Number)<>Test_Num do Plus(Number);
  FileName := FileName+Number;
  While Mask[i]<>']' do Inc(i);
  Inc(i);
  While i<=Length(Mask) do
    Begin
      FileName := FileName+ Mask[i];
      Inc(I);
    End;
  Result:= FileName;
End;

Procedure Plus(Var Num : string);
var Len : Integer;
Begin
  Len := Length(Num);
  Num := IntToStr(StrToInt(Num)+1);
  While Length(Num) < Len do
    Num := '0'+Num;
End;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Config := NewTESTER;
  Config := LoadTESTER('tester.xml');
  Tester := TTester.Create(False);
end;

Procedure WriteAnswer(Result : Integer);
Var Sub, ME : TStrings;
Begin
  ME := TStringList.Create;
  ME.LoadFromFile(Config.PATHS.MAIN+'\Submit.msg');
  Sub := TStringList.Create;
  Sub.Add('Result, Problem_ID:'+Me.Strings[1]+' TestNum: '+ Me.Strings[1]);
  Sub.Add(Me.Strings[1]);
  Sub.Add(IntToStr(Result));
  Sub.SaveToFile(Config.PATHS.MAIN+'\Answer.msg');
  DeleteFile(Config.PATHS.MAIN+'\Submit.msg');
  Sub.Free;
  Me.Free;
  ClearQueue;
End;

Procedure ClearQueue;
Var  Name : TSearchRec;
Begin
 If FindFirst(Config.PATHS.QUEUE+'\*.*',$3F,Name) = 0 then
    begin
      repeat
        If Name.Name[1]<>'.' then DeleteFile(Config.PATHS.QUEUE+'\'+Name.Name);
      until FindNext(Name) <> 0;
      FindClose(Name);
    end;
End;
procedure TForm1.Tetter_KillClick(Sender: TObject);
begin
  If Tetter_Kill.Caption = 'Kill Tester' then
    Begin
      Tester.Suspend;
      Tetter_Kill.Caption:= 'Run Tester'
    End
  Else
    Begin
      Tester.Resume;
      Tetter_Kill.Caption:= 'Kill Tester'
    End;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tester.Suspend;
  Tester.Terminate;
end;

end.
