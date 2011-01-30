{ * Video for Klad * }
Unit Video;

Interface

Uses Gr_MCGA,SetSprites;

Procedure InitVideo;
Procedure DoneVideo;
Procedure Showpoleklet( xc,yc,Obj:Byte );
Procedure ShowCursor( X,Y:Word );

Implementation

Var kerpich,pusto,gold,stair,iron:sprite;
    hero,hero_stair,anth,anth_stair,anth_gold:array[1..2] of sprite;

var ScrBox:Array[0..19,0..9,0..31,0..9]of byte absolute $0A000:0000;

procedure putspriten(xc,yc:byte;spr:sprite);
var i,j:byte;
Begin
     for i:=0 to 9 do
       for j:=0 to 9 do
         ScrBox[yc,i,xc,j]:=spr[j,i];
end;

Procedure OverPut( Var Dest,Src:Sprite );
  Var i,j:byte;
  Begin
     for i:=0 to 9 do
       for j:=0 to 9 do
         if Src[j,i]>0 then Dest[j,i]:=Src[j,i];
  End;

Procedure InitVideo;
  Begin
    loadspritefile('Sprites\kerpich.spr',kerpich);
    loadspritefile('Sprites\pusto.spr',pusto);
    loadspritefile('Sprites\hero_stp.spr',hero[1]);
    loadspritefile('Sprites\gold.spr',gold);
    loadspritefile('Sprites\iron.spr',iron);
    loadspritefile('Sprites\stair.spr',stair);
    loadspritefile('Sprites\anth_stp.spr',anth[1]);
    mirrorsprite(hero[2],hero[1],true);
    mirrorsprite(anth[2],anth[1],true);
    hero_stair[1]:=stair;
    hero_stair[2]:=stair;
    overput(hero_stair[1],hero[1]);
    overput(hero_stair[2],hero[2]);
    anth_stair[1]:=stair;
    anth_stair[2]:=stair;
    overput(anth_stair[1],anth[1]);
    overput(anth_stair[2],anth[2]);
    anth_gold[1]:=gold;
    anth_gold[2]:=gold;
    overput(anth_gold[1],anth[1]);
    overput(anth_gold[2],anth[2]);
    initmcga;
    bar(0,0,319,199,8);
  End;

Procedure DoneVideo;
  Begin
    DoneMCGA;
  End;


Procedure ShowCursor( X,Y:Word );
  Begin
    Bar(X*10,Y*10,X*10+8,Y*10,31);
    Bar(X*10+9,Y*10,X*10+9,Y*10+8,31);
    Bar(X*10+1,Y*10+9,X*10+9,Y*10+9,31);
    Bar(X*10,Y*10+1,X*10,Y*10+9,31);
  End;

procedure showpoleklet(xc,yc,Obj:byte);
  Begin
    case Obj of
      0,12:putspriten(xc,yc,pusto);
      1:putspriten(xc,yc,kerpich);
      2,13:putspriten(xc,yc,hero[1]);
      3:putspriten(xc,yc,gold);
      4:putspriten(xc,yc,stair);
      5:putspriten(xc,yc,hero_stair[1]);
      6,15:putspriten(xc,yc,anth[1]);
      7:putspriten(xc,yc,anth_stair[1]);
      8,14:putspriten(xc,yc,hero[2]);
      9:putspriten(xc,yc,hero_stair[2]);
      10,16:putspriten(xc,yc,anth[2]);
      11:putspriten(xc,yc,anth_stair[2]);
      17:putspriten(xc,yc,anth_gold[1]);
      18:putspriten(xc,yc,anth_gold[2]);
      19:putspriten(xc,yc,iron);
    end;
  End;

End.