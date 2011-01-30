Unit Polys;

Interface

Uses Vectors;

Procedure FillPoly(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; Col:Byte);
Procedure InterpolatePoly(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; C1,C2,C3,C4:Byte);
Procedure PhongPoly(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; N1,N2,N3,N4,L:TPoint; Shades:Word; BaseCol:Byte);
Procedure TexturePoly(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; Texture:Pointer);

Implementation

Uses NColor,Fix;

Procedure FillPoly;

Const FracBits=16;

Var YMin,YMax,YCurr:Integer;
    XMin,XMax:Integer;
    DX1,DX2,DX3,DX4:LongInt;
    XP1,XP2,XP3,XP4:LongInt;
    Temp:Integer;

Begin
     YMin:=Y1;
     YMax:=Y1;
     If (Y2<YMin) Then YMin:=Y2;
     If (Y2>YMax) Then YMax:=Y2;
     If (Y3<YMin) Then YMin:=Y3;
     If (Y3>YMax) Then YMax:=Y3;
     If (Y4<YMin) Then YMin:=Y4;
     If (Y4>YMax) Then YMax:=Y4;

     {Xpos in 16.16 fixed point math }
     If Y1<Y2 Then XP1:=LongInt(X1) Shl FracBits
              Else XP1:=LongInt(X2) Shl FracBits;
     If Y2<Y3 Then XP2:=LongInt(X2) Shl FracBits
              Else XP2:=LongInt(X3) Shl FracBits;
     If Y3<Y4 Then XP3:=LongInt(X3) Shl FracBits
              Else XP3:=LongInt(X4) Shl FracBits;
     If Y4<Y1 Then XP4:=LongInt(X4) Shl FracBits
              Else XP4:=LongInt(X1) Shl FracBits;

     If Y1=Y2 Then DX1:=0
              Else DX1:=(LongInt(X1-X2) Shl FracBits) Div (Y1-Y2);
     If Y2=Y3 Then DX2:=0
              Else DX2:=(LongInt(X2-X3) Shl FracBits) Div (Y2-Y3);
     If Y3=Y4 Then DX3:=0
              Else DX3:=(LongInt(X3-X4) Shl FracBits) Div (Y3-Y4);
     If Y4=Y1 Then DX4:=0
              Else DX4:=(LongInt(X4-X1) Shl FracBits) Div (Y4-Y1);

     For YCurr:=YMin To YMax Do
         Begin
              XMin:=32000;
              XMax:=-32000;
              If ((YCurr<=Y1) And (YCurr>=Y2)) Or
                 ((YCurr<=Y2) And (YCurr>=Y1)) Then
                 Begin
                      XMin:=XP1 Shr FracBits;
                      XMax:=XMin;
                      Inc(XP1,DX1);
                 End;
              If ((YCurr<=Y2) And (YCurr>=Y3)) Or
                 ((YCurr<=Y3) And (YCurr>=Y2)) Then
                 Begin
                      Temp:=XP2 Shr FracBits;
                      If Temp<XMin Then XMin:=Temp;
                      If Temp>XMax Then XMax:=Temp;
                      Inc(XP2,DX2);
                 End;
              If ((YCurr<=Y3) And (YCurr>=Y4)) Or
                 ((YCurr<=Y4) And (YCurr>=Y3)) Then
                 Begin
                      Temp:=XP3 Shr FracBits;
                      If Temp<XMin Then XMin:=Temp;
                      If Temp>XMax Then XMax:=Temp;
                      Inc(XP3,DX3);
                 End;
              If ((YCurr<=Y4) And (YCurr>=Y1)) Or
                 ((YCurr<=Y1) And (YCurr>=Y4)) Then
                 Begin
                      Temp:=XP4 Shr FracBits;
                      If Temp<XMin Then XMin:=Temp;
                      If Temp>XMax Then XMax:=Temp;
                      Inc(XP4,DX4);
                 End;
              HLine(XMin,YCurr,XMax-XMin+1,Col);
         End;
