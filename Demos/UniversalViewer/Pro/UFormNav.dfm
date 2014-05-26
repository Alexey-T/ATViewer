object FormNavUV: TFormNavUV
  Left = 183
  Top = 121
  ActiveControl = List
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'NavPanel'
  ClientHeight = 285
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 49
    Width = 340
    Height = 193
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 161
      Top = 0
      Width = 4
      Height = 193
      ResizeStyle = rsUpdate
    end
    object Tree: TVirtualExplorerTreeview
      Left = 0
      Top = 0
      Width = 161
      Height = 193
      Active = False
      Align = alLeft
      ChangeDelay = 300
      ColumnDetails = cdUser
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      ExplorerComboBox = Comb
      FileSizeFormat = fsfExplorer
      FileSort = fsFileExtension
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      HintMode = hmHint
      IncrementalSearch = isVisibleOnly
      IncrementalSearchStart = ssAlwaysStartOver
      IncrementalSearchTimeout = 2000
      ParentColor = False
      RootFolder = rfDesktop
      TabOrder = 0
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
      TreeOptions.SelectionOptions = [toLevelSelectConstraint]
      TreeOptions.VETShellOptions = [toContextMenus, toDragDrop]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      Columns = <>
    end
    object List: TVirtualExplorerEasyListview
      Left = 165
      Top = 0
      Width = 175
      Height = 193
      Align = alClient
      BackGround.Caption = 'Folder is empty'
      BackGround.CaptionShow = True
      BackGround.CaptionVAlignment = cvaTop
      BevelKind = bkTile
      CompressedFile.Color = clBlue
      CompressedFile.Font.Charset = DEFAULT_CHARSET
      CompressedFile.Font.Color = clWindowText
      CompressedFile.Font.Height = -11
      CompressedFile.Font.Name = 'MS Sans Serif'
      CompressedFile.Font.Style = []
      DefaultSortColumn = 0
      EditManager.Enabled = True
      EditManager.Font.Charset = DEFAULT_CHARSET
      EditManager.Font.Color = clWindowText
      EditManager.Font.Height = -11
      EditManager.Font.Name = 'MS Sans Serif'
      EditManager.Font.Style = []
      EncryptedFile.Color = clGreen
      EncryptedFile.Font.Charset = DEFAULT_CHARSET
      EncryptedFile.Font.Color = clWindowText
      EncryptedFile.Font.Height = -11
      EncryptedFile.Font.Name = 'MS Sans Serif'
      EncryptedFile.Font.Style = []
      DragManager.Enabled = True
      ExplorerCombobox = Comb
      ExplorerTreeview = Tree
      FileSizeFormat = vfsfDefault
      Grouped = False
      GroupingColumn = 0
      IncrementalSearch.Enabled = True
      Options = [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails, eloQueryInfoHints, eloShellContextMenus, eloChangeNotifierThread, eloGhostHiddenFiles]
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      PaintInfoGroup.MarginTop.Visible = False
      ParentShowHint = False
      ShowHint = True
      Sort.Algorithm = esaQuickSort
      Sort.AutoSort = True
      SortFolderFirstAlways = True
      TabOrder = 1
      ThumbsManager.StorageFilename = 'Thumbnails.album'
      View = elsList
      WheelMouseDefaultScroll = edwsHorz
      OnCustomColumnAdd = ListCustomColumnAdd
      OnCustomColumnCompare = ListCustomColumnCompare
      OnCustomColumnGetCaption = ListCustomColumnGetCaption
      OnItemSelectionChanged = ListItemSelectionChanged
      OnRootChange = ListRootChange
      OnRootChanging = ListRootChanging
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 24
    Width = 340
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      340
      25)
    object labFolder: TLabel
      Left = 4
      Top = 6
      Width = 32
      Height = 13
      Caption = '&Folder:'
      FocusControl = Comb
    end
    object btnUp: TSpeedButton
      Left = 308
      Top = 0
      Width = 28
      Height = 24
      Hint = 'Up one level'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        16050000424D160500000000000036040000280000000E0000000E0000000100
        080000000000E000000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
        FDFDFDFDFDFDFDFD00000000000000000000000000000000000000FBF6FBF6FB
        F6FBF6FBF6FBFB00000000F6FBF6FB000000000000F6F600000000FBF6FBF600
        F6FBF6FBF6FBFB00000000F6FBF6FB00FBF6FBF6FBF6F600000000FBF6000000
        0000F6FBF6FBFB00000000F6FBF6000000F6FBF6FBF6F600000000FBF6FBF600
        F6FBF6FBF6FBFB00000000F6FBF6FBF6FBF6FBF6FBF6F6000000000000000000
        00000000000000FD0000FD00FBF6FBF6FB00FDFDFDFDFDFD0000FDFD00000000
        00FDFDFDFDFDFDFD0000FDFDFDFDFDFDFDFDFDFDFDFDFDFD0000}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnUpClick
    end
    object Comb: TVirtualExplorerCombobox
      Left = 48
      Top = 0
      Width = 259
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Path = 'Comb'
      VirtualExplorerTree = Tree
    end
  end
  object Drv: TVirtualDriveToolbar
    Left = 0
    Top = 0
    Width = 340
    Height = 24
    AutoSize = True
    BkGndParent = Owner
    ButtonCaptionOptions = [coDriveLetterOnly]
    VirtualExplorerComboBox = Comb
    VirtualExplorerTree = Tree
    WideText = '&Drives:'
  end
  object Fold: TVirtualSpecialFolderToolbar
    Left = 0
    Top = 242
    Width = 340
    Height = 24
    Align = alBottom
    AutoSize = True
    BkGndParent = Owner
    SpecialFolders = [sfDesktop, sfDrives, sfMyPictures, sfPersonal, sfProgramFiles]
    SpecialCommonFolders = [sfCommonDocuments]
    VirtualExplorerComboBox = Comb
    VirtualExplorerTree = Tree
  end
  object Stat: TStatusBar
    Left = 0
    Top = 266
    Width = 340
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 144
    object mnuView: TMenuItem
      Caption = 'View'
      object mnuV1: TMenuItem
        Caption = 'Icons'
        GroupIndex = 1
        RadioItem = True
        OnClick = mnuV1Click
      end
      object mnuV2: TMenuItem
        Caption = 'List'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = mnuV2Click
      end
      object mnuV3: TMenuItem
        Caption = 'Details'
        GroupIndex = 1
        RadioItem = True
        OnClick = mnuV3Click
      end
      object mnuV4: TMenuItem
        Caption = 'Thumbnails'
        GroupIndex = 1
        RadioItem = True
        OnClick = mnuV4Click
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object mnuDrv: TMenuItem
        Caption = 'Show drives'
        GroupIndex = 2
        OnClick = mnuDrvClick
      end
      object mnuComb: TMenuItem
        Caption = 'Show combobox'
        GroupIndex = 2
        OnClick = mnuCombClick
      end
      object mnuFold: TMenuItem
        Caption = 'Show specials'
        GroupIndex = 2
        OnClick = mnuFoldClick
      end
      object mnuStat: TMenuItem
        Caption = 'Show status'
        GroupIndex = 2
        OnClick = mnuStatClick
      end
      object mnuHorz: TMenuItem
        Caption = 'Horiz. layout'
        GroupIndex = 2
        OnClick = mnuHorzClick
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object mnuHid: TMenuItem
        Caption = 'Show hidden'
        GroupIndex = 2
        ShortCut = 16456
        OnClick = mnuHidClick
      end
      object mnuOpenFold: TMenuItem
        Caption = 'Open folders in viewer'
        GroupIndex = 2
        OnClick = mnuOpenFoldClick
      end
      object mnuDock: TMenuItem
        Caption = 'Dock to viewer'
        GroupIndex = 2
        OnClick = mnuDockClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuAbout: TMenuItem
        Caption = 'About...'
        ShortCut = 32880
        OnClick = mnuAboutClick
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 264
    Top = 144
  end
end
