object FLoadPMGfile: TFLoadPMGfile
  Tag = 17
  Left = 154
  Top = 131
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Load *.PMG file'
  ClientHeight = 125
  ClientWidth = 145
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBox1: TCheckBox
    Left = 8
    Top = 0
    Width = 64
    Height = 17
    Caption = 'All'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 20
    Width = 145
    Height = 105
    TabOrder = 1
  end
end
