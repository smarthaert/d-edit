Var S:String; Cnt,I,J:Integer;
Begin
  Assign(output,'out.txt'); Rewrite(output);
  Cnt:=0;
  For I:=0 to 100 do
    Begin
      Str(I,S);
      For J:=1 to Length(S) do
        Begin
          Writeln(S[J],' - ',Cnt);
          Inc(Cnt);
        End;
    End;
  Close(output);
End.
