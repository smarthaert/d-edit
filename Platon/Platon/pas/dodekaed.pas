{17.01.99 }

 Uses Graph,Crt,Dos;

{°°°°° Utilities }

 Const
  Cr    = #13#10;
  CRight  = 'M';
  CUp     = 'H';
  CEnter  = #13;
  CLeft   = 'K';
  CDown   = 'P';
  CExit   = #27;
 Mask:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

{ procedure Beep;
begin
 Sound(300); Delay(25); NoSound;
end;}

 procedure ErrHalt(s:string);
begin
 Write(Cr+'Errow '+s); Halt;
end;

 Var x0,y0,Dx,Dy:word;

 procedure OpenEGAHi(Path:string);
 var Driver,Mode:integer;
begin
 Driver:=Vga;
 Mode:=EGAHi;
 Initgraph(Driver,Mode,Path);
 putpixel(640,350,15);
 if graphresult<>0 then
 Errhalt('InitGraph: it"s need Graph.bgi of Turbo-Pascal 6.0');
 x0:=Getmaxx div 2; y0:=Getmaxy div 2;
end;

{°°°°° Screen }

 const AttrAct = Black;
 const AttrPas = LightGreen;
 const AttrKey = Cyan;
 const AttrScr = Green;
 const AttrShad = DarkGray;

 const XScr = 40;   YScr = 20;
 const DXScr = 160; DYScr = 320;

 procedure ClrKey(x1,y1,x2,y2:word);
begin
 SetFillStyle(SolidFill,AttrScr);
 Bar(x1,y1,x1+x2,y1+y2);
end;

 procedure ShowKey(x1,y1,x2,y2:word);
begin
 SetColor(LightGray);
 Rectangle(x1,y1,x1+x2-1,y1+y2-1);
 SetColor(Black);
 Rectangle(x1+1,y1+1,x1+x2,y1+y2);
 SetFillStyle(SolidFill,AttrKey);
 Bar(x1+1,y1+1,x1+x2-1,y1+y2-1);
end;

 procedure KeyRealize(Act,x1,y1,x2,y2:word;s:string);
begin
 ClrKey(XScr+x1,YScr+y1,x2,y2);
 SetFillStyle(SolidFill,AttrShad);
 Bar(XScr+x1+3,YScr+y1+3,XScr+x1+x2-0,YScr+y1+y2-0);
 ShowKey(XScr+x1+0,YScr+y1+0,x2-3,y2-3);
 if Act=0 then SetColor(AttrPas)
          else SetColor(AttrAct);
 OutTextXY(XScr+x1+10,YScr+y1+10,s);
end;

 procedure KeyPress(x1,y1,x2,y2:word;s:string);
begin
 ClrKey(XScr+x1,YScr+y1,x2,y2);
 ShowKey(XScr+x1+3,YScr+y1+3,x2-3,y2-3);
 OutTextXY(XScr+x1+13,YScr+y1+13,s);
end;

{°°°°° Interface }

 Const Names:array[1..10] of string = (
 '3T 3-Tetraedre',
 '3C 3-Cube',
 '3O 3-Octaedre',
 '4T 4-Tetraedre',
 '4O 4-Octaedre',
 '4L 4-24Loop',
 '4C 4-Cube',
 '5C 5-Cube',
 '6C 6-Cube',
 '3I 3-Icosaedr');

 procedure SetPages(P1,P2:byte);
begin
 SetActivePage(P1);
 SetVisualPage(P2);
end;

 procedure InitScr;
 var n:byte;
begin
 SetPages(0,1);
 ClrKey(XScr,YScr,DXScr,DYScr);
 Rectangle(XScr,YScr,DXScr+XScr,DYScr+YScr);
 Rectangle(XScr,YScr,DXScr+XScr,  30 +YScr);
 OutTextXY(XScr+30,YScr+10,'P l a t o n');
 for n:=0 to 8 do
 KeyRealize(0,10,40+30*n,140,30,Names[n+1]);
 SetPages(0,0);
end;

 function Menu:byte;
 var Ch:Char; Cursor:Integer;
begin
 Menu:=0; Cursor:=0; Ch:=' ';
 repeat
  KeyRealize(1,10,40+30*Cursor,140,30,Names[Cursor+1]);
  Ch := ReadKey;
  KeyRealize(0,10,40+30*Cursor,140,30,Names[Cursor+1]);
  case Ch of
   #0: case ReadKey of
       CUp,CLeft:    Dec(Cursor);
       CRight,CDown: Inc(Cursor);
       end;
  '3': case ReadKey of
       't','T': Cursor:=0;
       'o','O': Cursor:=2;
       'c','C': Cursor:=1;
       end;
  '4': case ReadKey of
       't','T': Cursor:=3;
       'o','O': Cursor:=4;
       'c','C': Cursor:=6;
       'l','L': Cursor:=5;
       end;
  '5': case ReadKey of
       'c','C': Cursor:=7;
       end;
  '6': case ReadKey of
       'c','C': Cursor:=8;
       end;
   CExit: exit;
  end;
  Cursor:=(Cursor+9) mod 9;
{  Beep;}
 until Ch=CEnter;
 KeyPress(10,40+30*Cursor,140,30,'T3 3-Tetraedre');
 Menu:=Cursor+1;
