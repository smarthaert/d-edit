program RAL;
{ Russian Algoritmic Language Interpreter }
{DEFINE Debug}
uses
 Crt;
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
 emBrktNotFound='Пропущена открывающая скобка';
 emClBrktNotFound='Пропущена закрывающая скобка';
 emIndexOutOfRange='Индекс вне диапазона';
 emInvalidIndex='Плохой индекс';
 emNoParameters='Не заданы параметры';
 emTypeMismatch='Несоответствие типов';
 emEndWithoutBegin='Конец без начала';
 emSyntaxError='Синтаксическая ошибка';
 emNoQuote='Пропущена кавычка';
 emArgumentOutOfRange='Аргумент вне диапазона';
 OpsNum=10;
 Operators :array [1..OpsNum] of TextString=
            ('алг','нач','кон','если','иначе','кесли','пока','цикл','кцикл',
             'при');
 PrsNum=2;
 Procedures:array [1..PrsNum] of TextString=
            ('вывод','запрос');
 FuncNum=9;
 Functions:array [1..FuncNum] of TextString=
            ('sin','cos','tg','sign','int','sqr','ln','exp','rnd');
 DisplayLineNum:boolean=false;
 TotalLines:word=0;
 BegBuf:PText=nil;
 BegNumVar:PNumVar=nil;
 BegNumArr:PNumArr=nil;
 BegSymbVar:PSymbVar=nil;
 BegSymbArr:PSymbArr=nil;
 CurCycle:PCycle=nil;
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
 E:integer;

procedure Error(Message:MessageString);
 begin
  if WhereX<>1 then Writeln;
  if DisplayLineNum then Write('Ошибка в строке ',Line,': ');
  Writeln(Message);
  Halt(1);
 end;
procedure GoToLine(LineNum:word);
 var
  NeedBlock:word;
 begin
  if LineNum>TotalLines then Error('Системная ошибка');
  NeedBlock:=(LineNum-1) div BufSize;
  while CurBlock<>NeedBlock do
   if CurBlock<NeedBlock
    then
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
   if E<>0 then Error(emInvalidIndex);
   Idx:=Trunc(Number);
   if (Idx<>Number) or (Idx>254) then Error(emIndexOutOfRange);
   BegIdx:=Idx;
   Val(Copy(Index,P+2,Length(Index)-P-1),Number,E);
   if E<>0 then Error(emInvalidIndex);
   Idx:=Trunc(Number);
   if (Idx<>Number) or (Idx>255) or (Idx<=BegIdx) then Error(emIndexOutOfRange);
   EndIdx:=Idx;
   GetMem(Values,(EndIdx-BegIdx+1)*Size);
  end;
 begin
  while (Length(S)>0) and (S[1]=' ') do
   Delete(S,1,1);
  if S[1]<>'[' then Error('Пропущена откр. кв. скобка');
  Delete(S,1,1);
  if S[Length(S)]<>']' then Error('Пропущена закр. кв. скобка');
  Dec(S[0]);
  P:=Pos('(',S);
  if P=0 then Error('Не заданы индексы массива');
  Index:=Copy(S,P+1,Length(S)-P);
  if Index[Length(Index)]<>')' then Error(emClBrktNotFound);
  Dec(Index[0]);
  S[0]:=chr(P-1);
  P:=Pos('..',Index);
  if P=0 then Error('Не заданы нач. и кон. индексы массива');
  if S[Length(S)]='$'
   then begin
    New(SymbArr);
    SymbArr^.Next:=BegSymbArr;
    BegSymbArr:=SymbArr;
    with SymbArr^ do
     CreateAny(Ident,BegIdx,EndIdx,pointer(Values),sizeof(TString));
   end
   else begin
    New(NumArr);
    NumArr^.Next:=BegNumArr;
    BegNumArr:=NumArr;
    with NumArr^ do
     CreateAny(Ident,BegIdx,EndIdx,pointer(Values),sizeof(TFloat));
   end;
 end;
