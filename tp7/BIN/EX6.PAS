Uses CRT;
Var ch:char;
    str:string;
Function HowManyChInSt(ch:char;str:string):byte;
         Var i:byte;
         Begin
         i:=0;
         While Pos(ch,str) > 0 do
                               Begin
                               str[Pos(ch,str)]:=Chr(ord(ch)-1);inc(i);
                               End;
         HowManyChInSt:=i;
         End;

Begin
ch:='a';
str:='   sadam   ';
Randomize;
ClrScr;
WriteLn('HowMayChInSt(ch,str)=',HowManyChInSt(ch,str));
Writeln(str);
Readln;
End.