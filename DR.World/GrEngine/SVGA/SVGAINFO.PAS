Uses SVGA;

Const HexChars: Array [0..$F] of Char = '0123456789ABCDEF';

Function HexWord( W:Word ):String;
  Begin
    HexWord:=HexChars[Hi(W) shr 4] +
             HexChars[Hi(W) and $F] +
             HexChars[Lo(W) shr 4] +
             HexChars[Lo(W) and $F];
  End;

Var SVGA_Rec:PSVGA_InfoRec; Mode:Word; T:Text;
Begin
  New(SVGA_Rec);
  Assign(T,'SVGAINFO.TXT');
  Rewrite(T);
  For Mode:=$0000 to $FFFF do
    Begin
      If Get_SVGA_Info(Mode,SVGA_Rec) = 0 then
        With SVGA_Rec^ do
          Begin
            Writeln(T,'÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷');
            Writeln(T,' Video Mode ',HexWord(Mode),'h');
            Write(T,' Resolution : ',HorizRes,' * ',VertRes,' ');
            If (ModeAttrs And $10)<>0 then
              Writeln(T,'( Graphics Mode )')
            Else
              Writeln(T,'( Text Mode )');
            Writeln(T,' Video Scan Line Size : ',ScanLineSiz);
            Writeln(T,' Char : ',CharWide,' * ',CharHigh);
            Writeln(T,' Planes : ',PlaneCnt);
            Writeln(T,' Window Granularity : ',WinGran);
            Writeln(T,' Window Size : ',WinSize);
            Writeln(T,' Window A Segment : ',HexWord(WinASeg),'h');
            Writeln(T,' Window B Segment : ',HexWord(WinBSeg),'h');
            Writeln(T,' BitsPerPixel : ',BitsPerPel);
            Writeln(T,' Banks Num : ',BankCnt);
            Writeln(T,' Bank Size : ',BankSize);
            Write(T,' Mem Model : ');
            Case MemModel of
              $00 : Writeln(T,'Text mode');
              $01 : Writeln(T,'CGA graphics');
              $02 : Writeln(T,'Hercules graphics');
              $03 : Writeln(T,'4-plane planar');
              $04 : Writeln(T,'Packed pixel');
              $05 : Writeln(T,'Non-chain 4, 256 color');
              $06..$0F : Writeln(T,'Reserved, to be defined by VESA');
              $10..$FF : Writeln(T,'To be defined by OEM');
            End;
            Writeln(T);
          End;
    End;
  Close(T);
  Dispose(SVGA_Rec);
End.
