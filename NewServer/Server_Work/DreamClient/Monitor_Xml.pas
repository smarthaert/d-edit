
{***********************************************************}
{                                                           }
{                  Delphi XML Data Binding                  }
{                                                           }
{         Generated on: 24.07.2003 18:17:17                 }
{       Generated from: E:\Server_Work\Server\MONITOR.XML   }
{   Settings stored in: E:\Server_Work\Server\MONITOR.xdb   }
{                                                           }
{***********************************************************}
unit monitor_XML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLMONITORType = interface;
  IXMLUSERSTypes = interface;
  IXMLUSERTypes = interface;
  IXMLDataType = interface;
  IXMLSubmitsType = interface;
  IXMLSubmitType = interface;
  IXMLPROBLEMSType = interface;
  IXMLProblemType = interface;

{ IXMLMONITORType }

  IXMLMONITORType = interface(IXMLNode)
    ['{5D1EF406-3A16-4D2A-8FDF-A02FE67DEFCA}']
    { Property Accessors }
    function Get_USERS: IXMLUSERSTypes;
    function Get_PROBLEMS: IXMLPROBLEMSType;
    { Methods & Properties }
    property USERS: IXMLUSERSTypes read Get_USERS;
    property PROBLEMS: IXMLPROBLEMSType read Get_PROBLEMS;
  end;

{ IXMLUSERSTypes }

  IXMLUSERSTypes = interface(IXMLNodeCollection)
    ['{042AEBBA-DB79-4DCA-A77C-309695CDEE24}']
    { Property Accessors }
    function Get_USER(Index: Integer): IXMLUSERTypes;
    { Methods & Properties }
    function Add: IXMLUSERTypes;
    function Insert(const Index: Integer): IXMLUSERTypes;
    property USER[Index: Integer]: IXMLUSERTypes read Get_USER; default;
  end;

{ IXMLUSERTypes }

  IXMLUSERTypes = interface(IXMLNode)
    ['{FD6B23FC-5F13-4816-8180-86B03D9EC5FF}']
    { Property Accessors }
    function Get_Data: IXMLDataType;
    function Get_Submits: IXMLSubmitsType;
    { Methods & Properties }
    property Data: IXMLDataType read Get_Data;
    property Submits: IXMLSubmitsType read Get_Submits;
  end;

{ IXMLDataType }

  IXMLDataType = interface(IXMLNode)
    ['{9905C068-85F1-4813-8E7C-559CFAF9CF7C}']
    { Property Accessors }
    function Get_U_Name: WideString;
    function Get_Rank: Integer;
    function Get_Time: Integer;
    function Get_Solved: Integer;
    procedure Set_U_Name(Value: WideString);
    procedure Set_Rank(Value: Integer);
    procedure Set_Time(Value: Integer);
    procedure Set_Solved(Value: Integer);
    { Methods & Properties }
    property U_Name: WideString read Get_U_Name write Set_U_Name;
    property Rank: Integer read Get_Rank write Set_Rank;
    property Time: Integer read Get_Time write Set_Time;
    property Solved: Integer read Get_Solved write Set_Solved;
  end;

{ IXMLSubmitsType }

  IXMLSubmitsType = interface(IXMLNodeCollection)
    ['{A6454152-5845-4307-A7A7-5036790D4E1A}']
    { Property Accessors }
    function Get_Submit(Index: Integer): IXMLSubmitType;
    { Methods & Properties }
    function Add: IXMLSubmitType;
    function Insert(const Index: Integer): IXMLSubmitType;
    property Submit[Index: Integer]: IXMLSubmitType read Get_Submit; default;
  end;

