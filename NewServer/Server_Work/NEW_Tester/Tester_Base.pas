unit Tester_Base;

interface

Uses Tester_Xml, SysUtils, QDialogs;


implementation

Procedure TTester.LoadConfig(FileName: String);
Begin
  Config := NewTESTER;
  If Not FileExists(FileName) then ShowMessage('Отсутствует конфиг: '+FileName);
  Config := LoadTESTER(FileName);
End;

Function TTester.MakeMask(Problem_Id, Test_Num : Longint; Mask: String) : String;
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
      Number := Number + Mask[i];
      Inc(I);
    End;
  While StrToInt(Number)<>Test_Num do Plus(Number);
  FileName := FileName+Number;
  While Mask[i]<>']' do Inc(i);Inc(i);
  While i<>Length(Mask) do
    Begin
      FileName := FileName+ Mask[i];
      Inc(I);
    End;
End;

Procedure TTester.Plus(Var Num : string);
var Len : Integer;
Begin
  Len := Length(Num);
  Num := IntToStr(StrToInt(Num)+1);
  While Length(Num) < Len do
    Num := '0'+Num;
End;

end.
