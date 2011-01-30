UNIT GLOBAL;

INTERFACE

uses x_graph,x_pcx,ctvoice;

CONST
       KEYBOARD_INT=$09; KEY_BUFFER=$60; KEY_CONTROL=$61; INT_CONTROL=$20;
       MAKE_RIGHT=77;    MAKE_LEFT=75;   MAKE_UP=72;      MAKE_DOWN=80;
       BREAK_RIGHT=205;  BREAK_LEFT=203; BREAK_UP=200;    BREAK_DOWN=208;
       INDEX_UP=0;       INDEX_DOWN=1;   INDEX_RIGHT=2;   INDEX_LEFT=3;
       OVERBOARD=52;                     INTERSECTION_FOUND=1;
       MAX_SCALE=200;        WINDOW_HEIGHT=192;         WINDOW_MIDDLE=116;
       VERTICAL_SCALE=13312;
       ANGLE_0=0;    ANGLE_1=5;   ANGLE_2=10;   ANGLE_4=20;   ANGLE_5=25;
       ANGLE_6=30;   ANGLE_15=80; ANGLE_30=160; ANGLE_45=240; ANGLE_60=320;
       ANGLE_90=480;           ANGLE_135=720;           ANGLE_180=960;
       ANGLE_225=1200;         ANGLE_270=1440;          ANGLE_315=1680;
       ANGLE_360=1919;
       WORLD_ROWS=64;           WORLD_COLUMNS=64;
       CELL_X_SIZE=64;         CELL_Y_SIZE=64;          CELL_X_SIZE_FP=6;
       CELL_Y_SIZE_FP=6;
       WORLD_X_SIZE=(WORLD_COLUMNS * CELL_X_SIZE);
       WORLD_Y_SIZE=(WORLD_ROWS    * CELL_Y_SIZE);

TYPE
   enemy_info=record
         numhp,curframe,xpos,ypos,daminflict:byte
   end;
   enemypointer=^enemyrec;
   enemyrec=record
      enemy:enemy_info;
      link:enemypointer;
   end;

VAR  curpageoff:word;
     enemies:enemypointer;

IMPLEMENTATION
BEGIN
END.