Uses DOS,Video,Clr_Nat;

Function AbsTime:LongInt;
  Var
    H,M,S,SH:Word;
Begin
   GetTime(H,M,S,SH);
   AbsTime:=((LongInt(H)*60+M)*60+S)*100+SH;
End;

Const
  Pov=100000;

Var
  I,St,Et,Wt:LongInt;
  Rt:Extended;
  Buf:PScrBuf;
  Sprite:PNationSprite;
Begin
   New(Buf);
   CurScr:=Buf;
   New(Sprite,Init(10,10));
   St:=AbsTime;
   For I:=1 to Pov do
     Sprite^.PutNatXY(10,10,3);
   Et:=AbsTime;
   Dispose(Sprite,Done);
   Dispose(Buf);
   Wt:=Et-St;
   Rt:=(Wt/Pov*10000);
   WriteLn('All Ticks : ',Wt);
   WriteLn('One Microseconds : ',Rt:5:10);
End.