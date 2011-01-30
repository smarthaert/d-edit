Unit RGBVideo;

Interface

 Const
   {XSize = 768; YSize = 576;}
   XSize = 100; YSize = 100;

{ - RGB Pixel - }
 Type
   RGBA = Record
     R,G,B,A : Byte; { Red Green Blue + Alpha channel }
   End;

{ - RGB String - }
   TRGBA_Str = Array [1..XSize] of RGBA;
   PRGBA_Str = ^TRGBA_Str;

{ - RGB Image - }
   TRGBA_Image = Array [1..YSize] of PRGBA_Str;

{ -= Work Image =- }
 Type
   TWorkImage = Object
     Image : TRGBA_Image;
     Constructor Init; { Отводим память }
     Destructor Done; { Отчищаем память }
     Procedure Clear; { Clear it }
     Procedure Save( FileName:String ); { Save }
     Procedure Load( FileName:String ); { Load }
     Procedure Show; { for 640x480x16c }
   End;

{ - File Sequence - }
 Type
   FileSequence = Object
     Prefix  : String;
     Postfix : String;
     LeadSym : Byte;
     CurPos  : LongInt;
     Constructor Init( StartFileName:String );
     Function GetCur:String;
     Function CurExist:Boolean;
   End;

Implementation

 Uses Graph,RunError,StrUtils;

 Constructor FileSequence.Init( StartFileName:String );
   Var I,J:Byte; Error:Integer;
   Begin
     I:=Pos('.',StartFileName);
     If I < 2 then RuntimeError('Wrong sequence name!');
     Postfix := Copy(StartFileName,I+1,Length(StartFileName)-I);
     J:=Pos('0',StartFileName);
     If I < 2 then RuntimeError('Wrong sequence name!');
     LeadSym := I-J;
     Prefix := Copy(StartFileName,1,J-1);
     Val(Copy(StartFileName,J,LeadSym),CurPos,Error);
     If Error<>0 then RuntimeError('Wrong sequence name!');
   End;

 Function FileSequence.GetCur:String;
   Begin
     GetCur := Prefix+AddNumStr(CurPos,'0',LeadSym)+'.'+Postfix;
   End;

 Function FileSequence.CurExist:Boolean;
   Var F:File;
   Begin
     Assign(F,GetCur);
    {$I-}
     Reset(F);
     CurExist := (IOResult = 0);
     Close(F);
    {$I+}
   End;

 Constructor TWorkImage.Init;
   Var I:Word;
   Begin
     For I:=1 to YSize do New(Image[I]);
   End;

 Destructor TWorkImage.Done;
   Var I:Word;
   Begin
     For I:=1 to YSize do Dispose(Image[I]);
   End;

 Procedure TWorkImage.Clear;
   Var I,J:Word;
   Begin
     For I:=1 to YSize do
       For J:=1 to XSize do
         With Image[I]^[J] do
           Begin
             R:=1; G:=1; B:=1; A:=100;
           End;
   End;

 Procedure TWorkImage.Save( FileName:String );
   Var I,J:Word; F:File of TRGBA_Str;
   Begin
     Assign(F,FileName);
     Rewrite(F);
     For I:=1 to YSize do
       Write(F,Image[I]^);
     Close(F);
   End;

 Procedure TWorkImage.Load( FileName:String );
   Var I,J:Word; F:File of TRGBA_Str;
   Begin
     Assign(F,FileName);
     Reset(F);
     For I:=1 to YSize do
       Read(F,Image[I]^);
     Close(F);
   End;

 Procedure TWorkImage.Show;
   Var X,Y:Word;
   Begin
     For Y:=1 to YSize do
       For X:=1 to XSize do
         PutPixel(X,Y,Image[Y]^[X].R);
   End;

End.