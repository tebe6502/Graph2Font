object FSelectColor: TFSelectColor
  Tag = 4
  Left = 61
  Top = 369
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Select Color'
  ClientHeight = 280
  ClientWidth = 178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlue
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnMouseEnter = FormMouseEnter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 10
    Top = 16
    Width = 129
    Height = 241
    ParentShowHint = False
    ShowHint = True
    OnClick = Image1Click
    OnMouseMove = Image1MouseMove
  end
  object Image2: TImage
    Left = 144
    Top = 17
    Width = 32
    Height = 238
    Enabled = False
  end
  object Image3: TImage
    Left = 0
    Top = 16
    Width = 8
    Height = 240
    Enabled = False
    Stretch = True
  end
  object Image4: TImage
    Left = 14
    Top = 0
    Width = 128
    Height = 15
    Enabled = False
    Stretch = True
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 261
    Width = 178
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Panels = <
      item
        Alignment = taCenter
        Width = 128
      end>
    UseSystemFont = False
  end
end
