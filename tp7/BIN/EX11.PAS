Uses CRT;
Var str:string;
    ch:char;
Function IsChInSt(ch:char;str:string):boolean;
         Begin
         If Pos(ch,str)>0 then IsChInSt:=True
                          else IsChInSt:=False;
         End;

Begin
ch:='s';
str:='   sadoo aom   ';
Randomize;
ClrScr;
WriteLn('IsChInSt(ch,str)=',IsChInSt(ch,str));
Writeln(ch);Writeln(str);
Readln;
End.