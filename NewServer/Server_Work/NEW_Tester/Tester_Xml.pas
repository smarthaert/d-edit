
{**************************************************************}
{                                                              }
{                   Delphi XML Data Binding                    }
{                                                              }
{         Generated on: 18.07.2003 20:31:09                    }
{       Generated from: E:\Server_Work\NEW_Tester\Tester.xml   }
{   Settings stored in: E:\Server_Work\NEW_Tester\Tester.xdb   }
{                                                              }
{**************************************************************}
unit Tester_Xml;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLTESTERType = interface;
  IXMLPATHSType = interface;
  IXMLPROBLEMSType = interface;
  IXMLPROBLEMType = interface;

{ IXMLTESTERType }

  IXMLTESTERType = interface(IXMLNode)
    ['{EF41614E-8FD6-4209-999B-6FDB01B01B29}']
    { Property Accessors }
    function Get_PATHS: IXMLPATHSType;
    function Get_PROBLEMS: IXMLPROBLEMSType;
    { Methods & Properties }
    property PATHS: IXMLPATHSType read Get_PATHS;
    property PROBLEMS: IXMLPROBLEMSType read Get_PROBLEMS;
  end;

{ IXMLPATHSType }

  IXMLPATHSType = interface(IXMLNode)
    ['{7466A504-167E-46BC-B3FE-BC527CC9DE37}']
    { Property Accessors }
    function Get_QUEUE: WideString;
    function Get_MAIN: WideString;
    procedure Set_QUEUE(Value: WideString);
    procedure Set_MAIN(Value: WideString);
    { Methods & Properties }
    property QUEUE: WideString read Get_QUEUE write Set_QUEUE;
    property MAIN: WideString read Get_MAIN write Set_MAIN;
  end;

{ IXMLPROBLEMSType }

  IXMLPROBLEMSType = interface(IXMLNodeCollection)
    ['{68A086C7-5BDB-4A71-AD7F-4DCA39668932}']
    { Property Accessors }
    function Get_PROBLEM(Index: Integer): IXMLPROBLEMType;
    { Methods & Properties }
    function Add: IXMLPROBLEMType;
    function Insert(const Index: Integer): IXMLPROBLEMType;
    property PROBLEM[Index: Integer]: IXMLPROBLEMType read Get_PROBLEM; default;
  end;

