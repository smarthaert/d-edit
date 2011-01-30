Uses CRT,Graph,RGBVideo,StrUtils;

Var Image : TWorkImage;

Procedure Circle( X,Y,Rad:Word; _R,_G,_B:Byte );
  Var Steps:Word; F:Real; I:Word;
  Begin
    Steps := Rad*8; { Периметр описанного квадрата }
    F := (2*PI)/Steps;
    For I:=1 to Steps do
      With Image.Image[Y+Round(Sin(F*I)*Rad)]^[X+Round(Cos(F*I)*Rad)] do
        Begin R:=_R; G:=_G; B:=_B; End;
  End;

{ --=== Циклическая очередь точек ===-- }
Const SeqLen = 10000;
Var Sequence : Array [0..SeqLen-1] of Record X,Y:Word; End;
Const SeqFirst:Word=1; SeqEnd:Word=0; SeqCurLen:Word=0;
Function SeqNext(I:Word):Word; Begin SeqNext:=(I+1) mod SeqLen; End;
Function SeqPrev(I:Word):Word; Begin SeqPrev:=(I+SeqLen-1) mod SeqLen; End;

Procedure SeqAdd( X,Y:Word );
  Begin
    SeqEnd := SeqNext(SeqEnd);
    Sequence[SeqEnd].X:=X;
    Sequence[SeqEnd].Y:=Y;
    Inc(SeqCurLen);
    Image.Image[Y]^[X].A:=1;
  End;

Procedure SeqDel;
  Begin
    Image.Image[Sequence[SeqFirst].Y]^[Sequence[SeqFirst].X].A:=2;
    SeqFirst := SeqNext(SeqFirst);
    Dec(SeqCurLen);
  End;

Procedure Fill( _X,_Y:Word; _R,_G,_B:Byte );
  Var CR,CB,CG:Byte; X,Y,I:Word;
  Begin
   { Заносим первую точку }
    X:=_X; Y:=_Y;
    SeqAdd(X,Y);
    With Image.Image[Y]^[X] do
      Begin CR:=R; CG:=G; CB:=B; End; { Точка помещена в очередь ! }
   { Цикл заливки }
    Repeat
      X:=Sequence[SeqFirst].X;
      Y:=Sequence[SeqFirst].Y;
      With Image.Image[Y]^[X] do
        If ((R=CR) And (G=CG) And (B=CB)) then
          Begin
            If Y > 1 then     If Image.Image[Y-1]^[X].A > 2 then SeqAdd(X,Y-1);
            If Y < YSize then If Image.Image[Y+1]^[X].A > 2 then SeqAdd(X,Y+1);
            If X > 1 then     If Image.Image[Y]^[X-1].A > 2 then SeqAdd(X-1,Y);
            If X < XSize then If Image.Image[Y]^[X+1].A > 2 then SeqAdd(X+1,Y);
            R:=_R; G:=_G; B:=_B;
          End;
      SeqDel;
    Until SeqCurLen = 0;
  End;

{ - Основная программа - }
Const FramesNum = 25;
Var GD,GM,I:Integer;
Begin
  InitGraph(GD,GM,'');
  Image.Init;
  For I:=1 to FramesNum do
    Begin
      Image.Clear;
      Circle(50+I,50+I,20,2,2,2);
      Fill(50+I,50+I,3,3,3);
      Image.Show;
      Image.Save('Film\A'+AddNumStr(I,'0',3)+'.SCR');
    End;
  Image.Done;
  CloseGraph;
  Writeln('FramesNum: ',FramesNum);
End.