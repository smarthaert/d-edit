Uses Graph;
Const
  Angle60=Pi/3; {Угол между "иголочками" снежинки}
Var
  Driver,Mode:Integer;

Procedure Sneg(x,y,l:Integer); {x,y - центр снежинки, l - длина "иголочки"}
Var
  i:Integer;
  xNew,yNew:Integer; {Новые координаты центра снежинки}
Begin
  If l>=1 Then {Условие выхода из рекурсии - длина меньше 1}
    For i:=0 To 5 Do {Рисование шести "иголочек"}
    Begin
      xNew:=x+Round(l*Cos(i*Angle60));
      yNew:=y+Round(l*Sin(i*Angle60));
      Line(x,y,xNew,yNew);
      Sneg(xNew,yNew,l Div 3); {Рекурсивный вызов с новыми параметрами}
    End;
End;

Begin
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\Bp\Bgi');
  Sneg(320,240,100); {Начальный вызов: (320,240) - центр экрана, 100 - начальная длина}
  ReadLn;
End.
