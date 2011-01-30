Uses RGBVideo,RunError;

Var FR,FG,FB:Byte; StartX,StartY,Error:Integer;
    Image : TWorkImage;

Procedure CutImage;
  Var X,Y:Integer;
  Begin
    For Y:=1 to YSize do
      For X:=1 to XSize do
        With Image.Image[Y]^[X] do
          If ((R<>FR) Or (G<>FG) Or (B<>FB)) then
            Begin
              R := 8;
              G := 8;
              B := 8;
            End;
  End;

{ - main - }
Var SrcSeq,DstSeq : FileSequence;
Begin
  Writeln(' --=== BACK 0.1 [Denis@ipo.spb.ru] (c) 2000 :) ===--');
  If ParamCount = 5 then
    Begin
      Image.Init;
      SrcSeq.Init(ParamStr(1));
      DstSeq.Init(ParamStr(2));
      Writeln('Source Sequence: "',SrcSeq.GetCur,'"');
      Writeln('Destination Sequence: "',DstSeq.GetCur,'"');
      Val(ParamStr(3),StartX,Error);
      If ((Error<>0) Or (StartX<1) Or (StartX>XSize)) then RuntimeError('Bad StartX !');
      Val(ParamStr(4),StartY,Error);
      If ((Error<>0) Or (StartY<1) Or (StartY>YSize)) then RuntimeError('Bad StartY !');
      Image.Load(SrcSeq.GetCur);
      FR := Image.Image[StartY]^[StartX].R;
      FG := Image.Image[StartY]^[StartX].G;
      FB := Image.Image[StartY]^[StartX].B;
      While SrcSeq.CurExist do
        Begin
          Write(#13,'"',SrcSeq.GetCur,'" => "',DstSeq.GetCur,'"');
          If SrcSeq.CurPos > 1 then Image.Load(SrcSeq.GetCur);
          CutImage;
          Image.Save(DstSeq.GetCur);
          Inc(SrcSeq.CurPos); Inc(DstSeq.CurPos);
        End;
      Image.Done;
    End
  Else
    Begin
      Writeln('BACK <Исходная последовательность> <Конечная последовательность>');
      Writeln('  <X координата точки внутри вырезаемого обьекта> <Y - координата>');
      Writeln('  <Величина квадратиков (в пикселях) на которые разбивается изображение>');
    End;
End.