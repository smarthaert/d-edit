program RAL;
{ Russian Algoritmic Language Interpreter }
{DEFINE Debug}
uses
 Crt;

procedure Main;

const
  BufSize=10;
  StringLen=90;
  IdentLen=5;
  ParamsMaxNum=5;
label
  RepeatThis;
type
  TFloat=real;
  TString=string;
  TextString=string[StringLen];
  MessageString=string[80];
  PText=^TText;
  TText=record
         Data:array [1..BufSize] of TextString;
         Next,Prev:PText;
        end;
  TIdentifier=string[IdentLen];
  PIdentifier=^TIdentifier;
  PNumVar=^TNumVar;
  TNumVar=record
           Ident:TIdentifier;
           Value:TFloat;
           Next:PNumVar;
          end;
  TRealArray=array [0..255] of TFloat;
  PRealArray=^TRealArray;
  PNumArr=^TNumArr;
  TNumArr=record
           Ident:TIdentifier;
           BegIdx,EndIdx:byte;
           Values:PRealArray;
           Next:PNumArr;
          end;
  PSymbVar=^TSymbVar;
  TSymbVar=record
           Ident:TIdentifier;
           Value:TString;
           Next:PSymbVar;
          end;
  TStrArray=array [0..250] of TString;
  PStrArray=^TStrArray;
  PSymbArr=^TSymbArr;
  TSymbArr=record
           Ident:TIdentifier;
           BegIdx,EndIdx:byte;
           Values:PStrArray;
           Next:PSymbArr;
          end;
  TParamTypes=string[ParamsMaxNum];
  PCycle=^TCycle;
  TCycle=record
         CType:byte;
         StartLine:word;
         FinishLine:word;
         Prev:PCycle;
        end;
const
  otNone  = 0;
  otCicle = 1;
  otProc  = 2;
  ctOperator  = 1;
  ctProcedure = 2;
  ctAssigment = 3;
  vtmArray    = 2;
  vtmVariable = 0;
  vtmSymb     = 1;
  vtNumVar    = 0;
  vtNumArray  = 2;
  vtSymbVar   = 1;
  vtSymbArray = 3;
  ct_Any      = 0;
  ct_If       = 1;
  ct_For      = 2;
  ct_Repeat   = 3;
  ct_While    = 4;
  emBrktNotFound: String[28]= 'Пропущена открывающая скобка';
  emClBrktNotFound: String[28] = 'Пропущена закрывающая скобка';
  emIndexOutOfRange: String[20] = 'Индекс вне диапазона';
  emInvalidIndex: String[13] = 'Плохой индекс';
  emNoParameters: String[19] = 'Не заданы параметры';
  emTypeMismatch: String[20] = 'Несоответствие типов';
  emEndWithoutBegin: String[22] = 'Конец без начала';
  emSyntaxError: String[21] = 'Синтаксическая ошибка';
  emNoQuote: String[17] = 'Пропущена кавычка';
  emArgumentOutOfRange: String[22] = 'Аргумент вне диапазона';
  OpsNum = 10;
  Operators :array [1..OpsNum] of String[5] =
             ('алг','нач','кон','если','иначе','кесли','пока','цикл','кцикл',
              'при');
  PrsNum = 2;
  Procedures:array [1..PrsNum] of String[6]=
             ('вывод','запрос');
  FuncNum = 9;
  Functions:array [1..FuncNum] of String[4]=
             ('sin','cos','tg','sign','int','sqr','ln','exp','rnd');
  DisplayLineNum: Boolean = False;
  TotalLines: Word = 0;
  BegBuf: PText = nil;
  BegNumVar: PNumVar = nil;
  BegNumArr: PNumArr = nil;
  BegSymbVar: PSymbVar = nil;
  BegSymbArr: PSymbArr = nil;
  CurCycle: PCycle = nil;
var
  NumParams:array [1..ParamsMaxNum] of TFloat;
  StrParams:array [1..ParamsMaxNum] of TString;
  CurBuf,PrevBuf:PText;
  F:text;
  Line,CurBlock:word;
  S,Part,Index,S1:TextString;
  Number:TFloat;
  N,Num,i,FirstSign,p:byte;
  Idx:longint;
  SignPos:array [1..3] of byte;
  NumVar:PNumVar;
  NumArr:PNumArr absolute NumVar;
  SymbVar:PSymbVar absolute NumVar;
  SymbArr:PSymbArr absolute NumVar;
  Found,HotJump:boolean;
  VarType:byte;
  TempStr:TString;
  TempVar, TempVar2: TFloat;
  E:integer;
  ErrorFlag: Boolean;

procedure Error(Message:MessageString);
begin
  if not ErrorFlag then
  begin
    if WhereX<>1 then Writeln;
    if DisplayLineNum then Write('Ошибка в строке ',Line,': ');
    Writeln(Message);
    ErrorFlag := True;
  end;
end;

procedure GoToLine(LineNum:word);
var
  NeedBlock:word;
