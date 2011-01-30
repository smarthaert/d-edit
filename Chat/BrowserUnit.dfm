object BrowserForm: TBrowserForm
  Left = 296
  Top = 182
  Caption = #1055#1088#1086#1089#1090#1077#1081#1096#1080#1081' Web-'#1073#1088#1072#1091#1079#1077#1088
  ClientHeight = 446
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainWB: TWebBrowser
    Left = 0
    Top = 41
    Width = 688
    Height = 405
    Align = alClient
    TabOrder = 0
    ExplicitTop = 48
    ExplicitWidth = 680
    ExplicitHeight = 385
    ControlData = {
      4C0000001B470000DC2900000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 160
    ExplicitTop = 8
    ExplicitWidth = 185
    object SiteURL: TEdit
      Left = 120
      Top = 14
      Width = 321
      Height = 21
      TabOrder = 0
      Text = 'SiteURL'
    end
    object GoButton: TButton
      Left = 447
      Top = 10
      Width = 50
      Height = 25
      Caption = 'Go!'
      TabOrder = 1
      OnClick = GoButtonClick
    end
  end
  object XPManifest1: TXPManifest
    Left = 656
  end
  object TcpClient1: TTcpClient
    Left = 448
    Top = 80
  end
  object TcpServer1: TTcpServer
    Left = 520
    Top = 80
  end
end
