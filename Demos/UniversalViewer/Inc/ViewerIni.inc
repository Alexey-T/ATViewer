//Registry keys       
const
  cIniRegKey   = 'Software\UniversalViewer';
  cIniRegValue = 'ConfigurationFolder';

//Sections
const
  csOpt = 'Options';
  csToolbars = 'Toolbars';
  csPlugins = 'ListerPlugins';
  csShortcuts = 'Shortcuts';
  csUserTools = 'UserTools';
  csFonts = 'Fonts';
  csExt = 'Ext';
  csMedia = 'Media';
  csText = 'Text';

  csWindow = 'Window';
  csRecent = 'RecentFiles';
  csSearchOpt  = 'SearchOptions';
  csSearchHist = 'SearchHistory';
  csPrintOpt = 'Print';

//Keys
const
  //Options
  ccOLang = 'Lang';
  ccOIcons = 'Icons';

  ccUText   = 'UHText';
  ccUImage  = 'UHImage';
  ccUMedia  = 'UHMedia';
  ccUWeb    = 'UHWeb';
  ccUOffice = 'UHOffice';
  ccURtf    = 'UHRtf';
  ccUPlug   = 'UHPlug';

  ccHText   = 'HText';
  ccHImage  = 'HImage';
  ccHMedia  = 'HMedia';
  ccHWeb    = 'HWeb';
  ccHOffice = 'HOffice';
  ccHRtf    = 'HRtf';
  ccHPlug   = 'HPlug';

  ccORen = 'Ren';
  ccOShowMenu = 'Menu';
  ccOShowMenuIcons = 'MenuIcons';
  ccOShowToolbar = 'Toolbar';
  ccOShowToolbarFS = 'ToolbarFS';
  ccOShowBorder = 'Border';
  ccOShowStatusBar = 'Status';
  ccOShowNav = 'Nav';
  ccOShowHidden = 'Hidden';
  ccOShowOnTop = 'OnTop';
  ccOShowFullScreen = 'FScreen';
  ccOShowCfm = 'Cfm';
  ccOShowConv = 'Conv';
  ccOSingleInst = 'Single';
  ccOViewerTitle = 'Title';
  ccOViewerMode = 'Mode';

  //Fonts
  ccOFont = 'Text';
  ccOFontOem = 'Oem';
  ccOFontFooter = 'Footer';
  ccOFontGutter = 'Gutter';

  //Text
  ccOTextDetect = 'Detect';
  ccOTextDetectOEM = 'DetectOEM';
  ccOTextDetectUTF8 = 'DetectUTF8';
  ccOTextDetectSize = 'DetectSize';
  ccOTextDetectLimit = 'DetectLimit';

  ccOTextBackColor = 'CBack';
  ccOTextHexColor1 = 'CH1';
  ccOTextHexColor2 = 'CH2';
  ccOTextHexColorBack = 'CHBack';
  ccOTextGutterColor = 'CGut';
  ccOTextUrlColor = 'CUrl';
  ccOTextHiColor = 'CHi';

  ccOTextWidth = 'Width';
  ccOTextWidthFit = 'WidthFit';
  ccOTextOemSpec = 'OemSpec';

  ccOTextGutter = 'Gutter';
  ccOTextGutterLines = 'GutLines';
  ccOTextGutterLinesSize = 'GutLinesBuf';
  ccOTextGutterLinesCount = 'GutLinesCount';
  ccOTextGutterLinesStep = 'GutLinesStep';
  ccOTextGutterLinesExtUse = 'GutLinesExt';
  ccOTextGutterLinesExtList = 'GutLinesExtList';

  ccOTextSearchIndent = 'SIndent';
  ccOTextMaxLength = 'MaxLen';
  ccOTextMaxClipSize = 'MaxClip';
  ccOTextTabSize = 'TabSize';
                                
  ccOTextAutoReload = 'Reload';
  ccOTextAutoReloadBeep = 'ReloadBeep';
  ccOTextAutoReloadTail = 'ReloadTail';
  ccOTextAutoCopy = 'AutoCopy';

  ccOTextEncoding = 'Enc';
  ccOTextWrap = 'Wrap';
  ccOTextURLs = 'Url';
  ccOTextNonPrint = 'NonPrint';

  //Media
  ccOMediaMode = 'Mode';
  ccOMediaAutoPlay = 'AutoPlay';
  ccOMediaLoop = 'Loop';
  ccOMediaPlayCount = 'PlayCount';
  ccOMediaFit = 'Fit';
  ccOMediaFitOnlyBig = 'FitBig';
  ccOMediaFitWidth = 'FitX';
  ccOMediaFitHeight = 'FitY';
  ccOMediaFitWindow = 'FitWindow';
  ccOMediaCenter = 'Center';
  ccOMediaVolume = 'Volume';
  ccOMediaMute = 'Mute';
  ccOMediaAutoAdvance = 'AutoAdv';

  ccOImageColor = 'ImgColor';
  ccOImageResample = 'ImgRes';
  ccOImageTransparent = 'ImgTransp';
  ccOImageLabel = 'ImgLab';
  ccOImageLabelColor = 'ImgLabColor';
  ccOImageLabelColorErr = 'ImgLabColor2';

  //Web
  ccOWebOffline = 'WebOffline';
  ccOWebAcceptAll = 'WebAll';

  //Ext
  ccOExtText = 'Text';
  ccOExtImages = 'Images';
  ccOExtMedia = 'Media';
  ccOExtInet = 'Inet';
  ccOExtOoo = 'Ooo';
  ccOExtMso = 'Mso';
  ccOExtRTF = 'RTF';
  ccOExtConv = 'Conv';
  ccOExtIgnore = 'Ignore';
  ccOExtIgnoreUse = 'UIgnore';
  ccOExtImagesUse = 'UImg';
  ccOExtMediaUse = 'UMedia';
  ccOExtInetUse = 'UInet';
  ccOExtOooUse = 'UOoo';
  ccOExtMsoUse = 'UMso';
  ccOExtIView = 'IView';
  ccOExtIJL = 'IJL';

  //IView/IJL
  ccOIViewEnabled = 'IViewEn';
  ccOIViewExeName = 'IViewExe';
  ccOIViewPriority = 'IViewPrior';
  ccOIJLEnabled = 'IJLEn';

  //Misc
  ccToolbarMain = 'ToolbarMain';
  ccOModeUndetected = 'ModeUndetected';
  ccOModesDisabled = 'ModesDisabled';

  ccOFileSortOrder = 'FileSort';
  ccOFileNextMsg = 'FileNextMsg';
  ccOFileMoveDelay = 'FileMoveDelay';
  ccOFileSkipHidden = 'FileSkipHidden';
  ccOResolveLinks = 'ResolveLinks';
  ccOStatusUrlWidth = 'StatusUrlWidth';

  //Search
  ccOSearchSel = 'SearchSel';
  ccOSearchNoMsg = 'SearchNoMsg';
  ccOSearchNoCfm = 'SearchNoCfm';

  //History
  ccOGotoMode = 'Goto';
  ccOSaveRecents = 'ShowRecents';
  ccOSavePos = 'SavePos';
  ccOSaveSearch = 'SaveSearch';
  ccOSaveFolder = 'SaveFolder';
  ccOSaveFile = 'SaveFile';
  ccOLastFolder = 'Folder';
  ccOLastFolderSave = 'FolderSave';

  ccWinLeft = 'Left';
  ccWinTop = 'Top';
  ccWinWidth = 'Width';
  ccWinHeight = 'Height';
  ccWinMaximized = 'Max';

  //Plugins
  ccPDetect = '_detect';
  ccPEnabled = '_enabled';
  ccPPrior = 'PlugPrior';
  ccPTcVar = 'PlugTCVar';
  ccPHideKeys = 'PlugHideKeys';

  //Search options
  ccSrchWords = 'Words';
  ccSrchCase = 'Case';
  ccSrchBack = 'Back';
  ccSrchHex = 'Hex';
  ccSrchRegex = 'RegEx';
  ccSrchMLine = 'MLine';
  ccSrchOrigin = 'Origin';
  ccSrchAll = 'All';

  //User tools
  ccUCaption = '_Caption';
  ccUCommand = '_Command';
  ccUParams = '_Params';
  ccUActions = '_Actions';

  //Print options
  ccPFooter = 'Footer';
  ccPMarginL = 'MarginL';
  ccPMarginT = 'MarginT';
  ccPMarginR = 'MarginR';
  ccPMarginB = 'MarginB';

