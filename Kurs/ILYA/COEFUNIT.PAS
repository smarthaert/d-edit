Unit CoefUnit;

Interface

{ *************** }
{ * �����樥�� * }
{ *************** }
 Type
   PDigit = ^TDigit;
   TDigit = Record
     Digit   : ShortInt;
     Stephen : Integer;
     NextDig : PDigit;
   End;

{ --- ����� �� ���� �ᥫ --- }
 Function Min( N1, N2 : LongInt ) : LongInt;
{ --- ����� �� ���� �ᥫ --- }
 Function Max( N1, N2 : LongInt ) : LongInt;
{ --- ���������� ����� --- }
 Procedure AddDigit( Var Root : PDigit; Digit : ShortInt; Stephen : Integer );
{ --- �������� �����樥�� --- }
 Procedure MakeCoef( Var Root : PDigit; Str : String );
{ --- ����⮦���� �����樥�� --- }
 Procedure DelCoef( Var Root : PDigit );
{ --- ������⢨� �����樥�� � �������� �⥯���� --- }
 Function GetDigit( Root : PDigit; Stephen : Integer ) : ShortInt;
{ --- ���ᨬ��쭠� �⥯��� --- }
 Function MaxStep( Root : PDigit ) : Integer;
{ --- �������쭠� �⥯��� --- }
 Function MinStep( Root : PDigit ) : Integer;
{ --- ���뢠�� ���� --- }
 Function CoefSGN( Var Root : PDigit ) : Boolean;
{ --- �뢮� �����樥�� � ����� --- }
 Function ShowCoef( Var Root : PDigit ) : String;
{ --- ����� �� ��ࢮ� ��ண� --- }
 Function Sravn( C1, C2 : PDigit ) : ShortInt;
{ --- �������� �ᥫ --- }
 Function AddCoef( C1, C2 : PDigit ) : PDigit;
{ --- ���⠭�� �ᥫ --- }
 Function SubCoef( C1, C2 : PDigit ) : PDigit;

Implementation

{ --- ����� �� ���� �ᥫ --- }
Function Min( N1, N2 : LongInt ) : LongInt;
  Begin
    If N1 < N2 then Min := N1 Else Min := N2;
  End;

{ --- ����� �� ���� �ᥫ --- }
Function Max( N1, N2 : LongInt ) : LongInt;
  Begin
    If N1 > N2 then Max := N1 Else Max := N2;
  End;

{ --- ���������� ����� --- }
Procedure AddDigit( Var Root : PDigit; Digit : ShortInt; Stephen : Integer );
  Var NewEl : PDigit;
  Begin
    New(NewEl);
    NewEl^.Digit   := Digit;
    NewEl^.Stephen := Stephen;
    NewEl^.NextDig := Root;
    Root           := NewEl;
  End;

{ --- �������� �����樥�� --- }
Procedure MakeCoef( Var Root : PDigit; Str : String );
  Var I, PP : Byte; NewEl, Cur : PDigit;
  Begin
    PP := Pos('.', Str);
    If PP = 0 then PP := Length(Str) + 1;
    Root := nil;
    For I := 1 to Length(Str) do
      If Str[I] in ['1'..'9'] then
        AddDigit( Root, Ord(Str[I]) - Ord('0'), PP - I - Ord(I < PP) );
    If Str[1] = '-' then AddDigit( Root, Ord('-'), 0 );
  End;

{ --- ����⮦���� �����樥�� --- }
Procedure DelCoef( Var Root : PDigit );
  Var Buf : PDigit;
  Begin
    While Root <> nil do
      Begin
        Buf  := Root;
        Root := Root^.NextDig;
        Dispose(Buf);
      End;
  End;

{ --- ������⢨� �����樥�� � �������� �⥯���� --- }
Function GetDigit( Root : PDigit; Stephen : Integer ) : ShortInt;
  Var Flag : ShortInt; Cur : PDigit;
  Begin
    Flag := 0;
    Cur  := Root;
    While Cur <> nil do
      Begin
        If ((Cur^.Stephen = Stephen) And (Cur^.Digit <> Ord('-'))) then
          Flag := Cur^.Digit;
        Cur := Cur^.NextDig;
      End;
    GetDigit := Flag;
  End;

{ --- ���ᨬ��쭠� �⥯��� --- }
Function MaxStep( Root : PDigit ) : Integer;
  Var Max : Integer; C : PDigit;
  Begin
    Max := -MaxInt;
    C := Root;
    While C <> nil do
      Begin
        If C^.Stephen > Max then Max := C^.Stephen;
        C := C^.NextDig;
      End;
    MaxStep := Max;
  End;

