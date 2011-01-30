program calc;
uses crt;
const
 N=3;

 type M= array [1..N] of byte;

 var
 M1, M2: M;
  y: byte;
 procedure sloj;
  begin
  clrscr;
  writeln('slojenie');
  readln ;
  end;
 procedure vich;
  begin
  clrscr;
  writeln('vichitanie');
  readln
  end;
 procedure exit1;
  begin
  writeln('exit');
  readln;
  end;
 procedure VVod(var mM1: M);
 var
  x: char;
  k,b,i,kkk: integer;
 begin
  Writeln('VVod slogaemih');
  For i:=1 to N do
  begin
  mM1[i]:=0;
  end;
   i:=1;
   repeat
    x:=readkey;
    if ord(x)<>13 then
    begin
    if (x='0') or (x='1')  then
      begin

    repeat

    val(x,b,k) ;
    If k<>0 then
    begin
    writeln('Povtori VVod');
    x:=readkey;
    end;
    until k=0;
    mM1[i]:=b;
    i:=i+1;
    kkk:=i-1;
    end else begin
             writeln('Povtori VVod');
             end;
    end;
   until (i>N) or (ord(x)=13);
    For i:=1 to kkk do
    write(mM1[i]);
    writeln;
    readln;
 end;
 procedure Menu;

 begin
 VVod(M1);
 Vvod(M2);

 clrscr;
 writeln('1 - slojenie');
 writeln('2 - vichitanie');
 writeln('0 - exit');
 readln(y);
  case y of
  1: sloj;
  2: vich;
  end;
 end;

begin
  repeat
   Menu
  until y=0;

end.