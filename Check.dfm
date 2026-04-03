object FCheck: TFCheck
  Tag = 11
  Left = 79
  Top = 131
  HorzScrollBar.Visible = False
  AutoSize = True
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Check'
  ClientHeight = 514
  ClientWidth = 184
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
  object Bevel1: TBevel
    Left = 0
    Top = 320
    Width = 184
    Height = 26
  end
  object lWarnings: TLabel
    Left = 6
    Top = 326
    Width = 49
    Height = 14
    Caption = 'Warnings:'
  end
  object lErrors: TLabel
    Left = 79
    Top = 326
    Width = 33
    Height = 14
    Caption = 'Errors:'
  end
  object lLimit: TLabel
    Left = 134
    Top = 326
    Width = 24
    Height = 14
    Cursor = crHandPoint
    Caption = 'Limit:'
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 184
    Height = 315
    Columns = <
      item
        Caption = 'Line'
        MinWidth = 40
        Width = 40
      end
      item
        Alignment = taCenter
        Caption = 'Chng'
        MinWidth = 40
        Width = 40
      end
      item
        Alignment = taCenter
        Caption = 'Status'
        MinWidth = 80
        Width = 80
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = ListView1Click
    OnCustomDrawItem = ListView1CustomDrawItem
    OnMouseMove = ListView1MouseMove
  end
  object ListBox1: TListBox
    Left = 0
    Top = 350
    Width = 184
    Height = 164
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 15
    ParentFont = False
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 8
    Top = 24
    object Repair1: TMenuItem
      Caption = 'Optymize PMG'
      OnClick = Repair1Click
    end
    object Repair2: TMenuItem
      Caption = 'Optymize BMP'
      OnClick = Repair2Click
    end
  end
end
