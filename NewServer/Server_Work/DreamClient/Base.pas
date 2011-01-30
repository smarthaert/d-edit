unit Base;

interface

Uses Classes, ShellApi, XMLDoc, SysUtils,FmxUtils;

Type
   TUser = Class
       Name, ID, Dir_Path, IP : String;
       Disqualificated : Boolean;
   End;
   TServer = Class
       Start_Competition, End_Competition : TDateTime;
       Length_Competition : Longint;
   End;
   TProblem = Class
   End;

Var Users : Array of TUser;

{Function SendMessage(User_ID : Longint; Text : TStrings): Boolean; StdCall; external 'Dir.dll' name 'SendMessage';
Function AcceptMessage( User_ID : Longint) : TStrings; StdCall; external 'Dir.dll' name 'AcceptMessage';
Procedure GiveUsers_Podavis( UsersFromServer : Array of TUser ); StdCall; external 'Dir.dll' name 'GiveUsers_Podavis';}
Procedure ReadServerConfig;


implementation

Procedure ReadServerConfig;
Var Config, Good_Config : TextFile;
    Text, Tag : String;
    Ch, Next : Char;
    I : Longint;
    isFirstChar,isString : Boolean;
Begin
  {$I-}
  AssignFile(Config,'Test_Server.cfg');
  AssignFile(Good_Config, 'Good_Config.cfg');
  Reset(Config);
  Rewrite(Good_Config);
  IF IOResult<>0 then Write('Disabled Config');
  isFirstChar := true;
  isString := false;
  While Not Eof(Config) do
    Begin
      Read(Config,Ch);
      IF ((Ord(Ch)>32) or isString) Then
        Begin
          If (isFirstChar and (Ch<>'<')) then
            Write(Good_Config,'  ');
          isFirstChar := false;
          Write(Good_Config,Ch);
          If Ch = '"' then isString := not isString;
          If (Ch=';') Or (Ch='>') then
            Begin
              Writeln(Good_Config);
              isFirstChar := true;
            End;
        End;
    End;
  CloseFile(Config);
  CloseFile(Good_Config);
  DeleteFile('Test_Server.cfg');
  MoveFile('Good_Config.cfg','Test_Server.cfg');
  {$I+}
  Reset(Config);
  While Not Eof(Config) do
    Begin
      Read(Config,Text);
      If Text[1]='<' then Tag:=Text;


    End;
End;

end.
