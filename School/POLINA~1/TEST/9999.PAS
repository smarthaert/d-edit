Var S:String;
Begin
  Assign(Input,'IN.TXT');
  Assign(Output,'OUT.TXT');
  Reset(Input);
  Rewrite(Output);
  Readln(S);
  Writeln(S);
  Close(Input);
  Close(Output);
End.