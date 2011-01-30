object HostSettingsForm: THostSettingsForm
  Left = 251
  Top = 260
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1079#1083#1072
  ClientHeight = 336
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 92
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
  end
  object Label2: TLabel
    Left = 8
    Top = 116
    Width = 25
    Height = 13
    Caption = #1055#1086#1088#1090
  end
  object Label3: TLabel
    Left = 8
    Top = 172
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
    Enabled = False
  end
  object Label4: TLabel
    Left = 8
    Top = 196
    Width = 25
    Height = 13
    Caption = #1055#1086#1088#1090
    Enabled = False
  end
  object Label5: TLabel
    Left = 8
    Top = 252
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
    Enabled = False
  end
  object Label6: TLabel
    Left = 8
    Top = 276
    Width = 25
    Height = 13
    Caption = #1055#1086#1088#1090
    Enabled = False
  end
  object Label7: TLabel
    Left = 8
    Top = 12
    Width = 85
    Height = 13
    Caption = #1048#1084#1103' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
  end
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 313
    Height = 9
    Shape = bsTopLine
  end
  object Label8: TLabel
    Left = 8
    Top = 56
    Width = 75
    Height = 13
    Caption = #1054#1090#1074#1077#1090' '#1089#1077#1088#1074#1077#1088#1072
  end
  object PortEdit: TRzSpinEdit
    Left = 48
    Top = 112
    Width = 57
    Height = 21
    AllowKeyEdit = True
    Max = 65535.000000000000000000
    Min = 1.000000000000000000
    Value = 110.000000000000000000
    TabOrder = 2
    OnChange = NameEditChange
  end
  object HostEdit: TEdit
    Left = 48
    Top = 88
    Width = 273
    Height = 21
    TabOrder = 1
    OnChange = NameEditChange
  end
  object RzDialogButtons1: TRzDialogButtons
    Left = 0
    Top = 300
    Width = 336
    CaptionOk = 'OK'
    CaptionCancel = 'Cancel'
    CaptionHelp = '&Help'
    ModalResultOk = 1
    ModalResultCancel = 2
    ModalResultHelp = 0
    ParentShowHint = False
    ShowHint = False
    TabOrder = 8
  end
  object HasAltCB: TCheckBox
    Left = 8
    Top = 144
    Width = 209
    Height = 17
    Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1086#1077' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
    TabOrder = 3
    OnClick = HasAltCBClick
  end
  object AltPortEdit: TRzSpinEdit
    Left = 48
    Top = 192
    Width = 57
    Height = 21
    AllowKeyEdit = True
    Max = 65535.000000000000000000
    Min = 1.000000000000000000
    Value = 110.000000000000000000
    Enabled = False
    TabOrder = 5
  end
  object AltHostEdit: TEdit
    Left = 48
    Top = 168
    Width = 273
    Height = 21
    Enabled = False
    TabOrder = 4
  end
  object AltPort1Edit: TRzSpinEdit
    Left = 48
    Top = 272
    Width = 57
    Height = 21
    AllowKeyEdit = True
    Max = 65535.000000000000000000
    Min = 1.000000000000000000
    Value = 110.000000000000000000
    Enabled = False
    TabOrder = 7
  end
  object AltHost1Edit: TEdit
    Left = 48
    Top = 248
    Width = 273
    Height = 21
    Enabled = False
    TabOrder = 6
  end
  object HasAlt1CB: TCheckBox
    Left = 8
    Top = 224
    Width = 209
    Height = 17
    Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1086#1077' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077' 2'
    Enabled = False
    TabOrder = 9
    OnClick = HasAlt1CBClick
  end
  object NameEdit: TEdit
    Left = 104
    Top = 8
    Width = 217
    Height = 21
    TabOrder = 0
    OnChange = NameEditChange
  end
  object AnswerEdit: TEdit
    Left = 88
    Top = 52
    Width = 233
    Height = 21
    TabOrder = 10
  end
end
