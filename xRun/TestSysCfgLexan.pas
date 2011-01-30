{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P-,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
unit TestSysCfgLexan;
{$DEFINE DEBLEX}
interface
uses TestSysCfgIo;

const MaxIds = 10000;
type Lexem = (_Id, _QuotedStr, _Plus, _Minus, _Times, _Dot, _OpBr, _ClBr,
              _OpBrk, _ClBrk, _OpBrc, _ClBrc, _Semicolon, _Comma, _Colon,
              _DotDot, _PlusPlus, _Equal, _Let, _Less, _Greater, _NotEqual,
              _LEq, _Geq, _And, _Or, _Xor, _Not, _PlusEqual,
              _If, _Then, _Else, _Fi, _Fail, _For, _In, _Do, _Od,
              _True, _False, _Cat,
              _Include, _Question, _VertBar, _EOF, _Error);
var
  L  : Lexem;
  LV : integer;
  LS : string;
const DebugLexems : boolean = false;

procedure skipspc;
function searchid (const S : string; f : integer) : integer;
function getlexem : Lexem;
procedure id2str (x : integer; var S : string);
{$IFDEF DEBLEX}
procedure showlexem;
{$ENDIF}

implementation

{-------------- symbol table -----------------}
const HashPrime = 17239;
var syms   : array [1..HashPrime] of String;
    symtr  : array [1..HashPrime] of integer;
    id2sym : array [1..MaxIds] of integer;
    defids, defkw, keep_h1 : integer;

function searchid (const S : string; f : integer) : integer;
var
  i, h1, h2 : integer;
begin
  h1 := 0;  h2 := 0;
  for i := 1 to length (S) do begin
    if h1 >= (MaxInt-256) div 5 then h1 := h1 mod HashPrime;
    if h2 >= (MaxInt-256) div 3 then h2 := h2 mod pred(HashPrime);
    h1 := h1 * 5 + ord(S[i]);
    h2 := h2 * 3 + ord(S[i]);
  end;
  h1 := h1 mod HashPrime + 1;
  h2 := h2 mod pred (HashPrime) + 1;
  while syms[h1] <> '' do begin
    if syms[h1] = S then begin searchid := symtr[h1]; keep_h1:=h1; exit end;
    inc (h1, h2);
    if h1 > HashPrime then dec (h1, HashPrime)
  end;
  if f = 0 then begin searchid := 0; exit end;
  if defids = MaxIds then CfgError ('too many identifiers');
  inc (defids);
  syms[h1] := S;
  symtr[h1] := defids;
  id2sym[defids] := h1;
  keep_h1 := h1;
  searchid := defids
end;

procedure id2str (x : integer; var S : string);
begin
  if (x <= 0) or (x > defids) then runerror (239);
  S := syms[id2sym[x]]
end;

{------------ lexical analyser ---------------}

{$IFDEF DEBLEX}
procedure showlexem;
begin
  case L of
  _Id: writeln ('ident',#9,LS,#9,LV);
  _QuotedStr: writeln ('string',#9,LS);
  _Plus:      writeln ('+');
  _Minus:     writeln ('-');
  _Times:     writeln ('*');
  _Dot:       writeln ('.');
  _OpBr:      writeln ('(');
  _ClBr:      writeln (')');
  _OpBrk:     writeln ('[');
  _ClBrk:     writeln (']');
  _OpBrc:     writeln ('{');
  _ClBrc:     writeln ('}');
  _Semicolon: writeln (';');
  _Comma:     writeln (',');
  _Colon:     writeln (':');
  _DotDot:    writeln ('..');
  _PlusPlus:  writeln ('++');
  _Equal:     writeln ('=');
  _Let:       writeln (':=');
  _PlusEqual: writeln ('+=');
  _Less:      writeln ('<');
  _Greater:   writeln ('>');
  _NotEqual:  writeln ('<>');
  _LEq:       writeln ('<=');
  _GEq:       writeln ('>=');
  _And:       writeln ('and');
  _Or:        writeln ('or');
  _Xor:       writeln ('xor');
  _Not:       writeln ('not');
  _Question:  writeln ('?');
  _VertBar:   writeln ('|');
  _EOF:       writeln ('<EOF>');
  _Error:     writeln ('*invalid token*')
  else        writeln ('???')
  end
end;
{$ENDIF}

procedure skipspc;
begin
  ReadCfg;
  while RP^ in [' ',#9,#13,#10,#0,'#'] do begin
    if RP^ = '#' then while not (RP^ in [#13,#10,#0,#4]) do inc (RP);
    if RP^ = #10 then inc (CurCLine);
    inc (RP);
    if RP >= EP then ReadCfg
  end;
  ReadCfg
end;

procedure ReadQuoted;
begin
  if RP^ <> '"' then exit;
  LS := '';
  repeat
    if RP^ = '"' then begin
      inc (RP);
      while not (RP^ in [#4, #0, #13, #10, '"']) do begin
        LS := LS + RP^;  inc (RP) end;
      if RP^ <> '"' then CfgError ('string constant exceeds line');
      inc (RP);
    end else
    if (RP[0] = 'c') and (RP[1] = 'r') and (RP[2] in [#13,#10,#0,#4,'"']) then
    begin LS := LS + #10;  inc (RP, 2) end
    else break;
    skipspc
  until {false}true;
end;

function getlexem : Lexem;
begin
  skipspc;
  LV := 0;  LS := '';  L := _Error;
  case RP^ of
  #4:  begin L := _EOF end;
  '"': begin L := _QuotedStr; ReadQuoted end;
  'A'..'Z','a'..'z','0'..'9','_':
       begin
         L := _Id;
         repeat LS := LS + RP^; inc (RP)
         until not (RP^ in ['A'..'Z','a'..'z','0'..'9','_']);
         LV := searchid (LS, 0);
         if LV < 0 then begin
           L := Lexem (-LV);  LV := 0;  LS := ''
         end
       end;
  '+': begin
         inc (RP);
         if RP^ = '+' then begin inc(RP); L := _PlusPlus end
         else if RP^ = '=' then begin inc (RP); L := _PlusEqual end
         else L := _Plus
       end;
  '-': begin inc(RP); L := _Minus end;
  '*': begin inc(RP); L := _Times end;
  '(': begin inc(RP); L := _OpBr end;
  ')': begin inc(RP); L := _ClBr end;
  '[': begin inc(RP); L := _OpBrk end;
  ']': begin inc(RP); L := _ClBrk end;
  '{': begin inc(RP); L := _OpBrc end;
  '}': begin inc(RP); L := _ClBrc end;
  ',': begin inc(RP); L := _Comma end;
  ';': begin inc(RP); L := _Semicolon end;
  '=': begin inc(RP); L := _Equal end;
  '?': begin inc(RP); L := _Question end;
  '|': begin inc(RP); L := _VertBar end;
  '.': begin
         inc (RP);
         if RP^ = '.' then begin inc (RP); L := _DotDot end
         else L := _Dot
       end;
  ':': begin
         inc (RP);
         if RP^ = '=' then begin inc (RP); L := _Let end
         else L := _Colon
       end;
  '<': begin
         inc (RP);
         if RP^ = '=' then begin inc (RP); L := _LEq end
         else if RP^ = '>' then begin inc (RP); L := _NotEqual end
         else L := _Less
       end;
  '>': begin
         inc (RP);
         if RP^ = '=' then begin inc (RP); L := _GEq end
         else L := _Greater
       end
  else CfgError ('invalid character')
  end;
  getlexem := L;
{$IFDEF DEBLEX}
  if DebugLexems then showlexem;
{$ENDIF}
end;

{-------------- define keywords ------------}

procedure def_kw (T : Lexem; S : String);
var i : integer;
begin
  i := searchid (S, 1);
  if i <> defids then runerror (239);
  symtr[keep_h1] := -ord(T);
  dec (defids);  inc (defkw)
end;

procedure DefineKeywords;
begin
  def_kw (_And,  'and');
  def_kw (_Or,   'or');
  def_kw (_Xor,  'xor');
  def_kw (_Not,  'not');
  def_kw (_If,   'if');
  def_kw (_Then, 'then');
  def_kw (_Else, 'else');
  def_kw (_Fi,   'fi');
  def_kw (_For,  'for');
  def_kw (_In,   'in');
  def_kw (_Do,   'do');
  def_kw (_Od,   'od');
  def_kw (_Fail, 'fail');
  def_kw (_False,'false');
  def_kw (_True, 'true');
  def_kw (_Cat,  'cat');
  def_kw (_Include, 'include');
end;

begin
  DefineKeywords
end.