{$I MESSAGES.INC}
{$I CONSOLE.INC}
{$I INFOTASK.INC}

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �        � � � � � � � � � � �   � � � � �   � � � � �         � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

 Function TaskType( TaskName:String ):PTask;
   Begin
     If TaskName = 'CONSOLEINPUT' then TaskType:=New(PConsoleInput,Create) Else
     If TaskName = 'MESSAGES' then TaskType:=New(PMessageTask,Create) Else
     If TaskName = 'INFO' then TaskType:=New(PInfoTask,Create) Else
     TaskType:=nil;
   End;
