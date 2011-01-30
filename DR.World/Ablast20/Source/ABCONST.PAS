{-= Constants for Alien Blaster initallization =-}

Type  {events}
      EventType = (NoEvent, LevelCompleted, GameHalted, GameOver, LastLevelCompleted);

Const
      {information}
      LastUpdate = ' (22 Feb. 1999)';
      GameTitle = 'Alien Blaster v2.0';
      Programmer = 'Peter Moraliyski';
      EMail = 'ppm@freemail.c3.hu';
      WebPage = 'http://members.xoom.com/moraliyski/';
      {miscellaneous}
      Success = 0;
      DefaultLifes = 3;
      Speed = 127;
      GraphicsMode = $13;
      TextMode = $3;
      {error codes}
      CantLoadLevel = 1;
      FileNotFound = 2; {I/O code}
      CantCreateFile = 3;
      NotEnoughMemory = 4;
      CantOpenFile = 5;
      {grahical stuff}
      Vga = $A000;
      Display : pointer = Ptr(Vga, 0000);
      ScreenWidth = 319;
      ScreenHeight = 199;
      BufferSize = (ScreenWidth + 1) * (ScreenHeight + 1);
      {resources}
      SettingsFile = 'ablast.cfg';
      LevelFile = 'ablevel.';
      BackgroundPcx = 'data\backgrnd.pcx';
      ExplosionPcx = 'data\explode.pcx';
      PlayerPcx = 'data\player.pcx';
      PlayerBulletPcx = 'data\pbullet.pcx';
      EnemyPcx = 'data\enemy.pcx';
      EnemyBulletPcx = 'data\ebullet.pcx';
      FontPcx = 'data\font.pcx';
      {keys}
      kExtended = #0;
      kYes = 'Y'; kNo = 'No'; kPlus = '+'; kMinus = '-';  kEsc = #27; kEnter = #13;
      kCtrl = #29; kAlt = #56; kTab = #15; kLShift = #42; kRShift = #54;
      kUp = #72; kDown = #80; kLeft = #75; kRight = #77;
      kIns = #82; kDel = #83; kHome = #71; kEnd = #79; kPgUp = #73; kPgDn = #81;
      kF1 = #59; kF2 = #60; kF3 = #61; kF4 = #62; kF5 = #63; kF6 = #64;
      kF7 = #65; kF8 = #66; kF9 = #67; kF10 = #68; kF11 = #87; kF12 = #88;