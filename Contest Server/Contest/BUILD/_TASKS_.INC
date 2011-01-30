{$I MESSAGES.INC}
{$I CONSOLE.INC}
{$I INFOTASK.INC}

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ         …   ‘ ’  € –     ’        €  € —         ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Function TaskType( TaskName:String ):PTask;
   Begin
     If TaskName = 'CONSOLEINPUT' then TaskType:=New(PConsoleInput,Create) Else
     If TaskName = 'MESSAGES' then TaskType:=New(PMessageTask,Create) Else
     If TaskName = 'INFO' then TaskType:=New(PInfoTask,Create) Else
     TaskType:=nil;
   End;
