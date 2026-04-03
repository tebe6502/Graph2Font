object frameAtariPalette: TframeAtariPalette
  Left = 0
  Top = 0
  Width = 306
  Height = 44
  AutoSize = True
  TabOrder = 0
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 44
    Height = 44
    ParentShowHint = False
    ShowHint = True
    OnClick = Image1Click
    OnMouseMove = Image1MouseMove
  end
  object PenColors: TImage
    Left = 48
    Top = 0
    Width = 258
    Height = 17
    OnClick = PenColorsClick
    OnContextPopup = PenColorsContextPopup
    OnMouseDown = PenColorsMouseDown
    OnMouseMove = PenColorsMouseMove
  end
  object SpTBXToolbar1: TSpTBXToolbar
    Left = 48
    Top = 18
    Width = 124
    Height = 25
    CloseButton = False
    FullSize = True
    ProcessShortCuts = True
    ShrinkMode = tbsmWrap
    TabOrder = 0
    Caption = 'SpTBXToolbar1'
    Customizable = False
    DisplayMode = tbdmImageOnly
    MenuBar = True
    object SpTBXLabelItem1: TSpTBXLabelItem
      Caption = 'Fill:'
    end
    object fTool: TSpTBXSubmenuItem
      Caption = 'Solid Color'
      Images = Form1.ImageList4
      Options = [tboDropdownArrow, tboToolbarStyle]
      CustomWidth = 96
      CustomHeight = 25
      object SpTBXToolPalette1: TSpTBXToolPalette
        ColCount = 9
        Images = Form1.ImageList4
        RowCount = 13
        OnCellClick = SpTBXToolPalette1CellClick
      end
    end
  end
end
