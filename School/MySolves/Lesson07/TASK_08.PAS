Uses Graph;

Const
  Step=Pi*0.2;
Var
  Driver,Mode:Integer;

Procedure DrawStar(x,y,Size:Integer); {x,y - координаты центра и Size - радиус снежинки}
Var
  i,j,NewSize,xNew,yNew:Integer;
Begin
  If Size<1 Then PutPixel(x,y,15) Else
    For i:=0 To 9 Do {Первый цикл - по количеству направляющих снежинки}
    Begin
      NewSize:=Size;
      For j:=1 To 8 Do {Второй цикл - рисование 8-ми подуровней снежинки}
      Begin
        xNew:=x+Round(NewSize*Cos(i*Step));
        yNew:=y+Round(NewSize*Sin(i*Step));
        DrawStar(xNew,yNew,NewSize Div 5);
        NewSize:=NewSize*2 Div 3;
      End;
    End;
End;

Begin
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\Bp\Bgi');
  DrawStar(320,240,160);
  ReadLn;
End.