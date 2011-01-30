Uses CRT;
Const MaxArr=128;
Type str128 = array [1..MaxArr] of string;
     LetNumb = array ['a'..'z'] of byte;
Var StrArr:str128;
    Arr:LetNumb;
Procedure LetNumInStAr(var StrArr:str128;var Arr:LetNumb); {Var!!!! gJI9I He nepenoJIHeHu9I CTeKa}
          Var i,j:byte;
          Begin
          For i:=1 To MaxArr do
          For j:=1 To Length(StrArr[i]) do

                                        Case StrArr[i,j] of
                                             'a'..'z':inc(Arr[StrArr[i,j]]);
                                        End;

          End;

Begin
StrArr[15]:='ja   sadoo aom';
StrArr[128]:='  sasasmdasof  ';
Randomize;
ClrScr;
WriteLn('LetNumInStAr(StrArr)=');
LetNumInStAr(StrArr,Arr);
Writeln(StrArr[15]);
Writeln(StrArr[128]);
Writeln('d=',Arr['d']);
Readln;
End.