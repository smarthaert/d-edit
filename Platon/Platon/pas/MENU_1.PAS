{17.01.99 }

 Uses Graph,Crt,Dos;


{∞∞∞∞∞ Utilities }

 Const Cr=#13#10; CExit=#27;

 procedure ErrHalt(s:string);
begin
 Write(Cr+'Errow '+s); Halt;
end;

 function IntToStr(i: Longint): string;
 var s:string[11];
begin
 Str(i, s); IntToStr := s;
end;

{∞∞∞∞∞ Graphics }

 Var x0,y0,Dx,Dy:word; Page:byte;

 procedure OpenEGAHi(Path:string);
 var Driver,Mode:integer;
begin
 Driver:=Vga;
 Mode:=EGAHi;
 Initgraph(Driver,Mode,Path);
 if graphresult<>0 then halt;
end;

 procedure SwitchPage(Page:byte);
begin
 SetActivePage(Page);
 SetVisualPage(1-Page);
end;

{∞∞∞∞∞ Wins }

{‹ ViewType
 ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ}
 Type ViewType = object
     x1,y1,x2,y2 :integer;
     Color: Byte;
 procedure Make;
 procedure Passive;
 procedure Active;
 procedure Text(x,y:byte;s:string);
     end;

 procedure ViewType.Make;
begin
 SetFillStyle(SolidFill,Color);
 Bar(x1, y1, x2, y2);
end;

 procedure ViewType.Text(x,y:byte;s:string);
begin
 OutTextXY(x+x1,y+y1,s);
end;

 procedure ViewType.Passive;
 var OldColor:byte;
begin
 OldColor:=GetColor;
 SetColor(LightGray);
 Line(x1-1,y1-1,x2-1,y1-1);
 Line(x1-1,y1-1,x1-1,y2-1);
 SetColor(DarkGray);
 Line(x1,y2  ,x2,y2);
 Line(x2,y1+1,x2,y2);
 SetColor(OldColor);
end;

 procedure ViewType.Active;
 var OldColor:byte;
begin
 OldColor:=GetColor;
 SetColor(DarkGray);
 Line(x1-1,y1-1,x2-1,y1-1);
 Line(x1-1,y1-1,x1-1,y2-1);
 SetColor(LightGray);
 Line(x1,y2  ,x2,y2);
 Line(x2,y1+1,x2,y2);
 SetColor(OldColor);
end;

 const Wins:array[1..8] of ViewType =(
 (x1:20;y1:10;x2:160;y2:220;Color:Green),
 (x1:23;y1:13;x2:156;y2:25;Color:Blue),
 (x1:144;y1:13;x2:156;y2:25;Color:White),
 (x1:30;y1:30;x2:150;y2:45;Color:Green),
 (x1:30;y1:50;x2:150;y2:65;Color:Green),
 (x1:30;y1:70;x2:150;y2:85;Color:Green),
 (x1:30;y1:90;x2:150;y2:105;Color:Green),
 (x1:30;y1:110;x2:150;y2:125;Color:Green));

 const Truth:array[1..5] of string=(
 'Tetraedre',
 'Octaedre',
 'Cube',
 'Icosaedre',
 'Dodecaedre');

 const Param:array[1..5] of string=(
 'Dimension .',
 'Nodes .....',
 'Loops .....',
 'Planes ....',
 'Spaces ....');

{∞∞∞∞∞ Mouse }
 var R:Registers;

 procedure MouseInter(F:word);
begin
 r.ax:=F;
 Intr(51,r);
end;

 function MouseIsReady:boolean;
begin
 MouseInter(0); Inc(r.ax);
 MouseIsReady:=r.ax=0;
end;

 procedure MouseShow;
begin
 MouseInter(1);
end;

 procedure MouseHide;
begin
 MouseInter(2);
end;

 Function IsLocate(Win:ViewType):boolean;
begin
 MouseInter(3);
 With Win do IsLocate:=
 (x1<=r.cx) and (r.cx<=x2) and
 (y1<=r.dx) and (r.dx<=y2)
end;

 function LPressed:boolean;