End;

Procedure InterpolatePoly;

Const FracBits=16;

Var YMin,YMax,YCurr:Integer;
    XMin,XMax:Integer;
    DX1,DX2,DX3,DX4:LongInt;
    XP1,XP2,XP3,XP4:LongInt;
    Temp:Integer;
    CP1,CP2,CP3,CP4:LongInt;
    CD1,CD2,CD3,CD4:LongInt;
    CL,CR:Byte;

Begin
     YMin:=Y1;
     YMax:=Y1;
     If (Y2<YMin) Then YMin:=Y2;
     If (Y2>YMax) Then YMax:=Y2;
     If (Y3<YMin) Then YMin:=Y3;
     If (Y3>YMax) Then YMax:=Y3;
     If (Y4<YMin) Then YMin:=Y4;
     If (Y4>YMax) Then YMax:=Y4;

     {Xpos in 16.16 fixed point math }
     If Y1<Y2 Then Begin XP1:=LongInt(X1) Shl FracBits; CP1:=LongInt(C1) Shl FracBits End
              Else Begin XP1:=LongInt(X2) Shl FracBits; CP1:=LongInt(C2) Shl FracBits End;
     If Y2<Y3 Then Begin XP2:=LongInt(X2) Shl FracBits; CP2:=LongInt(C2) Shl FracBits End
              Else Begin XP2:=LongInt(X3) Shl FracBits; CP2:=LongInt(C3) Shl FracBits End;
     If Y3<Y4 Then Begin XP3:=LongInt(X3) Shl FracBits; CP3:=LongInt(C3) Shl FracBits End
              Else Begin XP3:=LongInt(X4) Shl FracBits; CP3:=LongInt(C4) Shl FracBits End;
     If Y4<Y1 Then Begin XP4:=LongInt(X4) Shl FracBits; CP4:=LongInt(C4) Shl FracBits End
              Else Begin XP4:=LongInt(X1) Shl FracBits; CP4:=LongInt(C1) Shl FracBits End;

     If Y1=Y2 Then Begin DX1:=0; CD1:=0; End
              Else Begin DX1:=(LongInt(X1-X2) Shl FracBits) Div (Y1-Y2);
                         CD1:=(LongInt(C1-C2) Shl FracBits) Div (Y1-Y2); End;
     If Y2=Y3 Then Begin DX2:=0; CD2:=0; End
              Else Begin DX2:=(LongInt(X2-X3) Shl FracBits) Div (Y2-Y3);
                         CD2:=(LongInt(C2-C3) Shl FracBits) Div (Y2-Y3); End;
     If Y3=Y4 Then Begin DX3:=0; CD3:=0; End
              Else Begin DX3:=(LongInt(X3-X4) Shl FracBits) Div (Y3-Y4);
                         CD3:=(LongInt(C3-C4) Shl FracBits) Div (Y3-Y4); End;
     If Y4=Y1 Then Begin DX4:=0; CD4:=0; End
              Else Begin DX4:=(LongInt(X4-X1) Shl FracBits) Div (Y4-Y1);
                         CD4:=(LongInt(C4-C1) Shl FracBits) Div (Y4-Y1); End;
     For YCurr:=YMin To YMax Do
         Begin
              XMin:=32000;
              XMax:=-32000;
              If ((YCurr<=Y1) And (YCurr>=Y2)) Or
                 ((YCurr<=Y2) And (YCurr>=Y1)) Then
                 Begin
                      XMin:=XP1 Shr FracBits;
                      XMax:=XMin;
                      CL:=CP1 Shr FracBits;
                      CR:=CL;
                      Inc(XP1,DX1);
                      Inc(CP1,CD1);
                 End;
              If ((YCurr<=Y2) And (YCurr>=Y3)) Or
                 ((YCurr<=Y3) And (YCurr>=Y2)) Then
                 Begin
                      Temp:=XP2 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP2 Shr FracBits;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP2 Shr FracBits;
                         End;
                      Inc(XP2,DX2);
                      Inc(CP2,CD2);
                 End;
              If ((YCurr<=Y3) And (YCurr>=Y4)) Or
                 ((YCurr<=Y4) And (YCurr>=Y3)) Then
                 Begin
                      Temp:=XP3 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP3 Shr FracBits;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP3 Shr FracBits;
                         End;
                      Inc(XP3,DX3);
                      Inc(CP3,CD3);
                 End;
              If ((YCurr<=Y4) And (YCurr>=Y1)) Or
                 ((YCurr<=Y1) And (YCurr>=Y4)) Then
                 Begin
                      Temp:=XP4 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP4 Shr FracBits;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP4 Shr FracBits;
                         End;
                      Inc(XP4,DX4);
                      Inc(CP4,CD4);
                 End;
              InterpolateHLine(XMin,YCurr,XMax-XMin+1,CL,CR);
         End;
