uses CRT;

var i:integer;
begin
  for i:=1000 to 4000 do begin
    Sound((i*i) mod 400 + 1000);
    Delay(200);
  end;
  Delay(10000);
  NoSound;
end.