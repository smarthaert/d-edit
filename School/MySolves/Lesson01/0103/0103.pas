Var q,n,p : Longint;
Begin
  Assign(input,'in.txt'); Reset(input);
  Assign(output,'out.txt'); Rewrite(output);
  Read(p,n); { �� �室��� 䠩�� ����� �������, ������⢮ ������ �� �⠦� }
 { �� �襭�� � ������ ����� 1 }
  q:=(p-1) div n + 1;
  Writeln(q);
  Close(input); Close(output);
End.