begin
  if LineNum>TotalLines then
  begin
    Error('Системная ошибка');
    Exit;
  end;
  NeedBlock:=(LineNum-1) div BufSize;
  while CurBlock<>NeedBlock do
  if CurBlock<NeedBlock then
  begin
    CurBuf:=CurBuf^.Next;
    Inc(CurBlock);
  end
  else
  begin
    CurBuf:=CurBuf^.Prev;
    Dec(CurBlock);
  end;
  Line:=LineNum;
  S:=CurBuf^.Data[((LineNum-1) mod BufSize)+1];
  HotJump:=false;
end;

procedure CreateArray(var S:TextString);
var
  p:byte;
  E:integer;

procedure CreateAny(var Ident:TIdentifier;var BegIdx,EndIdx:byte;
             var Values:pointer;Size:word);
begin
  Ident:=S;
  Val(Copy(Index,1,P-1),Number,E);
  if E<>0 then
  begin
    Error(emInvalidIndex);
    Exit;
  end;
  Idx:=Trunc(Number);
  if (Idx<>Number) or (Idx>254) then
  begin
    Error(emIndexOutOfRange);
    Exit;
  end;
  BegIdx:=Idx;
  Val(Copy(Index,P+2,Length(Index)-P-1),Number,E);
  if E<>0 then
  begin
    Error(emInvalidIndex);
    Exit;
  end;
  Idx:=Trunc(Number);
  if (Idx<>Number) or (Idx>255) or (Idx<=BegIdx) then
  begin
    Error(emIndexOutOfRange);
    Exit;
  end;
  EndIdx:=Idx;
  GetMem(Values,(EndIdx-BegIdx+1)*Size);
end;

begin
  while (Length(S)>0) and (S[1]=' ') do Delete(S,1,1);
  if S[1]<>'[' then
  begin
    Error('Пропущена откр. кв. скобка');
    Exit;
  end;
  Delete(S,1,1);
  if S[Length(S)]<>']' then
  begin
    Error('Пропущена закр. кв. скобка');
    Exit;
  end;
  Dec(S[0]);
  P:=Pos('(',S);
  if P=0 then
  begin
    Error('Не заданы индексы массива');
    Exit;
  end;
  Index:=Copy(S,P+1,Length(S)-P);
  if Index[Length(Index)]<>')' then
  begin
    Error(emClBrktNotFound);
    Exit;
  end;
  Dec(Index[0]);
  S[0]:=chr(P-1);
  P:=Pos('..',Index);
  if P=0 then
  begin
    Error('Не заданы нач. и кон. индексы массива');
    Exit;
  end;
  if S[Length(S)]='$' then
  begin
    New(SymbArr);
    SymbArr^.Next:=BegSymbArr;
    BegSymbArr:=SymbArr;
    with SymbArr^ do
     CreateAny(Ident,BegIdx,EndIdx,pointer(Values),sizeof(TString));
    if ErrorFlag then Exit;
  end
  else
  begin
    New(NumArr);
    NumArr^.Next:=BegNumArr;
    BegNumArr:=NumArr;
    with NumArr^ do
     CreateAny(Ident,BegIdx,EndIdx,pointer(Values),sizeof(TFloat));
    if ErrorFlag then Exit;
  end;
end;

function FindSymbVar(S:TextString;var SymbVar:PSymbVar):boolean;
var
  Found:boolean;
  VarPtr:PSymbVar;
begin
  if S[Length(S)]='$' then Dec(S[0]);
  if BegSymbVar=nil then FindSymbVar:=false
  else
  begin
    VarPtr:=BegSymbVar;
    repeat
      Found:=VarPtr^.Ident=S;
      SymbVar:=VarPtr;
      VarPtr:=VarPtr^.Next;
    until Found or (VarPtr=nil);
    FindSymbVar:=Found;
  end;
end;

function FindSymbArr(S:TextString;var SymbArr:PSymbArr):boolean;
 var
  Found:boolean;
  VarPtr:PSymbArr;
 begin
  if S[Length(S)]='$' then Dec(S[0]);
  if BegSymbArr=nil
   then FindSymbArr:=false
   else
    begin
     VarPtr:=BegSymbArr;
     repeat
      Found:=VarPtr^.Ident=S;
      SymbArr:=VarPtr;
      VarPtr:=VarPtr^.Next;
     until Found or (VarPtr=nil);
     FindSymbArr:=Found;
    end;
 end;
function FindNumVar(S:TextString;var NumVar:PNumVar):boolean;
 var
  Found:boolean;
  VarPtr:PNumVar;
 begin
  if BegNumVar=nil
   then FindNumVar:=false
   else
    begin
     VarPtr:=BegNumVar;
     repeat
      Found:=VarPtr^.Ident=S;
      NumVar:=VarPtr;
      VarPtr:=VarPtr^.Next;
     until Found or (VarPtr=nil);
     FindNumVar:=Found;
    end;
 end;
function FindNumArr(S:TextString;var NumArr:PNumArr):boolean;
 var
  Found:boolean;
  VarPtr:PNumArr;
 begin
  if BegNumArr=nil
   then FindNumArr:=false
   else
    begin
     VarPtr:=BegNumArr;
     repeat
      Found:=VarPtr^.Ident=S;
      NumArr:=VarPtr;
      VarPtr:=VarPtr^.Next;
     until Found or (VarPtr=nil);
     FindNumArr:=Found;
    end;
 end;
