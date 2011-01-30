var m, NOD, i, min, c: integer;
    a: array[1..100] of integer;
    found: boolean;

function GetNOD: integer;
  var i, d: integer;
  begin
    d:=0;
    for i:=1 to m do if a[i]<>0 then
      begin
        if d > 0 then begin
                        d:=0;
                        GetNOD:= d;
                        exit;
                      end;
        d:=a[i];
      end;
    GetNOD:= d;
  end;

function GetMin: integer;
  var min: integer;
  begin
    min:= 1;
    while a[min]=0 do inc(min);
    for i:= min + 1 to m do
      if (a[i]<>0) and (a[i]<a[min])
        then min:=i;
    GetMin:=min;
  end;

begin
  readln(m);
  for i:=1 to m do readln(a[i]);

  found:=false;
  repeat
    min:=GetMin;
    for i:=1 to m do
      if i<>min then a[i]:=a[i] mod a[min];
    NOD:=GetNOD;
  until NOD<>0;

  c:=0;
  for i:=1 to NOD do
    if NOD mod i = 0 then inc(c);

  writeln(c);

  for i:=1 to NOD do
    if NOD mod i = 0 then writeln(i);

  readln;
end.