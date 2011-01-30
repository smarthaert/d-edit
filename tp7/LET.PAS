Program m1;
  uses crt;
  var a,b,c:integer;
begin
  writeln('‚¢¥¤¨ £®¤');
  readln(a);
  b:=a mod 100;
  if ((b>10) and (b<20)) then writeln('let')
  else
     begin
     b:=b mod 10;
     case b of
     1: writeln(a,'god');
     2: writeln(a,'goda');
     3: writeln(a,'goda') ;
     4: writeln(a,'goda');
     else writeln(a,'let');
     end;
     end;
  readln;
end.
