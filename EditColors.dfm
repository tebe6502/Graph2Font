object FEditColors: TFEditColors
  Tag = 5
  Left = 74
  Top = 127
  BorderStyle = bsToolWindow
  BorderWidth = 4
  ClientHeight = 464
  ClientWidth = 176
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
  OnMouseEnter = FormMouseEnter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 2
    Top = 15
    Width = 29
    Height = 30
    Brush.Style = bsClear
    Enabled = False
  end
  object Panel1: TPanel
    Left = 32
    Top = 8
    Width = 142
    Height = 520
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 2
    Top = 294
    Width = 172
    Height = 131
    Align = alCustom
    TabOrder = 1
    object Bevel2: TBevel
      Left = 0
      Top = 77
      Width = 172
      Height = 34
    end
    inline frameLineRange1: TframeLineRange
      Left = 4
      Top = 5
      Width = 92
      Height = 63
      AutoSize = True
      TabOrder = 1
      ExplicitLeft = 4
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
    inline frameAddSkip1: TframeAddSkip
      Left = 2
      Top = 80
      Width = 169
      Height = 30
      TabOrder = 2
      ExplicitLeft = 2
      ExplicitTop = 80
      ExplicitWidth = 169
      inherited seAdd: TBMDSpinEdit
        Left = 30
        Height = 29
        EditLabel.Height = 14
        EditLabel.ExplicitLeft = 4
        EditLabel.ExplicitTop = 7
        EditLabel.ExplicitWidth = 23
        EditLabel.ExplicitHeight = 14
        ExplicitLeft = 30
        ExplicitHeight = 29
      end
      inherited seSkip: TBMDSpinEdit
        Height = 29
        EditLabel.Height = 14
        EditLabel.ExplicitLeft = 92
        EditLabel.ExplicitTop = 7
        EditLabel.ExplicitWidth = 23
        EditLabel.ExplicitHeight = 14
        ExplicitHeight = 29
      end
    end
    inline bFill: TButtonMenu
      Left = 100
      Top = 24
      Width = 64
      Height = 25
      PopupMenu = PopupMenu1
      TabOrder = 3
      OnClick = bFillClick
      ExplicitLeft = 100
      ExplicitTop = 24
      ExplicitWidth = 64
      ExplicitHeight = 25
      inherited MenuButton: TBitBtn
        Left = 50
        Height = 25
        OnClick = bFillMenuButtonClick
        ExplicitLeft = 50
        ExplicitHeight = 25
      end
      inherited MainButton: TBitBtn
        Width = 50
        Height = 25
        Caption = 'FILL'
        OnClick = bFillClick
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 50
      end
    end
    object bChange: TButton
      Left = 100
      Top = 24
      Width = 64
      Height = 25
      Hint = 'Apply changes'
      Caption = 'CHANGE'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bChangeClick
    end
  end
  object PopupMenu1: TPopupMenu
    Top = 96
    object fColor: TMenuItem
      AutoCheck = True
      Caption = 'Color'
      Checked = True
    end
    object fSaturation: TMenuItem
      AutoCheck = True
      Caption = 'Saturation'
      Checked = True
    end
    object fLock: TMenuItem
      AutoCheck = True
      Caption = 'Lock'
    end
  end
end
