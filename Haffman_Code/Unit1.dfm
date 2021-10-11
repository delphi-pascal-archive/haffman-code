object Form1: TForm1
  Left = 219
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1050#1086#1076' '#1061#1072#1092#1092#1084#1072#1085#1072
  ClientHeight = 441
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Button1: TButton
    Left = 8
    Top = 328
    Width = 121
    Height = 25
    Caption = #1050#1086#1076#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object SG1: TStringGrid
    Left = 8
    Top = 8
    Width = 425
    Height = 313
    DefaultColWidth = 85
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ColWidths = (
      66
      69
      69
      64
      121)
  end
  object Button2: TButton
    Left = 8
    Top = 368
    Width = 121
    Height = 25
    Caption = #1044#1077#1082#1086#1076#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object StringGrid1: TStringGrid
    Left = 136
    Top = 328
    Width = 297
    Height = 105
    ColCount = 2
    DefaultColWidth = 60
    DefaultRowHeight = 17
    FixedRows = 0
    TabOrder = 3
    ColWidths = (
      60
      204)
    RowHeights = (
      18
      20
      20
      19
      19)
  end
  object Button3: TButton
    Left = 8
    Top = 408
    Width = 121
    Height = 25
    Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    TabOrder = 4
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt|'#1050#1086#1076#1080#1088#1086#1074#1072#1085#1099#1077' '#1092#1072#1081#1083#1099'|*.asd|'#1044#1088#1091#1075#1080#1077' '#1092#1072#1081#1083#1099'|*.*'
    Left = 232
    Top = 360
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt|'#1055#1088#1086#1095#1077#1077'|*.*'
    Left = 268
    Top = 360
  end
end
