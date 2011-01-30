object Form1: TForm1
  Left = 271
  Top = 150
  Width = 579
  Height = 476
  Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1084#1072#1090#1088#1080#1094#1072#1084#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 576
    Top = 192
    Width = 3
    Height = 13
    Visible = False
  end
  object Label6: TLabel
    Left = 16
    Top = 160
    Width = 54
    Height = 13
    Caption = #1052#1072#1090#1088#1080#1094#1072' '#1040
  end
  object Label7: TLabel
    Left = 312
    Top = 160
    Width = 54
    Height = 13
    Caption = #1052#1072#1090#1088#1080#1094#1072' '#1042
  end
  object Label8: TLabel
    Left = 16
    Top = 288
    Width = 52
    Height = 13
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  end
  object SG1: TStringGrid
    Left = 16
    Top = 176
    Width = 248
    Height = 98
    DefaultColWidth = 48
    DefaultRowHeight = 18
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    OnSelectCell = SG1SelectCell
  end
  object SG2: TStringGrid
    Left = 312
    Top = 176
    Width = 248
    Height = 98
    DefaultColWidth = 48
    DefaultRowHeight = 18
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    OnSelectCell = SG1SelectCell
  end
  object BitBtn1: TBitBtn
    Left = 488
    Top = 416
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 6
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 272
    Top = 192
    Width = 33
    Height = 25
    Hint = #1057#1083#1086#1078#1077#1085#1080#1077
    Caption = '+'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn2Click
  end
  object SG3: TStringGrid
    Left = 16
    Top = 304
    Width = 248
    Height = 98
    DefaultColWidth = 48
    DefaultRowHeight = 18
    FixedCols = 0
    FixedRows = 0
    TabOrder = 7
    OnSelectCell = SG3SelectCell
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 409
    Height = 137
    Caption = #1056#1072#1079#1084#1077#1088#1099
    TabOrder = 5
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 97
      Height = 13
      Caption = #1064#1080#1088#1080#1085#1072' '#1084#1072#1090#1088#1080#1094#1099' '#1040
    end
    object Label2: TLabel
      Left = 8
      Top = 76
      Width = 91
      Height = 13
      Caption = #1044#1083#1080#1085#1072' '#1084#1072#1090#1088#1080#1094#1099' '#1040
    end
    object Label3: TLabel
      Left = 216
      Top = 28
      Width = 97
      Height = 13
      Caption = #1064#1080#1088#1080#1085#1072' '#1084#1072#1090#1088#1080#1094#1099' '#1040
    end
    object Label4: TLabel
      Left = 216
      Top = 76
      Width = 91
      Height = 13
      Caption = #1044#1083#1080#1085#1072' '#1084#1072#1090#1088#1080#1094#1099' '#1040
    end
    object Edit1: TEdit
      Left = 112
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 0
      Text = '2'
      OnExit = Edit4Exit
    end
    object Edit2: TEdit
      Left = 112
      Top = 72
      Width = 81
      Height = 21
      TabOrder = 1
      Text = '3'
      OnExit = Edit4Exit
    end
    object Edit3: TEdit
      Left = 320
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 2
      Text = '3'
      OnExit = Edit4Exit
    end
    object BitBtn3: TBitBtn
      Left = 184
      Top = 104
      Width = 217
      Height = 25
      Caption = #1055#1088#1080#1085#1103#1090#1100
      TabOrder = 4
      OnClick = BitBtn3Click
    end
    object Edit4: TEdit
      Left = 320
      Top = 72
      Width = 81
      Height = 21
      TabOrder = 3
      Text = '4'
      OnExit = Edit4Exit
    end
  end
  object BitBtn4: TBitBtn
    Left = 272
    Top = 216
    Width = 33
    Height = 25
    Hint = #1042#1099#1095#1080#1090#1072#1085#1080#1077
    Caption = '-'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 272
    Top = 240
    Width = 33
    Height = 25
    Hint = #1059#1084#1085#1086#1078#1077#1085#1080#1077
    Caption = '*'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn5Click
  end
end