function FindSymbVar(S:TextString;var SymbVar:PSymbVar):boolean;
 var
  Found:boolean;
  VarPtr:PSymbVar;
 begin
  if S[Length(S)]='$' then Dec(S[0]);
  if BegSymbVar=nil
   then FindSymbVar:=false
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
    ')':if not Quote then if BrktNum=0 then Error(emBrktNotFound)
        else Dec(BrktNum);
    ',':if (not Quote) and (BrktNum=0) then Found:=true;
   end;
  until (p>=Length(S)) or Found;
  if p>=Length(S)
   then begin
    { if BrktNum<>0 then Error(emClBrktNotFound);
      if Quote then Error(emNoQuote); }
    Part:=S;S:=''
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
     ')':if BrktNum=0 then Error(emBrktNotFound) else Dec(BrktNum);
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
  if OpPos=0
   then
    begin
     case S[1] of
      'д':if (S[Length(S)]<>')') or (Copy(S,1,5)<>'длина') then Error(emSyntaxError) else
          begin
           B:=Pos('(',S);
           if B=0 then Error(emBrktNotFound);
           Number:=Length(CalcSymb(Copy(S,B+1,Length(S)-B-1)));
          end;
      'A'..'Z','a'..'z':
       begin
        if S[Length(S)]=')'
         then
          begin
           P:=Pos('(',S);
           if P=0 then Error(emBrktNotFound);
           Number:=Calc(Copy(S,P+1,Length(S)-P-1));
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
            3:if Cos(Number)=0
               then Error(emArgumentOutOfRange)
               else Number:=Sin(Number)/Cos(Number);
            4:if Number>0 then Number:=1
              else if Number<0 then Number:=-1
               else Number:=0;
            5:Number:=Int(Number);
            6:if Number<0
               then Error(emArgumentOutOfRange)
               else Number:=Sqrt(Number);
            7:if Number<=0
               then Error(emArgumentOutOfRange)
               else Number:=Ln(Number);
            8:Number:=Exp(Number);
            9:Number:=Number*random(65535)/65536;
            else begin
             if not FindNumArr(S,NumArr) then Error('Не найден массив '+S);
             Idx:=Trunc(Number);
             if (Idx<NumArr^.BegIdx) or (Idx>NumArr^.EndIdx) then Error(emIndexOutOfRange);
             Number:=NumArr^.Values^[Idx-NumArr^.BegIdx];
            end;
           end;
          end
         else
          begin
           if not FindNumVar(S,NumVar) then Error('Не найдена переменная '+S);
           Number:=NumVar^.Value;
          end;
       end;
      '-':Number:=-Calc(Copy(S,2,Length(S)-1));
      '0'..'9':
        begin
         Val(S,Number,p);
         if p<>0 then Error('Плохое число');
        end;
      else Error(emSyntaxError);
     end;
    end
   else
    begin
     Operator:=S[OpPos];
     Double:=(((Operator='<') or (Operator='>')) and (S[OpPos+1]='=')) or
             ((Operator='<') and (S[OpPos+1]='>'));
     GetType(S,false);
     if VarType and vtmSymb=vtmSymb then
      begin
       New(Str1); New(Str2);
       Str1^:=CalcSymb(Copy(S,1,OpPos-1));
       if Double then Inc(OpPos);
       Str2^:=CalcSymb(Copy(S,OpPos+1,Length(S)-OpPos));
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
        if S[OpPos+1]=' ' then begin b:=OpPos+1; Double:=false end
         else if Copy(S,OpPos+1,3)='ли '
          then begin b:=OpPos+3; Double:=true end
          else Error(emSyntaxError);
        while S[b]=' ' do Delete(S,b,1);
        Number2:=Calc(Copy(S,1,OpPos-1));
        Number:=Calc(Copy(S,b,Length(S)-b+1));
        if Double then Number:=byte((Number<>0) or (Number2<>0))
         else Number:=byte((Number<>0) and (Number2<>0));
       end
      else begin
      Number2:=Calc(Copy(S,1,OpPos-1));
      if Double then Inc(OpPos);
      Number:=Calc(Copy(S,OpPos+1,Length(S)-OpPos));
      case Operator of
       '+':Number:=Number2+Number;
       '-':Number:=Number2-Number;
       '*':Number:=Number2*Number;
       '/':if Number=0
            then Error('Деление на ноль')
            else Number:=Number2/Number;
       '^':if Number2=0
            then Number:=0
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
        if p=0 then Error(emBrktNotFound);
        Index:=Copy(S,p+1,OpPos-p-1);
        Number:=Calc(Index);
        Idx:=Trunc(Number);
        if Cut then S[0]:=chr(p-1);
        if S[p-1]='$' then VarType:=vtSymbArray else VarType:=vtNumArray;
       end
      else if S[OpPos]='$' then VarType:=vtSymbVar else VarType:=vtNumVar;
    end;
   else Error(emSyntaxError);
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
  if S='' then Error(emSyntaxError);
  Str:='';
  repeat
   FindOperator(S,P);
   if P=0 then P:=Length(S)+1
   else if (P<3) or (S[p]<>'+') then Error('Плохой оператор');
   S1:=Copy(S,1,P-1);
   S:=Copy(S,P+1,Length(S)-P);
   GetType(S1,true);
   if VarType and vtmSymb <> vtmSymb then Error(emTypeMismatch);
   case S1[1] of
    '"':if S1[Length(S1)]<>'"' then Error(emNoQuote)
         else Str:=Str+Copy(S1,2,Length(S1)-2);
    'п':if (S1[Length(S1)]<>')') or (Copy(S1,1,6)<>'подстр') then Error(emSyntaxError) else
        begin
         P:=Pos('(',S1);
         if P=0 then Error(emBrktNotFound);
         S1:=Copy(S1,P+1,Length(S1)-P-1);
         GetParams(S1,'snn');
         Str:=Str+Copy(StrParams[1],Trunc(NumParams[1]),Trunc(NumParams[2]));
        end;
    'A'..'Z','a'..'z':if VarType=vtSymbArray
     then begin
      if not FindSymbArr(S1,SymbArr) then Error('Не найден стоковой массив '+S1);
      if (Idx<SymbArr^.BegIdx) or (Idx>SymbArr^.EndIdx) then Error(emIndexOutOfRange);
      Str:=Str+SymbArr^.Values^[Idx-SymbArr^.BegIdx];
     end
     else begin
      if not FindSymbVar(S1,SymbVar) then Error('Не найдена символьная переменная '+S1);
      Str:=Str+SymbVar^.Value;
     end;
    else Error(emSyntaxError);
   end;
  until S='';
  CalcSymb:=Str;
 end;
