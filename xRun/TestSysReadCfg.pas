{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
unit TestSysReadCfg;
interface

uses SysUtils;
type CfgParseException = class (Exception);

const INVALID_NUM = Integer ($80000000);
type
  TCfgObjType = (_NULL_, _STRING_, _LIST_, _CONTEXT_);
  PCfgObject = ^TCfgObject;
  PCfgString = ^TCfgString;
  PCfgList   = ^TCfgList;
  PCfgContext= ^TCfgContext;
  TCfgObject = object
                 P      : Pointer;
                 Origin : String;
                 destructor delobj; virtual;
                 constructor newobj (Ptr : Pointer);
                 constructor newobjo (Ptr : Pointer; const Org : string);
                 procedure destroy;
                 procedure raiseerr (const Msg : string);
                 function isnil : boolean; virtual;
                 function gettype : TCfgObjType; virtual;
                 function check : boolean;
                 function obj : PCfgObject;
                 function tostr : PCfgString;
                 function tolist : PCfgList;
                 function tocontext : PCfgContext;
                 procedure dump; virtual;
                 procedure print; virtual;
               end;
  TCfgString = object (TCfgObject)
                 function gettype : TCfgObjType; virtual;
                 function check : boolean;
                 constructor newstr (S : String);
                 function getstr : String;
                 function getint : Longint;
               end;
  TCfgList   = object (TCfgObject)
                 function gettype : TCfgObjType; virtual;
                 function check : boolean;
                 constructor newlist (var A : array of PCfgObject);
                 function len : integer;
                 function getel (x : integer) : PCfgObject;
               end;
  TCfgContext= object (TCfgObject)
                 function gettype : TCfgObjType; virtual;
                 function check : boolean;
                 function evalvar (S : string) : PCfgObject;
               end;

function ReadConfig (FileName : String) : PCfgContext;
procedure DelCfgObj (O : PCfgObject);
procedure ShowCfgStats;

implementation
uses TestSysCfgIO, TestSysCfgLexan;

const MaxCNA = 1024;  MaxCNS = 16384;
type
  TNode = (__String, __List, __Context, __Env, __Closure, __Range,
           __Plus, __Minus, __Times, __CatStr, __Dot,
           __And, __Or, __Xor, __Not, __In,
           __Equal, __NotEqual, __Less, __Greater, __LEq, __GEq,
           __For, __Cond, __Assign, __AddAssign,
           __Var, __LocVar);
  PNode = ^CNode;
  CNode = record
            refcnt  : integer;
            t       : TNode;
            N       : integer;
            case integer of
            0: (a : array [1..MaxCNA] of longint);
            1: (p : array [1..MaxCNA] of PNode);
            2: (c : array [0..MaxCNS-1] of char);
          end;

function Eval (Expr, Context, Env : PNode) : PNode; forward;
procedure Print (P : PNode); forward;

procedure dumpnode (P : PNode); forward;

var CC, CS  : PNode;    { current context: current point & start }

{------------- some heap procedures ---------------}

var oc, ocb, onw, onwb : longint;

function newnode (tp : TNode; sz : integer) : PNode;
var P : PNode; b : integer;
begin
  b := sizeof(CNode) - MaxCNS;
  if tp = __String then inc (b, sz + 1) else inc (b, sz shl 2);
  getmem (P, b);  if P = nil then runerror (239);
  fillchar (P^, b, 0);
  inc (oc);  inc (ocb, b);  inc (onw);  inc (onwb, b);
  P^.refcnt := 1;
  P^.t := tp;
  P^.N := sz;
  newnode := P
end;

function newstring (S : string) : PNode;
var P : PNode;
begin
  P := newnode (__String, length (S));
  move (S[1], P^.c, length (S));
  P^.c[length(S)] := #0;
  newstring := P
end;

function newpchar (S : PChar) : PNode;
var P : PNode; L : integer;
begin
  L := 0;  while S[L] <> #0 do inc (L);
  P := newnode (__String, L);
  move (S[0], P^.c, L + 1);
  newpchar := P
end;

function getpchar (P : PNode) : PChar;
begin
  if (P^.refcnt <= 0) or (P^.t <> __String) then runerror (239);
  getpchar := PChar (@P^.c[0])
end;

function getstring (P : PNode) : String;
begin
  Result := getpchar (P);
end;

procedure decref (var P : PNode); forward;

procedure i_delnode (var P : PNode);
var b : integer;
begin
  b := sizeof(CNode) - MaxCNS;
  if P^.t = __String then inc (b, P^.N + 1) else inc (b, P^.N shl 2);
  dec (oc);  dec (ocb, b);
  P^.refcnt := -239;
  freemem (P, b);
  P := nil
end;

procedure delnode (var P : PNode);
var a, b, i : integer;
begin
  if P = nil then exit;
  a := 1;  b := P^.N;
  case P^.t of
  __Var, __Env: a := 2;
  __Assign, __AddAssign: a := 4;
  __For:    a := 3;
  __String, __LocVar: b := 0;
  end;
  for i := a to b do decref (P^.p[i]);
  i_delnode (P)
end;

function incref (P : PNode) : PNode;
begin
  incref := P;
  if P = nil then exit;
  if (P^.refcnt <= 0) or (P^.refcnt > 1000) then runerror (239);
  inc (P^.refcnt)
end;

procedure decref (var P : PNode);
begin
{  writeln ('decref: '); dumpnode (P);}
  if P = nil then exit;
  if (P^.refcnt <= 0) or (P^.refcnt > 1000) then
    runerror (239);
  dec (P^.refcnt);
  if P^.refcnt = 0 then delnode (P)
end;

var keep_true, keep_false  : PNode;
function newbool (F : boolean) : PNode;
begin
  if F then begin
    if keep_true = nil then keep_true := newstring ('true');
    newbool := incref (keep_true)
  end else begin
    if keep_false = nil then keep_false := newstring ('false');
    newbool := incref (keep_false)
  end
end;

function getbool (P : PNode) : boolean;
begin
  getbool := false;
  if (P = nil) or (P^.t <> __String) then
    CfgError ('boolean expression required');
  if P = keep_true then begin getbool := true; exit end;
  if P = keep_false then begin getbool := false; exit end;
  if P^.N = 4 then begin
    if getstring(P) <> 'true' then
      CfgError ('boolean expression required');
    getbool := true
  end else if P^.N = 5 then begin
    if getstring(P) <> 'false' then
      CfgError ('boolean expression required');
    getbool := false
  end else CfgError ('boolean expression required');
end;

function hex (x : longint) : string;
var i : integer; S : string;
const HCyf : string = '0123456789ABCDEF';
begin
  S := '';
  for i := 1 to 8 do begin
    S := S + HCyf[succ((x shr 28) and $f)];
    x := x shl 4
  end;
  hex := S
end;

procedure i_dumpnode (P : PNode; ind : integer);
var a, i, b : integer; S : string;
begin
  write (hex(longint(P)),'':4, '':ind);
  if P = nil then begin writeln ('<nil>'); exit end;
  write (P^.refcnt,'#');
  if (P^.refcnt < 0) or (P^.refcnt > 1000) or (P^.N > MaxCNA) then
    begin writeln ('<invalid>'); exit end;
  if P^.t = __String then begin
    writeln (PChar(@(P^.c))); exit end;
  a := 1;  b := P^.N;
  case P^.t of
  __List    : S := 'List';
  __Context : S := 'Context';
  __Env     : begin S := 'Env'; a := 2 end;
  __Closure : S := 'Closure';
  __Range   : S := 'Range';
  __Plus    : S := '+';
  __Minus   : S := '-';
  __Times   : S := '*';
  __CatStr  : S := 'Cat';
  __Dot     : S := '.';
  __And     : S := 'And';
  __Or      : S := 'Or';
  __Xor     : S := 'Xor';
  __Not     : S := 'Not';
  __In      : S := 'In';
  __Equal   : S := '=';
  __NotEqual: S := '<>';
  __Less    : S := '<';
  __Greater : S := '>';
  __LEq     : S := '<=';
  __GEq     : S := '>=';
  __For     : begin S := 'for'; a := 3 end;
  __Cond    : S := 'cond';
  __Assign  : begin S := 'assign'; a := 4 end;
  __AddAssign : begin S := 'addassign'; a := 4 end;
  __Var     : begin S := 'var'; a := 2 end;
  __LocVar  : begin S := 'locvar'; a := P^.N + 1 end;
  else begin writeln ('<type ', ord(P^.t), '>'); exit end
  end;
  write (S);
  for i := 1 to a - 1 do begin
    write (' ', P^.a[i]);
    if (i = 1) and (P^.t in [__Assign, __AddAssign, __Var, __LocVar]) then
      begin id2str (P^.a[1], S);  write ('<', S, '>') end
  end;
  writeln;
  for i := a to b do
    if (P^.t = __Context) and (i = 2) {and (P^.p[1] <> nil)}
      then writeln (hex(longint(P^.p[i])),'':4, '':ind, '...')
      else i_dumpnode (P^.p[i], ind+2)
end;

procedure dumpnode (P : PNode);
begin
  i_dumpnode (P, 0);
  writeln ('------------------------');
end;

{---------- "extended" lexical analyser -----------}

function ReadPattern (mode : integer) : PNode; forward;

function getlexem : Lexem;
var P, Q : PNode;
begin
  while TestSysCfgLexan.getlexem = _Include do begin
    P := ReadPattern (1);
    Q := Eval (P, CC, nil);
    decref (P);
    OpenCfg (getstring (Q));
    decref (Q);
  end;
  getlexem := L
end;

{----------- Syntax analyser tables --------------}

const StkSize = 256;
type
  StkEntry = record id : integer; t, v, d, r : byte end;
  PStkEntry = ^StkEntry;
var
  symt, symv, symd  : array [1..MaxIds] of byte;
  {global var: symt=1, symd=depth of definition (>=0), symv=arity;
   local var:  symt=2, symd=frame level, symv=offset in frame;
   undefined:  symt=0}
  syStack      : array [1..StkSize] of StkEntry;
  sySP, frlev, glev  : integer;

procedure sy_push (_id, _t, _v, _d : integer);
begin
  if sySP = StkSize then CfgError ('syntax stack overflow');
  inc (sySP);
  with syStack[sySP] do begin
    id := _id;  t := _t;  v := _v;  d := _d end
end;

function sy_pop : PStkEntry;
begin
  if sySP = 0 then CfgError ('syntax stack underflow');
  dec (sySP);
  sy_pop := @syStack[sySP+1]
end;

procedure enter_lexlevel (t : integer);
begin
  sy_push (-1, t, 0, 0);
  inc (frlev, t);
  inc (glev);
end;

procedure leave_lexlevel;
begin
  if sySP = 0 then exit;
  dec (glev);
  repeat
    with syStack[sySP] do begin
      if id = -1 then begin dec (frlev, t); dec (sySP); break end;
      symt[id] := t;
      symv[id] := v;
      symd[id] := d
    end;
    dec (sySP)
  until sySP = 0;
end;

procedure defvar (id, arity : integer);
var i, f : integer;
begin
  if (symt[id]=1) and (symd[id]=glev) then begin
    if symv[id] <> arity then CfgError ('arity of function changed');
    exit
  end;
  f := 0;
  if (symt[id]=2) and (symd[id]=frlev) then begin
    i := sySP;
    while i > 0 do begin
      if SyStack[i].id = id then begin f := 1; break end;
      if SyStack[i].id = -1 then break;
      dec (i)
    end
  end;
  if f = 0 then sy_push (id, symt[id], symv[id], symd[id]);
  symt[id] := 1;
  symd[id] := glev;
  symv[id] := arity
end;

procedure deflocvar (id, offs : integer);
begin
  if (symt[id]=2) and (symd[id]=frlev) then
    CfgError ('Duplicate local variable name');
  sy_push (id, symt[id], symv[id], symd[id]);
  symt[id] := 2;
  symd[id] := frlev;
  symv[id] := offs
end;

function MbLocVar (var S : string) : boolean;
var i : integer;
begin
  for i := 1 to length(S) do
    if not (S[i] in ['a'..'z']) then begin MbLocVar:=false; exit end;
  MbLocVar := true
end;


{-------------- Expression parser -----------------}
{ Priority:
  or xor
  and
  not
  in < > = <> <= >=
  ..
  + -
  *
  .
  () []  }

function mkbinop (T : TNode; P, Q : PNode) : PNode;
var R : PNode;
begin
  R := newnode (T, 2);
  R^.p[1] := P;
  R^.p[2] := Q;
  mkbinop := R
end;

function mkunop (T : TNode; P : PNode) : PNode;
var R : PNode;
begin
  R := newnode (T, 1);
  R^.p[1] := P;
  mkunop := R
end;

function mklocvar (x : integer) : PNode;
var P : PNode;
begin
  P := newnode (__LocVar, 3);
  P^.a[1] := x;
  P^.a[2] := frlev - symd[x];
  P^.a[3] := symv[x];
  mklocvar := P
end;

function ReadContext : PNode; forward;
procedure ReadFor (P : PNode); forward;
function read_expr : PNode; forward;
function read_expr3a : PNode; forward;

const LStkSize = 1024;
var LStk   : array [1..StkSize] of PNode;
    LStkSP : integer;
    rexprmd : integer;

procedure lpush (P : PNode);
begin
  if LStkSP = LStkSize then CfgError ('List too long');
  inc (LStkSP);
  LStk[LStkSP] := P
end;

function read_builtin (T : TNode; u, v : integer) : PNode;
var P, Q : PNode; S, i : integer;
begin
  getlexem;
  P := newnode (T, v);
  S := 0;
  if L = _OpBr then begin
    repeat
      getlexem;
      inc (S);
      P^.p[S] := read_expr;
    until (S = v) or (L <> _Comma);
    if L <> _ClBr then CfgError (''','' expected');
    getlexem
  end else begin
    for i := 1 to u do
      P^.p[i] := read_expr;
    S := u;
    while (S < v) and (L in [_Id, _Cat, _VertBar, _OpBr, _OpBrk, _OpBrc,
                             _For, _If]) do
      begin inc (S); P^.p[S] := read_expr end
  end;
  if S <> v then begin
    Q := newnode (T, S);
    for i := 1 to S do Q^.p[i] := incref (P^.p[i]);
    decref (P);
    P := Q
  end;
  read_builtin := P
end;

function read_expr7 : PNode;  (*  id const ( ) [ ] { } *)
var S, RS, i : integer;  P, Q : PNode;
begin
  read_expr7 := nil;
  case L of
  _VertBar:
         begin
           read_expr7 := ReadPattern (2);
           getlexem;
         end;
  _QuotedStr:
         begin
           read_expr7 := newstring (LS);
           getlexem
         end;
  _Id:   begin
           if (LV = 0) or ((symt[LV] = 0) and (rexprmd = 0)) then begin
             {CfgError ('undefined identifier `'+LS+'''');}
             read_expr7 := newstring (LS);
             getlexem;
           end
           else if symt[LV] = 2 then
             begin read_expr7 := mklocvar (LV); getlexem end
           else begin
             if rexprmd = 1 then S := 31 else S := symv[LV];
             P := newnode (__Var, S + 1);  RS := 0;
             P^.a[1] := LV;
             getlexem;
             if S > 0 then
               if L = _OpBr then begin
                 i := 0;
                 repeat
                   inc (i);
                   getlexem;
                   P^.p[i+1] := read_expr;
                   if i = S then break;
                 until (i = S) or (L <> _Comma);
                 if (i < S) and (S < 31) then CfgError (''','' expected');
                 RS := i;
                 if L <> _ClBr then CfgError (''')'' expected');
                 getlexem
               end else
               if S < 31 then
               begin RS := S;  for i := 1 to S do P^.p[i+1] := read_expr end
               else RS := 0;
             if S <> RS then begin
               Q := newnode (__Var, RS + 1);
               for i := 1 to RS + 1 do
                 begin Q^.a[i] := P^.a[i];  P^.a[i] := 0 end;
               delnode (P);
               P := Q;
             end;
             read_expr7 := P
           end
         end;
  _Cat:  read_expr7 := read_builtin (__CatStr, 1, MaxCNA);
  _OpBr: begin
           getlexem;
           read_expr7 := read_expr;
           if L <> _ClBr then CfgError (''')'' expected');
           getlexem
         end;
  _OpBrk:begin
           getlexem;
           S := LStkSP;
           if L <> _ClBrk then begin
             lpush (read_expr);
             if L = _Comma then
               repeat
                 getlexem;
                 lpush (read_expr)
               until L <> _Comma
             else while L <> _ClBrk do lpush (read_expr)
           end;
           if L <> _ClBrk then CfgError (''']'' expected');
           getlexem;
           P := newnode (__List, LStkSP - S);
           for i := 1 to LStkSP - S do
             P^.p[i] := LStk[S+i];
           LStkSP := S;
           read_expr7 := P
         end;
  _OpBrc:begin
           getlexem;
           read_expr7 := ReadContext;
           if L <> _ClBrc then CfgError ('''}'' expected');
           getlexem
         end;
  _For:  begin
           getlexem;
           P := newnode (__For, 4);
           if L = _OpBr then begin
             getlexem;
             if (L <> _Id) or not MbLocVar(LS) then
               CfgError ('Variable identifier expected');
             if LV = 0 then LV := searchid (LS, 1);
             P^.a[1] := LV;
             if getlexem <> _Comma then CfgError (''','' expected');
             getlexem;
             P^.p[3] := read_expr;
             if L <> _Comma then CfgError (''','' expected');
             getlexem;
             ReadFor (P);
             if L <> _ClBr then CfgError (''')'' expected');
             getlexem;
           end else begin
             if (L <> _Id) or not MbLocVar(LS) then
               CfgError ('Variable identifier expected');
             if LV = 0 then LV := searchid (LS, 1);
             P^.a[1] := LV;
             if getlexem <> _In then CfgError ('''in'' expected');
             getlexem;
             P^.p[3] := read_expr3a;
             if L <> _Do then CfgError ('''do'' expected');
             getlexem;
             ReadFor (P);
             if L <> _Od then CfgError ('''od'' expected');
             getlexem
           end;
           read_expr7 := P
         end;
  _If:   begin
           getlexem;
           P := newnode (__Cond, 3);
           P^.p[1] := read_expr;
           if L <> _Then then CfgError ('''then'' expected');
           getlexem;
           P^.p[2] := read_expr;
           if L = _Else then begin
             getlexem;
             P^.p[3] := read_expr
           end;
           if L <> _Fi then CfgError ('''fi'' expected');
           getlexem;
           read_expr7 := P
         end;
  _True: begin getlexem; read_expr7 := newbool (true) end;
  _False:begin getlexem; read_expr7 := newbool (false) end;
  else CfgError ('identifier expected')
  end
end;


function read_expr6 : PNode;  {.}
var P, Q : PNode; oldm : integer;
begin
  P := read_expr7;
  oldm := rexprmd;
  while L = _Dot do begin
    getlexem;  rexprmd := 1;
    Q := read_expr7;
    P := mkbinop (__Dot, P, Q)
  end;
  rexprmd := oldm;
  read_expr6 := P
end;


function read_expr5 : PNode;  {*}
var P, Q : PNode;
begin
  P := read_expr6;
  while L = _Times do begin
    getlexem;
    Q := read_expr6;
    P := mkbinop (__Times, P, Q)
  end;
  read_expr5 := P
end;

function read_expr4 : PNode;  {+ -}
var P, Q : PNode;  T : TNode;
begin
  P := read_expr5;
  while L in [_Plus, _Minus] do begin
    if L = _Plus then T := __Plus else T := __Minus;
    getlexem;
    Q := read_expr5;
    P := mkbinop (T, P, Q)
  end;
  read_expr4 := P
end;

function read_expr3a : PNode; { .. }
var P, Q : PNode;
begin
  P := read_expr4;
  if L = _DotDot then begin
    getlexem;
    Q := read_expr4;
    P := mkbinop (__Range, P, Q)
  end;
  read_expr3a := P
end;


function read_expr3 : PNode;  {relop in}
var P, Q : PNode; T : TNode;
begin
  P := read_expr3a;
  while L in [_In, _Equal, _NotEqual, _Less, _Greater, _LEq, _GEq] do begin
    case L of
    _In:        T := __In;
    _Equal:     T := __Equal;
    _NotEqual:  T := __NotEqual;
    _Less:      T := __Less;
    _Greater:   T := __Greater;
    _LEq:       T := __LEq;
    _GEq:       T := __GEq
    else        T := __List
    end;
    getlexem;
    Q := read_expr3a;
    P := mkbinop (T, P, Q)
  end;
  read_expr3 := P
end;

function read_expr2 : PNode;  {not}
begin
  if L = _Not then begin
    getlexem;
    read_expr2 := mkunop (__Not, read_expr2)
  end else read_expr2 := read_expr3
end;

function read_expr1 : PNode;  {and}
var P, Q : PNode;
begin
  P := read_expr2;
  while L = _And do begin
    getlexem;
    Q := read_expr2;
    P := mkbinop (__And, P, Q)
  end;
  read_expr1 := P
end;


function read_expr : PNode;  {or, xor}
var P, Q : PNode;  T : TNode;
begin
  P := read_expr1;
  while L in [_Or, _Xor] do begin
    if L = _Or then T := __Or else T := __Xor;
    getlexem;
    Q := read_expr1;
    P := mkbinop (T, P, Q)
  end;
  read_expr := P
end;

{---------------- "pattern" parser ----------------}

function ReadPattern (mode : integer): PNode;
const MaxS = 32;
var
  S, i   : integer;
  T      : string;
  PQ     : array [1..MaxS] of PNode;
  P, Q   : PNode;
begin
  skipspc;
  S := 0;  T := '';
  while not (RP^ in [';',#13,#10,#4,#0]) and ((mode <> 1) or (RP^ <> ' '))
  and ((mode <> 2) or (RP^ <> '|')) do
    if RP^ <> '$' then begin T := T + RP^; inc (RP) end
    else begin
      inc (RP);
      case RP^ of
      '$',';','|': begin T := T + RP^; inc (RP) end;
      '(': begin
             inc (RP);
             if T <> '' then
               begin inc (S);  PQ[S] := newstring (T);  T := '' end;
             getlexem;
             Q := read_expr;
             if L <> _ClBr then CfgError (''')'' expected');
             inc (S);  PQ[S] := Q
           end;
      'A'..'Z','a'..'z':
           begin
             if T <> '' then
               begin inc (S);  PQ[S] := newstring (T);  T := '' end;
             repeat T := T + RP^; inc (RP)
             until not (RP^ in ['A'..'Z','a'..'z']);
             i := searchid (T, 0);  LS := T;  T := '';
             if (i = 0) or (symt[i] = 0) then
               CfgError ('undefined identifier');
             if symt[i] = 2 then Q := mklocvar (i)
             else begin
               if symv[i] > 0 then CfgError ('error in pattern');
               Q := newnode (__Var, 1);
               Q^.a[1] := i;
             end;
             inc (S);  PQ[S] := Q
           end
      else CfgError ('invalid character after ''$'' in pattern')
      end;
      if S >= MaxS - 1 then cfgerror ('pattern too complex');
    end;
  if (mode = 2) and (RP^ = '|') then inc (RP);
  if T <> '' then
    begin inc (S);  PQ[S] := newstring (T);  T := '' end;
  if S = 0 then P := newstring ('')
  else if S = 1 then P := PQ[1] else
  begin
    P := newnode (__CatStr, S);
    for i := 1 to S do
      P^.p[i] := PQ[i];
  end;
  ReadPattern := P
end;

{---------------- Context parser ------------------}

procedure AnswerQuestion;
var P, Q : PNode;
begin
  if L <> _Question then CfgError ('''?'' expected');
  getlexem;
  P := read_expr;
{  writeln ('**** in AnswerQuestion ****');
  writeln ('P = '); dumpnode (P);}
{  writeln ('CC = '); dumpnode (CC);}
  Q := Eval (P, CC, nil);
{  writeln ('Q = '); dumpnode (Q);}
  decref (P);
  Print (Q);
  decref (Q)
end;

procedure ReadFor (P : PNode);
var id : integer;
begin
  id := P^.a[1];
  enter_lexlevel (1);
  deflocvar (id, 1);
  P^.a[2] := frlev;
  P^.p[4] := read_expr;
  leave_lexlevel;
end;


function read_assign : PNode;  { f = expr; f x y = expr; f(x,y) = expr }
const MaxArgs = 16;
var
  id, arity, lvars, keep_glev  : integer;
  args                         : array [1..MaxArgs] of PNode;

procedure readarg;
begin
  if arity = maxargs then CfgError ('too many arguments');
  if (L = _QuotedStr) or ((L = _Id) and not MbLocVar(LS)) then
  begin
    inc (arity);
    args[arity] := newstring (LS);
    getlexem;
  end
  else if L = _Id then begin
    if LV = 0 then LV := searchid (LS, 1);
    inc (arity);
    if lvars = 0 then enter_lexlevel (1);
    inc (lvars);
    deflocvar (LV, lvars);
    args[arity] := mklocvar (LV);
    getlexem
  end else CfgError ('variable identifier or '':='' expected');
end;

var P, Q : PNode; i : integer; CL : Lexem;
begin
  if L <> _Id then CfgError ('identifier expected');
  id := searchid (LS, 1);  arity := 0;  lvars := 0;
  getlexem;
  keep_glev := glev;
  if L = _OpBr then begin
    getlexem;
    readarg;
    while L = _Comma do begin getlexem; readarg end;
    if L <> _ClBr then CfgError (''')'' expected');
    getlexem
  end else while not (L in [_Equal, _Let, _PlusEqual]) do readarg;
  if not (L in [_Equal, _Let, _PlusEqual]) then CfgError (''':='' expected');
  if (symt[id]=1) and (symd[id]=keep_glev) and (symv[id]<>arity) then
    CfgError ('number of arguments changed');
  CL := L;
  if L <> _Let then
    begin getlexem; Q := read_expr end
  else begin Q := ReadPattern(0); getlexem end;
  if lvars > 0 then leave_lexlevel;
  defvar (id, arity);
  P := newnode (__Assign, arity + 4);
    { <id> <locvars> <lexlev> <rs> <arg1> .. <argN> }
  if CL = _PlusEqual then P^.t := __AddAssign;
  P^.a[1] := id;
  P^.a[2] := lvars;
  P^.a[3] := frlev + ord (lvars > 0);
  P^.p[4] := Q;
  for i := 1 to arity do P^.p[i+4] := args[i];
  read_assign := P
end;

function ReadContext : PNode;
var P, Q : PNode;
begin
  while L = _Semicolon do getlexem;
  while L = _Question do AnswerQuestion;
  if L <>_Id then begin ReadContext := incref (CC); exit end;
  enter_lexlevel (0);
  Q := read_assign;
  P := newnode (__Context, 3);
  P^.p[1] := nil;
  P^.p[2] := incref (CC);
  P^.p[3] := Q;
  CS := P;  CC := P;
  while L = _Semicolon do getlexem;
  while L in [_Id, _Question] do begin
    if L = _Question then AnswerQuestion else
    begin
      Q := read_assign;
      P := newnode (__Context, 3);
      P^.p[1] := CC;
      P^.p[2] := incref (CS^.p[2]);
      P^.p[3] := Q;
      CC := P
    end;
    while L = _Semicolon do getlexem;
  end;
  P := CC;
  leave_lexlevel;
  CC := CS^.p[2];
  CS := CC;
  if CS <> nil then
    while CS^.p[1] <> nil do CS := CS^.p[1];
  ReadContext := P
end;

{------------------ Interpreter ---------------------}

function isnum (P : PNode) : boolean;
var v : longint; k : integer;
begin
  isnum := false;
  if P^.t <> __String then exit;
  val (getpchar (P), v, k);
  isnum := (k = 0) and (v = v)
end;

function numval (P : PNode) : longint;
var v : longint; k : integer;
begin
  if P^.t <> __String then runerror (239);
  val (getpchar (P), v, k);
  if k <> 0 then CfgError ('Number expected in arithmetic expression');
  numval := v
end;

function newnum (x : longint) : PNode;
var S : string;
begin
  str (x, S);
  newnum := newstring (S)
end;

function xnewnum (x : longint; P : PNode) : PNode;
var S : string;
begin
  str (x, S);
  if (P <> nil) and (P^.t = __String) and (P^.N > 0) and (P^.c[0] = '0') and (x >= 0) then
    while (length(S) < P^.N) and (length(S) < 255) do S := '0' + S;
  xnewnum := newstring (S)
end;

function EvalCons (P1, P2 : PNode) : PNode;
var x, y, i : integer;
    P       : PNode;
begin
  if P1 = nil then begin EvalCons := P2; exit end;
  if P2 = nil then begin EvalCons := P1; exit end;
  if P1^.t = __List then x := P1^.N else x := 1;
  if P2^.t = __List then y := P2^.N else y := 1;
  if x + y > MaxCNA then CfgError ('List too long');
  P := newnode (__List, x + y);
  if P1^.t = __List then begin
    for i := 1 to x do P^.p[i] := incref(P1^.p[i]);
    decref (P1)
  end else P^.p[1] := P1;
  if P2^.t = __List then begin
    for i := 1 to y do P^.p[x+i] := incref(P2^.p[i]);
    decref (P2)
  end else P^.p[x+1] := P2;
  EvalCons := P
end;

function EvalPlus (P1, P2 : PNode) : PNode;
var v1, v2 : longint;
begin
  if isnum (P1) and isnum (P2) then begin
    v1 := numval (P1);
    v2 := numval (P2);  decref(P2);
    if (v1 >= 0) and (v2 >= 0) then
         EvalPlus := xnewnum (v1 + v2, P1)
    else EvalPlus := newnum (v1 + v2);
    decref(P1);
  end else EvalPlus := EvalCons (P1, P2);
end;

function EvalMinus (P1, P2 : PNode) : PNode;
var v1, v2 : longint;
begin
  v1 := numval (P1);  decref(P1);
  v2 := numval (P2);  decref(P2);
  EvalMinus := newnum (v1 - v2)
end;

function EvalTimes (P1, P2 : PNode) : PNode;
var v1, v2 : longint;
begin
  v1 := numval (P1);  decref(P1);
  v2 := numval (P2);  decref(P2);
  EvalTimes:= newnum (v1 * v2)
end;

function EvalBool (md : integer; P1, P2 : PNode) : PNode;
var v : integer;
begin
  v := ord (getbool (P1)) shl 1 + ord (getbool (P2));
  decref (P1);  decref (P2);
  EvalBool := newbool (odd (md shr v))
end;

function EvalNot (P : PNode) : PNode;
begin
  EvalNot := newbool (not getbool (P));
  decref (P)
end;


function DoCmp (P, Q : PNode) : integer;
var
  S1, S2        : String;
  a, b, s, m, i : integer;
  v1, v2        : longint;
begin
  DoCmp := 0;
  if P = Q then exit;
  if P = nil then begin DoCmp := -1; exit end;
  if Q = nil then begin DoCmp := 1; exit end;
  if (P^.t = __String) and (Q^.t = __String) then begin
    S1 := getstring (P);
    S2 := getstring (Q);
    val (S1, v1, i); if i = 0 then begin
      val (S2, v2, i); if i = 0 then begin
        if v1 = v2 then DoCmp := 0 else
        if v1 < v2 then DoCmp := -1 else DoCmp := 1;
        exit
      end
    end;
    if S1 = S2 then DoCmp := 0 else
    if S1 < S2 then DoCmp := -1 else DoCmp := 1;
    exit
  end;
  if (P^.t = __List) and (Q^.t = __List) then begin
    a := P^.N;  b := Q^.N;
    if a < b then m := a else m := b;
    for i := 1 to m do begin
      s := DoCmp (P^.p[i], Q^.p[i]);
      if s <> 0 then begin DoCmp := s; exit end;
    end;
    if a = b then DoCmp := 0
    else if a < b then DoCmp := -1 else DoCmp := 1;
    exit
  end;
  CfgError ('Cannot compare expressions of such types');
end;


function EvalCmp (md : integer; P1, P2 : PNode) : PNode;
var sgn : integer;
begin
  sgn := DoCmp (P1, P2);
  decref (P1);
  decref (P2);
  EvalCmp := newbool (odd (md shr succ(sgn)))
end;

function EvalRange (P1, P2 : PNode) : PNode;
var v1, v2, i, j, L : longint; S1, S2 : string; P : PNode;
begin
  S1 := getstring (P1);
  S2 := getstring (P2);
  if isnum (P1) and isnum (P2) then begin
    v1 := numval (P1);  decref (P1);
    v2 := numval (P2);  decref (P2);
    if (length (S1) > length (S2)) or (v1 > v2) then
      begin EvalRange := nil; exit end;
    L := v2 - v1 + 1;
    if L > MaxCNA then CfgError ('List too long');
    P := newnode (__List, L);
    for i := 1 to L do begin
      P^.p[i] := newstring (S1);
      j := length (S1);
      while (j > 0) and (S1[j] = '9') do begin S1[j] := '0'; dec (j) end;
      if j = 0 then S1 := '1' + S1 else inc (S1[j])
    end;
    EvalRange := P
  end
  else begin
    if (length (S1) <> 1) or (length (S2) <> 1) then
      CfgError ('invalid range syntax');
    decref (P1);  decref (P2);
    if S1 > S2 then begin EvalRange := nil; exit end;
    L := ord (S2[1]) - ord (S1[1]) + 1;
    if L > MaxCNA then CfgError ('List too long');
    P := newnode (__List, L);
    for i := 1 to L do P^.p[i] := newstring (chr(ord(S1[1])+i-1));
    EvalRange := P
  end
end;

function MkClosure (Context, Env : PNode) : PNode;
var R : PNode;
begin
  R := newnode (__Closure, 3);
  R^.p[1] := incref (Context);
  R^.p[2] := incref (Env);
  R^.p[3] := nil;
  MkClosure := R
end;

function getloc (Env : PNode; dp, ps : integer) : PNode;
begin
  if (dp < 0) or (ps <= 0) then runerror (239);
  while dp >= 0 do begin
    if Env = nil then CfgError ('value depends on undefined variables');
    dec (dp);
    if dp >= 0 then Env := Env^.p[2]
  end;
  if ps > Env^.N - 2 then runerror (239);
  getloc := Env^.p[ps + 2]
end;

function newenv (E : PNode; d, s : integer) : PNode;
var P : PNode;
begin
  if s = 0 then begin
    while (E <> nil) and (E^.a[1] > d) do E := E^.p[2];
    newenv := incref(E); exit
  end;
  while (E <> nil) and (E^.a[1] >= d) do E := E^.p[2];
  P := newnode (__Env, s + 2);
  P^.a[1] := d;
  P^.p[2] := incref (E);
  newenv := P
end;

function matcharg (P, Q : PNode) : boolean;
var S1, S2 : string;
begin
  if Q^.t = __LocVar then begin matcharg := true; exit end;
  if P^.t <> __String then begin matcharg := false; exit end;
  S1 := getstring (P);
  S2 := getstring (Q);
  matcharg := (S1 = S2)
end;

function matchargs (S, P : PNode) : boolean;
var i : integer;
begin
  if (P = nil) or (P^.N = 0) then begin
    matchargs := (S^.N - 4 = 0); exit end;
  if (P^.N <> S^.N - 4) then begin matchargs := false; exit end;
  for i := 1 to P^.N do
    if not matcharg (P^.p[i], S^.p[i+4]) then
      begin matchargs := false; exit end;
  matchargs := true
end;

function EvalFunc (Expr, Context, Env : PNode) : PNode;
var
  C, Q, R, S, T, E, PC     : PNode;
  F                        : boolean;
  i, N, id                 : integer;
begin
  if Expr^.t <> __Var then runerror (239);
  C := Context;
  if C^.t = __Closure then
    begin Env := C^.p[2];  C := C^.p[1] end;
  id := Expr^.a[1];  N := Expr^.N - 1;
  if N > 0 then Q := newnode (__List, N) else Q := nil;
  for i := 1 to N do Q^.p[i] := Eval (Expr^.p[i+1], Context, Env);
  R := nil;  F := false;
  while C <> nil do begin
    PC := C^.p[1];
    if PC = nil then PC := C^.p[2];
    S := C^.p[3];
    if (S^.t in [__Assign, __AddAssign]) and (S^.a[1] = id)
    and MatchArgs (S, Q) then begin
      E := newenv (Env, S^.a[3], S^.a[2]);
      if Q <> nil then
        for i := 1 to Q^.N do with S^.p[i+4]^ do
          if t = __LocVar then E^.p[a[3]+2] := incref(Q^.p[i]);
      T := Eval (S^.p[4], PC, E);
      decref (E);
      if T <> nil then
        if R = nil then R := T else begin
          R := mkbinop (__List, T, R);
          F := true
        end;
      if (S^.t = __Assign) and (R <> nil) then break;
    end;
    if (C^.p[1] = nil) and (R <> nil) then break;
    C := PC
  end;
  decref (Q);
  if F then begin T := Eval (R, nil, nil); decref(R); R := T end;
  EvalFunc := R
end;

var EvalCnt : longint;

function Eval (Expr, Context, Env : PNode) : PNode;
function getarg (x : integer) : PNode;
begin
  if (x <= 0) or (x > Expr^.N) then runerror (239);
  getarg := Eval (Expr^.p[x], Context, Env)
end;

function EvalList : PNode;
var N, i, j, z  : integer;
    Q, R        : PNode;
    F           : boolean;
begin
  if Expr^.t <> __List then runerror (239);
  N := Expr^.N;
  Q := newnode (__List, N);
  F := true;
  for i := 1 to N do begin
    Q^.p[i] := Eval (Expr^.p[i], Context, Env);
    F := F and (Q^.p[i] <> nil) and (Q^.p[i] = Expr^.p[i]) and (Q^.p[i]^.t <> __List)
  end;
  if F then begin
    for i := 1 to N do decref (Q^.p[i]);
    EvalList := incref (Expr)
  end else begin
    z := 0;
    for i := 1 to N do if Q^.p[i] <> nil then
      with Q^.p[i]^ do if t <> __List then inc(z) else inc(z,N);
    if z > MaxCNA then CfgError ('List too long');
    R := newnode (__List, z);
    z := 0;
    for i := 1 to N do if Q^.p[i] <> nil then
      with Q^.p[i]^ do
        if t <> __List then
          begin inc(z); R^.p[z] := Q^.p[i] end
        else begin
          for j := 1 to N do begin inc(z); R^.p[z] := incref(p[j]) end;
          decref (Q^.p[i])
        end;
    EvalList := R
  end;
  i_delnode (Q);
end;

function EvalCatStr : PNode;
var N, i, j, z  : integer;
    Q, R        : PNode;
begin
  if Expr^.t <> __CatStr then runerror (239);
  N := Expr^.N;
  Q := newnode (__List, N);
  for i := 1 to N do
    Q^.p[i] := Eval (Expr^.p[i], Context, Env);
  z := 0;
  for i := 1 to N do if Q^.p[i] <> nil then with Q^.p[i]^ do
    if t = __String then inc (z, N)
    else if t <> __List then runerror (239)
    else for j := 1 to N do
           if p[j]^.t <> __String then runerror (239) else inc (z, p[j]^.N);
  R := newnode (__String, z);
  z := 0;
  for i := 1 to N do if Q^.p[i] <> nil then with Q^.p[i]^ do
    if t = __String then begin move (c[0], R^.c[z], N); inc (z, N) end
    else if t <> __List then runerror (239)
    else for j := 1 to N do
           if p[j]^.t <> __String then runerror (239) else with p[j]^ do
             begin move (c[0], R^.c[z], N); inc (z, N) end;
  decref (Q);
  EvalCatStr := R
end;

function EvalDot (C, E : PNode) : PNode;
var v : integer;
begin
{  writeln ('** in EvalDot **');
  writeln ('C='); dumpnode (C);
  writeln ('Expr='); dumpnode (E);}
  EvalDot := nil;
  if C = nil then exit;
  if C^.t = __List then begin
    E := Eval (E, Context, Env);
    if isnum (E) then begin
      v := numval (E);
      if (v > 0) and (v <= C^.N) then EvalDot := incref (C^.p[v]) else
      if (v < 0) and (v >= -C^.N) then EvalDot := incref (C^.p[C^.N+v+1])
                                  else EvalDot := nil
    end else CfgError ('Numeric expression expected');
    decref (E);  decref (C);
    exit
  end;
  if C^.t <> __Closure then
    CfgError ('Context expected');
  EvalDot := Eval (E, C^.p[1], C^.p[2]);
  decref (C);
end;

function EvalFor : PNode;
var
  i           : integer;
  L, R, E, Ev : PNode;
begin
  L := getarg(3);
  if L = nil then begin EvalFor := nil; exit end;
  if L^.t <> __List then CfgError ('list required in `for''');
  R := newnode (__List, L^.N);
  E := Expr^.p[4];
  for i := 1 to L^.N do begin
    Ev := newenv (Env, Expr^.a[2], 1);
    Ev^.p[3] := incref (L^.p[i]);
    R^.p[i] := Eval (E, Context, Ev);
    decref (Ev)
  end;
  decref (L);
  EvalFor := Eval (R, Context, Env);
  decref (R)
end;

function EvalCond (C, E1, E2 : PNode) : PNode;
begin
  if not getbool(C) then E1 := E2;
  decref (C);
  EvalCond := Eval (E1, Context, Env)
end;

var R : PNode;
begin
  inc (EvalCnt);
  if Expr = nil then begin Eval := nil; exit end;
  R := nil;
  case Expr^.t of
  __Closure, __String:  R:=incref(Expr);
  __LocVar:  R := incref(getloc (Env, Expr^.a[2], Expr^.a[3]));
  __Var:     R := EvalFunc (Expr, Context, Env);
  __Context: R := MkClosure (Expr, Env);
  __List:    R := EvalList;
  __Plus:    R := EvalPlus (getarg(1), getarg(2));
  __Minus:   R := EvalMinus (getarg(1), getarg(2));
  __Times:   R := EvalTimes (getarg(1), getarg(2));
  __CatStr:  R := EvalCatStr;
  __Dot:     R := EvalDot (getarg(1), Expr^.p[2]);
  __Range:   R := EvalRange (getarg(1), getarg(2));
  __For:     R := EvalFor;
  __Cond:    R := EvalCond (getarg(1), Expr^.p[2], Expr^.p[3]);
  __Equal:   R := EvalCmp (2, getarg(1), getarg(2));
  __NotEqual:R := EvalCmp (5, getarg(1), getarg(2));
  __Less:    R := EvalCmp (1, getarg(1), getarg(2));
  __Greater: R := EvalCmp (4, getarg(1), getarg(2));
  __LEq:     R := EvalCmp (3, getarg(1), getarg(2));
  __GEq:     R := EvalCmp (6, getarg(1), getarg(2));
  __And:     R := EvalBool ($8, getarg(1), getarg(2));
  __Or:      R := EvalBool ($e, getarg(1), getarg(2));
  __Xor:     R := EvalBool ($6, getarg(1), getarg(2));
  __Not:     R := EvalNot (getarg(1));
  else CfgError ('Unable to evaluate expression');
  end;
  if (R <> nil) and (R^.t = __Context) then
    R := MkClosure (R, Env);
  Eval := R
end;

{---------------- output -----------------}

procedure i_print (P : PNode);
var i, l : integer;
begin
  if P = nil then begin write ('nil'); exit end;
  case P^.t of
  __String : write (getpchar (P));
  __List:    begin
               write ('[');  l := P^.N;
               if l > 0 then i_print (P^.p[1]);
               for i := 2 to l do begin write (' '); i_print (P^.p[i]) end;
               write (']')
             end;
  else write ('?')
  end;
end;

procedure Print (P : PNode);
begin
  i_print (P);
  writeln
end;

procedure ShowCfgStats;
begin
  decref (keep_true);  decref (keep_false);
  writeln ('Allocated: ', onwb, ' bytes in ', onw, ' blocks');
  writeln ('Released:  ', onwb-ocb, ' bytes in ', onw-oc, ' blocks');
  writeln ('Kept:      ', ocb, ' bytes in ', oc, ' blocks');
  writeln ('EVAL: executed ', EvalCnt, ' times');
  incref (keep_true);  incref (keep_false);
end;

{-------------- object-oriented interface -----------}

function convpnode (P : PNode; T : TCfgObjType; const Org : string):PCfgObject;
var Q : PCfgObject;
begin
  Q := nil;
  if P = nil then
    case T of
    _NULL_:   Q := new (PCfgObject, newobjo (P, Org));
    _STRING_: Q := new (PCfgString, newobjo (P, Org));
    _LIST_:   Q := new (PCfgList, newobjo (P, Org));
    _CONTEXT_:Q := new (PCfgContext, newobjo (P, Org))
    end
  else
    case P^.t of
    __String: Q := new (PCfgString, newobjo (P, Org));
    __List:   Q := new (PCfgList, newobjo (P, Org));
    __Context, __Closure:
              Q := new (PCfgContext, newobjo (P, Org))
    else Q := new (PCfgObject, newobjo (P, Org))
    end;
  convpnode := Q
end;

constructor TCfgObject.newobj (Ptr : pointer);
var Q : PNode;
begin
  Q := Ptr;  P := nil;  Origin := '';
  if (Q <> nil) and not ((Q^.refcnt > 0) and (Q^.refcnt < 1000) and
     (Q^.t in [__String, __List, __Context, __Closure])) then runerror (239);
  P := Ptr;
end;

constructor TCfgObject.newobjo (Ptr : pointer; const Org : string);
var Q : PNode;
begin
  Q := Ptr;  P := nil;  Origin := Org;
  if (Q <> nil) and not ((Q^.refcnt > 0) and (Q^.refcnt < 1000) and
     (Q^.t in [__String, __List, __Context, __Closure])) then runerror (239);
  P := Ptr;
end;

destructor TCfgObject.delobj;
var Q : PNode;
begin
  Q := P;  decref (Q);  Origin := '';  P := nil
end;

function TCfgObject.gettype : TCfgObjType;
begin gettype := _NULL_ end;

function TCfgObject.isnil : boolean;
begin isnil := (P = nil) end;

procedure TCfgObject.dump;
begin dumpnode (PNode (P)) end;

procedure TCfgObject.print;
begin TestSysReadCfg.print (PNode (P)) end;

procedure TCfgObject.raiseerr (const Msg : string);
var S : string;
begin
  if Origin <> '' then S := Msg + ' at ' + Origin else S := Msg;
  raise CfgParseException.Create (S);
  runerror (244)
end;


constructor TCfgString.newstr (S : string);
begin TCfgObject.newobj (newstring (S)) end;

function TCfgString.getstr : string;
begin
  if P = nil then getstr := '<nil>'
             else getstr := getstring (PNode (P))
end;

function TCfgString.getint : longint;
var c : integer;
begin
  if P = nil then Result := INVALID_NUM
  else begin
    val (getstring (PNode (P)), Result, c);
    if c <> 0 then Result := INVALID_NUM
  end
end;

function TCfgString.gettype : TCfgObjType;
begin gettype := _STRING_ end;

constructor TCfgList.newlist (var A : array of PCfgObject);
var Q : PNode;  i : integer;
begin
  Q := newnode (__List, High(A)-Low(A)+1);
  for i := Low(A) to High(A) do
    Q^.p[i-Low(A)+1] := incref (A[i]^.p);
  P := Q
end;

function TCfgList.gettype : TCfgObjType;
begin gettype := _LIST_ end;

function TCfgList.len : integer;
begin if P = nil then len := 0 else len := PNode(P)^.N end;

function TCfgList.getel (x : integer) : PCfgObject;
begin
  if (P = nil) or (x = 0) or (abs(x) > PNode(P)^.N) then
    begin getel := convpnode (nil, _NULL_, format ('%s.%d', [Origin, x]));
          exit end;
  if x < 0 then inc (x, PNode(P)^.N + 1);
  getel := convpnode (incref (PNode(P)^.p[x]), _NULL_,
                        format ('%s.%d', [Origin, x]))
end;

function TCfgContext.gettype : TCfgObjType;
begin gettype := _CONTEXT_ end;

function TCfgContext.evalvar (S : string) : PCfgObject;
var id : integer;  Q, R : PNode;
begin
  R := nil;
  id := searchid (S, 0);
  if id > 0 then begin
    Q := newnode (__Var, 1);
    Q^.a[1] := id;
    try R := Eval (Q, PNode(P), nil);
    except on E : CfgException do raiseerr (E.Message)
    end;
    decref (Q)
  end;
  evalvar := convpnode (R, _LIST_, Origin + '.' + S)
end;

function TCfgObject.check : boolean;
var Q : PNode;
begin
  Q := PNode (P);
  if (Q <> nil) and ((Q^.refcnt <= 0) or (Q^.refcnt > 1000)) then
    begin check := false; exit end;
  check := true
end;

function TCfgString.check : boolean;
begin
  check := (P = nil) or (TCfgObject.check and (PNode(P)^.t = __String))
end;

function TCfgList.check : boolean;
begin
  check := (P = nil) or (TCfgObject.check and (PNode(P)^.t = __List))
end;

function TCfgContext.check : boolean;
begin
  check := (P = nil) or (TCfgObject.check and
           (PNode(P)^.t in [__Context, __Closure]))
end;

function TCfgObject.obj : PCfgObject;
begin obj := PCfgObject (PChar(@P)) end;

function TCfgObject.tostr : PCfgString;
begin
  if (P = nil) or (PNode(P)^.t <> __String) then
    raiseerr ('string required');
  tostr := PCfgString (obj)
end;

function TCfgObject.tolist : PCfgList;
begin
  if (P <> nil) and (PNode(P)^.t <> __List) then
    raiseerr ('list required');
  tolist := PCfgList (obj)
end;

function TCfgObject.tocontext : PCfgContext;
begin
  if (P = nil) or not (PNode(P)^.t in [__Context, __Closure]) then
    raiseerr ('context required');
  tocontext := PCfgContext (obj)
end;

procedure TCfgObject.destroy;
begin
  dispose (obj, delobj)
end;


function ReadConfig (FileName : String) : PCfgContext;
var P : PNode;
begin
  try
    OpenCfg (FileName);
    getlexem;
    P := ReadContext;
    if L <> _EOF then CfgError ('Syntax error');
    ReadConfig := new (PCfgContext, newobjo (P, {FileName+':'}''))
  except
  on CfgException do ReadConfig := nil
  end
end;

procedure DelCfgObj (O : PCfgObject);
begin
  if O <> nil then dispose (O, delobj);
end;

begin
end.