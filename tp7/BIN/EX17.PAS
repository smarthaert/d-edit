Uses CRT;
Var x:integer;

Function IntIn:integer;
         Var res,p:integer;
             buf:array [1..255] of byte;
             ch :char;
             i,k,l:byte;
         Begin
         i:=1;
         Repeat
               ch:=ReadKey;
               If not(Ord(ch)=13) then
               If ( (i=1) and (ch in ['1'..'9']) ) or ( not(i=1) and (ch in ['0'..'9']) )
               then Begin
                         Write(ch);
                         buf[i]:=Ord(ch)-48;
                         inc(i);
                    End;


         Until ((Ord(ch)=13) and not(i=1));
         res:=0;dec(i);
         For k:=i DownTo 1 do Begin
                              p:=1;
                              For l:=k+1 To i do p:=p*10;
                              res:=res+(buf[k]*p);
                              End;
         IntIn:=res;
         End;

Begin
Randomize;ClrScr;
x:=IntIn;
Writeln;
Writeln(x);
Readln;
End.