object Brows_Sect_Form: TBrows_Sect_Form
  Left = 344
  Top = 171
  Width = 870
  Height = 640
  Caption = 'Browse by Sector'
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
  object Splitter1: TSplitter
    Left = 580
    Top = 0
    Height = 601
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 580
    Height = 601
    Align = alLeft
    TabOrder = 0
    object DrawGrid1: TDrawGrid
      Left = 1
      Top = 1
      Width = 578
      Height = 599
      Align = alClient
      DefaultColWidth = 24
      DefaultRowHeight = 16
      TabOrder = 0
      OnDrawCell = DrawGrid1DrawCell
      OnSelectCell = DrawGrid1SelectCell
    end
  end
  object Panel2: TPanel
    Left = 583
    Top = 0
    Width = 271
    Height = 601
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 3
      Height = 13
    end
    object Panel3: TPanel
      Left = 1
      Top = 559
      Width = 269
      Height = 41
      Align = alBottom
      TabOrder = 0
      object SpinEdit1: TSpinEdit
        Left = 8
        Top = 9
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = SpinEdit1Change
      end
      object Button1: TButton
        Left = 136
        Top = 8
        Width = 121
        Height = 25
        Caption = 'View Sector'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 528
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074' HEX'
      Items.Strings = (
        #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074' HEX'
        #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1082#1072#1082' '#1089#1080#1084#1074#1086#1083#1099
        #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1082#1072#1082' UNICODE')
    end
  end
end
