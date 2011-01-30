Uses CRT;
Var ch,ch2:char;
    str:string;
Function ChangeChInSt(ch:char;str:string;ch2:char):string;
         Var buf:string;
         Begin
         buf:=str;
         While Pos(ch,buf)>0 do
                             Begin
                             buf[Pos(ch,buf)]:=ch2;
                             End;
         ChangeChInSt:=buf;
         End;

Begin
ch:='a';
ch2:='o';
str:='   sadooaom   ';
Randomize;
ClrScr;
WriteLn('ChangeChInSt(ch,str,ch2)=',ChangeChInSt(ch,str,ch2));
Writeln(str);
Readln;
End.