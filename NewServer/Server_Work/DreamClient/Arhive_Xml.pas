
{**********************************************************************}
{                                                                      }
{                       Delphi XML Data Binding                        }
{                                                                      }
{         Generated on: 24.07.03 11:46:37                              }
{       Generated from: C:\Pavlik\Server_Work\DreamClient\Arhive.xml   }
{   Settings stored in: C:\Pavlik\Server_Work\DreamClient\Arhive.xdb   }
{                                                                      }
{**********************************************************************}
unit Arhive_Xml;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLArhiveType = interface;
  IXMLMessagesType = interface;
  IXMLMessageType = interface;

{ IXMLArhiveType }

  IXMLArhiveType = interface(IXMLNode)
    ['{7730F2AD-8C14-443F-B450-28F7B687A90E}']
    { Property Accessors }
    function Get_Messages: IXMLMessagesType;
    { Methods & Properties }
    property Messages: IXMLMessagesType read Get_Messages;
  end;

{ IXMLMessagesType }

  IXMLMessagesType = interface(IXMLNodeCollection)
    ['{D96ADBA1-FDEA-49A3-9FDA-44C7D708D0C6}']
    { Property Accessors }
    function Get__Message(Index: Integer): IXMLMessageType;
    { Methods & Properties }
    function Add: IXMLMessageType;
    function Insert(const Index: Integer): IXMLMessageType;
    property _Message[Index: Integer]: IXMLMessageType read Get__Message; default;
  end;

{ IXMLMessageType }

  IXMLMessageType = interface(IXMLNode)
    ['{9DEAE721-6F04-4774-8E96-0609CD9C684D}']
    { Property Accessors }
    function Get_Litera: WideString;
    function Get_Name: WideString;
    function Get_Time: Integer;
    function Get_Answer: WideString;
    function Get_Num: Integer;
    procedure Set_Litera(Value: WideString);
    procedure Set_Name(Value: WideString);
    procedure Set_Time(Value: Integer);
    procedure Set_Answer(Value: WideString);
    procedure Set_Num(Value: Integer);
    { Methods & Properties }
    property Litera: WideString read Get_Litera write Set_Litera;
    property Name: WideString read Get_Name write Set_Name;
    property Time: Integer read Get_Time write Set_Time;
    property Answer: WideString read Get_Answer write Set_Answer;
    property Num: Integer read Get_Num write Set_Num;
  end;

{ Forward Decls }

  TXMLArhiveType = class;
  TXMLMessagesType = class;
  TXMLMessageType = class;

{ TXMLArhiveType }

  TXMLArhiveType = class(TXMLNode, IXMLArhiveType)
  protected
    { IXMLArhiveType }
    function Get_Messages: IXMLMessagesType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMessagesType }

  TXMLMessagesType = class(TXMLNodeCollection, IXMLMessagesType)
  protected
    { IXMLMessagesType }
    function Get__Message(Index: Integer): IXMLMessageType;
    function Add: IXMLMessageType;
    function Insert(const Index: Integer): IXMLMessageType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMessageType }

  TXMLMessageType = class(TXMLNode, IXMLMessageType)
  protected
    { IXMLMessageType }
    function Get_Litera: WideString;
    function Get_Name: WideString;
    function Get_Time: Integer;
    function Get_Answer: WideString;
    function Get_Num: Integer;
    procedure Set_Litera(Value: WideString);
    procedure Set_Name(Value: WideString);
    procedure Set_Time(Value: Integer);
    procedure Set_Answer(Value: WideString);
    procedure Set_Num(Value: Integer);
  end;

{ Global Functions }

function GetArhive(Doc: IXMLDocument): IXMLArhiveType;
function LoadArhive(const FileName: WideString): IXMLArhiveType;
function NewArhive: IXMLArhiveType;

implementation

{ Global Functions }

function GetArhive(Doc: IXMLDocument): IXMLArhiveType;
begin
  Result := Doc.GetDocBinding('Arhive', TXMLArhiveType) as IXMLArhiveType;
end;
function LoadArhive(const FileName: WideString): IXMLArhiveType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Arhive', TXMLArhiveType) as IXMLArhiveType;
end;

function NewArhive: IXMLArhiveType;
begin
  Result := NewXMLDocument.GetDocBinding('Arhive', TXMLArhiveType) as IXMLArhiveType;
end;

{ TXMLArhiveType }

procedure TXMLArhiveType.AfterConstruction;
begin
  RegisterChildNode('Messages', TXMLMessagesType);
  inherited;
end;

function TXMLArhiveType.Get_Messages: IXMLMessagesType;
begin
  Result := ChildNodes['Messages'] as IXMLMessagesType;
end;

{ TXMLMessagesType }

procedure TXMLMessagesType.AfterConstruction;
begin
  RegisterChildNode('Message', TXMLMessageType);
  ItemTag := 'Message';
  ItemInterface := IXMLMessageType;
  inherited;
end;

function TXMLMessagesType.Get__Message(Index: Integer): IXMLMessageType;
begin
  Result := List[Index] as IXMLMessageType;
end;

function TXMLMessagesType.Add: IXMLMessageType;
begin
  Result := AddItem(-1) as IXMLMessageType;
end;

function TXMLMessagesType.Insert(const Index: Integer): IXMLMessageType;
begin
  Result := AddItem(Index) as IXMLMessageType;
end;


{ TXMLMessageType }

function TXMLMessageType.Get_Litera: WideString;
begin
  Result := ChildNodes['Litera'].Text;
end;

procedure TXMLMessageType.Set_Litera(Value: WideString);
begin
  ChildNodes['Litera'].NodeValue := Value;
end;

function TXMLMessageType.Get_Name: WideString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLMessageType.Set_Name(Value: WideString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLMessageType.Get_Time: Integer;
begin
  Result := ChildNodes['Time'].NodeValue;
end;

procedure TXMLMessageType.Set_Time(Value: Integer);
begin
  ChildNodes['Time'].NodeValue := Value;
end;

function TXMLMessageType.Get_Answer: WideString;
begin
  Result := ChildNodes['Answer'].Text;
end;

procedure TXMLMessageType.Set_Answer(Value: WideString);
begin
  ChildNodes['Answer'].NodeValue := Value;
end;

function TXMLMessageType.Get_Num: Integer;
begin
  Result := ChildNodes['Num'].NodeValue;
end;

procedure TXMLMessageType.Set_Num(Value: Integer);
begin
  ChildNodes['Num'].NodeValue := Value;
end;

end.