function GetParam(var Part,S:TextString):boolean;
 var
  p:byte;
  Quote:boolean;
  BrktNum:byte;
  Found:boolean;
 begin
  p:=0;
  Quote:=false;
  BrktNum:=0;
  Found:=false;
  repeat
   Inc(p);
   case S[p] of
    '"':Quote:=not Quote;
    '(':if not Quote then Inc(BrktNum);
    ')':if not Quote then if BrktNum=0 then
        begin
          Error(emBrktNotFound);
          Exit;
        end
        else Dec(BrktNum);
    ',':if (not Quote) and (BrktNum=0) then Found:=true;
   end;
  until (p>=Length(S)) or Found;
  if p>=Length(S)
   then begin
    { if BrktNum<>0 then Error(emClBrktNotFound);
      if Quote then Error(emNoQuote); }
    Part:=S;S:='';
   end
   else begin Part:=Copy(S,1,p-1);S:=Copy(S,P+1,Length(S)-p) end;
  GetParam:=Part<>'';
 end;
procedure FindOperator(var S:TextString;var i:byte);
 const
  MaxLevel=5;
 var
  BrktNum,Level:byte;
  Quote:boolean;
 begin
  Level:=0;
  Quote:=false;
  repeat
   i:=0;
   BrktNum:=0;
   Found:=false;
   Inc(Level);
   repeat
    Inc(i);
    if not Quote then
    case S[i] of
     '"':Quote:=true;
     '(':Inc(BrktNum);
     ')':if BrktNum=0 then
         begin
           Error(emBrktNotFound);
           Exit;
         end
         else Dec(BrktNum);
     ' ':if (S[i+1]='и') and (Level=1) then Found:=true;
     '+','-','*','/','<','>','=','^':
       if (BrktNum=0) and (i>1) and (S[i-1]<>'E') and (S[i-1]<>'e') then
        case s[i] of
         '<','>','=':if Level=2 then Found:=true;
         '+','-':if Level=3 then Found:=true;
         '*','/':if Level=4 then Found:=true;
         '^':if Level=5 then Found:=true;
        end;
    end
    else if S[i]='"' then Quote:=false;
    if (Level=MaxLevel) and (i>=Length(S)) and (Length(S)>=2) and (S[1]='(') and (S[Length(S)]=')') then
     begin
      Delete(S,1,1);
      Dec(S[0]);
      i:=0;
      Level:=1;
     end;
   until Found or (i>=Length(S));
  until Found or (Level>=MaxLevel);
  if not Found then i:=0;
 end;
