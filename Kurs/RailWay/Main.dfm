object F: TF
  Left = 207
  Top = 172
  Width = 569
  Height = 393
  Caption = #1052#1054#1044#1045#1051#1068' '#1046#1045#1051#1045#1047#1053#1054#1044#1054#1056#1054#1046#1053#1054#1043#1054' '#1055#1045#1056#1045#1043#1054#1053#1040
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object LeftUpB: TBevel
    Left = 8
    Top = 56
    Width = 185
    Height = 9
  end
  object LeftDownB: TBevel
    Left = 8
    Top = 248
    Width = 185
    Height = 9
  end
  object LeftB: TBevel
    Left = 184
    Top = 56
    Width = 9
    Height = 201
  end
  object CenterB: TBevel
    Left = 184
    Top = 160
    Width = 193
    Height = 9
  end
  object RigthB: TBevel
    Left = 368
    Top = 56
    Width = 9
    Height = 201
  end
  object RightUB: TBevel
    Left = 368
    Top = 56
    Width = 185
    Height = 9
  end
  object RigthDB: TBevel
    Left = 368
    Top = 248
    Width = 185
    Height = 9
  end
  object Label1: TLabel
    Left = 88
    Top = 16
    Width = 91
    Height = 13
    Caption = #1054#1073#1097#1072#1103#1103' '#1086#1095#1077#1088#1077#1076#1100': '
  end
  object Queue: TLabel
    Left = 184
    Top = 16
    Width = 3
    Height = 13
  end
  object Direction: TLabel
    Left = 256
    Top = 120
    Width = 42
    Height = 13
    Caption = 'Direction'
  end
  object Count: TLabel
    Left = 264
    Top = 136
    Width = 28
    Height = 13
    Caption = 'Count'
  end
  object RigthBtn: TBitBtn
    Left = 296
    Top = 304
    Width = 75
    Height = 25
    Caption = #1055#1088#1072#1074#1099#1081
    TabOrder = 0
    OnClick = RigthBtnClick
  end
  object LeftBtn: TBitBtn
    Left = 192
    Top = 304
    Width = 75
    Height = 25
    Caption = #1051#1077#1074#1099#1081
    TabOrder = 1
    OnClick = LeftBtnClick
  end
end
