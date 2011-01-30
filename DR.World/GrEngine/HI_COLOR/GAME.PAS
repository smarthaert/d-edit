Uses CRT,GameUnit,Test;

Var I,J,Color:Word;
    BeginTime,EndTime:Word;
    Counter:Word;
Begin
  ScreenBuffer.Init;
  BeginTime:=GetAbsoluteTime;
  Counter:=0;
  Repeat
    For I:=0 to 639 do
      For J:=0 to 479 do
	ScreenBuffer.Data[J]^[I]:=Counter;
    ScreenBuffer.Draw;
    Inc(Counter);
  Until (KeyPressed) or (Counter=10);
  EndTime:=GetAbsoluteTime;
  ReadKey;
  ScreenBuffer.Done;
  Writeln(EndTime-BeginTime);
End.