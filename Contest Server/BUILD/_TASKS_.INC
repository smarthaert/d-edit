{$I BORDER.INC}   { เฎๆฅคใเ  DrawBorder }
{$I MESSAGES.INC} { ๋ขฎค แฎฎก้ฅญจฉ ญ  ํชเ ญ }
{$I CONSOLE.INC}  { ฎญแฎซ์ญ๋ฉ ขขฎค }
{$I INFOTASK.INC} { ญไฎเฌ ๆจ๏ ฎ แจแโฅฌฅ }

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
