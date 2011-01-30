{ Lion Studio 1998 }
{ *** �p��p���� ��� �뤨p���� �p��⮢ ��� ��p� Tanks *** }
Uses _13,Crt;

{ ����p� �p��⮢ }
Const sPusto=0;
      sWall=1;
      sIWall=2;
      sWater=6;
      sFire=7;
      sWFire=11;
      sPlayer1=15;
      sPlayer2=79;
      sBoom=143;
      sAnti=159;
      sAFire=223;
      sAWFire=227;
      sFireBonus=231;
      sSpeedFireBonus=235;
      sLiveBonus=239;
      sBombBonus=243;

Var  { ��ࠩ�� ���� }
      Sprites:Array[0..255,1..4,1..4] of Byte;
     { ��p��� 䠩� }
      F:File;
     { ���稪� }
      X,Y,Z:Integer;

{ �뢮� ���⮩ ࠬ�� }
Procedure Frame( x1,y1,x2,y2:Integer; Color:Byte );
  Begin
    Line(x1,y1,x1,y2,Color);
    Line(x1,y2,x2,y2,Color);
    Line(x2,y2,x2,y1,Color);
    Line(x2,y1,x1,y1,Color);
  End;

{ �뤨p���� ������ �p��� }
Procedure Get( X,Y:Integer; Number:Byte );
  Var XC,YC:Byte;
  Begin
    For YC:=0 to 3 do
      For XC:=0 to 3 do
        Begin
          Sprites[Number,YC+1,XC+1]:=Scr[Y+YC,X+XC];
          Scr[Y+YC,X+XC]:=15;
        End;
  End;

Begin
  Set13;
  LoadBMPFile('Sprites.Bmp');
 { ���뢠��� �p��⮢ }
  Frame(16,0,23,7,0);
  Get(0,0,sPusto);
  Get(4,0,sWall);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(X*4+8,Y*4,sIWall+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(X*4+16,Y*4,sFire+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(X*4+16,Y*4+8,sWFire+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(X*4+8,Y*4+8,sAFire+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(X*4+8,Y*4+16,sAWFire+Y*2+X);
  Get(24,0,sWater);
 { �p�襭�� ⠭�� 1 }
  Frame(28,0,43,15,0);
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,Y+20]:=Scr[Y,X+28];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[115-Y,X+36]:=Scr[Y,X+28];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,67-Y]:=Scr[Y,X+28];
 { ���⨥ ⠭�� 1 }
  For Y:=0 to 3 do
    For X:=0 to 3 do
      Get(28+X*4,Y*4,sPlayer1+Y*4+X);
  For Z:=1 to 3 do
    For Y:=0 to 3 do
      For X:=0 to 3 do
        Get(4+X*4+Z*16,100+Y*4,sPlayer1+Z*16+Y*4+X);
 { �p�襭�� ⠭�� 2 }
  Frame(44,0,59,15,0);
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,Y+68]:=Scr[Y,X+44];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[115-Y,X+84]:=Scr[Y,X+44];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,115-Y]:=Scr[Y,X+44];
 { ���⨥ ⠭�� 2 }
  For Y:=0 to 3 do
    For X:=0 to 3 do
      Get(44+X*4,Y*4,sPlayer2+Y*4+X);
  For Z:=1 to 3 do
    For Y:=0 to 3 do
      For X:=0 to 3 do
        Get(52+X*4+Z*16,100+Y*4,sPlayer2+Z*16+Y*4+X);
 { �p�襭�� ⠭�� ��⨣�p�� }
  Frame(76,0,91,15,0);
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,Y+116]:=Scr[Y,X+76];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[115-Y,X+132]:=Scr[Y,X+76];
  For Y:=0 to 15 do
    For X:=0 to 15 do
      Scr[X+100,163-Y]:=Scr[Y,X+76];
 { ���⨥ ⠭�� ��⨣�p�� }
  For Y:=0 to 3 do
    For X:=0 to 3 do
      Get(76+X*4,Y*4,sAnti+Y*4+X);
  For Z:=1 to 3 do
    For Y:=0 to 3 do
      For X:=0 to 3 do
        Get(100+X*4+Z*16,100+Y*4,sAnti+Z*16+Y*4+X);
 { ��p� }
  For Y:=0 to 3 do
    For X:=0 to 3 do
      Get(60+X*4,Y*4,sBoom+Y*4+X);
 { �p��� }
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(92+X*4,Y*4,sFireBonus+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(92+X*4,8+Y*4,sSpeedFireBonus+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(100+X*4,Y*4,sLiveBonus+Y*2+X);
  For Y:=0 to 1 do
    For X:=0 to 1 do
      Get(100+X*4,8+Y*4,sBombBonus+Y*2+X);
 { ������ �p��⮢ }
  Assign(F,'..\DATA\Tanks.Dat');
  Rewrite(F,1);
  BlockWrite(F,Sprites,4096);
  Close(F);
  ReadKey;
End.