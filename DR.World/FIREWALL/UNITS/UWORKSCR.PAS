Unit UWorkScr;

Interface

Uses Video,Clr_Nat,SprMngr,MouseLib;

Const
  WorkWinXS=50;
  WorkWinYS=50;

Var
  ScrollX,ScrollY:Word;
  ScrBuf,WorkScrBuf:PScrBuf;
  MouseX,MouseY:Integer;
  MouseNat:NumNation;
  MouseLB,MouseRB:Boolean;

Type
  PPMView=^PMView;
  PMView=^TMView;
  TMView=
    Object
      X,Y,XD,YD:Integer;
      CurSpr:PStdSprite;
      Next:PMView;
      SelfPointer:PPMView;
      Nation:NumNation;
      Constructor Init(SP:PPMView; Sprite:PStdSprite; _XD,_YD:Integer; Nat:NumNation);
      Procedure Draw(NP:Byte); Virtual;
      Procedure DrawSub(NP:Byte); Virtual;
      Procedure Step; Virtual;
      Destructor Done; Virtual;
      Procedure Free;
    End;
  PPMGroup=^PMGroup;
  PMGroup=^TMGroup;
  TMGroup=
    Object(TMView)
      Group:PMView;
      Constructor Init(SP:PPMGroup; Sprite:PStdSprite; _XD,_YD:Integer; Nat:NumNation);
      Procedure Insert(Ins:PMView);
      Destructor Done; Virtual;
      Procedure DrawSub(NP:Byte); Virtual;
      Procedure Step; Virtual;
    End;

Procedure ShowWorkWindow(N:Byte);
Procedure DrawMView(NP:Byte; MV:PMView);

Procedure DrawWorkFrame;
Function MouseIn(X1,Y1,X2,Y2:Integer):Boolean;
Procedure DrawMouse;
Procedure InitMCGAMouse;
Procedure GetMousePos;

Procedure InitMObjs;
Procedure DoneMObjs;
Procedure StepMObjs;
Procedure DrawMObjs(NP:Byte);
Procedure InsertMUnit(P:PMView);
Procedure InsertMBuilding(P:PMView);

Const
  CurMouse:PNationSprite=Nil;
  MUnits:PMGroup=Nil;
  MBuildings:PMGroup=Nil;

Implementation

Constructor TMView.Init;
Begin
   Nation:=Nat;
   SelfPointer:=SP;
   CurSpr:=Sprite;
   X:=_XD Div 10;
   Y:=_YD Div 10;
   XD:=_XD;
   YD:=_YD;
   Next:=Nil;
End;

Procedure TMView.Draw;
  Var
    XP,YP,XS,YS:Integer;
Begin
   If Next<>Nil then Next^.Draw(NP);
   If CurSpr=Nil then Exit;
   XS:=CurSpr^.XSize div 2;
   YS:=CurSpr^.YSize div 2;
   If (XD+XS<ScrollX*10)Or(YD+YS<ScrollY*10+NP*80)Or(XD-XS>ScrollX*10+209)Or(YD-YS>ScrollY*10+79+NP*80) then
     Exit;
   XP:=XD-ScrollX*10;
   YP:=YD-ScrollY*10-NP*80;
   If (XP+XS<0)Or(XP-XS>209)Or(YP+YS<0)Or(YP-YS>79) then
     Exit;
   If Nation=0 then
     CurSpr^.PutCenterXY(XP+WorkWinXS-10,YP+WorkWinYS-10)
     Else
     PNationSprite(CurSpr)^.PutNatCenter(XP+WorkWinXS-10,YP+WorkWinYS-10,Nation);
End;

Procedure TMView.Free;
Begin
   If SelfPointer=Nil then
     Begin
        Done;
        If Next<>Nil then Next^.Free;
     End
     Else
     Begin
        If Next<>Nil then
          Next^.SelfPointer:=SelfPointer;
        Dispose(SelfPointer^,Done);
        SelfPointer^:=Next;
     End;
End;

Procedure TMView.DrawSub;
Begin
   If Next<>Nil then Next^.DrawSub(NP);
End;

Procedure TMView.Step;
Begin
   If Next<>Nil then Next^.Step;
End;

Destructor TMView.Done;
Begin
End;

Constructor TMGroup.Init;
Begin
   Inherited Init(PPMView(SP),Sprite,_XD,_YD,Nat);
   Group:=Nil;
End;

Procedure TMGroup.Insert;
Begin
   Ins^.Next:=Group;
   If Group<>Nil then
     If Group^.SelfPointer<>Nil then
       Group^.SelfPointer:=@Ins^.Next;
   Group:=Ins;
   If Ins^.SelfPointer<>Nil then
     Ins^.SelfPointer:=@Group;
