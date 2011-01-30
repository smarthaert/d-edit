Uses
  UTankTypes in 'UTankTypes.pas',
  Classes,SysUtils;

{$APPTYPE CONSOLE}

Var I:Integer;
begin
  TankTypes.Load('Texts\Tanks.txt');
  Writeln(TankTypes.getType('Tiger2')^.Armor);
  Readln;
  TankTypes.Free;
end.