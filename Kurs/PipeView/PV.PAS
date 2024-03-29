{ 浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融 }
{ �  敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕  � }
{ �  �                  P I P E   V I E W E R                   �  � }
{ �  青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰  � }
{ 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕 }

Uses CRT,DOS,Graph,Config;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖         ��痰ガ�襯 蹍罐ゃ琺          崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = �｀� � 蹍������ = = = }
  Procedure Runtime_Error( Message:String );
    Begin
      CloseGraph;
      Writeln(' Runtime Error : ',Message);
      Halt(1);
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖         �ォ痰※皀�讚襯 ��甄�         崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = �ォ痰※皀�讚�� ��甄� = = = }
  Type Real_Type = Real;

 { = = = ���瓱���讚�� �ォ痰※皀�讚�� ��甄� = = = }
  Const Max_Real = 1E38;

 { = = = �┃�祠 ├ 2-� ��瓮� = = = }
  Function Min( R1,R2:Real_Type ):Real_Type;
    Begin
      If R1 < R2 then Min:=R1 Else Min:=R2;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖               3D ��腦�               崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = 3D ��腦� = = = }
  Type
    Point_3D = Object
      X,Y,Z:Real_Type;
    End;

 { = = = ������ ���爐┃�� = = = }
  Const Null_Point:Point_3D = (X:0;Y:0;Z:0);

 { = = = ���罔��├�罔� ���pえ��� ��腦� = = = }
  Procedure Init_Point_3D( Var P:Point_3D; X,Y,Z:Real_Type );
    Begin
      P.X:=X; P.Y:=Y; P.Z:=Z;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖                 �┃��                崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = �┃�� = = = }
  Type
    Line_3D = Record
      Point1,Point2:Word;
      Plane1,Plane2:Word;
      Line_Type:Byte;
    End;

 { = = = �┓� �┃┤ = = = }
  Const
    ltCreate = $00; { ｡p�с鉗�� �┃�� }
    ltBase   = $01; { �┃�� �甅������ }
    ltAxis   = $02; { �瓮��� �┃�� }
    ltAngle  = $03; { ������� �┃�� }

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖              ç瓷�痰�               崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = ç瓷�痰� = = = }
  Type
    Plane = Record
      Point1,Point2,NPoint:Word;
      Normal:Real_Type;
    End;

 { = = = �p�↓キ┘ ç瓷�痰� = = = }
  Type
    Surface = Record
      A,B,C,D:Real_Type;
    End;

 { = = = ��瘍モ ç瓷�痰� �� 3 ��腦�� = = = }
  Procedure Count_Surface( A,B,C:Point_3D; Var Result:Surface );
    Var D,MX,MY,MZ,AX,AY,AZ,BX,BY,BZ,CX,CY,CZ:Real_Type;
    Begin
      MX:=1-Min(A.X,Min(B.X,C.X)); AX:=A.X+MX; BX:=B.X+MX; CX:=C.X+MX;
      MY:=1-Min(A.Y,Min(B.Y,C.Y)); AY:=A.Y+MY; BY:=B.Y+MY; CY:=C.Y+MY;
      MZ:=1-Min(A.Z,Min(B.Z,C.Z)); AZ:=A.Z+MZ; BZ:=B.Z+MZ; CZ:=C.Z+MZ;
      D:= AX*BY*CZ + AY*BZ*CX + AZ*BX*CY - AZ*BY*CX - AY*BX*CZ - AX*BZ*CY;
      If D=0 then
        Begin
          AX:=AX+1; BX:=BX+1; CX:=CX+1;
          D:= AX*BY*CZ + AY*BZ*CX + AZ*BX*CY - AZ*BY*CX - AY*BX*CZ - AX*BZ*CY;
        End;
      If D=0 then
        Begin
          AY:=AY+1; BY:=BY+1; CY:=CY+1;
          D:= AX*BY*CZ + AY*BZ*CX + AZ*BX*CY - AZ*BY*CX - AY*BX*CZ - AX*BZ*CY;
        End;
      If D=0 then
        Begin
          AY:=AY+1; BY:=BY+1; CY:=CY+1;
          D:= AX*BY*CZ + AY*BZ*CX + AZ*BX*CY - AZ*BY*CX - AY*BX*CZ - AX*BZ*CY;
        End;
      If D<>0 then
        Begin { �pイ����Θ� Surface.D = -1 }
          Result.A:=( BY*CZ + AY*BZ + AZ*CY - AZ*BY - AY*CZ - BZ*CY ) / D ;
          Result.B:=( AX*CZ + BZ*CX + AZ*BX - AZ*CX - BX*CZ - AX*BZ ) / D ;
          Result.C:=( AX*BY + AY*CX + BX*CY - BY*CX - AY*BX - AX*CY ) / D ;
          Result.D:= -(Result.A*A.X + Result.B*A.Y + Result.C*A.Z);
        End
      Else { ��腦� �ウ�� �� �き�� �p鍖�� }
        Result.D:=Max_Real;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖               ��瘁│�                崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

  Const
    Max_Points = 65535 div SizeOf(Point_3D);
    Max_Lines  = 65535 div SizeOf(Line_3D);
    Max_Planes = 65535 div SizeOf(Plane);
  Type
    TPoints = Array [1..Max_Points] of Point_3D;
    TLines  = Array [1..Max_Lines]  of Line_3D;
    TPlanes = Array [1..Max_Planes] of Plane;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖              �ム甎オ皋��             崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = �ウ━� ������ �М�p�Ε��� = = = }
  Const
    Axis_Line_Mode = $01; { ����щ��碎 皰�讓� �瓱 }
    All_Lines_Mode = $02; { ����щ��碎 ≡� �┃┬ }
    Two_Lines_Mode = $03; { �ウ━ "� あ� �┃┬" }
    Max_Draw_Mode  = Two_Lines_Mode;

 { = = = ��痰錵キ┘ �� Y = = = }
  Const
    YScale = 350/480;
    
 { = = = �ム甎オ皋�� = = = }
  Type
    TPerspective = Object
      Draw_Mode:Byte; { �ウ━ �襤��� �М�p�Ε��� }
      Video_Page:Byte; { ��皋↓�� �┐ギ痰������ }
      Points_Num:Word; { ��腦� }
      Points:^TPoints;
      Lines_Num:Word;  { �┃┬ }
      Lines:^TLines;
      Planes_Num:Word; { ç瓷�痰� }
      Planes:^TPlanes;
      Constructor Init;
      Destructor Done;
      Procedure Draw;
      Procedure Add_Point( X,Y,Z:Real_Type );
      Procedure Add_Line( _Point1,_Point2,_Plane1,_Plane2,_Line_Type:Word );
      Procedure Add_Plane( _Point1,_Point2,_NPoint:Word );
      Procedure Scale( _Scale:Real_Type );
      Procedure Move( dX,dY,dZ:Real_Type );
      Procedure Rot_X( Angle:Real_Type );
      Procedure Rot_Y( Angle:Real_Type );
      Procedure Rot_Z( Angle:Real_Type );
    End;

  Var Perspective:TPerspective;

  Constructor TPerspective.Init;
    Var GD,GM:Integer;
    Begin
      GD:=EGA; GM:=EGAHI;
      InitGraph(GD,GM,'');
      Draw_Mode:=Two_Lines_Mode;
      Video_Page:=0;
      New(Points); Points_Num:=0;
      New(Lines);  Lines_Num :=0;
      New(Planes); Planes_Num:=0;
      Add_Point(30, 0, 0);
      Add_Point( 0,30, 0);
      Add_Point( 0, 0,30);
    End;

  Destructor TPerspective.Done;
    Begin
      Dispose(Points);
      Dispose(Lines);
      Dispose(Planes);
      CloseGraph;
    End;

  Procedure TPerspective.Draw;
    Var I:Word; Color:Byte; Z1,Z2:Real_Type; S:String;
    Begin
     { Planes }
      For I:=1 to Planes_Num do
        With Planes^[I] do
          Normal:=(Points^[Point1].Z+Points^[Point2].Z)/2-Points^[NPoint].Z;
     { Video Page }
      SetVisualPage(Video_Page);
      Video_Page:=1-Video_Page;
      SetActivePage(Video_Page);
     { Clear }
      ClearDevice;
     { Lines }
      For I:=1 to Lines_Num do
        With Lines^[I] do
          Begin
            Case Draw_Mode of
              Axis_Line_Mode: { ����щ��碎 皰�讓� �瓱 }
                If Line_Type=ltAxis then Color:=3 Else Color:=0;
              All_Lines_Mode: { ����щ��碎 ≡� �┃┬ }
                Case Line_Type of
                  ltCreate: Color:=15;
                  ltBase:   Color:=7;
                  ltAxis:   Color:=3;
                  ltAngle:  Color:=14;
                End;
              Two_Lines_Mode: { �ウ━ "� あ� �┃┬" }
                Case Line_Type of
                  ltCreate: { ｡p�с鉗�� �┃�� }
                    If (Planes^[Plane1].Normal*Planes^[Plane2].Normal)<=0 then
                      Color:=15 Else Color:=0;
                  ltBase: { �┃�� �甅������ }
                    Color:=7;
                  ltAxis: { �┃�� �瓮� }
                    Color:=3;
                  ltAngle: { �ァp� }
                    If ((Planes^[Plane1].Normal>=0) Or (Planes^[Plane2].Normal>=0)) then
                      Color:=14 Else Color:=0;
                End;
            End;
            If Color<>0 then
              Begin
                SetColor( Color );
                Line( Round( Points^[Point1].X ) + 320,
                      Round( Points^[Point1].Y*YScale ) + 175,
                      Round( Points^[Point2].X ) + 320,
                      Round( Points^[Point2].Y*YScale ) + 175 );
              End;
          End;
     { Axis }
      SetColor( 2 );
      For I:=1 to 3 do
        Line( 30, 320, Round(Points^[I].X)+30, Round(Points^[I].Y*YScale)+320 );
    End;

  Procedure TPerspective.Add_Point;
    Begin
      If Points_Num < Max_Points then
        Begin
          Inc(Points_Num);
          Init_Point_3D(Points^[Points_Num],X,Y,Z);
        End
      Else
        Runtime_Error('Too many Points !');
    End;

  Procedure TPerspective.Add_Line;
    Begin
      If Lines_Num < Max_Lines then
        Begin
          Inc(Lines_Num);
          With Lines^[Lines_Num] do
            Begin
              Point1    := _Point1;
              Point2    := _Point2;
              Plane1    := _Plane1;
              Plane2    := _Plane2;
              Line_Type := _Line_Type;
            End;
        End
      Else
        Runtime_Error('Too many Lines !');
    End;

  Procedure TPerspective.Add_Plane;
    Begin
      If Planes_Num < Max_Planes then
        Begin
          Inc(Planes_Num);
          With Planes^[Planes_Num] do
            Begin
              Point1 := _Point1;
              Point2 := _Point2;
              NPoint := _NPoint;
            End;
        End
      Else
        Runtime_Error('Too many Planes !');
    End;

  Procedure TPerspective.Scale;
    Var I:Word;
    Begin
      For I:=4 to Points_Num do
        With Points^[I] do
          Begin
            X:=X*_Scale; Y:=Y*_Scale; Z:=Z*_Scale;
          End;
    End;

  Procedure TPerspective.Move( dX,dY,dZ:Real_Type );
    Var I:Word;
    Begin
      For I:=4 to Points_Num do
        With Points^[I] do
          Begin X:=X+dX; Y:=Y+dY; Z:=Z+dZ; End;
    End;

  Procedure TPerspective.Rot_X;
    Var I:Word; T:Point_3D; Cosa,Sina:Real_Type;
    Begin
      Cosa:=Cos(Angle*PI/180); Sina:=Sin(Angle*PI/180);
      For I:=1 to Points_Num do
        Begin
          T:=Points^[I];
          Points^[I].Y:= T.Y*Cosa + T.Z*Sina;
          Points^[I].Z:= T.Z*Cosa - T.Y*Sina;
        End;
    End;

  Procedure TPerspective.Rot_Y;
    Var I:Word; T:Point_3D; Cosa,Sina:Real_Type;
    Begin
      Cosa:=Cos(Angle*PI/180); Sina:=Sin(Angle*PI/180);
      For I:=1 to Points_Num do
        Begin
          T:=Points^[I];
          Points^[I].X:= T.X*Cosa + T.Z*Sina;
          Points^[I].Z:= T.Z*Cosa - T.X*Sina;
        End;
    End;

  Procedure TPerspective.Rot_Z;
    Var I:Word; T:Point_3D; Cosa,Sina:Real_Type;
    Begin
      Cosa:=Cos(Angle*PI/180); Sina:=Sin(Angle*PI/180);
      For I:=1 to Points_Num do
        Begin
          T:=Points^[I];
          Points^[I].X:= T.X*Cosa + T.Y*Sina;
          Points^[I].Y:= T.Y*Cosa - T.X*Sina;
        End;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖         �キム�罔� ｡譽�皰�           崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { ��え竅-�オ皰p = ���. ���p�. + X*(�オ皰p I) + Y*(�オ皰p J) + Z*(�オ皰p K)}

 { = = = ���pえ��皚襯 ▲�皰p� = = = }
  Var vB,vI,vJ,vK:Point_3D;

 { = = = ����←キ┘ ��腦� = = = }
  Procedure _Add_Point( X,Y,Z:Real );
    Begin
      Perspective.Add_Point( vB.X + X*vI.X + Y*vJ.X + Z*vK.X,
                             vB.Y + X*vI.Y + Y*vJ.Y + Z*vK.Y,
                             vB.Z + X*vI.Z + Y*vJ.Z + Z*vK.Z );
    End;

 { = = = �キ�p�罔� �p鍖��� ��pェ�� �p磧� = = = }
  Procedure Generate_Barrel( X1,Y1,Z1,X2,Y2,Z2:Real; R1,R2:Real; N:Word );
    Var R:Real; S:Surface; Angle:Real; I,P,O:Word;
    Begin
     { 1. ����ガ ▲�皰p ������ ���pえ��� }
      Init_Point_3D( vB, X1, Y1, Z1 );
     { 2. �諛�甄錺� ▲�皰p K - �瘡 罔�┃�p� }
      Init_Point_3D( vK, X2-X1, Y2-Y1, Z2-Z1 );
     { 3. �諛�甄錺� ▲�皰p J }
      R:=Sqrt(Sqr(vK.X)+Sqr(vK.Y));
      If R<>0 then
        Init_Point_3D( vJ, vK.Y/R, vK.X/R, 0 )
      Else
        Init_Point_3D( vJ, 1, 0, 0 );
     { 4. �諛�甄錺� ▲�皰p I }
      Count_Surface(Null_Point, vJ, vK, S );
      R:=Sqrt(Sqr(S.A)+Sqr(S.B)+Sqr(S.C));
      Init_Point_3D(vI,S.A/R,S.B/R,S.C/R);
     { Points }
      Angle:=2*Pi/N; P:=Perspective.Points_Num;
      For I:=1 to N do _Add_Point( R1*Sin(I*Angle), R1*Cos(I*Angle), 0 );
      For I:=1 to N do _Add_Point( R2*Sin(I*Angle), R2*Cos(I*Angle), 1 );
      _Add_Point( 0,0,0 ); _Add_Point( 0,0,1 );
      With Perspective do
        Begin
          O:=Planes_Num;
          For I:=1 to N do
            Begin
              Add_Plane( P+I, P+(I mod N)+1, P+N*2+1 );
              Add_Line( P+I, P+I+N, O+I, O+(I mod N)+1, ltCreate );
              Add_Line( P+I, P+(I mod N)+1, 0, 0, ltBase );
              Add_Line( P+I+N, P+(I mod N)+1+N, 0, 0, ltBase );
            End;
          Add_Line( P+N*2+1, P+N*2+2, 0, 0, ltAxis );
        End;
    End;

 { = = = �キム�罔� ���キ� �珮° = = = }
  Procedure Generate_Bublic_Seg( X,Y,Z:Real; Old,New:Point_3D;
                                 Rad,_Rad:Real; N,Segs:Word );
    Var A1,A2,Y0,Z0,R,Angle:Real; I,J,P,K,L,T:Integer; S:Surface;
    Begin
     { �諛�甄錺� �瓱 }
      Init_Point_3D( vB, X, Y, Z );
      vK:=Old; vJ:=New;
      Count_Surface( Null_Point, vJ, vK, S );
      R:=Sqrt(Sqr(S.A)+Sqr(S.B)+Sqr(S.C));
      Init_Point_3D( vI, S.A/R, S.B/R, S.C/R );
     { �諛�甄錺� �����讚�� ����腑痰〓 皰腑� }
      P:=Perspective.Points_Num;
     { �諛�甄錺� ��� ├�キキ�� 磽��� }
      A1:=2*Pi/N; A2:=Pi/(Segs*2);
      With Perspective do
        For I:= 1 to (Segs+1) do { I = ����p 皀�竕ィ� 瓮腑��� }
          Begin
           { 1. ���ラ�ガ 皰腦� � 罐��p 皀�竕ィ� 瓮腑��� }
            Angle:=A2*(I-1)-Pi/2;
            Y0:=_Rad*Sin(Angle)+_Rad; Z0:=_Rad*Cos(Angle);
            _Add_Point( 0, Y0, Z0 ); K:=Points_Num;
           { 2. �p�〓え� �瓮≪� �┃�� }
            If I<(Segs+1) then Add_Line( K, K+N+1, 0, 0, ltAxis );
           { 3. ��Кラ�ガ 皰腦� ��▲p絖�痰� }
            For J:= 1 to N do
              _Add_Point( Rad*Cos(J*A1),
                          Rad*Sin(J*A1)*Sin(Angle)+Y0,
                          Rad*Sin(J*A1)*Cos(Angle)+Z0 );
           { 4. ����ガ ���瓷�痰� }
            L:=Planes_Num;
            If I<(Segs+1) then
              For J:= 1 to N do
                Add_Plane( K+J, K+(J mod N)+1+N+1, K );
           { 5. �p�〓え� �┃┬ }
            If ((I=(Segs+1)) Or (I=1)) then
              For J:= 1 to N do Add_Line( K+J, K+(J mod N)+1, 0, 0, ltBase )
            Else
              For J:= 1 to N do Add_Line( K+J, K+(J mod N)+1, L+J, L+J-N, ltCreate );
            If I<(Segs+1) then
              For J:= 1 to N do
                Add_Line( K+J, K+J+N+1, L+J, L+(J mod N)+1, ltCreate )
          End;
    End;

 { = = = �キム�罔� �筌p� = = = }
  Procedure Generate_Sphere( Rad:Real; Mer,Par:Word );
    Var P,M,B:Word; MA,PA,Temp:Real;
    Begin
      With Perspective do
        Begin
         { 1. ��瘁��←錺� 皰腦� }
          B:=Points_Num;
          For P:= 1 to Par do
            For M:= 1 to Mer do
              Begin
                PA:=Pi*P/(Par+1);
                MA:=2*Pi*M/Mer;
                Temp:=Rad*Sin(PA);
                Add_Point( Temp*Sin(MA),Temp*Cos(MA),Rad*Cos(PA) );
              End;
          Add_Point( 0,0,+Rad );
          Add_Point( 0,0,-Rad );
          Add_Point( 0,0,0 );
         { 2. �p�〓え� ���瓷�痰� }
          For M:=1 to Mer do Add_Plane(Par*Mer+1+B,(M mod Mer)+1+B,Par*Mer+3+B);
          For P:=1 to Par-1 do
            For M:=1 to Mer do
              Add_Plane((P-1)*Mer+M+B,P*Mer+(M mod Mer)+1+B,Par*Mer+3+B);
          For M:=1 to Mer do
            Add_Plane(Par*Mer+2+B,(Par-1)*Mer+(M mod Mer)+1+B,Par*Mer+3+B);
         { 3. �瘡 }
          Add_Line(Par*Mer+1+B,Par*Mer+2+B,0,0,2);
         { 4. ��p���カ� }
          For P:= 1 to Par do
            For M:= 1 to Mer do
              Add_Line( (P-1)*Mer+M+B,(P-1)*Mer+(M mod Mer)+1+B,Mer*(P-1)+M,Mer*P+M,0);
         { 5. ��p┐���� }
          For M:= 1 to Mer do
            Add_Line( Par*Mer+1+B, M+B ,M,Mer+((M+Mer-2)Mod Mer)+1,0);
          For M:= 1 to Mer do
            For P:= 1 to (Par-1) do
              Add_Line( (P-1)*Mer+M+B, P*Mer+M+B ,Mer*(P-1)+M,Mer*(P-1)+((M+Mer-2)Mod Mer)+1,0);
          For M:= 1 to Mer do
            Add_Line( (Par-1)*Mer+M+B, Par*Mer+2+B ,Mer*(Par-1)+M,Mer*(Par-1)+((M+Mer-2)Mod Mer)+1,0);
        End;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖        ������讚襯 �ムガキ�襯         崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 Const Config_File_Name = 'PV.CFG';

 { = = = ������讚襯 �ムガキ�襯 = = = }
  Var
    Rotate_Angle   : Real_Type;
    Scale_Power    : Real_Type;
    Move_Step      : Real_Type;
    Creative_Lines : Word;

 { = = = �痰���→� �ムガキ�諷 �� ��������� = = = }
  Procedure Default_Var_Set;
    Begin
      Rotate_Angle   := 1;
      Scale_Power    := 1.1;
      Move_Step      := 32;
      Creative_Lines := 32;
    End;

 { = = = �痰���→� �ムガキ�諷 = = = }
  Function Var_Set( Var_Name,Value:String ):Boolean; Far;
    Var Error:Integer;
    Begin
      If Var_Name = 'ROTATE_ANGLE'   then Val(Value,Rotate_Angle  ,Error);
      If Var_Name = 'SCALE_POWER'    then Val(Value,Scale_Power   ,Error);
      If Var_Name = 'MOVE_STEP'      then Val(Value,Move_Step     ,Error);
      If Var_Name = 'CREATIVE_LINES' then Val(Value,Creative_Lines,Error);
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖            ���珮И� �����            崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

  Procedure Load_Pipe( FileName:String );
    Var T:Text;
   { + + + + + + }
    Function ReadReal:Real_Type;
      Var Result:Real_Type;
      Begin
        Read( T, Result );
        ReadReal:=Result;
      End;
   { + + + + + + }
    Function ReadWord:Word;
      Var Result:Word;
      Begin
        Read( T, Result );
        ReadWord:=Result;
      End;
   { + + + + + + }
    Var Command:Char; N,_N,B,E:Point_3D;
        Now,C,I:Word; Rad,R,Temp:Real_Type; S:String;
    Begin
      If FSearch(FileName,'')='' then
        Runtime_Error('Pipe file '+FileName+' not found !');
      Assign( T, FileName );
      Reset( T );
      Init_Point_3D( B, 0, 0, 0 );
      With Perspective do
        Repeat
          Now:=Points_Num;
          Read( T, Command );
          Command:=UpCase( Command );
          Case Command of
            '[': { ｡譽�硅 }
              Begin
                Readln( T, S );
                Readln( T, C );
                For I:=1 to C do Add_Point( ReadReal, ReadReal, ReadReal );
                Readln( T, C );
                For I:=1 to C do Add_Line( ReadWord+Now, ReadWord+Now, ReadWord, ReadWord, ReadWord );
                Readln( T, C );
                For I:=1 to C do Add_Plane( ReadWord+Now, ReadWord+Now, ReadWord+Now );
              End;
            'N': { ������ ���p�←キ�� }
              Begin
                Init_Point_3D( N, ReadReal, ReadReal, ReadReal );
                R:=Sqrt( Sqr(N.X) + Sqr(N.Y) + Sqr(N.Z) );
                Init_Point_3D( N, N.X/R, N.Y/R, N.Z/R );
                Readln( T );
              End;
            'P': { �p鍖�� �p磧� }
              Begin
                Readln( T, R );
                Init_Point_3D( E, B.X+N.X*R, B.Y+N.Y*R, B.Z+N.Z*R );
                Generate_Barrel( B.X,B.Y,B.Z,E.X,E.Y,E.Z,Rad,Rad,Creative_Lines );
                B:=E;
              End;
            'R': { ��え竅 瓮腑��� }
               Readln( T, Rad );
            'A': { ��pュ�き┴ }
              Begin
                Read( T, R ); Readln( T, Temp );
                Init_Point_3D( E, B.X+N.X*R, B.Y+N.Y*R, B.Z+N.Z*R );
                Generate_Barrel( B.X,B.Y,B.Z,E.X,E.Y,E.Z,Rad,Temp,Creative_Lines );
                Rad:=Temp;
                B:=E;
              End;
            'W': { ���キ� }
              Begin
                _N:=N;
                Init_Point_3D( N, ReadWord, ReadWord, ReadWord );
                R:=Sqrt( Sqr(N.X) + Sqr(N.Y) + Sqr(N.Z) );
                Init_Point_3D( N, N.X/R, N.Y/R, N.Z/R );
                Readln( T, R );
                Generate_Bublic_Seg( B.X,B.Y,B.Z,_N,N,Rad,R,Creative_Lines,Creative_Lines );
                Init_Point_3D(B,B.X+R*N.X+R*_N.X,B.Y+R*N.Y+R*_N.Y,B.Z+R*N.Z+R*_N.Z);
              End;
            'L': {Labels[ReadWord]:=_Now}; { �モ�� }
            'G': {_Now:=Labels[ReadWord]}; { ��pュ�� �� �モ�� }
            Else
              Readln( T );
          End;
        Until EOF(T);
      Close( T );
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖              ����←キ┘              崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

  Function Manager:Boolean;
    Begin
      Manager:=True;
      With Perspective do
        Case ReadKey of
         { >>> Rotation <<< }
          #00:
            Case ReadKey of
              #72: Rot_X( +Rotate_Angle );
              #80: Rot_X( -Rotate_Angle );
              #75: Rot_Y( +Rotate_Angle );
              #77: Rot_Y( -Rotate_Angle );
              #71: Rot_Z( +Rotate_Angle );
              #73: Rot_Z( -Rotate_Angle );
            End;
         { >>> Scale <<< }
          '+': Scale( Scale_Power );
          '-': Scale( 1/Scale_Power );
         { >>> Move <<< }
          '8': Move( 0, +Move_Step, 0 );
          '6': Move( -Move_Step, 0, 0 );
          '4': Move( +Move_Step, 0, 0 );
          '2': Move( 0, -Move_Step, 0 );
         { >>> Ghange Draw Mode <<< }
          #09:
            Begin
              Inc(Draw_Mode);
              If Draw_Mode > Max_Draw_Mode then Draw_Mode:=1;
            End;
         { >>> Exit <<< }
          #27: Manager:=False;
        End;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳多 }
 { 崖          �甅�↓�� 蹍������          崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳匝 }

 { = = = ��痰�→� = = = }
  Procedure Poster;
    Begin
      Writeln;
      TextColor(11); Writeln(' >>> Pipe Viewer <<<');
      TextColor(13); Writeln(' Roman International');
      TextColor(14); Writeln('   PV < PipeFile >');
      TextColor(7); Writeln;
    End;

{ = = = �甅�↓�� 蹍������ = = = }
Begin
  If ParamCount = 1 then
    Begin
      Default_Var_Set;
      Config_File(Config_File_Name,Var_Set);
      Perspective.Init;
      Load_Pipe(ParamStr(1));
      Perspective.Draw;
      Perspective.Draw;
      While Manager do Perspective.Draw;
      Perspective.Done;
    End
  Else
    Poster;
End.