object FormDeb: TFormDeb
  Left = 300
  Top = 231
  BorderStyle = bsDialog
  Caption = 'Debug form'
  ClientHeight = 294
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox3: TListBox
    Left = 424
    Top = 4
    Width = 113
    Height = 281
    ItemHeight = 13
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 8
    Top = 124
    Width = 137
    Height = 161
    ItemHeight = 13
    TabOrder = 1
  end
  object ListBox2: TListBox
    Left = 152
    Top = 124
    Width = 137
    Height = 161
    ItemHeight = 13
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 8
    Top = 4
    Width = 401
    Height = 114
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object Button1: TButton
    Left = 544
    Top = 4
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 4
    OnClick = Button1Click
  end
end
