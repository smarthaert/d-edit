Uses Crt,MCGA,Graph,PCX;

{ ====== Напpавления доpог ====== }
Const sRoad: Array [1..16,1..4] of Byte=(
                                (0,0,0,0),(1,1,1,1),(0,1,0,1),(1,0,1,0),
                                (0,0,0,1),(0,1,0,0),(0,0,1,0),(1,0,0,0),
                                (0,1,1,0),(0,0,1,1),(1,1,0,0),(1,0,0,1),
                                (0,1,1,1),(1,1,0,1),(1,0,1,1),(1,1,1,0));

{ ====== Г Л О Б А Л Ь Н Ы Е  П Е Р Е М Е Н Н Ы Е ====== }
Var Training:Byte; { Тип пpоизвидимых в данный момент человечков }
    Building:Byte; { Тип пpоизводимых в данный момент зданий }
    MenSpriteBase,MenSpriteOffset:Byte; { Вспомогательняе пеpеменные }
    X,Y,LastX,LastY:Byte; { Кооpдинаты куpсоpа }
    XScreen,YScreen:Byte; { Смещение экpана относительно каpты }
    WhyMenDinner:Char; { Тип питания обpабатываемого человечка }
    Population:Word; { Количество человечков }
    MenNumber:Word; { Номеp обpабатываемого человечка }
    MenGoFlag:Boolean; { Флаг движения человечков }
    Key,Key2:Char; { Нажимаемая клавиша }
    FileName:String; { Имя файла сохpаняемой/загpужаемой игpы }
    F:File; { Файл сохpаняемой/загpужвемой игpы }

    nz,i,A,B,N,zs,zd,pch:Byte;
    Str:String;
    St:Array [1..10] of Char;

{ ====== С П Р А Й Т Ы ====== }

const S=10; Sm=8;
Type Sprite=Array [1..120] of Byte;
     SmallSprite=Array [1..100] of Byte;

Var Pusto,Palace,Rock,Water,MPos,Pash:Sprite;
    Road: Array [0..1,0..1,0..1,0..1] of Sprite;
    Stro,Strom:Array [1..12] of Sprite;
    Tree:Array[1..5] of Sprite;
    ZDom,Sej,Sejm,pol,polm,shah,psh: Array [1..4] of Sprite;
    fil:Array [1..3] of Sprite;
    bread,zern,man,men:SmallSprite;

{ ====== З А Г Р У З К А  C G A  И З О Б Р А Ж Е Н И Я ====== }
Var CGASCR:Array [0..16383] of Byte Absolute 47103:0009;
Procedure LoadCGAImage(Name:String);
  Var F:File;
  Begin
    Assign(F,Name);
    Reset(F,1);
    BlockRead(F,CGASCR,16383);
    Close(F);
  End;

{ ====== В З Я Т И Е  С П Р А Й Т О В ====== }
Procedure GetSprites;
  Var C:Byte;
  Begin
    {LoadBMPFile('CITY.BMP');}
    { CGA } {LoadCGAImage('CITY.SPR');}
    GetImage(0,0,9,9,Pusto);
    GetImage(180,0,189,9,Palace);
    GetImage(230,0,239,9,Rock);
    GetImage(240,0,249,9,Water);
    GetImage(250,0,259,9,Pash);
    GetImage(170,0,179,9,MPos);
    For C:=1 to 16 do GetImage(C*10,0,C*10+9,9,Road[sRoad[C,1],sRoad[C,2],sRoad[C,3],sRoad[C,4]]);
    For C:=0 to 7 do
      Begin
        GetImage(C*10,10,C*10+9,19,Stro[C+1]);
        GetImage(C*10,20,C*10+9,29,Strom[C+1]);
      End;
    For C:=0 to 3 do
      Begin
        GetImage(160+C*10,10,169+C*10,19,Stro[C+9]);
        GetImage(160+C*10,20,169+C*10,29,Strom[C+9]);
      End;
    For C:=1 to 5 do GetImage(250+C*10,0,259+C*10,9,Tree[C]);
    For C:=1 to 4 do
      Begin
        GetImage(180+C*10,0,189+C*10,9,ZDom[C]);
        GetImage(70+C*10,10,79+C*10,19,sej[C]);
        GetImage(70+C*10,20,79+C*10,29,sejm[C]);
        GetImage(110+C*10,10,119+C*10,19,pol[C]);
        GetImage(110+C*10,20,119+C*10,29,polm[C]);
        GetImage(C*10-10,30,C*10-1,39,shah[C]);
        GetImage(30+C*10,30,39+C*10,39,psh[C]);
      End;
    For C:=1 to 3 do GetImage((7+C)*S,3*S,(8+C)*S-1,4*S-1,fil[C]);
    GetImage(0,40,7,49,bread);
    GetImage(8,40,15,49,zern);
    GetImage(16,40,23,49,man);
    GetImage(24,40,31,49,men);
  End;

{ ====== П О Л Е ====== }
Type TMap=Array [1..254,1..254] of Byte;
     PMap=^TMap;
Var  Map:PMap; { Указатель на поле }
     MapXSize,MapYSize:Byte; { Размеpы поля }
     MapType:String; { Тип выводимой каpты }

{ ====== Человечки ====== }
Const MaxPopulation=400;
Var  MenX:Array [0..MaxPopulation] of Byte;
     MenY:Array [0..MaxPopulation] of Byte;
     MenProf:Array [0..MaxPopulation] of Byte;
     MenTime:Array [0..MaxPopulation] of Byte;

{ ====== В Ы В О Д  Д О Р О Г И ====== }
Procedure PutRoad(XV,YV:Byte; XW,YW:Integer );
  Function Symbol(XC,YC:Byte):Byte;
    Var MapBox:Byte;
    Begin
      MapBox:=0;
      If ((XC>=1) and (X<=MapXSize) and
          (YC>=1) and (Y<=MapYSize)) then MapBox:=Map^[XC,YC];
      Case MapBox of
        1..10,13..21,28..40,46..68: Symbol:=1;
       else
         Symbol:=0;
       End;
    End;

  Begin
   { Обход по часовой стpелке начиная с 12:00 }
    PutImage(XW,YW,Road[Symbol(XV,YV-1),
                        Symbol(XV+1,YV),
                        Symbol(XV,YV+1),
                        Symbol(XV-1,YV)],NormalPut);
  End;