end;

{°°°°°°°°° Geometry Definitions }

 Const
 MaxDimSpace = 6;
 MaxDimNods  = 96;
 MaxDimLoops = 200;
 DimAngle = 1000;

 Type
 TP = array[1..MaxDimSpace] of real;
 TPoints = array[1..MaxDimNods] of TP;

 Var
 DimSpace:byte;
 DimNods:byte;
 DimLoops:byte;
 DimPlanes:byte;
 W:TPoints;
 Loops:array[1..MaxDimLoops,1..2] of byte;
 Rotate: array[1..MaxDimSpace,1..MaxDimSpace] of real;

{°°°°°°°°° Geometry Data }

 const
 DS:array[1..10] of byte = (4, 3, 3, 5, 4, 4, 4, 5,  6, 3); {  §¬¥p­®áâ¨  }
 DN:array[1..10] of byte = (4, 8, 6, 5, 8,24,16,32, 64,20); { —¨á«  ¢¥pè¨­ }
 DL:array[1..10] of byte = (6,12,12,10,24,96,32,80,192,30); { —¨á«  pñ¡¥p  }
 DP:array[1..10] of byte = (4, 6, 8, 4, 8, 8, 6, 6,  6,12); { —¨á«  £p ­¥© }
 DD:array[1..10] of byte = (3, 4, 3, 3, 3, 3, 4, 4,  4, 3); {  §¬¥p­®áâ¨ ¬­®£®ã£®«ì­¨ª®¢ }

 { Œ áèâ ¡ }
 Const Disp:array[1..10] of word =
 ( 50,100,170,40,180,120, 80, 80, 80, 10);

 { H ç «ì­®¥ ¢p é¥­¨¥ }
 Const XT:array[1..10,1..4] of byte =
 ((1,2,3,2),(1,2,1,2),(1,2,1,2),
  (1,2,3,1),(1,2,1,2),(1,2,1,2),
  (1,2,3,2),(1,1,2,1),(1,2,3,1),
  (1,2,3,1));

 Const YT:array[1..10,1..4] of byte =
 ((4,4,4,3),(3,3,2,3),(3,3,2,3),
  (4,4,4,3),(4,4,2,3),(4,4,3,3),
  (4,4,4,3),(5,4,5,3),(6,5,4,3),
  (6,5,4,3));

 Const RT:array[1..10,1..4] of real =
 ((pi/6,pi/7,-pi/8,0),
  (pi/6,pi/7,-pi/9,pi/8),
  (pi/6,pi/7,-pi/9,0),
  (pi/6,pi/7,-pi/9,pi/7),
  (pi/6,pi/7,-pi/9,0),
  (pi/6,pi/7,-pi/9,0),
  (pi/6,pi/7,-pi/9,0),
  (pi/6,pi/7,-pi/9,0),
  (pi/6,pi/7,-pi/9,pi/7),
  (pi/6,pi/7,-pi/9,pi/7));

 { ’¥ªãé¥¥ ¢p é¥­¨¥ }
 Const TX:array[1..10,1..4] of byte =
 ((1,2,3,2),(1,2,3,2),(1,2,1,2),
  (1,2,3,4),(1,2,3,2),(1,2,1,2),
  (1,2,3,2),(1,2,3,4),(1,2,1,2),
  (1,2,1,2));

 Const TY:array[1..10,1..4] of byte =
 ((4,4,4,3),(2,3,1,3),(2,3,3,3),
  (5,5,5,5),(4,4,1,3),(4,3,2,2),
  (4,4,4,3),(5,5,5,5),(6,4,5,3),
  (6,4,5,3));

 Const TR:array[1..10,1..4] of real =
 ((1/DimAngle,-1/DimAngle,1/DimAngle,0),
  (1/DimAngle,-1/DimAngle,1/DimAngle,0),
  (1/DimAngle,-1/DimAngle,1/DimAngle,0),
  (1/DimAngle,-1/DimAngle,1/DimAngle,0),
  (1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle),
  (1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle),
  (1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle),
  (1/DimAngle,-1/DimAngle,1/DimAngle,0),
  (1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle),
  (1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle));

 Const Paterns:array[1..9] of FillPatternType =
(($77,$DD,$77,$DD,$77,$DD,$77,$DD),
 ($AA,$55,$AA,$55,$AA,$55,$AA,$55),
 ($99,$66,$99,$66,$99,$66,$99,$66),
 ($88,$22,$88,$22,$88,$22,$88,$22),
 ($AA,$55,$AA,$55,$AA,$55,$AA,$55),
 ($99,$66,$99,$66,$99,$66,$99,$66),
 ($88,$22,$88,$22,$88,$22,$88,$22),
 ($AA,$55,$AA,$55,$AA,$55,$AA,$55),
 ($77,$DD,$77,$DD,$77,$DD,$77,$DD));

{°°°°      ¨p ¬¨¤ -3    }

 Const T3:array[1..4,1..4] of integer =
