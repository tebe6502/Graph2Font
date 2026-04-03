object FEditColorsMap: TFEditColorsMap
  Tag = 18
  Left = 0
  Top = 0
  Hint = '$D016'
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Edit Colors Map'
  ClientHeight = 191
  ClientWidth = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 4
    Top = 196
    Width = 180
    Height = 62
  end
  object Bevel1: TBevel
    Left = 71
    Top = 8
    Width = 112
    Height = 57
  end
  object Label1: TLabel
    Left = 80
    Top = 17
    Width = 47
    Height = 14
    Caption = 'Cell Width'
  end
  object Label2: TLabel
    Left = 80
    Top = 43
    Width = 50
    Height = 14
    Caption = 'Cell Height'
  end
  object Bevel3: TBevel
    Left = 71
    Top = 71
    Width = 112
    Height = 120
  end
  object Shape1: TShape
    Left = 12
    Top = 80
    Width = 29
    Height = 29
    Brush.Style = bsClear
    Enabled = False
  end
  object RadioGroup1: TRadioGroup
    Left = 2
    Top = 2
    Width = 63
    Height = 63
    BiDiMode = bdLeftToRight
    Caption = 'Cell'
    ItemIndex = 1
    Items.Strings = (
      'New'
      'Edit')
    ParentBiDiMode = False
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object Edit1: TEdit
    Left = 140
    Top = 13
    Width = 24
    Height = 22
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object Edit2: TEdit
    Left = 140
    Top = 39
    Width = 24
    Height = 22
    ReadOnly = True
    TabOrder = 2
    Text = '3'
  end
  object UpDown1: TUpDown
    Left = 164
    Top = 13
    Width = 15
    Height = 22
    Associate = Edit1
    Max = 2
    TabOrder = 3
    OnClick = UpDown1Click
  end
  object UpDown2: TUpDown
    Left = 164
    Top = 39
    Width = 15
    Height = 22
    Associate = Edit2
    Max = 5
    Position = 3
    TabOrder = 4
    OnClick = UpDown2Click
  end
  object Edit3: TEdit
    Left = 140
    Top = 13
    Width = 24
    Height = 22
    Color = clMoneyGreen
    ReadOnly = True
    TabOrder = 5
  end
  object Edit4: TEdit
    Left = 140
    Top = 39
    Width = 24
    Height = 22
    Color = clMoneyGreen
    ReadOnly = True
    TabOrder = 6
  end
  object CheckBox1: TCheckBox
    Left = 88
    Top = 96
    Width = 40
    Height = 17
    Caption = 'RES'
    TabOrder = 7
  end
  object ComboBox1: TComboBox
    Left = 82
    Top = 76
    Width = 96
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 8
    Text = 'PS -> P0'
    Items.Strings = (
      'PS -> P0'
      'PS -> P1'
      'PS -> P2'
      'PS -> P3')
  end
  object ComboBox2: TComboBox
    Left = 82
    Top = 113
    Width = 96
    Height = 22
    Hint = 'OVERLAY Palette'
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Text = 'OV Palette #0'
    Items.Strings = (
      'OV Palette #0'
      'OV Palette #1'
      'OV Palette #2'
      'OV Palette #3')
  end
  object ComboBox3: TComboBox
    Left = 82
    Top = 136
    Width = 96
    Height = 22
    Hint = 'ANTIC/GTIA Palette'
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Text = 'PF Palette #0'
    Items.Strings = (
      'PF Palette #0'
      'PF Palette #1'
      'PF Palette #2'
      'PF Palette #3')
  end
  object Button1: TButton
    Left = 32
    Top = 202
    Width = 125
    Height = 25
    Caption = 'Change Bitmap Colors'
    TabOrder = 11
    OnClick = Button1Click
  end
  object ComboBox4: TComboBox
    Left = 12
    Top = 232
    Width = 75
    Height = 22
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 12
    Text = 'Color 0'
    Items.Strings = (
      'Color 0'
      'Color 1'
      'Color 2')
  end
  object ComboBox5: TComboBox
    Left = 104
    Top = 232
    Width = 75
    Height = 22
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 13
    Text = 'Color 0'
    Items.Strings = (
      'Color 0'
      'Color 1'
      'Color 2')
  end
  object CheckBox2: TCheckBox
    Left = 134
    Top = 96
    Width = 48
    Height = 17
    Caption = 'CATT'
    TabOrder = 14
  end
  object Button2: TButton
    Left = 89
    Top = 161
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 15
    OnClick = Button2Click
  end
end
