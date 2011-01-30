
{**********************************************************}
{                                                          }
{                     XML Data Binding                     }
{                                                          }
{         Generated on: 20.06.2006 11:59:20                }
{       Generated from: X:\scripts\Favorites\dirinfo.xml   }
{                                                          }
{**********************************************************}

unit dirinfo;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLRootType = interface;
  IXMLDirType = interface;
  IXMLDirTypeList = interface;
  IXMLFileType = interface;
  IXMLFileTypeList = interface;

{ IXMLRootType }

  IXMLRootType = interface(IXMLNode)
    ['{7ACC6E72-9728-4C97-8EE3-306C8FA811BB}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Dir: IXMLDirTypeList;
    function Get_File_: IXMLFileTypeList;
    procedure Set_Name(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Dir: IXMLDirTypeList read Get_Dir;
    property File_: IXMLFileTypeList read Get_File_;
  end;

{ IXMLDirType }

  IXMLDirType = interface(IXMLNode)
    ['{DB6E68B0-0E96-4150-96C1-83CB4C9B1277}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Exists: WideString;
    function Get_File_: IXMLFileTypeList;
    function Get_Dir: IXMLDirTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Exists(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Exists: WideString read Get_Exists write Set_Exists;
    property File_: IXMLFileTypeList read Get_File_;
    property Dir: IXMLDirTypeList read Get_Dir;
  end;

{ IXMLDirTypeList }

  IXMLDirTypeList = interface(IXMLNodeCollection)
    ['{991BCC1E-D7AB-42CF-A0B5-66C8A4B1FE5D}']
    { Methods & Properties }
    function Add: IXMLDirType;
    function Insert(const Index: Integer): IXMLDirType;
    function Get_Item(Index: Integer): IXMLDirType;
    property Items[Index: Integer]: IXMLDirType read Get_Item; default;
  end;

{ IXMLFileType }

  IXMLFileType = interface(IXMLNode)
    ['{60B4181E-CE1F-488B-868E-77AA25FBAF54}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Exists: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Exists(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Exists: WideString read Get_Exists write Set_Exists;
  end;

{ IXMLFileTypeList }

  IXMLFileTypeList = interface(IXMLNodeCollection)
    ['{212279E4-9B6E-4A50-9115-5CDE1D59539B}']
    { Methods & Properties }
    function Add: IXMLFileType;
    function Insert(const Index: Integer): IXMLFileType;
    function Get_Item(Index: Integer): IXMLFileType;
    property Items[Index: Integer]: IXMLFileType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLRootType = class;
  TXMLDirType = class;
  TXMLDirTypeList = class;
  TXMLFileType = class;
  TXMLFileTypeList = class;

{ TXMLRootType }

  TXMLRootType = class(TXMLNode, IXMLRootType)
  private
    FDir: IXMLDirTypeList;
    FFile_: IXMLFileTypeList;
  protected
    { IXMLRootType }
    function Get_Name: WideString;
    function Get_Dir: IXMLDirTypeList;
    function Get_File_: IXMLFileTypeList;
    procedure Set_Name(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDirType }

  TXMLDirType = class(TXMLNode, IXMLDirType)
  private
    FFile_: IXMLFileTypeList;
    FDir: IXMLDirTypeList;
  protected
    { IXMLDirType }
    function Get_Name: WideString;
    function Get_Exists: WideString;
    function Get_File_: IXMLFileTypeList;
    function Get_Dir: IXMLDirTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Exists(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDirTypeList }

  TXMLDirTypeList = class(TXMLNodeCollection, IXMLDirTypeList)
  protected
    { IXMLDirTypeList }
    function Add: IXMLDirType;
    function Insert(const Index: Integer): IXMLDirType;
    function Get_Item(Index: Integer): IXMLDirType;
  end;

{ TXMLFileType }

  TXMLFileType = class(TXMLNode, IXMLFileType)
  protected
    { IXMLFileType }
    function Get_Name: WideString;
    function Get_Exists: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Exists(Value: WideString);
  end;

{ TXMLFileTypeList }

  TXMLFileTypeList = class(TXMLNodeCollection, IXMLFileTypeList)
  protected
    { IXMLFileTypeList }
    function Add: IXMLFileType;
    function Insert(const Index: Integer): IXMLFileType;
    function Get_Item(Index: Integer): IXMLFileType;
  end;

{ Global Functions }

function Getroot(Doc: IXMLDocument): IXMLRootType;
function Loadroot(const FileName: WideString): IXMLRootType;
function Newroot: IXMLRootType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getroot(Doc: IXMLDocument): IXMLRootType;
begin
  Result := Doc.GetDocBinding('root', TXMLRootType, TargetNamespace) as IXMLRootType;
end;

function Loadroot(const FileName: WideString): IXMLRootType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('root', TXMLRootType, TargetNamespace) as IXMLRootType;
end;

function Newroot: IXMLRootType;
begin
  Result := NewXMLDocument.GetDocBinding('root', TXMLRootType, TargetNamespace) as IXMLRootType;
end;

{ TXMLRootType }

procedure TXMLRootType.AfterConstruction;
begin
  RegisterChildNode('dir', TXMLDirType);
  RegisterChildNode('file', TXMLFileType);
  FDir := CreateCollection(TXMLDirTypeList, IXMLDirType, 'dir') as IXMLDirTypeList;
  FFile_ := CreateCollection(TXMLFileTypeList, IXMLFileType, 'file') as IXMLFileTypeList;
  inherited;
end;

function TXMLRootType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLRootType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLRootType.Get_Dir: IXMLDirTypeList;
begin
  Result := FDir;
end;

function TXMLRootType.Get_File_: IXMLFileTypeList;
begin
  Result := FFile_;
end;

{ TXMLDirType }

procedure TXMLDirType.AfterConstruction;
begin
  RegisterChildNode('file', TXMLFileType);
  RegisterChildNode('dir', TXMLDirType);
  FFile_ := CreateCollection(TXMLFileTypeList, IXMLFileType, 'file') as IXMLFileTypeList;
  FDir := CreateCollection(TXMLDirTypeList, IXMLDirType, 'dir') as IXMLDirTypeList;
  inherited;
end;

function TXMLDirType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLDirType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLDirType.Get_Exists: WideString;
begin
  Result := AttributeNodes['exists'].Text;
end;

procedure TXMLDirType.Set_Exists(Value: WideString);
begin
  SetAttribute('exists', Value);
end;

function TXMLDirType.Get_File_: IXMLFileTypeList;
begin
  Result := FFile_;
end;

function TXMLDirType.Get_Dir: IXMLDirTypeList;
begin
  Result := FDir;
end;

{ TXMLDirTypeList }

function TXMLDirTypeList.Add: IXMLDirType;
begin
  Result := AddItem(-1) as IXMLDirType;
end;

function TXMLDirTypeList.Insert(const Index: Integer): IXMLDirType;
begin
  Result := AddItem(Index) as IXMLDirType;
end;
function TXMLDirTypeList.Get_Item(Index: Integer): IXMLDirType;
begin
  Result := List[Index] as IXMLDirType;
end;

{ TXMLFileType }

function TXMLFileType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLFileType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLFileType.Get_Exists: WideString;
begin
  Result := AttributeNodes['exists'].Text;
end;

procedure TXMLFileType.Set_Exists(Value: WideString);
begin
  SetAttribute('exists', Value);
end;

{ TXMLFileTypeList }

function TXMLFileTypeList.Add: IXMLFileType;
begin
  Result := AddItem(-1) as IXMLFileType;
end;

function TXMLFileTypeList.Insert(const Index: Integer): IXMLFileType;
begin
  Result := AddItem(Index) as IXMLFileType;
end;
function TXMLFileTypeList.Get_Item(Index: Integer): IXMLFileType;
begin
  Result := List[Index] as IXMLFileType;
end;

end. 