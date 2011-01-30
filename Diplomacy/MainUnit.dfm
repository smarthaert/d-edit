object MainForm: TMainForm
  Left = 181
  Top = 181
  Width = 696
  Height = 480
  Caption = #1044#1080#1087#1083#1086#1084#1072#1090#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object NewGameBtn: TBitBtn
    Left = 504
    Top = 168
    Width = 97
    Height = 25
    Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    TabOrder = 0
    OnClick = NewGameBtnClick
  end
  object ExitBtn: TBitBtn
    Left = 504
    Top = 200
    Width = 97
    Height = 25
    Caption = #1042#1099#1081#1090#1080
    TabOrder = 1
    OnClick = ExitBtnClick
  end
end