(( 1, 1, 1,-3),
 ( 1, 1,-3, 1),
 ( 1,-3, 1, 1),
 (-3, 1, 1, 1));

 Const LT3:array[1..6,1..2] of byte =
 ((1,2),(1,3),(1,4),(2,3),(2,4),(3,4));

 Const PT3:array[1..4,1..3] of byte =
 ((1,2,3),(1,3,4),(1,4,2),(2,4,3));

 Const AT3:array[1..4] of byte =
 (red,magenta,blue,cyan);

 Const BT3:array[1..4] of byte =
 (1,2,3,5);

{°°°°      Šã¡¨ª-3    }

 Const C3:array[1..8,1..3] of integer =
 ((-1,-1,-1),(-1,-1, 1),
  (-1, 1,-1),(-1, 1, 1),
  ( 1,-1,-1),( 1,-1, 1),
  ( 1, 1,-1),( 1, 1, 1));

 Const LC3:array[1..12,1..2] of byte =
 ((1,2),(1,3),(2,4),(3,4),
  (1,5),(2,6),(3,7),(4,8),
  (5,6),(5,7),(6,8),(7,8));

 Const PC3:array[1..6,1..4] of byte =
 ((1,2,4,3),(1,5,6,2),(1,3,7,5),
  (3,4,8,7),(2,6,8,4),(5,7,8,6));

 Const AC3:array[1..6] of byte =
 (red,magenta,blue,cyan,green,brown);

 Const BC3:array[1..6] of byte =
 (1,2,3,4,5,6);

{°°°°      Žªâ í¤p-3    }

 Const O3:array[1..6,1..3] of integer =
(( 1, 0, 0),(-1, 0, 0),
 ( 0, 1, 0),(-0,-1, 0),
 ( 0, 0, 1),(-0, 0,-1));

 Const LO3:array[1..12,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),
 ( 2, 3),( 2, 4),( 2, 5),( 2, 6),
 ( 3, 5),( 3, 6),( 4, 5),( 4, 6));

 Const PO3:array[1..8,1..3] of byte =
 ((1,6,4),(1,4,5),(1,5,3),(2,5,4),
  (3,5,2),(2,4,6),(1,3,6),(2,6,3));

 Const AO3:array[1..8] of byte =
 (red,magenta,blue,cyan,
  red,magenta,blue,cyan);

 Const BO3:array[1..8] of byte =
 (1,2,3,4,5,6,7,8);

{°°°°      ¨p ¬¨¤ -4    }

 Const T4:array[1..5,1..5] of integer =
 (( 1, 1, 1, 1,-4),
  ( 1, 1, 1,-4, 1),
  ( 1, 1,-4, 1, 1),
  ( 1,-4, 1, 1, 1),
  (-4, 1, 1, 1, 1));

 Const LT4:array[1..10,1..2] of byte =
 ((1,2),(1,3),(2,3),(2,4),(3,4),
  (3,5),(4,5),(4,1),(5,1),(5,2));

 Const PT4:array[1..4,1..3] of byte =
 ((1,2,3),(1,3,4),(1,4,2),(2,4,3));

 Const AT4:array[1..4] of byte =
 (red,magenta,blue,cyan);

 Const BT4:array[1..4] of byte =
 (1,2,3,5);

{°°°°      Žªâ í¤p-4    }

 Const O4:array[1..8,1..4] of integer =
 (( 1, 0, 0, 0),(-1, 0, 0, 0),
  ( 0, 1, 0, 0),( 0,-1, 0, 0),
  ( 0, 0, 1, 0),( 0, 0,-1, 0),
  ( 0, 0, 0, 1),( 0, 0, 0,-1));

 Const LO4:array[1..24,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1, 7),( 1, 8),
 ( 2, 3),( 2, 4),( 2, 5),( 2, 6),( 2, 7),( 2, 8),
 ( 3, 5),( 3, 6),( 3, 7),( 3, 8),( 4, 5),( 7, 6),
 ( 4, 6),( 4, 7),( 4, 8),( 5, 7),( 5, 8),( 6, 8));

 Const PO4:array[1..8,1..3] of byte =
 ((1,6,4),(1,4,5),(1,5,3),(2,5,4),
  (3,5,2),(2,4,6),(1,3,6),(2,6,3));

 Const AO4:array[1..8] of byte =
 (red,magenta,blue,cyan,
  red,magenta,blue,cyan);

 Const BO4:array[1..8] of byte =
 (1,2,3,4,5,6,7,8);

