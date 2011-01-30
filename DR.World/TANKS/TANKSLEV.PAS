{ Lion Studio 1998 }
{ *** Редактоp уpовней для Tanks *** }
Uses Crt,Gr_Mcga,RunError,TankGame;

{ Вывод простой рамки }
Procedure Frame( x1,y1,x2,y2:Integer; Color:Byte );
  Begin
    Bar(x1,y1,x1,y2,Color);
    Bar(x1,y2,x2,y2,Color);
    Bar(x2,y1,x2,y2,Color);
    Bar(x1,y1,x2,y1,Color);
  End;

{ Экранное изобpажение }
Type TScreen=Object
     { Кооpдинаты куpсоpа }
      XEDIT,YEDIT:Byte;
     { Спрайты игры }
      Sprites:Array[0..255,1..4,1..4] of Byte;
     { Инициализация спрайтов }
      Procedure InitSprites;
     { Вывод игрового поля }
      Procedure Show;
    End;

  Procedure TScreen.InitSprites;
    Var F:File;
    Begin
      Assign(F,'DATA\Tanks.Dat');
      Reset(F,1);
      BlockRead(F,Sprites,4096);
      Close(F);
      XEDIT:=1;
      YEDIT:=1;
    End;

  Procedure TScreen.Show;
    Var x,y:Byte;
    Begin
      For y:=1 to 48 do
        For x:=1 to 64 do
          Begin
            Mem[$A000+Y*80:x*4+16]:=Sprites[Level[y,x],1,1];
            Mem[$A000+Y*80:x*4+17]:=Sprites[Level[y,x],1,2];
            Mem[$A000+Y*80:x*4+18]:=Sprites[Level[y,x],1,3];
            Mem[$A000+Y*80:x*4+19]:=Sprites[Level[y,x],1,4];
            Mem[$A000+Y*80+20:x*4+16]:=Sprites[Level[y,x],2,1];
            Mem[$A000+Y*80+20:x*4+17]:=Sprites[Level[y,x],2,2];
            Mem[$A000+Y*80+20:x*4+18]:=Sprites[Level[y,x],2,3];
            Mem[$A000+Y*80+20:x*4+19]:=Sprites[Level[y,x],2,4];
            Mem[$A000+Y*80+40:x*4+16]:=Sprites[Level[y,x],3,1];
            Mem[$A000+Y*80+40:x*4+17]:=Sprites[Level[y,x],3,2];
            Mem[$A000+Y*80+40:x*4+18]:=Sprites[Level[y,x],3,3];
            Mem[$A000+Y*80+40:x*4+19]:=Sprites[Level[y,x],3,4];
            Mem[$A000+Y*80+60:x*4+16]:=Sprites[Level[y,x],4,1];
            Mem[$A000+Y*80+60:x*4+17]:=Sprites[Level[y,x],4,2];
            Mem[$A000+Y*80+60:x*4+18]:=Sprites[Level[y,x],4,3];
            Mem[$A000+Y*80+60:x*4+19]:=Sprites[Level[y,x],4,4];
          End;
      Frame(XEDIT*4+16,YEDIT*4,XEDIT*4+31,YEDIT*4+15,31);
    End;

{ Файл с уpовнем }
Var FN:String;
    Screen:TScreen;
    F:File;
    Key,K:Char;
    X,Y:Byte;
Begin
  If ParamCount=1 then
    Begin
      FN:=ParamStr(1);
      InitMCGA;
      Screen.InitSprites;
      OpenFileRE(F,'Level','Data\Levels\level'+FN+'.lev');
      BlockRead(F,Level,(48*64));
      Bar(0,0,319,199,27);
      Bar(19,3,276,196,23);
      Repeat
        Screen.Show;
        Key:=ReadKey;
        Key:=UpCase(Key);
       { Пеpедвижение куpсоpа }
        If Key=#00 then
          Begin
            K:=ReadKey;
            Case K of
              #72: If Screen.YEDIT>4 then Screen.YEDIT:=Screen.YEDIT-4;
              #80: If Screen.YEDIT<45 then Screen.YEDIT:=Screen.YEDIT+4;
              #75: If Screen.XEDIT>4 then Screen.XEDIT:=Screen.XEDIT-4;
              #77: If Screen.XEDIT<61 then Screen.XEDIT:=Screen.XEDIT+4;
             End;
          End;
       { Изиенение каpты }
        Case Key of
          'W': For Y:=0 to 3 do
                 For X:=0 to 3 do
                   Level[Screen.YEDIT+Y,Screen.XEDIT+X]:=sWall;
          'P': For Y:=0 to 3 do
                 For X:=0 to 3 do
                   Level[Screen.YEDIT+Y,Screen.XEDIT+X]:=sPusto;
          'Q': For Y:=0 to 3 do
                 For X:=0 to 3 do
                   Level[Screen.YEDIT+Y,Screen.XEDIT+X]:=sWater;
          'I': For Y:=0 to 3 do
                 For X:=0 to 3 do
                   Level[Screen.YEDIT+Y,Screen.XEDIT+X]:=sIWall+(Y mod 2)*2+(X mod 2);
         End;
      Until Key=#27;
      Rewrite(F,1);
      BlockWrite(F,Level,(48*64));
      Close(F);
      DoneMCGA;
  End
 Else
  Begin
    Writeln('TanksLev <Level Number>');
  End;
End.