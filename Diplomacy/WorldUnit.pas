{ -= ���� "����������" =- }
{ ������ �������� �������� ����
  �������� ������������� ������� �������� ����
    - ������ � �� ��������;
   ...
}

unit WorldUnit;

interface

Const MaxCountry = 20;
      CostPercent = 1000;

Const
  CountryNames : Array [1..MaxCountry] of String = (
    '������','�������','��������','���','������',
    '������','������','����','�������','��������',
    '�����','�������','������','������','�������',
    '������','��������','���������','������','�������');

{ ���� �������� }
Type
  TDiplomacyCost=Record
    Money,Zerno,Space:LongInt;
    MoveRight,Peace:Boolean;
    ViewCountry:Integer;
  End;

{ ������ ������ }
Type
  TCountry = Class(TObject)
  private
    function GetPeasant: LongInt;
  public
    Name : String; { �������� ������ }
    Space : Longint; { ���������� }
    Population : Longint; { ��������� }
    { -= ��������� =- }
    Money:LongInt;
    EarthZerno : Longint; { ������� ����� � ���� ���� }
    Zerno : Longint; { ������ ����� }
    { ��������� }
    //Peasant : Longint; { ����� �������� }
    Scientist : Longint; { ����� ������ }
    Soldier : Longint; { ����� ������ }
    { -= ���������� =- }
    Peace       : Array [1..MaxCountry] of Boolean; { �������� ��� }
    ViewCountry : Array [1..MaxCountry] of Boolean; { ����� }
    GoodCountry : Array [1..MaxCountry] of Integer; { ��������� }
    MoveRight   : Array [1..MaxCountry] of Boolean; { ����� ������� }
    { -= ��������� =- }
    { ��������� }
    Property Peasant:LongInt
      Read GetPeasant;
    { -= ���������� =- }
    Procedure DiplomacyClear(N:Integer);
    Procedure DiplomacyPeace(N:Integer);
    Procedure DiplomacyWar(N:Integer);
    Function DiplomacyCostScoreNumber(C:TDiplomacyCost;N:Integer):LongInt;
    Function DiplomacyCostScoreFlag(C:TDiplomacyCost;N:Integer):LongInt;
    Function DiplomacyAcceptable(S,O:TDiplomacyCost;N:Integer):Boolean;
    Procedure DiplomacyAccept(I,D:TDiplomacyCost;N:Integer);
    Function CanPay(C:TDiplomacyCost):Boolean;
    Function DiplomacyGood(S,O:TDiplomacyCost;N:Integer):LongInt;
    { �������� ������ }
    Constructor Create;
  End;

Var Countries:Array [1..MaxCountry] of TCountry;
    NumCountries:LongInt = 0;

Procedure DiplomacyAction(S,O:TDiplomacyCost;NS,NO:Integer);
Function NullDiplomacyCost:TDiplomacyCost;

implementation

Function NullDiplomacyCost:TDiplomacyCost;
Begin
  With Result do
    Begin
      Space:=0;
      Money:=0;
      Zerno:=0;
      Peace:=False;
      ViewCountry:=0;
      MoveRight:=False;
    End;
End;

Procedure DiplomacyAction(S,O:TDiplomacyCost;NS,NO:Integer);
Begin
  With Countries[NS] do
    Begin
      Inc(GoodCountry[NO],DiplomacyGood(S,O,NO));
      DiplomacyAccept(O,S,NO);
    End;
  With Countries[NO] do
    Begin
      Inc(GoodCountry[NS],DiplomacyGood(O,S,NS));
      DiplomacyAccept(S,O,NS);
    End;
End;

{ TCountry }

function TCountry.CanPay(C: TDiplomacyCost): Boolean;
begin
  Result:=False;
  If (C.Money>Money)Or(C.Zerno>Zerno)Or(C.Space>Space)then Exit;
  If C.ViewCountry<>0 then
    If Not ViewCountry[C.ViewCountry] then Exit;
  Result:=True;
end;

constructor TCountry.Create;
Var I:Integer;
begin
  inherited;
  {��������� ��� ����}
  Space:=100;
  Population:=500;
  Money:=10000;
  EarthZerno:=0;
  Zerno:=100;
  Scientist:=100;
  Soldier:=100;
  For I:=1 to MaxCountry do
    DiplomacyClear(I);
end;

procedure TCountry.DiplomacyAccept;
begin
  Inc(Money,I.Money);
  Dec(Money,D.Money);
  Inc(Zerno,I.Zerno);
  Dec(Zerno,D.Zerno);
  If I.ViewCountry<>0 then
    ViewCountry[I.ViewCountry]:=True;
  If I.MoveRight then
    MoveRight[N]:=True;
  If I.Peace then
    DiplomacyPeace(N);
end;

function TCountry.DiplomacyAcceptable;
Var
  R:LongInt;
  Null:TDiplomacyCost;
begin
  Result:=False;
  If Not CanPay(S) then Exit;
  {Null:=NullDiplomacyCost;
  If
    (DiplomacyGood(Null,0,N)=0)And
    (DiplomacyGood(S,Null,N)=0)then
    Exit;}
  R:=DiplomacyGood(S,O,N)+
    GoodCountry[N];
  Result:=(R>=0);
end;

procedure TCountry.DiplomacyClear;
begin
  Peace[N]:=True;
  ViewCountry[N]:=False;
  MoveRight[N]:=False;
  GoodCountry[N]:=0;
end;

function TCountry.DiplomacyCostScoreFlag(C: TDiplomacyCost;
  N: Integer): LongInt;
begin
  Result:=0;
  If C.Peace And Not Peace[N] then
    Inc(Result,100*CostPercent);
end;

function TCountry.DiplomacyCostScoreNumber(C: TDiplomacyCost;N: Integer): LongInt;
Var Size,NSize:LongInt;
begin
  Result:=0;
  Size:=Space;
  With C do
    Begin
      Inc(Result,Money*10*CostPercent Div Size);
      Inc(Result,Zerno*10*CostPercent Div Size);
      Inc(Result,Space*10000*CostPercent Div Size);
      If N=0 then Exit;
      NSize:=Countries[N].Space;
      If MoveRight And Not Self.MoveRight[N] then
        Inc(Result,NSize*100*CostPercent Div Size);
      If (ViewCountry<>0) And Not Self.ViewCountry[N] then
        Inc(Result,20*CostPercent);
    End;
end;

function TCountry.DiplomacyGood(S, O: TDiplomacyCost; N: Integer): LongInt;
begin
  Result:=
    DiplomacyCostScoreNumber(S,N)-
    DiplomacyCostScoreNumber(O,0)+
    DiplomacyCostScoreFlag  (S,N);
end;

procedure TCountry.DiplomacyPeace;
begin
  If Peace[N] then Exit;
  Peace[N]:=True;
  //Inc(GoodCountry[N],100);
end;

procedure TCountry.DiplomacyWar;
begin
  If Not Peace[N] then Exit;
  Peace[N]:=False;
  MoveRight[N]:=False;
  Dec(GoodCountry[N],100*CostPercent);
end;

function TCountry.GetPeasant: LongInt;
begin
  Result:=Population-Scientist-Soldier;
end;

end.