function CalcSymb(S:TextString):TString; forward;
procedure GetType(var S:TextString;Cut:boolean); forward;
function Calc(S:TextString):TFloat;
 var
  OpPos:byte;
  Operator:char;
  Number,Number2:TFloat;
  NumVar:PNumVar;
  NumArr:PNumArr absolute NumVar;
  b,c:byte;
  p:integer absolute b;
  Double:boolean;
  Found:boolean absolute Double;
  Str1,Str2:^TString;
 begin
  FindOperator(S,OpPos);
  if ErrorFlag then Exit;
  if OpPos=0
   then
    begin
     case S[1] of
      'д':if (S[Length(S)]<>')') or (Copy(S,1,5)<>'длина') then
          begin
            Error(emSyntaxError);
            Exit;
          end
          else
          begin
           B:=Pos('(',S);
           if B=0 then
           begin
             Error(emBrktNotFound);
             Exit;
           end;
           Number:=Length(CalcSymb(Copy(S,B+1,Length(S)-B-1)));
           if ErrorFlag then Exit;
          end;
      'A'..'Z','a'..'z':
       begin
        if S[Length(S)]=')'
         then
          begin
           P:=Pos('(',S);
           if P=0 then
           begin
             Error(emBrktNotFound);
             Exit;
           end;
           Number:=Calc(Copy(S,P+1,Length(S)-P-1));
           if ErrorFlag then Exit;
           S[0]:=chr(P-1);
           B:=1;
           Found:=false;
           repeat
            if S=Functions[B] then Found:=true
            else Inc(B);
           until Found or (b>FuncNum);
           case b of
            1:Number:=Sin(Number);
            2:Number:=Cos(Number);
            3:if Cos(Number)=0 then
              begin
                Error(emArgumentOutOfRange);
                Exit;
              end
              else Number:=Sin(Number)/Cos(Number);
            4:if Number>0 then Number:=1
              else if Number<0 then Number:=-1
               else Number:=0;
            5:Number:=Int(Number);
            6:if Number<0 then
              begin
                Error(emArgumentOutOfRange);
                Exit;
              end
              else Number:=Sqrt(Number);
            7:if Number<=0 then
              begin
                Error(emArgumentOutOfRange);
                Exit;
              end
              else Number:=Ln(Number);
            8:Number:=Exp(Number);
            9:Number:=Number*random(65535)/65536;
            else begin
             if not FindNumArr(S,NumArr) then
             begin
               Error('Не найден массив '+S);
               Exit;
             end;
             Idx:=Trunc(Number);
             if (Idx<NumArr^.BegIdx) or (Idx>NumArr^.EndIdx) then
             begin
               Error(emIndexOutOfRange);
               Exit;
             end;
             Number:=NumArr^.Values^[Idx-NumArr^.BegIdx];
            end;
           end;
          end
         else
          begin
           if not FindNumVar(S,NumVar) then
           begin
             Error('Не найдена переменная '+S);
             Exit;
           end;
           Number:=NumVar^.Value;
          end;
       end;
      '-':
        begin
          Number:=-Calc(Copy(S,2,Length(S)-1));
          if ErrorFlag then Exit;
        end;
      '0'..'9':
        begin
         Val(S,Number,p);
         if p<>0 then
         begin
           Error('Плохое число');
           Exit;
         end;
        end;
      else
      begin
        Error(emSyntaxError);
        Exit;
      end;
     end;
    end
   else
    begin
     Operator:=S[OpPos];
     Double:=(((Operator='<') or (Operator='>')) and (S[OpPos+1]='=')) or
             ((Operator='<') and (S[OpPos+1]='>'));
     GetType(S,false);
     if ErrorFlag then Exit;
     if VarType and vtmSymb=vtmSymb then
      begin
       New(Str1); New(Str2);
       Str1^:=CalcSymb(Copy(S,1,OpPos-1));
       if ErrorFlag then Exit;
       if Double then Inc(OpPos);
       Str2^:=CalcSymb(Copy(S,OpPos+1,Length(S)-OpPos));
       if ErrorFlag then Exit;
       case Operator of
        '=':Number:=byte(Str1^=Str2^);
        '>':if Double
             then Number:=byte(Str1^>=Str2^)
             else Number:=byte(Str1^>Str2^);
        '<':if not Double
             then Number:=byte(Str1^<Str2^)
             else if S[OpPos]='='
              then Number:=byte(Str1^<=Str2^)
              else Number:=byte(Str1^<>Str2^);
       end;
       Dispose(Str2); Dispose(Str1);
      end
     else if Operator=' ' then
       begin
        Delete(S,OpPos,1);
        if S[OpPos+1]=' ' then
        begin
          b:=OpPos+1;
          Double:=false
        end
        else if Copy(S,OpPos+1,3)='ли ' then
          begin
            b:=OpPos+3;
            Double:=true
          end
          else
          begin
            Error(emSyntaxError);
            Exit;
          end;
        while S[b]=' ' do Delete(S,b,1);
        Number2:=Calc(Copy(S,1,OpPos-1));
        if ErrorFlag then Exit;
        Number:=Calc(Copy(S,b,Length(S)-b+1));
        if ErrorFlag then Exit;
        if Double then Number:=byte((Number<>0) or (Number2<>0))
         else Number:=byte((Number<>0) and (Number2<>0));
       end
      else begin
      Number2:=Calc(Copy(S,1,OpPos-1));
      if ErrorFlag then Exit;
      if Double then Inc(OpPos);
      Number:=Calc(Copy(S,OpPos+1,Length(S)-OpPos));
      if ErrorFlag then Exit;
      case Operator of
       '+':Number:=Number2+Number;
       '-':Number:=Number2-Number;
       '*':Number:=Number2*Number;
       '/':if Number=0 then
           begin
             Error('Деление на ноль');
             Exit;
           end
           else Number:=Number2/Number;
       '^':if Number2=0 then Number:=0
           else if Number2<0
             then Number:=1/(Exp(Number*Ln(Number2)))
             else Number:=Exp(Number*Ln(Number2));
       '=':Number:=byte(Number=Number2);
       '>':if Double
            then Number:=byte(Number2>=Number)
            else Number:=byte(Number2>Number);
       '<':if not Double
            then Number:=byte(Number2<Number)
            else if S[OpPos]='='
             then Number:=byte(Number2<=Number)
             else Number:=byte(Number2<>Number);
      end;
     end;
    end;
  Calc:=Number;
 end;
procedure GetType(var S:TextString;Cut:boolean);
 var
  p,OpPos:byte;
 begin
  FindOperator(S,OpPos);
  if ErrorFlag then Exit;
  if OpPos=0 then OpPos:=Length(S) else Dec(OpPos);
  case S[1] of
   '"':VarType:=vtSymbVar;
   '0'..'9','(','-','+':VarType:=vtNumVar;
   'д':VarType:=vtNumVar;  {'длина'}
   'п':VarType:=vtSymbVar; {'подстр'}
   'A'..'Z','a'..'z':
    begin
     if S[OpPos]=')'
     then
       begin
        p:=Pos('(',S);
        if p=0 then
        begin
          Error(emBrktNotFound);
          Exit;
        end;
        Index:=Copy(S,p+1,OpPos-p-1);
        Number:=Calc(Index);
        if ErrorFlag then Exit;
        Idx:=Trunc(Number);
        if Cut then S[0]:=chr(p-1);
        if S[p-1]='$' then VarType:=vtSymbArray else VarType:=vtNumArray;
       end
      else if S[OpPos]='$' then VarType:=vtSymbVar else VarType:=vtNumVar;
    end;
   else
   begin
     Error(emSyntaxError);
     Exit;
   end;
  end;
 end;
