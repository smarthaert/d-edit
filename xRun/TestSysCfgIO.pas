{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P-,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
unit TestSysCfgIO;
interface

uses SysUtils, Windows;

const EOFChar=#4;

type CfgException = class (Exception);

var
  RP, EP   : PChar;
  CurCName : String;
  CurCLine : integer;

function OpenCfg (const S : string) : integer;
procedure CloseCfg;
procedure CfgError (const S : string);
procedure ReadCfg;

implementation

const CfgBuffSize = 8192{512};  MaxIncl = 8;


type CfgFile = record
                 handle : cardinal;
                 Name   : string;
                 line   : integer;
                 ps     : longint;
                 rb, tb : integer;
                 OldDir : string;
                 B      : array [0..CfgBuffSize] of char;
               end;
     PCfgFile = ^CfgFile;

var {BF : array [0..CfgBuffSize-1] of char;}
    QP : PChar;
    IStack  : array [1..MaxIncl] of PCfgFile;
    ISP     : word;
const NilStr : PChar = #4#4#4#4#4#4#4#4#0#0#0#0;


function OpenCfg (const S : String) : integer;
var P : PCfgFile;
    Dir : String;
begin
  new (P);
  {if P = nil then begin
    writeln ('config: fatal: out of memory');
    halt (239)
  end;}
  fillchar (P^, sizeof(P^), 0);
  if ISP = MaxIncl then begin
    writeln ('config: fatal: too nested config files');
    runerror (239);{bug}
  end;{add to log&ignore?}
  if ISP > 0 then with IStack[ISP]^ do begin
    Line := CurCLine;
    rb := RP - @B;
    tb := EP - @B;
  end;
  inc (ISP);
  IStack[ISP] := P;
  with P^ do begin

    (* assign (F, S);
    {$I-} reset (F, 1); {$I+} *)
    handle:=CreateFile (PChar (S), GENERIC_READ, FILE_SHARE_READ, nil,
              OPEN_EXISTING,
              FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
    if handle=invalid_handle_value then begin
      dispose (P);
      dec (ISP);
      OpenCfg := -1;
      CfgError ('unable to open included file `'+S+'''.');
      exit
    end;
    OldDir:=GetCurrentDir;
    Dir:=ExtractFileDir (S);
    Name:=ExtractFileName (S);
    Line := 0;
    if Length (Dir) > 0 then SetCurrentDir (Dir);
    QP := @B[CfgBuffSize];
    RP := QP;
    EP := QP;
    CurCName := Name;
    CurCLine := 1;
  end;
  ReadCfg;
  OpenCfg := ISP
end;

procedure CloseCfg;
begin
  if ISP = 0 then exit;
  with IStack[ISP]^ do begin
    CloseHandle (handle);
    SetCurrentDir (OldDir);
    RP := NilStr;
    EP := NilStr;
    QP := NilStr;
    CurCname := '';
    CurCLine := -1;
  end;
  dispose (IStack[ISP]);
  dec (ISP);
  if ISP = 0 then exit;
  with IStack[ISP]^ do begin
    RP := @B[rb];
    EP := @B[tb];
    QP := @B[CfgBuffSize];
    CurCName := Name;
    CurCLine := Line
  end;
  ReadCfg
end;

procedure CfgError (const S : String);
begin
  if CurCLine <= 0 then write ('config: error: ')
  else write ('config: ', CurCName, '(', CurCLine, '): ');
  writeln (S);
  raise CfgException.Create (S);
  runerror (242);
end;

procedure ReadCfg;
var sz, sh: integer;
    res:cardinal;
begin
  if QP = NilStr then begin RP:=QP; EP:=QP; exit end;
  if RP > EP then begin CloseCfg; ReadCfg; exit end;
  if EP - RP >= 256 then exit;
  if EP < QP then exit;
  with IStack[ISP]^ do begin
    sz := EP - RP;  sh := RP - @B;
    Move (RP^, B, sz);
    RP := @B;
    dec (EP, sh);
    inc (ps, sh);
    sz := QP - EP;
    if not ReadFile (handle, EP^, sz, res, nil) then
      runerror (239); {what to do on error???}
    inc (EP, res);
    EP^ := #0;
  end
end;

initialization
  RP := NilStr;
  EP := NilStr;
  QP := NilStr;
  ISP := 0;
  CurCname := '';
  CurCLine := -1;
end.