{ Turbo Pascal - Занятие 4. Рисование простеших примитивов }
uses graph;
var a,b:integer;
begin
  a:=detect;
  initgraph(a,b,'');
  line (20,20,200,200);
end.