{$APPTYPE CONSOLE}

var a,b : longint;
begin
  assign(input,'in.txt'); reset(input);
  assign(output,'out.txt'); rewrite(output);
  read(a,b);
  write(a+b);
end.