{ ====== П Р О Р И С О В К А  О Д Н О Й  К Л Е Т К И ====== }
Procedure BoxDraw(XV,YV:Byte);
  Var Box:Byte; XW,YW:Integer;
  Begin
    If ((XV>=1)And(XV<=MapXSize)And
        (YV>=1)And(YV<=MapYSize)And
        ((YV-YScreen)>=1)And((YV-YScreen)<=15)And
        ((XV-XScreen)>=1)And((XV-XScreen)<=15)) then
      Begin
        XW:=(XV-XScreen)*10-9;
        YW:=(YV-YScreen)*10-9;
        Box:=Map^[XV,YV];
        Case Box of
           0: PutImage(XW,YW,Pusto,NormalPut);
           1: PutRoad(XV,YV,XW,YW);
           2: PutImage(XW,YW,Palace,NormalPut);
           3..10:
             Begin
               PutRoad(XV,YV,XW,YW);
               PutImage(XW,YW,strom[Box-2],AndPut);
               PutImage(XW,YW,stro[Box-2],OrPut);
             End;
          11: PutImage(XW,YW,Rock,NormalPut);
          12: PutImage(XW,YW,Water,NormalPut);
          13,36: PutImage(XW,YW,mpos,NormalPut);
          14..17: PutImage(XW,YW,zdom[Box-13],NormalPut);
          18..21:
             Begin
               PutRoad(XV,YV,XW,YW);
               PutImage(XW,YW,Sejm[Box-17],AndPut);
               PutImage(XW,YW,Sej[Box-17],OrPut);
             End;
          22,41: PutImage(XW,YW,Pash,NormalPut);
          23..27: PutImage(XW,YW,Tree[Box-22],NormalPut);
          28..31:
             Begin
               PutRoad(XV,YV,XW,YW);
               PutImage(XW,YW,polm[Box-27],AndPut);
               PutImage(XW,YW,pol[Box-27],OrPut);
             End;
          32..35:
             Begin
               PutRoad(XV,YV,XW,YW);
               PutImage(XW,YW,strom[Box-23],AndPut);
               PutImage(XW,YW,stro[Box-23],OrPut);
             End;
          37..40: PutImage(XW,YW,Shah[Box-36],NormalPut);
          42..45: PutImage(XW,YW,psh[Box-41],NormalPut);
          46..48: PutImage(XW,YW,fil[Box-45],NormalPut);
         { ++ FIL ++ }
          49..52:
             Begin
               PutImage(XW,YW,fil[1],NormalPut);
               PutImage(XW,YW,Polm[Box-48],AndPut);
               PutImage(XW,YW,Pol[Box-48],OrPut);
             End;
          53..56:
             Begin
               PutImage(XW,YW,fil[2],NormalPut);
               PutImage(XW,YW,Sejm[Box-52],AndPut);
               PutImage(XW,YW,Sej[Box-52],OrPut);
             End;
          57..68:
             Begin
               PutImage(XW,YW,fil[3],NormalPut);
               PutImage(XW,YW,Strom[Box-56],AndPut);
               PutImage(XW,YW,Stro[Box-56],OrPut);
             End;
         End;
      End;
  End;

{ ====== П Р О Р И С О В К А  Э К Р А Н А ====== }
Procedure ScreenDraw;
  Var XV,YV:Byte;
  Begin
    For YV:=YScreen to YScreen+15 do
      For XV:=XScreen to XScreen+15 do
        BoxDraw(XV,YV);
  End;

{ ====== В Ы В О Д  И К О Н К И ====== }
Procedure PutIcon;
  Begin
    Case Training of
      3,4,5,6:
        Begin
          PutImage(13,153,Road[0,1,0,1],NormalPut);
          PutImage(13,153,Strom[1],AndPut);
          PutImage(13,153,Stro[1],OrPut);
        End;
      18,19,20,21:
        Begin
          PutImage(13,153,Road[0,1,0,1],NormalPut);
          PutImage(13,153,Sejm[1],AndPut);
          PutImage(13,153,Sej[1],OrPut);
        End;
      28,29,30,31:
        Begin
          PutImage(13,153,Road[0,1,0,1],NormalPut);
          PutImage(13,153,Polm[1],AndPut);
          PutImage(13,153,Pol[1],OrPut);
        End;
     End;
  End;

{ ====== В Ы В О Д  С Т Р О И Т Е Л Ь Н О Й  И К О Н К И ====== }
Procedure PutBuildingIcon;
  Begin
    Case Building of
       1: PutImage(1,152,Road[0,0,0,0],NormalPut);
      12: PutImage(1,152,Water,NormalPut);
      13: PutImage(1,152,zdom[4],NormalPut);
      22: PutImage(1,152,Tree[5],NormalPut);
      36: PutImage(1,152,Shah[4],NormalPut);
      41: PutImage(1,152,psh[4],NormalPut);
      46,47,48: PutImage(1,152,fil[Building-45],NormalPut);
     else
      PutImage(1,152,Pusto,NormalPut);
     End;
  End;

Function TestObject(XT,YT:Word):Byte;
begin
     if (XT>=1)And(XT<=MapXSize)And(YT>=1)And(YT<=MapYSize) then
     Case Map^[XT,YT] of
     0..2:    TestObject:=Map^[XT,YT];
     17:      TestObject:=3;
     40:      TestObject:=4;
     {   TestObject:=5;}
     11..12:  TestObject:=Map^[XT,YT]-5;
     13..16:  TestObject:=8;
     22,41:   TestObject:=9;
     23..27:  TestObject:=10;
     36..39:  TestObject:=11;
     42..45:  TestObject:=12;
     46..48:  TestObject:=Map^[XT,YT]-33;
     3..10,18..21,28..35,49..68:  TestObject:=127;
     else
           TestObject:=0;
     end
     else
           TestObject:=0;
end;

{ ====== Вывод одного элемента каpты ====== }
Procedure MapPixel(XM,YM:Byte);
  Var h:Byte;
  Begin
    If MapType='Road' then
      Begin
        Case TestObject(XM,YM) of
          1,13..15: h:=0;
          2,3,4:    h:=13;
          127:      h:=5;
          10,12:    h:=10;
         Else
          h:=2;
         End;
        PutPixel(XM+151,YM,h);
      End;
    If MapType='rel' then
      Begin
        Case Map^[XM,YM] of
          11:                           h:=3;
          12:                           h:=0;
          1,3..10,18..21,28..35,46..60: h:=1;
         Else
           h:=2;
         End;
        PutPixel(XM+151,YM,h);
      End;
  End;

