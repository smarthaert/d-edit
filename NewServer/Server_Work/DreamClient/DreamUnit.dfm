object F: TF
  Left = 105
  Top = 106
  Width = 667
  Height = 433
  Anchors = []
  Caption = 'Client for Dream Server 2003 - '
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '@Arial Unicode MS'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    659
    399)
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 0
    Top = 8
    Width = 657
    Height = 16
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'ACM Finals 2004 in Saint-Petersburg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 32
    Width = 659
    Height = 374
    ActivePage = MonitorTS
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    object SubmitTS: TTabSheet
      Caption = 'Submit'
      ImageIndex = 2
      object Label1: TLabel
        Left = 122
        Top = 64
        Width = 50
        Height = 16
        Caption = 'Problem:'
      end
      object Label2: TLabel
        Left = 121
        Top = 136
        Width = 39
        Height = 16
        Caption = 'Source'
      end
      object Label3: TLabel
        Left = 120
        Top = 101
        Width = 59
        Height = 16
        Caption = 'Language:'
      end
      object ChooseProblem: TComboBox
        Left = 186
        Top = 64
        Width = 383
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 1
      end
      object SubmitButton: TButton
        Left = 272
        Top = 192
        Width = 75
        Height = 25
        Caption = 'Submit!'
        TabOrder = 3
        OnClick = SubmitButtonClick
      end
      object ChooseLanguage: TComboBox
        Left = 186
        Top = 96
        Width = 383
        Height = 24
        AutoComplete = False
        Style = csDropDownList
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
        OnChange = ChooseLanguageChange
      end
      object SourcePath: TFilenameEdit
        Left = 186
        Top = 128
        Width = 385
        Height = 21
        NumGlyphs = 1
        TabOrder = 2
        OnChange = SourcePathChange
      end
    end
    object MonitorTS: TTabSheet
      Caption = 'Monitor'
      object MonitorDG: TDrawGrid
        Left = 0
        Top = 0
        Width = 651
        Height = 343
        Hint = 'Monitor'
        TabStop = False
        Align = alClient
        BiDiMode = bdLeftToRight
        Ctl3D = False
        DefaultRowHeight = 30
        FixedColor = 10034711
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedHorzLine, goVertLine, goHorzLine]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        OnDrawCell = MonitorDGDrawCell
        ColWidths = (
          181
          73
          36
          35
          32)
      end
    end
    object MessagesTS: TTabSheet
      Caption = 'Messages'
      ImageIndex = 2
      object AArhive: TDrawGrid
        Left = 0
        Top = 0
        Width = 651
        Height = 343
        Hint = 'Monitor'
        TabStop = False
        Align = alClient
        BiDiMode = bdLeftToRight
        Ctl3D = False
        DefaultRowHeight = 30
        FixedColor = 10034711
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goHorzLine]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        OnDrawCell = AArhiveDrawCell
        OnRowMoved = AArhiveRowMoved
        OnSelectCell = AArhiveSelectCell
        ColWidths = (
          181
          73
          36
          35
          32)
      end
    end
    object OptionsTS: TTabSheet
      Caption = 'Options'
      ImageIndex = 3
      object Label5: TLabel
        Left = 15
        Top = 72
        Width = 51
        Height = 16
        Caption = 'FontSize:'
      end
      object CellHeightLabel: TRxLabel
        Left = 8
        Top = 40
        Width = 93
        Height = 16
        Caption = ' '#1042#1099#1089#1086#1090#1072' '#1103#1095#1077#1081#1082#1080':'
      end
      object Edit1: TEdit
        Left = 74
        Top = 64
        Width = 121
        Height = 24
        TabOrder = 0
        Text = 'Edit1'
      end
      object BitBtn1: TBitBtn
        Left = 210
        Top = 64
        Width = 97
        Height = 25
        Caption = '&Update!'
        TabOrder = 1
        Kind = bkAll
      end
      object CellHeight: TRxSpinEdit
        Left = 104
        Top = 32
        Width = 57
        Height = 24
        Alignment = taRightJustify
        MaxValue = 25
        MinValue = 12
        Value = 20
        TabOrder = 2
        OnChange = CellHeightChange
      end
    end
  end
  object XMLDocument1: TXMLDocument
    Left = 606
    Top = 24
    DOMVendorDesc = 'MSXML'
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 574
    Top = 24
  end
end
