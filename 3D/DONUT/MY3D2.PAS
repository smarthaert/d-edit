Unit My3D2;

Interface

Uses Fade,Vectors;

{.$Define QuickSort}

Const FixMult=$200;

Const MaxPoints=1000;
      MaxFaces=1000;
      MaxTextures=80;
      Factor=200*FixMult;

Type TShading=(ShadingOff,ZFlat,Lambert,Gouraud,Phong);
     TMapping=(WireFrame,MappingOff,LinearTexture,Environment);
     TAttribs=(RemoveHidden,DepthSort);
Type TFace=Record
                 P1,P2,P3,P4:Word;
                 Shading:TShading;
                 Mapping:TMapping;
                 Col:Byte;
                 Texture:Byte;
                 FaceNormal:TPoint;
           End;
Type TTexture=Record
                    FileName:Array [0..30] Of Char;
                    Data:Pointer;
                    Palette:TPal;
              End;
Type TPoints=Array [0..MaxPoints-1] Of TPoint;
Type TFaces=Array [0..MaxFaces-1] Of TFace;
Type TTextures=Array [0..MaxTextures] Of TTexture;
Type TObject=Record
                   Attribs:Set Of TAttribs;
                   ObjCoords,
                   ObjRotate:TPoint;
                   NOfShades,
                   NOfColors,
                   NOfPoints,
                   NOfFaces,
                   NOfTextures:Word;
                   Points:^TPoints;
                   PointNormals:^TPoints;
                   Faces:^TFaces;
                   Textures:^TTextures;
             End;

Const Cam:TPoint=(X:-160*FixMult;Y:-100*FixMult;Z:-100*FixMult);
      Light:TPoint=(X:0*FixMult;Y:0*FixMult;Z:1*FixMult);

Procedure Rotate(X,Y,Z:LongInt; RX,RY,RZ:LongInt; Var NX,NY,NZ:LongInt);
Procedure DrawObject(O:TObject);
Procedure RotateObject(Var O:TObject; RX,RY,RZ:LongInt);
Procedure CalcFaceNormals(O:TObject);
Procedure CalcPointNormals(O:TObject);
Procedure LoadObject(FileName:String; Var O:TObject);
Procedure SaveObject(FileName:String; O:TObject);
Procedure FreeObject(O:TObject);

Implementation

Uses NColor,Fix,Format,ATTools,Polys;

Procedure Rotate;

Var I:Integer;
    C,S,T:LongInt;

Begin
     C:=FixCos(RX);
     S:=FixSin(RX);
     NZ:=FixMul(C,Z)-FixMul(S,Y);
     NY:=FixMul(S,Z)+FixMul(C,Y);
     C:=FixCos(RY);
     S:=FixSin(RY);
     NX:=FixMul(C,X)-FixMul(S,NZ);
     NZ:=FixMul(S,X)+FixMul(C,NZ);
     C:=FixCos(RZ);
     S:=FixSin(RZ);
     T:=FixMul(C,NX)-FixMul(S,NY);
     NY:=FixMul(S,NX)+FixMul(C,NY);
     NX:=T;
End;

Procedure DrawObject;

Var PointsBuffer:^TPoints;
    FNormalsBuffer:^TPoints;
    PNormalsBuffer:^TPoints;
    PBufferSize,FBufferSize:Word;

Function GetScreenX(P:TPoint):Integer;

Begin
     If -P.Z<>Cam.Z Then GetScreenX:=Fix2Int(FixDiv(FixMul(Factor,P.X),P.Z+Cam.Z)-Cam.X)
                    Else GetScreenX:=Fix2Int(Cam.X);
End;

Function GetScreenY(P:TPoint):Integer;

Begin
     If -P.Z<>Cam.Z Then GetScreenY:=Fix2Int(FixDiv(FixMul(Factor,P.Y),P.Z+Cam.Z)-Cam.Y)
                    Else GetScreenY:=Fix2Int(Cam.Y);
