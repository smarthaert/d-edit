Uses CRT;
Const MaxArr=128;
Type str128 = array [1..MaxArr] of string;
Var StrArr:str128;
    str,str2:string;
Procedure ChangeWorInStAr(str:string;var StrArr:str128;str2:string); {Var!!!! gJI9I He nepenoJIHeHu9I CTeKa}
          Var i:byte;
          Begin
          For i:=1 To MaxArr do
          While Pos(str,StrArr[i])>0 do
                                     Begin
                                     Insert(str2,StrArr[i],Pos(str,StrArr[i]));
                                     Delete(StrArr[i],Pos(str,StrArr[i]),Length(str));
                                     End;
          End;

Begin
str:='was';
str2:='were';
StrArr[15]:='   sadoo aom and bill  was  biggest ';
StrArr[128]:='  sasasmwasdwereasofjas   ';
Randomize;
ClrScr;
ChangeWorInStAr(str,StrArr,str2);
WriteLn('ChangeWorInStAr(str,StrArr,str2)=');
Writeln(str);
Writeln(StrArr[15]);
Writeln(StrArr[128]);
Writeln(str2);
Readln;
End.