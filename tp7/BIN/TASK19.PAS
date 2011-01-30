uses CRT;

type
  TStudent = record
    Surname : string;
    BirthYear : integer;
  end;

procedure EnterStudent( var R : TStudent );
begin
  Write('Surname: '); Readln(R.Surname);
  Write('Birth year: '); Readln(R.BirthYear);
end;

procedure ShowStudent( S : TStudent; Row,Col : integer );
begin
  GotoXY(Col,Row);
  Writeln(S.Surname,' ',S.BirthYear);
end;

var
  A : TStudent;
  i : integer;
begin
  EnterStudent(A);
  ClrScr;
  for i:=1 to 20 do
    ShowStudent(A,i,i);
  ReadKey;
end.
