{$I BORDER.INC}   { ��楤�� DrawBorder }
{$I MESSAGES.INC} { �뢮� ᮮ�饭�� �� ��࠭ }
{$I CONSOLE.INC}  { ���᮫�� ���� }
{$I INFOTASK.INC} { ���ଠ�� � ��⥬� }

{ ������������������������������������������������������������������ͻ }
{ � �        � � � � � � � � � � �   � � � � �   � � � � �         � � }
{ ������������������������������������������������������������������ͼ }

 Function TaskType( TaskName:String ):PTask;
   Begin
     If TaskName = 'CONSOLEINPUT' then TaskType:=New(PConsoleInput,Create) Else
     If TaskName = 'MESSAGES' then TaskType:=New(PMessageTask,Create) Else
     If TaskName = 'INFO' then TaskType:=New(PInfoTask,Create) Else
     TaskType:=nil;
   End;
