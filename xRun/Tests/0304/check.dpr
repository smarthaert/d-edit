{ �������� ������� - Task 0304 }

{$I trans.inc}
Uses TestLib, SysUtils, Task0304;

Var
  User,Jury : String;
  N : Integer;
  A : Array of LongInt;

function test : String;
var i : Integer;
begin
  Result := '����:'#13#10;
  Result := Result + IntToStr(N) + #13#10;
  for i:=0 to N-1 do 
    Result := Result + IntToStr(A[i]) + #13#10;
  Result := Result + '���������� �����: "'+Jury+'"'#13#10;
end;

var i : Integer;
Begin
  { ������ ������� ������ }
  N := inf.ReadInteger;
  SetLength(A,N);
  for i:=0 to N-1 do 
    A[i] := inf.ReadInteger; 
  {}
  User := ouf.ReadString;
  Jury := ans.ReadString;
  If not isCorrect(User) then 
    Quit(_WA,'���� ��������� ���������� ��������� ������������������ '+
      '� ������� ������� ������ ������: "'+User+'"'#13#10+
       test);

  If User<>Jury then Quit(_WA,'�������� ��������� ������������������:');

  Quit(_OK,'�� �����!');
End.
