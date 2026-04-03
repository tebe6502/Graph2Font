object FAbout: TFAbout
  Tag = 13
  Left = 517
  Top = 137
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 2
  ClientHeight = 499
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 380
    Height = 200
    Cursor = crHandPoint
    Align = alTop
    OnClick = Image1Click
  end
  object HTMLabel1: THTMLabel
    Left = 0
    Top = 283
    Width = 380
    Height = 216
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    HTMLText.Strings = (
      
        '<b>TGIFImage 2.2</b><br>Anders Melander, Filip Larsen, Reinier S' +
        'terkenburg<br><br><b>TPNGImage 1.2</b><br>Gustavo Daud, Paul Tot' +
        'h<br><br><b>ZLib 1.2.3</b><br>Erik Turner, David Bennion, Burak ' +
        'Kalayci, Vicente S'#225'nchez-Alarcos, <br>Luigi Sandon, Ferry Van Ge' +
        'nderen, Mathijs Van Veluw<br><br><b>BMSpinEdit 2.2</b><br>Karste' +
        'n Lehnart, Boian Mitov<br>')
    ParentFont = False
    Transparent = True
    Version = '1.9.0.1'
    ExplicitTop = 304
    ExplicitHeight = 241
  end
  object Bevel1: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 202
    Width = 380
    Height = 79
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 2
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
  end
end
