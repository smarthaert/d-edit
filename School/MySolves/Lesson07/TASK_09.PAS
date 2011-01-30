Uses Graph;

Var
  Driver,Mode:Integer;

Procedure Rect(x,y,w,h:Real; Vertical:Boolean);
{x,y - центр ветви, а w,h - ширина и высота ветви}
{Если Vertical=True, то ветвь - вертикальная, если False - то горизонтальная}
Var
  n:Real;
Begin
  Bar(Round(x-w),Round(y-h),Round(x+w),Round(y+h));
  If (w<0.15) Or (h<0.15) Then Exit;
  If Vertical Then
  Begin
    n:=h*0.7; {0.7 = Sqrt(0.49), т.е. длина ветви уменьшается почти в √2 раз}
    w:=w*0.66; {Толщина ветви уменьшается в 0.66 раз}
    Rect(x,y-h,n,w,False);
    Rect(x,y+h,n,w,False);
  End
  Else
  Begin
    n:=w*0.7;
    h:=h*0.66;
    Rect(x-w,y,h,n,True);
    Rect(x+w,y,h,n,True);
  End;
End;

Begin
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\Bp\Bgi');
  SetColor(15); SetFillStyle(1,15);
  Bar(314,50,326,240);
  Rect(320,240,120,5,False);
  ReadLn;
End.