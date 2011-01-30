{ * StrUtils - Работа со строками * }
Unit StrUtils;

Interface

 Const NS = #13#10;
{ -= Время =- }
 Const CurHour   : Word    = 0;
       CurMinute : Word    = 0;
       CurSecond : Word    = 0;
       CurSec100 : Word    = 0;
{ -= Перевод строки в число =- }
 Function Str2Int( S:String ):LongInt;
{ -= Перевод числа в строку =- }
 Function Int2Str( L:LongInt ):String;
{ -= Добавление символов сзади =- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
{ -= Перевод числа в строку дополненную символами слева =- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
{ -= Удаление пробелов в начале строки и в конце =- }
 Function DelSpaces( S:String ):String;
{ -= Перевод строки в верхний регистр =- }
 Function UpCaseStr( S:String ):String;
{ -= Строка времени =- }
 Function CurrentTimeStr:String;

Implementation

Uses DOS,RunError;

{ -= Перевод строки в число =- }
 Function Str2Int( S:String ):LongInt;
   Var Res:LongInt; Error:Integer;
   Begin
     Val(S,Res,Error);
     If Error<>0 then RuntimeError('Hе могу конвертировать строку в число.');
     Str2Int:=Res;
   End;

{ -= Перевод числа в строку =- }
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
   End;

{ -= Добавление символов сзади =- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ -= Перевод числа в строку дополненную символами слева =- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ -= Удаление пробелов в начале строки и в конце =- }
 Function DelSpaces( S:String ):String;
   Begin
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     While S[1]=' ' do S:=Copy(S,2,Length(S)-1);
     DelSpaces := S;
   End;

{ -= Перевод строки в верхний регистр =- }
 Function UpCaseStr( S:String ):String;
   Var I:Byte;
   Begin
     For I:=1 to Length(S) do S[I]:=UpCase(S[I]);
     UpCaseStr:=S;
   End;

{ -= Строка времени =- }
 Function CurrentTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurrentTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

End.