unit Pathes;
interface
Uses Windows,Forms,SysUtils,Dialogs ;

function CDEnabled:Boolean;
function CustomCDEnabled(FileName : string):Boolean;

Function GetName(InFileName : string): string ;overload;

Function GetName(InDir,InFileName : string): string ;overload;

implementation
//Uses Unit1;

function CDROMNames:String;
Var
DriveNum:word;
begin
Result:='';
for DriveNum:=1 to 25 do
 if GetDriveType(Pchar(Char(DriveNum + $41)+':\'))=DRIVE_CDROM
  then Result:=Result+Chr(DriveNum + ord('a'));
end;

function CustomCDEnabled(FileName : string):Boolean;
Var
CDS : string;
i   : integer;
begin
Result:=false;
CDS:=CDROMNames;
if Length(CDS)>=1 then
 For i:=1 to Length(CDS) do
  if FileExists( CDS[i]+':\'+FileName)then
   begin
    Result:=true;
    Exit;
   end;
end;

function CDEnabled:Boolean;
Var
CDS : string;
i   : integer;
FileName : string;
begin
Result:=false;
CDS:=CDROMNames;
FileName:=ExtractFileName(Application.ExeName);
if Length(CDS)>=1 then
 For i:=1 to Length(CDS) do
  begin
  if FileExists( CDS[i]+':\'+FileName)then
   begin
    Result:=true;
    Exit;
   end;
  end;
end;

function CDROMName:String;
Var
CDS : string;
i   : integer;
begin
Result:='';
CDS:=CDROMNames;
if Length(CDS)>=1 then
 For i:=1 to Length(CDS) do
  if FileExists( CDS[i]+':\'+ExtractFileName(Application.ExeName))then
   begin
    Result:=CDS[i];
    Exit;
   end;
end;


Function  GetName(InFileName : string): string ;
Var
OutFileName : string;
begin
 {
 if WorkDir<>'ERROR' then
 begin
  OutFileName:=WorkDir+'\'+InFileName ;
  if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;
 end;
 }

  Result:='';
  OutFileName:=ExtractFilePath(Application.ExeName)+InFileName ;
  //if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;


  OutFileName:=CDROMName+':\'+InFileName ;
  if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;

  //if Result='' then ShowMessage(InFileName);

end;

Function  GetName(InDir,InFileName : string): string ;
Var
OutFileName : string;
begin
 {
 if WorkDir<>'ERROR' then
 begin
  OutFileName:=WorkDir+'\'+InDir+'\'+InFileName ;
  if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;
  }

  Result:='';

  OutFileName:=ExtractFilePath(Application.ExeName)+InDir+'\'+InFileName ;
  //if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;

  OutFileName:=CDROMName+':\'+InDir+'\'+InFileName ;
  if FileExists(OutFileName) then
   begin
    Result:=OutFileName;
    Exit;
   end;

  //if Result='' then  ShowMessage(InDir+'\'+InFileName);

end;


end.
