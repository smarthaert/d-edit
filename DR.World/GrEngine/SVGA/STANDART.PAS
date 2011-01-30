Uses CRT,DOS,Graph;

Function AbsoluteTime:LongInt;
  Var Hour,Minute,Second,Sec100:Word;
  Begin
    GetTime( Hour,Minute,Second,Sec100 );
    AbsoluteTime:=((Hour*60+Minute)*60+Second*100)+Sec100;
  End;

Procedure MyLine( X1,Y1,X2,Y2:LongInt );
  Var X,Y,dX,dY,A,B:LongInt;
  Begin
    dX:=X2-X1;
    dY:=Y2-Y1;
    If ((dX=0) And (dY=0)) then Begin PutPixel(X1,Y1,14); Exit; End;
    If Abs(dX) > Abs(dY) then
      Begin
        A:=X1; B:=X2;
        If dX < 0 then Begin A:=X2; B:=X1; End;
        For X:=A to B do
          PutPixel(X,Y1+((X-X1)*dY) div dX,14)
      End
    Else
      Begin
        A:=Y1; B:=Y2;
        If dY < 0 then Begin A:=Y2; B:=Y1; End;
        For Y:=A to B do
          PutPixel(X1+((Y-Y1)*dX) div dY,Y,14)
      End;
  End;

Var GD,GM,X,Y:Integer; BeginTime,EndTime:LongInt;
Begin
  GD:=VGA; GM:=VGAHI;
  InitGraph(GD,GM,'i:\language\BP\BGI');
  BeginTime:=AbsoluteTime;
  For X:=-2 to 2 do
    For Y:=-2 to 2 do
      If (X<>0)Or(Y<>0) then MyLine(100,100,100+X*50,100+Y*50);
  MyLine(300,300,300,300);
  { 17 }
{  For X:=0 to 639 do
    For Y:=0 to 479 do
      PutPixel(X,Y,15);}
(*    MyLine(0,0,639,479); { 17 } *)
  EndTime:=AbsoluteTime;
  ReadKey;
  CloseGraph;
  Writeln(EndTime-BeginTime);
  ReadKey;
End.