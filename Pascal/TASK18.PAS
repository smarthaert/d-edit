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

var A : TStudent;
begin
  EnterStudent(A);
  case A.BirthYear of
    1900..1980: Writeln('Too Old');
    1981..1999: Writeln('Old');
    2000..2007: Writeln('Middle age');
    2007..2009: Writeln('New');
  end;
  Writeln(A.Surname,' ',A.BirthYear);
end.
