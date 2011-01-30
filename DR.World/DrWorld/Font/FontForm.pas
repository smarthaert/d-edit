Var T:Text;
    C:Char;
Begin
  Assign(T,'_Font.ini');
  Rewrite(T);
  For C:=#32 to #128 do
    Begin
      Writeln(T,'; "',C,'"');
{      Writeln(T,'___');
      Writeln(T,'___');
      Writeln(T,'___');
      Writeln(T,'___');
      Writeln(T,'___');}
      Writeln(T,'_____');
      Writeln(T,'_____');
      Writeln(T,'_____');
      Writeln(T,'_____');
      Writeln(T,'_____');
{      Writeln(T,'_____');
      Writeln(T,'_____');}
    End;
  Close(T);
End.