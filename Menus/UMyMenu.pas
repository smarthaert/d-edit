unit UMyMenu;

interface

Uses Graphics,Classes;

Const
  MyMenuItemHeight=40;

Type
  TMyMenuItemType=(itOnlyName,itImage,itValue);
  TMyMenuItem=Record
    X,Y:Integer;
    Name:ShortString;
    Case Typ:TMyMenuItemType of
      itImage:(Image:TGraphic);
      itValue:(Value:ShortString);
      itOnlyName:();
  End;
  PMyMenuItem=^TMyMenuItem;
  TMyMenu=class(TComponent)
  private
    FItems:TList;
    FNumSel:Integer;
    FX,FY:Integer;
    function GetItems(I: Integer): PMyMenuItem;
    procedure SetNumSel(const Value: Integer);
    function GetCount: Integer;
  public
    Font:TFont;
    Property Items[I:Integer]:PMyMenuItem
      Read GetItems;
    Property NumSel:Integer
      Read FNumSel
      Write SetNumSel;
    Property Count:Integer
      Read GetCount;
    Property X:Integer
      Read FX;
    Property Y:Integer
      Read FY;
    Procedure Paint(C:TCanvas);
    Function AddImageItem(AName:String;AImage:TGraphic):Integer;
    Function AddValueItem(AName:String;AValue:String):Integer;
    Function AddTextItem(AName:String):Integer;
    Constructor Create(AOwner:TComponent);override;
    Constructor MyCreate(AOwner:TComponent;AX,AY:Integer);
    Destructor Destroy; override;
  End;

implementation

{ TMyMenu }

Function TMyMenu.AddImageItem(AName: String; AImage: TGraphic):Integer;
Var Item:PMyMenuItem;
begin
  New(Item);
  With Item^ do
    Begin
      Name:=AName;
      Image:=AImage;
      Typ:=itImage;
      X:=FX;
      Y:=FY+FItems.Count*MyMenuItemHeight;
    End;
  Result:=FItems.Add(Item);
end;

function TMyMenu.AddTextItem(AName: String): Integer;
Var Item:PMyMenuItem;
begin
  New(Item);
  With Item^ do
    Begin
      Name:=AName;
      Typ:=itOnlyName;
      X:=FX;
      Y:=FY+FItems.Count*MyMenuItemHeight;
    End;
  Result:=FItems.Add(Item);
end;

Function TMyMenu.AddValueItem(AName, AValue: String):Integer;
Var Item:PMyMenuItem;
begin
  New(Item);
  With Item^ do
    Begin
      Name:=AName;
      Value:=AValue;
      Typ:=itValue;
      X:=FX;
      Y:=FY+FItems.Count*MyMenuItemHeight;
    End;
  Result:=FItems.Add(Item);
end;

constructor TMyMenu.Create(AOwner: TComponent);
begin
  inherited;
  FX:=5;
  FY:=5;
  FItems:=TList.Create;
  FNumSel:=0;
  Font:=TFont.Create;
  With Font do
    Begin
      Name:='CityBlueprint';
      Style:=[fsBold,fsItalic];
      Color:=clLime;
      Size:=15;
    End;
end;

destructor TMyMenu.Destroy;
begin
  FItems.Free;
  Font.Free;
  inherited;
end;

function TMyMenu.GetCount: Integer;
begin
  Result:=FItems.Count;
end;

function TMyMenu.GetItems(I: Integer): PMyMenuItem;
begin
  Result:=PMyMenuItem(FItems.Items[I]);
end;

constructor TMyMenu.MyCreate(AOwner: TComponent; AX, AY: Integer);
begin
  Create(AOwner);
  FX:=AX;
  FY:=AY;
end;

procedure TMyMenu.Paint(C: TCanvas);
Const
  INameSize=150;
  IValueSize=100;
  IBorder=4;
Var
  I,TX,TY:Integer;
begin
  With C do
    Begin
      Font:=Self.Font;
      For I:=0 to Count-1 do
        With Items[I]^ do
          Begin
            TX:=X+IBorder;
            TY:=Y+(MyMenuItemHeight-TextHeight(Name+':A')) Div 2;
            TextOut(TX,TY,Name);
            If Typ<>itOnlyName then
              Begin
                Inc(TX,INameSize);
                TextOut(TX-10,TY,':');
                Inc(TX,IValueSize);
                Case Typ of
                  itImage:Draw(TX-Image.Width,Y+IBorder,Image);
                  itValue:TextOut(TX-TextWidth(Value),TY,Value);
                End;
              End;
            If I=FNumSel then
              Begin
                //clFuchsia
                Pen.Style:=psDot;
                Pen.Color:=clFuchsia;
                Brush.Style:=bsClear;
                Rectangle(Bounds(X,Y,INameSize+IValueSize+IBorder*2-1,MyMenuItemHeight-1));
                Pen.Style:=psSolid;
              End;
          End;
    End;
end;

procedure TMyMenu.SetNumSel(const Value: Integer);
begin
  If (Value<0)Or(Value>Count-1) then Exit;
  FNumSel := Value;
end;

end.
