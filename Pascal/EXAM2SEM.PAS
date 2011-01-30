program CodingExam2SemTasks1to10;

uses
  Crt, Dos;

var
  ss,s, swrd: string;
  ch: Char;

{ Task 1 }

procedure LCharCount(FName: string);
var
  c: char;
  Lat: array['A'..'Z'] of integer;
  f: file of char;
  Res: Text;
begin
  for c:='A' to 'Z' do
    Lat[c] := 0;
  Assign(f, FName);
  Reset(f);
  while not EOF(F) do
  begin
    Read(f, c);
    if c in ['A'..'Z','a'..'z'] then
    inc(Lat[UpCase(c)]);
  end;
  Close(f);
  Assign(Res, 'Task1Res.txt');
  Rewrite(Res);
  Writeln;
  for c:= 'A' to 'Z' do
    if Lat[c] > 0 then
    begin
      WriteLn(Res, C, ' - ', Lat[C]);
      {
      WriteLn(C, ' - ', Lat[C]);
      }
    end;{if}
  Close(Res);
end;

{ Task 2 }

function RepeatCount(Search: Char; FName: string): integer;
var
  c: Char;
  f: File of Char;
  Res: integer;
begin
  Assign(F, FName);
  Reset(f);
  res:= 0;
  while not EOF(F) do                  { Watch all chars }
  begin
    Read(f, c);
    if upcase(c)=upcase(Search) then   { Compare chars }
      Res := Res + 1;
  end;
  Close(f);
  RepeatCount := Res;
end;

{ Task 3 }

function WordCount(FName: string): integer; {Works only with English text}
var
  F: Text;
  i, Res: integer;
  s: string;
begin
  Assign(f, FName);
  Reset(F);
  Res := 0;
  While not EOF(F) do
  begin
    ReadLn(f,s);
    for i:= 1 to Length(s) do
      if not (upcase(s[i]) in ['A'..'Z','0'..'9']) then { Cyrillic charset is not allowed in DOS-mode }
        s[i] := ' ';
    while pos('  ', s) > 0 do     { Deletes double spaces }
      Delete(s, pos('  ', s), 1);
    if s[1] = ' ' then delete(s,1,1); { Deletes first space }
    if s[Length(S)] = ' ' then delete(s,length(s),1); { Deletes last space }
    for i:= 1 to length(s) do
      if (s[i] = ' ')or(i=length(s)) then Res:= Res + 1;
    writeln(s);
  end; {while}
  Close(f);
  WordCount:= Res;
end; {func}

{ Task 4 }
{XEPb}

{ Task 5 }

function FirstStringIndex(s: string; FName: string): integer;
var
  i,c: integer;
  str, wrd: string;
  f: Text;
begin
  wrd := s;
  for c:= 1 to length(wrd) do
    wrd[c] := upcase(wrd[c]);
  i:= 0;
  FirstStringIndex:= -1;
  Assign(f, FName);
  Reset(f);
  while not EOF(F) do
  begin
    i:= i+1;
    ReadLn(f, str);
    for c:= 1 to length(str) do
      str[c] := upcase(str[c]);
    if pos(wrd, str)>0 then
    begin
      FirstStringIndex:= i;
      Break;
    end;{if}
  end; {while}
  Close(f);
end;

{ Task 6 }

procedure CopyStringsWWord(src: string; SWord: string; target: string);
var
  fsrc, ftarget: Text;
  search, str: string;
  i: integer;
begin
  Assign(fsrc, src);
  Reset(fsrc);
  Assign(ftarget, target);
  Rewrite(ftarget);
  search:='';
  for i := 1 to length(sWord) do
    search := search + upcase(sWord[i]);
  while not EOF(fsrc) do
  begin
    readln(fsrc, str);
    for i := 1 to length(str) do
      str[i] := upcase(str[i]);
    if pos(search, str)>0 then
      writeln(ftarget, str);
  end;
  Close(fsrc);
  Close(ftarget);
end;

{ Task 7 }

function TheShortestString(FName: string): string;
var
  Ln: integer;
  F: Text;
  str: string;
begin
  Assign(f, Fname);
  Reset(F);
  Ln:= maxint;
  TheShortestString:= '';
  While not EOF(F) do
  begin
    ReadLn(F,str);
    if (Length(str) > 0)and(Length(str)< Ln) then
    begin
      Ln := Length(str);
      TheShortestString := str + '#';  { Char "#" is to see that string is not empty}
    end; {if}
  end; {while}
  Close(f);
end;

{ Task 8 }
{XEPb}

{ Task 9 }
procedure FindFiles(Path: string; var Mask: string);
var
  SR: SearchRec;
  f: Text;
begin
  if Path[Length(Path)] <> '\' then Path:= Path+'\';
  if Mask = '' then Mask := '*.*';
  Assign(f, 'Task9Res.txt');
  Rewrite(f);
  FindFirst(Path + Mask, $3F, SR);  { $3f <=> faAnyFile }
  while DosError = 0 do
  begin
    Writeln(f, SR.Name);
    FindNext(SR);
  end;
  Close(f);
end;

{ Task 10 }
procedure MergeFiles(Path: string);
var
  SR: SearchRec;
  f,src : Text;
  str: string;
begin
  if Path[Length(Path)] <> '\' then Path := Path + '\';
  Assign(f, 'Task10res.txt');
  Rewrite(f);
  FindFirst(Path + '*.txt', $3F, SR);
  while DosError = 0 do {1}
  begin
    Assign(src, Path + SR.Name);
    Reset(src);
    while not EOF(src) do {2}
    begin
      ReadLn(src, str);
      WriteLn(f, str);
    end; {while 2}
    Close(src);
    FindNext(SR)
  end; {while 1}
  Close(f);
end;

begin

end.