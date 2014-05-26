object FormViewReg: TFormViewReg
  Left = 252
  Top = 274
  ActiveControl = edName
  BorderStyle = bsDialog
  Caption = 'Registration'
  ClientHeight = 151
  ClientWidth = 314
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
  object btnOK: TButton
    Left = 72
    Top = 120
    Width = 81
    Height = 23
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object boxInfo: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 105
    Caption = ' Registration info '
    TabOrder = 0
    object labName: TLabel
      Left = 8
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
      FocusControl = edName
    end
    object labKey: TLabel
      Left = 8
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Key:'
      FocusControl = edKey
    end
    object edName: TEdit
      Left = 8
      Top = 32
      Width = 281
      Height = 21
      TabOrder = 0
      OnChange = edNameChange
    end
    object edKey: TEdit
      Left = 8
      Top = 72
      Width = 281
      Height = 21
      TabOrder = 1
      OnChange = edNameChange
    end
  end
  object btnCancel: TButton
    Left = 160
    Top = 120
    Width = 81
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
