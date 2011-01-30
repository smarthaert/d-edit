Program pisch;
type
  A=^B;
  B=record
  inf:string;
  adr:A;
  end;

var
 beg,tek,pred:A;
 i:integer;
 el:string;

begin
  i:=1;
  while i<5 do
  begin
      if i=1 then
      begin
          new(tek);
          writeln('vvedite inf');
          readln(tek^.inf);
          tek^.adr:=nil;
          beg:=tek;
          pred:=tek;
          i:=i+1;
      end
      else begin
            new(tek);
            writeln('vvedite inf');
            readln(tek^.inf);
            tek^.adr:=nil;
            pred^.adr:=tek;
            pred:=tek;
            i:=i+1;
           end;
          end;
          tek:=beg;
      while tek<>nil do
      begin
          writeln (tek^.inf);
          tek:=tek^.adr;
      end;
      tek:=beg;
      writeln ('vvedite el');
      readln (el);
      while (tek<>nil) and (el<>tek^.inf) do
       begin
          pred:=tek;
          tek:=tek^.adr;
       end;
         if tek=nil then
         writeln('dannogo elementa net')
         else
          if tek=beg then
          { beg^.adr:=tek^.adr^.adr} else
           {tek^.adr:=tek^.adr^.adr;}

            tek:=beg;
            writeln ('vivod');
      while tek<>nil do
      begin
          writeln (tek^.inf);
          tek:=tek^.adr;
      end;
   readln
end.