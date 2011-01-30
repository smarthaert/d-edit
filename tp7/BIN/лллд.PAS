uses crt;
var
a,x,y:integer;
procedure ReadInt(prompt:string; var I:integer; NG,VG:integer);
var R:integer;
    Err:boolean;
begin
  repeat
  write(prompt);
{$I-}
  readln(I);
{$I+}
  R:=IOResult;
  Err:=(R<>0) or ((R=0) and ((I>VG) or (I<NG)));
  If Err then
  writeln ('oshibka!');
  until not Err;
end;

begin
clrscr;
readInt('vvedite a: ',a,1,32000);
readInt('vvedite x: ',x,-32000,32000);
readInt('vvedite y: ',y,-32000,32000);
x:=abs(x);
y:=abs(y);
if ((y*y+x*x)<a*a) and (y>(a-x)) then
writeln('prinadlezit') else
writeln('ne prinadlezit');
readkey;
end.
