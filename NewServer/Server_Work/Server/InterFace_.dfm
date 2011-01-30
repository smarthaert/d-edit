object Form1: TForm1
  Left = 275
  Top = 359
  Width = 365
  Height = 112
  Caption = 'Mega Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    357
    85)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 128
    Top = 0
    Width = 97
    Height = 25
    Caption = 'Lunch Command'
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 0
    Top = 64
    Width = 361
    Height = 25
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clSilver
    ReadOnly = True
    TabOrder = 2
    Text = 'Status '
  end
  object Edit1: TEdit
    Left = 0
    Top = 32
    Width = 353
    Height = 21
    TabOrder = 1
    Text = 'Coomand Line'
  end
  object CollectorBTN: TButton
    Left = 232
    Top = 0
    Width = 89
    Height = 25
    Caption = 'Kill Collector'
    TabOrder = 3
    OnClick = CollectorBTNClick
  end
  object XMLDocument1: TXMLDocument
    DOMVendorDesc = 'MSXML'
  end
end
