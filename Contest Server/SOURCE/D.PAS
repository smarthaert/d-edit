{  Задача D (Скобочная последовательность)  }
{ ========================================= }
Var T:Text; I,M,P,K:Word; S:String;
Begin
  Assign(T,'INPUT.TXT');
  Reset(T);
  Read(T,M);
  S:=' ';
  For I:=1 to M do S:=S+'  ';
  P:=1;
  For I:=1 to M do
    Begin
      Read(T,K);
      S[P]:='(';
      S[P+K+1]:=')';
      While S[P]<>' ' do Inc(P);
    End;
  Close(T);
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  Writeln(T,S);
  Close(T);
End.