begin
 MouseInter(3);
 LPressed:=r.bx mod 2=1
end;

 function RPressed:boolean;
begin
 MouseInter(3);
 RPressed:=(r.bx div 2) mod 2=1
end;

{∞∞∞∞∞ Geometry }

 Const
 MaxDimSpace = 4;
 MaxDimNods  = 4;
 MaxDimLoops = 200;
 MaxDimPlanes= 4;
 DimAngle = 1000;

 const Stat_3:array[1..5,1..5] of byte = (
 (4, 3, 3, 3, 3), { ê†ß¨•p≠Æ·‚®  }
 (4, 6, 8,20,12), { ó®·´† ¢•pË®≠ }
 (6,12,12,30,30), { ó®·´† pÒ°•p  }
 (4, 8, 6,12,20), { ó®·´† £p†≠•© }
 (1, 1, 1, 1, 1));{ ê†ß¨•p≠Æ·‚® ¨≠Æ£Æ„£Æ´Ï≠®™Æ¢ }

 Type
 TP = array[1..MaxDimSpace] of real;
 TPoints = array[1..MaxDimNods] of TP;

{∞∞∞∞∞ Geometry }

 Var
 Complex:byte;
 DimSpace:byte;
 DimNods:byte;
 DimLoops:byte;
 DimPlanes:byte;
{ W:TPoints;}

 Points:TPoints;

{∞∞∞∞∞ è®p†¨®§†-3 }

 Const Points_Tetr:
 array[1..4,1..4] of integer =
 (( 1, 1, 1,-3),
  ( 1, 1,-3, 1),
  ( 1,-3, 1, 1),
  (-3, 1, 1, 1));

 Const Planes_Tetr:
 array[1..MaxDimPlanes,1..3] of byte =
 ((1,2,3),(1,3,4),(1,4,2),(2,4,3));

 Const Paterns_Tetr:array[1..MaxDimPlanes] of FillPatternType =
(($77,$DD,$77,$DD,$77,$DD,$77,$DD),
 ($AA,$55,$AA,$55,$AA,$55,$AA,$55),
 ($99,$66,$99,$66,$99,$66,$99,$66),
 ($88,$22,$88,$22,$88,$22,$88,$22));

{∞∞∞∞∞ é™‚†Ì§p-3 }

 Const Points_Octa:
 array[1..6,1..3] of integer =
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

{∞∞∞∞      ä„°®™-3    }

 Const Points_Cube:
 array[1..8,1..3] of integer =
 ((-1,-1,-1),(-1,-1, 1),
  (-1, 1,-1),(-1, 1, 1),
  ( 1,-1,-1),( 1,-1, 1),
  ( 1, 1,-1),( 1, 1, 1));

 Const Planes_Cube:
 array[1..6,1..4] of byte =
 ((1,2,4,3),(1,5,6,2),(1,3,7,5),
  (3,4,8,7),(2,6,8,4),(5,7,8,6));

{∞∞∞∞∞ Rotate }

 var Rotate: array[1..MaxDimSpace,1..MaxDimSpace] of real;

 function XC(T:TP):integer;
begin
 XC:=Round(x0+Dx*T[1]);
end;

 function YC(T:TP):integer;
begin
 YC:=Round(y0+Dy*T[2]);
end;

 procedure Rotate_Vect(var X:TP);
 var i,j:byte; Y:TP;
begin
 for i:=1 to MaxDimSpace do Y[i]:=0;
 for i:=1 to MaxDimSpace do
 for j:=1 to MaxDimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

{ Ç ™ÆÆp§®≠†‚†Â m,n ¢p†È•≠®• ≠† „£Æ´ a }
 procedure Rotate_Comp(n,m:byte;a:real);
 var ca,sa:real; j,i:byte;
begin
 for i:=1 to MaxDimSpace do
 for j:=1 to MaxDimSpace do
 Rotate[i,j]:=0;
 for i:=1 to MaxDimSpace do
 Rotate[i,i]:=1;
 sa:=Sin(2*Pi*a); ca:=Cos(2*Pi*a);
 Rotate[n,n]:= ca; Rotate[n,m]:=-sa;
 Rotate[m,n]:= sa; Rotate[m,m]:= ca;
 for i:=1 to MaxDimNods do
 Rotate_Vect(Points[i]);