procedure GetParams { (var S:TextString;Types:TParamTypes) };
 var
  SPCount,NPCount:byte;
  Part:TextString;
 begin
  SPCount:=1;
  NPCount:=1;
  for P:=1 to Length(Types) do
   begin
    if (S='') or (not GetParam(Part,S)) then Error('Не хватает параметров');
    GetType(Part,False);
    if (VarType and vtmSymb)=0
     then
      begin
       if Types[P]<>'n' then Error(emTypeMismatch);
       NumParams[NPCount]:=Calc(Part);
       Inc(NPCount);
      end
     else
      begin
       if Types[P]<>'s' then Error(emTypeMismatch);
       StrParams[SPCount]:=CalcSymb(Part);
       Inc(SPCount);
      end;
   end;
  if S<>'' then Error('Лишние параметры');
 end;
procedure AssignNum(S:TextString; NewValue:TFloat);
 begin
  GetType(S,true);
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
      if not FindNumArr(S,NumArr) then Error('Не определен массив '+S);
      if (Idx<NumArr^.BegIdx) or (Idx>NumArr^.EndIdx) then Error(emIndexOutOfRange);
      NumArr^.Values^[Idx-NumArr^.BegIdx]:=NewValue;
     end;
   else Error(emTypeMismatch);
  end;
 end;
procedure AssignSymb(S:TextString; NewValue:TString);
 begin
  GetType(S,true);
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
      if not FindSymbArr(S,SymbArr) then Error('Не определен строковой массив '+S);
      if (Idx<SymbArr^.BegIdx) or (Idx>SymbArr^.EndIdx) then Error(emIndexOutOfRange);
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
  if (CurCycle=nil) or ((CycleType<>ct_Any) and (CurCycle^.CType<>CycleType))
   then Error(emEndWithoutBegin);
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
   if Cycle=nil
    then if CycleType=CEndType
     then Found:=FoundEnd
     else Error(emEndWithoutBegin)
    else begin
     Temp:=Cycle;
     Cycle:=Temp^.Prev;
     Dispose(Temp);
    end;
  end;
 begin
  if CurCycle^.FinishLine<>0
   then begin
    Line:=CurCycle^.FinishLine;
    CloseCycle(ct_Any);
   end
   else begin
    Found:=NotFound;
    Cycle:=nil;
    if CEndType=ct_If then OpNum:=6 else OpNum:=9;
    repeat
     GoToLine(Line+1);
     if (Cycle=nil) and Compare(S,Operators[OpNum])
      then Found:=FoundEnd
      else if Compare(S,Operators[4]) {if}
       then AddCycle(ct_If)
       else if Compare(S,Operators[7]) or Compare(S,Operators[8]) {while,cycle}
        then AddCycle(ct_Any)
        else if Compare(S,Operators[6]) {endif}
         then DelCycle(ct_If)
         else if Compare(S,Operators[9]) {cycle_end}
          then DelCycle(ct_Any)
          else if IfOp and (Cycle=nil) and Compare(S,Operators[5]) {else}
           then Found:=FoundElse;
    until Found<>NotFound;
    if Found=FoundEnd then CloseCycle(ct_Any);
   end;
 end;