{°°°°      24-ïç¥©ª     }

 Const L4:array[1..24,1..4] of integer =
 (( 1, 1, 0, 0),( 1,-1, 0, 0),
  ( 1, 0, 1, 0),( 1, 0,-1, 0),
  ( 1, 0, 0, 1),( 1, 0, 0,-1),
  (-1, 1, 0, 0),(-1,-1, 0, 0),
  (-1, 0, 1, 0),(-1, 0,-1, 0),
  (-1, 0, 0, 1),(-1, 0, 0,-1),
  ( 0, 1, 1, 0),( 0, 1,-1, 0),
  ( 0, 1, 0, 1),( 0, 1, 0,-1),
  ( 0, 0, 1, 1),( 0, 0, 1,-1),
  ( 0,-1, 1, 0),( 0,-1,-1, 0),
  ( 0,-1, 0, 1),( 0,-1, 0,-1),
  ( 0, 0,-1, 1),( 0, 0,-1,-1));

 Const LL4:array[1..96,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1,13),
 ( 1,14),( 1,15),( 1,16),( 2, 3),( 2, 4),
 ( 2, 5),( 2, 6),( 2,19),( 2,20),( 2,21),
 ( 2,22),( 3, 5),( 3, 6),( 3,13),( 3,17),
 ( 3,18),( 3,19),( 4, 5),( 4, 6),( 4,14),
 ( 4,20),( 4,23),( 4,24),( 5,15),( 5,17),
 ( 5,21),( 5,23),( 6,16),( 6,18),( 6,22),
 ( 6,24),( 7, 9),( 7,10),( 7,11),( 7,12),
 ( 7,13),( 7,14),( 7,15),( 7,16),( 8, 9),
 ( 8,10),( 8,11),( 8,12),( 8,19),( 8,20),
 ( 8,21),( 8,22),( 9,11),( 9,12),( 9,13),
 ( 9,17),( 9,18),( 9,19),(10,11),(10,12),
 (10,14),(10,20),(10,23),(10,24),(11,15),
 (11,17),(11,21),(11,23),(12,16),(12,18),
 (12,22),(12,24),(13,15),(13,16),(13,17),
 (13,18),(14,15),(14,16),(14,23),(14,24),
 (15,17),(15,23),(16,18),(16,24),(17,19),
 (17,21),(18,19),(18,22),(19,21),(19,22),
 (20,21),(20,22),(20,23),(20,24),(21,23),
 (22,24));

 Const PL4:array[1..8,1..3] of byte =
 ((1,6,4),(1,4,5),(1,5,3),(2,5,4),
  (3,5,2),(2,4,6),(1,3,6),(2,6,3));

 Const AL4:array[1..8] of byte =
 (red,magenta,blue,cyan,
  red,magenta,blue,cyan);

 Const BL4:array[1..8] of byte =
 (1,2,3,4,5,6,7,8);

{°°°°      Šã¡¨ª-4    }

 Const C4:array[1..16,1..4] of integer =
 ((-1,-1,-1,-1),(-1,-1, 1,-1),
  (-1, 1,-1,-1),(-1, 1, 1,-1),
  ( 1,-1,-1,-1),( 1,-1, 1,-1),
  ( 1, 1,-1,-1),( 1, 1, 1,-1),
  (-1,-1,-1, 1),(-1,-1, 1, 1),
  (-1, 1,-1, 1),(-1, 1, 1, 1),
  ( 1,-1,-1, 1),( 1,-1, 1, 1),
  ( 1, 1,-1, 1),( 1, 1, 1, 1));

 Const LC4:array[1..32,1..2] of byte =
(( 1, 2),( 1, 3),( 2, 4),( 3, 4),
 ( 1, 5),( 2, 6),( 3, 7),( 4, 8),
 ( 5, 6),( 5, 7),( 6, 8),( 7, 8),
 ( 1, 9),( 2,10),( 3,11),( 4,12),
 ( 5,13),( 6,14),( 7,15),( 8,16),
 ( 9,10),( 9,11),(10,12),(11,12),
 ( 9,13),(10,14),(11,15),(12,16),
 (13,14),(13,15),(14,16),(15,16));

 Const PC4:array[1..6,1..4] of byte =
 ((1,2,4,3),(1,5,6,2),(1,3,7,5),
  (3,4,8,7),(4,2,6,8),(5,7,8,6));

 Const AC4:array[1..6] of byte =
 (red,magenta,blue,cyan,green,brown);

 Const BC4:array[1..6] of byte =
 (1,2,3,4,5,6);

{°°°°      Šã¡¨ª-5    }

 Const C5:array[1..32,1..5] of integer =
 ((-1,-1,-1,-1,-1),(-1,-1,-1,-1, 1),
  (-1,-1,-1, 1,-1),(-1,-1,-1, 1, 1),
  (-1,-1, 1,-1,-1),(-1,-1, 1,-1, 1),
  (-1,-1, 1, 1,-1),(-1,-1, 1, 1, 1),
  (-1, 1,-1,-1,-1),(-1, 1,-1,-1, 1),
  (-1, 1,-1, 1,-1),(-1, 1,-1, 1, 1),
  (-1, 1, 1,-1,-1),(-1, 1, 1,-1, 1),
  (-1, 1, 1, 1,-1),(-1, 1, 1, 1, 1),
  ( 1,-1,-1,-1,-1),( 1,-1,-1,-1, 1),
  ( 1,-1,-1, 1,-1),( 1,-1,-1, 1, 1),
  ( 1,-1, 1,-1,-1),( 1,-1, 1,-1, 1),
  ( 1,-1, 1, 1,-1),( 1,-1, 1, 1, 1),
  ( 1, 1,-1,-1,-1),( 1, 1,-1,-1, 1),
  ( 1, 1,-1, 1,-1),( 1, 1,-1, 1, 1),
  ( 1, 1, 1,-1,-1),( 1, 1, 1,-1, 1),
  ( 1, 1, 1, 1,-1),( 1, 1, 1, 1, 1));

 Const LC5:array[1..80,1..2] of byte =
