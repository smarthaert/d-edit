object Form1: TForm1
  Left = 192
  Top = 107
  Width = 564
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object DXDraw: TDXDraw
    Left = 0
    Top = 0
    Width = 556
    Height = 453
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Options = [doAllowReboot, doWaitVBlank, doCenter, doRetainedMode, doHardware, doSelectDriver]
    SurfaceHeight = 453
    SurfaceWidth = 556
    Align = alClient
    TabOrder = 0
  end
  object ImageList: TDXImageList
    DXDraw = DXDraw
    Items.ColorTable = {
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000}
    Items = <
      item
        Name = 'Tank 1'
        PatternHeight = 0
        PatternWidth = 0
        Picture.Data = {
          04544449422800000020000000200000000100180000000000000C0000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000080000080000080000080
          0000800000800000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00000000000000000000000000000000800000800000FF0000FF0000FF0000FF
          0000FF0000FF000080000080000000000000000000000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00000000000000000000000000800000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000800000000000000000000000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00000000000000000000800000FF0000FF0000FF000080000080000080000080
          0000800000800000FF0000FF0000FF000080000000000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00000000000000800000FF0000FF0000800000800000FF0000FF0000FF0000FF
          0000FF0000FF0000800000800000FF0000FF0000800000000000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00000000800000FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000800000FF0000FF000080000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00000000800000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000800000FF0000800000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00800000FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF000080C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000FF0000800000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000800000FF0000FF0000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000FF0000FF0000FF0000800000800000FF0000FF0000FF0000FF
          0000FF0000FF0000800000800000FF0000FF0000FF0000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF000080000080000080000080
          0000800000800000FF0000FF0000800000800000FF0000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000FF0000FF0000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000FF0000FF0000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000FF0000FF0000800000FF0000FFC0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000800000800000800000800000FF0000FF8080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000800000FF0000FF
          0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF000080C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00000000800000FF0000FF0000FF0000FF0000FF0000800000800000FF0000FF
          0000800000800000FF0000FF0000FF0000FF0000FF0000800000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00000000000000800000FF0000FF0000FF0000800000000000800000FF0000FF
          0000800000000000800000FF0000FF0000FF000080000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          00000000000000000000800000FF0000800000000000000000800000FF0000FF
          0000800000000000000000800000FF0000800000000000000000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          00000000000000000000000000800000000000000000000000800000FF0000FF
          000080000000000000000000000080000000000000000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000800000FF0000FF
          0000800000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000080000080000080
          0000800000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000}
        SystemMemory = False
        Transparent = True
        TransparentColor = clBlack
      end
      item
        Name = 'Tank 2'
        PatternHeight = 0
        PatternWidth = 0
        Picture.Data = {
          04544449422800000020000000200000000100180000000000000C0000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000000000000000000000000000000000008080008080008080008080008080
          008080008080008080000000000000000000000000000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          000000000000000000000000808000808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D90080800080800000000000000000000000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          808000000000000000808000D9D900D9D900D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900D9D900D9D9008080000000000000008080C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900808000808000D9D900D9D900D9D900D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900D9D900D9D900D9D900808000808000D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900808000808000D9D900D9D900D9D900D9D9
          00D9D900D9D900808000808000D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900808000D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900808000D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900808000808000808000808000D9D900D9D900D9D9
          00D9D900808000808000808000808000D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900D9D9C0C0C0C0C0C000D9D900D9D900D9D900D9D9
          00D9D900D9D9C0C0C0C0C0C000D9D900D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900D9D900D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900D9D900D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000000000000000000000000000000000000
          D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9008080008080008080
          00808000D9D900D9D900D9D900D9D900D9D900808000D9D900D9D90000000000
          00000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900D9D900D9D900808000D9D900D9D900D9D9
          00D9D900808000D9D900D9D900D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900D9D900D9D900808000D9D900D9D900D9D900D9D9
          00D9D900D9D900808000D9D900D9D900D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900D9D900808000D9D900D9D900808000D9D900D9D900D9D900D9D900D9D9
          00D9D900D9D900D9D900808000D9D900D9D900808000D9D900D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          D9D900D9D900808000D9D900D9D900D9D9008080008080008080008080008080
          00808000808000808000D9D900D9D900D9D900808000D9D900D9D9C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          D9D900808000808000D9D900D9D900D9D900D9D900D9D900808000D9D900D9D9
          00808000D9D900D9D900D9D900D9D900D9D900808000808000D9D98080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          808000000000808000D9D900D9D900D9D900D9D900D9D900808000D9D900D9D9
          00808000D9D900D9D900D9D900D9D900D9D9008080000000008080C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000080808080808080808080808080808000
          000000000000000000808000D9D900D9D900D9D900D9D900808000D9D900D9D9
          00808000D9D900D9D900D9D900D9D90080800000000000000000008080808080
          80808080808080808080000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          000000000000000000000000808000808000D9D900D9D900808000D9D900D9D9
          00808000D9D900D9D9008080008080000000000000000000000000C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C000000000000000000000000000000000000000000000
          000000000000000000000000000000000000808000808000808000D9D900D9D9
          0080800080800080800000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000008080008080008080
          0080800000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000}
        SystemMemory = False
        Transparent = True
        TransparentColor = clBlack
      end
      item
        Name = 'Tank 3'
        PatternHeight = 0
        PatternWidth = 0
        Picture.Data = {
          04544449422800000020000000200000000100180000000000000C0000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000080808080808000000080808080808000
          0000000000000000008000008000000000000000008000008000000000000000
          0080000080000000000000000080000080000000000000000000008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          000000000000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B9000080000000000000008080808080
          8000000080808080808000000000000080808080808000B90080808080808000
          800000800000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B9000080000080000080008080808080
          8000B90080808080808000000000000080808080808000B90080808080808000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080008080808080
          8000B90080808080808000000000000080808080808000000080808080808000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080008080808080
          8000000080808080808000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080000000000000
          0000000000000000000000000000000080808080808000000080808080808000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          800000B90000800000B90000B90000800000800000B90000B900008000008000
          00B90000B90000800000800000B90000B90000800000B9000080008080808080
          8000000080808080808000000000000080808080808000B90080808080808000
          800000B900008000008000008000008000008000008000008000008000008000
          00800000800000800000800000800000800000800000B9000080008080808080
          8000B90080808080808000000000000080808080808000B90080808080808000
          800000B900808080C0C0C0C0C0C0808080808080C0C0C0C0C0C0808080808080
          C0C0C0C0C0C0808080808080C0C0C0C0C0C080808000B9000080008080808080
          8000B90080808080808000000000000080808080808000000080808080808000
          800000B900808080C0C0C0C0C0C0808080808080C0C0C0C0C0C0808080808080
          C0C0C0C0C0C0808080808080C0C0C0C0C0C080808000B9000080008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          800000B90000B900C0C0C0C0C0C000B90000B900C0C0C0C0C0C000B90000B900
          C0C0C0C0C0C000B90000B900C0C0C0C0C0C000B90000B9000080008080808080
          8000000080808080808000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000B90000B900008000008000008000008000
          00800000800000B90000B90000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          800000B90000B90000B90000B90000800000800000B90000B90000B90000B900
          00B90000B90000800000800000B90000B90000B90000B9000080000000000000
          0000000000000000000000000000000080808080808000000080808080808000
          800000B90000B90000B90000800000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000800000B90000B90000B9000080008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          800000B90000B90000B90000800000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000800000B90000B90000B9000080008080808080
          8000000080808080808000000000000080808080808000B90080808080808000
          800000B90000B90000B90000800000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B90000800000B90000B90000B9000080008080808080
          8000B90080808080808000000000000080808080808000B90080808080808000
          800000800000800000800000800000B90000B90000B90000B90000B90000B900
          00B90000B90000B90000B9000080000080000080000080000080008080808080
          8000B90080808080808000000000000080808080808000000080808080808000
          000000000000000000000000000000800000800000B90000B90000B90000B900
          00B90000B9000080000080000000000000000000000000000000008080808080
          8000000080808080808000000000000080808080808000000080808080808000
          0000000000000000000000000000000000000000008000008000008000008000
          0080000080000000000000000000000000000000000000000000008080808080
          8000000080808080808000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000}
        SystemMemory = False
        Transparent = True
        TransparentColor = clBlack
      end
      item
        Name = 'Fire'
        PatternHeight = 0
        PatternWidth = 0
        Picture.Data = {
          04544449422800000008000000080000000100180000000000C0000000000000
          000000000000000000000000000000000000007B46657B46657B46657B466500
          0000000000000000BD8CA8A35C85A35C857B4665A35C857B4665000000BD8CA8
          A35C85A35C85A35C85A35C857B4665A35C857B4665BD8CA8BD8CA8A35C85A35C
          85A35C85A35C857B46657B4665BD8CA8A35C85BD8CA8A35C85A35C85A35C85A3
          5C857B4665BD8CA8BD8CA8FFFFFFBD8CA8A35C85A35C85A35C857B4665000000
          BD8CA8BD8CA8A35C85BD8CA8A35C85BD8CA8000000000000000000BD8CA8BD8C
          A8BD8CA8BD8CA8000000000000}
        SystemMemory = False
        Transparent = True
        TransparentColor = clBlack
      end>
    Left = 8
    Top = 8
  end
  object DXInput: TDXInput
    ActiveOnly = True
    Joystick.BindInputStates = True
    Joystick.Effects.Effects = {
      FF0A0044454C50484958464F524345464545444241434B454646454354003010
      6E000000545046301D54466F726365466565646261636B456666656374436F6D
      706F6E656E74025F3107456666656374730E01044E616D650607456666656374
      730A45666665637454797065070665744E6F6E6506506572696F64023205506F
      7765720310270454696D6503E80300000000}
    Joystick.Enabled = True
    Joystick.ForceFeedback = False
    Joystick.AutoCenter = True
    Joystick.DeadZoneX = 50
    Joystick.DeadZoneY = 50
    Joystick.DeadZoneZ = 50
    Joystick.ID = 0
    Joystick.RangeX = 1000
    Joystick.RangeY = 1000
    Joystick.RangeZ = 1000
    Keyboard.BindInputStates = True
    Keyboard.Effects.Effects = {
      FF0A0044454C50484958464F524345464545444241434B454646454354003010
      6E000000545046301D54466F726365466565646261636B456666656374436F6D
      706F6E656E74025F3107456666656374730E01044E616D650607456666656374
      730A45666665637454797065070665744E6F6E6506506572696F64023205506F
      7765720310270454696D6503E80300000000}
    Keyboard.Enabled = True
    Keyboard.ForceFeedback = False
    Keyboard.Assigns = {
      4B00000026000000680000004A00000028000000620000004800000025000000
      640000004C00000027000000660000005A000000200000000000000058000000
      0D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000071000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000}
    Mouse.BindInputStates = False
    Mouse.Effects.Effects = {
      FF0A0044454C50484958464F524345464545444241434B454646454354003010
      6E000000545046301D54466F726365466565646261636B456666656374436F6D
      706F6E656E74025F3107456666656374730E01044E616D650607456666656374
      730A45666665637454797065070665744E6F6E6506506572696F64023205506F
      7765720310270454696D6503E80300000000}
    Mouse.Enabled = False
    Mouse.ForceFeedback = False
    UseDirectInput = True
    Left = 40
    Top = 8
  end
  object DXTimer1: TDXTimer
    ActiveOnly = True
    Enabled = True
    Interval = 0
    OnTimer = DXTimer1Timer
    Left = 72
    Top = 8
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 104
    Top = 8
  end
end
