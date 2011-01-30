Uses CRT;
Const MaxArr=128;
Type str128 = array [1..MaxArr] of string;
Var StrArr:str128;
    str:string;
Function IsWorInStAr(str:string;var StrArr:str128):boolean; {Var!!!! dJI9I He nepenoJIHeHu9I CTeKa}
         Var i:byte;buf,buf2:string;
         Begin
         buf:=' '+str+' ';
         IsWorInStAr:=False;
         For i:=1 To MaxArr Do
                            Begin
                            If (Pos(str,StrArr[i])=1)
                               or
                               (Pos(str,StrArr[i])=Length(StrArr[i])-Length(str))
                               then
                                                      Begin
                                                      IsWorInStAr:=True;
                                                      Break;
                                                      End;
                            buf2:=' '+StrArr[i]+' ';
                            If (Pos(buf,buf2)>0) then
                                                      Begin
                                                      IsWorInStAr:=True;
                                                      Break;
                                                      End;
                            End;
         End;

Begin
str:='jas';
StrArr[15]:='ja   sadoo aom';
StrArr[128]:='  sasasmdasof  ';
Randomize;
ClrScr;
WriteLn('IsWorInStAr(str,StrArr)=',IsWorInStAr(str,StrArr));
Writeln(str);
Writeln(StrArr[15]);
Writeln(StrArr[128]);
Readln;
End.