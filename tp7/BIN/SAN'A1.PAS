var n,m1,m2,m3,i: integer;

begin
writeln ('введите Число');
readln (n);
m1:= n div 100;
m2:= ((n-m1*100) div 10);
m3:= (n-(m1*100 + m2*10));
writeln (m1:3,m2:3,m3:3);

readln
end.