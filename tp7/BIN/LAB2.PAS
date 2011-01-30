unit lab2;
interface
uses crt;

type a=^b;
     b=record
       dannie:string;
       vozr:integer;
       adr:a;
     end;

var
 beg, list,l,l2,l3,l4:a;
 p:pointer; {peremennay ykazatel}
 c:char;
 s,t,k,dannie:string;
 m,n,i,j,f,vozr:integer;
procedure vvod;
procedure vivod;
procedure menu;
procedure zadanie1;
procedure zadanie2;
procedure zadanie3;
procedure zadanie4;
procedure zadanie5;

implementation

  procedure vvod;
  {var i,n,vozr:integer;
      dannie:string;}
  begin
   clrscr;
   writeln('vvedite kolichestvo zapisey');
   readln(n);
   new(list);
   beg:=list;
   writeln('vvod pervogo elementa (imya)');
   readln(dannie);
   writeln('vvedite vozrast');
   readln(vozr);
   list^.dannie:=dannie;
   list^.vozr:=vozr;
   list^.adr:=nil;
   beg:=list;
   l:=list;
   {sozdanie pervogo elementa}
   i:=2;
    while i<>(n+1) do
     begin
     writeln('vvedite',i,'-imya');
     readln(dannie);
     writeln('vvedite vozrast');
     readln(vozr);
     new(list);
     list^.dannie:=dannie;
     list^.vozr:=vozr;
     list^.adr:=nil;
     l^.adr:=list;
     l:=list;
     inc(i);
     end;
     end;

 procedure vivod;
  begin
   clrscr;
   list:=beg;
   writeln('dannie na etot moment:');
    while list<>nil do
     begin
      writeln(list^.dannie);
      writeln(list^.vozr);
      list:=list^.adr;
     end;
  end;
 procedure zadanie1;
 begin
 clrscr;
  writeln('vvedite kolichestvo elementov');
  readln(n);
  writeln('vvedite znachenie i nomer elementa pered kotorim neobhodima vstavka');
  readln(s);
  readln(f);
   for i:=0 to (n-1) do
    begin
     write('vvedite element dlya vstavki i nomer');
     readln(t);
     readln(j);
     list:=beg;
      while list<>nil do
       begin
	if (list^.dannie=s) and (list^.vozr=f) then
	 begin
	  k:=list^.dannie;
	  m:=list^.vozr;
	  list^.dannie:=t;
	  list^.vozr:=j;
	  new(l);
	  l^.adr:=list^.adr;
	  list^.adr:=l;
	  l^.dannie:=k;
	  l^.vozr:=m;
	  break;
	 end;
	 list:=list^.adr;
       end;
    end;
 vivod;
 end;
 procedure zadanie2;
  begin
   clrscr;
   s:=beg^.dannie;
   m:=beg^.vozr;
{write('vvedite znachenie pervogo');
   readln(s);}
   write('vvedite znachenie  elementa');
   readln(t);
   writeln('vvedite vozrast');
   readln(j);
   beg^.dannie:=t;
   beg^.vozr:=j;

	  new(l);
	  l^.adr:=list^.adr;
	  list^.adr:=l;
	  l^.dannie:=s;
	  l^.vozr:=m;
    vivod;
  end;
 procedure zadanie3;
begin
  beg:=nil;
  vivod;
  {list:=beg;
  while list^.adr<>nil do
  begin
   p:=list^.adr;
   dispose(list);
   list:=p;
  end;
  write('spisok yspeshno ydalen');
  writeln;}
end;
procedure zadanie4;
 begin
   clrscr;
   writeln('chto bydem iskat');
   readln(s);
   writeln('nomer');
   readln(j);
   n:=0;
   m:=0;
   list:=beg;
    while list<>nil do
     begin
      inc(n);
       if (list^.dannie=s) and (list^.vozr=j) then
	begin
	inc(m);
	writeln('iskomiy element nayden i imeet nomer=',n);
	end;
	list:=list^.adr;

     end;
     if m=0 then writeln('v etom spiske net takogo elementa');
 end;
 procedure zadanie5;
begin
 list:=beg;
 l2:=beg;
 l3:=beg;
  while l2^.adr<>nil do
   begin
    l3:=l3^.adr;
    l4:=l3^.adr;
     if l2^.dannie>l3^.dannie then
      begin
       list:=beg;
       l:=beg;
	while (list<>l2) and (l3^.dannie>list^.dannie) do
	 begin
	  l:=list;
	  list:=list^.adr;
	 end;
	if list=beg then
	begin
	 beg:=l3;
	 beg^.adr:=list;
	 l2^.adr:=l4;
	end
	else
	 if l3^.dannie<list^.dannie then
	  begin
	   list:=l3;
	   list^.adr:=l^.adr;
	   l^.adr:=list;
	   l2^.adr:=l4;
	  end
	   else if list=l2 then
	    begin
	    list:=l3;
	    l^.adr:=list;
	    list^.adr:=l2;
	    l2^.adr:=l4;
	    end;
      end
      else
      l2:=l3;
   end;
      vivod;
   end;
 procedure menu;
 begin
 writeln('viberite neobhodimoe deystvie');
 writeln('1-vstavka zadannogo chisla elementov pered elementom imeushim zadannoe znachenie');
 writeln('2-zamena pervogo elementa s vvedennim elementom');
 writeln('3-ydalenie spiska');
 writeln('4-poisk elementa s zadannim znacheniem');
 writeln('5-yporyadochit spisok');
 writeln('6-exit');
  readln(m);
  case m of
  1: begin zadanie1;menu; end;
  2: begin zadanie2;menu; end;
  3: begin zadanie3; readkey; end;
  4: begin zadanie4;menu; end;
  5: begin zadanie5;menu; end;
  6:begin exit; end;
 end;
end;
end.