End;

Procedure RotatePoints;

Var I:Integer;

Begin
     For I:=0 To O.NOfPoints-1 Do With O Do
         Rotate(Points^[I].X,Points^[I].Y,Points^[I].Z,
                ObjRotate.X,ObjRotate.Y,ObjRotate.Z,
                PointsBuffer^[I].X,PointsBuffer^[I].Y,PointsBuffer^[I].Z);
End;

Procedure RotateFNormals;

Var I:Integer;

Begin
     For I:=0 To O.NOfFaces-1 Do With O Do
         Rotate(Faces^[I].FaceNormal.X,Faces^[I].FaceNormal.Y,Faces^[I].FaceNormal.Z,
                ObjRotate.X,ObjRotate.Y,ObjRotate.Z,
                FNormalsBuffer^[I].X,FNormalsBuffer^[I].Y,FNormalsBuffer^[I].Z);
End;

Procedure RotatePNormals;

Var I:Integer;

Begin
     For I:=0 To O.NOfPoints-1 Do With O Do
         Rotate(PointNormals^[I].X,PointNormals^[I].Y,PointNormals^[I].Z,
                ObjRotate.X,ObjRotate.Y,ObjRotate.Z,
                PNormalsBuffer^[I].X,PNormalsBuffer^[I].Y,PNormalsBuffer^[I].Z);{}
End;

Procedure RemoveHiddenFaces;

Var I:Integer;
    T:TFace;

Begin
     I:=0;
     With O Do
          Repeat
                If ((GetScreenX(PointsBuffer^[Faces^[I].P1])-GetScreenX(PointsBuffer^[Faces^[I].P2]))*
                    (GetScreenY(PointsBuffer^[Faces^[I].P3])-GetScreenY(PointsBuffer^[Faces^[I].P2])))-
                   ((GetScreenY(PointsBuffer^[Faces^[I].P1])-GetScreenY(PointsBuffer^[Faces^[I].P2]))*
                    (GetScreenX(PointsBuffer^[Faces^[I].P3])-GetScreenX(PointsBuffer^[Faces^[I].P2])))>=0 Then
                   Begin
                        T:=Faces^[I];
                        Faces^[I]:=Faces^[NOfFaces-1];
                        Faces^[NOfFaces-1]:=T;
                        Dec(NOfFaces);
                   End
                Else Inc(I);
          Until I=NOfFaces;
End;

Procedure DepthSortFaces;
{$IfDef QuickSort}
Var Temp:TFace;
    X:Integer;

Procedure QuickSort(L,R:Integer);

Var i,j:Integer;

Begin
     With O Do
          Begin
               i:=l;
               j:=r;
               X:=PointsBuffer^[Faces^[(l+r) Div 2].P1].Z+
                  PointsBuffer^[Faces^[(l+r) Div 2].P2].Z+
                  PointsBuffer^[Faces^[(l+r) Div 2].P3].Z+
                  PointsBuffer^[Faces^[(l+r) Div 2].P4].Z;
               Repeat
                     While PointsBuffer^[Faces^[i].P1].Z+
                           PointsBuffer^[Faces^[i].P2].Z+
                           PointsBuffer^[Faces^[i].P3].Z+
                           PointsBuffer^[Faces^[i].P4].Z<X Do Inc(i);
                     While PointsBuffer^[Faces^[j].P1].Z+
                           PointsBuffer^[Faces^[j].P2].Z+
                           PointsBuffer^[Faces^[j].P3].Z+
                           PointsBuffer^[Faces^[j].P4].Z>X Do Dec(j);
                     If i<=j Then
                        Begin
                             Temp:=Faces^[i];
                             Faces^[i]:=Faces^[j];
                             Faces^[j]:=Temp;
                             Inc(i);
                             Dec(j);
                        End;
               Until i>j;
               If l<j Then QuickSort(l,j);
               If r>i Then QuickSort(i,r);
          End;
