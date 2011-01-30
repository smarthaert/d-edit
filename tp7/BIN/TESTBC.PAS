program Tester;
{Выполнили студенты гр. 8362 Буков М.В., Белов В.А.}
uses Crt, bicontre;
var i,n,c: integer;

procedure Generate(n,r:integer);
var m: integer;
    u,v:vert;
begin
     Create;
     if r=1 then m:=n*(n-1) div 2;
     if r=2 then m:=n-1;
     if r=3 then m:=n-2;
     Randomize;

     if (r=1) or (r=3) then begin
     for i:=1 to m do begin
         repeat
               u:=Random(n)+1;
               v:=Random(n)+1;
         until not SearchAdj(u,v) and (u<>v);
         Add(Adj[u],v);
         Add(Adj[v],u);
     end;
     end else begin
     u:=Random(n)+1;
     for i:=1 to m do begin
         repeat
               v:=Random(n)+1;
         until not SearchAdj(u,v) and (u<>v);
         Add(Adj[u],v);
         Add(Adj[v],u);
     end;

     end;
     SaveAdjList(Adj,'INBICON2.txt');
end;
begin
     c:=0;
     ClrScr;
     while c<>2 do begin
     ClrScr;
     Writeln('Считывание из файла (1) или генерация (2)?');
     repeat Readln(i); until (i=1) or (i=2);
     if i=1 then ReadAdjList('INBICON.txt') else begin
     Writeln('Связность: сильная (1), слабая (2) или средняя (3)?');
     repeat Readln(i); until (i=1) or (i=2) or (i=3);
     Writeln('Сколько вершин (до 9)?');
     repeat Readln(n); until (n>0) and (n<10);
     Generate(n,i);
     end;
     ShowAdjList(Adj);
     Writeln('Компоненты связности:');
     for i:=1 to nMax do numvert[i]:=0;
     iv:=0;
     stk:=nil;
     nm:='';
     for i:=1 to nMax do if numvert[i]=0 then BICON(i,i);
     Writeln('Попробуем еще раз (1) или выходим (2)?');
     repeat Readln(c); until (c=1) or (c=2);
     end;
end.