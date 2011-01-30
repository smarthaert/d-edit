{

Original idea by: 
 John Christian Lonningdal, 5 May 1996

Rewritten, improved, corrected by: 

 George K., 23 December 1999
  
 Vladimir V.,  16.10.00 : W-develop@mtu-net.ru; http//www.GameDev.narod.ru

}


unit DXWPath;

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls;

Const
 { directions in which to go. both contstants are used in the same time }
  DirX   : Array[0..7] of ShortInt=( 0,1,0,-1,-1, 1,1,-1);
  DirY   : Array[0..7] of ShortInt=(-1,0,1, 0,-1,-1,1, 1);
  NegDir : Array[0..7] of Byte=(2,3,0,1,6,7,4,5);

  DirV   : Array[0..7] of double=(1.42,1.42,1.42,1.42,1,1,1,1);

  DirToPatternY : Array[0..7] of byte=(0,2,4,6,7,1,3,5);
  //DirRad : Array[0..7] of Double=(0, 1.57, 3.14, 4.71, 5.5, 0.79, 2.37, 3.93);//0 : 2Pi
  DirRad : Array[0..7] of Double=(3.14, 1.57, 0, -1.57, -2.37, 2.37, 0.79, -0.79);//-Pi : +Pi
type

 TDirChangedPoints = record
   Point : TPoint;
   Dir   : Byte;
 end;

type
  TDXPath = class
   private
    FDimW,FDimH   : Integer;

  public
    FStartPos : TPoint;     // starting position
    FEndPos   : TPoint;     // the destination
    FMaxPath     : Integer;


    FPath                 : Array of TPoint;
    FObstacle             : Array of Array of Boolean;
    FDirMap               : Array of Array of Byte;
    FPointList            : Array[0..1] of array of TPoint;

    DirChangedPointsArr   : Array of TDirChangedPoints;
    DirChangedPointsCount : integer;
    DirChangedPoints      : TDirChangedPoints;

    constructor Create(MapW,MapH : integer ); virtual;
    destructor Destroy; override;

    function FindPath : Boolean;
  end;

implementation


constructor TDXPath.Create(MapW,MapH : integer);
begin
 inherited Create;

 FDimW:=MapW;
 FDimH:=MapH;

 SetLength(FObstacle,MapH,MapW);
 SetLength(FDirMap,MapH,MapW);
 SetLength(FPointList[0],MapH*MapW);
 SetLength(FPointList[1],MapH*MapW);
 SetLength(FPath,MapH*MapW);
end;


destructor TDXPath.Destroy;
begin
  inherited Destroy;
end;

/////////////////////////////////////////////
{  Path-Finding routine  }
function TDXPath.FindPath:Boolean;
var
 PointLength : Array[0..1] of Integer; // length of our point arrays
 PointStart  : Array[0..1] of Integer;//my
 CurPoint    : Integer; // point array we're processing at the moment
 Pos         : TPoint;
 i,x,y,j,k   : Integer;

 Stuck       : Boolean; // used to avoid Lock-ups

 Direction   : Byte; // current direction
 { 0 - Up         1 - Right       2 - Down       3 - Left
   4 - Up&Left    5 - Up&Right    6 - Down&Right 7 - Down&Left
   255 - No Direction }

{ pick a new direction }
 function NewDirection(Dir:Byte):Byte;
 begin
  Inc(Dir);
  if Dir>7 then Dir:=0;
  NewDirection:=Dir;
 end;

