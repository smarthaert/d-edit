Var q,n,p : Longint;
Begin
  Assign(input,'in.txt'); Reset(input);
  Assign(output,'out.txt'); Rewrite(output);
  Read(p,n); { Во входном файле Номер квартиры, Количество квартир на этаже }
 { Из решения к занятию номер 1 }
  q:=(p-1) div n + 1;
  Writeln(q);
  Close(input); Close(output);
End.