End;

Procedure TMGroup.DrawSub;
Begin
   Inherited DrawSub(NP);
   If Group<>Nil then
     Begin
        Group^.Draw(NP);
        Group^.DrawSub(NP);
     End;
End;

Procedure TMGroup.Step;
Begin
   Inherited Step;
   If Group<>Nil then
     Group^.Step;
End;

Destructor TMGroup.Done;
Begin
   While Group<>Nil do
     Group^.Free;
   Inherited Done;
End;

Procedure ShowWorkWindow;
  Var
    PS,PW:PScrBuf;
Begin
   PS:=ScrBuf;
   PW:=WorkScrBuf;
   Asm
     LES  DI,PS
     Add  DI,15*320+100
     Mov  DL,N
     Test DL,1
     JZ  @@FirstPart
     Add  DI,80*320
    @@FirstPart:
     Push DS
     LDS SI,PW
     Add SI,(WorkWinXS+WorkWinYS*320)
     Mov DX,80
    @@Lines:
     Mov CX,105
     Rep Movsw
     Add SI,110
     Add DI,110
     Dec DX
     JNZ @@Lines
     Pop DS
   End;
End;

Procedure DrawMView;
Begin
   If MV=Nil then Exit;
   MV^.Draw(NP);
   MV^.DrawSub(NP);
End;

Procedure DrawWorkFrame;
  Const
    LineLen=7;
    XWW1=99;
    YWW1=14;
    XWW2=310;
    YWW2=175;
    WWDec=1;
    WWInc=2;
  Var
    I,X,Y:Word;
    J:Byte;
Begin
   ClearScreen(22);
   For I:=0 to 10000 do
     Begin
        X:=Random(320-LineLen);
        Y:=Random(200-LineLen);
        For J:=0 to LineLen do
          CurScr^[Y+J,X+J]:=20+((LineLen-J) Shr 1);
     End;
   For J:=0 to 6 do
     Begin
        For I:=YWW1-J to YWW2+J do
          Dec(CurScr^[I,XWW1-J],WWDec);
        For I:=YWW1-J to YWW2+J do
          Inc(CurScr^[I,XWW2+J],WWInc);
        For I:=XWW1-J to XWW2+J do
          Dec(CurScr^[YWW1-J,I],WWDec);
        For I:=XWW1-J to XWW2+J do
          Inc(CurScr^[YWW2+J,I],WWInc);
        PutPixel(J,J,25);
     End;
   Rectangle(8,8,89,89,28);
   Rectangle(7,7,90,90,26);
End;

Function MouseIn(X1,Y1,X2,Y2:Integer):Boolean;
Begin
   MouseIn:=
     (MouseX>=X1)And
     (MouseX<=X2)And
     (MouseY>=Y1)And
     (MouseY<=Y2);
End;

Procedure DrawMouse;
Begin
   If CurMouse=Nil then Exit;
   CurMouse^.PutNatCenter(
     MouseX,
     MouseY,
     MouseNat);
End;

Procedure InitMCGAMouse;
Begin
   MouseNat:=1;
   With SpriteManager.Mouse^ do
     MouseLib.SetRange(XSize,(YSize Div 2),640-XSize,200-(YSize Div 2));
   SetCursor(320,100);
End;

Procedure GetMousePos;
Begin
   MouseX:=GetCursorX Div 2;
   MouseY:=GetCursorY;
   MouseLB:=LeftPressed;
   MouseRB:=RightPressed;
End;

Procedure InitMObjs;
Begin
   If MUnits=Nil then
     New(MUnits,Init(@MUnits,Nil,40,40,0));
   If MBuildings=Nil then
     New(MBuildings,Init(@MBuildings,Nil,40,40,0));
End;

Procedure DoneMObjs;
Begin
   If MUnits<>Nil then
     MUnits^.Free;
   If MBuildings<>Nil then
     MBuildings^.Free;
End;

Procedure StepMObjs;
Begin
   If MUnits<>Nil then
     MUnits^.Step;
   If MBuildings<>Nil then
     MBuildings^.Step;
End;

Procedure DrawMObjs;
Begin
   If MBuildings<>Nil then
     MBuildings^.DrawSub(NP);
   If MUnits<>Nil then
     MUnits^.DrawSub(NP);
End;

Procedure InsertMUnit;
Begin
   InitMObjs;
   MUnits^.Insert(P);
End;

Procedure InsertMBuilding;
Begin
   InitMObjs;
   MBuildings^.Insert(P);
End;

End.
