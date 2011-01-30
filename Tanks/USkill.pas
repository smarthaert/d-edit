unit USkill;

interface

Const
  ConstMaxVisibleEnemies=40;

Var GameSkill:Integer;

Function EnemySpawnCount:Integer;
Function EnemySpawnTime:Integer;
Function CalcMaxVisibleEnemies:Integer;

implementation

Function EnemySpawnCount:Integer;
Var
  I:Integer;
  R:Real;
Begin
  If GameSkill<5 then
    Begin
      Result:=GameSkill;
      Exit;
    End;
  R:=5;
  For I:=6 to GameSkill do
    R:=(R*1.2);
  Result:=Trunc(R);
End;

Function EnemySpawnTime:Integer;
Var I:Integer;
Begin
  Result:=30000;
  For I:=2 to GameSkill do
    Result:=(Result*3) Div 4;
End;

Function CalcMaxVisibleEnemies:Integer;
Begin
  Result:=5*GameSkill;
  If Result>ConstMaxVisibleEnemies then
    Result:=ConstMaxVisibleEnemies;
End;

end.