End;

Procedure TexturePoly(X1,Y1,X2,Y2,X3,Y3,X4,Y4:Integer; Texture:Pointer);

Const FracBits=16;

Procedure TexLine(XMin,Y,XMax,Tex1X,Tex1Y,Tex2X,Tex2Y:Integer; Texture:Pointer);

Var TexDX,TexDY:LongInt;
    CTX,CTY:LongInt;
    XCurr:Integer;

Begin
     If XMax=XMin Then
        Begin
             TexDX:=0;
             TexDY:=0;
        End
     Else Begin
               TexDX:=(LongInt(Tex2X-Tex1X) Shl FracBits) Div (XMax-XMin);
               TexDY:=(LongInt(Tex2Y-Tex1Y) Shl FracBits) Div (XMax-XMin);
          End;
     CTX:=LongInt(Tex1X) Shl FracBits;
     CTY:=LongInt(Tex1Y) Shl FracBits;
     For XCurr:=XMin To XMax Do
         Begin
              PutPixel(XCurr,Y,
                      Mem[Seg(Texture^):Ofs(Texture^)+4+
                      (CTX Shr FracBits)+(CTY Shr FracBits)*64]);
              Inc(CTX,TexDX);
              Inc(CTY,TexDY);
         End;
End;{}

Var YMin,YMax,YCurr:Integer;
    XMin,XMax:Integer;
    DX1,DX2,DX3,DX4:LongInt;
    XP1,XP2,XP3,XP4:LongInt;
    Tex1X,Tex1Y,Tex2X,Tex2Y:Integer;
    Tex1DX,Tex2DX,Tex3DX,Tex4DX:LongInt;
    Tex1P,Tex2P,Tex3P,Tex4P:LongInt;
    Temp:Integer;

