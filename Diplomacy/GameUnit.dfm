object GameForm: TGameForm
  Left = 135
  Top = 153
  Width = 742
  Height = 546
  Caption = #1044#1080#1087#1083#1086#1084#1072#1090#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = ExitClick
  PixelsPerInch = 96
  TextHeight = 13
  object RxLabel43: TRxLabel
    Left = 11
    Top = 104
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = #1058#1077#1088#1088#1080#1090#1086#1088#1080#1103':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 734
    Height = 519
    ActivePage = TabSheet6
    Align = alClient
    TabIndex = 5
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
    end
    object TabSheet2: TTabSheet
      Caption = #1069#1082#1086#1085#1086#1084#1080#1082#1072
      ImageIndex = 1
      object GroupBox9: TGroupBox
        Left = 544
        Top = 8
        Width = 161
        Height = 201
        Caption = ' '#1042#1072#1096#1080' '#1088#1077#1089#1091#1088#1089#1099' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object RxLabel53: TRxLabel
          Left = 17
          Top = 32
          Width = 67
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1072#1089#1077#1083#1077#1085#1080#1077':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel54: TRxLabel
          Left = 32
          Top = 48
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1088#1077#1089#1090#1100#1103#1085':'
        end
        object RxLabel55: TRxLabel
          Left = 40
          Top = 64
          Width = 45
          Height = 13
          Alignment = taRightJustify
          Caption = #1059#1095#1105#1085#1099#1093':'
        end
        object RxLabel56: TRxLabel
          Left = 41
          Top = 80
          Width = 44
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1086#1083#1076#1072#1090':'
        end
        object RxLabel57: TRxLabel
          Left = 11
          Top = 104
          Width = 73
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1088#1088#1080#1090#1086#1088#1080#1103':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel58: TRxLabel
          Left = 15
          Top = 120
          Width = 66
          Height = 26
          Alignment = taRightJustify
          Caption = #1052#1072#1082#1089'.'#13#10#1085#1072#1089#1077#1083#1077#1085#1080#1103':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel59: TRxLabel
          Left = 36
          Top = 152
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1077#1085#1100#1075#1080':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel60: TRxLabel
          Left = 44
          Top = 176
          Width = 40
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1077#1088#1085#1086':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurrencyEdit12: TCurrencyEdit
          Left = 88
          Top = 24
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 0
        end
        object CurrencyEdit22: TCurrencyEdit
          Left = 88
          Top = 48
          Width = 65
          Height = 18
          Alignment = taCenter
          AutoSize = False
          BorderStyle = bsNone
          Color = clActiveBorder
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 1
        end
        object CurrencyEdit23: TCurrencyEdit
          Left = 88
          Top = 64
          Width = 65
          Height = 18
          Alignment = taCenter
          AutoSize = False
          BorderStyle = bsNone
          Color = clActiveBorder
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 2
        end
        object CurrencyEdit24: TCurrencyEdit
          Left = 88
          Top = 80
          Width = 65
          Height = 18
          Alignment = taCenter
          AutoSize = False
          BorderStyle = bsNone
          Color = clActiveBorder
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 3
        end
        object CurrencyEdit25: TCurrencyEdit
          Left = 88
          Top = 96
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 4
        end
        object CurrencyEdit26: TCurrencyEdit
          Left = 88
          Top = 120
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 5
        end
        object CurrencyEdit27: TCurrencyEdit
          Left = 88
          Top = 144
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 6
        end
        object CurrencyEdit28: TCurrencyEdit
          Left = 88
          Top = 168
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 7
        end
      end
      object GroupBox7: TGroupBox
        Left = 544
        Top = 216
        Width = 161
        Height = 81
        Caption = #1055#1088#1080#1088#1086#1089#1090
        TabOrder = 1
        object RxLabel37: TRxLabel
          Left = 44
          Top = 28
          Width = 40
          Height = 13
          Alignment = taRightJustify
          Caption = #1047#1077#1088#1085#1086':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel38: TRxLabel
          Left = 17
          Top = 52
          Width = 67
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1072#1089#1077#1083#1077#1085#1080#1077':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CurrencyEdit6: TCurrencyEdit
          Left = 88
          Top = 20
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 0
        end
        object CurrencyEdit7: TCurrencyEdit
          Left = 88
          Top = 44
          Width = 65
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0;-,0'
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1053#1072#1091#1082#1072
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 16
        Top = 8
        Width = 313
        Height = 137
        Caption = ' '#1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1080#1103' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object RxLabel1: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object RxLabel2: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel3: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object RxLabel4: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel5: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object RxLabel6: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar1: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object MinBtn: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Hint = #1057#1085#1103#1090#1100' '#1074#1089#1077#1093' '#1091#1095#1077#1085#1099#1093' '#1089' '#1101#1090#1086#1075#1086' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object MaxBtn: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object ScEdit: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object LevelEdit: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox2: TGroupBox
        Left = 344
        Top = 8
        Width = 313
        Height = 137
        Caption = ' '#1044#1077#1085#1077#1078#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072'  '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object RxLabel7: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
        end
        object RxLabel8: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel9: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
        end
        object RxLabel10: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel11: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
        end
        object RxLabel12: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar2: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object Button1: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object Button2: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RxSpinEdit1: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CurrencyEdit1: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox3: TGroupBox
        Left = 16
        Top = 152
        Width = 313
        Height = 137
        Caption = ' '#1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1080#1103' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object RxLabel13: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
        end
        object RxLabel14: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel15: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
        end
        object RxLabel16: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel17: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
        end
        object RxLabel18: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar3: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object Button3: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object Button4: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RxSpinEdit2: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CurrencyEdit2: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox4: TGroupBox
        Left = 344
        Top = 152
        Width = 313
        Height = 137
        Caption = ' '#1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1080#1103' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object RxLabel19: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
        end
        object RxLabel20: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel21: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
        end
        object RxLabel22: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel23: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
        end
        object RxLabel24: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar4: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object Button5: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object Button6: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RxSpinEdit3: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CurrencyEdit3: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox5: TGroupBox
        Left = 16
        Top = 296
        Width = 313
        Height = 137
        Caption = ' '#1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1080#1103' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object RxLabel25: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
        end
        object RxLabel26: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel27: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
        end
        object RxLabel28: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel29: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
        end
        object RxLabel30: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar5: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object Button7: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object Button8: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RxSpinEdit4: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CurrencyEdit4: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox6: TGroupBox
        Left = 344
        Top = 296
        Width = 313
        Height = 137
        Caption = ' '#1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1080#1103' '
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        object RxLabel31: TRxLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = #1058#1077#1082#1091#1097#1080#1081' '#1091#1088#1086#1074#1077#1085#1100':'
        end
        object RxLabel32: TRxLabel
          Left = 112
          Top = 24
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel33: TRxLabel
          Left = 8
          Top = 40
          Width = 80
          Height = 13
          Caption = #1053#1091#1078#1085#1086' '#1091#1095#1077#1085#1099#1093':'
        end
        object RxLabel34: TRxLabel
          Left = 112
          Top = 40
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RxLabel35: TRxLabel
          Left = 8
          Top = 112
          Width = 107
          Height = 13
          Caption = #1054#1090#1082#1088#1086#1102#1090' '#1074' '#1090#1077#1095#1077#1085#1080#1080':'
        end
        object RxLabel36: TRxLabel
          Left = 120
          Top = 112
          Width = 9
          Height = 13
          Caption = '0'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ProgressBar6: TProgressBar
          Left = 144
          Top = 16
          Width = 62
          Height = 105
          Min = 0
          Max = 100
          Orientation = pbVertical
          Smooth = True
          TabOrder = 0
        end
        object Button9: TButton
          Left = 216
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Min'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object Button10: TButton
          Left = 264
          Top = 40
          Width = 41
          Height = 25
          Caption = 'Max'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object RxSpinEdit5: TRxSpinEdit
          Left = 232
          Top = 80
          Width = 65
          Height = 22
          Alignment = taCenter
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object CurrencyEdit5: TCurrencyEdit
          Left = 32
          Top = 64
          Width = 73
          Height = 21
          Alignment = taCenter
          AutoSize = False
          DisplayFormat = ',0.00;-,0.00'
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1043#1088#1072#1085#1080#1094#1099
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = #1040#1088#1084#1080#1103
      ImageIndex = 4
    end
    object TabSheet6: TTabSheet
      Caption = #1044#1080#1087#1083#1086#1084#1072#1090#1080#1103
      ImageIndex = 5
      object Label1: TLabel
        Left = 160
        Top = 48
        Width = 27
        Height = 13
        Caption = #1052#1080#1088' :'
      end
      object PeaceLabel: TLabel
        Left = 232
        Top = 48
        Width = 57
        Height = 13
        Alignment = taRightJustify
        Caption = 'PeaceLabel'
      end
      object Label2: TLabel
        Left = 160
        Top = 72
        Width = 66
        Height = 13
        Caption = #1058#1077#1088#1088#1080#1090#1086#1088#1080#1103' :'
      end
      object SpaceLabel: TLabel
        Left = 232
        Top = 72
        Width = 57
        Height = 13
        Alignment = taRightJustify
        Caption = 'SpaceLabel'
      end
      object ListBox1: TListBox
        Left = 8
        Top = 8
        Width = 137
        Height = 409
        ItemHeight = 13
        TabOrder = 0
      end
      object SpeakBtn: TBitBtn
        Left = 160
        Top = 8
        Width = 129
        Height = 33
        Caption = '&'#1055#1086#1075#1086#1074#1086#1088#1080#1090#1100
        Default = True
        TabOrder = 1
        OnClick = SpeakBtnClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
          33333333333F8888883F33330000324334222222443333388F3833333388F333
          000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
          F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
          223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
          3338888300003AAAAAAA33333333333888888833333333330000333333333333
          333333333333333333FFFFFF000033333333333344444433FFFF333333888888
          00003A444333333A22222438888F333338F3333800003A2243333333A2222438
          F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
          22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
          33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
          3333333333338888883333330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
  end
  object Panel1: TPanel
    Left = 416
    Top = 0
    Width = 305
    Height = 25
    Caption = 'Panel1'
    TabOrder = 1
    object RxLabel39: TRxLabel
      Left = 8
      Top = 8
      Width = 35
      Height = 13
      Caption = #1061#1086#1076#1080#1090':'
    end
    object CurCountryName: TRxLabel
      Left = 56
      Top = 4
      Width = 35
      Height = 13
      Caption = #1061#1086#1076#1080#1090':'
    end
    object ExitBtn: TBitBtn
      Left = 222
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Exit'
      TabOrder = 0
      OnClick = ExitBtnClick
      Kind = bkCancel
    end
    object NextCountryBtn: TBitBtn
      Left = 144
      Top = 0
      Width = 75
      Height = 25
      Caption = '&Next'
      TabOrder = 1
      OnClick = NextCountryBtnClick
      Kind = bkIgnore
    end
  end
end
