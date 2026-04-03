object FSelectFolder: TFSelectFolder
  Tag = 15
  Left = 232
  Top = 112
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Select Folder'
  ClientHeight = 377
  ClientWidth = 374
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 240
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnKeyPress = FormKeyPress
  DesignSize = (
    374
    377)
  PixelsPerInch = 96
  TextHeight = 14
  object Button1: TButton
    Left = 74
    Top = 352
    Width = 226
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 0
    Top = 23
    Width = 374
    Height = 324
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 1
    OnChange = DirectoryListBox1Change
  end
  object DriveComboBox1: TDriveComboBox
    Left = 0
    Top = 0
    Width = 372
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    OnChange = DriveComboBox1Change
  end
end
