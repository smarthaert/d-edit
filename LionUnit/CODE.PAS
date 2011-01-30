{ * Простой XOR-кодировщик по паролю * }
Var _Code_:Byte; Password:String;

Procedure InitCode;
  Var I:Byte;
  Begin
    _Code_:=0;
    For I:=1 to Length(Password) do
      _Code_:=(_Code_+Ord(Password[I])) mod 256;
  End;

Procedure RunCode( SymNum:LongInt );
  Begin
    _Code_:=(_Code_ +
       Ord(Password[((SymNum-1) mod Length(Password))+1])) mod 256;
  End;

Procedure Code( InputFile,OutputFile:String );
  Var FI,FO:File of Byte; C:Byte; L:LongInt;
  Begin
    Assign(FI,InputFile);
    Assign(FO,OutputFile);
    Reset(FI);
    Rewrite(FO);
    InitCode;
    L:=0;
    Repeat
      Inc(L);
      RunCode(L);
      Read(FI,C);
      C:=C Xor _Code_;
      Write(FO,C);
    Until EOF(FI);
    Close(FI);
    Close(FO);
  End;

Begin
  Writeln('-= Простой XOR-кодировщик по паролю =-');
  If ParamCount = 3 then
    Begin
      Password := ParamStr(3);
      Code(ParamStr(1),ParamStr(2));
    End
  Else
    Writeln('CODE <input_file> <output_file> <Password>');
End.