procedure GetParams(var S:TextString;Types:TParamTypes); forward;
function CalcSymb(S:TextString):TString;
 var
  Str:TString;
  S1:TextString;
  P:byte;
  SymbArr:PSymbArr;
  SymbVar:PSymbVar absolute SymbArr;
 begin
  if S='' then
  begin
    Error(emSyntaxError);
    Exit;
  end;
  Str:='';
  repeat
   FindOperator(S,P);
   if ErrorFlag then Exit;
   if P=0 then P:=Length(S)+1
   else if (P<3) or (S[p]<>'+') then
     begin
       Error('Плохой оператор');
       Exit;
     end;
   S1:=Copy(S,1,P-1);
   S:=Copy(S,P+1,Length(S)-P);
   GetType(S1,true);
   if ErrorFlag then Exit;
   if VarType and vtmSymb <> vtmSymb then
   begin
     Error(emTypeMismatch);
     Exit;
   end;
   case S1[1] of
    '"':if S1[Length(S1)]<>'"' then
        begin
          Error(emNoQuote);
          Exit;
        end
        else Str:=Str+Copy(S1,2,Length(S1)-2);
    'п':if (S1[Length(S1)]<>')') or (Copy(S1,1,6)<>'подстр') then
        begin
          Error(emSyntaxError);
          Exit;
        end
        else
        begin
         P:=Pos('(',S1);
         if P=0 then
         begin
           Error(emBrktNotFound);
           Exit;
         end;
         S1:=Copy(S1,P+1,Length(S1)-P-1);
         GetParams(S1,'snn');
         if ErrorFlag then Exit;
         Str:=Str+Copy(StrParams[1],Trunc(NumParams[1]),Trunc(NumParams[2]));
        end;
    'A'..'Z','a'..'z':if VarType=vtSymbArray
     then begin
      if not FindSymbArr(S1,SymbArr) then
      begin
        Error('Не найден стоковой массив '+S1);
        Exit;
      end;
      if (Idx<SymbArr^.BegIdx) or (Idx>SymbArr^.EndIdx) then
      begin
        Error(emIndexOutOfRange);
        Exit;
      end;
      Str:=Str+SymbArr^.Values^[Idx-SymbArr^.BegIdx];
     end
     else
     begin
       if not FindSymbVar(S1,SymbVar) then
       begin
         Error('Не найдена символьная переменная '+S1);
         Exit;
       end;
       Str:=Str+SymbVar^.Value;
     end;
    else
    begin
      Error(emSyntaxError);
      Exit;
    end;
   end;
  until S='';
  CalcSymb:=Str;
 end;
procedure GetParams { (var S:TextString;Types:TParamTypes) };
 var
  SPCount,NPCount, P: Byte;
  Part:TextString;
 begin
  SPCount:=1;
  NPCount:=1;
  for P :=1 to Length(Types) do
   begin
    if (S='') or (not GetParam(Part,S)) then
    begin
      Error('Не хватает параметров');
      Exit;
    end;
    if ErrorFlag then Exit;
    GetType(Part,False);
    if ErrorFlag then Exit;
    if (VarType and vtmSymb)=0
     then
      begin
       if Types[P]<>'n' then
       begin
         Error(emTypeMismatch);
         Exit;
       end;
       NumParams[NPCount]:=Calc(Part);
       if ErrorFlag then Exit;
       Inc(NPCount);
      end
     else
      begin
       if Types[P]<>'s' then
       begin
         Error(emTypeMismatch);
         Exit;
       end;
       StrParams[SPCount]:=CalcSymb(Part);
       if ErrorFlag then Exit;
       Inc(SPCount);
      end;
   end;
  if S<>'' then
  begin
    Error('Лишние параметры');
    Exit;
  end;
 end;
procedure AssignNum(S:TextString; NewValue:TFloat);
 begin
  GetType(S,true);
  if ErrorFlag then Exit;
  case VarType of
   vtNumVar:
     begin
      if not FindNumVar(S,NumVar) then
       begin
        New(NumVar);
        NumVar^.Next:=BegNumVar;
        BegNumVar:=NumVar;
        NumVar^.Ident:=S;
       end;
      NumVar^.Value:=NewValue;
     end;
   vtNumArray:
     begin
      if not FindNumArr(S,NumArr) then
      begin
        Error('Не определен массив '+S);
        Exit;
      end;
      if (Idx<NumArr^.BegIdx) or (Idx>NumArr^.EndIdx) then
      begin
        Error(emIndexOutOfRange);
        Exit;
      end;
      NumArr^.Values^[Idx-NumArr^.BegIdx]:=NewValue;
     end;
   else
   begin
     Error(emTypeMismatch);
     Exit;
   end;
  end;
 end;
procedure AssignSymb(S:TextString; NewValue:TString);
 begin
  GetType(S,true);
  if ErrorFlag then Exit;
  if S[Length(S)]='$' then Dec(S[0]);
  case VarType of
   vtSymbVar:
     begin
      if not FindSymbVar(S,SymbVar) then
       begin
        New(SymbVar);
        SymbVar^.Next:=BegSymbVar;
        BegSymbVar:=SymbVar;
        SymbVar^.Ident:=S;
       end;
      SymbVar^.Value:=NewValue;
     end;
   vtSymbArray:
     begin
      if not FindSymbArr(S,SymbArr) then
      begin
        Error('Не определен строковой массив '+S);
        Exit;
      end;
      if (Idx<SymbArr^.BegIdx) or (Idx>SymbArr^.EndIdx) then
      begin
        Error(emIndexOutOfRange);
        Exit;
      end;
      SymbArr^.Values^[Idx-SymbArr^.BegIdx]:=NewValue;
     end;
  end;
 end;