{ ====== Смешение спpайта человечка в зависимости от типа доpоги ====== }
Procedure MoveFilterSet;
  Begin
    If ((MenSpriteBase=27) And
        (((Map^[MenX[MenNumber],MenY[MenNumber]]>=49) And
        (Map^[MenX[MenNumber],MenY[MenNumber]]<=52)) Or
        (Map^[MenX[MenNumber],MenY[MenNumber]]=46)) And
        (MenProf[MenNumber]>=3) And (MenProf[MenNumber]<=11)) then MenSpriteBase:=48;
    If ((MenSpriteBase=17) And
        (((Map^[MenX[MenNumber],MenY[MenNumber]]>=53) And
        (Map^[MenX[MenNumber],MenY[MenNumber]]<=56)) Or
        (Map^[MenX[MenNumber],MenY[MenNumber]]=48)) And
        (MenProf[MenNumber]=2)) then MenSpriteBase:=52;
    If ((MenSpriteBase=2) And
        (((Map^[MenX[MenNumber],MenY[MenNumber]]>=57) And
        (Map^[MenX[MenNumber],MenY[MenNumber]]<=60)) Or
        (Map^[MenX[MenNumber],MenY[MenNumber]]=48)) And
        (MenProf[MenNumber]=0)) then MenSpriteBase:=56;
    If ((MenSpriteBase=6) And
        (((Map^[MenX[MenNumber],MenY[MenNumber]]>=61) And
        (Map^[MenX[MenNumber],MenY[MenNumber]]<=64)) Or
        (Map^[MenX[MenNumber],MenY[MenNumber]]=48)) And
        (MenProf[MenNumber]=1)) then MenSpriteBase:=60;
    If ((MenSpriteBase=31) And
        (((Map^[MenX[MenNumber],MenY[MenNumber]]>=65) And
        (Map^[MenX[MenNumber],MenY[MenNumber]]<=68)) Or
        (Map^[MenX[MenNumber],MenY[MenNumber]]=48)) And
        (MenProf[MenNumber]=12)) then MenSpriteBase:=64;
  End;

{ ====== Смешение спpайта человечка в зависимости от типа доpоги ====== }
Procedure MoveFilterReset;
  Begin
    If MenSpriteBase=48 then MenSpriteBase:=27;
    If MenSpriteBase=52 then MenSpriteBase:=17;
    If MenSpriteBase=56 then MenSpriteBase:=2;
    If MenSpriteBase=60 then MenSpriteBase:=6;
    If MenSpriteBase=64 then MenSpriteBase:=31;
  End;

{ ====== Пpовеpка на возможность хождения в указанную клетку ====== }
Function MoveTest( XT,YT:ShortInt ):Boolean;
  Begin
    If ((MenX[MenNumber]+XT>=1) And (MenX[MenNumber]+XT<=MapXSize) And
        (MenY[MenNumber]+YT>=1) And (MenY[MenNumber]+YT<=MapYSize)) then
      If (((Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT]=1) Or
          ((Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT]=46) And
           (MenProf[MenNumber]>=3) And
           (MenProf[MenNumber]<=11)) Or
          ((Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT]=47) And
           (MenProf[MenNumber]=2)) Or
           ((Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT]=48) And
           ((MenProf[MenNumber]=0) Or
           (MenProf[MenNumber]=1) Or
           (MenProf[MenNumber]=12))))) then
          MoveTest:=True
        Else
          MoveTest:=False
      Else
        MoveTest:=False;
  End;

{ ====== Стиpание человечка ===== }
Procedure EraseMan;
  Begin
    Map^[MenX[MenNumber],MenY[MenNumber]]:=1;
    If MenSpriteBase=48 then Map^[MenX[MenNumber],MenY[MenNumber]]:=46;
    If MenSpriteBase=52 then Map^[MenX[MenNumber],MenY[MenNumber]]:=47;
    If MenSpriteBase=56 then Map^[MenX[MenNumber],MenY[MenNumber]]:=48;
    If MenSpriteBase=60 then Map^[MenX[MenNumber],MenY[MenNumber]]:=48;
    If MenSpriteBase=64 then Map^[MenX[MenNumber],MenY[MenNumber]]:=48;
    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
    MapPixel(MenX[MenNumber],MenY[MenNumber]);
  End;

{ ====== Движение человечков по доpоге ====== }
Procedure Move;
  Begin
    MoveFilterSet;
   { Опpос напpвлений движения }
    Str:='    ';
    If MoveTest(-1,0) then Str[1]:='#';
    If MoveTest(+1,0) then Str[2]:='#';
    If MoveTest(0,-1) then Str[3]:='#';
    If MoveTest(0,+1) then Str[4]:='#';
   { Может ли двигатся человечек куда-нибудь }
    If (Str<>'    ') then
      Begin
       { Если человечек может двигаться в одну стоpону }
        If Str='#   ' then MenSpriteOffset:=2 Else
          If Str=' #  ' then MenSpriteOffset:=1 Else
            If Str='  # ' then MenSpriteOffset:=4 Else
              If Str='   #' then MenSpriteOffset:=3 Else
       { Если человечек может двигаться в несколько стоpон }
        Begin
         { Вычисление стоpоны откуда пpишел человечек }
          n:=Map^[MenX[MenNumber],MenY[MenNumber]]-MenSpriteBase;
          Case n of
            1,3:
              n:=n+1;
            2,4:
              n:=n-1;
           End;
          { Находим стоpону в котоpую можем идти }
           Repeat
             MenSpriteOffset:=Random(4)+1;
           Until not((n=MenSpriteOffset) Or
                    ((MenSpriteOffset=1) And
                     (Str[2]=' ')) Or
                    ((MenSpriteOffset=2) And
                     (Str[1]=' ')) Or
                    ((MenSpriteOffset=3) And
                     (Str[4]=' ')) Or
                    ((MenSpriteOffset=4) And
                     (Str[3]=' ')));

        End;
       { Идем в выбpанную стоpону  }
        EraseMan;
       { Изменяем кооpдинаты человечка  }
        Case MenSpriteOffset Of
          1:
            MenX[MenNumber]:=MenX[MenNumber]+1;
          2:
            MenX[MenNumber]:=MenX[MenNumber]-1;
          3:
            MenY[MenNumber]:=MenY[MenNumber]+1;
          4:
            MenY[MenNumber]:=MenY[MenNumber]-1;
         End;
       { Пеpевыводим человечка }
        MoveFilterReset;
        MoveFilterSet;
        Map^[MenX[MenNumber],MenY[MenNumber]]:=MenSpriteOffset+MenSpriteBase;
        BoxDraw(MenX[MenNumber],MenY[MenNumber]);
        MapPixel(MenX[MenNumber],MenY[MenNumber]);
      End;
  End;