Begin
     YMin:=Y1;
     YMax:=Y1;
     If (Y2<YMin) Then YMin:=Y2;
     If (Y2>YMax) Then YMax:=Y2;
     If (Y3<YMin) Then YMin:=Y3;
     If (Y3>YMax) Then YMax:=Y3;
     If (Y4<YMin) Then YMin:=Y4;
     If (Y4>YMax) Then YMax:=Y4;
     {Xpos in 16.16 fixed point math }
     If Y1<Y2 Then
        Begin
             XP1:=LongInt(X1) Shl FracBits;
             Tex1P:=1;
        End
     Else Begin
               XP1:=LongInt(X2) Shl FracBits;
               Tex1P:=64 Shl FracBits;
          End;
     If Y2<Y3 Then
        Begin
             XP2:=LongInt(X2) Shl FracBits;
             Tex2P:=1;
        End
     Else Begin
               XP2:=LongInt(X3) Shl FracBits;
               Tex2P:=64 Shl FracBits;
          End;
     If Y3<Y4 Then
        Begin
             XP3:=LongInt(X3) Shl FracBits;
             Tex3P:=64 Shl FracBits;
        End
     Else Begin
               XP3:=LongInt(X4) Shl FracBits;
               Tex3P:=1;
          End;
     If Y4<Y1 Then
        Begin
             XP4:=LongInt(X4) Shl FracBits;
             Tex4P:=64 Shl FracBits;
        End
     Else Begin
               XP4:=LongInt(X1) Shl FracBits;
               Tex4P:=1;
          End;

     If Y1=Y2 Then
        Begin
             DX1:=0;
             Tex1DX:=0;
        End
     Else Begin
               DX1:=(LongInt(X1-X2) Shl FracBits) Div (Y1-Y2);
               Tex1DX:=(LongInt(64) Shl FracBits) Div (Y2-Y1);
          End;
     If Y2=Y3 Then
        Begin
             DX2:=0;
             Tex2DX:=0;
        End
     Else Begin
               DX2:=(LongInt(X2-X3) Shl FracBits) Div (Y2-Y3);
               Tex2DX:=(LongInt(64) Shl FracBits) Div (Y3-Y2);
          End;
     If Y3=Y4 Then
        Begin
             DX3:=0;
             Tex3DX:=0;
        End
     Else Begin
               DX3:=(LongInt(X3-X4) Shl FracBits) Div (Y3-Y4);
               Tex3DX:=(LongInt(64) Shl FracBits) Div (Y3-Y4);
          End;
     If Y4=Y1 Then
        Begin
             DX4:=0;
             Tex4DX:=0;
        End
     Else Begin
               DX4:=(LongInt(X4-X1) Shl FracBits) Div (Y4-Y1);
               Tex4DX:=(LongInt(64) Shl FracBits) Div (Y4-Y1);
          End;

     For YCurr:=YMin To YMax Do
         Begin
              XMin:=32000;
              XMax:=-32000;
              If ((YCurr<=Y1) And (YCurr>=Y2)) Or
                 ((YCurr<=Y2) And (YCurr>=Y1)) Then
                 Begin
                      XMin:=XP1 Shr FracBits;
                      XMax:=XMin;
                      Tex1X:=Tex1P Shr FracBits;Tex1Y:=0;
                      Tex2X:=Tex1P Shr FracBits;Tex2Y:=0;
                      Inc(XP1,DX1);
                      Inc(Tex1P,Tex1DX);
                 End;
              If ((YCurr<=Y2) And (YCurr>=Y3)) Or
                 ((YCurr<=Y3) And (YCurr>=Y2)) Then
                 Begin
                      Temp:=XP2 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              Tex1X:=64-1;
                              Tex1Y:=Tex2P Shr FracBits;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              Tex2X:=64-1;
                              Tex2Y:=Tex2P Shr FracBits;
                         End;
                      Inc(XP2,DX2);
                      Inc(Tex2P,Tex2DX);
                 End;
              If ((YCurr<=Y3) And (YCurr>=Y4)) Or
                 ((YCurr<=Y4) And (YCurr>=Y3)) Then
                 Begin
                      Temp:=XP3 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              Tex1X:=Tex3P Shr FracBits;
                              Tex1Y:=64-1;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              Tex2X:=Tex3P Shr FracBits;
                              Tex2Y:=64-1;
                         End;
                      Inc(XP3,DX3);
                      Inc(Tex3P,Tex3DX);
                 End;
              If ((YCurr<=Y4) And (YCurr>=Y1)) Or
                 ((YCurr<=Y1) And (YCurr>=Y4)) Then
                 Begin
                      Temp:=XP4 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              Tex1X:=0;
                              Tex1Y:=Tex4P Shr FracBits;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              Tex2X:=0;
                              Tex2Y:=Tex4P Shr FracBits;
                         End;
                      Inc(XP4,DX4);
                      Inc(Tex4P,Tex4DX);
                 End;
              TexLine(XMin,YCurr,XMax,Tex1X,Tex1Y,Tex2X,Tex2Y,Texture);
        End;
