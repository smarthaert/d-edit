{========================================================================}
procedure prost(n3: integer; var pr:integer);
var a3: integer;
x3: real;
begin
a3:=1;
repeat
inc(a3);
x3:=n3/a3;
 if (x3= n3 div a3) and (a3<>n3)  then a3:=12;
until a3>10;
 if a3=11 then pr:=1
  else
   pr:=0;
end;
{=========================================================================}
procedure summa(n2: integer; var y2,i2: integer);
var prs2,x2:integer;

begin
 y2:=n2;
 i2:=2;
 dec(y2);
 prost(y2,prs2);
 repeat
 if prs2=1 then
  begin
  x2:=y2+i2;
   if (x2<>(n2)) then
    begin
     repeat
     inc(i2);
     prost(i2,prs2);
     until (prs2=1);
    end
  end
   else
   begin
   dec(y2);
   prost(y2,prs2);
   i2:=2;
   x2:=y2+i2;
   end;
   if (x2>(n2)) then
   begin
   dec(y2);
   prost(y2,prs2);
   i2:=2;
   end;
  until (((x2=n2) or (y2=2)) and (prs2=1));
end;
{=========================================================================}
procedure summa3h(n4: integer; var a4,b4,c4: integer);
var a,b,d :integer;
begin
  summa(n4,a,b);
  if (a>b) or (a=b)  then d:=a-1 else d:=b-1;
  summa(d,a,b);
     if (a>b) or (a=b) then
      begin
       d:=((n4)-a)+3;
       a4:=a;
      end
        else
         begin
          d:=((n4)-b)+3;
          a4:=b;
         end;
  summa(d,b4,c4);
end;


{==========================================================================}
procedure Mnoj(n1: integer );
 Var i: integer;
  x1,j: real;
  begin
  i:=2;
  x1:=n1;
   repeat
     j:=int(x1/i);
     If (x1/i=j) then
      begin
       x1:= x1 / i;
       write(i,' ');
      end
       else
       begin
       inc(i)
       end;
   until ( x1=1 )
  end;
{________________________________________________________________________}
procedure kolprost(n1:integer);
 Var i,p: integer;
 z, v : real;
 begin
  repeat
  if n1=2 then
 begin
 writeln('Для n=2 решений нет');
 break;
 end;
  p:=1;
  n1:=n1-1;
  repeat
   inc(p);
   v:=n1/p;
   if p>n1  then p:=11;
    if (v = n1 div p) and (p<>n1) then  p:=12;
  until p>10;
  if p=11 then write(n1, ' ');
  until n1=2;
 end;
{=================================================================}
procedure deliteli(n4:integer);
var i,k:integer;
d,p:real;
Begin
 i:=1;
 k:=0;
 repeat
  d:=n4/i;
  p:=int(n4/i);
   If (d=p) then
    begin
     write(i,' ');
     inc(k);
    end;
  inc(i);
 until (i>n4);
  writeln(chr(10),chr(13),'колличество делителей N - ',k);
end;
{=================================================================}
procedure summdel(n5:integer);
var i,sum:integer;
d,p:real;
s:string;
Begin
 s:='+';
 i:=1;
 sum:=0;
 repeat
  d:=n5/i;
  p:=int(n5/i);
   If (d=p) and (p<>1) then
    begin
     sum:=sum+i;
     write(i,' ');
    end;
  inc(i);
 until (i>n5);
 write('=',sum);
 if sum=n5 then write ('- совершенное число')
 else write('- несовершенное число');
end;
{=================================================================}
Procedure Eler(n6:integer; var fi:integer);
Var i,m: integer;
  x6,j,h: real;
  begin
  i:=2;
  x6:=n6;
   begin
    repeat
     j:=int(x6/i);
     If (x6/i=j) then
      begin
       x6:=x6 / i;
            for m:=2 to n6-1 do
             begin
              if m<x6 then
                begin
                 h:=x6/m;
                  if (h = int(x6/m)) then
                    begin
                     fi:=0;
                     m:=n6+1;
                    end
                  else
                   begin
                    write(m,' ');
                    inc(fi);
                   end
              else
               begin
                h:=m/x6;
                 if (h = int(x6/m)) then
                  begin
                   fi:=0;
                   m:=n6+1;
                  end
                 else
                   begin
                    write(m,' ');
                    inc(fi);
      end;
     end
       else
       begin
       inc(i)
       end;
   until ( x6=1 );
  end;
{=================================================================}
{=================================================================}
Var n,y,i,prs,a,b,c,isxn,fe: integer;
yes: char;
Begin
 repeat
  repeat
   writeln('Введите целое число N>=2 ');
   readln(n);
    if n<2 then writeln('Вы ввели число  N<2');
  until n>=2;
  isxn:=n;
  prost(n,prs);
   if prs=1 then writeln('Вы ввели простое число')
    else
     begin
     writeln('Множители числа n');
     Mnoj(n);
   end;
  writeln('');
  writeln('Простые числа до числа n');
  kolprost(n);
  prost(n,prs);
  n:=n*2;
  writeln;
  writeln('Представление четного в виде суммы 2 простых (2n)');
  summa(n,y,i);
  writeln(chr(13));
  writeln(y,' ',i);
  writeln('Представление нечетного в виде суммы 3 простых (2n+3)');
  summa3h(n,a,b,c);
  writeln(a,' ',b,' ',c);
  writeln('кол-во делителей n = ',' ',isxn,': ');
  deliteli(isxn);
  summdel(isxn);
  writeln;
  {writeln('Все числа взаимно простые с n :');
  eler(isxn,fe);
  writeln;
  writeln('Функция Эйлера равна= ',fe);}
writeln(chr(10),chr(13),'Вы хотите завершить работу ? Да - Y ');
readln(yes);
until (yes='Y') or (yes= 'y');
end.
