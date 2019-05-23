object Form1: TForm1
  Left = 275
  Top = 263
  Width = 870
  Height = 638
  Caption = #1055#1086#1080#1089#1082' '#1082#1086#1087#1080#1080' '#1079#1072#1075#1088#1091#1079#1086#1095#1085#1099#1093' '#1086#1073#1083#1072#1089#1090#1077#1081' '#1085#1072' '#1079#1072#1076#1072#1085#1085#1086#1084' '#1083#1086#1075#1080#1095#1077#1089#1082#1086#1084' '#1076#1080#1089#1082#1077
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
  object Label1: TLabel
    Left = 24
    Top = 312
    Width = 37
    Height = 13
    Caption = #1057#1090#1072#1090#1091#1089':'
  end
  object Label2: TLabel
    Left = 72
    Top = 312
    Width = 87
    Height = 13
    Caption = #1053#1077#1090' '#1076#1077#1089#1082#1088#1080#1087#1090#1086#1088#1072
  end
  object Label3: TLabel
    Left = 288
    Top = 464
    Width = 121
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088' '#1076#1080#1089#1082#1072' '#1074' '#1073#1072#1081#1090#1072#1093':'
  end
  object Label4: TLabel
    Left = 416
    Top = 464
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label5: TLabel
    Left = 128
    Top = 544
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label6: TLabel
    Left = 16
    Top = 544
    Width = 107
    Height = 13
    Caption = #1055#1088#1086#1095#1080#1090#1072#1085#1086' '#1089#1077#1082#1090#1086#1088#1086#1074':'
  end
  object Label7: TLabel
    Left = 248
    Top = 544
    Width = 83
    Height = 13
    Caption = #1042#1089#1077#1075#1086' '#1089#1077#1082#1090#1086#1088#1086#1074':'
  end
  object Label8: TLabel
    Left = 336
    Top = 545
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label9: TLabel
    Left = 24
    Top = 336
    Width = 189
    Height = 13
    Caption = #1057#1095#1080#1090#1072#1085#1086' '#1073#1072#1081#1090' '#1080#1079' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1089#1077#1082#1090#1086#1088#1072': 0'
  end
  object Button1: TButton
    Left = 16
    Top = 272
    Width = 97
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100' '#1087#1086#1080#1089#1082
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 240
    Width = 265
    Height = 21
    TabOrder = 1
    Text = 'C:'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 568
    Width = 777
    Height = 17
    TabOrder = 2
  end
  object Button2: TButton
    Left = 288
    Top = 272
    Width = 75
    Height = 25
    Caption = #1055#1088#1077#1082#1088#1072#1090#1080#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 400
    Top = 0
    Width = 449
    Height = 457
    TabOrder = 4
  end
  object Button3: TButton
    Left = 24
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 432
    Width = 137
    Height = 25
    Caption = 'BrowsBySector'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 320
    Top = 0
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 120
    Top = 272
    Width = 75
    Height = 25
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
    Enabled = False
    TabOrder = 8
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 200
    Top = 272
    Width = 75
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074
    Enabled = False
    TabOrder = 9
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 768
    Top = 464
    Width = 75
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 10
    OnClick = Button8Click
  end
  object SpinEdit1: TSpinEdit
    Left = 16
    Top = 48
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 11
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 72
    Top = 48
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 12
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 136
    Top = 48
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 13
    Value = 0
  end
  object OpenDialog1: TOpenDialog
    Left = 112
    Top = 168
  end
end
