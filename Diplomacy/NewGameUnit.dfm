object NewGameForm: TNewGameForm
  Left = 297
  Top = 98
  Width = 696
  Height = 480
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1081' '#1080#1075#1088#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object RxLabel1: TRxLabel
    Left = 32
    Top = 64
    Width = 131
    Height = 13
    Caption = #1042#1099#1073#1086#1088' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1089#1090#1088#1072#1085':'
  end
  object RxLabel2: TRxLabel
    Left = 32
    Top = 120
    Width = 8
    Height = 13
    Caption = '2'
  end
  object RxLabel3: TRxLabel
    Left = 160
    Top = 120
    Width = 14
    Height = 13
    Caption = '20'
  end
  object RxLabel4: TRxLabel
    Left = 8
    Top = 136
    Width = 108
    Height = 26
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080#1075#1088#1086#1082#1086#1074'-'#13#10#1083#1102#1076#1077#1081' '#1085#1072' '#1082#1072#1088#1090#1077
  end
  object RxSlider1: TRxSlider
    Left = 32
    Top = 80
    Width = 150
    Height = 40
    Increment = 1
    MinValue = 2
    MaxValue = 20
    TabOrder = 0
    Value = 2
  end
  object Panel1: TPanel
    Left = 248
    Top = 24
    Width = 433
    Height = 409
    BevelInner = bvRaised
    BorderWidth = 2
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Color = clBlack
    TabOrder = 1
    object PaintMap: TPaintBox
      Left = 128
      Top = 32
      Width = 305
      Height = 337
    end
  end
  object RxSpinEdit1: TRxSpinEdit
    Left = 128
    Top = 136
    Width = 49
    Height = 28
    MaxValue = 10
    MinValue = 1
    Value = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object GenNewMapBtn: TBitBtn
    Left = 24
    Top = 272
    Width = 177
    Height = 25
    Caption = '&'#1043#1077#1085#1077#1088#1072#1094#1080#1103' '#1085#1086#1074#1086#1081' '#1082#1072#1088#1090#1099
    TabOrder = 3
    Kind = bkRetry
  end
  object ExitBtn: TBitBtn
    Left = 24
    Top = 392
    Width = 177
    Height = 25
    Caption = '&'#1042' '#1075#1083#1072#1074#1085#1086#1077' '#1084#1077#1085#1102
    TabOrder = 4
    Kind = bkClose
  end
  object BitBtn1: TBitBtn
    Left = 24
    Top = 304
    Width = 177
    Height = 25
    Caption = '&'#1042#1099#1073#1086#1088' '#1090#1077#1088#1088#1080#1090#1086#1088#1080#1080
    TabOrder = 5
    OnClick = BitBtn1Click
    Kind = bkRetry
  end
end
