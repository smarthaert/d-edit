uses CRT;

const
  ac = 1960; bc = 1141;

{ Наибольший общий делитель }
function GCD( const a,b,aa,ba,ab,bb:longint ):longint;
var m : longint; { Частное }
begin
  writeln(a:4,' ',b:4,'   ',
    aa,'*',ac,' + ',ba,'*',bc,'=',aa*ac+ba*bc,'  ',
    ab,'*',ac,' + ',bb,'*',bc,'=',ab*ac+bb*bc  );
  if b = 0 then begin
    { Запоминаем частное решение }
    GCD := a
  end else begin
    m := a div b;
    GCD := GCD(b,a mod b,ab,bb,aa-ab*m,ba-bb*m);
  end;
end;

begin
  ClrScr;
  { Расширенный алгоритм Евклида }
  GCD(ac,bc,1,0,0,1);
  {  }
end.