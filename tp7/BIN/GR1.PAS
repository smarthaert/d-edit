 uses graph;
 var a,b,k,i:integer;
 begin
 a:=detect;
 initgraph(a,b,'d:\9361');
 k:=1;
 for i:=1 to 200 do
 begin
 line(1,2,120+k,178+k);
 k:=k*2*i
 end;
 end.