{ IXMLSubmitType }

  IXMLSubmitType = interface(IXMLNode)
    ['{7D0FA1D7-B457-46DD-BE4B-906D352D7685}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_NUM_Submits: WideString;
    function Get_Kol_Submits: Integer;
    function Get_Solve_Time: Integer;
    function Get_Balls: Integer;
    procedure Set_ID(Value: Integer);
    procedure Set_NUM_Submits(Value: WideString);
    procedure Set_Kol_Submits(Value: Integer);
    procedure Set_Solve_Time(Value: Integer);
    procedure Set_Balls(Value: Integer);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property NUM_Submits: WideString read Get_NUM_Submits write Set_NUM_Submits;
    property Kol_Submits: Integer read Get_Kol_Submits write Set_Kol_Submits;
    property Solve_Time: Integer read Get_Solve_Time write Set_Solve_Time;
    property Balls: Integer read Get_Balls write Set_Balls;
  end;

{ IXMLPROBLEMSType }

  IXMLPROBLEMSType = interface(IXMLNodeCollection)
    ['{E5A4FEBC-A0F5-444F-8162-DBF709B292AE}']
    { Property Accessors }
    function Get_Problem(Index: Integer): IXMLProblemType;
    { Methods & Properties }
    function Add: IXMLProblemType;
    function Insert(const Index: Integer): IXMLProblemType;
    property Problem[Index: Integer]: IXMLProblemType read Get_Problem; default;
  end;

{ IXMLProblemType }

  IXMLProblemType = interface(IXMLNode)
    ['{9D2FF712-A40E-49BB-B0D3-1570D01310A7}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Litera: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Litera: WideString read Get_Litera write Set_Litera;
  end;

{ Forward Decls }

  TXMLMONITORType = class;
  TXMLUSERSType = class;
  TXMLUSERType = class;
  TXMLDataType = class;
  TXMLSubmitsType = class;
  TXMLSubmitType = class;
  TXMLPROBLEMSType = class;
  TXMLProblemType = class;

{ TXMLMONITORType }

  TXMLMONITORType = class(TXMLNode, IXMLMONITORType)
  protected
    { IXMLMONITORType }
    function Get_USERS: IXMLUSERSTypes;
    function Get_PROBLEMS: IXMLPROBLEMSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLUSERSType }

  TXMLUSERSType = class(TXMLNodeCollection, IXMLUSERSTypes)
  protected
    { IXMLUSERSTypes }
    function Get_USER(Index: Integer): IXMLUSERTypes;
    function Add: IXMLUSERTypes;
    function Insert(const Index: Integer): IXMLUSERTypes;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLUSERType }

  TXMLUSERType = class(TXMLNode, IXMLUSERTypes)
  protected
    { IXMLUSERTypes }
    function Get_Data: IXMLDataType;
    function Get_Submits: IXMLSubmitsType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDataType }

  TXMLDataType = class(TXMLNode, IXMLDataType)
  protected
    { IXMLDataType }
    function Get_U_Name: WideString;
    function Get_Rank: Integer;
    function Get_Time: Integer;
    function Get_Solved: Integer;
    procedure Set_U_Name(Value: WideString);
    procedure Set_Rank(Value: Integer);
    procedure Set_Time(Value: Integer);
    procedure Set_Solved(Value: Integer);
  end;

{ TXMLSubmitsType }

  TXMLSubmitsType = class(TXMLNodeCollection, IXMLSubmitsType)
  protected
    { IXMLSubmitsType }
    function Get_Submit(Index: Integer): IXMLSubmitType;
    function Add: IXMLSubmitType;
    function Insert(const Index: Integer): IXMLSubmitType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSubmitType }

  TXMLSubmitType = class(TXMLNode, IXMLSubmitType)
  protected
    { IXMLSubmitType }
    function Get_ID: Integer;
    function Get_NUM_Submits: WideString;
    function Get_Kol_Submits: Integer;
    function Get_Solve_Time: Integer;
    function Get_Balls: Integer;
    procedure Set_ID(Value: Integer);
    procedure Set_NUM_Submits(Value: WideString);
    procedure Set_Kol_Submits(Value: Integer);
    procedure Set_Solve_Time(Value: Integer);
    procedure Set_Balls(Value: Integer);
  end;

