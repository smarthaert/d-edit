unit MapPreview;

interface

Uses Graphics,SysUtils,Types,Windows;

Const
  ESize=2;
  MapPreviewWidth=ESize*20;
  MapPreviewHeight=ESize*15;
  MapImageSize=MapPreviewWidth+4;
  MapHImageText=60;
  MapHImageWidth=MapPreviewWidth+MapHImageText+4;
  MapHImageHeight=MapPreviewHeight+4;

Function LoadPreview(Canvas:TCanvas;X,Y:Integer;FN:String):Boolean;
Function LoadMapImage(Canvas:TCanvas;X,Y:Integer;FN:String;MN:String=''):Boolean;
Function FNtoPreviewName(S:String):String;
Function LoadHMapImage(Canvas:TCanvas;X,Y:Integer;FN:String;MN:String=''):Boolean;

implementation

Function LoadPreview(Canvas:TCanvas;X,Y:Integer;FN:String):Boolean;
Var
  F:TextFile;
  S:String;
  R,C,RCount,CCount:Integer;
  Clr:TColor;
Begin
  Result:=False;
  {With Canvas do
    Begin
      FillRect(Rect(0,0,));
    End;}
  If FN='' then Exit;
  If Not FileExists(FN) then Exit;
  AssignFile(F,FN);
  Reset(F);
  ReadLn(F,CCount,RCount);
  With Canvas do
    For R:=1 to RCount do
      Begin
        ReadLn(F,S);
        For C:=1 to CCount do
          Begin
            If Length(S)<C then Break;
            Case S[C] of
              '@':Clr:=clRed;
              '#':Clr:=RGB(128,48,128);
              '&':Clr:=clLime;
              '.':Clr:=clNavy;
              '^':Clr:=RGB(180,180,0);
              'A'..'Z','*':Clr:=clAqua;
              '1','2':Clr:=clBlue;
              '0','3'..'9':Clr:=clWhite;
              '/','\':Clr:=clYellow;
              Else
                Clr:=clGray;
            End;
            Brush.Color:=Clr;
            FillRect(Bounds(X+(C-1)*ESize,Y+(R-1)*ESize,ESize,ESize));
          End;
      End;
  CloseFile(F);
  Result:=True;
End;

Function LoadMapImage(Canvas:TCanvas;X,Y:Integer;FN,MN:String):Boolean;
Begin
  If MN='' then
    MN:=FNtoPreviewName(FN);
  With Canvas do
    Begin
      Pen.Color:=clWhite;
      Rectangle(Bounds(X,Y,MapImageSize,MapImageSize));
      Brush.Color:=clBlack;
      FillRect(Bounds(X+1,Y+1,MapImageSize-2,MapImageSize-2));
      Brush.Style:=bsClear;
      Font.Style:=[];
      Font.Color:=clYellow;
      Font.Size:=4;
      TextOut(X+(MapImageSize-TextWidth(MN)) Div 2,Y+MapImageSize-((MapImageSize-MapPreviewHeight) Div 2)-TextHeight(MN) Div 2,MN);
    End;
  Result:=LoadPreview(Canvas,X+2,Y+2,FN);
End;

Function LoadHMapImage(Canvas:TCanvas;X,Y:Integer;FN,MN:String):Boolean;
Begin
  If MN='' then
    MN:=FNtoPreviewName(FN);
  With Canvas do
    Begin
      Brush.Color:=clBlack;
      FillRect(Bounds(X,Y,MapHImageWidth,MapHImageHeight));
      Pen.Color:=clWhite;
      Rectangle(Bounds(X+MapHImageText,Y,MapPreviewWidth+4,MapPreviewHeight+4));
      Brush.Style:=bsClear;
      Font.Style:=[];
      Font.Color:=clYellow;
      Font.Size:=4;
      TextOut(X+(MapHImageText-TextWidth(MN)) Div 2,Y+(MapPreviewHeight-TextHeight(MN)) Div 2,MN);
    End;
  Result:=LoadPreview(Canvas,X+2+MapHImageText,Y+2,FN);
End;

Function FNtoPreviewName(S:String):String;
Begin
  Result:=ChangeFileExt(ExtractFileName(S),'');
End;

end.