(( 1, 2),( 1, 3),( 1, 5),( 1, 9),( 1,17),
 ( 2, 4),( 2, 6),( 2,10),( 2,18),( 3, 4),
 ( 3, 7),( 3,11),( 3,19),( 4, 8),( 4,12),
 ( 4,20),( 5, 6),( 5, 7),( 5,13),( 5,21),
 ( 6, 8),( 6,14),( 6,22),( 7, 8),( 7,15),
 ( 7,23),( 8,16),( 8,24),( 9,10),( 9,11),
 ( 9,13),( 9,25),(10,12),(10,14),(10,26),
 (11,12),(11,15),(11,27),(12,16),(12,28),
 (13,14),(13,15),(13,29),(14,16),(14,30),
 (15,16),(15,31),(16,32),(17,18),(17,19),
 (17,21),(17,25),(18,20),(18,22),(18,26),
 (19,20),(19,23),(19,27),(20,24),(20,28),
 (21,22),(21,23),(21,29),(22,24),(22,30),
 (23,24),(23,31),(24,32),(25,26),(25,27),
 (25,29),(26,28),(26,30),(27,28),(27,31),
 (28,32),(29,30),(29,31),(30,32),(31,32));

 Const PC5:array[1..6,1..4] of byte =
 ((1,2,4,3),(1,5,6,2),(1,3,7,5),
  (3,4,8,7),(2,6,8,4),(5,7,8,6));

 Const AC5:array[1..6] of byte =
 (red,magenta,blue,cyan,green,brown);

 Const BC5:array[1..6] of byte =
 (1,2,3,4,5,6);

{°°°°      Šã¡¨ª-6    }

 Const C6:array[1..64,1..6] of integer =
 ((-1,-1,-1,-1,-1,-1),(-1,-1,-1,-1,-1, 1),
  (-1,-1,-1,-1, 1,-1),(-1,-1,-1,-1, 1, 1),
  (-1,-1,-1, 1,-1,-1),(-1,-1,-1, 1,-1, 1),
  (-1,-1,-1, 1, 1,-1),(-1,-1,-1, 1, 1, 1),
  (-1,-1, 1,-1,-1,-1),(-1,-1, 1,-1,-1, 1),
  (-1,-1, 1,-1, 1,-1),(-1,-1, 1,-1, 1, 1),
  (-1,-1, 1, 1,-1,-1),(-1,-1, 1, 1,-1, 1),
  (-1,-1, 1, 1, 1,-1),(-1,-1, 1, 1, 1, 1),
  (-1, 1,-1,-1,-1,-1),(-1, 1,-1,-1,-1, 1),
  (-1, 1,-1,-1, 1,-1),(-1, 1,-1,-1, 1, 1),
  (-1, 1,-1, 1,-1,-1),(-1, 1,-1, 1,-1, 1),
  (-1, 1,-1, 1, 1,-1),(-1, 1,-1, 1, 1, 1),
  (-1, 1, 1,-1,-1,-1),(-1, 1, 1,-1,-1, 1),
  (-1, 1, 1,-1, 1,-1),(-1, 1, 1,-1, 1, 1),
  (-1, 1, 1, 1,-1,-1),(-1, 1, 1, 1,-1, 1),
  (-1, 1, 1, 1, 1,-1),(-1, 1, 1, 1, 1, 1),
  ( 1,-1,-1,-1,-1,-1),( 1,-1,-1,-1,-1, 1),
  ( 1,-1,-1,-1, 1,-1),( 1,-1,-1,-1, 1, 1),
  ( 1,-1,-1, 1,-1,-1),( 1,-1,-1, 1,-1, 1),
  ( 1,-1,-1, 1, 1,-1),( 1,-1,-1, 1, 1, 1),
  ( 1,-1, 1,-1,-1,-1),( 1,-1, 1,-1,-1, 1),
  ( 1,-1, 1,-1, 1,-1),( 1,-1, 1,-1, 1, 1),
  ( 1,-1, 1, 1,-1,-1),( 1,-1, 1, 1,-1, 1),
  ( 1,-1, 1, 1, 1,-1),( 1,-1, 1, 1, 1, 1),
  ( 1, 1,-1,-1,-1,-1),( 1, 1,-1,-1,-1, 1),
  ( 1, 1,-1,-1, 1,-1),( 1, 1,-1,-1, 1, 1),
  ( 1, 1,-1, 1,-1,-1),( 1, 1,-1, 1,-1, 1),
  ( 1, 1,-1, 1, 1,-1),( 1, 1,-1, 1, 1, 1),
  ( 1, 1, 1,-1,-1,-1),( 1, 1, 1,-1,-1, 1),
  ( 1, 1, 1,-1, 1,-1),( 1, 1, 1,-1, 1, 1),
  ( 1, 1, 1, 1,-1,-1),( 1, 1, 1, 1,-1, 1),
  ( 1, 1, 1, 1, 1,-1),( 1, 1, 1, 1, 1, 1));

 Const LC6:array[1..192,1..2] of byte =
