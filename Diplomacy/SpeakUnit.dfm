object SpeakForm: TSpeakForm
  Left = 255
  Top = 218
  Width = 576
  Height = 362
  Caption = #1043#1086#1074#1086#1088#1080#1084' '#1089' '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TryBtn: TBitBtn
    Left = 64
    Top = 304
    Width = 121
    Height = 25
    Caption = '&'#1055#1086#1087#1088#1086#1073#1086#1074#1072#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 408
    Top = 304
    Width = 121
    Height = 25
    Caption = '&'#1054#1090#1084#1077#1085#1072
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 16
    Width = 289
    Height = 265
    Caption = 'GroupBox1'
    TabOrder = 2
    object cPeace1: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = #1052#1080#1088
      TabOrder = 0
      OnClick = cPeace1Click
    end
    object cMoveRight1: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = #1055#1088#1072#1074#1086' '#1087#1088#1086#1093#1086#1076#1072
      TabOrder = 1
    end
    object cMoney1: TLabeledEdit
      Left = 8
      Top = 72
      Width = 121
      Height = 21
      BiDiMode = bdLeftToRight
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.BiDiMode = bdLeftToRight
      EditLabel.Caption = #1044#1077#1085#1100#1075#1080
      EditLabel.ParentBiDiMode = False
      LabelPosition = lpAbove
      LabelSpacing = 3
      ParentBiDiMode = False
      TabOrder = 2
      OnChange = cMoneyClick
    end
    object cZerno1: TLabeledEdit
      Left = 160
      Top = 72
      Width = 121
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1077#1088#1085#1086
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 3
      OnChange = cMoneyClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 296
    Top = 16
    Width = 265
    Height = 265
    Caption = 'GroupBox2'
    TabOrder = 3
    object cPeace2: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = #1052#1080#1088
      TabOrder = 0
      OnClick = cPeace2Click
    end
    object cMoney2: TLabeledEdit
      Left = 8
      Top = 72
      Width = 121
      Height = 21
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1077#1085#1100#1075#1080
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 1
      OnChange = cMoneyClick
    end
    object cZerno2: TLabeledEdit
      Left = 136
      Top = 72
      Width = 121
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1077#1088#1085#1086
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 2
      OnChange = cMoneyClick
    end
    object cMoveRight2: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = #1055#1088#1072#1074#1086' '#1087#1088#1086#1093#1086#1076#1072
      TabOrder = 3
    end
  end
end
