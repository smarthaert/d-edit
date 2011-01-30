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
 Str(i, s);
 if i<10
 then IntToStr :=' '+ s
 else IntToStr :=s;
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

 Var
 Complex:byte;
 DimSpace:byte;
 DimNods:byte;
 DimLoops:byte;
 DimPlanes:byte;

 Points:TPoints;

{∞∞∞∞∞ Menu }

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
 Ch:=' '; SetFillStyle(SolidFill,Green);
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

  if KeyPressed then
  Ch:=ReadKey;
  if Ch=#0 then
  Ch:=ReadKey;

 Until (Ch=#27) or
 (IsLocate(Wins[2]) and LPressed);
end;

{∞∞∞∞∞ Main }
begin
 If not MouseIsReady then
 ErrHalt(' åÎËÏ ≠•§Æ·‚„Ø≠†!');

 OpenEGAHi('');

 Complex:=1;
 MouseShow;
 InitMenu;
 MakeMenu;
 CloseGraph;
end.
