{$N+,E+}
Uses DOS,CRT,GameKeyb,Gr_MCGA,Math,GF_PCX;

{ --=== Base ===-- }
Var Timer : LongInt Absolute $0040:$006c;
Const Deg2Rad : Real = Pi/180;
Procedure WolfDoomInfo; Forward;

{ --=== WOLF_3D.ASM ===-- }
Const
  VAddr : Pointer = nil; { Видеобуфер }
  DarkNess    : Word = 0;
  Scr_Horizon : Word = 100;
  Scr_Height  : Word = 200;
  Scr_Offs    : Word = 0;
  Scr_MagicConst : Real = 128;
  Scr_Cast_Angle : Real = 0.2;
  Scr_Width : Word = 320;
Var
  Wall,Floor,Ceiling,_Shade : Pointer;
  hmh,hph : Integer; X : Word;
  V,H,Stp,px128,py128,SinA,CosA,Magic : LongInt;

Procedure DrawWallFloor; External;
{$l WOLF_3D.OBJ}

{ --=== TVideo ===-- }
Type
  TVideo = Object
    FPS : LongInt; { Скорость - Frames per second }
    Frames : LongInt; { Количество кадров на текущий монент }
    FirstTimer : LongInt; { Начальное положение таймера }
    Shade : Array [0..17*256-1] of Byte; { Затенение }
    GamePal : RGBPalette; { Игровая палитра }
    Constructor Init;
    Destructor Done;
    Procedure InitGraph;
    Procedure InitTexture( Var Texture:Pointer; FileName:String );
    Procedure DoneTexture( Var Texture:Pointer );
    Procedure SetShade;
    Procedure Run;
    Procedure ComputeView;
    Function InRange( X,Y:Real ):Boolean;
  End;

Var Video:TVideo;

{ --=== TMap - Карта и игрок ===-- }
Const
  mStart : Byte = 1;
  mEnde  : Byte = 2;
  mMauer : Byte = 3;
Type
  TMap = Object
    Heading : Real;
    Turn    : Real;
    Step    : Real;
    Data    : Array [0..32*32-1] OF byte;
    PlayerX,PlayerY : Real;
    DestX,DestY : Real;
    SinH,CosH,NewPlayerX,NewPlayerY : Real;
    Constructor Init( FileName:String );
    Procedure Player;
    Procedure EvalKeys;
    Procedure Draw;
  End;

Constructor TMap.Init( FileName:String );
  Var F:File; X,Y:Word;
  Begin
    Heading := 0; Turn := 0; Step := 0;
    OpenFileRE(F,'WolfDoom MAP',FileName);
    BlockRead(F,Data,SizeOf(Data));
    Close(F);
    For X:=0 to 31 do
      For Y:=0 to 31 do
        If Data[X+Y*32]=mStart then
          Begin PlayerX:=X+0.5; PlayerY:=Y+0.5; Data[x+y*32]:=0; End
        Else
        If Data[X+Y*32]=mEnde then
          Begin DestX:=X; DestY:=Y; Data[X+Y*32]:=mMauer; End;
  End;


Procedure TMap.Player;
  Begin
   { Поворот }
    Heading := Heading + Turn;
    While Heading >= 360 do Heading := Heading - 360;
    While Heading < 0 do Heading := Heading + 360;
   { Перемещение }
    If Step<>0 then
      Begin SinH:=Sin(Heading*Deg2Rad); CosH:=Cos(Heading*Deg2Rad); End;
    If Step > 0 then
      Begin
        NewPlayerX := PlayerX + SinH * (Step+0.5);
        NewPlayerY := PlayerY + CosH * (Step+0.5);
      End;
    If Step < 0 then
      Begin
        NewPlayerX := PlayerX + SinH * (Step-0.5);
        NewPlayerY := PlayerY + CosH * (Step-0.5);
      End;
    If (data[round(int(NewPlayerX))+round(int(PlayerY+0.1)) shl 5] <= 0) and
       (data[round(int(NewPlayerX))+round(int(PlayerY-0.1)) shl 5] <= 0)
      then PlayerX :=PlayerX + sinh * step;
    If (data[round(int(PlayerX+0.1))+round(int(NewPlayerY)) shl 5] <= 0) and
       (data[round(int(PlayerX-0.1))+round(int(NewPlayerY)) shl 5] <= 0 )
      then PlayerY := PlayerY + cosh * step;
  End;