{ --- �������쭠� �⥯��� --- }
Function MinStep( Root : PDigit ) : Integer;
  Var Min : Integer; C : PDigit;
  Begin
    Min := MaxInt;
    C := Root;
    While C <> nil do
      Begin
        If C^.Stephen < Min then Min := C^.Stephen;
        C := C^.NextDig;
      End;
    MinStep := Min;
  End;

{ --- ���뢠�� ���� --- }
Function CoefSGN( Var Root : PDigit ) : Boolean;
  Begin
    CoefSGN := True;
    If Root <> nil then
      If Root^.Digit = Ord('-') then
        CoefSGN := False;
  End;

{ --- �뢮� �����樥�� � ����� --- }
Function ShowCoef( Var Root : PDigit ) : String;
  Var Cur : PDigit; I, Max, Min : Integer; S : String;
  Begin
    Cur := Root;
    S := '';
    If Not CoefSGN(Cur) then S := '-';
   { ����塞 ���ᨬ����� �⥯��� }
    Min:=MinStep(Cur);
    Max:=MaxStep(Cur);
    If Max < 0 then Max := 0;
   { ��᫮ �� �窨 }
    For I := Max downto 0 do S := S + Chr(GetDigit(Cur,I) + Ord('0'));
   { ��窠 }
    If Min < 0 then S:=S+'.';
   { ��᫮ ��᫥ �窨 }
    For I := -1 downto Min do S := S + Chr(GetDigit(Cur,I) + Ord('0'));
    ShowCoef := S;
  End;

{ --- ����� �� ��ࢮ� ��ண� --- }
Function Sravn( C1, C2 : PDigit ) : ShortInt;
  Var I, MinS, MaxS : Integer;
  Begin
    Sravn := 0;
    MinS  := Min(MinStep(C1), MinStep(C2));
    MaxS  := Max(MaxStep(C1), MaxStep(C2));
    For I := MaxS downto MinS do
      Begin
        If GetDigit(C1, I) > GetDigit(C2, I) then
          Begin Sravn := 1; Exit; End;
        If GetDigit(C1, I) < GetDigit(C2, I) then
          Begin Sravn := -1; Exit; End;
      End;
  End;

{ --- �������� � ���⠭�� �����樥�⮢ ��� ��� ��९������� --- }
Function Add_Coef( C1, C2 : PDigit; K : ShortInt ) : PDigit;
  Var Root : PDigit; Add, MinS, MaxS, I, Temp : Integer;
  Begin
    Root := nil;
    MinS := Min(MinStep(C1), MinStep(C2));
    MaxS := Max(MaxStep(C1), MaxStep(C2));
    Add:= 0;
    For I := MinS to (MaxS + 1) do
      Begin
        Temp := GetDigit(C1, I) + K * GetDigit(C2, I) + Add;
        Add  := Temp div 10;
        If Temp < 0 then Add := -1;
        Temp := (Temp + 10) mod 10;
        If Temp <> 0 then AddDigit(Root, Temp, I);
      End;
    Add_Coef := Root;
  End;

{ --- �������� �ᥫ --- }
Function AddCoef( C1, C2 : PDigit ) : PDigit;
  Var Root, P1, P2, Temp : PDigit;
  Begin
    P1 := C1; P2 := C2;
   { P1 - ����襥 �� ����� P2 - ����襥 }
    If Sravn(P2, P1) = 1 then Begin Temp := P1; P1 := P2; P2 := Temp; End;
   { �᫨ ��� ����������� ����� }
    If CoefSGN(P1) = CoefSGN(P2) then
      Root := Add_Coef(P1, P2, 1)
   { �᫨ ��� ࠧ���� ����� }
    Else
      Root := Add_Coef(P1, P2, -1);
    If Not CoefSGN(P1) then AddDigit(Root, Ord('-'), 0);
    AddCoef := Root;
  End;

{ --- ���⠭�� �ᥫ --- }
Function SubCoef( C1, C2 : PDigit ) : PDigit;
  Var Root, P1, P2, Temp : PDigit; T : Boolean;
  Begin
    P1 := C1; P2 := C2;
   { P1 - ����襥 �� ����� P2 - ����襥 }
    If Sravn(P2, P1) = 1 then
      Begin Temp := P1; P1 := P2; P2 := Temp; T := True; End
    Else
      T := False;
   { �᫨ ��� ����������� ����� }
    If CoefSGN(P1) = CoefSGN(P2) then
      Root := Add_Coef(P1, P2, -1)
   { �᫨ ��� ࠧ���� ����� }
    Else
      Root := Add_Coef(P1, P2, 1);
    If T then
      Begin If CoefSGN(P1) then AddDigit(Root, Ord('-'), 0); End
    Else
      If Not CoefSGN(P1) then AddDigit(Root, Ord('-'), 0);
    SubCoef := Root;
  End;

End.