object FLoadScreens: TFLoadScreens
  Tag = 21
  Left = 219
  Top = 115
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 2
  Caption = 'Load screens'
  ClientHeight = 431
  ClientWidth = 626
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
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object FileListBox1: TFileListBox
    Left = 0
    Top = 232
    Width = 287
    Height = 199
    ItemHeight = 16
    Mask = '*.g2f;*.mic;*.pic;*.mch'
    MultiSelect = True
    ShowGlyphs = True
    TabOrder = 0
    OnDblClick = Add1Click
    OnMouseDown = FileListBox1MouseDown
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 0
    Top = 0
    Width = 287
    Height = 199
    ItemHeight = 16
    TabOrder = 1
    OnChange = DirectoryListBox1Change
  end
  object ListView1: TListView
    Left = 293
    Top = 0
    Width = 333
    Height = 400
    Columns = <
      item
        MinWidth = 310
        Width = 310
      end>
    ColumnClick = False
    ReadOnly = True
    TabOrder = 2
    ViewStyle = vsReport
    OnMouseDown = ListView1MouseDown
  end
  object Button1: TButton
    Left = 293
    Top = 406
    Width = 333
    Height = 25
    Caption = 'Load files from list'
    ModalResult = 1
    TabOrder = 3
    OnClick = Button1Click
  end
  object FilterComboBox1: TFilterComboBox
    Left = 0
    Top = 205
    Width = 287
    Height = 22
    FileList = FileListBox1
    Filter = 
      'All files (*.g2f;*.mic;*.pic;*.mch)|*.g2f;*.mic;*.pic;*.mch|G2F ' +
      '(*.g2f)|*.g2f|Micropainter (*.mic)|*.mic|Koala Microilustrator (' +
      '*.pic)|*.pic|MCH (*.mch)|*.mch'
    TabOrder = 4
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 256
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = Add1Click
    end
    object Addall1: TMenuItem
      Caption = 'Add all'
      OnClick = Addall1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 400
    Top = 128
    object Moveup1: TMenuItem
      Caption = 'Move up'
      OnClick = Moveup1Click
    end
    object Movedown1: TMenuItem
      Caption = 'Move down'
      OnClick = Movedown1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Moveatfirstposition1: TMenuItem
      Caption = 'Move at first position'
      OnClick = Moveatfirstposition1Click
    end
    object Moveatlastposition1: TMenuItem
      Caption = 'Move at last position'
      OnClick = Moveatlastposition1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Removefromlist1: TMenuItem
      Caption = 'Remove from list'
      OnClick = Removefromlist1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Clearalllist1: TMenuItem
      Caption = 'Clear list'
      OnClick = Clearalllist1Click
    end
  end
end
