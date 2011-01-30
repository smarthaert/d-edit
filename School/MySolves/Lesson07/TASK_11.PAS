Uses Graph;
Var
  a,b,Driver,Mode:Integer; {a,b - длины сторон}

Procedure Divide(x1,y1,x2,y2:Integer);
{x1,y1 и x2,y2 - координаты левого верхнего и правого нижнего углов прямоугольника}
Begin
  Rectangle(x1,y1,x2,y2);
  If x2-x1=y2-y1 Then Exit; {Выход из процедуры, если получили квадрат}
  If x2-x1>y2-y1 Then x1:=x1+(y2-y1) Else y1:=y1+(x2-x1);
  Divide(x1,y1,x2,y2);
End;

Begin
  Write('Введите длины сторон через пробел (например, 250 180): '); ReadLn(a,b);
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\Bp\Bgi');
  Divide(1,1,a,b);
  ReadLn;
End.
