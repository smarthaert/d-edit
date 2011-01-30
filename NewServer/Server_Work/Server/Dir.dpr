library Dir;

uses
  SysUtils, Classes, Xml_Server, QDialogs;

Type  TUser = Record
         Name, Dir_Path, Disqualificated : WideString;
         ID : Longint;
      End;

Var UsersConfig : Array of TUser;
    Len : Longint;
    Mesage: TStrings;


Procedure GiveUsers(_Config : IXMLUSERSType); StdCall;
Var i : Longint;
begin
  SetLength(UsersConfig, _Config.Count);
  Len:=_Config.Count;
  For I:=0 to  _Config.Count-1 do
    Begin
       UsersConfig[i].ID:=_Config.USER[i].ID;
       UsersConfig[i].Name:=_Config.USER[i].Name;
       UsersConfig[i].Dir_Path:=_Config.USER[i].Dir_Path;
       UsersConfig[i].Disqualificated:=_Config.USER[i].Disqualificated;
    End;
  //  ShowMessage(_Config.XML);  
End;

Function SendMessage(FileName : String; Text : TStrings): Boolean; StdCall;
Begin
   FileName := FileName{UsersConfig.USER.Items[User_ID].Dir_Path}+'\Answer.msg';
   Text.SaveToFile(FileName);
   if FileExists(FileName) then begin
      Result := False;
      Exit;
   end;
   Result := True;
End;

Function  AcceptMessage(User_ID : Integer) : String; StdCall;
Var Mesage : TStrings;
    FileName : String;
Begin
   if ((User_ID<0) or (User_ID>=Len)) then
      Begin
        MessageDLG('USER_ID='+IntToStr(User_ID)+' не существует!',MtError,[mbOK],0);
        Result:='';
        Exit;
      End;
   FileName := UsersConfig[User_ID].Dir_Path+'\Submit.msg';
   //ShowMessage(FileName);
   if not FileExists(FileName) then begin
     Result := '';
     Exit;
   end;
   Try
      Mesage := TStringList.Create;
      Mesage.LoadFromFile(FileName);
      DeleteFile(FileName);
      //ShowMessage(Mesage.Text);
      Result := Mesage.Text;
   Finally
      Mesage.Free;
   End;
End;


Function TempWrite( Text : String):String;
Var F :TextFile;
Begin
   Assign(F, 'TT.txt');
   Rewrite(F);
   Write(F,Text);
   Result := 'kgjhflkdsh';
   CloseFile(F);
End;

exports
   AcceptMessage, GiveUsers, SendMessage, TempWrite;


end.


