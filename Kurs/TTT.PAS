Uses CRT;

Const
  SendBlockSize=5;

Type
  TSenderCommand=(NoCom,SendCom,RcvCom);
  TSender=
    Object
      SendByte:Byte;
      RcvByte:Byte;
      Command:TSenderCommand;
      HiCom:TSenderCommand;
      SendStr:String;
      RcvStr:String;
      Sended:Byte;
      Procedure ComSend(Str:String);
      Procedure ComRcv;
      Procedure ComClear;
      Procedure Init;
      Procedure Step;
      Procedure NoComStep;
      Procedure SendComStep;
      Procedure RcvComStep;
    End;

Procedure TSender.Init;
Begin
   SendByte:=0;
   RcvByte:=0;
   Command:=NoCom;
   HiCom:=NoCom;
   RcvStr:='';
   SendStr:='';
   Sended:=0;
End;

Procedure TSender.NoComStep;
Begin
   SendByte:=0;
   If RcvByte>=32 then ComRcv;
End;

Procedure TSender.RcvComStep;
Begin
   If RcvByte>=32 then
     Begin
        RcvStr:=RcvStr+Chr(RcvByte);
        Inc(Sended);
        If Sended=SendBlockSize then
          Begin
             If HiCom=RcvCom then
               SendStr:=Copy(RcvStr,Length(RcvStr)-Sended,Sended);
             ComSend(SendStr);
          End;
     End
     Else
     If RcvByte=0 then ComClear;
End;

Procedure TSender.SendComStep;
Begin
   If SendStr='' then
     ComClear;
   SendByte:=Ord(SendStr[1]);
   SendStr:=Copy(SendStr,2,Length(SendStr)-1);
   Inc(Sended);
   If Sended=SendBlockSize then
     ComRcv;
End;

Procedure TSender.Step;
Begin
   Case Command of
     NoCom:NoComStep;
     SendCom:SendComStep;
     RcvCom:RcvComStep;
     Else
       ComClear;
   End;
End;

Procedure TSender.ComSend;
Begin
   If Str='' then
     Begin
     End;
   SendStr:=Str;
   Command:=SendCom;
   Sended:=0;
   If HiCom=NoCom then
     Begin
        HiCom:=SendCom;
        SendStr:=#$FF+SendStr
     End;
End;

Procedure TSender.ComClear;
Begin
   If HiCom=Command then
     HiCom:=NoCom;
   Case HiCom of
     SendCom:ComSend(SendStr);
     RcvCom:ComRcv;
   End;
   Command:=NoCom;
End;

Procedure TSender.ComRcv;
Begin
   RcvStr:='';
   Command:=RcvCom;
   Sended:=0;
   If HiCom=NoCom then HiCom:=RcvCom;
End;

Var
  UpSender,DownSender:TSender;
  MixByte:Byte;

Procedure StepAll;
  Function Isk(B:Byte):Byte;
    Var
      _And,_Or,N,I:Byte;
  Begin
     _And:=$FF;
     _Or:=0;
     For I:=1 to 6 do
       Begin
          N:=Random(256);
          _And:=_And And N;
          _Or:=_Or Or N;
       End;
     Isk:=(B Or _And)And _Or;
  End;
Begin
   UpSender.RcvByte:=MixByte;
   DownSender.RcvByte:=MixByte;
   MixByte:=Isk(UpSender.SendByte Or DownSender.SendByte);
   UpSender.Step;
   DownSender.Step;
End;

Procedure ShowData;
  Var
    S:String;
    I:Byte;
Begin
   GotoXY(71,10);
   Str(MixByte,S);
   While Length(S)<3 do S:='_'+S;
   Write(S);
   GotoXY(3,8);
   Str(UpSender.RcvByte,S);
   While Length(S)<3 do S:='_'+S;
   Write('R:'+S);
   GotoXY(3,4);
   Str(UpSender.SendByte,S);
   While Length(S)<3 do S:='_'+S;
   Write('S:'+S);
   GotoXY(3,12);
   Str(DownSender.RcvByte,S);
   While Length(S)<3 do S:='_'+S;
   Write('R:'+S);
   GotoXY(3,16);
   Str(DownSender.SendByte,S);
   While Length(S)<3 do S:='_'+S;
   Write('S:'+S);
   GotoXY(13,16);
   With DownSender do
     Case Command of
       RcvCom:Write(RcvStr);
       SendCom:Write(SendStr);
     End;
   S:='';
   For I:=WhereX to 60 do
     S:=S+' ';
   Write(S);
   GotoXY(13,4);
   With UpSender do
     Case Command of
       RcvCom,NoCom:Write(RcvStr);
       SendCom:Write(SendStr);
     End;
   S:='';
   For I:=WhereX to 60 do
     S:=S+' ';
   Write(S);
End;

Procedure ShowBase;
  Var
    I:Byte;
Begin
   GotoXY(10,8);
   For I:=1 to 60 do
     Write('-');
   Write('+'#8#10'|'#8#10'|'#8#10'|'#8#10'+');
   GotoXY(10,12);
   For I:=1 to 60 do
     Write('-');
   GotoXY(9,12);
   Write('+'#8#10'|'#8#10'|'#8#10'|'#8#10'+-<:');
   GotoXY(9,4);
   Write('+-<:'#8#8#8#8#10'|'#8#10'|'#8#10'|'#8#10'+');
End;

Var
  Key:Char;

Begin
   Randomize;
   ClrScr;
   ShowBase;
   UpSender.Init;
   DownSender.Init;
   MixByte:=0;
   Repeat
     ShowData;
     Key:=ReadKey;
     Case Key of
       's','S':UpSender.ComSend('Test string');
       ' ':StepAll;
     End;
   Until Key=#27;
End.