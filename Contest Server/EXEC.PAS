{ Запуск программы с опеределенными параметрами и контролем памяти }

{$M $4000,0,0}
Uses Dos;

Var ProgramName,CmdLine:String; I:Integer;
Begin
  If ParamCount = 0 then
    Begin
      Writeln('EXEC <Program Name> [<Command Line>]');
      Halt(1);
    End;
  ProgramName:=ParamStr(1);
  Writeln('Program to Exec (full path): ',ProgramName);
  CmdLine:='';
  For I:=2 to ParamCount do CmdLine:=CmdLine + ParamStr(I)+' ';
  Writeln('Command line to pass to ',ProgramName,': ',CmdLine);
  Writeln('Memory: ',MemAvail);
  Writeln('About to Exec...');
  SwapVectors;
  Exec(ProgramName,CmdLine);
  SwapVectors;
  Writeln('...back from Exec');
  Writeln('Memory: ',MemAvail);
  If DosError <> 0 then { Error? }
    Writeln('Dos error #', DosError)
  Else
    Writeln('Exec successful. ',
            'Child process exit code = ',
             DosExitCode);
End.





