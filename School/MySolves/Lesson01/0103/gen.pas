Var NN,I,Q,P,N:Word;
Begin
  Assign(Input,'in.txt'); Reset(input);
  Assign(output,'out.txt'); ReWRITE(output);
  Readln(nn);
  For I:=1 to NN do
    Begin
      Read(p); Read(n);
      q := (p - 1) div n +1;
      Writeln(q);
    End;
  Close(input); Close(output);
End.