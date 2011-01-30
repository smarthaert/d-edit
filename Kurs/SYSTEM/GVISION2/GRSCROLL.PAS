unit GrScroll;
interface
uses Views,Drivers,Objects;
Const ZeroPoint:TPoint = (X:0;Y:0);
Type PPictureScroller = ^TPictureScroller;
     {Scroller with text coordinates and graphic images}
     TPictureScroller = object ( TScroller )
                  function Overlayed:boolean;virtual;
                  {Must be called at begin of Draw method
                    like if Overlayed then exit;}
                  Procedure MakeGraphic(Src:TPoint;Var Dest:TPoint);
                  {Converts text coordinates to graphic coords of top left
                   corner of symbol (global to global, local to local}
                  Procedure GetGraphicLimits(var Limits:TRect);
                   {Returns Global graphic coordinates of view}
                  Procedure GetGraphicExtent(var Extent:TRect);
                   {Returns Local graphic coordinates of view}
                  Procedure MakeGraphicRect(Src:TRect;Var Dest:TRect);
                  {converts text rectangle to graphic }
                end;
     PGraphScroller = ^TGraphScroller;
     TGraphScroller = object (TPictureScroller)
      {Scroller with graphic coordinates}
                  Procedure MapMouse(Var P:TPoint);
                  Procedure SetLimit(X,Y:Integer);Virtual;
                  Procedure ChangeBounds(var Bounds:TRect);Virtual;
                 end;
    PVirtualScreen = ^TVirtualScreen;
    TVirtualScreen = object ( TGraphScroller )
     {Customize Draw method of this object with any graphic operators using
     virtual coordinates (up to 0..32767 pixels on any axis,
     but not use SetViewPort and GetPixel}
                     procedure PutPixel(x,y:integer;Pixel:Word);virtual;
                     procedure Line(x1,y1,x2,y2:integer);virtual;
                     Procedure MoveTo(x,y:integer);virtual;
                     Procedure LineTo(x,Y:integer);virtual;
                     Procedure Circle(x,y:integer;Radius:word);virtual;
                     Procedure Ellipse(X,Y:Integer;StAngle,EndAngle:word;XRadius,YRadius:Word);virtual;
                     Procedure Arc(X,Y:Integer;StAngle,EndAngle:word;Radius:Word);virtual;
                     Procedure PieSlice(X,Y:Integer;StAngle,EndAngle:word;Radius:Word);virtual;
                     Procedure FillEllipse(X,Y:Integer;XRadius,YRadius:Word);virtual;
                     Procedure DrawPoly(NumPoints:Word; var PolyPoints);virtual;
                     Procedure FillPoly(NumPoints:Word; var PolyPoints);virtual;
                     Procedure OutTextXY(x,y:integer;S:String);virtual;
                    end;
implementation
uses Graph,gvISION;
{ TPictureScroller }
function TPictureScroller.Overlayed:boolean;
{Must be called at begin of Draw method
  like if Overlayed then exit;}
var B:TDrawBuffer;
    P1,P2:TPoint;
begin
 MoveChar(b,#255,$FF,Size.X);
 WriteLine(0,0,Size.X,Size.Y,B);
 P1.X:=0;P1.Y:=0;
 MakeGlobal(P1,P1);
 MakeGlobal(Size,P2);
 asm
  Push es
  Push ds
  les Di,Self
  Mov CX,ES:[Di].TView.Size.Y
  Mov DX,ES:[DI].TView.Size.X
  Mov Si,Offset FirstBuffer
  Les si,[SI]
  Mov ax,p1.Y
  mov bl,160
  mul bl
  add si,Ax
  add Si,P1.X
  add SI,P1.X
  mov di,si
  Mov ax,0ffffh
  Push Ds
  Push es
  Pop ds
  Pop es
@@1:push Cx
    mov cx,dx
@@2:Lodsw
    cmp ax,0FFFFh
    jnz @@3
     Loop @@2
    add di,160
    mov si,di
    pop cx
    Loop @@1
    Mov al,False
    jmp  @@4
@@3:mov al,True
    Pop Cx
@@4:pop ds
    Pop es
    Mov @Result,AL
end;
 MoveChar(b,' ',GetColor(1),Size.X);
 WriteLine(0,0,Size.X,Size.Y,B);
 RefreshDisplay;
 MakeGraphic(p1,p1);
 MakeGraphic(p2,p2);
 SetViewPort(P1.X,P1.Y,P2.X,P2.Y,ClipOn);
end;

Procedure TPictureScroller.MakeGraphic(Src:TPoint;Var Dest:TPoint);
{Converts text coordinates to graphic coords of top left
 corner of symbol (global to global, local to local}
begin
 Dest.X:=Src.X shl 3;
 Dest.Y:=Src.Y * GraphStringHeight;
end;

Procedure TPictureScroller.GetGraphicLimits(var Limits:TRect);

 {Returns Global graphic coordinates of view}
var R:TRect;
begin
 MakeGlobal(ZeroPoint,R.A);
 MakeGlobal(Size,R.B);
 MakeGraphicRect(R,Limits);
end;

Procedure TPictureScroller.GetGraphicExtent(var Extent:TRect);
 {Returns Local graphic coordinates of view}
begin
 MakeGraphic(Size,Extent.B);
 Extent.A:=ZeroPoint;
end;

Procedure TPictureScroller.MakeGraphicRect(Src:TRect;Var Dest:TRect);
{converts text rectangle to graphic }
begin
 MakeGraphic(Src.A,Dest.A);
 MakeGraphic(Src.B,Dest.B);
end;

    { TGraphScroller }
Procedure TGraphScroller.SetLimit(X,Y:Integer);
begin
  Limit.X := X;
  Limit.Y := Y;
  if HScrollBar <> nil then
    HScrollBar^.SetParams(HScrollBar^.Value, 0, X - Size.X shl 3, (Size.X - 1)*8, 8);
  if VScrollBar <> nil then
    VScrollBar^.SetParams(VScrollBar^.Value, 0, Y - Size.Y*GraphStringHeight, (Size.Y - 1)*GraphStringHeight,
     GraphStringHeight);
end;

Procedure TGraphScroller.ChangeBounds(var Bounds:TRect);
begin
  SetBounds(Bounds);
  SetLimit(Limit.X, Limit.Y);
  DrawView;
end;

Procedure TGraphScroller.MapMouse(var P:TPoint);
var Z:TPoint;
begin
 MakeGlobal(ZeroPoint,Z);
 MakeGraphic(Z,Z);
 P.X:=Delta.X+GraphMouseWhere.X-Z.X;
 P.Y:=Delta.Y+GraphMouseWhere.Y-Z.Y;
end;

{ TVirtualScreen }
procedure TVirtualScreen.PutPixel(x,y:integer;Pixel:Word);
begin
 Graph.PutPixel(X-Delta.X,Y-Delta.Y,Pixel);
end;

procedure TVirtualScreen.Line(x1,y1,x2,y2:integer);
begin
 With Delta do
  Graph.Line(X1-x,y1-y,x2-x,y2-y);
end;

Procedure TVirtualScreen.MoveTo(x,y:integer);
begin
 Graph.MoveTo(X-Delta.X,Y-Delta.Y);
end;

Procedure TVirtualScreen.LineTo(x,Y:integer);
begin
 Graph.LineTo(X-Delta.X,Y-Delta.Y);
end;

Procedure TVirtualScreen.Circle(x,y:integer;Radius:word);
begin
 Graph.Circle(X-Delta.X,Y-Delta.Y,Radius);
end;

Procedure TVirtualScreen.Ellipse(X,Y:Integer;StAngle,EndAngle:word;XRadius,YRadius:Word);
begin
 Graph.Ellipse(X-Delta.X,Y-Delta.Y,StAngle,EndAngle,XRadius,YRadius);
end;

Procedure TVirtualScreen.Arc(X,Y:Integer;StAngle,EndAngle:word;Radius:Word);
begin
 Graph.Arc(X-Delta.X,Y-Delta.Y,StAngle,EndAngle,Radius);
end;

Procedure TVirtualScreen.PieSlice(X,Y:Integer;StAngle,EndAngle:word;Radius:Word);
begin
 Graph.PieSlice(X-Delta.X,Y-Delta.Y,StAngle,EndAngle,Radius);
end;

Procedure TVirtualScreen.FillEllipse(X,Y:Integer;XRadius,YRadius:Word);
begin
 Graph.FillEllipse(X-Delta.X,Y-Delta.Y,XRadius,YRadius);
end;

Procedure TVirtualScreen.DrawPoly(NumPoints:Word; var PolyPoints);
begin
end;

Procedure TVirtualScreen.FillPoly(NumPoints:Word; var PolyPoints);
begin
end;

Procedure TVirtualScreen.OutTextXY(x,y:integer;S:String);
begin
 Graph.OutTextXY(X-Delta.X,Y-Delta.Y,S);
end;

end.