(( 1, 2),( 1, 3),( 1, 5),( 1, 9),( 1,17),( 1,33),
 ( 2, 4),( 2, 6),( 2,10),( 2,18),( 2,34),( 3, 4),
 ( 3, 7),( 3,11),( 3,19),( 3,35),( 4, 8),( 4,12),
 ( 4,20),( 4,36),( 5, 6),( 5, 7),( 5,13),( 5,21),
 ( 5,37),( 6, 8),( 6,14),( 6,22),( 6,38),( 7, 8),
 ( 7,15),( 7,23),( 7,39),( 8,16),( 8,24),( 8,40),
 ( 9,10),( 9,11),( 9,13),( 9,25),( 9,41),(10,12),
 (10,14),(10,26),(10,42),(11,12),(11,15),(11,27),
 (11,43),(12,16),(12,28),(12,44),(13,14),(13,15),
 (13,29),(13,45),(14,16),(14,30),(14,46),(15,16),
 (15,31),(15,47),(16,32),(16,48),(17,18),(17,19),
 (17,21),(17,25),(17,49),(18,20),(18,22),(18,26),
 (18,50),(19,20),(19,23),(19,27),(19,51),(20,24),
 (20,28),(20,52),(21,22),(21,23),(21,29),(21,53),
 (22,24),(22,30),(22,54),(23,24),(23,31),(23,55),
 (24,32),(24,56),(25,26),(25,27),(25,29),(25,57),
 (26,28),(26,30),(26,58),(27,28),(27,31),(27,59),
 (28,32),(28,60),(29,30),(29,31),(29,61),(30,32),
 (30,62),(31,32),(31,63),(32,64),(33,34),(33,35),
 (33,37),(33,41),(33,49),(34,36),(34,38),(34,42),
 (34,50),(35,36),(35,39),(35,43),(35,51),(36,40),
 (36,44),(36,52),(37,38),(37,39),(37,45),(37,53),
 (38,40),(38,46),(38,54),(39,40),(39,47),(39,55),
 (40,48),(40,56),(41,42),(41,43),(41,45),(41,57),
 (42,44),(42,46),(42,58),(43,44),(43,47),(43,59),
 (44,48),(44,60),(45,46),(45,47),(45,61),(46,48),
 (46,62),(47,48),(47,63),(48,64),(49,50),(49,51),
 (49,53),(49,57),(50,52),(50,54),(50,58),(51,52),
 (51,55),(51,59),(52,56),(52,60),(53,54),(53,55),
 (53,61),(54,56),(54,62),(55,56),(55,63),(56,64),
 (57,58),(57,59),(57,61),(58,60),(58,62),(59,60),
 (59,63),(60,64),(61,62),(61,63),(62,64),(63,64));

 Const PC6:array[1..6,1..4] of byte =
 ((1,2,4,3),(1,5,6,2),(1,3,7,5),
  (8,7,3,4),(2,6,8,4),(5,7,8,6));

 Const AC6:array[1..6] of byte =
 (red,magenta,blue,cyan,green,brown);

 Const BC6:array[1..6] of byte =
 (1,2,3,4,5,6);

{°°°°      ˆª®á í¤à - 3   }

 Var I3:array[1..20,1..3] of integer;

 Const LI3:array[1..30,1..2] of byte =
 (( 1, 2),( 2, 3),( 3, 4),( 4, 5),( 5, 1),
  ( 1, 6),( 2, 7),( 3, 8),( 4, 9),( 5,10),
  ( 6,12),(12, 7),( 7,13),(13, 8),( 8,14),
  (14, 9),( 9,15),(15,10),(10,11),(11, 6),
  (11,16),(12,17),(13,18),(14,19),(15,20),
  (16,17),(17,18),(18,19),(19,20),(20,16));

 Const PI3:array[1..12,1..5] of byte =
 (( 1, 2, 3, 4, 5),
  ( 1, 2, 7,12, 6),( 2, 3, 8,13, 7),
  ( 3, 4, 9,14, 8),( 4, 5,10,15, 9),( 5, 1, 6,11,10),
  ( 6,12, 7,16,11),(12, 7,13,18,17),
  ( 8,14,19,18,13),( 9,15,20,19,14),(10,11,16,20,15),
  (16,17,18,19,20));

 Const AI3:array[1..12] of byte =
 (red,magenta,blue,cyan,green,brown,red,magenta,blue,cyan,green,brown);

 Const BI3:array[1..12] of byte =
 (1,2,3,4,5,6,7,8,9,10,11,12);

Procedure BuildI3;
  Var I:Byte;
  Begin
    For I:=1 to 5 do
      Begin
        I3[I   ,1]:=Round(11*Cos(I*Pi/2.5));
        I3[I   ,2]:=Round(11*Sin(I*Pi/2.5));
        I3[I   ,3]:=-20;
        I3[I+5 ,1]:=Round(16*Cos(I*Pi/2.5));
        I3[I+5 ,2]:=Round(16*Sin(I*Pi/2.5));
        I3[I+5 ,3]:=-3;
        I3[I+10,1]:=Round(16*Cos((I-0.5)*Pi/2.5));
        I3[I+10,2]:=Round(16*Sin((I-0.5)*Pi/2.5));
        I3[I+10,3]:=+3;
        I3[I+15,1]:=Round(11*Cos((I-0.5)*Pi/2.5));
        I3[I+15,2]:=Round(11*Sin((I-0.5)*Pi/2.5));
        I3[I+15,3]:=+20;
      End;
  End;

