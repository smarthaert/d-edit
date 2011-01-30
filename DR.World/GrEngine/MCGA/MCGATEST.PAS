Uses CRT,DOS;

{$I MCGA.PAS}

Function AbsoluteTime:LongInt;
  Var Hour,Minute,Second,Sec100:Word;
  Begin
    GetTime( Hour,Minute,Second,Sec100 );
    AbsoluteTime:=((Hour*60+Minute)*60+Second*100)+Sec100;
  End;

Var BeginTime,EndTime,T,I:LongInt;
Begin
  Init_MCGA;
  New(SB);
  BeginTime:=AbsoluteTime;
  Asm Cli End;
  For I:=1 to 100 do
    Asm
      Mov AX,SegA000
      Mov ES,AX
      Xor DI,DI
      Mov CX,32000
      Mov AX,0F0Fh
      Rep Stosw
    End;
  Asm Sti End;
  EndTime:=AbsoluteTime;
  Close_MCGA;
  Dispose(SB);
  T:=EndTime-BeginTime;
  Writeln(T);
  Writeln((10000/T):0:2);
  ReadKey;
End.