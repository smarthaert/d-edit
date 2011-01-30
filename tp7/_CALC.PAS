Unit _Calc;

Interface

type


    FPtr = ^FRec;
    FArray = Array[1..50] of FPtr;
    PFArray = ^FArray;
    OpType = (opCell,opFormula,opValue,opFunc,opSign,opSFunc);
    FRec = Record
      Owner: FPtr;
      Name: String;
      Tp: OpType;
      case OpType of
       opCell: (Left, Right: FPtr);
       opFunc: (ParamsNum: Byte; Params: PFArray);
    end;
    OpString           = String[2];

 var Error: Boolean;

 Var X_Calc : Real;

 Function CalcFormulaTree(P: FPtr) : Real;

 function GetFormula(const S: String): FPtr;

 Function Calculate( Formula:String ):Real;

Implementation

procedure DelFC(var s:string);
var
  sl: byte absolute s;
begin
  if sl>0 then begin Dec(sl); Move(s[2], s[1], sl) end;
end;

Procedure AddStr(var S ; C : char);assembler ;
   asm
        cld
        les Di,S
        inc ES:DI.byte
        mov al,ES:DI.byte
        sub ah,ah
        add DI,AX
        mov al,C
        Stosb
   end;

FUNCTION  PosChar(C: Char; S: string): Byte; assembler;
asm
  les di,S
  xor ch,ch
  mov cl,byte ptr es:[di]
  mov bx,cx
  inc di
  cld
  mov al,C
  repne scasb
  jnz @S
  sub bx,cx
  mov al,bl
  jmp @Q
@S:xor al,al
@Q:
end;

var ErrOcc : Boolean;
    ErrStr : String;
    CellOccured: Boolean;

