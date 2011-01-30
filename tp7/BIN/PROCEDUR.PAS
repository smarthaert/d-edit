 uses crt;
var
a,x,y:real;
procedure ReadReal(prompt:string; var I:real; NG,VG:real);
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
readReal('vvedite a: ',a,1,32000);
readReal('vvedite x: ',x,-32000,32000);
readReal('vvedite y: ',y,-32000,32000);
x:=abs(x);
y:=abs(y);
if ((y*y+x*x)<a*a) and (y>(a-x)) then
writeln('prinadlezit') else
writeln('ne prinadlezit');
readkey;
end.