object FSelectValue: TFSelectValue
  Tag = 17
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 270
  ClientWidth = 60
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 7
    Width = 60
    Height = 256
  end
  object TrackBar1: TTrackBar
    Left = 0
    Top = 0
    Width = 60
    Height = 270
    Max = 255
    Orientation = trVertical
    Frequency = 16
    TabOrder = 0
    ThumbLength = 39
    TickMarks = tmBoth
  end
end
