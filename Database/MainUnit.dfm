object MainForm: TMainForm
  Left = 329
  Top = 140
  Width = 525
  Height = 416
  Caption = #1040#1073#1086#1085#1077#1085#1090#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 40
    Width = 505
    Height = 305
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 272
    Top = 352
    Width = 240
    Height = 25
    DataSource = DataSource
    TabOrder = 1
  end
  object ADODataSet: TADODataSet
    Active = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=phonebook.mdb;Persi' +
      'st Security Info=False'
    CursorType = ctStatic
    CommandText = #1040#1073#1086#1085#1077#1085#1090#1099
    CommandType = cmdTable
    Parameters = <>
    Left = 8
    Top = 8
  end
  object DataSource: TDataSource
    DataSet = ADODataSet
    Left = 40
    Top = 8
  end
end