//end local
begin
 // !!!!!!! FillChar does not work with dinamic Array
 //FillChar(FDirMap,SizeOf(FDirMap),255); // filling our direction map with value 255 = no direction
 For j :=0 to (FDimH-1) do
  For i :=0 to(FDimW-1) do
    FDirMap[j,i]:=255;


 { adding starting position to Point Array #0 }
 PointLength[0]:=1;
 FPointList[0,0]:=FStartPos;

 { Point Array #1 is empty }
 PointLength[1]:=0;

 CurPoint:=0; // current Point array is #0

 PointStart[0]:=0;
 PointStart[1]:=0;

 repeat
  Stuck:=True;

  for j:= PointStart[CurPoint] to PointLength[CurPoint]-1 do
   begin

    Pos:=FPointList[CurPoint,j];

    { expanding the direction map from current position by checking specific directions }
    { variable "i" is our direction. there're 8 directions... }
    for i:=0 to 7 do
     begin
      { gettign new coordinates if we're going in current direction }
      x:=Pos.X+DirX[i];
      y:=Pos.Y+DirY[i];

      { check if our new place is valid }
      { to be valid it must be:
         1) inside 20x20 boundaries
         2) empty
         3) the direction map at this place must be empty (i.e. set to NoDirector = 255) }
      if (x>=0)and(y>=0)and(x<FDimW)and(y<FDimH)and(not FObstacle[y,x])and(FDirMap[y,x]=255) then
       begin
        FDirMap[y,x]:=i; // filling the direction map

        { adding this position to ANOTHER Point Array so our current array won't be corrupted }
        k:=PointLength[CurPoint xor 1];
        FPointList[CurPoint xor 1,k]:=Point(x,y);
        Inc(k);
        { if we got overflow - exit }
        if k>FDimW*FDimH-1 then
         begin
          FindPath:=False;
          Exit;
         end;

        PointLength[CurPoint xor 1]:=k;

        Stuck:=False; // we added new point so we're not stuck!

        { if this point is our destination - LEAVE THIS LOOP! }
        if (x=FEndPos.X)and(y=FEndPos.Y) then Break;
       end;{ add point to point array }
     end;

    { we opened two loops - one break is not enough. here's another one ... }
    if (x=FEndPos.X)and(y=FEndPos.Y) then Break;
   end;//j

  if Stuck then
   begin
    FindPath:=False;
    Exit;
   end;

  PointStart[CurPoint]:=PointLength[CurPoint];
  { changing current Point Array }
  CurPoint:=CurPoint xor 1;
 until ((x=FEndPos.X)and(y=FEndPos.Y));


 { assuming x=EndPos.X, y=EndPos.Y }
 Pos:=Point(x,y);

 { adding FINAL position to our path }
 FMaxPath:=1;
 FPath[0]:=Pos;

  { now adding more points to our PATH, starting from END and using Direction map to
  get back to starting point }
 repeat
  Direction:=FDirMap[y,x]; // loading direction value
  Direction:=NegDir[Direction]; // negating it


  { moving in that direction }
  x:=x+DirX[Direction];
  y:=y+DirY[Direction];

  { adding new point to PATH array }
  FPath[FMaxPath]:=Point(x,y);
  Inc(FMaxPath);

  { if got path overflow - leave }
  if FMaxPath>FDimW*FDimH-1 then
   begin
    FindPath:=False;
    Exit;
   end;
 until (x=FStartPos.X)and(y=FStartPos.Y);

 FindPath:=True;

  DirChangedPointsCount:=0;
  i:=0;

  FDirMap[FPath[FMaxPath-1].y,FPath[FMaxPath-1].x]:=255;

  Direction:=FDirMap[FPath[i].y,FPath[i].x];
  DirChangedPoints.Point:=FPath[i];
  DirChangedPoints.Dir:=255;

  inc(DirChangedPointsCount);
  SetLength(DirChangedPointsArr,DirChangedPointsCount);
  DirChangedPointsArr[DirChangedPointsCount-1]:=DirChangedPoints;

 for i:=1 to FMaxPath-1 do
 begin
  if Direction<>FDirMap[FPath[i].y,FPath[i].x] then
  begin
    inc(DirChangedPointsCount);
    SetLength(DirChangedPointsArr,DirChangedPointsCount);

    DirChangedPoints.Point:=FPath[i];
    DirChangedPoints.Dir:=Direction;
    DirChangedPointsArr[DirChangedPointsCount-1]:=DirChangedPoints;

    Direction:=FDirMap[FPath[i].y,FPath[i].x];
  end;
 end;

 for i:=0 to (DirChangedPointsCount div 2)-1 do
 begin
  DirChangedPoints:=DirChangedPointsArr[i];
  DirChangedPointsArr[i]:=DirChangedPointsArr[DirChangedPointsCount-1-i];
  DirChangedPointsArr[DirChangedPointsCount-1-i]:=DirChangedPoints;
 end;

end;

end.