Const
    Signs  : Set of Char = ['+','-','*','/','^','=','|','\','&','%','#','~','>','<',':'];
    FSigns : Set of Char = ['+','-','*','/','^',':'];
    UnarySigns: Set of Char = ['+','-','~'];

    MaxOperations = 26;

    Prior  : Array [1..MaxOperations] of OpString =
      ('||','&&','^^','~','=','<','>','==','>=','=>','<=','=<',
      '<>','><','\','|','+','-','^','>>','<<','&','%','*','/',':');




Const On = True; Off = False;

Function UpCaseStr( S:String ):String;
  Var Temp:String; I:Byte;
  Begin
    Temp:=S;
    For I:=1 to Length(S) do
      Temp[I]:=UpCase(Temp[I]);
    UpCaseStr:=Temp;
  End;

function IsPrior  (c1,c2 : String) : Boolean;
 var i : Byte;
begin
 i:=1;
 While (c1<>Prior[i]) and (c2<>Prior[i]) and (i<=MaxOperations) do Inc(i);
 IsPrior:=c1=Prior[i];
end;

procedure GetToken( St : String; var Start : Integer; var O : String;var Tp : OpType);
 var I,L   : Integer;
     S,S1  : String;
     B: Boolean;
begin
 St:=UpCaseStr(St);
 O:=Copy(St,Start,250);
 if O[1]='(' then Tp:=opFormula
             else if (O[1]>='0') and (O[1]<='9') or (O[1] = '$') or (O[1] = '.')
                     then Tp:=opValue
                     else if (O[1]>='A') and (O[1]<='Z') or (O[1] = '@')
                             then Tp:=opCell
                             else if O[1] in signs
                                     then
                                      begin
                                       S:=O[1];
                                       if (O[2] in signs) and not (O[1] in UnarySigns)
                                           and not (O[2] in UnarySigns)
                                          then S:=S+O[2];
                                       O:=S;
                                       Tp:=opSign;
                                       Inc(Start, Length(S));
                                       Exit;
                                      end
                                     else
                                      begin
                                       Error:=True;
                                       Exit;
                                      end;
 L:=1;
 S:='';
 Case Tp of
  opFormula : begin
             i:=1;
             S:=O[1];
             repeat
              Inc(L);
              AddStr(S, O[L]);
              Inc(i,Byte(O[L]='(')-Byte(O[L]=')'));
             until ((i=0) and (O[L]=')')) or (L>Byte(O[0]));
             Inc(Start, Length(S));
            end;
  opValue   : begin
               B := On;
               repeat
                AddStr(S, O[L]); B := B and (O[L] in ['0'..'9','E','.']);
                if B and (L < Length(O)) and (O[L] = 'E') and (O[L+1] in ['+','-'])
                  and (S[1] >= '0') and (S[1] <= '9') then
                  begin S := S + O[L+1]; Inc(L); end;
                Inc(L);
               until not (O[L] in ['0'..'9','X','A'..'F','H','O','.']) or (L>Byte(O[0]));
               Inc(Start, Length(S));
               if S[1] = '.' then Insert('0', S, 1);
               if PosChar('.', S) = 0 then
               if S[Length(S)] = 'H' then
                 begin
                   S := '@H'+Copy(S, 1, Length(S)-1);
                   tp := opCell;
                 end else
               if S[1] = '$' then
                 begin
                   S := '@H'+Copy(S, 2, Length(S)-1);
                   tp := opCell;
                 end else
               if (S[Length(S)] = 'B') and (S[2] in ['0'..'1']) then
                 begin
                   S := '@B'+Copy(S, 1, Length(S)-1);
                   tp := opCell;
                 end else
               if S[Length(S)] = 'O' then
                 begin
                   S := '@O'+Copy(S, 1, Length(S)-1);
                   tp := opCell;
                 end else
                  if (S[1] = '0') and (S[0] > #1) then
                   begin
                     tp := opCell;
                     case S[2] of
                       'X': S := '@H'+Copy(S,3,255);
                       'B': S := '@B'+Copy(S,3,255);
                       else S := '@O'+Copy(S,2,255);
                     end;
                   end
             end;
  opCell    : begin
               repeat
               AddStr(S, O[L]);
               Inc(L);
               if (O[L]='(') and (L <= Length(O)) then
                begin
                 I := L;
                 GetToken(O,L,S1,Tp);
                 L := I;
                 S:=S+S1;
                 Tp:=opFunc;
                end;
               until (O[L] in Signs) or (Tp=opFunc) or (L>Byte(O[0]));
               Inc(Start, Length(S));
              end;
 end;
 O:=S;
 ErrOcc:=False;
end;

procedure CalcError;
begin
  Error := True;
end;

function GetCellValue(S: String): Real;
 var C: Char;
     L: LongInt;
     B: Byte absolute S;

 procedure GetValue(N: Integer);
  var I: Integer;
      C: Char;
      K,M: LongInt;
 begin
   L := 0; M := 1;
   for I := 0 to B-1 do
    begin
      C := S[B-I];
      if (C>='0') and (C<='9') then K := Byte(C)-48 else
        if (C>='A') and (C<='F') then K := Byte(C)-55 else
          begin Error := On; Exit; end;
      if K > N - 1 then begin Error := On; Exit; end;
      L := L + K * M;
      M := M * N;
    end;
 end;

begin
 S:=UpCaseStr(S);
 if S = 'PI' then
   begin GetCellValue := PI; Exit end;
 if S = 'X' then
   begin GetCellValue := X_Calc; Exit end;
 if (S[1] = '@') and (B > 2) and (S[2] in ['H','B','O']) then
   begin
      C := UpCase(S[2]); Delete(S, 1, 2);
      case C of
        'H': GetValue(16);
        'B': GetValue(2);
        'O': GetValue(8);
      end;
      GetCellValue := L;
   end else Error := True;
end;

Function CalcFormulaTree(P: FPtr) : Real;

   Function GetFuncValue(P: FPtr) : Real;
    var I: Integer;
        R, R1, R2: Real;
        S: String;
   begin
    S := UpCaseStr(P^.Name); GetFuncValue := 0;
    if S = 'IF' then
     begin
      if (P^.ParamsNum < 2) or (P^.ParamsNum > 3) then
       begin CalcError; Exit; end;
      R := 0; R1 := CalcFormulaTree(P^.Params^[1]); if Error then Exit;
      if (P^.ParamsNum = 2) then begin if R1 <> 0 then R := CalcFormulaTree(P^.Params^[2]) end
       else if R1 <> 0 then R := CalcFormulaTree(P^.Params^[2])
                       else R := CalcFormulaTree(P^.Params^[3]);
      GetFuncValue := R; Exit
     end;
    if P^.ParamsNum = 1 then
     begin
      R := CalcFormulaTree(P^.Params^[1]);
      if not Error then
      begin
        If S='RAD' then begin GetFuncValue:=(R*180)/PI; Exit end;
        If S='GRAD' then begin GetFuncValue:=(R*PI)/180; Exit end;
        If S='COS' then begin GetFuncValue:=Cos(R); Exit end;
        If S='SIN' then begin GetFuncValue:=Sin(R); Exit end;
        If S='SQR' then begin GetFuncValue:=R * R; Exit end;

        IF ((S='ASIN') or (S='ARCSIN')) then
         begin
          if (R=1) then begin GetFuncValue:=PI/2; Exit; end;
          if (1-Sqr(R)>0) then GetFuncValue:=ArcTan(R/Sqrt(1-Sqr(R)))
          else GetFuncValue := 0; Exit end;
        IF ((S='ACOS') or (S='ARCCOS')) then
         begin
          if (R=0) then begin GetFuncValue:=PI/2; Exit; end;
          if ((R<>0) and (1-Sqr(R)>0)) then GetFuncValue:=ArcTan(Sqrt(1-Sqr(R))/R)
          else GetFuncValue := 0; Exit end;

        IF (S='SEC') then
         begin if (Cos(R)<>0) then GetFuncValue:=1/Cos(R) else GetFuncValue := 0; Exit end;
        IF (S='COSEC') then
         begin if (Sin(R)<>0) then GetFuncValue:=1/Sin(R) else GetFuncValue := 0; Exit end;

        IF (S='FACT') then
         begin
          If (R < 0) then begin GetFuncValue := 0; Exit; end;
          If (R = 0) then begin GetFuncValue := 1; Exit; end;
          If (R < 32) then
           begin
            R2 := 1;
            for I := 1 to trunc(R) do
             R2 := R2 * I;
            GetFuncValue := R2;
           end
         else GetFuncValue := 0; Exit end;

        If (S='SQRT') then
         begin if (R >= 0) then GetFuncValue:=Sqrt(R) else Error := On; Exit end;
        If (S='LN') then
         begin if (R > 0) then GetFuncValue:=Ln(R) else Error := On; Exit end;
        If (S='LG') then
         begin if (R > 0) then GetFuncValue:=Ln(R)/Ln(10) else Error := On; Exit end;
        If ((S='TAN') or (S='TG')) then
         begin if (cos(R) <> 0) then GetFuncValue:=Sin(R)/Cos(R) else Error := On; Exit end;
        If S='ARCTAN' then begin GetFuncValue:=ArcTan(R); Exit end;
        If (S='EXP') then
        begin
          if (Abs(R) < 88.0) then GetFuncValue:=Exp(R) else Error := On;
          Exit;
        end;
        If (S='CTAN') or (S='CTG') or (S='COTAN') then
         begin if (Sin(R) <> 0) then GetFuncValue:=Cos(R)/Sin(R) else Error := On; Exit end;
        If S='SIGN' then
         begin if R = 0 then GetFuncValue:=0 else
               if R < 0 then GetFuncValue := -1
                        else GetFuncValue := 1; Exit end;
       end;
      end;
    CalcError;
   end;


 var   R,R1 : Real;
       J, Y1, Y2: Integer;
       X1, X2: Byte;
       BB: Boolean;

 procedure FormulaError;
 begin
  {CalcError(erInvalidFormula)}
   Error := True;
 end;

begin
 CalcFormulaTree:=0; if Error then Exit;
 if p=Nil then Exit;
 if (p^.Tp=opFunc)
    then begin
          R:=GetFuncValue(P);
          CalcFormulaTree := R;
          Exit;
         end;
 if (p^.Tp=opValue) then
  begin
   Val(p^.Name,R,J);
   if J>0 then CalcError;
   CalcFormulaTree:=R; Exit;
  end;
  if (p^.Tp=opCell) then
   begin
    R := GetCellValue(p^.Name);
    CalcFormulaTree := R; Exit;
   end;
  if (p^.Tp=opSign) then
   begin
    if (p^.Name[0] > #2) or (p^.Name = #0) {or (p^.Right = nil) or
       (not (p^.Name[1] in UnarySigns) and (p^.Left =nil))}  then
     begin FormulaError; Exit end;
    if P^.Right = nil then
      begin
       CalcFormulaTree := CalcFormulaTree(p^.Left);
       Exit;
     end;
    R:=CalcFormulaTree(p^.Left);
    R1:=CalcFormulaTree(p^.Right);
    if Error then Exit;
    if p^.Name[0] = #1 then
    begin
     Case p^.Name[1] of
      '+' : R:=R+R1;
      '-' : R:=R-R1;
      '*' : if (Abs(R) > 1) then
                if (1e38/Abs(R) < Abs(R1)) then FormulaError else R:=R*R1
              else
                if (Abs(R1) > 1) and (1e38/Abs(R1) < Abs(R)) then FormulaError else R:=R*R1;
      '|' : if (Abs(R) <= $7FFFFFFF) and (Abs(R1) <= $7FFFFFFF) then
              R := Trunc(R) or Trunc(R1) else FormulaError;
      '&' : if (Abs(R) <= $7FFFFFFF) and (Abs(R1) <= $7FFFFFFF) then
              R := Trunc(R) and Trunc(R1) else FormulaError;
      '%' : if (Abs(R) <= $7FFFFFFF) and (Abs(R1) <= $7FFFFFFF) and (Trunc(R1) <> 0) then
              R := Trunc(R) mod Trunc(R1) else FormulaError;
      '\' : if (Abs(R) <= $7FFFFFFF) and (Abs(R1) <= $7FFFFFFF) then
              R := Trunc(R) xor Trunc(R1) else FormulaError;
      '~' : if (Abs(R1) <= $7FFFFFFF) then
              R := not Integer(Trunc(R1)) else FormulaError;
      '/' : if R1<>0 then R:=R/R1 else Error := On;
      '^' : if (R<>0) then
              begin
               BB := (Frac(R)=0) and (Frac(R1)=0);
               if (R=1) or(R1 = 0) then R:=1 else
                  begin
                   if Abs(R1) > 1e9 then begin Error := On; Exit; end;
                   J := Trunc(Round(R1));
                   if R>0 then Y1:=1 else Y1:=-1;
                   R:=Abs(R);
                   if (Ln(R)<(70/Abs(R1))) then {if R1 < 0 then R:=Exp(-ln(R)*R1)
                                                     else} R:=Exp(ln(R)*R1)
                                      else Error := On;
                   if Odd(J) then R := R*Y1;
                  end;
                if BB then
                  if Abs(Frac(R)) < 0.5 then
                    begin
                       R := Int(R);
                    end else
                    begin
                      if R < 0 then R := Int(R)-1
                               else R := Int(R)+1;
                    end;
              end else Error := On;
      '>' : R := Byte(R>R1);
      '<' : R := Byte(R<R1);
      '=' : R := Byte(R=R1);
       else FormulaError;
     end;
    end else
     Case p^.Name[1] of
      '=': case p^.Name[2] of
            '=': R := Byte(R=R1);
            '>': R := Byte(R>=R1);
            '<': R := Byte(R<=R1);
             else FormulaError;
           end;
      '&': if p^.Name[2] = '&' then R := Byte((R<>0) and (R1<>0)) else FormulaError;
      '|': if p^.Name[2] = '|' then R := Byte((R<>0) or (R1<>0)) else FormulaError;
      '^': if p^.Name[2] = '^' then R := Byte((R<>0) xor (R1<>0)) else FormulaError;
      '>': if p^.Name[2] = '<' then R := Byte(R<>R1) else
            if p^.Name[2] = '=' then R := Byte(R>=R1) else
              if (p^.Name[2] = '>') and (Abs(R) <= $7FFFFFFF) and (Abs(R1) < $7FFFFFFF)
               then R := Trunc(R) shr Trunc(R1) else FormulaError;
      '<': if p^.Name[2] = '>' then R := Byte(R<>R1) else
            if p^.Name[2] = '=' then R := Byte(R<=R1) else
             if (p^.Name[2] = '<') and (Abs(R) <= $7FFFFFFF) and (Abs(R1) < $7FFFFFFF)
               then R := Trunc(R) shl Trunc(R1) else FormulaError;
       else FormulaError;
     end;
    CalcFormulaTree:=R;
   end;

end;

function GetFormulaTree(St : String) : FPtr;

var LastOp,Root,p,
    CurPtr        : FPtr;
    S,S1          : String;
    Tp            : OpType;
    Count         : Integer;

 Procedure NewOperand( S : String);
  var Q, Q1: String;
      A,I: Integer;
 begin
  if tp=opFormula then
    begin
     DelFC(s);Dec(Byte(s[0]));
     p:=GetFormulaTree(s);
    end
    else
    if tp=opFunc then
    begin
     New(p);
     p^.Owner := LastOp;
     p^.Name := Copy(s,1,Pos('(',s)-1);
     p^.Tp := Tp;
     New(p^.Params);
     p^.ParamsNum := 0; p^.Params^[1] := nil;
     Q := Copy(s,Pos('(',s) + 1,200); Dec(Q[0]); I := 1; A := 0;
     While (I <= Length(Q)) do
      begin
       Q1 := '';
       While (I <= Length(Q)) and (Q[I] <> ',') do
        begin
         Q1 := Q1 + Q[I];
         if Q[I] = '(' then Inc(A) else if Q[I] = ')' then Dec(A);
         if A < 0 then begin ErrOcc := True; Exit end;
         Inc(I);
        end;
       if A <> 0 then begin ErrOcc := True; Exit end;
       Inc(p^.ParamsNum); Inc(I);
       p^.Params^[p^.ParamsNum] := GetFormulaTree(Q1);
      end;
    end
    else
    begin
     New(p);
     p^.Owner:=LastOp;
     p^.Left:=Nil;
     p^.Right:=Nil;
     p^.Name:=s;
     p^.Tp:=Tp; CellOccured := CellOccured or (Tp = opCell);
    end;
  if LastOP<>Nil then LastOp^.Right:=p;
  CurPtr:=p;
 end;

 procedure NewSign(S : String);
  Label Loop;
  var q : FPtr;
 begin
  New(p);
  p^.Name:=S;
  p^.Tp:=opSign;
  q:=LastOp;
Loop:
  if q=Nil then
   begin
    Root:=p;
    p^.Left:=CurPtr;
    p^.Right:=Nil;
    p^.Owner:=Nil;
   end
   else
   begin
    if isPrior(s,q^.Name) then
     begin
      While (q<>Nil) and isPrior(s,q^.Name) do q:=q^.Owner;
      CurPtr:=q;
      if q=Nil then CurPtr:=Root;
      GoTo Loop;
     end
     else
     begin
      p^.Owner:=q;
      p^.Left:=q^.Right;
      p^.Right:=Nil;
      q^.Right:=p;
     end
   end;
   LastOp:=p;
   CurPtr:=p;
 end;

begin
 if ErrOcc then Exit;
 LastOp:=Nil;Root:=Nil;CurPtr:=Nil;GetFormulaTree:=Nil;
 Count:=1;
 repeat
  GetToken(St,Count,S,Tp);
  {Inc(Count,Byte(s[0]));}
  if not ErrOcc then
   if Tp=opSign then NewSign(S) else NewOperand(S);
  GetFormulaTree:=Root;
 until (Count>Byte(St[0])) or ErrOcc;
 if (Root=Nil) and not ErrOcc then GetFormulaTree:=CurPtr;

end;

function GetFormula(const S: String): FPtr;
 var A1, A2, I: Integer;
begin
 CellOccured := False; GetFormula := nil;
 ErrOcc := False; A1 := 0; A2 := 0;
 For I := 1 to Length(S) do
  begin
   if S[I] = '(' then Inc(A1) else
      if S[I] = ')' then Dec(A1);
   if A1 < 0 then
    begin ErrOcc := True; Exit end;
  end;
 if A1 > 0 then
    begin ErrOcc := True; Exit end;
 GetFormula := GetFormulaTree(S);
end;

Function Calculate( Formula:String ):Real;
  Begin
    Calculate:=CalcFormulaTree(GetFormula(Formula));
  End;

End.