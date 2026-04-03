object frameAddSkip: TframeAddSkip
  Left = 0
  Top = 0
  Width = 171
  Height = 30
  TabOrder = 0
  object seAdd: TBMDSpinEdit
    Left = 32
    Top = 0
    Width = 54
    Height = 28
    Cursor = crArrow
    Hint = '-128,00 .. 128,00'
    EditLabel.Width = 23
    EditLabel.Height = 13
    EditLabel.Caption = 'Add:'
    LabelPosition = lpLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '0,00'
    OnContextPopup = seAddContextPopup
    Increment = 0.010000000000000000
    MaxValue = 128.000000000000000000
    MinValue = -128.000000000000000000
    GaugeMaxValue = 128.000000000000000000
    Position = 0
    TrackBarEnabled = False
  end
  object seSkip: TBMDSpinEdit
    Left = 118
    Top = 0
    Width = 44
    Height = 28
    Cursor = crArrow
    Hint = '1 .. 128'
    EditLabel.Width = 23
    EditLabel.Height = 13
    EditLabel.Caption = 'Skip:'
    LabelPosition = lpLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = '1'
    OnContextPopup = seAddContextPopup
    Increment = 1.000000000000000000
    MaxValue = 128.000000000000000000
    MinValue = 1.000000000000000000
    GaugeMaxValue = 64.000000000000000000
    GaugeMinValue = 1.000000000000000000
    Value = 1.000000000000000000
    Position = 1
    Precision = 0
    TrackBarEnabled = False
  end
end
