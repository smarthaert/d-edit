{$APPTYPE CONSOLE}
Uses SysUtils;
Var a,b : Longint;

Begin
  AssignFile(Input,'a.in');
  AssignFile(Output,'a.Out');
  Reset(Input);
  Rewrite(Output);
  Read(a,b);
  Write(A+b);
  CloseFile(Input);
  CloseFile(Output);
End.
1
Borland Delphi 6.0
.dpr