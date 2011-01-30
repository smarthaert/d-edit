Uses Graph;
Const
  Radian=Pi/180;
  DeltaAngle=30*Radian; {Добавка к углу}
Var
  Driver,Mode:Integer;

Procedure Ris(x,y:Integer; Len,Angle:real);
Var
  Color,xNew,yNew:Integer;
Begin
  If Len<1 Then Exit; {Выход из рекурсии при длине ветки меньше 1 пиксела}
  If Len<15 Then Color:=14 Else Color:=15; {Листья - желтым цветом, ствол - белым}
  xNew:=x+Round(Len*Cos(Angle)); {Координаты конца ветки}
  yNew:=y+Round(Len*Sin(Angle));
  SetColor(Color); Line(x,y,xNew,yNew);     {Рисуем ветку}
  Ris(xNew,yNew,Len*0.65,Angle-DeltaAngle); {Рисуем левую подветку}
  Ris(xNew,yNew,Len*0.65,Angle+DeltaAngle); {Рисуем правую подветку}
End;

Begin
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\bp\bgi'); {Устанавливаем графический режим}
  Ris(100,400,160,-40*Radian);        {Рекурсивное рисование ветки}
  ReadLn;
  CloseGraph;
End.