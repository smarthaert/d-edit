program new;
uses crt;
type

     zapis=record
     name:string;
     rost:integer;
     sled:integer;
     end;
var beg:integer;
    i,j:integer;
    name:string;
    n,rost,k:integer;
    m:array[1..3] of zapis;
    a:zapis;
begin
  clrscr;
  for i:=1 to 3 do
  begin
  writeln('vvedite familiu,rost:');
  readln(name);
  m[i].name:=name;
  readln(rost);
  m[i].rost:=rost;
  m[i].sled:=0;
  end;{vvod}
   for j:=1 to 3 do
    begin
    for i:=1 to 4 do
    begin
     if m[i].name>m[j].name then
      begin
      a:=m[i];
      m[i]:=m[j];
      m[j]:=a;
      end;
    end;
    end; {sort}
   n:=m[1].rost;{beee}
  for j:=1 to 3 do
   begin
   for i:=1 to 3 do begin
   if m[i].sled=0 then
   begin
    if m[i+1].rost<n then
     begin
      n:=m[i+1].rost;
      m[i+1].sled:=-1;{?}
      k:=i+1;
      m[j].sled:=;
     end;
     end;
     beg:=i+1;

      {if m[j].sled=-1 then
         m[j].sled:=beg;}
     end;
   {while sled=0 and m[i].rost<n do
    begin

    end;}
    {if sled=0 and m[i].rost>n}

  end;
for i:=1 to 3 do
  begin
  writeln('vivod');
  writeln(m[i].name);
  writeln(m[i].rost);
  writeln(m[i].sled);
  end;{vivod}
 readkey;
end.