Uses TPCRT,TPPick;

{ --- Функция, возвращающая по номеру запись --- }
Function F( N:Integer ):String; Far;
  Begin
    F:=Chr(Ord('0')+N);
  End;

Var Selected:Word; Palette:PickColorArray;
Begin
  Palette[WindowAttr] := $07;
  Palette[FrameAttr]  := $07;
  Palette[HeaderAttr] := $0F;
  Palette[SelectAttr] := $70;
  Palette[AltNormal]  := $0F;
  Palette[AltHigh]    := $0F;
  Repeat
    PickWindow(Addr(F),10,1,1,10,10,True,Palette,'Test',Selected);
    Writeln(Selected);
  Until ReadKey = #27;
End.