procedure NewCycle(CycleType:byte);
 var
  Cycle:PCycle;
 begin
  New(Cycle);
  with Cycle^ do
   begin
    Prev:=CurCycle;
    StartLine:=Line;
    FinishLine:=0;
    CType:=CycleType;
   end;
  CurCycle:=Cycle;
 end;
procedure CloseCycle(CycleType:byte);
 var
  Cycle:PCycle;
 begin
  if (CurCycle=nil) or ((CycleType<>ct_Any) and (CurCycle^.CType<>CycleType)) then
  begin
    Error(emEndWithoutBegin);
    Exit;
  end;
  Cycle:=CurCycle;
  CurCycle:=Cycle^.Prev;
  Dispose(Cycle);
 end;
procedure FindEOCycle(CEndType:byte;IfOp:boolean);
 const
  NotFound=0;
  FoundEnd=1;
  FoundElse=2;
 type
  PTempCycle=^TempCycle;
  TempCycle=record
   CType:byte;
   Prev:PTempCycle;
  end;
 var
  Found:byte;
  OpNum:byte;
  Cycle:PTempCycle;
 function Compare(S1,S2:TextString):boolean;
  var
   OldLen:byte;
  begin
   OldLen:=Length(S1);
   S1[0]:=S2[0];
   Compare:=(OldLen>=Length(S2)) and (S1=S2);
  end;
 procedure AddCycle(CycleType:byte);
  var
   Temp:PTempCycle;
  begin
   Temp:=Cycle;
   New(Cycle);
   with Cycle^ do
   begin
    CType:=CycleType;
    Prev:=Temp;
   end;
  end;
 procedure DelCycle(CycleType:byte);
  var
   Temp:PTempCycle;
  begin
   if Cycle=nil then
     if CycleType=CEndType then Found:=FoundEnd
     else
     begin
       Error(emEndWithoutBegin);
       Exit;
     end
   else
   begin
     Temp:=Cycle;
     Cycle:=Temp^.Prev;
     Dispose(Temp);
   end;
  end;
 begin
  if CurCycle^.FinishLine<>0 then
  begin
    Line:=CurCycle^.FinishLine;
    CloseCycle(ct_Any);
    if ErrorFlag then Exit;
  end
  else
  begin
    Found:=NotFound;
    Cycle:=nil;
    if CEndType=ct_If then OpNum:=6 else OpNum:=9;
    repeat
     GoToLine(Line+1);
     if ErrorFlag then Exit;
     if (Cycle=nil) and Compare(S,Operators[OpNum])
      then Found:=FoundEnd
      else if Compare(S,Operators[4]) {if}
       then AddCycle(ct_If)
       else if Compare(S,Operators[7]) or Compare(S,Operators[8]) {while,cycle}
        then AddCycle(ct_Any)
        else if Compare(S,Operators[6]) then {endif}
         begin
           DelCycle(ct_If);
           if ErrorFlag then Exit;
         end
         else if Compare(S,Operators[9]) then {cycle_end}
          begin
            DelCycle(ct_Any);
            if ErrorFlag then Exit;
          end
          else if IfOp and (Cycle=nil) and Compare(S,Operators[5]) {else}
           then Found:=FoundElse;
    until Found<>NotFound;
    if Found=FoundEnd then
    begin
      CloseCycle(ct_Any);
      if ErrorFlag then Exit;
    end;
   end;
 end;

