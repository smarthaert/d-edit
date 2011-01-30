uses crt;
var
n:integer;

function Pun(x:integer):boolean;
var
c,n:integer;
a:real;
b:boolean;
begin
for c:=1 to (n-1) do
  begin
   a:=sqrt(n-sqr(c));
   if (a-trunc(a))=0 then b:=true
   else writeln ('no');
   end;
Pun:=b;
end;

begin
clrscr;
write('Введите натуральное число n: ');
readln(n);
end.