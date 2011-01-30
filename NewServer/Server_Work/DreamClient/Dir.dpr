library Dir;

uses
  SysUtils, Classes, Monitor_Xml, QDialogs, User_xml;


Var UsersConfig : IXMLConfigType;
    Len : Longint;
    Mesage: TStrings;

Function SendMessage(Path, _Message : String): Boolean; StdCall;
Var Text : Tstrings;
Begin
   Text:= TStringList.Create;
   Text.Text:=_Message;
   Path := Path+'\Submit.msg';
   Text.SaveToFile(Path);
   if FileExists(Path) then begin
      Result := False;
      Exit;
   end;
   Result := True;
End;

Procedure GiveConfig(Var _Config : IXMLConfigType);
Begin
  UsersConfig := _Config;

End;

Function  AcceptMessage : String; StdCall;
Var Mesage : TStrings;
    FileName : String;
Begin
   FileName := UsersConfig.Paths.Queue+'\Answer.msg';
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

exports
   AcceptMessage, SendMessage, GiveConfig;


end.


