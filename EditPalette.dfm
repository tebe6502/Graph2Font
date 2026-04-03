object FEditPalette: TFEditPalette
  Tag = 16
  Left = 57
  Top = 194
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Edit Palette'
  ClientHeight = 319
  ClientWidth = 178
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
  OnKeyPress = FormKeyPress
  OnMouseEnter = FormMouseEnter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 177
    Height = 241
    OnClick = Image1Click
    OnMouseMove = Image1MouseMove
  end
  object Panel1: TPanel
    Left = 0
    Top = 246
    Width = 178
    Height = 73
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 178
      Height = 73
      Shape = bsFrame
    end
    object Apply: TButton
      Left = 104
      Top = 26
      Width = 59
      Height = 25
      Caption = 'APPLY'
      TabOrder = 0
      OnClick = ApplyClick
    end
    inline frameLineRange1: TframeLineRange
      Left = 8
      Top = 5
      Width = 92
      Height = 63
      AutoSize = True
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 5
      inherited Panel1: TPanel
        inherited bGet: TButton
          OnClick = frameLineRange1bGetClick
        end
        inherited seLine: TBMDSpinEdit
          Height = 29
          EditLabel.Height = 14
          EditLabel.ExplicitLeft = 4
          EditLabel.ExplicitTop = 7
          EditLabel.ExplicitWidth = 35
          EditLabel.ExplicitHeight = 14
          OnChange = frameLineRange1seLineChange
          ExplicitHeight = 29
        end
        inherited seRange: TBMDSpinEdit
          Height = 29
          EditLabel.Width = 34
          EditLabel.Height = 14
          EditLabel.ExplicitLeft = 5
          EditLabel.ExplicitTop = 41
          EditLabel.ExplicitWidth = 34
          EditLabel.ExplicitHeight = 14
          OnChange = frameLineRange1seLineChange
          ExplicitHeight = 29
        end
      end
    end
  end
end
