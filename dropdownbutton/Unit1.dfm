object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Button Menu Demo'
  ClientHeight = 135
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline ButtonMenu1: TButtonMenu
    Left = 3
    Top = 3
    Width = 81
    Height = 25
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    PopupMenu = PopupMenu1
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 81
    ExplicitHeight = 25
    inherited MainButton: TButton
      Width = 63
      Height = 23
      Caption = 'Close'
      ExplicitLeft = 1
      ExplicitWidth = 63
      ExplicitHeight = 23
    end
    inherited MenuButton: TButton
      Left = 64
      Width = 16
      Height = 23
      OnClick = ButtonMenu1MenuButtonClick
      ExplicitLeft = 64
      ExplicitWidth = 16
      ExplicitHeight = 23
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 32
    Top = 48
    object CloseItem: TMenuItem
      Caption = 'Close'
      OnClick = CloseItemClick
    end
    object CloseSaveItem: TMenuItem
      Caption = 'Close && Save'
      OnClick = CloseSaveItemClick
    end
  end
end
