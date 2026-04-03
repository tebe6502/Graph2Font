object FEditPMG: TFEditPMG
  Tag = 8
  Left = 37
  Top = 154
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  BorderWidth = 4
  ClientHeight = 421
  ClientWidth = 236
  Color = clBtnFace
  DoubleBuffered = True
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
  object Bevel3: TBevel
    Left = 2
    Top = 331
    Width = 232
    Height = 49
    Shape = bsFrame
  end
  object Bevel1: TBevel
    Left = 2
    Top = 228
    Width = 232
    Height = 74
    Shape = bsFrame
  end
  object Label10: TLabel
    Left = 164
    Top = 9
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'P l a y e r  0'
    Transparent = False
  end
  object Label1: TLabel
    Left = 164
    Top = 38
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'M i s s i l e  0'
    Transparent = False
  end
  object Label20: TLabel
    Left = 152
    Top = 22
    Width = 3
    Height = 14
    Transparent = False
  end
  object Label11: TLabel
    Left = 164
    Top = 65
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'P l a y e r  1'
    Color = clBtnFace
    ParentColor = False
    Transparent = False
  end
  object Label15: TLabel
    Left = 164
    Top = 94
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'M i s s i l e  1'
    Transparent = False
  end
  object Label22: TLabel
    Left = 152
    Top = 78
    Width = 3
    Height = 14
    Transparent = False
  end
  object Label36: TLabel
    Left = 164
    Top = 121
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'P l a y e r  2'
    Transparent = False
  end
  object Label38: TLabel
    Left = 164
    Top = 150
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'M i s s i l e  2'
    Transparent = False
  end
  object Label40: TLabel
    Left = 152
    Top = 134
    Width = 3
    Height = 14
    Transparent = False
  end
  object Label53: TLabel
    Left = 164
    Top = 177
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'P l a y e r  3'
    Transparent = False
  end
  object Label55: TLabel
    Left = 164
    Top = 206
    Width = 62
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'M i s s i l e  3'
    Transparent = False
  end
  object Label57: TLabel
    Left = 152
    Top = 190
    Width = 3
    Height = 14
    Transparent = False
  end
  object P: TLabel
    Left = 56
    Top = 342
    Width = 46
    Height = 14
    Caption = 'PRIORITY'
    Transparent = False
  end
  object lPriority: TLabel
    Left = 6
    Top = 362
    Width = 225
    Height = 13
    Hint = 'PM = Player and Missile, PF = Playfield, P4 = all Missiles'
    Alignment = taCenter
    AutoSize = False
    Caption = 'P4-PF0-PF1-PF2-PF3-PM0-PM1-PM2-PM3-BAK'
    ParentShowHint = False
    ShowHint = True
    Transparent = False
  end
  object lPrior: TLabel
    Left = 116
    Top = 342
    Width = 6
    Height = 14
    Caption = '4'
    Transparent = False
  end
  object PM0: TLabel
    Left = 164
    Top = 24
    Width = 62
    Height = 15
    Hint = '$D012 (704)'
    Alignment = taCenter
    AutoSize = False
    Caption = 'COLPM0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object PM1: TLabel
    Left = 164
    Top = 80
    Width = 62
    Height = 15
    Hint = '$D013 (705)'
    Alignment = taCenter
    AutoSize = False
    Caption = 'COLPM1'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = False
  end
  object PM2: TLabel
    Left = 164
    Top = 136
    Width = 62
    Height = 15
    Hint = '$D014 (706)'
    Alignment = taCenter
    AutoSize = False
    Caption = 'COLPM2'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = False
  end
  object PM3: TLabel
    Left = 164
    Top = 192
    Width = 62
    Height = 15
    Hint = '$D015 (707)'
    Alignment = taCenter
    AutoSize = False
    Caption = 'COLPM3'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = False
  end
  object Bevel4: TBevel
    Left = 136
    Top = 306
    Width = 97
    Height = 21
    Hint = 'Color form PF3'
    ParentShowHint = False
    Shape = bsFrame
    ShowHint = True
  end
  object Bevel5: TBevel
    Left = 2
    Top = 306
    Width = 130
    Height = 21
    Hint = 'Color form PF3'
    ParentShowHint = False
    Shape = bsFrame
    ShowHint = True
  end
  object Bevel2: TBevel
    Left = 2
    Top = 384
    Width = 232
    Height = 36
  end
  object Button6: TButton
    Tag = 1
    Left = 170
    Top = 236
    Width = 60
    Height = 25
    Hint = 'Align PMG to right edge'
    Caption = 'Right Edge'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = Button6Click
  end
  object Button7: TButton
    Tag = -1
    Left = 170
    Top = 270
    Width = 60
    Height = 25
    Hint = 'Align PMG to left edge'
    Caption = 'Left Edge'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = Button6Click
  end
  object udPrior: TUpDown
    Left = 142
    Top = 338
    Width = 25
    Height = 20
    Min = -3
    Max = 1
    Orientation = udHorizontal
    TabOrder = 0
    OnChangingEx = udPriorChangingEx
  end
  object chbPlayer5: TCheckBox
    Left = 152
    Top = 308
    Width = 73
    Height = 17
    Hint = '5-th Player (Color Missiles = Color Players)'
    Caption = ' Player 4'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = chbPlayer5Click
  end
  object chbMLC: TCheckBox
    Left = 18
    Top = 308
    Width = 107
    Height = 17
    Hint = 'Multicolor Players and Missiles'
    Caption = ' Multicolor PM'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = chbMLCClick
  end
  object Panel5: TPanel
    Left = 36
    Top = 4
    Width = 120
    Height = 218
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 152
    Top = 270
    Width = 16
    Height = 25
    Glyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 7
  end
  inline frameLineRange1: TframeLineRange
    Left = 6
    Top = 234
    Width = 92
    Height = 63
    AutoSize = True
    TabOrder = 8
    ExplicitLeft = 6
    ExplicitTop = 234
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
        OnChange = frameLineRange1seRangeChange
        ExplicitHeight = 29
      end
    end
  end
  inline frameAddSkip1: TframeAddSkip
    Left = 28
    Top = 388
    Width = 171
    Height = 30
    TabOrder = 9
    ExplicitLeft = 28
    ExplicitTop = 388
    inherited seAdd: TBMDSpinEdit
      Height = 29
      EditLabel.Height = 14
      EditLabel.ExplicitLeft = 6
      EditLabel.ExplicitTop = 7
      EditLabel.ExplicitWidth = 23
      EditLabel.ExplicitHeight = 14
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
  inline FillPMGColors: TButtonMenu
    Left = 100
    Top = 236
    Width = 68
    Height = 25
    PopupMenu = PopupMenu2
    TabOrder = 10
    ExplicitLeft = 100
    ExplicitTop = 236
    ExplicitWidth = 68
    ExplicitHeight = 25
    inherited MenuButton: TBitBtn
      Left = 54
      Height = 25
      OnClick = FillPMGColorsMenuButtonClick
      ExplicitLeft = 54
      ExplicitHeight = 25
    end
    inherited MainButton: TBitBtn
      Width = 54
      Height = 25
      Caption = 'FILL'
      OnClick = FillPMGColorsClick
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 54
    end
  end
  inline Apply: TButtonMenu
    Left = 100
    Top = 270
    Width = 68
    Height = 25
    PopupMenu = PopupMenu1
    TabOrder = 11
    ExplicitLeft = 100
    ExplicitTop = 270
    ExplicitWidth = 68
    ExplicitHeight = 25
    inherited MenuButton: TBitBtn
      Left = 54
      Height = 25
      OnClick = ApplyMenuButtonClick
      ExplicitLeft = 54
      ExplicitHeight = 25
    end
    inherited MainButton: TBitBtn
      Width = 54
      Height = 25
      Caption = 'APPLY'
      OnClick = ApplyClick
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 54
    end
  end
  object Panel6: TPanel
    Left = 100
    Top = 236
    Width = 130
    Height = 59
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object Button5: TButton
      Left = 26
      Top = 16
      Width = 75
      Height = 25
      Caption = 'CHANGE'
      TabOrder = 0
      OnClick = Button5Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 128
    object pmgCHANGE: TMenuItem
      Break = mbBreak
      Caption = 'CHANGE'
      Checked = True
      OnClick = pmgCHANGEClick
    end
    object pmgCLEAR: TMenuItem
      Tag = 1
      Caption = 'CLEAR'
      OnClick = pmgCHANGEClick
    end
    object pmgFILL: TMenuItem
      Tag = 2
      Caption = 'FILL'
      OnClick = pmgCHANGEClick
    end
    object pmgDELETE: TMenuItem
      Tag = 3
      Caption = 'DELETE'
      OnClick = pmgCHANGEClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmgEDIT: TMenuItem
      Tag = 4
      Caption = 'EDIT'
      Enabled = False
      OnClick = pmgCHANGEClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 8
    Top = 80
    object fColor: TMenuItem
      AutoCheck = True
      Caption = 'Color'
      Checked = True
      OnClick = fColorClick
    end
    object fSaturation: TMenuItem
      AutoCheck = True
      Caption = 'Saturation'
      Checked = True
      OnClick = fColorClick
    end
  end
end