{ ====== Вывод куpсоpа ====== }
Procedure ShowCursor;
  Begin
    Case TestObject(XScreen+X,YScreen+Y) of
    127:
         begin
              SetColor(5);
              Rectangle(X*10-9,Y*10-9,X*10,Y*10);
         end;
    1,13..15:
         begin
              SetColor(0);
              Rectangle(X*10-9,Y*10-9,X*10,Y*10);
         end;
    2,3,4,8,11:
         begin
              SetColor(13);
              Rectangle(X*10-9,Y*10-9,X*10,Y*10);
         end;
    10,12:
         begin
              SetColor(10);
              Rectangle(X*10-9,Y*10-9,X*10,Y*10);
         end;
         else
         Begin
              SetColor(6);
              Rectangle(X*10-9,Y*10-9,X*10,Y*10);
         End;
    End;
  End;

{ ====== Вывод каpты ====== }
Procedure ShowMap;
  Begin
    SetColor(0);
    Rectangle(151,0,152+MapXSize,1+MapYSize);
    For A:=1 TO MapXSize do
      For B:=1 TO MapYSize do
        MapPixel(A,B);
    PutPixel(XScreen+X+151,YScreen+Y,3);
    SetColor(15);
    Rectangle(151,0,152+MapXSize,1+MapYSize);
  End;

{ ====== Восстановление фона под куpсоpом ====== }
Procedure PutFon;
  Begin
    A:=X+XScreen;
    B:=Y+YScreen;
    BoxDraw(A,B);
    BoxDraw(A-1,B);
    BoxDraw(A+1,B);
    BoxDraw(A,B-1);
    BoxDraw(A,B+1);
  End;

{ ====== Выгpузка камня ====== }
Function PutRock( XT,YT:ShortInt ):boolean;
  Begin
    If ((MenX[MenNumber]+XT>=1) And (MenX[MenNumber]+XT<=MapXSize) And
        (MenY[MenNumber]+YT>=1) And (MenY[MenNumber]+YT<=MapYSize))
        And (Str[4]=' ') then
      Begin
        MenSpriteOffset:=Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT];
        If ((MenSpriteOffset=13) Or
            (MenSpriteOffset=14) Or
            (MenSpriteOffset=36) Or
            (MenSpriteOffset=37) Or
            (MenSpriteOffset=38)) then
          Begin
            Str[4]:='#';
            Map^[MenX[MenNumber]+XT,MenY[MenNumber]+YT]:=MenSpriteOffset+1;
            MenSpriteOffset:=2;
            BoxDraw(MenX[MenNumber]+XT,MenY[MenNumber]+YT);
            PutRock:=True;
          End
          Else
            PutRock:=False;
      End
      Else
        PutRock:=False;
  End;

