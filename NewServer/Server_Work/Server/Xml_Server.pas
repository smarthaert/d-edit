unit Xml_Server;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLServerType = interface;
  IXMLCONTESTType = interface;
  IXMLTESTERSType = interface;
  IXMLTESTERType = interface;
  IXMLPATHSType = interface;
  IXMLCOMPILERSType = interface;
  IXMLCompilatorType = interface;
  IXMLUSERSType = interface;
  IXMLUSERType = interface;
  IXMLPROBLEMSType = interface;
  IXMLPROBLEMType = interface;

{ IXMLServerType }

  IXMLServerType = interface(IXMLNode)
    ['{46972E71-6696-4ABF-AC5F-B128A28A5FF4}']
    { Property Accessors }
    function Get_CONTEST: IXMLCONTESTType;
    function Get_TESTERS: IXMLTESTERSType;
    function Get_PATHS: IXMLPATHSType;
    function Get_COMPILERS: IXMLCOMPILERSType;
    function Get_USERS: IXMLUSERSType;
    function Get_PROBLEMS: IXMLPROBLEMSType;
    { Methods & Properties }
    property CONTEST: IXMLCONTESTType read Get_CONTEST;
    property TESTERS: IXMLTESTERSType read Get_TESTERS;
    property PATHS: IXMLPATHSType read Get_PATHS;
    property COMPILERS: IXMLCOMPILERSType read Get_COMPILERS;
    property USERS: IXMLUSERSType read Get_USERS;
    property PROBLEMS: IXMLPROBLEMSType read Get_PROBLEMS;
  end;