{°°°°°°°°° Geometry Program }

 procedure Rotate_Vect(var X:TP);
 var i,j:byte; Y:TP;
begin
 for i:=1 to MaxDimSpace do Y[i]:=0;
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

 procedure Rotate_Comp(n,m:byte;a:real);
 var ca,sa:real; j,i:byte;
begin
 for i:=1 to MaxDimSpace do
 for j:=1 to MaxDimSpace do
 Rotate[i,j]:=0;
 for i:=1 to DimSpace do
 Rotate[i,i]:=1;
 sa:=Sin(2*Pi*a); ca:=Cos(2*Pi*a);
 Rotate[n,n]:= ca; Rotate[n,m]:=-sa;
 Rotate[m,n]:= sa; Rotate[m,m]:= ca;
 for i:=1 to DimNods do
 Rotate_Vect(W[i]);
end;

 function XC(T:TP):integer;
begin
 XC:=Trunc(x0+Dx*T[1]);
end;

 function YC(T:TP):integer;
begin
 YC:=Trunc(y0+Dy*T[2]);
end;

 procedure ShowLoops(Ind:byte);
 var i,j:byte;
begin
 for i:=1 to DimLoops do
 for j:=1 to 2 do
 case Ind of
  1: Loops[i,j]:=LT3[i,j];
  2: Loops[i,j]:=LC3[i,j];
  3: Loops[i,j]:=LO3[i,j];
  4: Loops[i,j]:=LT4[i,j];
  5: Loops[i,j]:=LO4[i,j];
  6: Loops[i,j]:=LL4[i,j];
  7: Loops[i,j]:=LC4[i,j];
  8: Loops[i,j]:=LC5[i,j];
  9: Loops[i,j]:=LC6[i,j];
 10: Loops[i,j]:=LI3[i,j];
 end;
 for i:=1 to DimLoops do
 Line( XC(W[Loops[i,1]]),YC(W[Loops[i,1]]),
       XC(W[Loops[i,2]]),YC(W[Loops[i,2]]));
end;

 procedure ShowNamb;
 var i:byte;
begin
 for i:=1 to DimNods do
 OutTextXY( XC(W[i])-10,YC(W[i])-8,Mask[i])
end;

{°°°°° Planes }

 function Minor2(p1,p2:byte):real;
begin
 Minor2:=W[P1][1]*W[P2][2]-W[P2][1]*W[P1][2];
end;

 function Area(p1,p2,p3:byte):real;
begin
 Area:=(Minor2(p2,p3)+Minor2(p3,p1)+Minor2(p1,p2))/2;
end;

 procedure ShowTr(p1,p2,p3:byte);
 var i:byte; Triangle : array[1..3] of PointType;
begin
 Triangle[1].X:=XC(W[P1]); Triangle[1].Y:=YC(W[P1]);
 Triangle[2].X:=XC(W[P2]); Triangle[2].Y:=YC(W[P2]);
 Triangle[3].X:=XC(W[P3]); Triangle[3].Y:=YC(W[P3]);
 FillPoly(SizeOf(Triangle) div SizeOf(PointType), Triangle);
end;

 procedure ShowSq(p1,p2,p3,p4:byte);
 var i:byte;
 Square: array[1..4] of PointType;
begin
 Square[1].X:=XC(W[P1]); Square[1].Y:=YC(W[P1]);
 Square[2].X:=XC(W[P2]); Square[2].Y:=YC(W[P2]);
 Square[3].X:=XC(W[P3]); Square[3].Y:=YC(W[P3]);
 Square[4].X:=XC(W[P4]); Square[4].Y:=YC(W[P4]);
 FillPoly(SizeOf(Square) div SizeOf(PointType), Square);
end;

 procedure ShowPoly5(p1,p2,p3,p4,p5:byte);
 var i:byte;
 Poly5: array[1..5] of PointType;
begin
 Poly5[1].X:=XC(W[P1]); Poly5[1].Y:=YC(W[P1]);
 Poly5[2].X:=XC(W[P2]); Poly5[2].Y:=YC(W[P2]);
 Poly5[3].X:=XC(W[P3]); Poly5[3].Y:=YC(W[P3]);
 Poly5[4].X:=XC(W[P4]); Poly5[4].Y:=YC(W[P4]);
 Poly5[5].X:=XC(W[P5]); Poly5[5].Y:=YC(W[P5]);
 FillPoly(SizeOf(Poly5) div SizeOf(PointType), Poly5);
end;

 procedure ShowPlanes(Ind:byte);
 var i,k:byte; r:real; P:TP;
