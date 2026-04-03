object FPaletteOptions: TFPaletteOptions
  Tag = 3
  Left = 40
  Top = 129
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Palette Options'
  ClientHeight = 264
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 121
    Height = 161
    Caption = 'Adjustment'
    TabOrder = 0
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 164
    Width = 299
    Height = 73
    Caption = 'External palette'
    TabOrder = 1
    object UseExternal: TCheckBox
      Left = 8
      Top = 48
      Width = 121
      Height = 17
      Caption = 'Use external palette'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = UseExternalClick
    end
    object Button3: TButton
      Left = 8
      Top = 18
      Width = 57
      Height = 24
      Caption = 'Browse'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Edit5: TEdit
      Left = 72
      Top = 20
      Width = 217
      Height = 22
      TabOrder = 2
      OnContextPopup = Edit5ContextPopup
    end
  end
  object Button1: TButton
    Left = 138
    Top = 240
    Width = 74
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 223
    Top = 240
    Width = 74
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 127
    Top = 6
    Width = 172
    Height = 155
    BevelOuter = bvLowered
    BevelWidth = 2
    ParentBackground = False
    TabOrder = 4
    object Image1: TImage
      Left = 6
      Top = 6
      Width = 160
      Height = 144
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Atari palette files (*.act)|*.act'
    Left = 70
    Top = 228
  end
end
