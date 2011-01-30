uses crt,graph,dos,turbo3;

{$M $4000,0,0 }   { 16K stack, no heap }

var func:char;
    direc,nd,td,s:string;
    work:text;
    exc:integer;

Procedure FileCopy(SrcPath, DstPath, FSpec : String; Var ExStat : Integer);
Var
  DirInfo : SearchRec;
  Done    : Boolean;

Procedure Process(X : String);
Var
  Source,
  Dest     : File;
  Buffer   : Array[1..4096] of Byte;
  ReadCnt,
  WriteCnt : Word;

begin
  {$I-}
  ExStat:=0;
  Assign(Source,SrcPath+X);
  Reset(Source,1);
  If IOResult <> 0 then
    ExStat := 1;
  If ExStat = 0 then
  begin
    Assign(Dest,DstPath+X);
    ReWrite(Dest,1);
    If IOResult <> 0 then
      ExStat := 2;
    If ExStat = 0 then
    begin
      Repeat
        BlockRead(Source,Buffer,Sizeof(Buffer),ReadCnt);
        BlockWrite(Dest,Buffer,ReadCnt,WriteCnt);
        If IOResult <> 0 then
          ExStat := 3;
      Until (ReadCnt = 0) or (WriteCnt <> ReadCnt) or (ExStat <> 0);
      Close(Dest);
    end;
    Close(Source);
  end;
  {$I+}
end;

begin
  {$I-}
    ExStat := 0;
    FindFirst(SrcPath + FSpec, Archive, DirInfo);
    Done := False;
    While Not Done do
    begin
      Process(DirInfo.Name);
      If (ExStat = 0) then
      begin
        FindNext(DirInfo);
        If (DosError<>0) then
          Done := True;
      end
      else
        Done := True;
    end;
  {$I+}
end;

function chk_direc(s:string):boolean;
begin
chk_direc:=true;
{$i-}
chdir(s);
{$i+}
if ioresult<>0 then chk_direc:=false;
end;

begin
textmode(co80+font8x8);
clrscr;
writeln('IronClad installation');
getdir(0,nd);

if nd[length(nd)]='\' then delete(nd,length(nd),1);

writeln;
write('Are you sure want to install IronClad [Y/N]?');
read(kbd,func);
func:=upcase(func);
if func='Y' then
begin
writeln;
write('Install to what directory [c:\IronClad]: ');
readln(direc);

if direc<>'' then
begin
if (direc[2]<>':') and (pos('\',direc)=0) then direc:='c:\'+direc;
end;

if direc='' then direc:='c:\IronClad';
{$i-}
chdir(direc);
{$i+}

if ioresult<>0 then
begin
writeln;
write('Directory: ',direc,' does not exist. Do you want to create it [Y/N]: ');
read(kbd,func);
func:=upcase(func);
if func='Y' then
begin
{$i-}
mkdir(direc);
{$i+}
if (ioresult<>0) and (chk_direc(direc)=false) then
begin
clrscr;
writeln('Unable to create directory: ',direc,'. Please try install to a different');
writeln('location');
writeln;
write('Hit enter to stop installation--');
readln;
textmode(co80);
halt;
end;
end;
end;

{$i-}
mkdir(direc+'\pictures');
{$i+}
if (ioresult<>0) and (chk_direc(direc+'\pictures')=false) then
begin
clrscr;
writeln('Unable to use directory: ',direc,'. Please try install to a different');
writeln('location [1]');
writeln;
write('Hit enter to stop installation--');
readln;
textmode(co80);
halt;
end;
{$i-}
mkdir(direc+'\bgi');
{$i+}
if (ioresult<>0) and (chk_direc(direc+'\bgi')=false) then
begin
clrscr;
writeln('Unable to use directory: ',direc,'. Please try install to a different');
writeln('location [2]');
writeln;
write('Hit enter to stop installation--');
readln;
textmode(co80);
halt;
end;
{$i-}
mkdir(direc+'\source');
{$i+}
if (ioresult<>0) and (chk_direc(direc+'\source')=false) then
begin
clrscr;
writeln('Unable to use directory: ',direc,'. Please try install to a different');
writeln('location [3]');
writeln;
write('Hit enter to stop installation--');
readln;
textmode(co80);
halt;
end;

assign(work,nd+'\ship.ini');
rewrite(work);
writeln(work,'[Work Directory]');
writeln(work,direc);
writeln(work,'[Picture Directory]');
writeln(work,direc+'\pictures');
writeln(work,'[Bgi directory]');
writeln(work,direc+'\bgi');
writeln(work,'[Stars]');
writeln(work,'ON');
writeln(work,'[Slow down]');
writeln(work,'1');
close(work);

assign(work,nd+'\filelist.lst');
{$i-}
reset(work);
{$i+}
if ioresult<>0 then
begin
clrscr;
writeln('Unable to find crucial file: filelist.lst');
readln;
textmode(co80);
halt;
end;
writeln;
writeln('About to unzip picutres');
write('Hit enter to continue--');
readln;
SwapVectors;
Exec(nd+'\pkunzip.exe',concat(nd+'\pictures.zip ',direc,'\pictures'));
SwapVectors;
if DosError <> 0 then
begin
clrscr;
writeln('Could not unzip pictures. Cannot continue--');
readln;
textmode(co80);
halt;
end;

clrscr;
writeln('Copying files--');
writeln;

repeat
readln(work,s);
if s[1]='[' then
begin
if s='[Work' then td:=direc+'\';
if s='[Bgi' then td:=direc+'\bgi\';
if s='[Source' then td:=direc+'\source\';
end;
if s[1]<>'[' then
begin
filecopy(nd+'\',td,s,exc);
end;
until eof(work);
close(work);
chdir(direc);

assign(work,'ironclad.ex_');
{$i-}
rename(work,'ironclad.exe');
{$i+}
if ioresult<>0 then
begin
clrscr;
writeln('Unable to locate IronClad.ex_ in installation directory!');
halt;
end;
assign(work,'ironclad.ic_');
{$i-}
rename(work,'ironclad.ico');
{$i+}
if ioresult<>0 then
begin
clrscr;
writeln('Unable to locate IronClad.ic_ in installation directory!');
halt;
end;
assign(work,'ironclad.pi_');
{$i-}
rename(work,'ironclad.pif');
{$i+}
if ioresult<>0 then
begin
clrscr;
writeln('Unable to locate IronClad.pi_ in installation directory!');
end;


textmode(co80);
clrscr;
writeln('IronClad installation complete!');
writeln('Type "Ironclad" to play. Remember to have a mouse driver installed before');
writeln('playing. Select the Help option from the main menu to learn the keys.');
writeln;
end;
end.