{ IXMLCONTESTType }

  IXMLCONTESTType = interface(IXMLNode)
    ['{D5B16C8E-335A-4820-8FB3-340C1D336868}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Place: WideString;
    function Get_Data: WideString;
    function Get_Rules: Integer;
    function Get_Start: WideString;
    function Get_End_: WideString;
    function Get_Length: Integer;
    procedure Set_Name(Value: WideString);
    procedure Set_Place(Value: WideString);
    procedure Set_Data(Value: WideString);
    procedure Set_Rules(Value: Integer);
    procedure Set_Start(Value: WideString);
    procedure Set_End_(Value: WideString);
    procedure Set_Length(Value: Integer);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Place: WideString read Get_Place write Set_Place;
    property Data: WideString read Get_Data write Set_Data;
    property Rules: Integer read Get_Rules write Set_Rules;
    property Start: WideString read Get_Start write Set_Start;
    property End_: WideString read Get_End_ write Set_End_;
    property Length: Integer read Get_Length write Set_Length;
  end;

{ IXMLTESTERSType }

  IXMLTESTERSType = interface(IXMLNodeCollection)
    ['{D8FC7592-4295-4AFE-812E-F62D3F13CCA3}']
    { Property Accessors }
    function Get_TESTER(Index: Integer): IXMLTESTERType;
    { Methods & Properties }
    function Add: IXMLTESTERType;
    function Insert(const Index: Integer): IXMLTESTERType;
    property TESTER[Index: Integer]: IXMLTESTERType read Get_TESTER; default;
  end;

{ IXMLTESTERType }

  IXMLTESTERType = interface(IXMLNode)
    ['{702207B1-105A-49AA-8EC0-6D2F1735B91D}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Path: WideString;
    function Get_Queue: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Path(Value: WideString);
    procedure Set_Queue(Value: WideString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property Path: WideString read Get_Path write Set_Path;
    property Queue: WideString read Get_Queue write Set_Queue;
  end;

{ IXMLPATHSType }

  IXMLPATHSType = interface(IXMLNode)
    ['{9F7AB8B9-1470-43A2-9D36-F98D946B186F}']
    { Property Accessors }
    function Get_Queue: WideString;
    function Get_QueueNumber: WideString;
    function Get_Arhive: WideString;
    function Get_Results: WideString;
    procedure Set_Queue(Value: WideString);
    procedure Set_QueueNumber(Value: WideString);
    procedure Set_Arhive(Value: WideString);
    procedure Set_Results(Value: WideString);
    { Methods & Properties }
    property Queue: WideString read Get_Queue write Set_Queue;
    property QueueNumber: WideString read Get_QueueNumber write Set_QueueNumber;
    property Arhive: WideString read Get_Arhive write Set_Arhive;
    property Results: WideString read Get_Results write Set_Results;
  end;

{ IXMLCOMPILERSType }

  IXMLCOMPILERSType = interface(IXMLNodeCollection)
    ['{960731F0-0F9F-45CA-8075-A303037823CC}']
    { Property Accessors }
    function Get_Compilator(Index: Integer): IXMLCompilatorType;
    { Methods & Properties }
    function Add: IXMLCompilatorType;
    function Insert(const Index: Integer): IXMLCompilatorType;
    property Compilator[Index: Integer]: IXMLCompilatorType read Get_Compilator; default;
  end;

{ IXMLCompilatorType }

  IXMLCompilatorType = interface(IXMLNode)
    ['{FCD7F4C1-8421-42D1-8402-2A0CCC88B452}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_FileExt: WideString;
    function Get_Program_: WideString;
    function Get_CmdLine: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_FileExt(Value: WideString);
    procedure Set_Program_(Value: WideString);
    procedure Set_CmdLine(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property FileExt: WideString read Get_FileExt write Set_FileExt;
    property Program_: WideString read Get_Program_ write Set_Program_;
    property CmdLine: WideString read Get_CmdLine write Set_CmdLine;
  end;

{ IXMLUSERSType }

  IXMLUSERSType = interface(IXMLNodeCollection)
    ['{B9E1636E-76A3-4370-BD6D-26C5391CE55C}']
    { Property Accessors }
    function Get_USER(Index: Integer): IXMLUSERType;
    { Methods & Properties }
    function Add: IXMLUSERType;
    function Insert(const Index: Integer): IXMLUSERType;
    property USER[Index: Integer]: IXMLUSERType read Get_USER; default;
  end;

{ IXMLUSERType }

  IXMLUSERType = interface(IXMLNode)
    ['{85CB13FA-AE2D-445D-AADD-E99A8663458B}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Name: WideString;
    function Get_Dir_Path: WideString;
    function Get_Disqualificated: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Dir_Path(Value: WideString);
    procedure Set_Disqualificated(Value: WideString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property Name: WideString read Get_Name write Set_Name;
    property Dir_Path: WideString read Get_Dir_Path write Set_Dir_Path;
    property Disqualificated: WideString read Get_Disqualificated write Set_Disqualificated;
  end;

{ IXMLPROBLEMSType }

  IXMLPROBLEMSType = interface(IXMLNodeCollection)
    ['{F10534E3-AB6D-41BD-88D4-A234D723FC5B}']
    { Property Accessors }
    function Get_PROBLEM(Index: Integer): IXMLPROBLEMType;
    { Methods & Properties }
    function Add: IXMLPROBLEMType;
    function Insert(const Index: Integer): IXMLPROBLEMType;
    property PROBLEM[Index: Integer]: IXMLPROBLEMType read Get_PROBLEM; default;
  end;

{ IXMLPROBLEMType }

  IXMLPROBLEMType = interface(IXMLNode)
    ['{3CAD7921-7047-4FB5-A5F9-C46CF5220BDB}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_Name: WideString;
    function Get_Litera: WideString;
    function Get_Tests: Integer;
    function Get_Status: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
    procedure Set_Tests(Value: Integer);
    procedure Set_Status(Value: WideString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property Name: WideString read Get_Name write Set_Name;
    property Litera: WideString read Get_Litera write Set_Litera;
    property Tests: Integer read Get_Tests write Set_Tests;
    property Status: WideString read Get_Status write Set_Status;
  end;

{ Forward Decls }

  TXMLServerType = class;
  TXMLCONTESTType = class;
  TXMLTESTERSType = class;
  TXMLTESTERType = class;
  TXMLPATHSType = class;
  TXMLCOMPILERSType = class;
  TXMLCompilatorType = class;
  TXMLUSERSType = class;
  TXMLUSERType = class;
  TXMLPROBLEMSType = class;
  TXMLPROBLEMType = class;

{ TXMLServerType }

  TXMLServerType = class(TXMLNode, IXMLServerType)
  protected
    { IXMLServerType }
    function Get_CONTEST: IXMLCONTESTType;
    function Get_TESTERS: IXMLTESTERSType;
    function Get_PATHS: IXMLPATHSType;
    function Get_COMPILERS: IXMLCOMPILERSType;
    function Get_USERS: IXMLUSERSType;
    function Get_PROBLEMS: IXMLPROBLEMSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCONTESTType }

  TXMLCONTESTType = class(TXMLNode, IXMLCONTESTType)
  protected
    { IXMLCONTESTType }
    function Get_Name: WideString;
    function Get_Place: WideString;
    function Get_Data: WideString;
    function Get_Rules: Integer;
    function Get_Start: WideString;
    function Get_End_: WideString;
    function Get_Length: Integer;
    procedure Set_Name(Value: WideString);
    procedure Set_Place(Value: WideString);
    procedure Set_Data(Value: WideString);
    procedure Set_Rules(Value: Integer);
    procedure Set_Start(Value: WideString);
    procedure Set_End_(Value: WideString);
    procedure Set_Length(Value: Integer);
  end;

{ TXMLTESTERSType }

  TXMLTESTERSType = class(TXMLNodeCollection, IXMLTESTERSType)
  protected
    { IXMLTESTERSType }
    function Get_TESTER(Index: Integer): IXMLTESTERType;
    function Add: IXMLTESTERType;
    function Insert(const Index: Integer): IXMLTESTERType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTESTERType }

  TXMLTESTERType = class(TXMLNode, IXMLTESTERType)
  protected
    { IXMLTESTERType }
    function Get_ID: Integer;
    function Get_Path: WideString;
    function Get_Queue: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Path(Value: WideString);
    procedure Set_Queue(Value: WideString);
  end;

{ TXMLPATHSType }

  TXMLPATHSType = class(TXMLNode, IXMLPATHSType)
  protected
    { IXMLPATHSType }
    function Get_Queue: WideString;
    function Get_QueueNumber: WideString;
    function Get_Arhive: WideString;
    function Get_Results: WideString;
    procedure Set_Queue(Value: WideString);
    procedure Set_QueueNumber(Value: WideString);
    procedure Set_Arhive(Value: WideString);
    procedure Set_Results(Value: WideString);
  end;

{ TXMLCOMPILERSType }

  TXMLCOMPILERSType = class(TXMLNodeCollection, IXMLCOMPILERSType)
  protected
    { IXMLCOMPILERSType }
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
    function Get_FileExt: WideString;
    function Get_Program_: WideString;
    function Get_CmdLine: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_FileExt(Value: WideString);
    procedure Set_Program_(Value: WideString);
    procedure Set_CmdLine(Value: WideString);
  end;

{ TXMLUSERSType }

  TXMLUSERSType = class(TXMLNodeCollection, IXMLUSERSType)
  protected
    { IXMLUSERSType }
    function Get_USER(Index: Integer): IXMLUSERType;
    function Add: IXMLUSERType;
    function Insert(const Index: Integer): IXMLUSERType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLUSERType }

  TXMLUSERType = class(TXMLNode, IXMLUSERType)
  protected
    { IXMLUSERType }
    function Get_ID: Integer;
    function Get_Name: WideString;
    function Get_Dir_Path: WideString;
    function Get_Disqualificated: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Dir_Path(Value: WideString);
    procedure Set_Disqualificated(Value: WideString);
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
    function Get_Name: WideString;
    function Get_Litera: WideString;
    function Get_Tests: Integer;
    function Get_Status: WideString;
    procedure Set_ID(Value: Integer);
    procedure Set_Name(Value: WideString);
    procedure Set_Litera(Value: WideString);
    procedure Set_Tests(Value: Integer);
    procedure Set_Status(Value: WideString);
  end;

{ Global Functions }

function GetServer(Doc: IXMLDocument): IXMLServerType;
function LoadServer(const FileName: WideString): IXMLServerType;
function NewServer: IXMLServerType;

implementation

{ Global Functions }

function GetServer(Doc: IXMLDocument): IXMLServerType;
begin
  Result := Doc.GetDocBinding('Server', TXMLServerType) as IXMLServerType;
end;
function LoadServer(const FileName: WideString): IXMLServerType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Server', TXMLServerType) as IXMLServerType;
end;

function NewServer: IXMLServerType;
begin
  Result := NewXMLDocument.GetDocBinding('Server', TXMLServerType) as IXMLServerType;
end;

{ TXMLServerType }

procedure TXMLServerType.AfterConstruction;
begin
  RegisterChildNode('CONTEST', TXMLCONTESTType);
  RegisterChildNode('TESTERS', TXMLTESTERSType);
  RegisterChildNode('PATHS', TXMLPATHSType);
  RegisterChildNode('COMPILERS', TXMLCOMPILERSType);
  RegisterChildNode('USERS', TXMLUSERSType);
  RegisterChildNode('PROBLEMS', TXMLPROBLEMSType);
  inherited;
end;

function TXMLServerType.Get_CONTEST: IXMLCONTESTType;
begin
  Result := ChildNodes['CONTEST'] as IXMLCONTESTType;
end;

function TXMLServerType.Get_TESTERS: IXMLTESTERSType;
begin
  Result := ChildNodes['TESTERS'] as IXMLTESTERSType;
end;

function TXMLServerType.Get_PATHS: IXMLPATHSType;
begin
  Result := ChildNodes['PATHS'] as IXMLPATHSType;
end;

function TXMLServerType.Get_COMPILERS: IXMLCOMPILERSType;
begin
  Result := ChildNodes['COMPILERS'] as IXMLCOMPILERSType;
end;

function TXMLServerType.Get_USERS: IXMLUSERSType;
begin
  Result := ChildNodes['USERS'] as IXMLUSERSType;
end;

function TXMLServerType.Get_PROBLEMS: IXMLPROBLEMSType;
begin
  Result := ChildNodes['PROBLEMS'] as IXMLPROBLEMSType;
end;

{ TXMLCONTESTType }

function TXMLCONTESTType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLCONTESTType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_Place: WideString;
begin
  Result := ChildNodes['Place'].Text;
end;

procedure TXMLCONTESTType.Set_Place(Value: WideString);
begin
  ChildNodes['Place'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_Data: WideString;
begin
  Result := ChildNodes['Data'].Text;
end;

procedure TXMLCONTESTType.Set_Data(Value: WideString);
begin
  ChildNodes['Data'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_Rules: Integer;
begin
  Result := ChildNodes['Rules'].NodeValue;
end;

procedure TXMLCONTESTType.Set_Rules(Value: Integer);
begin
  ChildNodes['Rules'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_Start: WideString;
begin
  Result := ChildNodes['Start'].Text;
end;

procedure TXMLCONTESTType.Set_Start(Value: WideString);
begin
  ChildNodes['Start'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_End_: WideString;
begin
  Result := ChildNodes['End'].Text;
end;

procedure TXMLCONTESTType.Set_End_(Value: WideString);
begin
  ChildNodes['End'].NodeValue := Value;
end;

function TXMLCONTESTType.Get_Length: Integer;
begin
  Result := ChildNodes['Length'].NodeValue;
end;

procedure TXMLCONTESTType.Set_Length(Value: Integer);
begin
  ChildNodes['Length'].NodeValue := Value;
end;

{ TXMLTESTERSType }

procedure TXMLTESTERSType.AfterConstruction;
begin
  RegisterChildNode('TESTER', TXMLTESTERType);
  ItemTag := 'TESTER';
  ItemInterface := IXMLTESTERType;
  inherited;
end;

function TXMLTESTERSType.Get_TESTER(Index: Integer): IXMLTESTERType;
begin
  Result := List[Index] as IXMLTESTERType;
end;

function TXMLTESTERSType.Add: IXMLTESTERType;
begin
  Result := AddItem(-1) as IXMLTESTERType;
end;

function TXMLTESTERSType.Insert(const Index: Integer): IXMLTESTERType;
begin
  Result := AddItem(Index) as IXMLTESTERType;
end;


{ TXMLTESTERType }

function TXMLTESTERType.Get_ID: Integer;
begin
  Result := ChildNodes['ID'].NodeValue;
end;

procedure TXMLTESTERType.Set_ID(Value: Integer);
begin
  ChildNodes['ID'].NodeValue := Value;
end;

function TXMLTESTERType.Get_Path: WideString;
begin
  Result := ChildNodes['Path'].Text;
end;

procedure TXMLTESTERType.Set_Path(Value: WideString);
begin
  ChildNodes['Path'].NodeValue := Value;
end;

function TXMLTESTERType.Get_Queue: WideString;
begin
  Result := ChildNodes['Queue'].Text;
end;

procedure TXMLTESTERType.Set_Queue(Value: WideString);
begin
  ChildNodes['Queue'].NodeValue := Value;
end;

{ TXMLPATHSType }

function TXMLPATHSType.Get_Queue: WideString;
begin
  Result := ChildNodes['Queue'].Text;
end;

procedure TXMLPATHSType.Set_Queue(Value: WideString);
begin
  ChildNodes['Queue'].NodeValue := Value;
end;

function TXMLPATHSType.Get_QueueNumber: WideString;
begin
  Result := ChildNodes['QueueNumber'].Text;
end;

procedure TXMLPATHSType.Set_QueueNumber(Value: WideString);
begin
  ChildNodes['QueueNumber'].NodeValue := Value;
end;

function TXMLPATHSType.Get_Arhive: WideString;
begin
  Result := ChildNodes['Arhive'].Text;
end;

procedure TXMLPATHSType.Set_Arhive(Value: WideString);
begin
  ChildNodes['Arhive'].NodeValue := Value;
end;

function TXMLPATHSType.Get_Results: WideString;
begin
  Result := ChildNodes['Results'].Text;
end;

procedure TXMLPATHSType.Set_Results(Value: WideString);
begin
  ChildNodes['Results'].NodeValue := Value;
end;

{ TXMLCOMPILERSType }

procedure TXMLCOMPILERSType.AfterConstruction;
begin
  RegisterChildNode('Compilator', TXMLCompilatorType);
  ItemTag := 'Compilator';
  ItemInterface := IXMLCompilatorType;
  inherited;
end;

function TXMLCOMPILERSType.Get_Compilator(Index: Integer): IXMLCompilatorType;
begin
  Result := List[Index] as IXMLCompilatorType;
end;

function TXMLCOMPILERSType.Add: IXMLCompilatorType;
begin
  Result := AddItem(-1) as IXMLCompilatorType;
end;

function TXMLCOMPILERSType.Insert(const Index: Integer): IXMLCompilatorType;
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

function TXMLCompilatorType.Get_FileExt: WideString;
begin
  Result := ChildNodes['FileExt'].Text;
end;

procedure TXMLCompilatorType.Set_FileExt(Value: WideString);
begin
  ChildNodes['FileExt'].NodeValue := Value;
end;

function TXMLCompilatorType.Get_Program_: WideString;
begin
  Result := ChildNodes['Program'].Text;
end;

procedure TXMLCompilatorType.Set_Program_(Value: WideString);
begin
  ChildNodes['Program'].NodeValue := Value;
end;

function TXMLCompilatorType.Get_CmdLine: WideString;
begin
  Result := ChildNodes['CmdLine'].Text;
end;

procedure TXMLCompilatorType.Set_CmdLine(Value: WideString);
begin
  ChildNodes['CmdLine'].NodeValue := Value;
end;

{ TXMLUSERSType }

procedure TXMLUSERSType.AfterConstruction;
begin
  RegisterChildNode('USER', TXMLUSERType);
  ItemTag := 'USER';
  ItemInterface := IXMLUSERType;
  inherited;
end;

function TXMLUSERSType.Get_USER(Index: Integer): IXMLUSERType;
begin
  Result := List[Index] as IXMLUSERType;
end;

function TXMLUSERSType.Add: IXMLUSERType;
begin
  Result := AddItem(-1) as IXMLUSERType;
end;

function TXMLUSERSType.Insert(const Index: Integer): IXMLUSERType;
begin
  Result := AddItem(Index) as IXMLUSERType;
end;


{ TXMLUSERType }

function TXMLUSERType.Get_ID: Integer;
begin
  Result := ChildNodes['ID'].NodeValue;
end;

procedure TXMLUSERType.Set_ID(Value: Integer);
begin
  ChildNodes['ID'].NodeValue := Value;
end;

function TXMLUSERType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLUSERType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLUSERType.Get_Dir_Path: WideString;
begin
  Result := ChildNodes['Dir_Path'].Text;
end;

procedure TXMLUSERType.Set_Dir_Path(Value: WideString);
begin
  ChildNodes['Dir_Path'].NodeValue := Value;
end;

function TXMLUSERType.Get_Disqualificated: WideString;
begin
  Result := ChildNodes['Disqualificated'].Text;
end;

procedure TXMLUSERType.Set_Disqualificated(Value: WideString);
begin
  ChildNodes['Disqualificated'].NodeValue := Value;
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

function TXMLPROBLEMType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLPROBLEMType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_Litera: WideString;
begin
  Result := ChildNodes['Litera'].Text;
end;

procedure TXMLPROBLEMType.Set_Litera(Value: WideString);
begin
  ChildNodes['Litera'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_Tests: Integer;
begin
  Result := ChildNodes['Tests'].NodeValue;
end;

procedure TXMLPROBLEMType.Set_Tests(Value: Integer);
begin
  ChildNodes['Tests'].NodeValue := Value;
end;

function TXMLPROBLEMType.Get_Status: WideString;
begin
  Result := ChildNodes['Status'].Text;
end;

procedure TXMLPROBLEMType.Set_Status(Value: WideString);
begin
  ChildNodes['Status'].NodeValue := Value;
end;

end.
