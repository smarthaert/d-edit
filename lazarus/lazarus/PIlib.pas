library PIlib;



function PIEV(precision:longint):extended;
var PI:extended;cnt:longint;
begin
PI:=4;
for cnt:=1 to precision do
    begin
      if (cnt mod 2)=1 then
         PI:=PI-(4/(1+cnt*2))
      else
         PI:=PI+(4/(1+cnt*2));
    end;
PIEV:=PI;
end;
exports
PIEV;

end.
