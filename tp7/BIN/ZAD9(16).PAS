
function Pun(x:integer):boolean;
var
i,n:integer;
a:real;
b:boolean;
begin
for i:=1 to (n-1) do
  begin
   a:=sqrt(n-sqr(i));
   if (a-trunc(a))=0 then b:=true
   end;
Pun:=b;
end.