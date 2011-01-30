Uses CRT;
Const iArr=10;
      jArr=10;
Type arr10x10 = array [1..iArr,1..jArr] of integer;
Var a:arr10x10;
i,j:byte;

Procedure GenArr2d(var inarr:arr10x10);
          Var i,j:byte;
          Begin
          For i:=1 To iArr Do
          For j:=1 To jArr Do Begin
                              inarr[i,j]:=Random(MaxInt);
                              End;
          End;

Procedure WriteArr2d(inarr:arr10x10);
          Var i,j:byte;
          Begin
          For i:=1 To iArr Do
          For j:=1 To jArr Do Begin
                              Write('a[',i:2,',',j:2,']=',inarr[i,j]:6,' ');
                              End;
          End;

Procedure TransArr2d (var inarr:arr10x10);
          Var i,j:byte;
          buf:integer;
          Begin
          For i:=2 To iArr Do
          For j:=i To jArr Do Begin
                            buf:=inarr[j,i];
                            inarr[j,i]:=inarr[i,j];
                            inarr[i,j]:=buf;
                            End;
          End;

Begin
Randomize;
ClrScr;                {O4ucTKa 3KPaHa}
GenArr2d(a);           {3anucb reHepupoBaHHbIx 4uceJI B MaccuB}
WriteArr2d(a);         {BbIBog MaccuBa Ha 3KPaH}
TransArr2d(a);         {3aMeHa CTPOK Ha CTOJI6u,bI}
Readln;                {Enter}
WriteArr2d(a);         {BbIBog MaccuBa Ha 3KPaH}
Readln;                {Enter}
End.