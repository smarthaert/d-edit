Uses CRT,DOS;

Const
  DefaultEditFile='karte.map';
  MapMax=3;
  TrTab:Array [0..MapMax] of Char=
    ' SF±';

Type
  MapCoord=0..31;
  MapPoint=
    Record
      X,Y:MapCoord;
    End;
  PutSet=Set of Byte;

Const
  OneMapPut:PutSet=[1];

Var
  Map:Array [0..31,0..31] of Byte;
  Curs:MapPoint;
  Put:Byte;
  Refresh:Boolean;
  EditFile:PathStr;

Function Equal(Var P1,P2; Count:Word):Boolean;
  Var
    R:Boolean;
Begin
  Asm
    Mov CX,Count
    Inc CX
    Push DS
    LES SI,P1
    LDS DI,P2
    Rep CMPSB
    Mov AL,0
    Cmp CX,0
    JNZ @@Exit
    Mov AL,1
   @@Exit:
    Pop DS
    Mov R,AL
  End;
  Equal:=R;
End;

Procedure LoadMap;
  Var F:File;
Begin
   Assign(F,EditFile);
   Reset(F,1024);
   BlockRead(F,Map,1);
   Close(F);
   Refresh:=True;
End;

Procedure SaveMap;
  Var F:File;
Begin
   Assign(F,EditFile);
   ReWrite(F,1024);
   BlockWrite(F,Map,1);
   Close(F);
End;

Procedure ShowME(Cr:MapPoint);
  Var
    Tm:MapPoint;
Begin
   Tm:=Curs;
   If Equal(Tm,Cr,SizeOf(Cr)) then
     TextBackGround(13)
     Else
     TextBackGround(1);
   With Cr do
     Begin
        GotoXY(2+X,2+Y);
        Write(TrTab[Map[X,Y]]);
     End;
End;

Procedure ShowMap;
  Var
    Cr:MapPoint;
Begin
   For Cr.Y:=0 to 31 do
     For Cr.X:=0 to 31 do
       ShowME(Cr);
   Refresh:=False;
End;

Procedure ShowPut;
  Const
    Size=5;
  Var
    X,Y:ShortInt;
Begin
   TextBackGround(6);
   For Y:=-Size to Size do
     Begin
        GotoXY(40,10+Y);
        For X:=-Size to Size do
          Write(TrTab[Put]);
     End;
End;

Procedure TestParam;
  Var
    S:PathStr;
Begin
   EditFile:=DefaultEditFile;
   If ParamCount=1 then
     Begin
        S:=FSearch(ParamStr(1),'');
        If S<>'' then EditFile:=S;
     End;
End;

Procedure Show_All;
Begin
   ShowMap;
   ShowPut;
End;

Procedure Init_All;
Begin
   TestParam;
   ClrScr;
   TextMode(258);
   Curs.X:=15;
   Curs.Y:=15;
   Put:=0;
   Refresh:=False;
End;

Procedure Done_All;
Begin
   TextBackGround(0);
   ClrScr;
   TextMode(CO80);
End;

Procedure MoveCurs(X,Y:MapCoord);
  Var
    Old:MapPoint;
Begin
   Old:=Curs;
   Curs.X:=X;
   Curs.Y:=Y;
   ShowME(Old);
   ShowME(Curs);
End;

Procedure ChangeME(S,D:Byte);
  Var
    X,Y:MapCoord;
Begin
   For X:=0 to 31 do
     For Y:=0 to 31 do
       If Map[X,Y]=S then Map[X,Y]:=D;
   Refresh:=True;
End;

Procedure PutME;
  Var
    Old:Byte;
Begin
   Old:=Map[Curs.X,Curs.Y];
   If Old In OneMapPut then Exit;
   If Put In OneMapPut then ChangeME(Put,0);
   Map[Curs.X,Curs.Y]:=Put;
   ShowME(Curs);
End;

Procedure IncPut;
Begin
   If Put<MapMax then
     Inc(Put)
     Else
     Put:=0;
   ShowPut;
End;

Procedure DecPut;
Begin
   If Put>0 then
     Dec(Put)
     Else
     Put:=MapMax;
   ShowPut;
End;

Procedure EditRun;
  Var
    Key:Char;
Begin
   Show_All;
   Repeat
     If KeyPressed then
       Begin
          Key:=ReadKey;
          Case Key of
            #0:
              Case ReadKey of
                #60:SaveMap;
                #61:LoadMap;
                #75:If Curs.X> 0 then MoveCurs(Curs.X-1,Curs.Y  );
                #77:If Curs.X<31 then MoveCurs(Curs.X+1,Curs.Y  );
                #72:If Curs.Y> 0 then MoveCurs(Curs.X  ,Curs.Y-1);
                #80:If Curs.Y<31 then MoveCurs(Curs.X  ,Curs.Y+1);
              End;
            ' ':PutME;
            '+':IncPut;
            '-':DecPut;
          End;
       End
       Else
       Key:=#255;
     If Refresh then ShowMap;
     GotoXY(1,1);
   Until Key=#27;
End;

Begin
   Init_All;
   LoadMap;
   EditRun;
   Done_All;
End.