object MainForm: TMainForm
  Left = 217
  Top = 107
  Width = 722
  Height = 482
  Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1088#1077#1076#1072#1082#1090#1086#1088
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 133
    Top = 0
    Width = 581
    Height = 436
    Align = alClient
  end
  object LeftToolBar: TActionToolBar
    Left = 0
    Top = 0
    Width = 133
    Height = 436
    Hint = #1055#1072#1085#1077#1083#1100' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074
    ActionManager = ActionManager
    Align = alLeft
    Caption = 'LeftToolBar'
    ColorMap.HighlightColor = 14410210
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 14410210
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Orientation = boTopToBottom
    Spacing = 0
  end
  object MainMenu: TMainMenu
    Left = 135
    Top = 10
    object mFile: TMenuItem
      Caption = #1060#1072#1081#1083
      ShortCut = 16467
      object mNewFile: TMenuItem
        Action = FileNew
      end
      object mFileOpen: TMenuItem
        Action = FileOpen
      end
      object mFileSave: TMenuItem
        Action = FileSave
      end
      object mFileSaveAs: TMenuItem
        Action = FileSaveAs
      end
      object m2: TMenuItem
        Caption = '-'
      end
      object mFilePageSetup: TMenuItem
        Action = FilePageSetup
      end
      object mFilePrintSetup: TMenuItem
        Action = FilePrintSetup
      end
      object m3: TMenuItem
        Caption = '-'
      end
      object mFileExit: TMenuItem
        Action = FileExit
      end
    end
    object mEdit: TMenuItem
      Caption = #1055#1088#1072#1074#1082#1072
      object mUndo: TMenuItem
        Action = EditUndo
      end
      object mEditRepeat: TMenuItem
        Action = EditRepeat
        OnClick = mEditRepeatClick
      end
      object m1: TMenuItem
        Caption = '-'
      end
      object mEditCut: TMenuItem
        Action = EditCut
      end
      object mEditCopy: TMenuItem
        Action = EditCopy
      end
      object mEditPaste: TMenuItem
        Action = EditPaste
      end
      object mEditDelete: TMenuItem
        Action = EditDelete
      end
      object mEditSelectAll: TMenuItem
        Action = EditSelectAll
      end
    end
  end
  object ActionList: TActionList
    Left = 165
    Top = 10
    object EditUndo: TEditUndo
      Category = 'Edit'
      Caption = #1054#1090#1082#1072#1090
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 3
      ShortCut = 16474
      OnExecute = EditUndoExecute
    end
    object EditRepeat: TAction
      Category = 'Edit'
      Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1100
      ShortCut = 16473
    end
    object EditCut: TEditCut
      Category = 'Edit'
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
      OnExecute = EditCutExecute
    end
    object EditCopy: TEditCopy
      Category = 'Edit'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
      OnExecute = EditCopyExecute
    end
    object EditPaste: TEditPaste
      Category = 'Edit'
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditSelectAll: TEditSelectAll
      Category = 'Edit'
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditDelete: TEditDelete
      Category = 'Edit'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = 'Delete|Erases the selection'
      ImageIndex = 5
      ShortCut = 46
    end
    object FileNew: TAction
      Category = 'File'
      Caption = #1053#1086#1074#1099#1081
      ShortCut = 16462
      OnExecute = FileNewExecute
    end
    object FilePrintSetup: TFilePrintSetup
      Category = 'File'
      Caption = #1053#1072#1089#1090#1086#1081#1082#1072' '#1087#1077#1095#1072#1090#1080'...'
      Hint = 'Print Setup'
    end
    object FilePageSetup: TFilePageSetup
      Category = 'File'
      Caption = #1055#1072#1088#1072'&'#1084#1077#1090#1088#1099' '#1089#1090#1088#1072#1085#1080#1094#1099'...'
      Dialog.MinMarginLeft = 0
      Dialog.MinMarginTop = 0
      Dialog.MinMarginRight = 0
      Dialog.MinMarginBottom = 0
      Dialog.MarginLeft = 2500
      Dialog.MarginTop = 2500
      Dialog.MarginRight = 2500
      Dialog.MarginBottom = 2500
      Dialog.PageWidth = 21000
      Dialog.PageHeight = 29700
    end
    object FileExit: TFileExit
      Category = 'File'
      Caption = #1042#1099#1093#1086#1076
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
      ShortCut = 16472
    end
    object FileOpen: TOpenPicture
      Category = 'Dialog'
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083'...'
      Hint = 'Open Picture'
      ShortCut = 16463
      OnAccept = FileOpenAccept
    end
    object FileSaveAs: TSavePicture
      Category = 'Dialog'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
      Hint = 'Save Picture'
      ShortCut = 16467
      OnAccept = FileSaveAsAccept
    end
    object ColorSelect: TColorSelect
      Category = 'Dialog'
      Caption = 'Select &Color...'
      Hint = 'Color Select'
    end
    object FontEdit: TFontEdit
      Category = 'Dialog'
      Caption = 'Select &Font...'
      Dialog.Font.Charset = DEFAULT_CHARSET
      Dialog.Font.Color = clWindowText
      Dialog.Font.Height = -11
      Dialog.Font.Name = 'MS Sans Serif'
      Dialog.Font.Style = []
      Hint = 'Font Select'
    end
    object PrintDlg: TPrintDlg
      Category = 'Dialog'
      Caption = '&Print...'
      ImageIndex = 14
      ShortCut = 16464
    end
    object FileSave: TAction
      Category = 'File'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = FileSaveExecute
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = FileNew
            ShortCut = 16462
          end
          item
            Action = FileOpen
            ShortCut = 16463
          end
          item
            Action = FileSave
          end
          item
            Action = FilePrintSetup
          end
          item
            Action = FilePageSetup
          end
          item
            Action = FileExit
            ImageIndex = 43
            ShortCut = 16472
          end>
        ActionBar = LeftToolBar
      end>
    LinkedActionLists = <
      item
        ActionList = ActionList
        Caption = 'ActionList'
      end>
    Images = ToolbarImageList
    Left = 195
    Top = 10
    StyleName = 'XP Style'
  end
  object ToolbarImageList: TImageList
    Left = 225
    Top = 10
  end
end
