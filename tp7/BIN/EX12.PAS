Uses CRT;
Const MaxArr=128;
Type str128 = array [1..MaxArr] of string;
Var StrArr:str128;
    ch:char;
Function IsChInStAr(ch:char;var StrArr:str128):boolean; {Var!!!! dJI9I He nepenoJIHeHu9I CTeKa}
         Var i:byte;
         Begin
         IsChInStAr:=False;
         For i:=1 To MaxArr Do
         If Pos(ch,StrArr[i])>0 then Begin IsChInStAr:=True;Break;End;
         End;

Begin
ch:='w';
StrArr[1]:='   sadoo aom   ';
StrArr[128]:='  sasasmdasofjas   ';
Randomize;
ClrScr;
WriteLn('IsChInStAr(ch,StrArr)=',IsChInStAr(ch,StrArr));
Writeln(ch);
Writeln(StrArr[1]);
Writeln(StrArr[128]);
Readln;
End.