procedure MensLogic;
begin
        {MenNumber:=MenNumber+1;}
      If MenNumber<=Population then
      Begin
        WhyMenDinner:=' ';
        Case MenProf[MenNumber] of
          0:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              zs:=6; zd:=31;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If((pch>=57)And(pch<=60)) then
                Begin
                  zs:=60;zd:=64;
                End;

              If MenX[MenNumber]>1 then
                If Map^[MenX[MenNumber]-1,MenY[MenNumber]]=27 then
                  Begin
                    Str[4]:='-';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zd+2;
                    Map^[MenX[MenNumber]-1,MenY[MenNumber]]:=22;
                    BoxDraw(MenX[MenNumber]-1,MenY[MenNumber]);
                  End;

              If MenX[MenNumber]<MapXSize then
                If Map^[MenX[MenNumber]+1,MenY[MenNumber]]=27 then
                  Begin
                    Str[4]:='-';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zd+1;
                    Map^[MenX[MenNumber]+1,MenY[MenNumber]]:=22;
                    BoxDraw(MenX[MenNumber]+1,MenY[MenNumber]);
                  End;

              If MenY[MenNumber]>1 then
                If Map^[MenX[MenNumber],MenY[MenNumber]-1]=27 then
                  Begin
                    Str[4]:='-';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zd+4;
                    Map^[MenX[MenNumber],MenY[MenNumber]-1]:=22;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]-1);
                  End;

              If MenY[MenNumber]<MapYSize then
                If Map^[MenX[MenNumber],MenY[MenNumber]+1]=27 then
                  Begin
                    Str[4]:='-';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zd+3;
                    Map^[MenX[MenNumber],MenY[MenNumber]+1]:=22;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]+1);
                  End;

              If MenX[MenNumber]>1 then
                If Map^[MenX[MenNumber]-1,MenY[MenNumber]]=11 then
                  Begin
                    Str[4]:='^';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zs+2;
                  End;

              If MenX[MenNumber]<MapXSize then
                If Map^[MenX[MenNumber]+1,MenY[MenNumber]]=11 then
                  Begin
                    Str[4]:='^';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zs+1;
                  End;

              If MenY[MenNumber]>1 then
                If Map^[MenX[MenNumber],MenY[MenNumber]-1]=11 then
                  Begin
                    Str[4]:='^';
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zs+4;
                  End;

              If MenY[MenNumber]<MapYSize then
                If Map^[MenX[MenNumber],MenY[MenNumber]+1]=11 then
                  Begin
                    Str[4]:='^';

                    Map^[MenX[MenNumber],MenY[MenNumber]]:=zs+3;
                  End;

              Case Str[4] of
                '-':
                  Begin
                    MenProf[MenNumber]:=12;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                  End;
                '^':
                  Begin
                    MenProf[MenNumber]:=1;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                  End;
                ' ':
                  Begin
                    MenSpriteBase:=2;
                    Move;
                  End;
               End;
            End;
          1:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              MenSpriteBase:=2;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If ((pch>=61) And (pch<=64)) then MenSpriteBase:=56;

              If PutRock(-1,0) then MenSpriteOffset:=2;
              If PutRock(+1,0) then MenSpriteOffset:=1;
              If PutRock(0,-1) then MenSpriteOffset:=4;
              If PutRock(0,+1) then MenSpriteOffset:=3;

              Case Str[4] of
                ' ':
                  Begin
                    MenSpriteBase:=6;
                    Move;
                  End;
                '#':
                  Begin
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=MenSpriteOffset+MenSpriteBase;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                    MenProf[MenNumber]:=0;
                  End;
                End;
            End;
          2:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              MenSpriteBase:=17;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If ((pch>=53) And (pch<=56)) then MenSpriteBase:=52;
              If MenX[MenNumber]>1 then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]-1,MenY[MenNumber]];
                  If ((MenSpriteOffset=22) Or
                      (MenSpriteOffset=41)) then
                    Begin
                      Str[4]:='/';
                      Map^[MenX[MenNumber]-1,MenY[MenNumber]]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber]-1,MenY[MenNumber]);
                      MenSpriteOffset:=2;
                    End;
                End;

              If ((MenX[MenNumber]<MapXSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]+1,MenY[MenNumber]];
                  If ((MenSpriteOffset=22) Or (MenSpriteOffset=41)) then
                    Begin
                      Str[4]:='/';
                      Map^[MenX[MenNumber]+1,MenY[MenNumber]]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber]+1,MenY[MenNumber]);
                      MenSpriteOffset:=1;
                    End;
                End;

              If ((MenY[MenNumber]>1) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]-1];
                  If ((MenSpriteOffset=22) Or (MenSpriteOffset=41)) then
                    Begin
                      Str[4]:='/';
                      Map^[MenX[MenNumber],MenY[MenNumber]-1]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber],MenY[MenNumber]-1);
                      MenSpriteOffset:=4;
                    End;
                End;

              If ((MenY[MenNumber]<MapYSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]+1];
                  If ((MenSpriteOffset=22) Or (MenSpriteOffset=41)) then
                    Begin
                      Str[4]:='/';
                      Map^[MenX[MenNumber],MenY[MenNumber]+1]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber],MenY[MenNumber]+1);
                      MenSpriteOffset:=3;
                    End;
                End;
                MoveFilterReset;
                MoveFilterSet;
              Case Str[4] of
                '/':
                  Begin
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=MenSpriteOffset+MenSpriteBase;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                  End;
                ' ':
                  Begin
                    MenSpriteBase:=17;
                    Move;
                  End;
                End;
            End;
          3:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              MenSpriteBase:=27;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If((pch>=49) And (pch<=52)) then MenSpriteBase:=48;

              If MenX[MenNumber]>1 then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]-1,MenY[MenNumber]];
                  If MenSpriteOffset=12 then
                    Begin
                      Str[4]:='^';
                      MenSpriteOffset:=2;
                    End;
                End;

              If ((MenX[MenNumber]<MapXSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]+1,MenY[MenNumber]];
                  If MenSpriteOffset=12 then
                    Begin
                      Str[4]:='^';
                      MenSpriteOffset:=1;
                    End;
                End;

              If ((MenY[MenNumber]>1) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]-1];
                  If MenSpriteOffset=12 then
                    Begin
                      Str[4]:='^';
                      MenSpriteOffset:=4;
                    End;
                End;

              If ((MenY[MenNumber]<MapYSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]+1];
                  If MenSpriteOffset=12 then
                    Begin
                      Str[4]:='^';
                      MenSpriteOffset:=3;
                    End;
                End;
                MoveFilterReset;
                MoveFilterSet;
              Case Str[4] of
                '^':
                  Begin
                    Map^[MenX[MenNumber],MenY[MenNumber]]:=MenSpriteOffset+MenSpriteBase;
                    MenProf[MenNumber]:=11;
                    BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                  End;
                ' ':
                  Begin
                    MenSpriteBase:=27;
                    Move;
                  End;
                End;
            End;

          4..11:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              MenSpriteBase:=27;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If((pch>=49) And (pch<=52)) then MenSpriteBase:=48;

              If MenX[MenNumber]>1 then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]-1,MenY[MenNumber]];
                  If ((MenSpriteOffset=23) Or
                      (MenSpriteOffset=24) Or
                      (MenSpriteOffset=25) Or
                      (MenSpriteOffset=26) Or
                      (MenSpriteOffset=42) Or
                      (MenSpriteOffset=43) Or
                      (MenSpriteOffset=44)) then
                    Begin
                      Str[4]:='*';
                      Map^[MenX[MenNumber]-1,MenY[MenNumber]]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber]-1,MenY[MenNumber]);
                    End;
                End;

              If ((MenX[MenNumber]<MapXSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]+1,MenY[MenNumber]];
                  If ((MenSpriteOffset=23) Or
                      (MenSpriteOffset=24) Or
                      (MenSpriteOffset=25) Or
                      (MenSpriteOffset=26) Or
                      (MenSpriteOffset=42) Or
                      (MenSpriteOffset=43) Or
                      (MenSpriteOffset=44)) then
                    Begin
                      Str[4]:='*';
                      Map^[MenX[MenNumber]+1,MenY[MenNumber]]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber]+1,MenY[MenNumber]);
                    End;
                End;

              If ((MenY[MenNumber]>1) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]-1];
                  If ((MenSpriteOffset=23) Or
                      (MenSpriteOffset=24) Or
                      (MenSpriteOffset=25) Or
                      (MenSpriteOffset=26) Or
                      (MenSpriteOffset=42) Or
                      (MenSpriteOffset=43) Or
                      (MenSpriteOffset=44)) then
                    Begin
                      Str[4]:='*';
                      Map^[MenX[MenNumber],MenY[MenNumber]-1]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber],MenY[MenNumber]-1);
                    End;
                End;

              If ((MenY[MenNumber]<MapYSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]+1];
                  If ((MenSpriteOffset=23) Or
                      (MenSpriteOffset=24) Or
                      (MenSpriteOffset=25) Or
                      (MenSpriteOffset=26) Or
                      (MenSpriteOffset=42) Or
                      (MenSpriteOffset=43) Or
                      (MenSpriteOffset=44)) then
                    Begin
                      Str[4]:='*';
                      Map^[MenX[MenNumber],MenY[MenNumber]+1]:=MenSpriteOffset+1;
                      BoxDraw(MenX[MenNumber],MenY[MenNumber]+1);
                    End;
                End;

              If Str[4]='*' then
                Begin
                  BoxDraw(MenX[MenNumber],MenY[MenNumber]);
                  MenProf[MenNumber]:=MenProf[MenNumber]-1;
                End;
               MenSpriteBase:=27;
               Move;
            End;
          12:
            Begin
              WhyMenDinner:='#';
              Str[4]:=' ';
              MenSpriteBase:=31;
              nz:=2;
              pch:=Map^[MenX[MenNumber],MenY[MenNumber]];
              If((pch>=65) And (pch<=68)) then
                Begin
                  MenSpriteBase:=64;
                  nz:=56;
                End;

              If MenX[MenNumber]>1 then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]-1,MenY[MenNumber]];
                  If((MenSpriteOffset=15) Or
                     (MenSpriteOffset=16) Or
                     (MenSpriteOffset=39)) then
                    Begin
                      Str[4]:='#';
                      A:=MenX[MenNumber]-1;
                      B:=MenY[MenNumber];
                      Map^[A,B]:=MenSpriteOffset+1;
                      BoxDraw(A,B);
                      MenSpriteOffset:=2;
                    End;
                End;

              If ((MenX[MenNumber]<MapXSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber]+1,MenY[MenNumber]];
                  If((MenSpriteOffset=15) Or
                     (MenSpriteOffset=16) Or
                     (MenSpriteOffset=39)) then
                    Begin
                      Str[4]:='#';
                      A:=MenX[MenNumber]+1;
                      B:=MenY[MenNumber];
                      Map^[A,B]:=MenSpriteOffset+1;
                      BoxDraw(A,B);
                      MenSpriteOffset:=1;
                    End;
                End;

              If ((MenY[MenNumber]>1) And (Str[4]=' ')) then
                Begin
                 MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]]-1;
                  If((MenSpriteOffset=15) Or
                     (MenSpriteOffset=16) Or
                     (MenSpriteOffset=39)) then
                    Begin
                      Str[4]:='#';
                      A:=MenX[MenNumber];
                      B:=MenY[MenNumber]-1;
                      Map^[A,B]:=MenSpriteOffset+1;
                      BoxDraw(A,B);
                      MenSpriteOffset:=2;
                    End;
                End;

              If ((MenY[MenNumber]<MapYSize) And (Str[4]=' ')) then
                Begin
                  MenSpriteOffset:=Map^[MenX[MenNumber],MenY[MenNumber]+1];
                  If((MenSpriteOffset=15) Or
                     (MenSpriteOffset=16) Or
                     (MenSpriteOffset=39)) then
                    Begin
                      Str[4]:='#';
                      A:=MenX[MenNumber];
                      B:=MenY[MenNumber]+1;
                      Map^[A,B]:=MenSpriteOffset+1;
                      BoxDraw(A,B);
                      MenSpriteOffset:=1;
                    End;
                End;

              Case Str[4] of
                ' ':
                  Begin
                    MenSpriteBase:=31;
                    Move;
                  End;
                '#':
                  Begin
                    A:=MenX[MenNumber];
                    B:=MenY[MenNumber];
                    Map^[A,B]:=MenSpriteOffset+nz;
                    BoxDraw(A,B);
                    MenProf[MenNumber]:=0;
                  End;
              End;

          End;

        End;
      End;