{ - Обработка нажатий на клавиши - }
Type CtrlKey = Record Name:String; Scan:Byte; End;
Const
  CtrlKeyNum = 6;
  ctrlTurnLeft  = 1;
  ctrlTurnRight = 2;
  ctrlStep      = 3;
  ctrlBackward  = 4;
  ctrlShowMap   = 5;
  ctrlShowInfo  = 6;
  CtrlKeySet : Array [1..CtrlKeyNum] of CtrlKey = (
    (Name:'Turn to Left';Scan:cLeft),
    (Name:'Turn to Right';Scan:cRight),
    (Name:'Step';Scan:cUp),
    (Name:'Step Backward';Scan:cDown),
    (Name:'Show Map';Scan:cEnter),
    (Name:'Show Info';Scan:15));

Procedure TMap.EvalKeys;
  Begin
   { Повороты }
    If Keys[CtrlKeySet[ctrlTurnLeft].Scan] then
      Begin
        If Turn < 1 then Turn := 1
        Else If Turn < 8 THEN Turn := Turn * 2;
      End
    Else If Keys[CtrlKeySet[ctrlTurnRight].Scan] then
      Begin
        If Turn > -1  then Turn:= -1
        ELSE If Turn > -8 then Turn := Turn * 2;
      End
    Else
      Turn := Turn * 0.6; { Замедление поворота }
   { Ходы }
    If Keys[CtrlKeySet[ctrlBackward].Scan] then
      Begin
        If Step > -0.1 then Step := -0.1
        Else If Step > -0.25 then Step := Step * 1.1;
      End
    Else If Keys[CtrlKeySet[ctrlStep].Scan] then
      Begin
        If Step < 0.1 then Step := 0.1
        Else If Step < 0.25 then Step := Step * 1.1;
      End
    Else
      Step := Step * 0.8;
   { Просмотр карты }
    If Keys[CtrlKeySet[ctrlShowMap].Scan] then
      Begin
        Repeat Until AnyPressed = False;
        Draw;
        Repeat Until AnyPressed = True;
        Repeat Until AnyPressed = False;
      End;
   { Информация о программе }
    If Keys[CtrlKeySet[ctrlShowInfo].Scan] then
      Begin
        DoneMCGA;
        Repeat Until AnyPressed = False;
        WolfDoomInfo;
        Writeln;
        Writeln('# Press any key for return to 3D world #');
        Repeat Until AnyPressed = True;
        Repeat Until AnyPressed = False;
        Video.InitGraph;
      End;
  End;

{ - Вывод карты на экран - }
Procedure TMap.Draw;
  Var I,J,Offset,Color,Add:Word;
  Begin
    For I:=0 to 31 do
      For J:=0 to 31 do
        Begin
          Add:=0;
          If I=Trunc(PlayerX) then Add:=Add + 10;
          If J=Trunc(PlayerY) then Add:=Add + 10;
          Color:=100 + Data[i+(j shl 5)] * 20 + Add;
          offset:= 62*320+28+(i*3)+(j*3)*320;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+1]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+2]:= color;
          offset:=offset+ 320;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+1]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+2]:= color;
          offset:=offset+320;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+1]:= color;
          mem[Seg(VAddr^):Ofs(VAddr^)+offset+2]:= color;
        End;
    Flip(Seg(VAddr^),$A000);
  End;

Var Map : TMap;