End;

Procedure PhongHLine(X,Y,L:Integer; V1,V2,Light:TPoint; Shades:Word; BaseCol:Byte);

Var VOfs,VSeg,I:Integer;
    VD:TPoint;
    Color:Integer;
    Length:LongInt;

Begin
     VOfs:=Y*320+X;
     VSeg:=Seg(VScreen^);
     VD.X:=(V2.X-V1.X) Div L;
     VD.Y:=(V2.Y-V1.Y) Div L;
     VD.Z:=(V2.Z-V1.Z) Div L;
     For I:=1 To L Do
         Begin
              Length:=FixSQRT(FixMul(V1.X,V1.X)+
                              FixMul(V1.Y,V1.Y)+
                              FixMul(V1.Z,V1.Z));
              If Length<>0 Then
                 Begin
                      V1.X:=FixDiv(V1.X,Length);
                      V1.Y:=FixDiv(V1.Y,Length);
                      V1.Z:=FixDiv(V1.Z,Length);
                 End;
              Color:=BaseCol*Shades-
                     Fix2Int((FixMul(V1.X,Light.X)+
                              FixMul(V1.Y,Light.Y)+
                              FixMul(V1.Z,Light.Z))*(Shades-1));
              If Color<BaseCol*Shades Then Color:=BaseCol*Shades;
              If Color>BaseCol*Shades+Shades-1 Then Color:=BaseCol*Shades+Shades-1;{}
              Mem[VSeg:VOfs]:=Color;
              Inc(VOfs);
              Inc(V1.X,VD.X);
              Inc(V1.Y,VD.Y);
              Inc(V1.Z,VD.Z);
         End;
End;

Procedure PhongPoly;

Const FracBits=16;

Var YMin,YMax,YCurr:Integer;
    XMin,XMax:Integer;
    DX1,DX2,DX3,DX4:LongInt;
    XP1,XP2,XP3,XP4:LongInt;
    Temp:Integer;
    CP1,CP2,CP3,CP4:TPoint;
    CD1,CD2,CD3,CD4:TPoint;
    CL,CR:TPoint;

