Uses CRT;
Const MaxArr=128;
Type str128 = array [1..MaxArr] of string;
Var StrArr:str128;
    str:string;
Function HowManyWorInStAr(str:string;var StrArr:str128):byte; {Var!!!! gJI9I He nepenoJIHeHu9I CTeKa}
         Var h,i,j:byte;
             buf:string;
         Begin
         h:=0;
         For i:=1 To MaxArr do
                            Begin
                            buf:=StrArr[i];
                            While Pos(str,buf)>0
                                  do
                                  Begin
                                  inc(h);
                                  Delete(buf,Pos(str,buf),Length(str));
                                  End;
                            End;
         HowManyWorInStAr:=h
         End;

Begin
str:='was';
StrArr[15]:='   sadoo aom and bill  was  biggest ';
StrArr[128]:='  sasasmwasdwereasofjas   ';
Randomize;
ClrScr;
WriteLn('HowManyWorInStAr(str,StrArr)=',HowManyWorInStAr(str,StrArr));
Writeln(str);
Writeln(StrArr[15]);
Writeln(StrArr[128]);
Readln;
End.