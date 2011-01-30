unit Base;

interface

Uses Classes, ShellApi, XMLDoc, SysUtils, FmxUtils, Xml_Server,
     QDialogs, monitor_XML;


//Const Queue_Path ='C:\Pavlik\ETUClub\Queue\';

{************************** Functions & Procedures ************************}

Function LoadQueueNumber: String;
Procedure SaveQueueNumber;

Type
  EDLLLoadError = Class(Exception);  // Исключения при зарг. DLL

  TSendMessage = Function (FileName : String; Text : TStrings): Boolean; StdCall;
  TAcceptMessage = Function (User_ID : Integer) : String; StdCall;
  TGiveUsers = Procedure (_Config : IXMLUSERSType); StdCall;


Var LibHandle   : THandle;
    SendUserMessage : TSendMessage;
    AcceptMessage : TAcceptMessage;
    GiveUsers : TGiveUsers;
    Tek_Time : TDateTime;

{********************************* Variables *****************************}

Var  Config : IXMLServerType;
     Tek_Queue: Longint;
     XMonitor : IXMLMONITORType;


implementation

Function LoadQueueNumber: String;
Var F : Text;
    Number : Integer;
    Answer : String;
Begin
  {$I-}
    AssignFile(F,Config.Paths.QueueNumber);
    IF FileExists(Config.Paths.QueueNumber) Then Reset(F) Else
      Begin
        MessageDLG('Queue file not Found! #13 view "server.xml"',
                     mtError ,[mbOK], 0);
        Result := '';
        Exit;
      End;
    Read(F,Number);
    Tek_Queue := Number;
    Case Length(IntToStr(Number)) of
      1 : Answer := '0000000'+IntToStr(Number);
      2 : Answer := '000000'+IntToStr(Number);
      3 : Answer := '00000'+IntToStr(Number);
      4 : Answer := '0000'+IntToStr(Number);
      5 : Answer := '000'+IntToStr(Number);
      6 : Answer := '00'+IntToStr(Number);
      7 : Answer := '0'+IntToStr(Number);
      8 : Answer := IntToStr(Number);
    Else Answer := ''; End;
    CloseFile(F);
  {$I+}
  Result := Answer;
End;


Procedure SaveQueueNumber;
Var F : Text;
Begin
  {$I-}
    AssignFile(F,Config.Paths.QueueNumber);
    ReWrite(F);
    Writeln(F, Tek_Queue);
    CloseFile(F);
  {$I+}
End;


Procedure PrintConfig;
Begin
  ShowMessage(Config.Xml);
End;
{  initialization
    LibHandle := LoadLibrary('Dir.dll');
    if LibHandle = 0 then ;// Error
  finalization
    FreeLibrary(LibHandle); // Unload the DLL.}
end.