Begin
     YMin:=Y1;
     YMax:=Y1;
     If (Y2<YMin) Then YMin:=Y2;
     If (Y2>YMax) Then YMax:=Y2;
     If (Y3<YMin) Then YMin:=Y3;
     If (Y3>YMax) Then YMax:=Y3;
     If (Y4<YMin) Then YMin:=Y4;
     If (Y4>YMax) Then YMax:=Y4;

     {Xpos in 16.16 fixed point math }
     If Y1<Y2 Then Begin XP1:=LongInt(X1) Shl FracBits; CP1:=N1;End
              Else Begin XP1:=LongInt(X2) Shl FracBits; CP1:=N2;End;
     If Y2<Y3 Then Begin XP2:=LongInt(X2) Shl FracBits; CP2:=N2;End
              Else Begin XP2:=LongInt(X3) Shl FracBits; CP2:=N3;End;
     If Y3<Y4 Then Begin XP3:=LongInt(X3) Shl FracBits; CP3:=N3;End
              Else Begin XP3:=LongInt(X4) Shl FracBits; CP3:=N4;End;
     If Y4<Y1 Then Begin XP4:=LongInt(X4) Shl FracBits; CP4:=N4;End
              Else Begin XP4:=LongInt(X1) Shl FracBits; CP4:=N1;End;

     If Y1=Y2 Then Begin DX1:=0; CD1.X:=0; CD1.Y:=0; CD1.Z:=0;End
              Else Begin DX1:=(LongInt(X1-X2) Shl FracBits) Div (Y1-Y2);
                         CD1.X:=(N1.X-N2.X) Div (Y1-Y2);
                         CD1.Y:=(N1.Y-N2.Y) Div (Y1-Y2);
                         CD1.Z:=(N1.Z-N2.Z) Div (Y1-Y2); End;
     If Y2=Y3 Then Begin DX2:=0; CD2.X:=0; CD2.Y:=0; CD2.Z:=0; End
              Else Begin DX2:=(LongInt(X2-X3) Shl FracBits) Div (Y2-Y3);
                         CD2.X:=(N2.X-N3.X) Div (Y2-Y3);
                         CD2.Y:=(N2.Y-N3.Y) Div (Y2-Y3);
                         CD2.Z:=(N2.Z-N3.Z) Div (Y2-Y3);End;
     If Y3=Y4 Then Begin DX3:=0; CD3.X:=0; CD3.Y:=0; CD3.Z:=0; End
              Else Begin DX3:=(LongInt(X3-X4) Shl FracBits) Div (Y3-Y4);
                         CD3.X:=(N3.X-N4.X) Div (Y3-Y4);
                         CD3.Y:=(N3.Y-N4.Y) Div (Y3-Y4);
                         CD3.Z:=(N3.Z-N4.Z) Div (Y3-Y4);End;
     If Y4=Y1 Then Begin DX4:=0; CD4.X:=0; CD4.Y:=0; CD4.Z:=0; End
              Else Begin DX4:=(LongInt(X4-X1) Shl FracBits) Div (Y4-Y1);
                         CD4.X:=(N4.X-N1.X) Div (Y4-Y1);
                         CD4.Y:=(N4.Y-N1.Y) Div (Y4-Y1);
                         CD4.Z:=(N4.Z-N1.Z) Div (Y4-Y1);End;
     For YCurr:=YMin To YMax Do
         Begin
              XMin:=32000;
              XMax:=-32000;
              If ((YCurr<=Y1) And (YCurr>=Y2)) Or
                 ((YCurr<=Y2) And (YCurr>=Y1)) Then
                 Begin
                      XMin:=XP1 Shr FracBits;
                      XMax:=XMin;
                      CL:=CP1;
                      CR:=CP1;
                      Inc(XP1,DX1);
                      Inc(CP1.X,CD1.X);
                      Inc(CP1.Y,CD1.Y);
                      Inc(CP1.Z,CD1.Z);
                 End;
              If ((YCurr<=Y2) And (YCurr>=Y3)) Or
                 ((YCurr<=Y3) And (YCurr>=Y2)) Then
                 Begin
                      Temp:=XP2 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP2;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP2;
                         End;
                      Inc(XP2,DX2);
                      Inc(CP2.X,CD2.X);
                      Inc(CP2.Y,CD2.Y);
                      Inc(CP2.Z,CD2.Z);
                 End;
              If ((YCurr<=Y3) And (YCurr>=Y4)) Or
                 ((YCurr<=Y4) And (YCurr>=Y3)) Then
                 Begin
                      Temp:=XP3 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP3;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP3;
                         End;
                      Inc(XP3,DX3);
                      Inc(CP3.X,CD3.X);
                      Inc(CP3.Y,CD3.Y);
                      Inc(CP3.Z,CD3.Z);
                 End;
              If ((YCurr<=Y4) And (YCurr>=Y1)) Or
                 ((YCurr<=Y1) And (YCurr>=Y4)) Then
                 Begin
                      Temp:=XP4 Shr FracBits;
                      If Temp<XMin Then
                         Begin
                              XMin:=Temp;
                              CL:=CP4;
                         End;
                      If Temp>XMax Then
                         Begin
                              XMax:=Temp;
                              CR:=CP4;
                         End;
                      Inc(XP4,DX4);
                      Inc(CP4.X,CD4.X);
                      Inc(CP4.Y,CD4.Y);
                      Inc(CP4.Z,CD4.Z);
                 End;
              PhongHLine(XMin,YCurr,XMax-XMin+1,CL,CR,L,Shades,BaseCol);
         End;
End;

End.