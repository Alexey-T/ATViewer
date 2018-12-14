object FormViewOptionsImages: TFormViewOptionsImages
  Left = 305
  Top = 135
  BorderStyle = bsDialog
  Caption = 'Libraries'
  ClientHeight = 120
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 180
    Top = 88
    Width = 81
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 92
    Top = 88
    Width = 81
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object boxIJL: TGroupBox
    Left = 8
    Top = 4
    Width = 337
    Height = 77
    TabOrder = 0
    object labExtIJL: TLabel
      Left = 24
      Top = 34
      Width = 75
      Height = 13
      Caption = 'File extensions:'
      FocusControl = edExtIJL
    end
    object chkUseIJL: TCheckBox
      Left = 8
      Top = 16
      Width = 321
      Height = 17
      Caption = 'Use IJL'
      TabOrder = 0
      OnClick = chkUseIJLClick
    end
    object edExtIJL: TEdit
      Left = 24
      Top = 48
      Width = 257
      Height = 21
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.exe|*.exe'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 296
    Top = 56
  end
end
