Begin
  Assign(Output,'tab_gen.htm');
  Rewrite(Output);
  Writeln('<HTML>');
  Writeln('<HEAD>');
  Writeln('<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251">');
  Writeln('<TITLE>'+'Table Generator 1.0'+'</TITLE>');
  Writeln('</HEAD>');
  Writeln('<BODY>');

  Writeln('</BODY>');
  Writeln('</HTML>');
  Close(Output);
End.