{ IXMLPROBLEMType }

  IXMLPROBLEMType = interface(IXMLNode)
    ['{0DD78FA6-9662-4877-94C7-D8253C77879A}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Litera: WideString;
    function Get_INPUT_FILE: WideString;
    function Get_OUTPUT_FILE: WideString;
    function Get_TEST_IN: WideString;
    function Get_TEST_OUT: WideString;
    function Get_TESTS: Integer;
    function Get_TIMELIMIT: Integer;
    function Get_PATH: WideString;
    function Get_TESTER: WideString;
    function Get_STATUS: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Litera(Value: WideString);
    procedure Set_INPUT_FILE(Value: WideString);
    procedure Set_OUTPUT_FILE(Value: WideString);
    procedure Set_TEST_IN(Value: WideString);
    procedure Set_TEST_OUT(Value: WideString);
    procedure Set_TESTS(Value: Integer);
    procedure Set_TIMELIMIT(Value: Integer);
    procedure Set_PATH(Value: WideString);
    procedure Set_TESTER(Value: WideString);
    procedure Set_STATUS(Value: WideString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property Litera: WideString read Get_Litera write Set_Litera;
    property INPUT_FILE: WideString read Get_INPUT_FILE write Set_INPUT_FILE;
    property OUTPUT_FILE: WideString read Get_OUTPUT_FILE write Set_OUTPUT_FILE;
    property TEST_IN: WideString read Get_TEST_IN write Set_TEST_IN;
    property TEST_OUT: WideString read Get_TEST_OUT write Set_TEST_OUT;
    property TESTS: Integer read Get_TESTS write Set_TESTS;
    property TIMELIMIT: Integer read Get_TIMELIMIT write Set_TIMELIMIT;
    property PATH: WideString read Get_PATH write Set_PATH;
    property TESTER: WideString read Get_TESTER write Set_TESTER;
    property STATUS: WideString read Get_STATUS write Set_STATUS;
  end;

{ Forward Decls }

  TXMLTESTERType = class;
  TXMLPATHSType = class;
  TXMLPROBLEMSType = class;
  TXMLPROBLEMType = class;

{ TXMLTESTERType }

  TXMLTESTERType = class(TXMLNode, IXMLTESTERType)
  protected
    { IXMLTESTERType }
    function Get_PATHS: IXMLPATHSType;
    function Get_PROBLEMS: IXMLPROBLEMSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPATHSType }

  TXMLPATHSType = class(TXMLNode, IXMLPATHSType)
  protected
    { IXMLPATHSType }
    function Get_QUEUE: WideString;
    function Get_MAIN: WideString;
    procedure Set_QUEUE(Value: WideString);
    procedure Set_MAIN(Value: WideString);
  end;

{ TXMLPROBLEMSType }

  TXMLPROBLEMSType = class(TXMLNodeCollection, IXMLPROBLEMSType)
  protected
    { IXMLPROBLEMSType }
    function Get_PROBLEM(Index: Integer): IXMLPROBLEMType;
    function Add: IXMLPROBLEMType;
    function Insert(const Index: Integer): IXMLPROBLEMType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROBLEMType }

  TXMLPROBLEMType = class(TXMLNode, IXMLPROBLEMType)
  protected
    { IXMLPROBLEMType }
    function Get_ID: Integer;
    function Get_Litera: WideString;
    function Get_INPUT_FILE: WideString;
    function Get_OUTPUT_FILE: WideString;
    function Get_TEST_IN: WideString;
    function Get_TEST_OUT: WideString;
    function Get_TESTS: Integer;
    function Get_TIMELIMIT: Integer;
    function Get_PATH: WideString;
    function Get_TESTER: WideString;
    function Get_STATUS: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Litera(Value: WideString);
    procedure Set_INPUT_FILE(Value: WideString);
    procedure Set_OUTPUT_FILE(Value: WideString);
    procedure Set_TEST_IN(Value: WideString);
    procedure Set_TEST_OUT(Value: WideString);
    procedure Set_TESTS(Value: Integer);
    procedure Set_TIMELIMIT(Value: Integer);
    procedure Set_PATH(Value: WideString);
    procedure Set_TESTER(Value: WideString);
    procedure Set_STATUS(Value: WideString);
  end;

{ Global Functions }

function GetTESTER(Doc: IXMLDocument): IXMLTESTERType;
function LoadTESTER(const FileName: WideString): IXMLTESTERType;
function NewTESTER: IXMLTESTERType;

implementation

{ Global Functions }

function GetTESTER(Doc: IXMLDocument): IXMLTESTERType;
begin
  Result := Doc.GetDocBinding('TESTER', TXMLTESTERType) as IXMLTESTERType;
end;
function LoadTESTER(const FileName: WideString): IXMLTESTERType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('TESTER', TXMLTESTERType) as IXMLTESTERType;
end;

function NewTESTER: IXMLTESTERType;
begin
  Result := NewXMLDocument.GetDocBinding('TESTER', TXMLTESTERType) as IXMLTESTERType;
end;

{ TXMLTESTERType }

procedure TXMLTESTERType.AfterConstruction;
begin
  RegisterChildNode('PATHS', TXMLPATHSType);
  RegisterChildNode('PROBLEMS', TXMLPROBLEMSType);
  inherited;
end;

function TXMLTESTERType.Get_PATHS: IXMLPATHSType;
begin
  Result := ChildNodes['PATHS'] as IXMLPATHSType;
end;

function TXMLTESTERType.Get_PROBLEMS: IXMLPROBLEMSType;
begin
  Result := ChildNodes['PROBLEMS'] as IXMLPROBLEMSType;
end;

{ TXMLPATHSType }

