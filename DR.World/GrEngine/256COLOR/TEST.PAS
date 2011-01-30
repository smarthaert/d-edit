Unit Test;
Interface
  Function GetAbsoluteTime:LongInt;
Implementation
Uses Dos;
  Function GetAbsoluteTime:LongInt;
    Var Hour,Minute,Second,Sec100:Word;
    Begin
      GetTime( Hour,Minute,Second,Sec100 );
      GetAbsoluteTime:=((Hour*60+Minute)*60+Second*100)+Sec100;
    End;
Begin
End.