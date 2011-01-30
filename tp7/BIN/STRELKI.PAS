 program p;
 uses crt;
 var c:char;
     y:integer;
 begin
 clrscr;
    writeln('vvedite simvol');
    c:=readkey;
    y:=ord(c);
    if y=0 then begin
    c:=readkey;
    y:=ord(c);
  if y=72 then begin
  gotoxy (10,2);
  writeln('strelka vverh')
 end
  else if y=80 then
  begin
  gotoxy (10,10);
  writeln ('strelka vniz');
 end
  else
  if y= 77 then
  begin
  gotoxy (20,5);
  writeln('strelka vpravo')
  end
  ELSE
  IF y=75 then begin
  gotoxy (2,5);
  writeln ('strelka vlevo');
  end;
  end
  else begin
  gotoxy(2,40);
  writeln ('k');
  end;
 readln
end.

