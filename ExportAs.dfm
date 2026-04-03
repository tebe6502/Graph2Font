object FExportAs: TFExportAs
  Tag = 14
  Left = 219
  Top = 384
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsToolWindow
  BorderWidth = 2
  ClientHeight = 329
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 2
    Top = 260
    Width = 222
    Height = 32
  end
  object Bevel1: TBevel
    Left = 228
    Top = 260
    Width = 392
    Height = 32
  end
  object ScrollBox2: TScrollBox
    Left = 228
    Top = 0
    Width = 392
    Height = 254
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object Image2: TImage
      Left = 0
      Top = 0
      Width = 32
      Height = 32
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 222
    Height = 254
    Color = clBtnFace
    ColCount = 8
    DefaultColWidth = 14
    DefaultRowHeight = 14
    FixedColor = clSkyBlue
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    GridLineWidth = 2
    Options = [goVertLine, goHorzLine]
    ParentFont = False
    TabOrder = 1
    OnClick = StringGrid1Click
    OnMouseDown = StringGrid1MouseDown
    OnSelectCell = StringGrid1SelectCell
  end
  object Button4: TButton
    Left = 2
    Top = 297
    Width = 619
    Height = 32
    Hint = '0 charsets'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = Button4Click
  end
  object seWidth: TBMDSpinEdit
    Left = 49
    Top = 262
    Width = 50
    Height = 29
    Cursor = crArrow
    EditLabel.Width = 33
    EditLabel.Height = 14
    EditLabel.Caption = 'Width: '
    LabelPosition = lpLeft
    TabOrder = 4
    Text = '128'
    OnChange = seWidthChange
    OnContextPopup = seWidthContextPopup
    Increment = 1.000000000000000000
    MaxValue = 128.000000000000000000
    MinValue = 1.000000000000000000
    Value = 128.000000000000000000
    Position = 128
    Precision = 0
    TrackBarEnabled = False
  end
  object seHeight: TBMDSpinEdit
    Left = 156
    Top = 262
    Width = 50
    Height = 29
    Cursor = crArrow
    EditLabel.Width = 36
    EditLabel.Height = 14
    EditLabel.Caption = 'Height: '
    LabelPosition = lpLeft
    TabOrder = 5
    Text = '256'
    OnChange = seHeightChange
    OnContextPopup = seWidthContextPopup
    Increment = 1.000000000000000000
    MaxValue = 256.000000000000000000
    MinValue = 1.000000000000000000
    Value = 256.000000000000000000
    Position = 256
    Precision = 0
    TrackBarEnabled = False
  end
  object seFirst: TBMDSpinEdit
    Left = 388
    Top = 262
    Width = 50
    Height = 29
    Cursor = crArrow
    EditLabel.Width = 113
    EditLabel.Height = 14
    EditLabel.Caption = 'Copy screen from row '
    LabelPosition = lpLeft
    TabOrder = 6
    Text = '0'
    OnChange = seFirstChange
    OnContextPopup = seWidthContextPopup
    Increment = 1.000000000000000000
    MaxValue = 30.000000000000000000
    Position = 0
    Precision = 0
    TrackBarEnabled = False
  end
  object seLast: TBMDSpinEdit
    Left = 490
    Top = 262
    Width = 50
    Height = 29
    Cursor = crArrow
    EditLabel.Width = 38
    EditLabel.Height = 14
    EditLabel.Caption = 'to row  '
    LabelPosition = lpLeft
    TabOrder = 7
    Text = '30'
    OnChange = seLastChange
    OnContextPopup = seWidthContextPopup
    Increment = 1.000000000000000000
    MaxValue = 30.000000000000000000
    MinValue = 1.000000000000000000
    Value = 30.000000000000000000
    Position = 30
    Precision = 0
    TrackBarEnabled = False
  end
  object ProgressBar1: TProgressBar
    Left = 230
    Top = 262
    Width = 388
    Height = 28
    Step = 1
    TabOrder = 3
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 32
    object New1: TMenuItem
      Caption = 'File'
      object New3: TMenuItem
        Caption = 'New'
        ShortCut = 16462
        OnClick = New3Click
      end
      object New2: TMenuItem
        Caption = 'Open Map'
        ShortCut = 16463
        OnClick = New2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SaveProject1: TMenuItem
        Caption = 'Save Map'
        ShortCut = 16467
        OnClick = SaveProject1Click
      end
    end
    object Export1: TMenuItem
      Caption = 'Export'
      object anm1: TMenuItem
        Caption = 'as animation'
        Checked = True
        OnClick = anm1Click
      end
      object ashscroll1: TMenuItem
        Caption = 'as hscroll'
        Enabled = False
      end
      object scr1: TMenuItem
        Caption = 'as vscroll'
        OnClick = scr1Click
      end
      object sld1: TMenuItem
        Caption = 'as slideshow'
        OnClick = sld1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Charsfill1: TMenuItem
        Caption = 'Chars fill'
        ShortCut = 16454
        OnClick = Charsfill1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'MAP (*.map)|*.map|All files (*.*)|*.*'
    Left = 56
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Filter = 'MAP (*.map)|*.map|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 96
    Top = 32
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 112
    object Edit5: TMenuItem
      Caption = 'Edit screen'
      OnClick = Edit5Click
    end
    object Insert1: TMenuItem
      Caption = 'Insert edit screen'
      OnClick = Insert1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Load1: TMenuItem
      Caption = 'Load screens'
      OnClick = Load1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Remove1: TMenuItem
      Caption = 'Remove screen'
      OnClick = Remove1Click
    end
  end
end