function TXMLPATHSType.Get_QUEUE: WideString;
begin
  Result := ChildNodes['QUEUE'].Text;
end;

procedure TXMLPATHSType.Set_QUEUE(Value: WideString);
begin
  ChildNodes['QUEUE'].NodeValue := Value;
end;

function TXMLPATHSType.Get_MAIN: WideString;
begin
  Result := ChildNodes['MAIN'].Text;
end;

procedure TXMLPATHSType.Set_MAIN(Value: WideString);
begin
  ChildNodes['MAIN'].NodeValue := Value;
end;

{ TXMLPROBLEMSType }

procedure TXMLPROBLEMSType.AfterConstruction;
begin
  RegisterChildNode('PROBLEM', TXMLPROBLEMType);
  ItemTag := 'PROBLEM';
  ItemInterface := IXMLPROBLEMType;
  inherited;
end;

function TXMLPROBLEMSType.Get_PROBLEM(Index: Integer): IXMLPROBLEMType;
begin
  Result := List[Index] as IXMLPROBLEMType;
end;

function TXMLPROBLEMSType.Add: IXMLPROBLEMType;
begin
  Result := AddItem(-1) as IXMLPROBLEMType;
end;

function TXMLPROBLEMSType.Insert(const Index: Integer): IXMLPROBLEMType;
begin
  Result := AddItem(Index) as IXMLPROBLEMType;
end;


{ TXMLPROBLEMType }

function TXMLPROBLEMType.Get_ID: Integer;
begin
  Result := ChildNodes['ID'].NodeValue;
end;

procedure TXMLPROBLEMType.Set_ID(Value: Integer);
begin
  ChildNodes['ID'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_Litera: WideString;
begin
  Result := ChildNodes['Litera'].Text;
end;

procedure TXMLPROBLEMType.Set_Litera(Value: WideString);
begin
  ChildNodes['Litera'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_INPUT_FILE: WideString;
begin
  Result := ChildNodes['INPUT_FILE'].Text;
end;

procedure TXMLPROBLEMType.Set_INPUT_FILE(Value: WideString);
begin
  ChildNodes['INPUT_FILE'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_OUTPUT_FILE: WideString;
begin
  Result := ChildNodes['OUTPUT_FILE'].Text;
end;

procedure TXMLPROBLEMType.Set_OUTPUT_FILE(Value: WideString);
begin
  ChildNodes['OUTPUT_FILE'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_TEST_IN: WideString;
begin
  Result := ChildNodes['TEST_IN'].Text;
end;

procedure TXMLPROBLEMType.Set_TEST_IN(Value: WideString);
begin
  ChildNodes['TEST_IN'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_TEST_OUT: WideString;
begin
  Result := ChildNodes['TEST_OUT'].Text;
end;

procedure TXMLPROBLEMType.Set_TEST_OUT(Value: WideString);
begin
  ChildNodes['TEST_OUT'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_TESTS: Integer;
begin
  Result := ChildNodes['TESTS'].NodeValue;
end;

procedure TXMLPROBLEMType.Set_TESTS(Value: Integer);
begin
  ChildNodes['TESTS'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_TIMELIMIT: Integer;
begin
  Result := ChildNodes['TIMELIMIT'].NodeValue;
end;

procedure TXMLPROBLEMType.Set_TIMELIMIT(Value: Integer);
begin
  ChildNodes['TIMELIMIT'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_PATH: WideString;
begin
  Result := ChildNodes['PATH'].Text;
end;

procedure TXMLPROBLEMType.Set_PATH(Value: WideString);
begin
  ChildNodes['PATH'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_TESTER: WideString;
begin
  Result := ChildNodes['TESTER'].Text;
end;

procedure TXMLPROBLEMType.Set_TESTER(Value: WideString);
begin
  ChildNodes['TESTER'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_STATUS: WideString;
begin
  Result := ChildNodes['STATUS'].Text;
end;

procedure TXMLPROBLEMType.Set_STATUS(Value: WideString);
begin
  ChildNodes['STATUS'].NodeValue := Value;
end;

end.