end;

{∞∞∞∞∞ Planes }

 function Minor2(p1,p2:byte):real;
begin
 Minor2:=Points[P1][1]*Points[P2][2]-Points[P2][1]*Points[P1][2];
end;

 function Area(p1,p2,p3:byte):real;
begin
 Area:=(Minor2(p2,p3)+Minor2(p3,p1)+Minor2(p1,p2))/2;
end;

 procedure ShowPlanes;
 var i,k:byte;
 Triangle : array[1..3] of PointType;
begin
 for k:=1 to DimPlanes do
 if Area(Planes_Tetr[k,1],Planes_Tetr[k,2],Planes_Tetr[k,3])>0 then
 begin
  SetFillPattern(Paterns_Tetr[k], Green);
  for i:=1 to 3 do
  with Triangle[i] do
  begin
   X:=XC(Points[Planes_Tetr[k,i]]); Y:=YC(Points[Planes_Tetr[k,i]]);
  end;
  FillPoly(SizeOf(Triangle) div SizeOf(PointType), Triangle);
 end;
end;

 procedure InitMenu;
 var ch:char; y,n:word;
begin
 SetColor(White);
 Wins[1].Make;
 Wins[1].Passive;
 Wins[2].Make;
 Wins[2].Text(8,3,'Platon');
 Wins[3].Make;
 SetColor(Black); y:=130;
 for n:=0 to 4 do
 begin
  Wins[1].Text(20,y,Param[n+1]);
  Inc(y,10);
  Wins[n+4].Passive;
  Wins[n+4].Text(10,4,Truth[n+1]);
 end;
end;

 procedure MakeMenu;
 var ch:char; y,n:word; Comp1:byte;
begin
 SetFillStyle(SolidFill,Green);
 Repeat
  for n:=0 to 4 do
  if IsLocate(Wins[n+4]) then
  begin
   Wins[n+4].Active;
   Complex:=n+1;
  end else Wins[n+4].Passive;
  if Complex<>Comp1 then
  for n:=0 to 4 do
  begin
   Bar(130,140+n*10,150,150+n*10);
   Wins[1].Text(110,130+n*10,
   IntToStr(Stat_3[n+1,Complex]))
  end;
  Comp1:=Complex;
 Until KeyPressed or LPressed;
end;

 procedure MakeComp;
 var i,j,Xasp,Yasp: Word;
begin
 GetAspectRatio(Xasp, Yasp);
 Dx:=50; Dy:=Round((Xasp/Yasp)*Dx);
 x0:=Getmaxx div 2; y0:=Getmaxy div 2;
 DimSpace:=Stat_3[1,Complex];
 DimNods :=Stat_3[2,Complex];
 DimLoops:=Stat_3[3,Complex];
 DimPlanes:=Stat_3[4,Complex];
 for i:=1 to MaxDimNods do
 for j:=1 to DimSpace do
 case Complex of
 1: Points[i,j]:=Points_Tetr[i,j];
 2: Points[i,j]:=Points_Octa[i,j];
 end;
 Rotate_Comp(1,4, pi/6);
 Rotate_Comp(2,4, pi/7);
 Rotate_Comp(3,4,-pi/8);
 MouseHide;
 Page:=0; SwitchPage(Page);
 repeat
  Rotate_Comp(1,3, 1/DimAngle);
  Rotate_Comp(2,3,-1/DimAngle);
  ClearViewPort;
  ShowPlanes;
  Page:=1-Page; SwitchPage(Page);
  Delay(100);
  ClearViewPort;
 Until KeyPressed or RPressed;
 MouseShow;
end;

{∞∞∞∞∞ Main }
begin
 If not MouseIsReady then
 ErrHalt(' åÎËÏ ≠•§Æ·‚„Ø≠†!');

 OpenEGAHi('');

 MouseShow;
 InitMenu;
 MakeMenu;
 MakeComp;
 CloseGraph;
end.
