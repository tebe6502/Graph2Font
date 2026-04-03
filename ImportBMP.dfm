object FImportBMP: TFImportBMP
  Tag = 25
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Import Bitmap'
  ClientHeight = 86
  ClientWidth = 1090
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
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1092
    Height = 89
    ParentBackground = False
    TabOrder = 0
    object Image5: TImage
      Left = 2
      Top = 4
      Width = 1088
      Height = 20
      OnClick = Image5Click
      OnMouseDown = Image5MouseDown
      OnMouseMove = Image5MouseMove
    end
    object SmartColors: TCheckBox
      Left = 108
      Top = 60
      Width = 83
      Height = 17
      Caption = 'Smart Colors'
      TabOrder = 0
      OnClick = SmartColorsClick
    end
    object CountColors: TCheckBox
      Left = 208
      Top = 60
      Width = 77
      Height = 17
      Caption = 'Sort Colors'
      TabOrder = 1
      OnClick = AutoresizeBMP1Click
    end
    object FifthColors: TCheckBox
      Left = 8
      Top = 60
      Width = 68
      Height = 17
      Caption = '5th colors'
      TabOrder = 2
      OnClick = FifthColorsClick
    end
    object AutoresizeBMP1: TCheckBox
      Left = 408
      Top = 60
      Width = 65
      Height = 17
      Caption = 'HResize'
      TabOrder = 3
      OnClick = AutoresizeBMP1Click
    end
    object Dither: TCheckBox
      Left = 508
      Top = 60
      Width = 44
      Height = 17
      Caption = 'Dither'
      TabOrder = 4
      OnClick = DitherClick
    end
    object DitherMatrix: TComboBox
      Left = 558
      Top = 57
      Width = 46
      Height = 22
      Hint = 'Bayer matrix'
      Style = csDropDownList
      Enabled = False
      ItemHeight = 14
      ItemIndex = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '4x4'
      OnChange = DitherMatrixChange
      Items.Strings = (
        '2x2'
        '4x4'
        '8x8')
    end
    object Grayscale: TCheckBox
      Left = 308
      Top = 60
      Width = 68
      Height = 17
      Caption = 'Grayscale'
      TabOrder = 6
      OnClick = AutoresizeBMP1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 72
    Top = 40
    object Selectall1: TMenuItem
      Caption = 'Select all colors'
      OnClick = Selectall1Click
    end
    object Unselectall1: TMenuItem
      Caption = 'Unselect all colors'
      OnClick = Unselectall1Click
    end
    object Invertselection1: TMenuItem
      Caption = 'Invert selection'
      OnClick = Invertselection1Click
    end
  end
end
