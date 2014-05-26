object FormMain: TFormMain
  Left = 266
  Top = 134
  AutoScroll = False
  Caption = 'ATPrintPreview Demo'
  ClientHeight = 346
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 280
    Width = 391
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object labMm: TLabel
      Left = 44
      Top = 44
      Width = 27
      Height = 13
      Caption = '&units:'
      FocusControl = edMm
    end
    object btnOpen: TButton
      Left = 42
      Top = 8
      Width = 73
      Height = 25
      Caption = '&Open...'
      TabOrder = 0
      OnClick = btnOpenClick
    end
    object btnPreview: TButton
      Left = 120
      Top = 8
      Width = 151
      Height = 25
      Caption = '&Preview && Print...'
      Default = True
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnPreviewClick
    end
    object btnClose: TButton
      Left = 278
      Top = 8
      Width = 73
      Height = 25
      Cancel = True
      Caption = 'Close'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object edMm: TComboBox
      Left = 82
      Top = 40
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = chkMmClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object boxMain: TGroupBox
      Left = 0
      Top = 0
      Width = 391
      Height = 280
      Align = alClient
      Caption = ' Sample image '
      TabOrder = 0
      object Image1: TImage
        Left = 2
        Top = 15
        Width = 387
        Height = 263
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 288
    Top = 215
  end
  object XPManifest1: TXPManifest
    Left = 320
    Top = 216
  end
end
