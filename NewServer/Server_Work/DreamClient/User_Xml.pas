
{*************************************************************}
{                                                             }
{                   Delphi XML Data Binding                   }
{                                                             }
{         Generated on: 23.07.2003 20:57:13                   }
{       Generated from: E:\Server_Work\DreamClient\User.xml   }
{   Settings stored in: E:\Server_Work\DreamClient\User.xdb   }
{                                                             }
{*************************************************************}
unit User_Xml;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLConfigType = interface;
  IXMLProblemsType = interface;
  IXMLProblemType = interface;
  IXMLCompilersType = interface;
  IXMLCompilatorType = interface;
  IXMLPathsType = interface;

{ IXMLConfigType }

  IXMLConfigType = interface(IXMLNode)
    ['{8B955F7B-141B-4B2C-B77F-B7F61236D082}']
    { Property Accessors }
    function Get_Problems: IXMLProblemsType;
    function Get_Compilers: IXMLCompilersType;
    function Get_Paths: IXMLPathsType;
    { Methods & Properties }
    property Problems: IXMLProblemsType read Get_Problems;
    property Compilers: IXMLCompilersType read Get_Compilers;
    property Paths: IXMLPathsType read Get_Paths;
  end;

{ IXMLProblemsType }

  IXMLProblemsType = interface(IXMLNodeCollection)
    ['{66068E46-AD67-442E-98D4-EFFFDAD1E552}']
    { Property Accessors }
    function Get_Problem(Index: Integer): IXMLProblemType;
    { Methods & Properties }
    function Add: IXMLProblemType;
    function Insert(const Index: Integer): IXMLProblemType;
    property Problem[Index: Integer]: IXMLProblemType read Get_Problem; default;
  end;

{ IXMLProblemType }

  IXMLProblemType = interface(IXMLNode)
    ['{BC3266A0-127F-4086-BB3E-1F5F9AFA3189}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Name: WideString;
    function Get_Litera: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property Name: WideString read Get_Name write Set_Name;
    property Litera: WideString read Get_Litera write Set_Litera;
  end;

{ IXMLCompilersType }

  IXMLCompilersType = interface(IXMLNodeCollection)
    ['{41F86075-4BFC-473B-AC4E-88EEC7DCB9A4}']
    { Property Accessors }
    function Get_Compilator(Index: Integer): IXMLCompilatorType;
    { Methods & Properties }
    function Add: IXMLCompilatorType;
    function Insert(const Index: Integer): IXMLCompilatorType;
    property Compilator[Index: Integer]: IXMLCompilatorType read Get_Compilator; default;
  end;

{ IXMLCompilatorType }

  IXMLCompilatorType = interface(IXMLNode)
    ['{10511014-B4ED-4914-8251-EF376557987E}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Mask: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Mask(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Mask: WideString read Get_Mask write Set_Mask;
  end;

{ IXMLPathsType }

  IXMLPathsType = interface(IXMLNode)
    ['{E25BB73F-19D3-4A52-AA7D-9A271AD29025}']
    { Property Accessors }
    function Get_Queue: WideString;
    procedure Set_Queue(Value: WideString);
    { Methods & Properties }
    property Queue: WideString read Get_Queue write Set_Queue;
  end;

{ Forward Decls }

  TXMLConfigType = class;
  TXMLProblemsType = class;
  TXMLProblemType = class;
  TXMLCompilersType = class;
  TXMLCompilatorType = class;
  TXMLPathsType = class;

{ TXMLConfigType }

  TXMLConfigType = class(TXMLNode, IXMLConfigType)
  protected
    { IXMLConfigType }
    function Get_Problems: IXMLProblemsType;
    function Get_Compilers: IXMLCompilersType;
    function Get_Paths: IXMLPathsType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLProblemsType }

  TXMLProblemsType = class(TXMLNodeCollection, IXMLProblemsType)
  protected
    { IXMLProblemsType }
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
    function Get_ID: Integer;
    function Get_Name: WideString;
    function Get_Litera: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
  end;

{ TXMLCompilersType }

  TXMLCompilersType = class(TXMLNodeCollection, IXMLCompilersType)
  protected
    { IXMLCompilersType }
    function Get_Compilator(Index: Integer): IXMLCompilatorType;
    function Add: IXMLCompilatorType;
    function Insert(const Index: Integer): IXMLCompilatorType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCompilatorType }

  TXMLCompilatorType = class(TXMLNode, IXMLCompilatorType)
  protected
    { IXMLCompilatorType }
    function Get_Name: WideString;
    function Get_Mask: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Mask(Value: WideString);
  end;

