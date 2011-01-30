unit MessageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, RXCtrls, ExtCtrls, Arhive_Xml;

type
  TMF = class(TForm)
    RxLabel1: TRxLabel;
    OkBtn: TBitBtn;
    LMessage: TRxLabel;
    RxLabel3: TRxLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RxLabel4: TRxLabel;
    Bevel3: TBevel;
    RxLabel5: TRxLabel;
    Bevel4: TBevel;
    LNum: TRxLabel;
    LTime: TRxLabel;
    LProblemName: TRxLabel;
    Procedure Init(Num :Longint);
  private
    { Private declarations }
  public
    { Public declarations }
    _Arhive : IXMLArhiveType;
  end;

var
  MF: TMF;

implementation

{$R *.dfm}

procedure TMF.Init(Num : Longint);
begin
   _Arhive := LoadArhive('Arhive.xml');
   LMessage.Caption := _Arhive.Messages._Message[Num].Answer;
   LNum.Caption := IntToStr(_Arhive.Messages._Message[Num].Num);
   LProblemName.Caption:= _Arhive.Messages._Message[Num].Name;
   LTime.Caption := IntToStr(_Arhive.Messages._Message[Num].Time);
end;

end.