{ --=== TVideo -> Implementation ===--- }
Constructor TVideo.Init;
  Begin
    GetMem(VAddr,64000);
    ClearMemory(Seg(VAddr^));
    InitTexture(Floor,'Data/boden.pcx');
    InitTexture(Ceiling,'Data/decke.pcx');
    InitTexture(Wall,'Data/brick1.pcx');
    InitGraph;
  End;

Destructor TVideo.Done;
  Begin
    DoneMCGA;
    FreeMem(vaddr,64000);
    DoneTexture(Floor);
    DoneTexture(Ceiling);
    DoneTexture(Wall);
  End;

Procedure TVideo.InitGraph;
  Begin
    _Shade:=@Shade;
    InitMCGA;
    SetPalette(GamePal);
    SetShade;
    Frames := 0;
    FirstTimer := Timer;
    FPS := 0;
  End;

Procedure TVideo.InitTexture( Var Texture:Pointer; FileName:String );
  Var Header:PCXHeader;
  Begin
    GetMem(Texture,128*128);
    LoadPCX(FileName,Header,GamePal,Texture,0,128);
  End;

Procedure TVideo.DoneTexture( Var Texture:Pointer );
  Begin
    FreeMem(Texture,128*128);
  End;

Procedure TVideo.SetShade;
  Var Color,St,Diff,TC,TDiff,R,G,B:Integer;
  Begin
    For Color:=0 to 255 do Shade[Color]:=Color;
    For St:=1 to 16 do
      For Color:=0 to 255 do
	Begin
	  R := (Integer(GamePal[Color].R) shr 4) * (16-St);
	  G := (Integer(GamePal[Color].G) shr 4) * (16-St);
	  B := (Integer(GamePal[Color].B) shr 4) * (16-St);
          Diff := 1000;
	  For TC:=0 to 255 do
	    Begin
	      TDiff := Abs(Integer(GamePal[TC].R - R)) +
                       Abs(Integer(GamePal[TC].G - G)) +
                       Abs(Integer(GamePal[TC].B - B));
              If TDiff < Diff then
   		Begin Diff:=TDiff; Shade[Color+(St shl 8)]:=TC; End;
            End;
	End;
  End;

Procedure TVideo.Run;
  Begin
    ComputeView;
    Flip(Seg(VAddr^),$A000);
    Inc(Frames);
    If Timer<>FirstTimer then
       FPS := (Frames * LongInt(18)) div (Timer-FirstTimer);
    If FPS > 25 then WaitForRetrace;
  End;

