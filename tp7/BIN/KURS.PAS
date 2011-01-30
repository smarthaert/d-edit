Uses Crt;
Type
TStudent=record
Fam:string[30];
Im:string[30];
MATEM:word;
end;
var

WR:TStudent;
{//////////////////////////////////////////}
Procedure EditStudent(FName:string);
var
F:File of TStudent;i:integer;
ED,SUR,ONAM:string;
NSUR,NNAME:string[30];
N,P:longint;
begin;
Assign(F,FName);
Reset(F);
{Seek(F,1);}
ClrScr;
 while not EOF(F) do
  begin;
  i:=0;
  Read(F,WR);
  writeln('SURNAME:',WR.Fam);
  writeln('NAME   :',WR.Im);
  writeln('MATAN  :',WR.MATEM);writeln('************');
  end;
   Writeln('ENTER EDIT STUDENT');
   Writeln('1.SURNAME');
   Writeln('2.NAME');
   writeln('3.MATAN');
   case READKEY of
   '1':begin;
   Writeln('ENTER SURNAME');READln(SUR);
   Writeln('ENTER NEW SURNAME');READln(nsur);
   Assign(F,FName);
   Reset(F);
   while not EOF (F) do
    begin;
    P := FilePos(F);
    Read(F,WR);

    if SUR=wr.fam then
      begin

      wr.fam:=nsur;
      seek(F,P);
      Write(F,wr);
       break;
       end;

    end;
     end;
  '2':
  begin;
  writeln('NAME');readln(ONAM);
  writeln('NEW NAME');readln(nname);
  Assign(F,FName);
   Reset(F);
   while not EOF (F) do
    begin;
    P := FilePos(F);
    Read(F,WR);
    if onam=wr.im then
      begin
       wr.im:=nname;
      seek(F,P);
      Write(F,wr);
      break;
       end;
      end;
      end;


end;
   end;
{////////////////////////////}
Procedure SearchStud(FName:string);
var
F:file of TStudent;
WR:TStudent;NUM:byte;
WSTR,SEARCH,OK:string;
begin;
ClrScr;Writeln('///SEARCH STUDENT///');
Writeln('ENTER SURNAME');read(SEARCH);
Assign(F,FName);
Reset(F);
while not EOF (F) do
  begin;
  Read(F,WR);
  if SEARCH=WR.Fam then
   begin;
  { writeln(WR.Im);
   writeln(WR.MATEM);}
   writeln('SURNAME:',WR.Fam);
   writeln('NAME   :',WR.Im);
   writeln('MATAN  :',WR.MATEM);
   end;

  end;
Writeln('PLEASE PRESSED KEY');
READKEY;
close(F);

end;
{////////////////////////////////////////}
Procedure ShowStudents(FName:string);
var
F: file of TStudent;
I,Count :byte;
WR:TStudent;
WSTR: string;
begin;
Assign(F,FName);
Reset(F);
{Seek(F,1);}
ClrScr;
while not EOF(F) do
begin;
Read(F,WR);
writeln('SURNAME:',WR.Fam);
writeln('NAME   :',WR.Im);
writeln('MATAN  :',WR.MATEM);writeln('************');
end;
Writeln('PLEASE PRESSED KEY');
READKEY;

Close(F);
end;
{/////////////////////////////////////////////}
Procedure AddStudent(FName:string);
var
F:file of TStudent;
WR:TStudent;
Ans:char;
begin;
Assign(F,FNAME);{$I-}
Reset(F);
if IORESULT=0 then
Seek(F,FileSize(F)){$I+}
else ReWrite(F);
With WR do
Repeat ClrScr;
Write('SURNAME: ');Readln(FAM);
Write('NAME:    ');Readln(Im);
Write('MATAN:   ');Readln(MATEM);
Write(F,WR);
Write('ESCHO ?');
Read(Ans);
Until(Ans='n');
Close(F);
end;
PROCEDURE OTCHET(FName:string);

 var
F:file of TStudent;
WR:TStudent;NUM:byte;
WSTR,OK:string;
SEARCH:word;
begin;
ClrScr;Writeln('///OTCHET///');
Writeln('ENTER BALL MATAN');read(SEARCH);
Assign(F,FName);
Reset(F);
while not EOF (F) do
  begin;
  Read(F,WR);
  if SEARCH=WR.MATEM then
   begin;
   writeln('SURNAME:',WR.Fam);
   writeln('NAME   :',WR.Im);
   writeln('MATAN  :',WR.MATEM);
   Writeln('************************');
   end;
end;READKEY;
end;
{///////////////////////////////////}
var
FName:string;
begin;
ClrScr;
FName:='bdstudent';
writeln('1.ADD STUDENT');
writeln('2.SHOW STUDENT');
writeln('3.SEARCH STUDENT');
writeln('4.EDIT STUDENT');
writeln('5.OTCHET');
case READKEY of
'1': AddStudent(FName);
'2': ShowStudents(FName);
'3': SearchStud(FName);
'4': EditStudent(FName);
'5': OTCHET(FName);
end;
{ShowStudents(FName);
AddStudent(FName);
 ShowStudents(FName);}
end.