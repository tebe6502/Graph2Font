object FCharsFill: TFCharsFill
  Tag = 10
  Left = 250
  Top = 100
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Chars fill'
  ClientHeight = 433
  ClientWidth = 121
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 121
    Height = 433
    HorzScrollBar.Visible = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 0
      Top = 3
      Width = 99
      Height = 422
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      OnContextPopup = Memo1ContextPopup
    end
  end
end
