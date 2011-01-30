 uses parser,valuegrabber,sysutils;

 var grab:valueaccumulator;err,ident:string;psr:TInterpreter;

 begin
 psr.parse('function(1,2,3,4,5,666,7777,88888,90)',ident,err,grab);
 writeln(ident);
 while not grab.empty do writeln(grab.get.str);
 readln;
 end.
