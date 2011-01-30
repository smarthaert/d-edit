Uses CRT;
Const max=2;
Type ny = record
     n:string;
     y:integer;
     end;
Var Rec:Array [1..max] of ny;
    i,x,y:byte;

Procedure WriteToNY(var r:ny;i:byte);
         Begin
         Writeln('BBeguTe (I)aMuJIuIO ',i,' CTygeHTa');
         Readln(r.n);
         Writeln('BBeguTe rog Po}I{geHu9I ',i,' CTygeHTa');
         Readln(r.y);
         End;

Procedure ReadFromNY(r:ny;x:byte;y:byte;i:byte);
          Begin
          GoToXY(x,y);
          For i:=1 To max Do Begin
                             GoToXY(x,WhereY);
                             Writeln('#',i,' (I)aMuJIu9I=',Rec[i].n,' rog=',Rec[i].y);
                             End;
          End;
Begin
Randomize;ClrScr;
For i:=1 To max Do WriteToNY(Rec[i],i);
Write('BBeguTE X=');Readln(x);
Write('BBeguTE Y=');Readln(y);
ReadFromNY(Rec[1],x,y,i);
Readln;
End.