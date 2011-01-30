USES GRAPH,CRT;
VAR
    GD,GM:INTEGER;
PROCEDURE VETKA(X,Y,D:INTEGER;U:REAL);
VAR
    X1,Y1,D1:INTEGER;
    U1:REAL;
BEGIN
    IF D<5 THEN EXIT;
    IF D<8 THEN SETCOLOR(14)
     ELSE IF D<16 THEN SETCOLOR(2)
	   ELSE SETCOLOR(6);
    X1:=X+ROUND(D*SIN(U));
    Y1:=Y+ROUND(D*COS(U));
    LINE(X,Y,X1,Y1);
    D1:={ROUND(D/1.3)}D-ROUND(RANDOM(D)/1.7);
    U1:=0.1+RANDOM*1;
    VETKA(X1,Y1,D1,U+U1);
    VETKA(X1,Y1,D1,U-U1);
END;
BEGIN
    RANDOMIZE;
    GD:=DETECT;
    INITGRAPH(GD,GM,'c:\bp\bgi');
    IF GRAPHRESULT<>GROK THEN HALT(1);
    Repeat
      CLEARDEVICE;
      OutTextXY(0,0,'Press ESC to exit or any other key to continue');
      VETKA(120,340,60,2.5);
    Until ReadKey=#27;
END.