{ TXMLPROBLEMSType }

  TXMLPROBLEMSType = class(TXMLNodeCollection, IXMLPROBLEMSType)
  protected
    { IXMLPROBLEMSType }
    function Get_Problem(Index: Integer): IXMLProblemType;
    function Add: IXMLProblemType;
    function Insert(const Index: Integer): IXMLProblemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLProblemType }

  TXMLProblemType = class(TXMLNode, IXMLProblemType)
  protected
    { IXMLProblemType }
    function Get_Name: WideString;
    function Get_Litera: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
  end;

{ Global Functions }

function GetMONITOR(Doc: IXMLDocument): IXMLMONITORType;
function LoadMONITOR(const FileName: WideString): IXMLMONITORType;
function NewMONITOR: IXMLMONITORType;

implementation

{ Global Functions }

function GetMONITOR(Doc: IXMLDocument): IXMLMONITORType;
begin
  Result := Doc.GetDocBinding('MONITOR', TXMLMONITORType) as IXMLMONITORType;
end;
function LoadMONITOR(const FileName: WideString): IXMLMONITORType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('MONITOR', TXMLMONITORType) as IXMLMONITORType;
end;

function NewMONITOR: IXMLMONITORType;
begin
  Result := NewXMLDocument.GetDocBinding('MONITOR', TXMLMONITORType) as IXMLMONITORType;
end;

{ TXMLMONITORType }

procedure TXMLMONITORType.AfterConstruction;
begin
  RegisterChildNode('USERS', TXMLUSERSType);
  RegisterChildNode('PROBLEMS', TXMLPROBLEMSType);
  inherited;
end;

function TXMLMONITORType.Get_USERS: IXMLUSERSTypes;
begin
  Result := ChildNodes['USERS'] as IXMLUSERSTypes;
end;

function TXMLMONITORType.Get_PROBLEMS: IXMLPROBLEMSType;
begin
  Result := ChildNodes['PROBLEMS'] as IXMLPROBLEMSType;
end;

{ TXMLUSERSType }

procedure TXMLUSERSType.AfterConstruction;
begin
  RegisterChildNode('USER', TXMLUSERType);
  ItemTag := 'USER';
  ItemInterface := IXMLUSERTypes;
  inherited;
end;

function TXMLUSERSType.Get_USER(Index: Integer): IXMLUSERTypes;
begin
  Result := List[Index] as IXMLUSERTypes;
end;

function TXMLUSERSType.Add: IXMLUSERTypes;
begin
  Result := AddItem(-1) as IXMLUSERTypes;
end;

function TXMLUSERSType.Insert(const Index: Integer): IXMLUSERTypes;
begin
  Result := AddItem(Index) as IXMLUSERTypes;
end;


{ TXMLUSERType }

procedure TXMLUSERType.AfterConstruction;
begin
  RegisterChildNode('Data', TXMLDataType);
  RegisterChildNode('Submits', TXMLSubmitsType);
  inherited;
end;

function TXMLUSERType.Get_Data: IXMLDataType;
begin
  Result := ChildNodes['Data'] as IXMLDataType;
end;

function TXMLUSERType.Get_Submits: IXMLSubmitsType;
begin
  Result := ChildNodes['Submits'] as IXMLSubmitsType;
end;

{ TXMLDataType }

function TXMLDataType.Get_U_Name: WideString;
begin
  Result := ChildNodes['U_Name'].Text;
end;

procedure TXMLDataType.Set_U_Name(Value: WideString);
begin
  ChildNodes['U_Name'].NodeValue := Value;
end;

function TXMLDataType.Get_Rank: Integer;
begin
  Result := ChildNodes['Rank'].NodeValue;
end;

procedure TXMLDataType.Set_Rank(Value: Integer);
begin
  ChildNodes['Rank'].NodeValue := Value;
