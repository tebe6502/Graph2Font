object FEditRasters: TFEditRasters
  Tag = 12
  Left = 180
  Top = 538
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Edit Rasters'
  ClientHeight = 164
  ClientWidth = 1034
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 145
    Width = 1034
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 170
      end
      item
        Alignment = taCenter
        Width = 256
      end
      item
        Alignment = taCenter
        Width = 256
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1025
    Height = 145
    ActivePage = TabSheet2
    MultiLine = True
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Init'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1017
        Height = 116
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        OnClick = Panel3Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Main'
      ImageIndex = 1
      object Label24: TLabel
        Left = 531
        Top = 86
        Width = 80
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Global offset'
        Transparent = False
      end
      object Label7: TLabel
        Left = 299
        Top = 96
        Width = 44
        Height = 13
        AutoSize = False
        Caption = 'Register:'
        Transparent = False
      end
      object ScrollBox1: TScrollBox
        Left = 168
        Top = 0
        Width = 643
        Height = 116
        VertScrollBar.Visible = False
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object Panel2: TPanel
          Left = 2
          Top = 0
          Width = 659
          Height = 100
          BevelOuter = bvNone
          TabOrder = 0
          object LineOfsetLabel: TLabel
            Left = 0
            Top = 45
            Width = 54
            Height = 16
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = '$00'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = False
            OnClick = ValLabelClick
            OnDblClick = LabelSelectColor
          end
          object LineOfsetRadioButton: TRadioButton
            Left = 17
            Top = 0
            Width = 14
            Height = 16
            TabOrder = 0
            OnClick = RadioButtonClick
          end
          object seValue: TBMDSpinEdit
            Left = 216
            Top = 61
            Width = 54
            Height = 29
            Cursor = crArrow
            EditLabel.Width = 3
            EditLabel.Height = 14
            EditLabel.Caption = ' '
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '0'
            Visible = False
            OnChange = seValueChange
            OnContextPopup = seNopContextPopup
            Increment = 1.000000000000000000
            MaxValue = 255.000000000000000000
            Position = 0
            Precision = 0
            TrackBarEnabled = False
          end
          object seNop: TBMDSpinEdit
            Left = 80
            Top = 61
            Width = 54
            Height = 29
            Cursor = crArrow
            EditLabel.Width = 3
            EditLabel.Height = 14
            EditLabel.Caption = ' '
            LabelPosition = lpLeft
            TabOrder = 2
            Text = '0'
            Visible = False
            OnChange = seNopChange
            OnContextPopup = seNopContextPopup
            Increment = 1.000000000000000000
            MaxValue = 36.000000000000000000
            Position = 0
            GaugeBeginColor = clBlack
            GaugeEndColor = clBlack
            Precision = 0
            TrackBarEnabled = False
          end
        end
      end
      object GTIARegisterList: TComboBox
        Left = 467
        Top = 58
        Width = 72
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 1
        Text = 'HPOSP0'
        Visible = False
        OnChange = GTIARegisterListChange
        OnCloseUp = GTIARegisterListCloseUp
        OnDblClick = GTIARegisterListDblClick
        Items.Strings = (
          'HPOSP0'
          'HPOSP1'
          'HPOSP2'
          'HPOSP3'
          'HPOSM0'
          'HPOSM1'
          'HPOSM2'
          'HPOSM3'
          'SIZEP0'
          'SIZEP1'
          'SIZEP2'
          'SIZEP3'
          'SIZEM'
          'GRAFP0'
          'GRAFP1'
          'GRAFP2'
          'GRAFP3'
          'GRAFM'
          'COLPM0'
          'COLPM1'
          'COLPM2'
          'COLPM3'
          'COLOR0'
          'COLOR1'
          'COLOR2'
          'COLOR3'
          'COLBAK'
          'GTICTL'
          'VDELAY'
          'PMCNTL'
          'HITCLR'
          'CONSOL'
          'CHRCTL')
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 164
        Height = 72
        BevelInner = bvLowered
        ParentBackground = False
        TabOrder = 2
        object Apply: TButton
          Left = 99
          Top = 23
          Width = 59
          Height = 25
          Hint = 'Apply change'
          Caption = 'APPLY'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ApplyClick
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
              OnChange = frameLineRange1seRangeChange
              ExplicitHeight = 29
            end
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 74
        Width = 164
        Height = 41
        BevelInner = bvLowered
        ParentBackground = False
        TabOrder = 3
        object GlobalOfset: TTrackBar
          Left = 0
          Top = 3
          Width = 164
          Height = 32
          Max = 24
          Min = -24
          Frequency = 2
          ShowSelRange = False
          TabOrder = 0
          ThumbLength = 16
          TickMarks = tmBoth
          OnChange = GlobalOfsetChange
        end
      end
    end
  end
end
