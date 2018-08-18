object FormViewOptions: TFormViewOptions
  Left = 253
  Top = 152
  BorderStyle = bsDialog
  Caption = 'Universal Viewer settings'
  ClientHeight = 395
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 64
    Top = 196
    Width = 44
    Height = 13
    Caption = 'Internet:'
  end
  object btnOk: TButton
    Left = 392
    Top = 364
    Width = 81
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 480
    Top = 364
    Width = 81
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 553
    Height = 349
    ActivePage = tabIntf
    TabOrder = 0
    object tabIntf: TTabSheet
      Caption = 'Interface'
      object boxIntf: TGroupBox
        Left = 8
        Top = 4
        Width = 449
        Height = 285
        Caption = 'Interface'
        TabOrder = 0
        object labLang: TLabel
          Left = 8
          Top = 20
          Width = 51
          Height = 13
          Caption = 'Language:'
          FocusControl = edLang
        end
        object labIcon: TLabel
          Left = 8
          Top = 44
          Width = 30
          Height = 13
          Caption = 'Icons:'
          FocusControl = edIcon
        end
        object edLang: TComboBox
          Left = 88
          Top = 16
          Width = 153
          Height = 21
          Style = csDropDownList
          DropDownCount = 10
          ItemHeight = 13
          TabOrder = 0
          OnChange = edLangChange
        end
        object chkShell: TCheckBox
          Left = 8
          Top = 188
          Width = 400
          Height = 17
          Caption = 'Explorer context menu item'
          TabOrder = 9
        end
        object chkToolbar: TCheckBox
          Left = 8
          Top = 116
          Width = 400
          Height = 17
          Caption = 'Show toolbar'
          TabOrder = 5
        end
        object chkBorder: TCheckBox
          Left = 8
          Top = 148
          Width = 400
          Height = 17
          Caption = 'Show border'
          TabOrder = 7
        end
        object chkSingleInst: TCheckBox
          Left = 8
          Top = 204
          Width = 400
          Height = 17
          Caption = 'Run single instance only'
          TabOrder = 10
        end
        object chkMenu: TCheckBox
          Left = 8
          Top = 84
          Width = 400
          Height = 17
          Caption = 'Show menu'
          TabOrder = 3
        end
        object chkStatusBar: TCheckBox
          Left = 8
          Top = 164
          Width = 400
          Height = 17
          Caption = 'Show status bar'
          TabOrder = 8
        end
        object chkNav: TCheckBox
          Left = 8
          Top = 68
          Width = 400
          Height = 17
          Caption = 'Show navigation panel'
          TabOrder = 2
        end
        object chkMenuIcons: TCheckBox
          Left = 8
          Top = 100
          Width = 400
          Height = 17
          Caption = 'Show icons in menu'
          TabOrder = 4
        end
        object edIcon: TComboBox
          Left = 88
          Top = 40
          Width = 153
          Height = 21
          Style = csDropDownList
          DropDownCount = 10
          ItemHeight = 13
          TabOrder = 1
          OnChange = edIconChange
        end
        object Panel1: TPanel
          Left = 248
          Top = 32
          Width = 129
          Height = 33
          TabOrder = 11
          Visible = False
          object Image1: TImage
            Left = 1
            Top = 1
            Width = 127
            Height = 31
            Align = alClient
          end
        end
        object chkShowCfm: TCheckBox
          Left = 8
          Top = 228
          Width = 433
          Height = 17
          Caption = 'Show confirmation'
          TabOrder = 12
        end
        object chkShowConv: TCheckBox
          Left = 8
          Top = 244
          Width = 433
          Height = 17
          Caption = 'Show converter msg'
          TabOrder = 13
        end
        object chkToolbarFS: TCheckBox
          Left = 24
          Top = 132
          Width = 400
          Height = 17
          Caption = 'Allow toolbar in full-screen'
          TabOrder = 6
        end
        object chkRen: TCheckBox
          Left = 8
          Top = 260
          Width = 433
          Height = 17
          Caption = 'Suggest rename'
          TabOrder = 14
        end
      end
    end
    object tabFile: TTabSheet
      Caption = 'File types'
      ImageIndex = 5
      object boxExt: TGroupBox
        Left = 8
        Top = 4
        Width = 369
        Height = 149
        Caption = 'File extensions'
        TabOrder = 0
        object labConv: TLabel
          Left = 8
          Top = 90
          Width = 39
          Height = 13
          Caption = 'labConv'
          FocusControl = edConv
        end
        object labText: TLabel
          Left = 8
          Top = 18
          Width = 36
          Height = 13
          Caption = 'labText'
          FocusControl = edText
        end
        object edText: TEdit
          Left = 120
          Top = 16
          Width = 233
          Height = 21
          TabOrder = 0
        end
        object edImages: TEdit
          Left = 120
          Top = 40
          Width = 233
          Height = 21
          TabOrder = 2
        end
        object edInet: TEdit
          Left = 120
          Top = 64
          Width = 233
          Height = 21
          TabOrder = 4
        end
        object edConv: TEdit
          Left = 120
          Top = 88
          Width = 233
          Height = 21
          TabOrder = 5
        end
        object chkImages: TCheckBox
          Left = 8
          Top = 42
          Width = 112
          Height = 17
          Caption = 'chkImages'
          TabOrder = 1
        end
        object chkInet: TCheckBox
          Left = 8
          Top = 66
          Width = 112
          Height = 17
          Caption = 'chkInet'
          TabOrder = 3
        end
        object edIgnore: TEdit
          Left = 120
          Top = 112
          Width = 233
          Height = 21
          TabOrder = 7
        end
        object chkIgnore: TCheckBox
          Left = 8
          Top = 114
          Width = 112
          Height = 17
          Caption = 'Ignore:'
          TabOrder = 6
        end
      end
      object btnTextOptions: TButton
        Left = 8
        Top = 248
        Width = 185
        Height = 21
        Caption = 'Auto-detection...'
        TabOrder = 1
        OnClick = btnTextOptionsClick
      end
      object btnImageOptions: TButton
        Left = 8
        Top = 274
        Width = 185
        Height = 21
        Caption = 'Libraries...'
        TabOrder = 2
        OnClick = btnImageOptionsClick
      end
    end
    object tabText: TTabSheet
      Caption = 'Text'
      ImageIndex = 3
      object boxText: TGroupBox
        Left = 276
        Top = 4
        Width = 262
        Height = 197
        Caption = 'Text'
        TabOrder = 1
        object labTextFixedWidth: TLabel
          Left = 64
          Top = 126
          Width = 115
          Height = 13
          Caption = 'Binary mode fixed width'
          FocusControl = edTextWidth
        end
        object labTabSize: TLabel
          Left = 64
          Top = 170
          Width = 39
          Height = 13
          Caption = 'Tab size'
          FocusControl = edTextTabSize
        end
        object labTextLength: TLabel
          Left = 64
          Top = 148
          Width = 90
          Height = 13
          Caption = 'Maximal line length'
          FocusControl = edTextLength
        end
        object edTextWidth: TSpinEdit
          Left = 8
          Top = 124
          Width = 49
          Height = 22
          AutoSize = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 6
          Value = 10
          OnKeyDown = edHTextKeyDown
        end
        object chkTextWidthFit: TCheckBox
          Left = 8
          Top = 104
          Width = 250
          Height = 17
          Caption = 'Binary mode fit width'
          TabOrder = 5
          OnClick = chkTextWidthFitClick
        end
        object chkTextAutoCopy: TCheckBox
          Left = 8
          Top = 88
          Width = 250
          Height = 17
          Caption = 'Auto-copy to clipboard'
          TabOrder = 4
        end
        object edTextTabSize: TSpinEdit
          Left = 8
          Top = 168
          Width = 49
          Height = 22
          AutoSize = False
          MaxValue = 20
          MinValue = 1
          TabOrder = 8
          Value = 1
          OnKeyDown = edHTextKeyDown
        end
        object edTextLength: TSpinEdit
          Left = 8
          Top = 146
          Width = 49
          Height = 22
          AutoSize = False
          Increment = 50
          MaxValue = 10000
          MinValue = 10
          TabOrder = 7
          Value = 10
          OnKeyDown = edHTextKeyDown
        end
        object chkTextWrap: TCheckBox
          Left = 8
          Top = 40
          Width = 250
          Height = 17
          Caption = 'Wrap'
          TabOrder = 1
        end
        object chkTextNonPrint: TCheckBox
          Left = 8
          Top = 72
          Width = 250
          Height = 17
          Caption = 'Non-print'
          TabOrder = 3
        end
        object btnGutterOptions: TButton
          Left = 8
          Top = 16
          Width = 201
          Height = 21
          Caption = 'Gutter && line numbers'
          TabOrder = 0
          OnClick = btnGutterOptionsClick
        end
        object chkTextURLs: TCheckBox
          Left = 8
          Top = 56
          Width = 249
          Height = 17
          Caption = 'Hilight URLs'
          TabOrder = 2
        end
      end
      object boxTextFont: TGroupBox
        Left = 8
        Top = 4
        Width = 262
        Height = 105
        Caption = 'Font'
        TabOrder = 0
        object labTextFont1: TLabel
          Left = 8
          Top = 19
          Width = 26
          Height = 13
          Caption = 'Font:'
          FocusControl = btnTextFont
        end
        object labTextFontShow: TLabel
          Left = 96
          Top = 19
          Width = 22
          Height = 13
          Caption = 'Font'
        end
        object labTextColors: TLabel
          Left = 8
          Top = 40
          Width = 34
          Height = 13
          Caption = 'Colors:'
          FocusControl = btnTextColor
        end
        object labTextFontShowOEM: TLabel
          Left = 96
          Top = 81
          Width = 22
          Height = 13
          Caption = 'Font'
        end
        object btnTextFont: TButton
          Left = 64
          Top = 16
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 0
          OnClick = btnTextFontClick
        end
        object btnTextColor: TButton
          Left = 64
          Top = 38
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnTextColorClick
        end
        object btnTextColorHexBack: TButton
          Left = 88
          Top = 38
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 2
          OnClick = btnTextColorHexBackClick
        end
        object btnTextColorHex1: TButton
          Left = 112
          Top = 38
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 3
          OnClick = btnTextColorHex1Click
        end
        object btnTextColorHex2: TButton
          Left = 136
          Top = 38
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 4
          OnClick = btnTextColorHex2Click
        end
        object btnTextColorGutter: TButton
          Left = 160
          Top = 38
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 5
          OnClick = btnTextColorGutterClick
        end
        object chkTextOemSpecial: TCheckBox
          Left = 8
          Top = 60
          Width = 241
          Height = 17
          Caption = 'Use special OEM font'
          TabOrder = 7
          OnClick = chkTextOemSpecialClick
        end
        object btnTextFontOEM: TButton
          Left = 64
          Top = 78
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 8
          OnClick = btnTextFontOEMClick
        end
        object btnTextColorURL: TButton
          Left = 184
          Top = 38
          Width = 25
          Height = 21
          Hint = 'URL'
          Caption = '...'
          TabOrder = 6
          OnClick = btnTextColorURLClick
        end
        object btnTextColorHi: TButton
          Left = 208
          Top = 38
          Width = 25
          Height = 21
          Hint = 'Highlight'
          Caption = '...'
          TabOrder = 9
          OnClick = btnTextColorHiClick
        end
      end
      object boxTextSearch: TGroupBox
        Left = 8
        Top = 188
        Width = 262
        Height = 97
        Caption = 'Search'
        TabOrder = 3
        object labSearchIndent: TLabel
          Left = 56
          Top = 70
          Width = 135
          Height = 13
          Caption = 'Search result: lines from top'
          FocusControl = edSearchIndent
        end
        object edSearchIndent: TSpinEdit
          Left = 8
          Top = 68
          Width = 41
          Height = 22
          AutoSize = False
          MaxLength = 100
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
          OnKeyDown = edHTextKeyDown
        end
        object chkSearchSel: TCheckBox
          Left = 8
          Top = 16
          Width = 250
          Height = 17
          Caption = 'Suggest selection'
          TabOrder = 0
        end
        object chkSearchNoMsg: TCheckBox
          Left = 8
          Top = 32
          Width = 250
          Height = 17
          Caption = 'No error msg'
          TabOrder = 1
        end
        object chkSearchNoCfm: TCheckBox
          Left = 8
          Top = 48
          Width = 250
          Height = 17
          Caption = 'No next cfm'
          TabOrder = 2
        end
      end
      object boxTextReload: TGroupBox
        Left = 8
        Top = 112
        Width = 262
        Height = 73
        Caption = 'Auto-reload'
        TabOrder = 2
        object chkTextReload: TCheckBox
          Left = 8
          Top = 16
          Width = 250
          Height = 17
          Caption = 'Auto-reload'
          TabOrder = 0
          OnClick = chkTextReloadClick
        end
        object chkTextReloadBeep: TCheckBox
          Left = 8
          Top = 32
          Width = 250
          Height = 17
          Caption = 'Beep'
          TabOrder = 1
        end
        object chkTextReloadTail: TCheckBox
          Left = 8
          Top = 48
          Width = 250
          Height = 17
          Caption = 'Follow tail'
          TabOrder = 2
        end
      end
    end
    object tabMedia: TTabSheet
      Caption = 'Multimedia'
      ImageIndex = 4
      object boxImage: TGroupBox
        Left = 8
        Top = 4
        Width = 265
        Height = 209
        Caption = 'Image'
        TabOrder = 0
        object labColorImage: TLabel
          Left = 8
          Top = 20
          Width = 34
          Height = 13
          Caption = 'Colors:'
          FocusControl = btnMediaColor
        end
        object chkImageResample: TCheckBox
          Left = 8
          Top = 144
          Width = 254
          Height = 17
          Caption = 'Resample image'
          TabOrder = 9
        end
        object chkImageTransp: TCheckBox
          Left = 8
          Top = 160
          Width = 254
          Height = 17
          Caption = 'Show transparency'
          TabOrder = 10
        end
        object btnMediaColor: TButton
          Left = 80
          Top = 17
          Width = 33
          Height = 21
          Caption = '...'
          TabOrder = 0
          OnClick = btnMediaColorClick
        end
        object btnMediaColorLabel: TButton
          Left = 112
          Top = 17
          Width = 33
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btnMediaColorLabelClick
        end
        object btnMediaColorLabelErr: TButton
          Left = 144
          Top = 17
          Width = 33
          Height = 21
          Caption = '...'
          TabOrder = 2
          OnClick = btnMediaColorLabelErrClick
        end
        object chkImageFit: TCheckBox
          Left = 8
          Top = 40
          Width = 254
          Height = 17
          Caption = 'Fit image'
          TabOrder = 3
        end
        object chkImageFitBig: TCheckBox
          Left = 8
          Top = 56
          Width = 254
          Height = 17
          Caption = 'Fit only big'
          TabOrder = 4
        end
        object chkImageCenter: TCheckBox
          Left = 8
          Top = 104
          Width = 254
          Height = 17
          Caption = 'Center'
          TabOrder = 7
        end
        object chkImageFitWindow: TCheckBox
          Left = 8
          Top = 120
          Width = 254
          Height = 17
          Caption = 'Fit window'
          TabOrder = 8
        end
        object chkImageLabel: TCheckBox
          Left = 8
          Top = 184
          Width = 254
          Height = 17
          Caption = 'Show info line'
          TabOrder = 11
        end
        object chkImageFitWidth: TCheckBox
          Left = 8
          Top = 72
          Width = 254
          Height = 17
          Caption = 'Fit only width'
          TabOrder = 5
        end
        object chkImageFitHeight: TCheckBox
          Left = 8
          Top = 88
          Width = 254
          Height = 17
          Caption = 'Fit only height'
          TabOrder = 6
        end
      end
      object boxInternet: TGroupBox
        Left = 280
        Top = 8
        Width = 257
        Height = 53
        Caption = 'Internet'
        TabOrder = 1
        object chkWebOffline: TCheckBox
          Left = 8
          Top = 20
          Width = 246
          Height = 17
          Caption = 'Offline mode'
          TabOrder = 0
        end
      end
    end
    object tabShortcuts: TTabSheet
      Caption = 'Shortcuts'
      ImageIndex = 1
      object labShortcut: TLabel
        Left = 328
        Top = 8
        Width = 45
        Height = 13
        Caption = 'Shortcut:'
        FocusControl = HotKey1_
      end
      object ListKeys: TListView
        Left = 8
        Top = 8
        Width = 305
        Height = 261
        Columns = <
          item
            Caption = 'Command'
            Width = 165
          end
          item
            Caption = 'Shortcut'
            Width = 115
          end>
        ColumnClick = False
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnSelectItem = ListKeysSelectItem
      end
      object HotKey1_: THotKey
        Left = 376
        Top = 36
        Width = 145
        Height = 19
        Enabled = False
        HotKey = 0
        Modifiers = []
        TabOrder = 1
        Visible = False
      end
      object btnKeyOk: TButton
        Left = 328
        Top = 48
        Width = 89
        Height = 21
        Caption = 'OK'
        Enabled = False
        TabOrder = 3
        OnClick = btnKeyOkClick
      end
      object btnKeyReset: TButton
        Left = 328
        Top = 72
        Width = 89
        Height = 21
        Caption = 'Reset'
        Enabled = False
        TabOrder = 4
        OnClick = btnKeyResetClick
      end
      object HotKey1: TecHotKey
        Left = 328
        Top = 24
        Width = 137
        Height = 21
        TabStop = False
        HotKey = 0
        TabOrder = 2
      end
    end
    object tabHistory: TTabSheet
      Caption = 'History'
      ImageIndex = 6
      object boxHistory: TGroupBox
        Left = 8
        Top = 4
        Width = 305
        Height = 157
        Caption = 'History'
        TabOrder = 0
        object chkSaveFolder: TCheckBox
          Left = 8
          Top = 128
          Width = 289
          Height = 17
          Caption = 'Save last working folder'
          TabOrder = 6
        end
        object chkSavePosition: TCheckBox
          Left = 8
          Top = 112
          Width = 289
          Height = 17
          Caption = 'Save window position'
          TabOrder = 5
        end
        object chkSaveRecents: TCheckBox
          Left = 8
          Top = 16
          Width = 289
          Height = 17
          Caption = 'Save recent files list'
          TabOrder = 0
        end
        object chkSaveSearch: TCheckBox
          Left = 8
          Top = 72
          Width = 289
          Height = 17
          Caption = 'Save search history'
          TabOrder = 3
        end
        object btnClearRecent: TButton
          Left = 24
          Top = 50
          Width = 89
          Height = 21
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnClearRecentClick
        end
        object btnClearSearch: TButton
          Left = 24
          Top = 89
          Width = 89
          Height = 21
          Caption = 'Clear'
          TabOrder = 4
          OnClick = btnClearSearchClick
        end
        object chkSaveFile: TCheckBox
          Left = 24
          Top = 32
          Width = 270
          Height = 17
          Caption = 'Reopen last used file'
          TabOrder = 1
        end
      end
    end
    object tabMisc: TTabSheet
      Caption = 'Misc'
      ImageIndex = 2
      object boxMisc: TGroupBox
        Left = 8
        Top = 4
        Width = 305
        Height = 133
        Caption = 'Misc'
        TabOrder = 0
        object labViewerTitle: TLabel
          Left = 8
          Top = 44
          Width = 63
          Height = 13
          Caption = 'Window title:'
          FocusControl = edViewerTitle
        end
        object labViewerMode: TLabel
          Left = 8
          Top = 20
          Width = 65
          Height = 13
          Caption = 'Startup view:'
          FocusControl = edViewerMode
        end
        object labFileSort: TLabel
          Left = 8
          Top = 68
          Width = 47
          Height = 13
          Caption = 'Files sort:'
          FocusControl = edFileSort
        end
        object chkResolveLinks: TCheckBox
          Left = 8
          Top = 104
          Width = 289
          Height = 17
          Caption = 'Resolve .lnk'
          TabOrder = 4
        end
        object chkShowHidden: TCheckBox
          Left = 8
          Top = 88
          Width = 289
          Height = 17
          Caption = 'Show hidden files'
          TabOrder = 3
        end
        object edViewerTitle: TComboBox
          Left = 144
          Top = 40
          Width = 153
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 1
          Text = 'Display full pathname'
          Items.Strings = (
            'Display full pathname'
            'Display filename only')
        end
        object edViewerMode: TComboBox
          Left = 144
          Top = 16
          Width = 153
          Height = 22
          Style = csOwnerDrawFixed
          DropDownCount = 10
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 0
          Text = 'Auto detect'
          Items.Strings = (
            'Auto detect'
            'Text'
            'Binary'
            'Hex'
            'Image/Multimedia'
            'Internet'
            'Unicode'
            'Plugins'
            'RTF/UTF-8')
        end
        object edFileSort: TComboBox
          Left = 144
          Top = 64
          Width = 153
          Height = 22
          Style = csOwnerDrawFixed
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 2
          Text = 'File name'
          Items.Strings = (
            'File name'
            'File name (desc.)'
            'Extension'
            'Extension (desc.)')
        end
      end
      object boxPrint: TGroupBox
        Left = 320
        Top = 4
        Width = 217
        Height = 57
        Caption = 'Print'
        TabOrder = 2
        object labFontFooter: TLabel
          Left = 8
          Top = 15
          Width = 59
          Height = 13
          Caption = 'Footer font:'
          FocusControl = btnFontFooter
        end
        object labFooterFontShow: TLabel
          Left = 64
          Top = 32
          Width = 22
          Height = 13
          Caption = 'Font'
        end
        object btnFontFooter: TButton
          Left = 24
          Top = 30
          Width = 33
          Height = 21
          Caption = '...'
          TabOrder = 0
          OnClick = btnFontFooterClick
        end
      end
      object boxHMisc: TGroupBox
        Left = 8
        Top = 140
        Width = 305
        Height = 141
        Caption = 'Use custom height'
        TabOrder = 1
        object chkHText: TCheckBox
          Left = 8
          Top = 16
          Width = 130
          Height = 17
          Caption = 'Text'
          TabOrder = 0
          OnClick = chkHTextClick
        end
        object edHText: TSpinEdit
          Left = 144
          Top = 12
          Width = 50
          Height = 22
          Increment = 20
          MaxValue = 2000
          MinValue = 40
          TabOrder = 1
          Value = 40
          OnKeyDown = edHTextKeyDown
        end
        object chkHImage: TCheckBox
          Left = 8
          Top = 40
          Width = 130
          Height = 17
          Caption = 'Image'
          TabOrder = 2
          OnClick = chkHTextClick
        end
        object edHImage: TSpinEdit
          Left = 144
          Top = 36
          Width = 50
          Height = 22
          Increment = 20
          MaxValue = 2000
          MinValue = 40
          TabOrder = 3
          Value = 40
          OnKeyDown = edHTextKeyDown
        end
        object chkHWeb: TCheckBox
          Left = 8
          Top = 64
          Width = 130
          Height = 17
          Caption = 'Web'
          TabOrder = 4
          OnClick = chkHTextClick
        end
        object edHWeb: TSpinEdit
          Left = 144
          Top = 60
          Width = 50
          Height = 22
          Increment = 20
          MaxValue = 2000
          MinValue = 40
          TabOrder = 5
          Value = 40
          OnKeyDown = edHTextKeyDown
        end
        object chkHRtf: TCheckBox
          Left = 8
          Top = 112
          Width = 130
          Height = 17
          Caption = '&RTF/UTF-8:'
          TabOrder = 8
          OnClick = chkHTextClick
        end
        object edHRtf: TSpinEdit
          Left = 144
          Top = 108
          Width = 50
          Height = 22
          Increment = 20
          MaxValue = 2000
          MinValue = 40
          TabOrder = 9
          Value = 40
          OnKeyDown = edHTextKeyDown
        end
        object chkHPlug: TCheckBox
          Left = 8
          Top = 88
          Width = 130
          Height = 17
          Caption = 'Plugins:'
          TabOrder = 6
          OnClick = chkHTextClick
        end
        object edHPlug: TSpinEdit
          Left = 144
          Top = 84
          Width = 50
          Height = 22
          Increment = 20
          MaxValue = 2000
          MinValue = 40
          TabOrder = 7
          Value = 40
          OnKeyDown = edHTextKeyDown
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Shell Dlg'
    Font.Style = []
    Left = 424
    Top = 12
  end
  object ColorDialog1: TColorDialog
    Left = 472
    Top = 12
  end
  object FontDialog2: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Shell Dlg'
    Font.Style = []
    Device = fdPrinter
    Options = [fdEffects, fdWysiwyg]
    Left = 448
    Top = 12
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.bmp'
    FileName = '(Template).bmp'
    Filter = '*.bmp|*.bmp'
    InitialDir = 'C:\'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 504
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 320
    Top = 360
  end
end
