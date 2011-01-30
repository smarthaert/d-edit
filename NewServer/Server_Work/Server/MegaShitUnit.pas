unit MegaShitUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Base;

type
  TForm1 = class(TForm)
    LB: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Type
  CrazyTokenizer = Class
   Private
    T : TextFile;
   Public
    Constructor OpenFile( FileName : String );
    Function NextToken( LowChar : Char ): String;
    Function ReadString : String;
    Function ReadInt : Integer;
    Destructor Close;
  End;

procedure TForm1.FormCreate(Sender: TObject);
var CT : CrazyTokenizer;
begin
  CT := CrazyTokenizer.Create;
  CT.OpenFile('Test_Server.cfg');
  LB.Items.Add(CT.NextToken(#33));
  LB.Items.Add(CT.NextToken('='));
  LB.Items.Add(CT.ReadString);
  LB.Items.Add(CT.NextToken('='));
  LB.Items.Add(CT.ReadString);
  LB.Items.Add(CT.NextToken('='));
  LB.Items.Add(CT.ReadString);
  CT.Close;
end;

{ CrazyTokenizer }

constructor CrazyTokenizer.OpenFile(FileName: String);
begin
  if not FileExists(FileName) then ShowMessage('ShIT!');
  AssignFile(T,FileName);
  Reset(T);
end;

destructor CrazyTokenizer.Close;
begin
  CloseFile(T);
end;

function CrazyTokenizer.NextToken( LowChar : Char ): String;
var Ch : Char;
  isString : Boolean;
begin
  while not eof(T) do begin
    Read(T,Ch);
    if Ord(Ch)>=ord(LowChar) then break;
  end;
  {}
  Result := Ch;
  while not eof(T) do begin
    Read(T,Ch);
    if Ord(Ch)<=ord(LowChar) then
      break
    else
      Result := Result + Ch;
  end;
end;

function CrazyTokenizer.ReadInt: Integer;
begin
  // Example: Length=300;
  NextToken('='); // Read "="
  Result := StrToInt(NextToken('0'));
  NextToken(';'); // Read ";"
end;

function CrazyTokenizer.ReadString: String;
var Ch : Char;
begin
  // Example: pas="dcc32.exe ";
  Repeat
    Read(T,Ch);
  Until Ch = '"';
  Repeat
    Read(T,Ch);
    if Ch<>'"' then
      Result := Result + Ch;
  Until Ch = '"';
end;

end.