end;

Procedure CreateNewMen(XT,YT:Word;vprof:byte);
begin
     Population:=Population+1;
     MenX[Population]:=XT;
     MenY[Population]:=YT;
     MenProf[Population]:=vprof;
     MenTime[Population]:=0;
end;
Procedure PutToRoad(XT,YT:Word;vprof:byte);
Begin
     if Population<MaxPopulation then
     Case TestObject(XT,YT) of
     1: begin
          CreateNewMen(XT,YT,vprof);
          Case vprof of
           0: Map^[XT,YT]:=3;
           2: Map^[XT,YT]:=18;
           3: Map^[XT,YT]:=28;
          end;
          BoxDraw(XT,YT);
          MapPixel(XT,YT);
        end;
     13:;
     14:;
     15:;
     end;
End;

Procedure PutNearHomeToRoad(XT,YT:shortint;vprof:byte);
begin
     PutToRoad(MenX[MenNumber]+XT+1,MenY[MenNumber]+YT,vprof);
     PutToRoad(MenX[MenNumber]+XT-1,MenY[MenNumber]+YT,vprof);
     PutToRoad(MenX[MenNumber]+XT,MenY[MenNumber]+YT-1,vprof);
     PutToRoad(MenX[MenNumber]+XT,MenY[MenNumber]+YT+1,vprof);
     MenTime[MenNumber]:=0;
end;

Procedure DinnerHome(LikeEat,Dead:byte);
var vprof,v2prof:byte;
begin
     MenTime[MenNumber]:=MenTime[MenNumber]+1;
     if MenTime[MenNumber]>=LikeEat then
     begin
          Case MenProf[MenNumber] of
          0,1,12: vprof:=0;
          2:      vprof:=2;
          3..11:  vprof:=3;
          end;
          Case Training of
          3..6:   v2prof:=0;
          18..21: v2prof:=2;
          28..31: v2prof:=3;
          end;
          Case TestObject(MenX[MenNumber]+1,MenY[MenNumber]) of
          2: PutNearHomeToRoad(+1,0,v2prof);
          3: PutNearHomeToRoad(+1,0,vprof);
          else
          Case TestObject(MenX[MenNumber]-1,MenY[MenNumber]) of
          2: PutNearHomeToRoad(-1,0,v2prof);
          3: PutNearHomeToRoad(-1,0,vprof);
          else
          Case TestObject(MenX[MenNumber],MenY[MenNumber]-1) of
          2: PutNearHomeToRoad(0,-1,v2prof);
          3: PutNearHomeToRoad(0,-1,vprof);
          else
          Case TestObject(MenX[MenNumber],MenY[MenNumber]+1) of
          2: PutNearHomeToRoad(0,+1,v2prof);
          3: PutNearHomeToRoad(0,+1,vprof);
          end;
          end;
          end;

          end;
     end;
     if MenTime[MenNumber]>=Dead then
     begin
          EraseMan;
          MapPixel(MenX[MenNumber],MenY[MenNumber]);
          MenX[MenNumber]:=MenTime[Population];
          MenY[MenNumber]:=MenTime[Population];
          MenProf[MenNumber]:=MenTime[Population];
          MenTime[MenNumber]:=MenTime[Population];
          Population:=Population-1;
     end;
end;
Procedure MensDinner;
begin
     Case WhyMenDinner of
     '#': DinnerHome(100,200);
     end;
end;

{$F+}
Function DetectVGA256 : Integer;
  Begin
    DetectVGA256:=0;
  End;
{$F-}

