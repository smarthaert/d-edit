{ * StrUtils - ����� � ��ப��� * }
Unit StrUtils;

Interface

 Const NS = #13#10;
{ -= �६� =- }
 Const CurHour   : Word    = 0;
       CurMinute : Word    = 0;
       CurSecond : Word    = 0;
       CurSec100 : Word    = 0;
{ -= ��ॢ�� ��ப� � �᫮ =- }
 Function Str2Int( S:String ):LongInt;
{ -= ��ॢ�� �᫠ � ��ப� =- }
 Function Int2Str( L:LongInt ):String;
{ -= ���������� ᨬ����� ᧠�� =- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
{ -= ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ ᫥�� =- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
{ -= �������� �஡���� � ��砫� ��ப� � � ���� =- }
 Function DelSpaces( S:String ):String;
{ -= ��ॢ�� ��ப� � ���孨� ॣ���� =- }
 Function UpCaseStr( S:String ):String;
{ -= ��ப� �६��� =- }
 Function CurrentTimeStr:String;

Implementation

Uses DOS,RunError;

{ -= ��ॢ�� ��ப� � �᫮ =- }
 Function Str2Int( S:String ):LongInt;
   Var Res:LongInt; Error:Integer;
   Begin
     Val(S,Res,Error);
     If Error<>0 then RuntimeError('H� ���� �������஢��� ��ப� � �᫮.');
     Str2Int:=Res;
   End;

{ -= ��ॢ�� �᫠ � ��ப� =- }
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
   End;

{ -= ���������� ᨬ����� ᧠�� =- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ -= ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ ᫥�� =- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ -= �������� �஡���� � ��砫� ��ப� � � ���� =- }
 Function DelSpaces( S:String ):String;
   Begin
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     While S[1]=' ' do S:=Copy(S,2,Length(S)-1);
     DelSpaces := S;
   End;

{ -= ��ॢ�� ��ப� � ���孨� ॣ���� =- }
 Function UpCaseStr( S:String ):String;
   Var I:Byte;
   Begin
     For I:=1 to Length(S) do S[I]:=UpCase(S[I]);
     UpCaseStr:=S;
   End;

{ -= ��ப� �६��� =- }
 Function CurrentTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurrentTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

End.