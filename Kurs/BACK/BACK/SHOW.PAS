Uses RGBVideo,Graph,CRT;

{ - main - }
Var SrcSeq,Src2Seq : FileSequence;
    GD,GM : Integer;
    Image : TWorkImage;
Begin
  If ParamCount >= 1 then
    Begin
      InitGraph(GD,GM,'');
      SrcSeq.Init(ParamStr(1));
      If ParamCount >=2 then
        Src2Seq.Init(ParamStr(2))
      Else
        Src2Seq.CurPos := MaxLongInt;
      While SrcSeq.CurExist do
        Begin
          Image.Load(SrcSeq.GetCur);
          Image.Show;
          Delay(40);
          If SrcSeq.CurPos = Src2Seq.CurPos then Break;
          Inc(SrcSeq.CurPos);
        End;
      ReadKey;
      CloseGraph;
    End
  Else
    Begin
      Writeln(' --=== SHOW 0.1 [Denis@ipo.spb.ru] (c) 2000 :) ===--');
      Writeln('Использование: SHOW <Sequence>');
      Writeln('Например: SHOW Film\A001.SCR');
    End;
End.