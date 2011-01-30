type
  TStudent = record
    Surname : string;
    BirthYear : integer;
  end;

procedure EnterStudent( var R : TStudent );
begin
  Write('Surname: '); Readln(R.Surname);
  {$I-}
  repeat
    Write('Birth year: ');
    Readln(R.BirthYear);
  until IOResult = 0;
  {$I+}
end;

var A : TStudent;
begin
  EnterStudent(A);
  case A.BirthYear of
    1900..1980: Writeln('Too Old');
    1981..1999: Writeln('Old');
    2000..2007: Writeln('Middle age');
    2007..2009: Writeln('New');
  else
    Writeln('Wrong year!');
  end;
  Writeln(A.Surname,' ',A.BirthYear);
end.
