{ * �⨫�� ��� �ॢ�饭�� ⥪�� � Pascal'��᪨� �������ਨ * }
Var I,O:Text; S:String;
Begin
  If ParamCount = 2 then
    Begin
      Assign(I,ParamStr(1));
      Assign(O,ParamStr(2));
      Reset(I); Rewrite(O);
      Repeat
        Readln(I,S);
        If S<>'' then
          Writeln(O,'{ ',S,' }')
        Else
          Writeln(O);
      Until EOF(I);
      Close(I); Close(O);
    End
  Else
    Begin
      Writeln('COMMENT <In File> <Out File>');
    End;
End.Var I,O:Text; S:String;
Begin
  If ParamCount = 2 then
    Begin
      Assign(I,ParamStr(1));
      Assign(O,ParamStr(2));
      Reset(I); Rewrite(O);
      Repeat
        Readln(I,S);
        If S<>'' then
          Writeln(O,'{ ',S,' }')
        Else
          Writeln(O);
      Until EOF(I);
      Close(I); Close(O);
    End
  Else
    Begin
      Writeln('-= �⨫�� ��� �ॢ�饭�� ⥪�� � Pascal'��᪨� �������ਨ =-');
      Writeln('COMMENT <input_file> <output_file>');
    End;
End.