begin     { *** Main *** }
 Randomize;
 Writeln('---------');
 {$IFDEF Debug}
 Writeln(#13#10,'Free memory:',MemAvail,'/',MaxAvail);
 {$ENDIF}
 if ParamCount<1 then Error('Использование: ral <имя-файла>');
 Assign(F,ParamStr(1));
 {$I-}
 Reset(F);
 {$I+}
 if IOResult<>0 then
   Error('Не найден файл '+ParamStr(1));
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
  HotJump:=true;
  RepeatThis:
  if S[1]='['
   then CreateArray(S)
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
         if not Found
          then Error('Неизвестный оператор '+Part);
         case Num of
          1,3:; {program,end}
          2:if Length(S)<>0 then CreateArray(S); {begin}
          4:if Copy(S,Length(S)-2,3)<>' то' {if}
             then Error('Пропущено "то"')
             else begin
              Dec(S[0],3);
              NewCycle(ct_If);
              if Calc(S)=0 then FindEOCycle(ct_If,true);
             end;
          6:CloseCycle(ct_If);   {endif}
          5:FindEOCycle(ct_If,false); {else}
          7:begin {while}
             NewCycle(ct_While);
             if Calc(S)=0 then FindEOCycle(ct_Any,false);
            end;
          9:if CurCycle=nil then Error(emEndWithoutBegin) {cycle_end}
            else with CurCycle^ do begin
             FinishLine:=Line;
             case CType of
              ct_If:Error(emEndWithoutBegin);
              ct_While:
                begin
                 GotoLine(StartLine);
                 goto RepeatThis;
                end;
              ct_For:
                begin
                 GoToLine(StartLine);
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
              if P=0 then Error('Пропущено ":="');
              Part:=Copy(S,1,P-1);
              Delete(S,1,P+1);
              P:=Pos(' до ',S);
              if P=0 then Error('Пропущено "до"');
              S1:=Copy(S,1,P-1);
              Delete(S,1,P+3);
              P:=Pos(' шаг ',S);
              if P=0 then Number:=1
              else begin
               Number:=Calc(Copy(S,P+5,Length(S)-P-4));
               S[0]:=char(P-1);
              end;
              if HotJump then begin
               NewCycle(ct_For);
               AssignNum(Part,Calc(S1));
              end
              else begin
               AssignNum(Part,Calc(Part)+Number);
              end;
              if Number>0
               then begin if Calc(Part)>Calc(S) then FindEOCycle(ct_Any,false); end
               else begin if Calc(Part)<Calc(S) then FindEOCycle(ct_Any,false); end;
             end
             else if S<>'' then Error('Пропущено "от"')
              else NewCycle(ct_Repeat); {repeat}
          10:if (CurCycle=nil) or (CurCycle^.CType<>ct_Repeat) {exit_if}
              then Error('"при" без "цикл"')
              else begin
               if Copy(S,Length(S)-4,5)<>'выход' then Error('Пропущен "выход"');
               Dec(S[0],5);
               while (Length(S)>0) and (S[Length(S)]=' ') do Dec(S[0]);
               if Calc(S)<>0 then FindEOCycle(ct_Any,false)
              end;
         end;
        end;
      ctProcedure:
        begin
         if S[Length(S)]<>')' then Error('Нет закрывающей скобки');
         Num:=0;
         repeat
          Inc(Num);
          Found:=Part=Procedures[Num];
         until Found or (Num>=OpsNum);
         if not Found
          then Error('Неизвестная процедура '+Part);
         Dec(S[0]);
         case Num of
          1:begin
             while GetParam(Part,S) do
             begin
              GetType(Part,False);
              if VarType and vtmSymb=vtmSymb then
               begin
                FindOperator(Part,P);
                if (P>0) and ((Part[P]='=') or (Part[P]='<') or (Part[P]='>'))
                 then VarType:=vtNumVar;
               end;
              if VarType and vtmSymb = vtmSymb
               then Write(CalcSymb(Part))
               else
                begin
                 Str(Calc(Part):0:20,Part);
                 if Pos('E',Part)=0 then
                  begin
                   while (Length(Part)>0) and (Part[Length(Part)]='0') do
                    Dec(Part[0]);
                   if Part[Length(Part)]='.' then Dec(Part[0]);
                  end;
                 Write(Part);
                end;
             end;
             Writeln;
            end;
          2:begin
             while GetParam(Part,S) do
              begin
               if Part[1]='"'
                then
                 begin
                  { CalcSymb ... }
                  Write(Copy(Part,2,Length(Part)-2));
                 end
                else
                 begin
                  GetType(Part,false);
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
                   end
                   else begin
                    ReadLn(TempStr);
                    AssignSymb(Part,TempStr);
                   end;
                 end;
              end;
            end;
         end;
        end;
      ctAssigment:
        begin
         Delete(S,1,1);
         GetType(Part,False);
         if VarType and vtmSymb <> vtmSymb
          then AssignNum(Part,Calc(S))
          else AssignSymb(Part,CalcSymb(S));
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
end.