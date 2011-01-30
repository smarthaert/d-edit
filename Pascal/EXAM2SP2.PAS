program ExamSecondSemPart2;

uses
  Crt, Dos;

type
  TMyRec = record
    Key: integer;
  end;

var
  FileName: string;
  NewV, Condition: integer;
  TempRec: TMyRec;

{ Procedures CreateMyRec and CreateMyRecFile are not in Task list }

procedure CreateMyRec(var R: TMyRec);
begin
  with R do
  begin
    { Absolutely random formula ))) }
    Key := (Random(20) - Random(10));
  end;
end;

procedure CreateMyRecFile(FN: string); { Result is a FileName }
var
  f: File of TMyRec;
  i: integer;
  R: TMyRec;
begin
  Assign(f, FN);
  Rewrite(f);
  Randomize;
  for i := 1 to 20 do
  begin
    CreateMyRec(R);
    Write(R.key:3);
    write(f, R);
  end;
  Close(f);
  WriteLn;
end;

{ Task 11 }

procedure DeleteItemsFromFile(Cond: integer; Fname: string);
var
  f, tmp: file of TMyRec;
  r: TMyRec;
begin
  CreateMyRecFile(FName);
  Assign(f, Fname);
  Reset(f);
  Assign(tmp, 'res11.rec');
  Rewrite(tmp);
  While Not EOF(F) do
  begin
    Read(f, r);
    if r.key <> Cond then
    begin
      write(tmp, r);
    end
    else
      writeln('Deleted: ', R.Key);
  end;
  Close(f);
  Close(tmp);
end;

{ Task 12 }

procedure ReplaceItemsFromFile(Cond: integer; NewValue: integer; Fname: string);
var
  f, tmp: file of TMyRec;
  r: TMyRec;
begin
  CreateMyRecFile(FName);
  Assign(f, Fname);
  Reset(f);
  Assign(tmp, 'res12.rec');
  Rewrite(tmp);
  While Not EOF(F) do
  begin
    Read(f, r);
    if r.key = Cond then
    begin
      r.key := NewValue;
      writeln('Replaced: ', Cond);
    end;
    write(tmp, R);
  end;
  Close(f);
  Close(tmp);
end;

{ Task 13 }
procedure MaxInFile(Fname: string; var Res: TMyRec);
var
  f: file of TMyRec;
  max: integer;
  R: TMyRec;
begin
  CreateMyRecFile(fname);
  Res.Key := -maxint;
  Assign(f, FName);
  Reset(f);
  while not EOF(F) do
  begin
    Read(f, R);
    if R.key > Res.Key then
      Res := R;
  end;
end;

{ Task 14 }
function MinInFile(Fname: string): integer;
var
  f: file of TMyRec;
  max: integer;
  R, res: TMyRec;
  Result: integer;
begin
  CreateMyRecFile(fname);
  Res.Key := maxint;
  Assign(f, FName);
  Reset(f);
  Result := 0;
  while not EOF(F) do
  begin
    Result := Result + 1;
    Read(f, R);
    if R.key < Res.Key then
    begin
       MinInFile := Result;
       Res:= r;
    end;
  end;
end;

{ Task 15 }
function MoreThanMax(value: integer; FName: string): boolean;
var
  f: file of TMyRec;
  R, res: TMyRec;
begin
  CreateMyRecFile(fname);
  Res.Key := -maxint;
  Assign(f, FName);
  Reset(f);
  while not EOF(F) do
  begin
    Read(f, R);
    if R.key > Res.Key then
      Res := R;
  end;
  MoreThanMax:= Res.key < value;
end;

{ Task 16 }
procedure InInterval(vlow, vhigh: integer; FName: string);
var
  f, tmp: file of TMyRec;
  r: TMyRec;
begin
  CreateMyRecFile(FName);
  Assign(f, Fname);
  Reset(f);
  Assign(tmp, 'res11.rec');
  Rewrite(tmp);
  While Not EOF(F) do
  begin
    Read(f, r);
    if (r.key >= vlow)and(r.key <= vhigh) then
    begin
      write(tmp, r);
      write(r.key:3);
    end
  end;
  Close(f);
  Close(tmp);
end;


begin
  clrscr;
  FileName:= 'D:\MyRecF.rec';
  Write('Enter min: '); Readln(NewV);
  Write('Enter max: '); Readln(Condition);
  InInterval(NewV, Condition, FileName);
  readkey;
end.