Procedure TVideo.ComputeView;
  Var a,x1,x2,y1,y2,dist1,dist2,step:Real;
      Height,Dist:Longint;
  Label Break1,Break2,break3,break4;
  Begin
    px128 := round(Map.PlayerX*128);py128:=round(Map.PlayerY*128);
    a := Map.Heading + 32;
    For X:=0 to scr_width-1 do
      Begin
        a:=a - scr_cast_angle;
       (* Tabellen wДhren besser *)
	magic := round(int(scr_MagicConst*1024/cos((a - Map.Heading)*Deg2Rad)));
	sina  := round(int(sin(a*DEG2RAD) * 128 * 1024));
	cosa  := round(int(cos(a*DEG2RAD) * 128 * 1024));
       (* Bewegung auf der Y-achse *)
	if (a<>180) and (a<>0) then
  	  begin
	    if ( sina > 0 ) then
	      begin
	        step:= tan( (90-a) * DEG2RAD );
	  	x1:= int(Map.PlayerX)+1;
	  	y1:= Map.PlayerY + (x1-Map.PlayerX) * step;
                while true do
		  begin
	  	    if inrange(x1,y1) then goto break1;
		    x1 :=x1+ 1;
		    y1 := y1+step;
		  end;
                Break1:
	      end
	    else
	      begin
		step:= tan( (a-270) * DEG2RAD );
		x1:= int(Map.PlayerX)-0.0000001;
	        y1:= Map.PlayerY + (Map.PlayerX-x1) * step;
		while true do
		  begin
                    if inrange(x1,y1) then goto break2;
		    x1:=x1- 1;
		    y1:=y1+step;
		  end;
                break2:
	      end
	  end;
       (* Bewegung auf der Y-achse *)
	if (a<>270) and (a<>90) then
	  begin
            if cosa>0 then {nach vorne}
	      begin
                step:= tan( a * DEG2RAD );
		y2:= int(Map.PlayerY)+1;
	        x2:= Map.PlayerX + (y2-Map.PlayerY) * step;
                while true do
		  begin
                    if inrange(x2,y2) then goto break3;
		    y2 :=y2+ 1;
		    x2 := x2+step;
		  end;
                break3:
              end
	    else
	      begin
		step:= tan( (a-180) * DEG2RAD );
		y2:= int(Map.PlayerY)-0.000001;
	        x2:= Map.PlayerX - (Map.PlayerY-y2) * step;
		while true do {Hinten}
		  begin
                    if inrange(x2,y2) then goto break4;
		    y2 :=y2- 1;
		    x2 :=x2-step;
		  end;
                break4:
	      end;
	  end;
        dist1:= sqr(Map.PlayerX-x1)+sqr(Map.PlayerY - y1);
	dist2:= sqr(Map.PlayerX-x2)+sqr(Map.PlayerY - y2);
	if dist1>dist2 then
	  begin
            dist:= round(int(sqrt(dist2) * 1024));
            h:= Abs(128 - round(128 * x2));
	  end
	else
	  begin
	    dist:= round(int(sqrt(dist1) * 1024));
            h:= abs(128 - round(128 * y1));
	  end;
        height:= magic div dist;
	stp:= 64*65536 div height;
	hmh:= scr_horizon - height; hph:= scr_horizon + height;
        darkness:= dist shr 10;
	if darkness>16 then darkness:= 16
	else if darkness>0 then dec(darkness);
	darkness:= (darkness shl 8);
	if hmh<0 then
 	  begin
            v:= (0 - hmh) * stp;
	    hmh:= 0;
	    hph:= scr_height;
	  end
	else v:= 0;
        DrawWallFloor;
      end;
  End;

Function TVideo.InRange( X,Y:Real ):Boolean;
  Var ppx,ppy: Real;
  Begin
    ppx:=int(x);ppy:=int(y);
    if (ppx< 00) or (ppy < 00) or (ppx > 27) or (ppy>27) OR
      (Map.Data[round(ppx)+round(ppy) shl 5]>0) then
       inrange:=true else inrange:=false;
  End;

{ --=== WolfDoomInfo ===-- }
Procedure WolfDoomInfo;
  Var I:Word;
  Begin
    Writeln('--=== WolfDoom Information ===--');
    Writeln('Free memory = ',MemAvail,' bytes');
    Writeln('Speed = ',Video.FPS,' Frames per Second. Total frames = ',Video.Frames);
    Writeln('Player X = ',Map.PlayerX:0:3,'  Y = ',Map.PlayerY:0:3);
    Writeln('  Heading = ',Map.Heading:0:3);
    Writeln('  Turn speed = ',Map.Turn:0:3);
    Writeln('  Step speed = ',Map.Step:0:3);
    Writeln('Destination X = ',Map.DestX:0:3,'  Y = ',Map.DestY:0:3);
    Writeln('*** Control Keys ***');
    For I:=1 to CtrlKeyNum do
      Writeln('  * ',CtrlKeySet[I].Name,' = ',KeyNames[CtrlKeySet[I].Scan],
        ' (',CtrlKeySet[I].Scan,')');
  End;

{ --=== Основная программа ===-- }
Begin
  Video.Init;
  InitInt09;
  Map.Init('Data/karte.map');
  While not Keys[cEsc] do
    Begin
      Map.EvalKeys;
      Map.Player;
      Video.Run;
    End;
  RestoreInt09;
  Video.Done;
  WolfDoomInfo;
End.