begin
 for k:=1 to DimPlanes do
 begin
  case Ind of
   1: r:=Area(PT3[k,1],PT3[k,2],PT3[k,3]);
   2: r:=Area(PC3[k,1],PC3[k,2],PC3[k,3]);
   3: r:=Area(PO3[k,1],PO3[k,2],PO3[k,3]);
   4: r:=Area(PT4[k,1],PT4[k,2],PT4[k,3]);
   5: r:=Area(PO4[k,1],PO4[k,2],PO4[k,3]);
   6: r:=Area(PL4[k,1],PL4[k,2],PL4[k,3]);
   7: r:=Area(PC4[k,1],PC4[k,2],PC4[k,3]);
   8: r:=Area(PC5[k,1],PC5[k,2],PC5[k,3]);
   9: r:=Area(PC6[k,1],PC6[k,2],PC6[k,3]);
  10: r:=Area(PI3[k,1],PI3[k,2],PI3[k,3]);
  end;
  if r>0 then
  case Ind of
   1: begin
       SetFillPattern(Paterns[k], Green);
       ShowTr(PT3[k,1],PT3[k,2],PT3[k,3]);
      end;
   2: begin
       SetFillPattern(Paterns[k], Green);
       ShowSq(PC3[k,1],PC3[k,2],PC3[k,3],PC3[k,4]);
      end;
   3: begin
       SetFillPattern(Paterns[k], Green);
       ShowTr(PO3[k,1],PO3[k,2],PO3[k,3]);
      end;
   4: begin
       SetFillPattern(Paterns[k], Green);
       ShowTr(PT4[k,1],PT4[k,2],PT4[k,3]);
      end;
   5: begin
       SetFillPattern(Paterns[k], Green);
       ShowTr(PO4[k,1],PO4[k,2],PO4[k,3]);
      end;
   6: begin
       SetFillPattern(Paterns[k], Green);
       ShowTr(PL4[k,1],PL4[k,2],PL4[k,3]);
      end;
   7: begin
       SetFillPattern(Paterns[k], Green);
       ShowSq(PC4[k,1],PC4[k,2],PC4[k,3],PC4[k,4]);
      end;
   8: begin
       SetFillPattern(Paterns[k], Green);
       ShowSq(PC5[k,1],PC5[k,2],PC5[k,3],PC5[k,4]);
      end;
   9: begin
       SetFillPattern(Paterns[k], Green);
       ShowSq(PC6[k,1],PC6[k,2],PC6[k,3],PC6[k,4]);
      end;
   10: begin
       SetFillPattern(Paterns[k], Green);
       ShowPoly5(PI3[k,1],PI3[k,2],PI3[k,3],PI3[k,4],PI3[k,5]);
      end;
  end;
 end;
end;

 function Minor3(p1,p2,p3:byte):real;
 var v:real;
begin
 v:=
 W[P1][3]*Minor2(P2,P3)+
 W[P2][3]*Minor2(P3,P1)+
 W[P3][3]*Minor2(P1,P2);
 Minor3:=v;
end;

{°°°°° Subroutines }

 procedure InitData(Ind:byte);
 var i,j:byte;
 Xasp, Yasp : Word;

begin
 GetAspectRatio(Xasp,Yasp);
 DimSpace:= Ds[Ind];
 DimNods := Dn[Ind];
 DimLoops:= Dl[Ind];
 DimPlanes:=Dp[Ind];
 for i:=1 to MaxDimSpace do
 for j:=1 to MaxDimNods do
 W[i,j]:=0;
 for j:=1 to DimSpace do
 for i:=1 to DimNods do
 case Ind of
  1: W[i,j]:=T3[i][j];
  2: W[i,j]:=C3[i][j];
  3: W[i,j]:=O3[i][j];
  4: W[i,j]:=T4[i][j];
  5: W[i,j]:=O4[i][j];
  6: W[i,j]:=L4[i][j];
  7: W[i,j]:=C4[i][j];
  8: W[i,j]:=C5[i][j];
  9: W[i,j]:=C6[i][j];
 10: W[i,j]:=I3[i][j];
 end;
 Dx:=Disp[ind];
 Dy:=Round((Xasp/Yasp)*Disp[ind]);
 for i:=1 to 4 do
 Rotate_Comp(XT[ind,i],YT[ind,i],RT[ind,i]);
end;

 procedure MakeMove(Ind:byte);
 var n,Page:byte; Ch:char;
begin
 Page:=0; SetPages(Page,1-Page);
 repeat
  for n:=1 to 4 do
  Rotate_Comp(TX[ind,n],TY[ind,n],TR[ind,n]);
  ClearViewPort;
  ShowLoops(Ind);
  ShowPlanes(Ind);
  ShowNamb;
  Page:=1-Page; SetPages(Page,1-Page);
 until keypressed;
 Ch:=readkey;
 if Ch=#0 then Ch:=readkey;
 ClearViewPort;
end;

{°°°°°°°°° Main }
 var Complex:byte;
begin
 BuildI3;
 OpenEGAHi('');
{ repeat}
{  InitScr;}
{  Complex:=Menu;
  SetColor(white);
  if Complex>0 then
  begin}
   InitData(10{Complex});
   MakeMove(10{Complex});
{  end;
  ClearViewPort;
  SetPages(0,0);
  ClearViewPort;
 until Complex=0;}
 CloseGraph;
end.
