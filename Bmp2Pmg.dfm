object FBmp2Pmg: TFBmp2Pmg
  Tag = 9
  Left = 70
  Top = 133
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Convert to PMG'
  ClientHeight = 256
  ClientWidth = 188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  DesignSize = (
    188
    256)
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 2
    Top = 8
    Width = 88
    Height = 248
  end
  object Image1: TImage
    Left = 6
    Top = 12
    Width = 80
    Height = 240
    Cursor = crDrag
    Stretch = True
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object RadioGroup1: TRadioGroup
    Left = 97
    Top = 3
    Width = 92
    Height = 91
    Anchors = [akTop, akRight]
    Caption = 'PMG'
    ItemIndex = 0
    Items.Strings = (
      'Mono (%01)'
      'Mono (%10)'
      'Mono (%11)'
      'Multicolor')
    ParentBackground = False
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object GroupBox1: TGroupBox
    Left = 97
    Top = 96
    Width = 92
    Height = 161
    Anchors = [akTop, akRight]
    Caption = 'Order'
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 40
      Width = 32
      Height = 112
      Alignment = taCenter
      AutoSize = False
    end
    object Label2: TLabel
      Left = 38
      Top = 40
      Width = 32
      Height = 112
      Alignment = taCenter
      AutoSize = False
    end
    object Label3: TLabel
      Left = 6
      Top = 116
      Width = 32
      Height = 28
      Alignment = taCenter
      AutoSize = False
    end
    object Label4: TLabel
      Left = 50
      Top = 116
      Width = 32
      Height = 28
      Alignment = taCenter
      AutoSize = False
    end
    object RadioButton1: TRadioButton
      Left = 14
      Top = 24
      Width = 17
      Height = 17
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 48
      Top = 24
      Width = 17
      Height = 17
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object RadioButton3: TRadioButton
      Left = 14
      Top = 100
      Width = 17
      Height = 17
      TabOrder = 2
      OnClick = RadioButton1Click
    end
    object RadioButton4: TRadioButton
      Left = 58
      Top = 100
      Width = 17
      Height = 17
      TabOrder = 3
      OnClick = RadioButton1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 
      'PMG G2F Sprites (*.pmg)|*.pmg|PMG DAT Data (*.dat)|*.dat|PMG ASM' +
      ' Listing (*.asm)|*.asm|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 48
    Top = 24
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 24
    object File1: TMenuItem
      Caption = 'File'
      object SaveAs1: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object PMG1: TMenuItem
      Caption = 'Size'
      object pmgx1: TMenuItem
        Caption = 'PMG x1'
        Checked = True
        OnClick = pmgx1Click
      end
      object pmgx2: TMenuItem
        Caption = 'PMG x2'
        OnClick = pmgx2Click
      end
      object pmgx4: TMenuItem
        Caption = 'PMG x4'
        OnClick = pmgx4Click
      end
    end
  end
end
