object FMove: TFMove
  Tag = 7
  Left = 84
  Top = 122
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Move, Copy, Paste'
  ClientHeight = 174
  ClientWidth = 196
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
  object Panel1: TPanel
    Left = 2
    Top = 0
    Width = 193
    Height = 60
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnMouseEnter = Panel1MouseEnter
    object MoveX: TButton
      Left = 4
      Top = 33
      Width = 49
      Height = 25
      Caption = 'Move X'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = MoveXClick
    end
    object MoveY: TButton
      Left = 68
      Top = 33
      Width = 49
      Height = 25
      Caption = 'Move Y'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = MoveYClick
    end
    object MovePMG: TCheckBox
      Left = 134
      Top = 5
      Width = 52
      Height = 17
      Hint = 'Players & Missiles Graphics'
      Caption = 'PMG'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 2
    end
    object MoveBitmap: TCheckBox
      Left = 134
      Top = 23
      Width = 52
      Height = 17
      Hint = 'Bitmap'
      Caption = 'Bitmap'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 3
    end
    object MoveColors: TCheckBox
      Left = 134
      Top = 41
      Width = 52
      Height = 17
      Hint = 'Colors & Rasters'
      Caption = 'Colors'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
    object seMoveX: TBMDSpinEdit
      Left = 4
      Top = 2
      Width = 49
      Height = 29
      Cursor = crArrow
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '0'
      OnChange = seMoveXChange
      OnContextPopup = seMoveXContextPopup
      Increment = 1.000000000000000000
      MaxValue = 64.000000000000000000
      MinValue = -64.000000000000000000
      Position = 0
      Precision = 0
      UpDownOrientation = udHorizontal
      TrackBarEnabled = False
    end
    object seMoveY: TBMDSpinEdit
      Left = 68
      Top = 2
      Width = 49
      Height = 29
      Cursor = crArrow
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpLeft
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = '0'
      OnChange = seMoveYChange
      OnContextPopup = seMoveXContextPopup
      Increment = 1.000000000000000000
      MaxValue = 239.000000000000000000
      MinValue = -239.000000000000000000
      Position = 0
      Precision = 0
      TrackBarEnabled = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 60
    Width = 196
    Height = 114
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    OnMouseEnter = Panel2MouseEnter
    object Bevel4: TBevel
      Left = 102
      Top = 4
      Width = 93
      Height = 70
      Shape = bsFrame
    end
    object Bevel3: TBevel
      Left = 2
      Top = 4
      Width = 98
      Height = 70
      Shape = bsFrame
    end
    object Bevel5: TBevel
      Left = 2
      Top = 76
      Width = 193
      Height = 37
      Shape = bsFrame
    end
    object bCopy: TBitBtn
      Left = 107
      Top = 10
      Width = 82
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Copy'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = bCopyClick
    end
    inline frameLineRange1: TframeLineRange
      Left = 5
      Top = 8
      Width = 92
      Height = 63
      AutoSize = True
      TabOrder = 1
      ExplicitLeft = 5
      ExplicitTop = 8
      inherited Panel1: TPanel
        inherited bGet: TButton
          Visible = False
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
    object udLeft: TBMDSpinEdit
      Left = 28
      Top = 80
      Width = 48
      Height = 29
      Cursor = crArrow
      Color = clMoneyGreen
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '0'
      OnChange = udLeftChange
      OnContextPopup = seMoveXContextPopup
      Increment = 1.000000000000000000
      MaxValue = 47.000000000000000000
      Position = 0
      Precision = 0
      UpDownOrientation = udHorizontal
      TrackBarEnabled = False
    end
    object udRight: TBMDSpinEdit
      Left = 120
      Top = 80
      Width = 48
      Height = 29
      Cursor = crArrow
      Color = clMoneyGreen
      EditLabel.Width = 3
      EditLabel.Height = 14
      EditLabel.Caption = ' '
      LabelPosition = lpLeft
      TabOrder = 3
      Text = '48'
      OnChange = udRightChange
      OnContextPopup = seMoveXContextPopup
      Increment = 1.000000000000000000
      MaxValue = 48.000000000000000000
      MinValue = 1.000000000000000000
      Value = 48.000000000000000000
      Position = 48
      Precision = 0
      UpDownOrientation = udHorizontal
      TrackBarEnabled = False
    end
    inline bPaste: TButtonMenu
      Left = 107
      Top = 41
      Width = 82
      Height = 25
      PopupMenu = PopupMenu1
      TabOrder = 4
      ExplicitLeft = 107
      ExplicitTop = 41
      ExplicitWidth = 82
      ExplicitHeight = 25
      inherited MenuButton: TBitBtn
        Left = 68
        Height = 25
        Enabled = False
        OnClick = bPasteMenuButtonClick
        ExplicitLeft = 68
        ExplicitHeight = 25
      end
      inherited MainButton: TBitBtn
        Width = 68
        Height = 25
        Enabled = False
        OnClick = BitBtn1Click
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 68
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Images = Form1.ImageList2
    Left = 80
    Top = 136
    object Paste1: TMenuItem
      Caption = 'Paste'
      ImageIndex = 0
      OnClick = Paste1Click
    end
    object Flip1: TMenuItem
      Caption = 'Flip'
      ImageIndex = 0
      OnClick = Paste1Click
    end
    object Mirror1: TMenuItem
      Caption = 'Mirror'
      ImageIndex = 0
      OnClick = Paste1Click
    end
    object Merge1: TMenuItem
      Caption = 'Merge'
      ImageIndex = 0
      OnClick = Paste1Click
    end
  end
end