End;

Begin
     QuickSort(0,O.NOfFaces-1);
End;
{$Else}
Var Pos:Integer;
    Temp:TFace;

Begin
     Pos:=0;
     With O Do
          Repeat
                If PointsBuffer^[Faces^[Pos].P1].Z+
                   PointsBuffer^[Faces^[Pos].P2].Z+
                   PointsBuffer^[Faces^[Pos].P3].Z>
                   PointsBuffer^[Faces^[Pos+1].P1].Z+
                   PointsBuffer^[Faces^[Pos+1].P2].Z+
                   PointsBuffer^[Faces^[Pos+1].P3].Z Then
                   Begin
                        Temp:=Faces^[Pos+1];
                        Faces^[Pos+1]:=Faces^[Pos];
                        Faces^[Pos]:=Temp;
                        Pos:=0;
                   End
                Else Inc(Pos);
          Until Pos=NOfFaces-1;
End;
{$EndIf}

Var CFace:Integer;
    BaseCol1,BaseCol2,BaseCol3,BaseCol4:Integer;
    C1,C2,C3,C4:TPoint;

Begin
     PBufferSize:=O.NOfPoints*SizeOf(TPoint);
     FBufferSize:=O.NOfFaces*SizeOf(TPoint);
     GetMem(PointsBuffer,PBufferSize);
     GetMem(PNormalsBuffer,PBufferSize);
     GetMem(FNormalsBuffer,FBufferSize);
     RotatePoints;
     If RemoveHidden In O.Attribs Then RemoveHiddenFaces;
     If DepthSort In O.Attribs Then DepthSortFaces;
     RotateFNormals;
     RotatePNormals;
     For CFace:=0 To O.NOfFaces-1 Do
         With O.Faces^[CFace] Do
              Begin
                   C1:=PointsBuffer^[P1];
                   C2:=PointsBuffer^[P2];
                   C3:=PointsBuffer^[P3];
                   C4:=PointsBuffer^[P4];
                   Case Mapping Of
                        WireFrame:;
                        MappingOff:Begin
                                        Case Shading Of
                                             ShadingOff:BaseCol1:=Col;
                                             ZFlat:BaseCol1:=Col*O.NOfShades+
                                                             Fix2Int(C1.Z+
                                                                     C2.Z+
                                                                     C3.Z+
                                                                     C4.Z) Div (O.NOfShades Div 4);
                                             Lambert:BaseCol1:=Col*O.NOfShades-
                                                               Round((Fix2Real(FNormalsBuffer^[CFace].X)*
                                                                      Fix2Real(Light.X)+
                                                                      Fix2Real(FNormalsBuffer^[CFace].Y)*
                                                                      Fix2Real(Light.Y)+
                                                                      Fix2Real(FNormalsBuffer^[CFace].Z)*
                                                                      Fix2Real(Light.Z))*(O.NOfShades-1));
                                             Gouraud:Begin
                                                          BaseCol1:=Col*O.NOfShades-
                                                                    Round((Fix2Real(PNormalsBuffer^[P1].X)*
                                                                           Fix2Real(Light.X)+
                                                                           Fix2Real(PNormalsBuffer^[P1].Y)*
                                                                           Fix2Real(Light.Y)+
                                                                           Fix2Real(PNormalsBuffer^[P1].Z)*
                                                                           Fix2Real(Light.Z))*(O.NOfShades-1));
                                                          If BaseCol1<Col*O.NOfShades Then BaseCol1:=Col*O.NOfShades;
                                                          BaseCol2:=Col*O.NOfShades-
                                                                    Round((Fix2Real(PNormalsBuffer^[P2].X)*
                                                                           Fix2Real(Light.X)+
                                                                           Fix2Real(PNormalsBuffer^[P2].Y)*
                                                                           Fix2Real(Light.Y)+
                                                                           Fix2Real(PNormalsBuffer^[P2].Z)*
                                                                           Fix2Real(Light.Z))*(O.NOfShades-1));
                                                          If BaseCol2<Col*O.NOfShades Then BaseCol2:=Col*O.NOfShades;
                                                          BaseCol3:=Col*O.NOfShades-
                                                                    Round((Fix2Real(PNormalsBuffer^[P3].X)*
                                                                           Fix2Real(Light.X)+
                                                                           Fix2Real(PNormalsBuffer^[P3].Y)*
                                                                           Fix2Real(Light.Y)+
                                                                           Fix2Real(PNormalsBuffer^[P3].Z)*
                                                                           Fix2Real(Light.Z))*(O.NOfShades-1));
                                                          If BaseCol3<Col*O.NOfShades Then BaseCol3:=Col*O.NOfShades;
                                                          BaseCol4:=Col*O.NOfShades-
                                                                    Round((Fix2Real(PNormalsBuffer^[P4].X)*
                                                                           Fix2Real(Light.X)+
                                                                           Fix2Real(PNormalsBuffer^[P4].Y)*
                                                                           Fix2Real(Light.Y)+
                                                                           Fix2Real(PNormalsBuffer^[P4].Z)*
                                                                           Fix2Real(Light.Z))*(O.NOfShades-1));
                                                          If BaseCol4<Col*O.NOfShades Then BaseCol4:=Col*O.NOfShades;
                                                     End;
{                                             Phong:;{sun, fun and nothing to do!}
                                        End;
                                        If Shading=Phong Then
                                           PhongPoly(GetScreenX(C1),GetScreenY(C1),
                                                     GetScreenX(C2),GetScreenY(C2),
                                                     GetScreenX(C3),GetScreenY(C3),
                                                     GetScreenX(C4),GetScreenY(C4),
                                                     PNormalsBuffer^[P1],
                                                     PNormalsBuffer^[P2],
                                                     PNormalsBuffer^[P3],
                                                     PNormalsBuffer^[P4],
                                                     Light,O.NOfShades,Col) Else
                                        If Shading=Gouraud Then
                                           InterpolatePoly(GetScreenX(C1),GetScreenY(C1),
                                                           GetScreenX(C2),GetScreenY(C2),
                                                           GetScreenX(C3),GetScreenY(C3),
                                                           GetScreenX(C4),GetScreenY(C4),
                                                           BaseCol1,BaseCol2,BaseCol3,BaseCol4)
                                        Else FillPoly(GetScreenX(C1),GetScreenY(C1),
                                                      GetScreenX(C2),GetScreenY(C2),
                                                      GetScreenX(C3),GetScreenY(C3),
                                                      GetScreenX(C4),GetScreenY(C4),
                                                      BaseCol1);
                                   End;
                        LinearTexture:TexturePoly(GetScreenX(C1),GetScreenY(C1),
                                                  GetScreenX(C2),GetScreenY(C2),
                                                  GetScreenX(C3),GetScreenY(C3),
                                                  GetScreenX(C4),GetScreenY(C4),
                                                  O.Textures^[Texture].Data);
                        Environment:;
                   End;
              End;
     FreeMem(PointsBuffer,PBufferSize);
     FreeMem(PNormalsBuffer,PBufferSize);
     FreeMem(FNormalsBuffer,FBufferSize);
End;

Procedure RotateObject;

Begin
     With O.ObjRotate Do
          Begin
               Inc(X,RX);
               Inc(Y,RY);
               Inc(Z,RZ);
{               If (X>128) Then X:=00;
               If (X<00) Then X:=128;
               If (Y>128) Then Y:=00;
               If (Y<00) Then Y:=128;
               If (Z>128) Then Z:=00;
               If (Z<00) Then Z:=128;}
          End;
End;

Procedure CalcFaceNormals;

Var I:Integer;
    Length:Real;

Begin
     For I:=0 To O.NOfFaces-1 Do
         With O.Faces^[I] Do
              Begin
                   FaceNormal.X:=(Fix2Int(O.Points^[P2].Y)-Fix2Int(O.Points^[P1].Y))*
                                 (Fix2Int(O.Points^[P1].Z)-Fix2Int(O.Points^[P3].Z))-
                                 (Fix2Int(O.Points^[P2].Z)-Fix2Int(O.Points^[P1].Z))*
                                 (Fix2Int(O.Points^[P1].Y)-Fix2Int(O.Points^[P3].Y));
                   FaceNormal.Y:=(Fix2Int(O.Points^[P2].Z)-Fix2Int(O.Points^[P1].Z))*
                                 (Fix2Int(O.Points^[P1].X)-Fix2Int(O.Points^[P3].X))-
                                 (Fix2Int(O.Points^[P2].X)-Fix2Int(O.Points^[P1].X))*
                                 (Fix2Int(O.Points^[P1].Z)-Fix2Int(O.Points^[P3].Z));
                   FaceNormal.Z:=(Fix2Int(O.Points^[P2].X)-Fix2Int(O.Points^[P1].X))*
                                 (Fix2Int(O.Points^[P1].Y)-Fix2Int(O.Points^[P3].Y))-
                                 (Fix2Int(O.Points^[P2].Y)-Fix2Int(O.Points^[P1].Y))*
                                 (Fix2Int(O.Points^[P1].X)-Fix2Int(O.Points^[P3].X));
                   With FaceNormal Do
                        Begin
                             Length:=SQRT(X*X+Y*Y+Z*Z);
                             If Length<>0 Then
                                Begin
                                     X:=Real2Fix(X/Length);
                                     Y:=Real2Fix(Y/Length);
                                     Z:=Real2Fix(Z/Length);
                                End;
                        End;
              End;
End;

Procedure CalcPointNormals;

Var I,II:Integer;
    NOfFacesPerPoint:Word;
    Temp:Record
               X,Y,Z:Real;
         End;
    Length:Real;

Begin
     With O Do
          For I:=0 To NOfPoints-1 Do
              Begin
                   Temp.X:=0;
                   Temp.Y:=0;
                   Temp.Z:=0;
                   NOfFacesPerPoint:=0;
                   For II:=0 To NOfFaces-1 Do
                       If (Faces^[II].P1=I) Or
                          (Faces^[II].P2=I) Or
                          (Faces^[II].P3=I) Or
                          (Faces^[II].P4=I) Then
                          Begin
                               Temp.X:=Temp.X+Fix2Real(Faces^[II].FaceNormal.X);
                               Temp.Y:=Temp.Y+Fix2Real(Faces^[II].FaceNormal.Y);
                               Temp.Z:=Temp.Z+Fix2Real(Faces^[II].FaceNormal.Z);
                               Inc(NOfFacesPerPoint);
                          End;
                   If NOfFacesPerPoint>0 Then
                      Begin
{                           Temp.X:=Temp.X/NOfFacesPerPoint;
                           Temp.Y:=Temp.Y/NOfFacesPerPoint;
                           Temp.Z:=Temp.Z/NOfFacesPerPoint;}
                           Length:=SQRT(Temp.X*Temp.X+Temp.Y*Temp.Y+Temp.Z*Temp.Z);
                           If Length<>0 Then
                              Begin
                                   PointNormals^[I].X:=Real2Fix(Temp.X/Length);
                                   PointNormals^[I].Y:=Real2Fix(Temp.Y/Length);
                                   PointNormals^[I].Z:=Real2Fix(Temp.Z/Length);
                              End;
                      End;
              End;
End;

Procedure LoadObject;

Var F:File;
    I:Integer;

Begin
     Assign(F,FileName);
     ReSet(F,1);
     With O Do
          Begin
               BlockRead(F,Attribs,SizeOf(Attribs));
               BlockRead(F,ObjCoords,SizeOf(ObjCoords));
               BlockRead(F,ObjRotate,SizeOf(ObjRotate));
               BlockRead(F,NOfShades,SizeOf(NOfShades));
               BlockRead(F,NOfColors,SizeOf(NOfColors));{}
               BlockRead(F,NOfPoints,SizeOf(NOfPoints));
               BlockRead(F,NOfFaces,SizeOf(NOfFaces));
               BlockRead(F,NOfTextures,SizeOf(NOfTextures));
               If NOfPoints>0 Then
                  Begin
                       GetMem(Points,NOfPoints*SizeOf(TPoint));
                       GetMem(PointNormals,NOfPoints*SizeOf(TPoint));
                       For I:=0 To NOfPoints-1 Do
                           BlockRead(F,Points^[I],SizeOf(Points^[I]));
                  End;
               If NOfFaces>0 Then
                  Begin
                       GetMem(Faces,NOfFaces*SizeOf(TFace));
                       For I:=0 To NOfFaces-1 Do
                           BlockRead(F,Faces^[I],SizeOf(Faces^[I]));
                  End;
               If NOfTextures>0 Then
                  Begin
                       GetMem(Textures,NOfTextures*SizeOf(TTexture));
                       For I:=0 To NOfTextures-1 Do
                           Begin
                                BlockRead(F,Textures^[I],SizeOf(Textures^[I]));
                                If Pos('.PCX',UpString(Textures^[I].FileName))<>0 Then
                                   LoadPCX(Textures^[I].FileName,Textures^[I].Data,Textures^[I].Palette) Else
                                If Pos('.BMP',UpString(Textures^[I].FileName))<>0 Then
                                   LoadBMP(Textures^[I].FileName,Textures^[I].Data,Textures^[I].Palette);
                           End;
                  End;
          End;
     CalcFaceNormals(O);
     CalcPointNormals(O);
     Close(F);
End;

Procedure SaveObject;

Var F:File;
    I:Integer;

Begin
     Assign(F,FileName);
     ReWrite(F,1);
     With O Do
          Begin
               BlockWrite(F,Attribs,SizeOf(Attribs));
               BlockWrite(F,ObjCoords,SizeOf(ObjCoords));
               BlockWrite(F,ObjRotate,SizeOf(ObjRotate));
               BlockWrite(F,NOfShades,SizeOf(NOfShades));
               BlockWrite(F,NOfColors,SizeOf(NOfColors));
               BlockWrite(F,NOfPoints,SizeOf(NOfPoints));
               BlockWrite(F,NOfFaces,SizeOf(NOfFaces));
               BlockWrite(F,NOfTextures,SizeOf(NOfTextures));
               If NOfPoints>0 Then
                  Begin
                       For I:=0 To NOfPoints-1 Do
                           BlockWrite(F,Points^[I],SizeOf(Points^[I]));
                  End;
               If NOfFaces>0 Then
                  Begin
                       For I:=0 To NOfFaces-1 Do
                           BlockWrite(F,Faces^[I],SizeOf(Faces^[I]));
                  End;
               If NOfTextures>0 Then
                  Begin
                       For I:=0 To NOfTextures-1 Do
                           BlockWrite(F,Textures^[I],SizeOf(Textures^[I]));
                  End;
          End;
     Close(F);
End;

Procedure FreeObject;

Var I:Integer;

Begin
     With O Do
          Begin
               If NOfPoints>0 Then
                  Begin
                       FreeMem(Points,NOfPoints*SizeOf(TPoint));
                       FreeMem(PointNormals,NOfPoints*SizeOf(TPoint));
                  End;
               If NOfFaces>0 Then FreeMem(Faces,NOfFaces*SizeOf(TFace));
               If NOfTextures>0 Then
                  Begin
                       For I:=0 To NOfTextures-1 Do
                           FreeSprite(Textures^[I].Data);
                       FreeMem(Textures,NOfTextures*SizeOf(TTexture));
                  End;
          End;
End;

Begin
     InitSinCos;
End.