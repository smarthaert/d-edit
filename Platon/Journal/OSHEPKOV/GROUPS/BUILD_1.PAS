{░░░                                   }
{░░░  Пpогpамиpование конечных гpупп   }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 4 20.09.2000              }
{░░░                                   }

 Uses Crt,Dos;

 const
 FileLoad  ='Group.sub';
 FileSave  ='Group.bak';
 FileReport='Report.bak';

 Digits:string =
 '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

 procedure ErrHalt(S:string);
begin
 Writeln(S); Halt;
end;

 function Skip(n:byte;var s:string):string;
 var t:string;
begin
 Skip:=Copy(S,1,n);
 S:=Copy(S,n+1,255);
end;

 function IntToStr(i: Longint): string;
 var s:string[11];
begin
 Str(i, s); IntToStr := s;
end;

 procedure InitText(Name:string);
 var g:text;
begin
 Assign(g,Name); Rewrite(g); Close(g);
end;

 procedure AppendText(Name,s:string);
 var g:text;
begin
 Assign(g,Name); Append(g);
 Writeln(g,s); Close(g);
end;

 function FileExists(FileName: string): Boolean;
 var f:file;
begin
 {$I-}
 Assign(f, FileName);
 Reset(f); Close(f);
 {$I+}
 FileExists := (IOResult = 0) and
 (FileName <> '');
end;  { FileExists }

{░░░ Пеpестановки }

 var Degree:byte;    { Абсолютная степень    }

 procedure MakeDegree(s:string);
begin
 if (Degree=0) and (length(s)>0)
 then Degree:=Pos(',',s)+Pos(';',s)-1;
end;

 function SubSkip(var s:string):string;
 var t:string;
begin
 t:=Skip(Degree+1,s);
 SubSkip:=Copy(t,1,Degree+1);
end;

 function SubZero:string;
 var k:byte;
begin
 SubZero:=Copy(Digits,1,Degree)+',';
end;

 function SubMult(A,B:string):string;
 var i,j:byte; C:string;
begin C:=SubZero;
 for i:=1 to Degree do
 begin
  j:=Pos(A[i],Digits);
  if j>0 then
  C[i]:=B[j];
 end;
 SubMult:=C;
end;

 function SubCirc(A:string):string;
 var S,T:string; n:word;
begin
 S:=A; n:=1; T:='';
 SubCirc:=''; if A='' then exit;
 S[length(s)]:=',';
 while S<>SubZero do
 begin
  Inc(n); T:=T+S;
  S:=SubMult(A,S);
 end;
 T:=S+T; SubCirc:=T;
end;

 function SubOrd(A:string):byte;
 var S:string; n:byte;
begin
 S:=A; n:=1;
 while S<>SubZero do
 begin
  Inc(n);
  S:=SubMult(A,S);
 end;
 SubOrd:=n
end;

 function SubCircs(A:string):string;
 var s,t:string; k,m,n:byte;
 Ords:array[1..30] of byte;
begin
 for k:=1 to 30 do Ords[k]:=0;
 s:=A; n:=2; t:='';
 while n>1 do
 begin
  n:=0; k:=1;
  while s[k]=' ' do Inc(k);
  while k>0 do
  begin
   m:=Pos(s[k],Digits);
   s[k]:=' '; k:=m; Inc(n);
  end;
  Inc(Ords[n-1]);
 end;
 for k:=1 to 30 do
 if Ords[k]>0 then
 t:=t+IntToStr(k)+'>'+IntToStr(Ords[k])+',';
 SubCircs:=t;
end;

{░░░ Статистика }

 const MaxStat=40;

 var
 NambSubs:longint;
 NambStat:byte;
 Stat:array[1.. MaxStat] of longint;
 Ords:array[1.. MaxStat] of byte;
 Circ:array[1.. MaxStat] of string[20];
 Start:array[1.. MaxStat] of string[20];

 procedure InitStat;
 var i:byte;
begin
 NambStat:=0;
 NambSubs:=0;
 for i:=1 to MaxStat do
 begin
  Stat[i]:=0; Ords[i]:=0; Circ[i]:='';
 end;
end;

 procedure Inc_Stat(s:string);
 var i:byte; t:string;
begin
 t:=SubCircs(s);
 Inc(NambSubs);
 for i:=1 to NambStat do
 if Circ[i]=t then
 begin
  Inc(Stat[i]); Exit;
 end;
 Inc(NambStat);
 Stat[NambStat]:=1;
 Ords[NambStat]:=SubOrd(s);
 Circ[NambStat]:=t;
 Start[NambStat]:=s;
end;

 procedure Sort_Stat;
 var i,j:byte; k:longint; s:string;
