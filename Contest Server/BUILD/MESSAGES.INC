{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                       C     …                           ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ‘ฎฎก้ฅญจฅ ===--- }
 Type
   PMessage = ^TMessage;
   TMessage = Record
     Mesg : String[78];
     Next : PMessage;
   End;

{ ---=== ใไฅเ แฎฎก้ฅญจฉ ===--- }
 Const MessageList : PMessage = nil;

{ ---=== ฎขฎฅ แฎฎก้ฅญจฅ ===--- }
 Procedure Message( _Message_:String );
   Var Last,Mesg:PMessage;
   Begin
     New(Mesg);
     Mesg^.Mesg:=_Message_;
     Mesg^.Next:=nil;
     If MessageList<>nil then
       Begin
         Last:=MessageList;
         While Last^.Next<>nil do Last:=Last^.Next;
         Last^.Next:=Mesg;
       End
     Else
       MessageList:=Mesg;
   End;

{ ---=== งขซฅ็์ แฎฎก้ฅญจฅ ===--- }
 Function GetMessage:String;
   Var Mesg:PMessage;
   Begin
     GetMessage:=MessageList^.Mesg;
     Mesg:=MessageList^.Next;
     Dispose(MessageList);
     MessageList:=Mesg;
   End;

{ ---=== กเ กฎโช  แฎฎก้ฅญจฉ ===--- }
 Type
   PMessageTask = ^TMessageTask;
   TMessageTask = Object(TTask)
     OutX,OutY : Byte;
     Procedure Init; Virtual;
     Procedure Run; Virtual;
     Destructor Done; Virtual;
   End;

 Procedure TMessageTask.Init;
   Begin
     ClrScr;
     DrawBorder(1,1,80,21,5);
     TextColor(15); GotoXY(35,1); Write(' Messages ');
     Message(' ษออออออออออออออออออออออออออออออออออออออออออออป');
     Message(' บ        ---=== System started ===---        บ');
     Message(' ศออออออออออออออออออออออออออออออออออออออออออออผ');
     Message('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
     Message('');
   End;

 Procedure TMessageTask.Run;
   Var X,Y:Byte; S:String;
   Begin
     If MessageList = nil then Exit;
     X:=WhereX; Y:=WhereY;
     TextColor(3);
     Window(2,2,79,20);
     GotoXY(OutX,OutY);
     While MessageList<>nil do
       Begin
         S:=GetMessage;
         Writeln(S);
       End;
     OutX:=WhereX;
     OutY:=WhereY;
     Window(1,1,80,25);
     GotoXY(X,Y);
   End;

 Destructor TMessageTask.Done;
   Begin
     Run;
     TextColor(7);
     ClrScr;
   End;