{ TXMLPathsType }

  TXMLPathsType = class(TXMLNode, IXMLPathsType)
  protected
    { IXMLPathsType }
    function Get_Queue: WideString;
    procedure Set_Queue(Value: WideString);
  end;

{ Global Functions }

function GetConfig(Doc: IXMLDocument): IXMLConfigType;
function LoadConfig(const FileName: WideString): IXMLConfigType;
function NewConfig: IXMLConfigType;

implementation

{ Global Functions }

function GetConfig(Doc: IXMLDocument): IXMLConfigType;
begin
  Result := Doc.GetDocBinding('Config', TXMLConfigType) as IXMLConfigType;
end;
function LoadConfig(const FileName: WideString): IXMLConfigType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Config', TXMLConfigType) as IXMLConfigType;
end;

function NewConfig: IXMLConfigType;
begin
  Result := NewXMLDocument.GetDocBinding('Config', TXMLConfigType) as IXMLConfigType;
end;

{ TXMLConfigType }

procedure TXMLConfigType.AfterConstruction;
begin
  RegisterChildNode('Problems', TXMLProblemsType);
  RegisterChildNode('Compilers', TXMLCompilersType);
  RegisterChildNode('Paths', TXMLPathsType);
  inherited;
end;

function TXMLConfigType.Get_Problems: IXMLProblemsType;
begin
  Result := ChildNodes['Problems'] as IXMLProblemsType;
end;

function TXMLConfigType.Get_Compilers: IXMLCompilersType;
begin
  Result := ChildNodes['Compilers'] as IXMLCompilersType;
end;

function TXMLConfigType.Get_Paths: IXMLPathsType;
begin
  Result := ChildNodes['Paths'] as IXMLPathsType;
end;

{ TXMLProblemsType }

procedure TXMLProblemsType.AfterConstruction;
begin
  RegisterChildNode('Problem', TXMLProblemType);
  ItemTag := 'Problem';
  ItemInterface := IXMLProblemType;
  inherited;
end;

function TXMLProblemsType.Get_Problem(Index: Integer): IXMLProblemType;
begin
  Result := List[Index] as IXMLProblemType;
end;

function TXMLProblemsType.Add: IXMLProblemType;
begin
  Result := AddItem(-1) as IXMLProblemType;
end;

function TXMLProblemsType.Insert(const Index: Integer): IXMLProblemType;
begin
  Result := AddItem(Index) as IXMLProblemType;
end;


{ TXMLProblemType }

function TXMLProblemType.Get_ID: Integer;
begin
  Result := ChildNodes['ID'].NodeValue;
end;

procedure TXMLProblemType.Set_ID(Value: Integer);
begin
  ChildNodes['ID'].NodeValue := Value;
end;

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

{ TXMLCompilersType }

procedure TXMLCompilersType.AfterConstruction;
begin
  RegisterChildNode('Compilator', TXMLCompilatorType);
  ItemTag := 'Compilator';
  ItemInterface := IXMLCompilatorType;
  inherited;
end;

function TXMLCompilersType.Get_Compilator(Index: Integer): IXMLCompilatorType;
begin
  Result := List[Index] as IXMLCompilatorType;
end;

function TXMLCompilersType.Add: IXMLCompilatorType;
begin
  Result := AddItem(-1) as IXMLCompilatorType;
end;

function TXMLCompilersType.Insert(const Index: Integer): IXMLCompilatorType;
begin
  Result := AddItem(Index) as IXMLCompilatorType;
end;


{ TXMLCompilatorType }

function TXMLCompilatorType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLCompilatorType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLCompilatorType.Get_Mask: WideString;
begin
  Result := ChildNodes['Mask'].Text;
end;

procedure TXMLCompilatorType.Set_Mask(Value: WideString);
begin
  ChildNodes['Mask'].NodeValue := Value;
end;

{ TXMLPathsType }

function TXMLPathsType.Get_Queue: WideString;
begin
  Result := ChildNodes['Queue'].Text;
end;

procedure TXMLPathsType.Set_Queue(Value: WideString);
begin
  ChildNodes['Queue'].NodeValue := Value;
end;

end.
