{ Игровой мир для Tanks2 }
Unit TankGame;

Interface

{ - Номеpа спpайтов на карте - }
Const
  sPusto   = 0;
  sWall    = 1;
  sIWall   = 2;
  sWater   = 6;
  sFire    = 7;
  sWFire   = 11;
  sBoom    = 143;
  sPlayer1 = 15;
  sPlayer2 = 79;
  sAnti    = 159;
  sAFire   = 223;
  sAWFire  = 227;
  sFireBonus      = 231;
  sSpeedFireBonus = 235;
  sLiveBonus = 239;
  sBombBonus = 243;

{ - Напpавления движения - }
Const
  dUp    = 0;
  dLeft  = 1;
  dDown  = 2;
  dRight = 3;
  dNo    = 4;
  dStop  = 255;

{ - Уровень - }
Var Level : Array [1..48,1..64] of Byte;

Implementation

End.