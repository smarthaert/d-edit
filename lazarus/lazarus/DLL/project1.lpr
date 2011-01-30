library PIlib;

{$mode objfpc}{$H+}

function PIEV(precision:longint):extended;
var PI:extended;cnt:longint;
begin
PI:=1;
for cnt:=1 to precision do
    begin
      if (cnt and 1)=1 then
         PI:=PI-(1/(3+cnt*2))
      else
         PI:=PI+(1/(3+cnt*2));
    end;
PIEV:=PI;
end;
exports
function PIEV;

end.
