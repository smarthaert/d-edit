{ ---=== ”ซ ฃ แฎเฅขญฎข ญจ๏ ===--- }
 Const Contest : Boolean = False;

{ ---=== เฅฌ๏ ===--- }
 Const StartContestHour   : Byte    = 0;
       StartContestMinute : Byte    = 0;
       CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;
       CurTime            : LongInt = 0;
       AllContestTime     : LongInt = 9999;
       TimeLeft           : LongInt = 9999;


{ ---=== ‘โเฎช  ขเฅฌฅญจ ===--- }
 Function CurrentTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurrentTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                       ”    € –                          ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฎช ง ฏเฎๆฅแแ  เ กฎโ๋ ===--- }
 Const
   NumInfoSymb = 12;
   InfoSymb : Array [0..NumInfoSymb-1] of Char='-/|\-/|\-/|\';

{ ---=== ญไฎเฌ ๆจ๏ ===--- }
 Type
   PInfoTask = ^TInfoTask;
   TInfoTask = Object(TTask)
     LastDraw : Word;
     Procedure Run; Virtual;
     Procedure Show;
   End;

 Procedure TInfoTask.Run;
   Var Temp:Word;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurTime:=(CurHour-StartContestHour)*60+(CurMinute-StartContestMinute);
     TimeLeft:=AllContestTime-CurTime;
     Temp:=CurSec100 div NumInfoSymb;
     If Temp<>LastDraw then
       Begin
         Show;
         LastDraw:=Temp;
       End;
   End;

 Procedure TInfoTask.Show;
   Var X,Y:Byte;
   Begin
     X:=WhereX; Y:=WhereY;
     GotoXY(1,25);
     TextColor(10);
     Write(CurrentTimeStr,'  ');
     TextColor(11);
     Write('Contest = ',Contest,' ',
           AddNumStr(StartContestHour,'0',2),':',
           AddNumStr(StartContestMinute,'0',2),'  ');
     TextColor(13);
     Write(' Time ',AddNumStr(CurTime,'0',4),
           '  All ',AddNumStr(AllContestTime,'0',4),
           ' Left ',AddNumStr(TimeLeft,'0',4),'  ');
     TextColor(9);
     Write(InfoSymb[CurSec100*NumInfoSymb div 100]);
     Write('  ');
     GotoXY(X,Y);
   End;