begin     { *** Main *** }
 Randomize;
 ErrorFlag := False;
 { WriteLn('Русский алгоритмический язык 1.0  Д.Виноградов 1993'); }
 Writeln('---------');
 {$IFDEF Debug}
 Writeln(#13#10,'Free memory:',MemAvail,'/',MaxAvail);
 {$ENDIF}
 if ParamCount<1 then
 begin
   Error('Использование: ral <имя-файла>');
   Exit;
 end;
 Assign(F,ParamStr(1));
 {$I-}
 Reset(F);
 {$I+}
 if IOResult<>0 then
 begin
   Error('Не найден файл '+ParamStr(1));
   Exit;
 end;
 { Read file }
 while not(Eof(F)) do
  begin
   Inc(TotalLines);
   Line:=((TotalLines-1) mod BufSize)+1;
   if Line=1 then
    begin
     New(CurBuf);
     if BegBuf=nil
      then
       begin
        BegBuf:=CurBuf;
        CurBuf^.Prev:=nil;
       end
      else
       begin
        CurBuf^.Prev:=PrevBuf;
        PrevBuf^.Next:=CurBuf;
       end;
     CurBuf^.Next:=nil;
     PrevBuf:=CurBuf;
    end;
   Read(F,S);
   while (Length(S)>0) and ((S[1]=' ') or (S[1]=#9)) do
    Delete(S,1,1);
   while (Length(S)>0) and ((S[Length(S)]=' ') or (S[1]=#9)) do
    Dec(S[0]);
   CurBuf^.Data[Line]:=S;
   Readln(F);
  end;
 CurBlock:=0;
 CurBuf:=BegBuf;
 { Main body }
 (*
 for Line:=1 to TotalLines do
  begin  { Pass 1 }
  end;
 *)
 Line:=1;
 DisplayLineNum:=true;
 repeat
  GoToLine(Line);
  if ErrorFlag then Exit;
  HotJump:=true;
  RepeatThis:
  if S[1]='[' then
  begin
    CreateArray(S);
    if ErrorFlag then Exit;
  end
  else
    begin
     SignPos[ctOperator ]:=Pos(' ', S);
     SignPos[ctProcedure]:=Pos('(', S);
     SignPos[ctAssigment]:=Pos(':=',S);
     FirstSign:=1;
     for i:=1 to 3 do
      begin
       if SignPos[i]=0 then SignPos[i]:=Length(S)+1;
       if SignPos[i]<>0 then
        if SignPos[i]<SignPos[FirstSign] then FirstSign:=i;
      end;
     if (FirstSign=2) and (SignPos[ctAssigment]<Length(S)) and
        (S[SignPos[ctAssigment]-1]=')') then FirstSign:=ctAssigment;
     Part:=Copy(S,1,SignPos[FirstSign]-1);
     S:=Copy(S,SignPos[FirstSign]+1,Length(S)-SignPos[FirstSign]);
     while (Length(S)>0) and (S[1]=' ') do Delete(S,1,1);
     case FirstSign of
      ctOperator :
        begin
         Num:=0;
         repeat
          Inc(Num);
          Found:=Part=Operators[Num];
         until Found or (Num>=OpsNum);
         if not Found then
         begin
           Error('Неизвестный оператор '+Part);
           Exit;
         end;
         case Num of
          1,3:; {program,end}
          2:if Length(S)<>0 then {begin}
            begin
              CreateArray(S);
              if ErrorFlag then Exit;
            end;
          4:if Copy(S,Length(S)-2,3)<>' то' then {if}
            begin
              Error('Пропущено "то"');
              Exit;
            end
            else
            begin
              Dec(S[0],3);
              NewCycle(ct_If);
              TempVar := Calc(S);
              if ErrorFlag then Exit;
              if TempVar = 0 then FindEOCycle(ct_If,true);
              if ErrorFlag then Exit;
            end;
          6:begin {endif}
              CloseCycle(ct_If);
              if ErrorFlag then Exit;
            end;
          5:begin {else}
              FindEOCycle(ct_If,false);
              if ErrorFlag then Exit;
            end;
          7:begin {while}
             NewCycle(ct_While);
             TempVar := Calc(S);
             if ErrorFlag then Exit;
             if TempVar = 0 then FindEOCycle(ct_Any,false);
             if ErrorFlag then Exit;
            end;
          9:if CurCycle=nil then {cycle_end}
            begin
              Error(emEndWithoutBegin);
              Exit;
            end
            else with CurCycle^ do begin
             FinishLine:=Line;
             case CType of
              ct_If:
                begin
                  Error(emEndWithoutBegin);
                  Exit;
                end;
              ct_While:
                begin
                  GotoLine(StartLine);
                  if ErrorFlag then Exit;
                  goto RepeatThis;
                end;
              ct_For:
                begin
                  GoToLine(StartLine);
                  if ErrorFlag then Exit;
                  goto RepeatThis;
                end;
              ct_Repeat:Line:=StartLine;
             end;
            end;
          8:if Copy(S,1,2)='от' {cycle}
             then begin {for}
              Delete(S,1,2);
              while (Length(S)>0) and (S[1]=' ') do Delete(S,1,1);
              P:=Pos(':=',S);
              if P=0 then
              begin
                Error('Пропущено ":="');
                Exit;
              end;
              Part:=Copy(S,1,P-1);
              Delete(S,1,P+1);
              P:=Pos(' до ',S);
              if P=0 then
              begin
                Error('Пропущено "до"');
                Exit;
              end;
              S1:=Copy(S,1,P-1);
              Delete(S,1,P+3);
              P:=Pos(' шаг ',S);
              if P=0 then Number:=1
              else
              begin
                Number:=Calc(Copy(S,P+5,Length(S)-P-4));
                if ErrorFlag then Exit;
                S[0]:=char(P-1);
              end;
              if HotJump then
              begin
                NewCycle(ct_For);
                TempVar := Calc(S1);
                if ErrorFlag then Exit;
                AssignNum(Part,TempVar);
                if ErrorFlag then Exit;
              end
              else
              begin
                TempVar := Calc(Part) + Number;
                if ErrorFlag then Exit;
                AssignNum(Part,TempVar);
                if ErrorFlag then Exit;
              end;
              if Number>0 then
              begin
                TempVar := Calc(Part);
                if ErrorFlag then Exit;
                TempVar2 := Calc(S);
                if ErrorFlag then Exit;
                if TempVar > TempVar2 then FindEOCycle(ct_Any,false);
                if ErrorFlag then Exit;
              end
              else
              begin
                TempVar := Calc(Part);
                if ErrorFlag then Exit;
                TempVar2 := Calc(S);
                if ErrorFlag then Exit;
                if TempVar < TempVar2 then FindEOCycle(ct_Any,false);
                if ErrorFlag then Exit;
              end;
             end
             else if S<>'' then
               begin
                 Error('Пропущено "от"');
                 Exit;
               end
               else NewCycle(ct_Repeat); {repeat}
          10:if (CurCycle=nil) or (CurCycle^.CType<>ct_Repeat) then {exit_if}
             begin
               Error('"при" без "цикл"');
               Exit;
             end
             else
             begin
               if Copy(S,Length(S)-4,5)<>'выход' then
               begin
                 Error('Пропущен "выход"');
                 Exit;
               end;
               Dec(S[0],5);
               while (Length(S)>0) and (S[Length(S)]=' ') do Dec(S[0]);
               TempVar := Calc(S);
               if ErrorFlag then Exit;
               if TempVar <> 0 then FindEOCycle(ct_Any,false);
               if ErrorFlag then Exit;
              end;
         end;
        end;
      ctProcedure:
        begin
         if S[Length(S)]<>')' then
         begin
           Error('Нет закрывающей скобки');
           Exit;
         end;
         Num:=0;
         repeat
          Inc(Num);
          Found:=Part=Procedures[Num];
         until Found or (Num>=OpsNum);
         if not Found then
         begin
           Error('Неизвестная процедура '+Part);
           Exit;
         end;
         Dec(S[0]);
         case Num of
          1:begin
             while GetParam(Part,S) do
             begin
              if ErrorFlag then Exit;
              GetType(Part,False);
              if ErrorFlag then Exit;
              if VarType and vtmSymb=vtmSymb then
               begin
                FindOperator(Part,P);
                if ErrorFlag then Exit;
                if (P>0) and ((Part[P]='=') or (Part[P]='<') or (Part[P]='>'))
                 then VarType:=vtNumVar;
               end;
              if VarType and vtmSymb = vtmSymb then
              begin
                TempStr := CalcSymb(Part);
                if ErrorFlag then Exit;
                Write(TempStr);
              end
              else
                begin
                 TempVar := Calc(Part);
                 if ErrorFlag then Exit;
                 Str(TempVar:0:20,Part);
                 if Pos('E',Part)=0 then
                  begin
                   while (Length(Part)>0) and (Part[Length(Part)]='0') do
                    Dec(Part[0]);
                   if Part[Length(Part)]='.' then Dec(Part[0]);
                  end;
                 Write(Part);
                end;
             end;
             if ErrorFlag then Exit;
             Writeln;
            end;
          2:begin
             while GetParam(Part,S) do
             begin
               if ErrorFlag then Exit;
               if Part[1]='"'
                then
                 begin
                  { CalcSymb ... }
                  Write(Copy(Part,2,Length(Part)-2));
                 end
                else
                 begin
                  GetType(Part,false);
                  if ErrorFlag then Exit;
                  if VarType and vtSymbVar <> vtSymbVar
                   then begin
                    repeat
                     ReadLn(TempStr);
                     Val(TempStr,Number,E);
                     if E<>0 then
                      begin
                       if WhereX<>1 then Writeln;
                       Write('Ошибка, повторите ввод:');
                      end;
                    until E=0;
                    AssignNum(Part,Number);
                    if ErrorFlag then Exit;
                   end
                   else
                   begin
                     ReadLn(TempStr);
                     AssignSymb(Part,TempStr);
                     if ErrorFlag then Exit;
                   end;
                 end;
             end;
             if ErrorFlag then Exit;
            end;
         end;
        end;
      ctAssigment:
        begin
         Delete(S,1,1);
         GetType(Part,False);
         if ErrorFlag then Exit;
         if VarType and vtmSymb <> vtmSymb then
         begin
           TempVar := Calc(S);
           if ErrorFlag then Exit;
           AssignNum(Part, TempVar);
           if ErrorFlag then Exit;
         end
         else
         begin
           TempStr := CalcSymb(S);
           if ErrorFlag then Exit;
           AssignSymb(Part, TempStr);
           if ErrorFlag then Exit;
         end;
        end;
     end;
   end;
  Inc(Line);
 until Line>TotalLines;
 { Close buffers }
 while BegNumVar<>nil do
  begin
   NumVar:=BegNumVar^.Next;
   Dispose(BegNumVar);
   BegNumVar:=NumVar;
  end;
 while BegNumArr<>nil do
  begin
   NumArr:=BegNumArr^.Next;
   with BegNumArr^ do FreeMem(Values,(EndIdx-BegIdx+1)*sizeof(TFloat));
   Dispose(BegNumArr);
   BegNumArr:=NumArr;
  end;
 while BegBuf<>nil do
  begin
   CurBuf:=BegBuf^.Next;
   Dispose(BegBuf);
   BegBuf:=CurBuf;
  end;
 Close(F);
 {$IFDEF Debug}
 Writeln('Free memory:',MemAvail,'/',MaxAvail,#13#10);
 {$ENDIF}
end;

begin
  Main;
  Writeln(#13#10'End of program');
end.