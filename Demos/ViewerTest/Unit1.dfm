object Form1: TForm1
  Left = 100
  Top = 191
  Width = 640
  Height = 366
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object boxViewer: TGroupBox
    Left = 0
    Top = 0
    Width = 632
    Height = 276
    Align = alClient
    Caption = ' Viewer '
    TabOrder = 0
    object V: TATViewer
      Left = 2
      Top = 15
      Width = 628
      Height = 259
      Align = alClient
      BevelOuter = bvNone
      Caption = 'No file loaded'
      TabOrder = 0
      TabStop = True
      TextWrap = True
      TextWidth = 65
      TextWidthFit = True
      TextWidthFitHex = True
      TextFont.Charset = DEFAULT_CHARSET
      TextFont.Color = clWindowText
      TextFont.Height = -12
      TextFont.Name = 'Courier New'
      TextFont.Style = []
      TextFontOEM.Charset = OEM_CHARSET
      TextFontOEM.Color = clWindowText
      TextFontOEM.Height = -12
      TextFontOEM.Name = 'Terminal'
      TextFontOEM.Style = []
      TextFontFooter.Charset = DEFAULT_CHARSET
      TextFontFooter.Color = clBlack
      TextFontFooter.Height = -12
      TextFontFooter.Name = 'Arial'
      TextFontFooter.Style = []
      TextFontGutter.Charset = DEFAULT_CHARSET
      TextFontGutter.Color = clBlack
      TextFontGutter.Height = -12
      TextFontGutter.Name = 'Courier New'
      TextFontGutter.Style = []
      MediaLoop = False
      MediaShowControls = True
      MediaShowTracker = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 276
    Width = 632
    Height = 56
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 4
      Width = 49
      Height = 13
      Caption = 'File name:'
    end
    object ed: TTntEdit
      Left = 8
      Top = 20
      Width = 313
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 328
      Top = 20
      Width = 75
      Height = 25
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object TntOpenDialog1: TTntOpenDialog
    Filter = '*.*|*.*'
    InitialDir = 'C:\'
    Left = 328
    Top = 272
  end
end
