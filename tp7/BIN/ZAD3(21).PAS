
uses crt;
var x,e,s,sn,r,a,a0:real;
    q:char;kn:integer; b:boolean;
procedure ReadReal (var I:real);
var Str: string; code:integer;
begin
  repeat
readln (Str);
val (Str,I,code);
if code <> 0 then
begin
 textcolor (4);
 writeln ('ошибка типа данных!повторите ввод');
 textcolor (15);
 end;
 until code=0;
 end;
 procedure HeadTxt (s: string);
 begin
   GotoXY ((80-Length(s)) div 2, );
TextColor (10);
writeln (s);
textcolor (15);
end;
 behin
 repeat
 clrscr;
 HeadTxt ('задание №3(31)');
 repeat
 b:=false;
 writeln ('введите х');
 ReadReal (x);
 if (x<=0) or (x>=2) then
 begin
 writeln ('х не принадлежит области разложения');
 writeln ('х должен лежать в промежутке (0;2)');
 writeln;
 end;
 until (x>0) and (x<2);
  write ('введите точность е');
  ReadReal (e);
  s:=0; sn:=0: a0:=x-1; k:=0;
   repeat
     a:=a0; Inc (k);  s:=s+a;
  if abs (a)>e then a0:= -(a*k*(x-1)/(k+1))
  else
  begin
    n:=k; sn:=s; b:=true;
    rn:=abs(ln(x)-sn);
    end;
 until b:=true;
 writeln ('n:= ,n);
 writeln ('sn:=' ,sn);
 writeln ('rn:=' ,rn);
 writeln ('повторить программу y/n');
 repeat
 q:=ReradKey;
 until q in ['y','n'];
 until q in ['n'];
 end.