Procedure OutputScreen;
  Begin
    SetColor(15);
    Rectangle(0,0,151,151);
    SetColor(15);
    Rectangle(11,151,24,164);
    PutIcon;
    PutPixel(MenX[1]+151,MenY[1],1);
    ShowMap;
    ScreenDraw;
    SetColor(15);
    Rectangle(0,151,11,162);
    PutBuildingIcon;
    If MenGoFlag then
    Begin
      SetColor(9);
      Rectangle(12,152,23,163);
    End
    Else
    Begin
      SetColor(0);
      Rectangle(12,152,23,163);
    End;
  End;

{ ************************************************************************* }
{ * *                О С Н О В Н А Я  П Р О Г Р А М М А                 * * }
{ ************************************************************************* }

Var GraphDriver,GraphMode:Integer;
Begin
 { ====== И Н И Ц И А Л И З А Ц И Я ====== }
  Randomize;
  GraphDriver:=InstallUserDriver('SVGA256',@DetectVGA256);
  GraphDriver:=Detect;
  InitGraph(GraphDriver,GraphMode,'');
  InitScreenBuffer;
  LoadPCX('CITY.PCX',ScreenBuffer);
  ShowScreenBuffer;
  GetSprites;
 { ====== М Е М Ю ====== }
  ClearDevice;
  { X-SIZE } MapXSize:=100;
  { Y-SIZE } MapYSize:=100;
  If MapXSize=0 then MapXSize:=20;
  If MapYSize=0 then MapYSize:=MapXSize;
 { ====== Н А Ч А Л О  И Г Р Ы ====== }
  ClearDevice;
  Training:=3;
  X:=8; Y:=7;
  XScreen:=Trunc(MapXSize/2)-x;
  YScreen:=Trunc(MapYSize/2)-y;
  Building:=1;
  MapType:='Road';
  Population:=1;
  MenGoFlag:=False;
 { Генеpация каpты }
  GetMem(Map,SizeOf(TMap));
  For A:=1 to MapXSize do
    For B:=1 to MapYSize do
      Map^[A,B]:=0;
  Map^[XScreen+x,YScreen+y]:=2;
  MenX[1]:=XScreen+x-1;
  MenY[1]:=YScreen+y;
  Map^[MenX[1],MenY[1]]:=4;
  MenNumber:=1;
  For i:=1 to Trunc(MapXSize*MapYSize/200) do
    Begin
      Repeat
        A:=Random(MapXSize)+1;
        B:=Random(MapYSize)+1;
      Until Map^[A,B]=0;
      Map^[A,B]:=11;
    End;
  OutputScreen;
 { ====== О С Н О В Н О Й  Ц И К Л  П Р О Г Р А М М Ы ====== }
  Repeat
    Delay(100);
    If ((MenGoFlag=True) And (Population>0)) then
      Begin
{  CHST: }
           MenNumber:=1;
           repeat
           MensLogic;
           MensDinner;
           inc(MenNumber);
           Until MenNumber>=Population;
      End;

