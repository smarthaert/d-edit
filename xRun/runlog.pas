{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P-,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
unit runlog;

interface

uses SysUtils, {Windows, }TestSysUtil, TestSysTime;

const RunLogName:string='run.log';

procedure WriteLog (const S:String);
procedure WriteOnlyLog (const S:String);
procedure WriteLogEmpty;
procedure OnlyLogString (const S : string; P : array of const);
procedure LogString (const S : string; P : array of const);

implementation

procedure WriteOnlyLog (const S:String);
var Z:string;
begin
  if RunLogName<>'' then begin
    z:={MyDateTimeToStr (MyNow)+' '+}S+#13#10; // Denis
    if not AppendStringToFile (Z, RunLogName, true) then
      writeln ('WARNING: unable to write log file '+RunLogName);
  end;
end;

procedure WriteLogEmpty;
begin
  if RunLogName<>'' then begin
    if not AppendStringToFile (#13#10, RunLogName, true) then
      writeln ('WARNING: unable to write log file '+RunLogName);
  end;
end;


procedure WriteLog (const S:String);
begin
  Writeln (S);
  WriteOnlyLog (s);
end;


procedure OnlyLogString (const S : string; P : array of const);
begin
  WriteOnlyLog (format (S, P));
end;


procedure LogString (const S : string; P : array of const);
begin
  WriteLog (format (S, P));
end;


end.
