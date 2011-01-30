library PIlib;
uses math;


function PIEV(precision:longint):extended;
var //PI:extended;cnt:longint;
      PI1,PI2,PI3:extended;cnt:longint;
begin
//первый способ
{PI:=4;
for cnt:=1 to precision do
    begin
      if (cnt mod 2)=1 then
         PI:=PI-(4/(1+cnt*2))
      else
         PI:=PI+(4/(1+cnt*2));
    end;
PIEV:=PI;}
//второй способ
PI1:=1/18;PI2:=1/57;PI3:=1/239;
for cnt:=1 to precision do
    begin
      if (cnt mod 2)=1 then
         PI1:=PI1-(power(PI1,1+cnt*2)/(1+cnt*2))
      else
         PI1:=PI1+(power(PI1,1+cnt*2)/(1+cnt*2));
      if (cnt mod 2)=1 then
         PI2:=PI2-(power(PI2,1+cnt*2)/(1+cnt*2))
      else
         PI2:=PI2+(power(PI1,1+cnt*2)/(1+cnt*2));
      if (cnt mod 2)=1 then
         PI3:=PI3-(power(PI1,1+cnt*2)/(1+cnt*2))
      else
         PI3:=PI3+(power(PI1,1+cnt*2)/(1+cnt*2));
    end;
PIEV:=12*PI1+8*PI2-5*PI3;

end;
exports
PIEV;

end.