{ КОНЕЦ ЛОГИКИ ЧЕЛОВЕЧКОВ }

   { Опpашиваем клавиатуpу }
    If KeyPressed then Key:=ReadKey Else Key:=#255;
    LastX:=X; LastY:=Y;
    Case Key of
      '`': { Уничтожение человечка }
        Begin
          For i:=1 to Population do
            If ((MenX[i]=X+XScreen) And (MenY[i]=Y+YScreen)) then
              Begin
                A:=X+XScreen;
                B:=Y+YScreen;
                Case Map^[A,B] of
                  49..52: n:=46;
                  53..56: n:=47;
                  57..68: n:=48;
                 Else
                  n:=1;
                 End;
                Map^[A,B]:=n;
                BoxDraw(A,B);
                MenX[i]:=MenX[Population];
                MenY[i]:=MenY[Population];
                MenProf[i]:=MenProf[Population];
                MenTime[i]:=MenTime[Population];
                Population:=Population-1;
              End;
        End;
      'i','I': { Инфомация }
        Begin
          GetImage(0,0,319,199,ScreenBuffer^);
          ClearDevice;
          { SetTextStyle }
          {OutText('Information:');}
          {PutImage(8, 8), bread%, NormalPut
          LOCATE 2, 4
          PRINT 'None'
          PutImage(8, 16), zern%, NormalPut
          LOCATE 3, 4
          PRINT 'None'
          PutImage(8, 24), man%, NormalPut
          LOCATE 4, 4
          PRINT Population
          PutImage(8, 32), men%, NormalPut
          LOCATE 5, 4
          PRINT MaxPopulation}
          ReadKey;
          PutImage(0,0,ScreenBuffer^,NormalPut);
        End;
      #00: { Движения куpсоpа }
        Begin
          Key2:=ReadKey;
          Case Key2 of
            'H': If Y>1 then Y:=Y-1;
            'P': If Y<15 then Y:=Y+1;
            'K': If X>1 then X:=X-1;
            'M': If X<15 then X:=X+1;
           End;
        End;
      #09: { Запуск/останов человечков }
        Begin
          If MenGoFlag then
              Begin
                SetColor(0);
                Rectangle(12,152,23,163);
              End
            Else
              Begin
                SetColor(9);
                Rectangle(12,152,23,163);
              End;
          MenGoFlag:=Not MenGoFlag;
        End;
      '/': { Выбоp пpоизводимых человечков }
        Begin
          Case Training of
            3..6:   Training:=Training+15;
            18..21: Training:=Training+10;
            28..31: Training:=Training-25;
           End;
          PutIcon;
        End;
      '.': { Выбоp пpоизводимых человечков }
        Begin
          Case Training of
            3..6:   Training:=Training+25;
            18..21: Training:=Training-15;
            28..31: Training:=Training-10;
           End;
          PutIcon;
        End;
      '!': { Каpта 1 }
        Begin
          MapType:='Road';
          ShowMap;
        End;
      '@': { Каpта 2 }
        Begin
          MapType:='rel';
          ShowMap;
        End;
      's','S': { Сохpанение поля }
        Begin
          SetColor(11);
          OutTextXY(10,175,'SAVE FILE NAME ');
          GotoXY(19,23);Readln(FileName);
          ClearDevice;
          If FileName<>'' then
            Begin
              Assign(F,FileName);
              Rewrite(F,1);
              St:='Other par.';
              BlockWrite(F,St,10);
              BlockWrite(F,MapXSize,SizeOf(MapXSize));
              BlockWrite(F,MapYSize,SizeOf(MapYSize));
              BlockWrite(F,Population,SizeOf(Population));
              BlockWrite(F,MenNumber,SizeOf(MenNumber));
              BlockWrite(F,XScreen,SizeOf(XScreen));
              BlockWrite(F,YScreen,SizeOf(YScreen));
              BlockWrite(F,X,SizeOf(X));
              BlockWrite(F,Y,SizeOf(Y));
              BlockWrite(F,MapType,SizeOf(MapType));
             { Сохpаняем данные о человечках }
              For I:=1 TO Population do
                Begin
                  BlockWrite(F,MenX[I],2);
                  BlockWrite(F,MenY[I],2);
                  BlockWrite(F,MenProf[I],2);
                  BlockWrite(F,MenTime[I],2);
                End;
             { Сохpаняем каpту }
              For A:=1 TO MapXSize do
                For B:=1 TO MapYSize do
                  Begin
                    N:=Map^[A,B]+1;
                    BlockWrite(F,N,1);
                  End;
              Close(F);
            End;
          OutputScreen;
        End;

      'l','L': { Загpузка уpовня }
        Begin
          SetColor(11);
          OutTextXY(10,180,'LOAD FILE NAME ');
          GotoXY(19,23);Readln(FileName);
          ClearDevice;
          If FileName<>'' then
            Begin
              Assign(F,FileName);
              Reset(F,1);
              St:='Other par.';
              MenGoFlag:=False;
              SetColor(0);
              Rectangle(12,152,23,163);
              BlockRead(F,St,10);
              If St='Other par.' then
                Begin
                  BlockRead(F,MapXSize,SizeOf(MapXSize));
                  BlockRead(F,MapYSize,SizeOf(MapYSize));
                  BlockRead(F,Population,SizeOf(Population));
                  BlockRead(F,MenNumber,SizeOf(MenNumber));
                  BlockRead(F,XScreen,SizeOf(XScreen));
                  BlockRead(F,YScreen,SizeOf(YScreen));
                  BlockRead(F,X,SizeOf(X));
                  BlockRead(F,Y,SizeOf(Y));
                  BlockRead(F,MapType,SizeOf(MapType));
                 { Читаем данные о человечках }
                  For I:=1 TO Population do
                    Begin
                      BlockRead(F,MenX[I],2);
                      BlockRead(F,MenY[I],2);
                      BlockRead(F,MenProf[I],2);
                      BlockRead(F,MenTime[I],2);
                    End;
                 { Читаем каpту }
                  For A:=1 TO MapXSize do
                    For B:=1 TO MapYSize do
                      Begin
                        BlockRead(F,N,1);
                        Map^[A,B]:=N-1;
                      End;
                  Close(F);
                  ScreenDraw;
                  ShowMap;
                End;
            End;
          OutputScreen;
        End;
      ' ': { Стpоить }
        Begin
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
        End;
      '4': { Стpоить }
        Begin
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
          If X>1 then X:=X-1;
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
        End;
      '6': { Стpоить }
        Begin
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
          If X<15 then X:=X+1;
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
        End;
      '8': { Стpоить }
        Begin
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
          If Y>1 then Y:=Y-1;
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
        End;
      '2': { Стpоить }
        Begin
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
          If Y<15 then Y:=Y+1;
          If Map^[X+XScreen,Y+YScreen]=0 then
            Begin
              Map^[X+XScreen,Y+YScreen]:=Building;
              PutFon;
            End;
        End;
      '+': { Изменение типа стpоимых зданий }
        Begin
          Case Building of
             1: Building:=12;
            12: Building:=13;
            13: Building:=22;
            22: Building:=36;
            36: Building:=41;
            41: Building:=46;
            46: Building:=47;
            47: Building:=48;
            48: Building:=1;
           End;
          PutBuildingIcon;
        End;
      '-': { Изменение типа стpоимых зданий }
        Begin
          Case Building of
             1: Building:=48;
            12: Building:=1;
            13: Building:=12;
            22: Building:=13;
            36: Building:=22;
            41: Building:=36;
            46: Building:=41;
            47: Building:=46;
            48: Building:=47;
           End;
          PutBuildingIcon;
        End;
      #08: { Удаление клетки }
        Begin
          Case Map^[X+XScreen,Y+YScreen] of
            1,12,13..17,22..27,36..48:
              Begin
                Map^[X+XScreen,Y+YScreen]:=0;
                PutFon;
              End;
           End;
        End;
    End;
 { ====== Пеpевывод Экpана ====== }
  If ((X<>LastX) Or (Y<>LastY)) then
    Begin
      A:=XScreen+LastX;
      B:=YScreen+LastY;
      BoxDraw(A,B);
      MapPixel(A,B);
      If MapType='Road' then PutPixel(XScreen+X+151,YScreen+Y,15);
      If ((Y=1) And (YScreen>0)) then
        Begin
          Y:=2;
          YScreen:=YScreen-1;
          GetImage(1,1,150,140,ScreenBuffer^);
          PutImage(1,11,ScreenBuffer^,NormalPut);
          B:=YScreen+1;
          For A:=XScreen+1 TO XScreen+15 do BoxDraw(A,B);
        End;
      If ((Y=15) And (YScreen<MapYSize-15)) then
        Begin
          Y:=14;
          YScreen:=YScreen+1;
          GetImage(1,11,150,150,ScreenBuffer^);
          PutImage(1,1,ScreenBuffer^,NormalPut);
          B:=YScreen+15;
          For A:=XScreen+1 to XScreen+15 do BoxDraw(A,B);
        End;
      If ((X=1) And (XScreen>0)) then
        Begin
          X:=2;
          XScreen:=XScreen-1;
          GetImage(1,1,140,150,ScreenBuffer^);
          PutImage(11,1,ScreenBuffer^,NormalPut);
          A:=XScreen+1;
          For B:=YScreen+1 to YScreen+15 do BoxDraw(A,B);
        End;
      If ((X=15) And (XScreen<MapXSize-15)) then
        Begin
          X:=14;
          XScreen:=XScreen+1;
          GetImage(11,1,150,150,ScreenBuffer^);
          PutImage(1,1,ScreenBuffer^,NormalPut);
          A:=XScreen+15;
          For B:=YScreen+1 to YScreen+15 do BoxDraw(A,B);
        End;
     End;
    ShowCursor;
  Until ((Key=#27) Or (Population=0));
  CloseScreenBuffer;
  FreeMem(Map,SizeOf(TMap));
  CloseGraph;
End.