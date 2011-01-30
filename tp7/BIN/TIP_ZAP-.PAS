Program TIP_ZAPISEI;
uses crt;
type
      M = array [1..4] of real;
      A=record
        F:string;
        zp: M;

      end;

    var
      M2:array [1..3] of A;
      i,j : integer;

begin
clrscr;      for i:=1 to 3 do
       begin
          write ('vvedite familiy');
          readln (M2[i].F);
          write ('vvedite 4 ');
          for j:=1 to 4 do
           begin
              write ('zp');
              readln (M2[i].zp[j]);
           end;
       end;

    for i:=1 to 3 do
    begin
     write (M2[i].F:10, '   ');
      for j:=1 to 4 do
      begin
        write (M2[i].zp[j]:5:2);

      end;
      writeln;
    end;
end.