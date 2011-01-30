Uses CRT;
Var str:string;
Function HowManyWorInSt(str:string):byte;
         Var w:byte;
         Begin
         If str[1]=' ' then w:=0
                       else w:=1;
         While Pos(' ',str)>0 do
                              Begin
                              If (not (Pos(' ',str)=Length(str)))
                                 and
                                 (not (str[Pos(' ',str)+1]=' ')) then inc(w);
                              str[Pos(' ',str)]:='_';
                              End;
         HowManyWorInSt:=w;
         End;

Begin
str:='   sadoo aom   ';
Randomize;
ClrScr;
WriteLn('HowManyWorInSt(str)=',HowManyWorInSt(str));
Writeln(str);
Readln;
End.