end;

function TXMLDataType.Get_Time: Integer;
begin
  Result := ChildNodes['Time'].NodeValue;
end;

procedure TXMLDataType.Set_Time(Value: Integer);
begin
  ChildNodes['Time'].NodeValue := Value;
end;

function TXMLDataType.Get_Solved: Integer;
begin
  Result := ChildNodes['Solved'].NodeValue;
end;

procedure TXMLDataType.Set_Solved(Value: Integer);
begin
  ChildNodes['Solved'].NodeValue := Value;
end;

{ TXMLSubmitsType }

procedure TXMLSubmitsType.AfterConstruction;
begin
  RegisterChildNode('Submit', TXMLSubmitType);
  ItemTag := 'Submit';
  ItemInterface := IXMLSubmitType;
  inherited;
end;

function TXMLSubmitsType.Get_Submit(Index: Integer): IXMLSubmitType;
begin
  Result := List[Index] as IXMLSubmitType;
end;

function TXMLSubmitsType.Add: IXMLSubmitType;
begin
  Result := AddItem(-1) as IXMLSubmitType;
end;

function TXMLSubmitsType.Insert(const Index: Integer): IXMLSubmitType;
begin
  Result := AddItem(Index) as IXMLSubmitType;
end;


{ TXMLSubmitType }

function TXMLSubmitType.Get_ID: Integer;
begin
  Result := ChildNodes['ID'].NodeValue;
end;

procedure TXMLSubmitType.Set_ID(Value: Integer);
begin
  ChildNodes['ID'].NodeValue := Value;
end;

function TXMLSubmitType.Get_NUM_Submits: WideString;
begin
  Result := ChildNodes['NUM_Submits'].Text;
end;

procedure TXMLSubmitType.Set_NUM_Submits(Value: WideString);
begin
  ChildNodes['NUM_Submits'].NodeValue := Value;
end;

function TXMLSubmitType.Get_Kol_Submits: Integer;
begin
  Result := ChildNodes['Kol_Submits'].NodeValue;
end;

procedure TXMLSubmitType.Set_Kol_Submits(Value: Integer);
begin
  ChildNodes['Kol_Submits'].NodeValue := Value;
end;

function TXMLSubmitType.Get_Solve_Time: Integer;
begin
  Result := ChildNodes['Solve_Time'].NodeValue;
end;

procedure TXMLSubmitType.Set_Solve_Time(Value: Integer);
begin
  ChildNodes['Solve_Time'].NodeValue := Value;
end;

function TXMLSubmitType.Get_Balls: Integer;
begin
  Result := ChildNodes['Balls'].NodeValue;
end;

procedure TXMLSubmitType.Set_Balls(Value: Integer);
begin
  ChildNodes['Balls'].NodeValue := Value;
end;

{ TXMLPROBLEMSType }

procedure TXMLPROBLEMSType.AfterConstruction;
begin
  RegisterChildNode('Problem', TXMLProblemType);
  ItemTag := 'Problem';
  ItemInterface := IXMLProblemType;
  inherited;
end;

function TXMLPROBLEMSType.Get_Problem(Index: Integer): IXMLProblemType;
begin
  Result := List[Index] as IXMLProblemType;
end;

function TXMLPROBLEMSType.Add: IXMLProblemType;
begin
  Result := AddItem(-1) as IXMLProblemType;
end;

function TXMLPROBLEMSType.Insert(const Index: Integer): IXMLProblemType;
begin
  Result := AddItem(Index) as IXMLProblemType;
end;


{ TXMLProblemType }

function TXMLProblemType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLProblemType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLProblemType.Get_Litera: WideString;
begin
  Result := ChildNodes['Litera'].Text;
end;

procedure TXMLProblemType.Set_Litera(Value: WideString);
begin
  ChildNodes['Litera'].NodeValue := Value;
end;

end.
