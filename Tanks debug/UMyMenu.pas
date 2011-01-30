unit UMyMenu;

interface

Uses Graphics,Classes,DXInput,Pointers;

Const
  MyMenuItemHeight=40;
  MyMenuKeyDelay=200;

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
    LastKeyTime:Integer;
    function GetItems(I: Integer): PMyMenuItem;
    procedure SetNumSel(const Value: Integer);
    function GetCount: Integer;
  public
    Font,SelFont:TFont;
    FocusFrame:Boolean;
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
    Function Input(UpKey,DownKey,LeftKey,RightKey,FireKey:TDXInputState;MoveCount:Integer):ShortInt;Overload;
    Function Input(MoveCount:Integer):ShortInt;Overload;
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
  FocusFrame:=True;
  Font:=TFont.Create;
  SelFont:=TFont.Create;
  With Font do
    Begin
      Name:='CityBlueprint';
      Style:=[fsBold,fsItalic];
      Color:=clLime;
      Size:=15;
    End;
  SelFont.Assign(Font);
end;

destructor TMyMenu.Destroy;
Var I:Integer;
begin
  For I:=0 to FItems.Count-1 do
    Begin
      If FItems.Items[I]=Nil then Continue;
      Dispose(FItems.Items[I]);
    End;
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

function TMyMenu.Input(UpKey, DownKey, LeftKey, RightKey,
  FireKey: TDXInputState; MoveCount: Integer): ShortInt;
begin
  Result:=0;
  Inc(LastKeyTime,MoveCount);
  If LastKeyTime<MyMenuKeyDelay then
    Exit
    Else
    LastKeyTime:=MyMenuKeyDelay;
  With MyDXInput do
    Begin
      If UpKey In MyDXInput.States then
        Begin
          NumSel:=NumSel-1;
          LastKeyTime:=0;
        End;
      If DownKey In MyDXInput.States then
        Begin
          NumSel:=NumSel+1;
          LastKeyTime:=0;
        End;
      If LeftKey In MyDXInput.States then
        Begin
          Result:=-1;
          LastKeyTime:=0;
        End;
      If RightKey In MyDXInput.States then
        Begin
          Result:=1;
          LastKeyTime:=0;
        End;
      If FireKey In MyDXInput.States then
        Begin
          Result:=1;
          LastKeyTime:=0;
        End;
    End;
end;

function TMyMenu.Input(MoveCount: Integer): ShortInt;
begin
  Result:=Input(isUp,isDown,isLeft,isRight,isButton32,MoveCount);
end;

constructor TMyMenu.MyCreate(AOwner: TComponent; AX, AY: Integer);
begin
  Create(AOwner);
  FX:=AX;
  FY:=AY;
  LastKeyTime:=0;//MyMenuKeyDelay;
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
      Brush.Style:=bsClear;
      For I:=0 to Count-1 do
        Begin
          If Items[I]=Nil then Continue;
          With Items[I]^ do
            Begin
              If I=FNumSel then
                Font.Assign(Self.SelFont)
                Else
                Font.Assign(Self.Font);
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
              If (I=FNumSel)And FocusFrame then
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
    End;
end;

procedure TMyMenu.SetNumSel(const Value: Integer);
begin
  If (Value<0)Or(Value>Count-1) then Exit;
  FNumSel := Value;
end;

end.
