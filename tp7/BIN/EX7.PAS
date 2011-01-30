Uses CRT;
Var ch:char;
    str:string;
Function DelChInSt(ch:char;str:string):string;
         Var buf:string;
         Begin
         buf:=str;
         While Pos(ch,buf)>0 do
                             Begin
                             Delete(buf,Pos(ch,buf),1);
                             End;
         DelChInSt:=buf;
         End;

Begin
ch:='a';
str:='   sadam   ';
Randomize;
ClrScr;
WriteLn('DelChInSt(ch,str)=',DelChInSt(ch,str));
Writeln(str);
Readln;
End.