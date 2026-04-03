object FEditCharset: TFEditCharset
  Tag = 6
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsToolWindow
  BorderWidth = 2
  Caption = 'Edit Charset'
  ClientHeight = 227
  ClientWidth = 610
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseEnter = FormMouseEnter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel3: TBevel
    Left = 158
    Top = 49
    Width = 150
    Height = 150
  end
  object Bevel2: TBevel
    Left = 311
    Top = 49
    Width = 296
    Height = 150
  end
  object Bevel1: TBevel
    Left = 5
    Top = 49
    Width = 150
    Height = 150
  end
  object Label1: TLabel
    Left = 344
    Top = 12
    Width = 38
    Height = 14
    Caption = 'Charset'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 206
    Width = 610
    Height = 21
    Panels = <
      item
        Bevel = pbNone
        Style = psOwnerDraw
        Width = 30
      end
      item
        Alignment = taCenter
        Bevel = pbNone
        Width = 128
      end
      item
        Alignment = taCenter
        Bevel = pbNone
        Width = 151
      end
      item
        Alignment = taCenter
        Width = 50
      end>
    OnDrawPanel = StatusBar1DrawPanel
  end
  inline frameAtariPalette1: TframeAtariPalette
    Left = 2
    Top = 2
    Width = 306
    Height = 44
    AutoSize = True
    TabOrder = 1
    ExplicitLeft = 2
    ExplicitTop = 2
  end
  object ComboCharset: TComboBox
    Left = 388
    Top = 8
    Width = 177
    Height = 22
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Default'
    OnChange = ComboCharsetChange
    OnCloseUp = ComboCharsetCloseUp
    Items.Strings = (
      'Default')
  end
  object Image1: TImgView32
    Left = 314
    Top = 51
    Width = 290
    Height = 146
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Centered = False
    Scale = 1.000000000000000000
    ScaleMode = smResize
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    ScrollBars.Visibility = svHidden
    OverSize = 0
    TabOrder = 3
    OnClick = Image1Click
    OnMouseMove = Image1MouseMove
  end
  object Image3: TImgView32
    Left = 161
    Top = 52
    Width = 148
    Height = 148
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Centered = False
    Scale = 1.000000000000000000
    ScaleMode = smResize
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    ScrollBars.Visibility = svHidden
    OverSize = 0
    TabOrder = 4
    OnClick = Image3Click
    OnMouseMove = Image3MouseMove
  end
  object Image2: TImgView32
    Left = 8
    Top = 54
    Width = 144
    Height = 144
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Centered = False
    Scale = 1.000000000000000000
    ScaleMode = smResize
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    ScrollBars.Visibility = svHidden
    OverSize = 0
    TabOrder = 5
    OnMouseDown = Image2MouseDown
    OnMouseMove = Image2MouseMove
    OnMouseUp = Image2MouseUp
  end
  object MainMenu1: TMainMenu
    Images = Form1.ImageList2
    Left = 472
    Top = 48
    object File1: TMenuItem
      Caption = 'File'
      object LoadFNT1: TMenuItem
        Caption = 'Load FNT'
        ShortCut = 16463
        OnClick = LoadFNT1Click
      end
      object SaveFNT1: TMenuItem
        Caption = 'Save FNT'
        ShortCut = 16467
        OnClick = SaveFNT1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object DeleteFNT: TMenuItem
        Caption = 'Delete FNT'
        OnClick = DeleteFNTClick
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Copy1: TMenuItem
        Caption = 'Copy'
        ImageIndex = 5
        ShortCut = 16451
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = 'Paste'
        ImageIndex = 4
        ShortCut = 16470
        OnClick = Paste1Click
      end
    end
    object Option1: TMenuItem
      Caption = 'Option'
      object FlipVertical2: TMenuItem
        Caption = 'Vertical Flip'
        ImageIndex = 8
        ShortCut = 86
        OnClick = FlipVertical1Click
      end
      object FlipVertical1: TMenuItem
        Caption = 'Horizontal Flip'
        ImageIndex = 9
        ShortCut = 72
        OnClick = FlipVertical2Click
      end
      object RotateRight1: TMenuItem
        Caption = 'Rotate Right'
        ImageIndex = 11
        ShortCut = 82
        OnClick = RotateRight1Click
      end
      object RotateLeft1: TMenuItem
        Caption = 'Rotate Left'
        ImageIndex = 12
        ShortCut = 76
        OnClick = RotateLeft1Click
      end
      object Fill1: TMenuItem
        Caption = 'Fill'
        ShortCut = 70
        OnClick = Fill1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      ShortCut = 112
      OnClick = Help1Click
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.fnt'
    Filter = 'FNT Charset (*.fnt)|*.fnt'
    Left = 392
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.fnt'
    Filter = 'FNT Charset (*.fnt)|*.fnt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 424
    Top = 48
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 312
    Top = 48
  end
end
