object MF: TMF
  Left = 315
  Top = 304
  Width = 473
  Height = 191
  Caption = 'Message Lister'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    465
    162)
  PixelsPerInch = 96
  TextHeight = 13
  object LProblemName: TRxLabel
    Left = 144
    Top = 48
    Width = 297
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'LNum'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 15419746
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object LNum: TRxLabel
    Left = 40
    Top = 8
    Width = 153
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'LNum'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 15419746
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object LTime: TRxLabel
    Left = 264
    Top = 8
    Width = 177
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'LNum'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 15419746
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Bevel4: TBevel
    Left = 264
    Top = 8
    Width = 177
    Height = 25
  end
  object Bevel2: TBevel
    Left = 144
    Top = 48
    Width = 297
    Height = 25
  end
  object Bevel1: TBevel
    Left = 40
    Top = 8
    Width = 153
    Height = 25
  end
  object LMessage: TRxLabel
    Left = 104
    Top = 96
    Width = 337
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Accepted'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    Anchors = [akLeft, akRight]
    ParentFont = False
  end
  object Bevel3: TBevel
    Left = 104
    Top = 96
    Width = 337
    Height = 25
  end
  object RxLabel1: TRxLabel
    Left = 8
    Top = 96
    Width = 89
    Height = 20
    Caption = 'Message :'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object RxLabel3: TRxLabel
    Left = 8
    Top = 8
    Width = 22
    Height = 20
    Caption = #8470
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object RxLabel4: TRxLabel
    Left = 8
    Top = 48
    Width = 128
    Height = 20
    Caption = 'Problem Name'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object RxLabel5: TRxLabel
    Left = 208
    Top = 8
    Width = 44
    Height = 20
    Caption = 'Time'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object OkBtn: TBitBtn
    Left = 168
    Top = 136
    Width = 113
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
end
