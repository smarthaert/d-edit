Unit SprMngr;

Interface

Uses DOS,Clr_Nat,Video,Paths;

Type
  TNatDirSpr=Array [1..8] of TNationSprite;
  PNatDirSpr=^TNatDirSpr;
  TSpriteManager=
    Object
      Tank:PNatDirSpr;
      Pusto:PStdSprite;
      Boom:PMaskSprite;
      Mouse:PNationSprite;
      Water:PStdSprite;
      Constructor Init;
      Destructor Done;
      Procedure DonePNatDirSpr(Var P:PNatDirSpr);
      Procedure InitPNatDirSpr(Var P:PNatDirSpr; FileMask:PathStr);
    End;

Var
  SpriteManager:TSpriteManager;

Implementation

Constructor TSpriteManager.Init;
Begin
   InitPNatDirSpr(Tank,'_TANK?.SPR');
   New(Pusto,LoadHSprite('_PUSTO.SPR'));
   New(Water,LoadHSprite('WATER_F.SPR'));
   New(Boom,LoadHSprite('_BOOM.SPR'));
   New(Mouse,LoadHSprite('MOUSE.SPR'));
End;

Procedure TSpriteManager.InitPNatDirSpr;
  Var
    I,N:Byte;
    S:String[1];
Begin
   N:=Pos('?',FileMask);
   New(P);
   For I:=1 to 8 do
     Begin
        Str(I,S);
        If N<>0 then FileMask[N]:=S[1];
        P^[I].LoadHSprite(FileMask);
     End;
End;

Destructor TSpriteManager.Done;
Begin
   Dispose(Pusto,Done);
   Dispose(Water,Done);
   Dispose(Boom,Done);
   Dispose(Mouse,Done);
   DonePNatDirSpr(Tank);
End;

Procedure TSpriteManager.DonePNatDirSpr;
  Var
    I:Byte;
Begin
   For I:=1 to 8 do
     P^[I].Done;
   Dispose(P);
End;

End.