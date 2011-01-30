Uses CRT;
Var str:string;
Function MaxChInSt(str:string):char;
         Var ch:char;i:byte;
         Begin
         ch:=chr(0);
         For i:=1 To Length(str) do If str[i]>ch then ch:=str[i];
         MaxChInSt:=ch;
         End;

Begin
str:='   sadoo aom   ';
Randomize;
ClrScr;
WriteLn('MaxChInSt(str)=',MaxChInSt(str));
Writeln(str);
Readln;
End.