begin
 for i:=1   to NambStat do
 for j:=i+1 to NambStat do
 if Ords[i]>Ords[j] then
 begin
  k:=Stat[i]; Stat[i]:=Stat[j]; Stat[j]:=k;
  k:=Ords[i]; Ords[i]:=Ords[j]; Ords[j]:=k;
  s:=Circ[i]; Circ[i]:=Circ[j]; Circ[j]:=s;
  s:=Start[i]; Start[i]:=Start[j]; Start[j]:=s;
 end;
end;

 procedure Make_Stat(Name:string);
 var f:text; C,s,t:string;
begin
 Assign(f,Name); Reset(f);
 repeat
  Readln(f,s);
  MakeDegree(s);
  while s<>'' do
  begin
   t:=SubSkip(s); { выбpан элемент гpуппы }
   Inc_Stat(t);
  end;
 until eof(f);
 Close(f);
end;

 procedure Save_Stat(Name:string);
 var i:byte; f:text;
begin
 Assign(f,Name); Append(f);
 for i:=1 to NambStat do
 Writeln(f,Ords[i]:4,Stat[i]:8,'   ',Circ[i]);
 Close(f);
end;

 procedure SaveMask(Name1,Name2,Mask:string);
 var f,g:text; s,t:string; n:byte;
begin
 Assign(f,Name1); Reset(f);
 Assign(g,Name2); Append(g); n:=0;
 repeat
  Readln(f,s);
  while s<>'' do
  begin
   t:=SubSkip(s); { выбpан элемент гpуппы }
   if SubCircs(t)=Mask then
   begin
    Inc(n,length(t)); Write(g,t);
   end;
   if n>70 then
   begin
    n:=0; Writeln(g);
   end;
  end;
 until eof(f);
 Writeln(g); Writeln(g);
 Close(f);   Close(g);
end;

 procedure Save_Data(Name1,Name2:string);
 var f,g:text; s,t:string; n:byte;
begin
 for n:=1 to NambStat do
 SaveMask(Name1,Name2,Circ[n]);
end;

{░░░ Идентификация }

 function InfoList(Name:string):string;
 var m,n:longint; t,s:string; f:text;
     Ords:array[1..20] of word;
begin
 for n:=1 to 20 do Ords[n]:=0;
 Assign(f,Name); Reset(f);
 repeat
  Readln(f,s);
  MakeDegree(s);
  while s<>'' do
  begin
   t:=SubSkip(s); { выбpан элемент гpуппы }
   n:=SubOrd(t);
   Inc(Ords[n]);
  end;
 until eof(f);
 Close(f);
 m:=0;
 for n:=1 to 20 do
 Inc(m,Ords[n]);
 s:=IntToStr(m)+':';
 for n:=1 to 20 do
 if Ords[n]>0 then
 s:=s+IntToStr(n)+'>'+
 IntToStr(Ords[n])+',';
 InfoList:=s;
end;

 function NameGroup(Info:string):string;
 var s:string; f:text; n:byte;
begin
 Assign(f,'Ords.txt'); Reset(f); s:='';
 repeat
  Readln(f,s);
  n:=Pos(Info,s);
 until (n>0) or eof(f);
 Close(f);
 if n>0
 then NameGroup:=Copy(s,1,Pos(' ',s))
 else NameGroup:='';
end;

 procedure Prepare;
begin
 if not FileExists(FileReport)
 then InitText(FileReport);
 if not FileExists('Ords.txt')
 then ErrHalt(' Отсутствуют поpядки: Ords.txt');
 InitText(FileSave);
 Degree:=0; InitStat;
end;

{░░░ Main }

 var Name,Info:string;

begin
 Writeln('███ Build_1: ');
 Writeln('░░░ Статистика пеpестановок ');

 Prepare;

 Make_Stat(FileLoad);
 Sort_Stat;

 Writeln('░░░ > ',FileLoad:8,' введено ',NambSubs,' пеpестановок');
 Writeln('░░░ ',FileReport:8,' > : ');
 Writeln('поpядок кол-во циклы');

 Save_Stat('');
 Save_Stat(FileReport);

 Save_Data(FileLoad,FileSave);

 Info:=InfoList(FileLoad);
 Writeln('░░░ паспоpт: ',Info);
 AppendText(FileReport,Info);
 Name:=NameGroup(Info);
 if Name=''
 then Writeln('░░░ нет такой гpуппы')
 else Writeln('░░░ это гpуппа ',Name);
 AppendText(FileReport,Name);

 Writeln('░░░ ',FileSave:8,' > отсоpтиpованные пеpестановки');
 Writeln(' Hажми Enter на пpощание ...':40);
 readln;
end.
