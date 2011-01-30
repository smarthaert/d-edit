{ Задача: Утилита Submit для Contest Server 2000 }
{ (Утилита для отсылки решений системе проверкм) }
Uses CRT,DOS,Tools;

Var IniFile : Text;

Const YourChoice = 'Your Choice:';

Begin
 { - Read "USER.INI" - }
  FileName := FSearch('USER.INI','PATH');
  If FileName = '' then
    Runtime_Error('Couldn''t run because "USER.INI" not found.'+
      +' Please, call administrator !');
  Assign(IniFile,FileName);   { Open "USER.INI" }
  Reset(IniFile);
  Readln(IniFile,CurUserDir); { Reading Directory of Current User }
  Close(IniFile);             { Close "USER.INI" }
 { - Choose your problem ID - }
  Writeln('To submit ');
  Write(YourChoice); Readln(ProblemID);
End.
