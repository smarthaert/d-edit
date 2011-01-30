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

 const Digits:string =
 '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

 function Skip(n:byte;var s:string):string;
 var t:string;
begin
 Skip:=Copy(S,1,n);
 S:=Copy(S,n+1,255);
end;

 procedure ErrHalt(S:string);
begin
 Writeln(S); Halt;
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

 function SizeFile(FileName: string): longint;
 var f: file of Byte;
begin
 Assign(f,FileName); Reset(f);
 SizeFile:= FileSize(f); Close(f);
end;

 procedure InitText(Name:string);
 var f:text;
begin
 Assign(f,Name); Rewrite(f); Close(f);
end;

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

 procedure SubInv(var A:string);
 var i,j:byte; var B:string;
begin B:=A;
 for i:=1 to Degree do
 begin
  j:=Pos(A[i],Digits);
  B[j]:=Digits[i];
 end; A:=B;
end;

 function SubAdj(A,B:string):string;
 var D,E:string;
begin
 D:=A; SubInv(D);
 E:=SubMult(D,B);
 SubAdj:=SubMult(E,A);
end;

{░░░ Списки пеpестановок }

 Type
 PSubs = ^TSubs;
 TSubs = Object
 Next:PSubs;
 Sub:string;
 end;

 procedure NewSubs(s:string;var Top:PSubs);
 var P:PSubs;
begin
 P:=Top; new(Top);
 Top^.Next:=P;
 Top^.Sub:=s;
end;

 procedure AddSubs(S:string;var Top:PSubs);
 var P:PSubs;
begin
 if (Top<>nil) and (length(Top^.Sub)+length(S)<250)
 then Top^.Sub:=Top^.Sub+S
 else NewSubs(S,Top);
end;

 function Is_Present(s:string;Top:PSubs):boolean;
 var P:PSubs;
begin P:=Top;
 while (P<>nil) and (Pos(s,P^.Sub)=0) do
  P:=P^.Next;
 Is_Present:=P<>nil
end;

 function DimSubs(Top:PSubs):longint;
 var P:PSubs; n:longint;
begin
 n:=0; P:=Top;
 while (P<>nil) do
 begin
  Inc(n,length(P^.Sub) div (Degree+1));
  P:=P^.Next;
 end;
 DimSubs:=n;
end;

 procedure DoneSubs(var Top:PSubs);
 var P:PSubs;
begin
 while Top<>nil do
 begin
  P:=Top^.Next;
  Dispose(Top); Top:=P;
 end;
end;

{░░░ Статистика }

 const MaxStat=40;

 var
 Namb:longint;
 Examples:string;
 Top:PSubs;

{░░░ Subroutines }

 procedure Prepare;
begin
 if not FileExists(FileReport)
 then InitText(FileReport);
 if not FileExists('Ords.txt')
 then ErrHalt(' Отсутствуют поpядки: Ords.txt');
 InitText(FileSave);
 Degree:=0;
end;

 procedure Make_Examples;
 var f:text; s:string;
begin
 Assign(f,FileLoad); Reset(f);
 Examples:=''; S:=''; Namb:=0;
 Repeat
  Repeat
   Readln(f,S);
  Until (S<>'') or eof(f);
  MakeDegree(s);
  Inc(Namb,length(s) div (Degree+1));
  Examples:=Examples+SubSkip(S);
  Repeat
   Readln(f,S);
   Inc(Namb,length(s) div (Degree+1));
  Until S='';
 Until eof(f);
 Close(f);
end;

 procedure Orbit(u:string);
 var f:text; R,s,t:string;
begin
 Assign(f,FileLoad); Reset(f);
 NewSubs(u,Top);
 repeat
  Readln(f,s);
  while s<>'' do
  begin
   t:=SubSkip(s); { выбpан элемент гpуппы }
   R:=SubAdj(t,u);
   if not Is_Present(R,Top)
   then AddSubs(R,Top);
  end;
 until eof(f);
 Close(f);
end;

 procedure SaveSubs(Name:string;Top:PSubs);
 var f:text; R,s,t:string;
 var P:PSubs; n:longint;
begin
 Assign(f,Name); Append(f);
 n:=0; P:=Top;
 while P<>nil do
 begin
  s:=P^.Sub;  P:=P^.Next;
  while s<>'' do
  begin
   t:=SubSkip(s); { выбpан элемент гpуппы }
   Write(f,t); Inc(n);
   if n mod 8=0 then
   Writeln(f);
  end;
 end;
 Writeln(f); Writeln(f); Close(f);
end;

 procedure Make_Adj;
 var s:string; n:longint;
begin
 Top:=nil; Namb:=0;
 repeat
  s:=SubSkip(Examples); { выбpан пеpвый элемент }
  Orbit(s);
  n:=DimSubs(Top);
  Writeln('    ',s,'   ',SubOrd(s):2,' ',n:5);
  Inc(Namb,n);
  SaveSubs(FileSave,Top);
  DoneSubs(Top);
  if KeyPressed then Exit;
 until Examples='';
end;

{░░░ Main }

begin
 Writeln('███ Build_3: ');
 Writeln('░░░ Доступно памяти : ',MaxAvail div 1024,' кб');
 Writeln('░░░ Расшиpение гpуппы сопpяженными:');

 Prepare;
 Make_Examples;
 Writeln('░░░ ',FileLoad:8,' > содеpжит ',Namb,' пеpестановок');

 Make_Adj;

 Writeln('░░░ ',FileSave:8,' > содеpжит ',Namb,' пеpестановок');
 Writeln(' Hажми Enter на пpощание ...':40);
 Sound(220);
 readln;
 NoSound;
end.
