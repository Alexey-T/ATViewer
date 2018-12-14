//-----------------------------------------------------
{$I ATViewerOptions.inc}
{$I ATStreamSearchOptions.inc}
{$I Compilers.inc}
{$I ViewerOptions.inc}

unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, IniFiles,
  TntClasses, TntForms, TntDialogs,
  
  ATBinHex, ATViewer, ATxCodepages,
  ATxNextFile, ATxToolbarList, ATxUserTools, ATxIniFile,
  UFormViewToolList, WLXProc,
  ToolWin, VistaAltFixUnit,
  XPMan, TntExtCtrls;

const
  cViewerVersion = '5.8.0';
  cViewerDate = 'aug 2018';

const
  cToolbarListDefault =
    'FileOpen FileSaveAs FileRename FileDelete Sep ' +
    'FilePrev FileNext Sep ' +
    'EditCopy EditFind EditFindNext Sep ' +
    'ViewShowNav ViewImageFit ViewFullScreen Sep ' +
    'ViewZoomIn ViewZoomOut ViewZoomOriginal Sep ' +
    'OptionsConfigure OptionsPlugins Sep ' +
    'UserTool1 UserTool2';

const
  EM_DISPLAYBAND = WM_USER + 51;
  cAppHandle = 100;

type
  TRecentMenus = array[0 .. 9] of TMenuItem;
  TPluginsList = array[1 .. WlxPluginsMaxCount] of record
    FFileName: TWlxFilename;
    FDetectStr: string;
    FEnabled: boolean;
  end;
  TViewerGotoMode = (
    vgPercent,
    vgLine,
    vgHex,
    vgDec,
    vgSelStart,
    vgSelEnd);


type
  TFormViewUV = class(TTntForm)
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuView: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuSep: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuViewTextOEM: TMenuItem;
    mnuViewTextANSI: TMenuItem;
    mnuViewTextWrap: TMenuItem;
    mnuViewImageFit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditFind: TMenuItem;
    mnuEditFindNext: TMenuItem;
    N4: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    mnuFileClose: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuViewWebOffline: TMenuItem;
    N5: TMenuItem;
    mnuFilePrint: TMenuItem;
    mnuFilePrintSetup: TMenuItem;
    mnuFilePrintPreview: TMenuItem;
    N6: TMenuItem;
    mnuOptionsConfigure: TMenuItem;
    mnuFileReload: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    N7: TMenuItem;
    mnuEditGoto: TMenuItem;
    N8: TMenuItem;
    mnuFilePrev: TMenuItem;
    mnuFileNext: TMenuItem;
    mnuOptionsPlugins: TMenuItem;
    ImageList1: TImageList;
    mnuViewAlwaysOnTop: TMenuItem;
    mnuViewFullScreen: TMenuItem;
    mnuOptions: TMenuItem;
    mnuFileOpenRecent: TMenuItem;
    mnuRecent0: TMenuItem;
    mnuRecent1: TMenuItem;
    mnuRecent2: TMenuItem;
    mnuRecent3: TMenuItem;
    mnuRecent4: TMenuItem;
    mnuRecent5: TMenuItem;
    mnuRecent6: TMenuItem;
    mnuRecent7: TMenuItem;
    mnuRecent8: TMenuItem;
    mnuRecent9: TMenuItem;
    N9: TMenuItem;
    mnuRecentClear: TMenuItem;
    MenuRecents: TPopupMenu;
    mnuBarRecent0: TMenuItem;
    mnuBarRecent1: TMenuItem;
    mnuBarRecent2: TMenuItem;
    mnuBarRecent3: TMenuItem;
    mnuBarRecent4: TMenuItem;
    mnuBarRecent5: TMenuItem;
    mnuBarRecent6: TMenuItem;
    mnuBarRecent7: TMenuItem;
    mnuBarRecent8: TMenuItem;
    mnuBarRecent9: TMenuItem;
    mnuViewMode8: TMenuItem;
    mnuViewMode7: TMenuItem;
    mnuViewMode6: TMenuItem;
    mnuViewMode5: TMenuItem;
    mnuViewMode4: TMenuItem;
    mnuViewMode3: TMenuItem;
    mnuViewMode2: TMenuItem;
    mnuViewMode1: TMenuItem;
    mnuViewImageMenu: TMenuItem;
    Toolbar: TToolBar;
    ToolButton4: TToolButton;
    mnuUserTool1: TMenuItem;
    mnuUserTool2: TMenuItem;
    mnuUserTool3: TMenuItem;
    mnuUserTool4: TMenuItem;
    mnuUserTool5: TMenuItem;
    mnuUserTool6: TMenuItem;
    mnuUserTool7: TMenuItem;
    mnuUserTool8: TMenuItem;
    MenuToolbar: TPopupMenu;
    mnuToolbarCustomize: TMenuItem;
    mnuOptionsToolbar: TMenuItem;
    mnuViewImageGrayscale: TMenuItem;
    mnuViewImageRotateLeft: TMenuItem;
    mnuViewImageRotateRight: TMenuItem;
    mnuViewTextMenu: TMenuItem;
    N3: TMenuItem;
    mnuViewWebMenu: TMenuItem;
    N12: TMenuItem;
    mnuViewWebGoBack: TMenuItem;
    mnuViewWebGoForward: TMenuItem;
    mnuViewImageFitOnlyBig: TMenuItem;
    mnuHelpWebMenu: TMenuItem;
    mnuHelpWebHomepage: TMenuItem;
    mnuHelpWebEmail: TMenuItem;
    N14: TMenuItem;
    mnuFileDelete: TMenuItem;
    mnuOptionsUserTools: TMenuItem;
    N15: TMenuItem;
    mnuViewImageShowLabel: TMenuItem;
    mnuTools: TMenuItem;
    mnuViewImageCenter: TMenuItem;
    TimerShow: TTimer;
    mnuViewInterfaceMenu: TMenuItem;
    mnuViewShowMenu: TMenuItem;
    mnuViewShowToolbar: TMenuItem;
    mnuViewShowStatusbar: TMenuItem;
    N16: TMenuItem;
    mnuOptionsAdvanced: TMenuItem;
    mnuOptionsEditIni: TMenuItem;
    mnuViewZoomMenu: TMenuItem;
    mnuViewZoomOut: TMenuItem;
    mnuViewZoomIn: TMenuItem;
    mnuViewZoomOriginal: TMenuItem;
    mnuViewImageFitWindow: TMenuItem;
    MenuImage: TPopupMenu;
    mnuImageFit: TMenuItem;
    mnuImageFitOnlyBig: TMenuItem;
    mnuImageCenter: TMenuItem;
    N17: TMenuItem;
    mnuImageFitWindow: TMenuItem;
    N18: TMenuItem;
    mnuImageRotateRight: TMenuItem;
    mnuImageRotateLeft: TMenuItem;
    mnuImageGrayscale: TMenuItem;
    mnuImageShowLabel: TMenuItem;
    mnuViewShowNav: TMenuItem;
    mnuHelpWebPlugins: TMenuItem;
    ViewerPanel: TPanel;
    Viewer: TATViewer;
    mnuOptionsEditIniHistory: TMenuItem;
    mnuFileRename: TMenuItem;
    mnuHelpContents: TMenuItem;
    mnuFileCopy: TMenuItem;
    mnuFileMove: TMenuItem;
    mnuOptionsSavePos: TMenuItem;
    mnuFileProp: TMenuItem;
    mnuViewImageNegative: TMenuItem;
    mnuViewImageFlipVert: TMenuItem;
    mnuViewImageFlipHorz: TMenuItem;
    mnuImageFlipHorz: TMenuItem;
    mnuImageFlipVert: TMenuItem;
    mnuImageNegative: TMenuItem;
    mnuViewTextMac: TMenuItem;
    mnuViewTextEncSubmenu: TMenuItem;
    mnuViewTextEncMenu: TMenuItem;
    N19: TMenuItem;
    mnuViewTextEncNext: TMenuItem;
    mnuViewTextEncPrev: TMenuItem;
    N21: TMenuItem;
    mnuViewTextNonPrint: TMenuItem;
    mnuViewTextTail: TMenuItem;
    mnuEditCopyToFile: TMenuItem;
    mnuEditFindPrev: TMenuItem;
    ImageListS: TImageList;
    mnuViewImageShowEXIF: TMenuItem;
    mnuImageShowEXIF: TMenuItem;
    mnuViewMediaEffect: TMenuItem;
    mnuEditPaste: TMenuItem;
    N22: TMenuItem;
    mnuFileEmail: TMenuItem;
    MenuModes: TPopupMenu;
    mnuModes1: TMenuItem;
    mnuModes2: TMenuItem;
    mnuModes3: TMenuItem;
    mnuModes4: TMenuItem;
    mnuModes5: TMenuItem;
    mnuModes6: TMenuItem;
    mnuModes7: TMenuItem;
    mnuModes8: TMenuItem;
    mnuFileCopyFN: TMenuItem;
    N25: TMenuItem;
    mnuBarRecentClear: TMenuItem;
    XPManifest1: TXPManifest;
    TimerWM: TTimer;
    mnuFileLink: TMenuItem;
    N1: TMenuItem;
    mnuMode: TMenuItem;
    mnuViewImageFitWidth: TMenuItem;
    mnuViewImageFitHeight: TMenuItem;
    mnuImageFitWidth: TMenuItem;
    mnuImageFitHeight: TMenuItem;
    StatusBar1: TStatusBar;
    N2: TMenuItem;
    mnuHelpForumEng: TMenuItem;
    mnuHelpForumRus: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuViewMode3Click(Sender: TObject);
    procedure mnuViewMode2Click(Sender: TObject);
    procedure mnuViewMode1Click(Sender: TObject);
    procedure mnuViewMode4Click(Sender: TObject);
    procedure mnuViewMode6Click(Sender: TObject);
    procedure mnuViewTextOEMClick(Sender: TObject);
    procedure mnuViewTextANSIClick(Sender: TObject);
    procedure mnuViewTextWrapClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuViewImageFitClick(Sender: TObject);
    procedure mnuEditFindClick(Sender: TObject);
    procedure mnuEditFindNextClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditSelectAllClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuViewMode5Click(Sender: TObject);
    procedure mnuViewWebOfflineClick(Sender: TObject);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuFilePrintPreviewClick(Sender: TObject);
    procedure mnuFilePrintSetupClick(Sender: TObject);
    procedure mnuOptionsConfigureClick(Sender: TObject);
    procedure mnuFileReloadClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuEditGotoClick(Sender: TObject);
    procedure mnuFilePrevClick(Sender: TObject);
    procedure mnuFileNextClick(Sender: TObject);
    procedure mnuViewMode7Click(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure mnuOptionsPluginsClick(Sender: TObject);
    procedure mnuEditCopyHexClick(Sender: TObject);
    procedure mnuViewMode8Click(Sender: TObject);
    procedure mnuViewAlwaysOnTopClick(Sender: TObject);
    procedure mnuViewFullScreenClick(Sender: TObject);
    procedure mnuRecent0Click(Sender: TObject);
    procedure mnuRecentClearClick(Sender: TObject);
    procedure btnImageRotate90Click(Sender: TObject);
    procedure btnImageRotate270Click(Sender: TObject);
    procedure btnImageNegativeClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuToolbarCustomizeClick(Sender: TObject);
    procedure mnuViewImageGrayscaleClick(Sender: TObject);
    procedure mnuViewWebGoBackClick(Sender: TObject);
    procedure mnuViewWebGoForwardClick(Sender: TObject);
    procedure mnuViewImageFitOnlyBigClick(Sender: TObject);
    procedure mnuHelpWebHomepageClick(Sender: TObject);
    procedure mnuHelpWebEmailClick(Sender: TObject);
    procedure mnuFileDeleteClick(Sender: TObject);
    procedure mnuOptionsUserToolsClick(Sender: TObject);
    procedure ViewerTextFileReload(Sender: TObject);
    procedure ViewerMediaPlaybackEnd(Sender: TObject);
    procedure ViewerPluginsAfterLoading(const APluginName: String);
    procedure ViewerPluginsBeforeLoading(const APluginName: String);
    procedure mnuViewImageShowLabelClick(Sender: TObject);
    procedure mnuViewImageCenterClick(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure mnuViewShowMenuClick(Sender: TObject);
    procedure mnuViewShowToolbarClick(Sender: TObject);
    procedure mnuViewShowStatusbarClick(Sender: TObject);
    procedure mnuOptionsEditIniClick(Sender: TObject);
    procedure mnuViewZoomInClick(Sender: TObject);
    procedure mnuViewZoomOutClick(Sender: TObject);
    procedure mnuViewZoomOriginalClick(Sender: TObject);
    procedure mnuViewImageFitWindowClick(Sender: TObject);
    procedure mnuViewShowNavClick(Sender: TObject);
    procedure mnuHelpWebPluginsClick(Sender: TObject);
    procedure mnuOptionsEditIniHistoryClick(Sender: TObject);
    procedure mnuFileRenameClick(Sender: TObject);
    procedure mnuHelpContentsClick(Sender: TObject);
    procedure mnuFileCopyClick(Sender: TObject);
    procedure mnuFileMoveClick(Sender: TObject);
    procedure mnuOptionsSavePosClick(Sender: TObject);
    procedure mnuFilePropClick(Sender: TObject);
    procedure mnuViewImageNegativeClick(Sender: TObject);
    procedure mnuViewImageFlipVertClick(Sender: TObject);
    procedure mnuViewImageFlipHorzClick(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuViewTextMacClick(Sender: TObject);
    procedure mnuViewTextEncMenuClick(Sender: TObject);
    procedure mnuViewTextEncPrevClick(Sender: TObject);
    procedure mnuViewTextEncNextClick(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure mnuViewTextNonPrintClick(Sender: TObject);
    procedure mnuViewTextTailClick(Sender: TObject);
    procedure mnuEditCopyToFileClick(Sender: TObject);
    procedure mnuRecent0MeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure mnuRecent0DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure mnuEditFindPrevClick(Sender: TObject);
    procedure mnuUserTool1Click(Sender: TObject);
    procedure mnuUserTool2Click(Sender: TObject);
    procedure mnuUserTool3Click(Sender: TObject);
    procedure mnuUserTool4Click(Sender: TObject);
    procedure mnuUserTool5Click(Sender: TObject);
    procedure mnuUserTool6Click(Sender: TObject);
    procedure mnuUserTool7Click(Sender: TObject);
    procedure mnuUserTool8Click(Sender: TObject);
    procedure mnuViewImageShowEXIFClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuFileEmailClick(Sender: TObject);
    procedure mnuFileCopyFNClick(Sender: TObject);
    procedure TimerWMTimer(Sender: TObject);
    procedure mnuFileLinkClick(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuViewImageFitWidthClick(Sender: TObject);
    procedure mnuViewImageFitHeightClick(Sender: TObject);
    procedure mnuHelpForumEngClick(Sender: TObject);
    procedure mnuHelpForumRusClick(Sender: TObject);
  private
    { Private declarations }
    OpenDialog1: TTntOpenDialog;
    SaveDialog1: TTntSaveDialog;
    PanelTop: TPanel;

    //Ini
    FIniName: WideString;
    FIniNameHist: WideString;
    FIniNameLS: AnsiString;
    FIni: TATIniFile;
    FIniHist: TATIniFile;
    FIniSave: TATIniFileSave;
    FIniHistSave: TATIniFileSave;

    //Fields
    FShowToolbarFS: boolean;
    FFileName: WideString;
    FFileFolder: WideString;
    FFileNameWM: WideString;

    FUText,
    FUImage,
    FUOffice,
    FUWeb,
    FURtf,
    FUPlug: boolean;
    FHText,
    FHImage,
    FHWeb,
    FHOffice,
    FHRtf,
    FHPlug: integer;

    FIconsName: string;
    FSingleInstance: boolean;
    FShowConv: boolean;
    FShowNavStart: boolean;
    FExtConv: string;
    FExtIgnore: string;
    FExtIgnoreUse: boolean;
    FSuggRename: boolean;
    FShowMenu: boolean;
    FShowStatusBar: boolean;
    FShowFullScreen: boolean;
    FShowNoFindError: boolean;
    FShowNoFindReset: boolean;
    FShowFindSelection: boolean;
    FFileNextMsg: boolean;
    FFileMoveDelay: integer;
    FResolveLinks: boolean;

    FViewerTitle: integer;
    FViewerMode: integer; //0, 1..8

    FFindHistory: TTntStringList;
    FFindText: WideString;
    FFindWords: boolean;
    FFindCase: boolean;
    FFindBack: boolean;
    FFindHex: boolean;
    FFindRegex: boolean;
    FFindMLine: boolean;
    FFindAll: boolean;
    FFindOrigin: boolean;
    FGotoMode: TViewerGotoMode;

    FSaveRecents: boolean;
    FSavePosition: boolean;
    FSaveSearch: boolean;
    FSaveFolder: boolean;
    FSaveFile: boolean;

    FPluginsTotalcmdVar: boolean;
    FPluginsHideKeys: boolean;

    FMediaAutoAdvance: boolean;
    FMediaFitWindow: boolean;
    FImageLabelVisible: boolean;
    FImageLabelColor: TColor;
    FImageLabelColorErr: TColor;

    FQuickViewMode: boolean; //Set by /Q param
    FNoTaskbarIcon: boolean;
    FBoundsRectOld: TRect;
    FActivateBusy: boolean;

    //Other fields
    FFileList: TATFileList;
    FRecentList: TTntStringList;
    FToolbarList: TToolbarList;
    FRecentMenus: TRecentMenus;
    FRecentMenusBar: TRecentMenus;
    FUserTools: TATUserTools;
    FFormFindProgress: TForm;
    FPluginsList: TPluginsList;
    FPluginsNum: integer;

    {$ifdef CMD}
    FStartupPosDo: boolean;
    FStartupPosLine: boolean;
    FStartupPosPercent: boolean;
    FStartupPos: Int64;
    FStartupPrint: boolean;
    FNavHandle: THandle;
    {$endif}

    procedure TestLClick(Sender: TObject);
    procedure TestRClick(Sender: TObject);
    procedure DoFileNext(ANext: boolean; AImgOnly: boolean = false);
    procedure FixLister;
    procedure InitConfigs;
    procedure SetIconsName(const Name: string);
    function IsImageListSaved: boolean;
    function SCollapseVars(const fn: string): string;
    function SelTextShort: WideString;
    function TextNotSelected: boolean;
    procedure ViewerStatusTextChange(Sender: TObject; const Text: WideString);
    procedure ViewerTitleChange(Sender: TObject; const Text: WideString);
    procedure UpdateOptions(AUpdateFitWindow: boolean = false);
    procedure UpdateImageLabel;
    procedure UpdateStatusBar;
    procedure UpdateCaption(const APluginName: string = '';
      ABeforeLoading: boolean = true;
      const AWebTitle: WideString = '');
    procedure UpdateFitWindow(AUseOriginalImageSizes: boolean);
    procedure ReloadFile;
    procedure CloseFile(AKeepList: boolean = false);
    procedure LoadOptions;
    procedure LoadNav;
    procedure SavePosition;
    procedure SaveOptionsInt;
    procedure SaveOptionsDlg;
    procedure LoadMargins;
    procedure SaveMargins;
    procedure LoadUserTools;
    procedure SaveUserTools;
    procedure ApplyUserTools;
    procedure LoadToolbar;
    procedure SaveToolbar;
    procedure ApplyToolbar;
    procedure ApplyToolbarCaptions;
    procedure InitPlugins;
    function LoadPluginPre(const sFN, sExt: string): boolean;
    procedure LoadPluginsOptions;
    procedure SavePluginsOptions;
    procedure ResizePlugin;
    function PluginPresent(const AFileName: TWlxFilename): boolean;
    function RecentItemIndex(Sender: TObject): integer;
    function ActiveFileName: WideString;

    {$ifdef CMD}
    function ReadCommandLine: WideString;
    {$endif}
    {$ifdef NAV}
    function GetShowNav: boolean;
    procedure SetShowNav(AValue: boolean);
    property ShowNav: boolean read GetShowNav write SetShowNav;
    procedure NavSync;
    procedure NavMove;
    {$endif}

    procedure AppActivate(Sender: TObject);
    procedure AppMessage(var Msg: TMsg; var Handled: boolean);
    procedure LoadShortcuts;
    procedure SaveShortcuts;
    procedure LoadRecents;
    procedure SaveRecents;
    procedure ApplyRecents;
    procedure InitRecents;
    procedure ClearRecents;
    procedure LoadSearch;
    procedure SaveSearch;
    procedure ClearSearch;
    procedure AddRecent(const S: WideString);
    function GetShowOnTop: boolean;
    procedure SetShowOnTop(AValue: boolean);
    function GetShowHidden: boolean;
    procedure SetShowHidden(AValue: boolean);
    procedure SetShowFullScreen(AValue: boolean);
    function GetShowToolbar: boolean;
    procedure SetShowToolbar(AValue: boolean);
    function GetShowBorder: boolean;
    procedure SetShowBorder(AValue: boolean);
    procedure SetShowMenu(AValue: boolean);
    function GetShowMenuIcons: boolean;
    procedure SetShowMenuIcons(AValue: boolean);
    function GetEnableMenu: boolean;
    procedure SetEnableMenu(AValue: boolean);
    procedure DoUserToolActions1(const Tool: TATUserTool);
    procedure DoUserToolActions2(const Tool: TATUserTool);
    procedure SearchPrepareAndStart;
    procedure InitFormFindProgress;
    procedure InitPreview;
    function GetStatusVisible: boolean;
    function GetFollowTail: boolean;
    procedure SetFollowTail(AValue: boolean);
    procedure ViewerOptionsChange(ASender: TObject);
    procedure ViewerFileLoad(S: TObject);
    procedure UpdateShortcuts;
    procedure DoFindFirst;
    procedure DoFindNext(AFindPrevious: boolean = false);
    procedure DoUserTool(AIndex: integer);

    function GetImageBorderWidth: Integer;
    function GetImageBorderHeight: Integer;
    function GetImageWidthActual: Integer;
    function GetImageHeightActual: Integer;
    function GetImageWidthActual2: Integer;
    function GetImageHeightActual2: Integer;
    function GetImageScrollVisible: Boolean;
    procedure SetImageScrollVisible(AValue: Boolean);

    property MediaFitWindow: boolean read FMediaFitWindow write FMediaFitWindow;
    property ImageBorderWidth: integer read GetImageBorderWidth;
    property ImageBorderHeight: integer read GetImageBorderHeight;
    property ImageWidthActual: integer read GetImageWidthActual;
    property ImageWidthActual2: integer read GetImageWidthActual2;
    property ImageHeightActual: integer read GetImageHeightActual;
    property ImageHeightActual2: integer read GetImageHeightActual2;
    property ImageScrollVisible: boolean read GetImageScrollVisible write SetImageScrollVisible;
    {$ifdef NAV}
    procedure DoFileRename;
    procedure DoFileDelete;
    procedure DoFileCopy;
    procedure DoFileMove;
    {$endif}
    function IsMHT: boolean;
    procedure PanelTopClick(Sender: TObject);
    function ConvName(const AFileName: WideString): WideString;
    procedure SetShowToolbarFS(Value: boolean);
    procedure Demo;
    function FTempPic(const ext: Widestring): Widestring;
  public
    { Public declarations }
    function LoadArc(const AFileName: WideString): boolean;
    function LoadFile(
      AFileName: WideString;
      AKeepList: boolean = false;
      ASyncNav: boolean = true;
      ADoConv: boolean = false): boolean;
    property FileName: WideString read FFileName write FFileName;
    property FileFolder: WideString read FFileFolder write FFileFolder;
    property IconsName: string read FIconsName write SetIconsName;
    property ShowOnTop: boolean read GetShowOnTop write SetShowOnTop;
    property ShowFullScreen: boolean read FShowFullScreen write SetShowFullScreen;
    property ShowMenu: boolean read FShowMenu write SetShowMenu;
    property ShowStatusBar: boolean read FShowStatusBar write FShowStatusBar;
    property ShowMenuIcons: boolean read GetShowMenuIcons write SetShowMenuIcons;
    property ShowToolbar: boolean read GetShowToolbar write SetShowToolbar;
    property ShowToolbarFS: boolean read FShowToolbarFS write SetShowToolbarFS;
    property ShowBorder: boolean read GetShowBorder write SetShowBorder;
    property ShowHidden: boolean read GetShowHidden write SetShowHidden;

    property EnableMenu: boolean read GetEnableMenu write SetEnableMenu;
    property MediaAutoAdvance: boolean read FMediaAutoAdvance write FMediaAutoAdvance;
    property FollowTail: boolean read GetFollowTail write SetFollowTail;

  protected
    { Protected declarations }
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
    procedure WMCommand(var Message: TMessage); message WM_COMMAND; //To process WM_COMMAND sent by plugins
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE; //To focus active embedded control
    {$ifdef NAV}
    //procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMDisp(var Msg: TMessage); message EM_DISPLAYBAND;
    procedure WMMove(var Msg: TMessage); message WM_MOVE;
    {$endif}
  end;

var
  FormViewUV: TFormViewUV;


//Functions to use in 3rd-party applications:
procedure OpenUniversalViewer(const AFileName: WideString);
procedure OpenUniversalViewerOptions;


implementation

uses
  ShellAPI, Consts,
  TntSysUtils, TntFileCtrl,
  ATxCodepageList,
  ATxSProc, ATxSHex, ATxFProc, ATxRegistry,
  ATxParamStr, ATxMsgProc, ATxVersionInfo,
  ATViewerMsg, ATxMsg, ATxShellExtension,
  ATxUtils, ATxIconsProc,
  ATStreamSearch, ATImageBox, WLXPlugin,
  ATxUnpack_Dll, ATxLnk, ATxPanel,
  ATxClipboard, ATxUtilExec,
  {$ifdef PREVIEW}
  ATPrintPreview,
  ATxPrintProc,
  {$endif}
  {$ifdef EXIF}
  UFormViewEXIF,
  {$endif}
  {$ifdef NAV}
  UFormView_Op,
  {$endif}
  UFormViewFindText, UFormViewFindProgress, UFormViewOptions,
  UFormViewGoto, UFormViewToolbar, UFormPluginsOptions,
  UFormViewRename, UFormViewEdit, UFormViewAbout;

{$R *.DFM}

{$I ViewerIni.inc}
{$I UFormView_FitWindow.pas}
{$ifdef NAV}
{$I UFormView_File.pas}
{$endif}

{ Constants }

const
  CR = #13#10;
  cFindCount = 30;

{ Helper functions }

//----------------------------------------------
procedure OpenUniversalViewer(const AFileName: WideString);
var
  Form: TFormViewUV;
begin
  Application.CreateForm(TFormViewUV, Form);
  with Form do
  begin
    FileName:= AFileName;
    Show;
  end;
end;

//----------------------------------------------
procedure OpenUniversalViewerOptions;
begin
  with TFormViewUV.Create(nil) do
  try
    FileName:= '';
    mnuOptionsConfigureClick(nil);
  finally
    Release;
  end;
end;

//----------------------------------------------
const
  cModesNumbered: array[1 .. 8] of TATViewerMode =
    (vmodeText, vmodeBinary, vmodeHex, vmodeMedia, vmodeWeb, vmodeUnicode, vmodeWLX, vmodeRTF);

function SListToModes(S: string): TATViewerModes;
  //
  function SGetListValue(var S: string): string;
  var
    i: integer;
  begin
    i:= Pos(' ', s);
    if i = 0 then i:= MaxInt;
    Result:= Copy(s, 1, i-1);
    Delete(s, 1, i);
  end;
  //
var
  SS: string;
  N: integer;
begin
  Result:= [];
  repeat
    S:= Trim(S);
    SS:= SGetListValue(S);
    if SS = '' then Break;
    N:= StrToIntDef(SS, 0);
    if (N >= Low(cModesNumbered)) and (N <= High(cModesNumbered)) then
      Include(Result, cModesNumbered[N]);
  until false;
end;

function IntegerToMode(N: integer; Default: TATViewerMode): TATViewerMode;
begin
  if (N >= Low(cModesNumbered)) and (N <= High(cModesNumbered)) then
    Result:= cModesNumbered[N]
  else
    Result:= Default;
end;

//----------------------------------------------
procedure CopyMenuItem(Source, Dest: TMenuItem);
begin
  Dest.Caption:= Source.Caption;
  Dest.Enabled:= Source.Enabled;
  Dest.Checked:= Source.Checked;
  Dest.ShortCut:= Source.ShortCut;
  Dest.OnClick:= Source.OnClick;
end;

procedure MsgTextNotSelected;
begin
  MsgWarning(MsgString(125));
end;


{ Additional helper functions }

function SBegin(const S, Par: WideString): boolean;
begin
  Result:= Copy(S, 1, Length(Par)) = Par;
end;

function SVal(const S: WideString): WideString;
var
  n: integer;
begin
  n:= Pos('=', S);
  if n = 0 then
    Result:= ''
  else
    Result:= Copy(S, n + 1, MaxInt);
end;


//----------------------------------------------
{
Configuration files are searched in these locations:
0) Folder specified in command line
1) UV folder, if Portable.ini file exists there;
2) Location stored in the registry under "HKEY_CURRENT_USER\Software\UniversalViewer";
3) Location stored in the registry under "HKEY_LOCAL_MACHINE\Software\UniversalViewer";
4) Default location: "%AppData%\ATViewer" folder.
}

function ConfigFolder: WideString;
var
  i: integer;
  S: WideString;
begin
  Result:= '';

  {$ifdef CMD}
  for i:= 1 to SParamCount do
    begin
    S:= SParamStrW(i);
    if SBegin(UpperCase(S), '/INI=') then
      begin
      Result:= SVal(S);
      if not IsDirExist(Result) then
        begin MsgError(SFormatW(MsgViewerErrCannotFindFolder, [Result])); Halt end;
      Exit
      end;
    end;
  {$endif}

  if IsFileExist(SParamDir + '\Portable.ini') then
    begin Result:= SParamDir; Exit end;

  Result:=
    SExpandVars(
    GetRegKeyStr(HKEY_CURRENT_USER, cIniRegKey, cIniRegValue,
    GetRegKeyStr(HKEY_LOCAL_MACHINE, cIniRegKey, cIniRegValue, '')));
  if Result <> '' then Exit;

  Result:= SExpandVars('%AppData%\ATViewer');
  //FGetAppDataPath + '\ATViewer'
end;

{$ifdef CMD}
{$I ViewerCmdLine.inc}
{$endif}


//----------------------------------------------
{ TFormView }

procedure TFormViewUV.InitConfigs;
var
  Folder: WideString;
begin
  Folder:= ConfigFolder;
  if not IsDirExist(Folder) then
    FCreateDir(Folder);

  FIniName:= Folder + '\Viewer.ini';
  FIniNameHist:= Folder + '\ViewerHistory.ini';
  FIniNameLS:= FGetShortName(Folder) + '\lsplugin.ini';

  FIni:= TATIniFile.Create(FIniName);
  FIniHist:= TATIniFile.Create(FIniNameHist);
  FIniSave:= TATIniFileSave.Create(FIniName);
  FIniHistSave:= TATIniFileSave.Create(FIniNameHist);
end;


function TFormViewUV.SCollapseVars(const fn: string): string;
  procedure CollapseVar(var S: string; const VarName: string);
  var
    Value: string;
  begin
    Value:= SExpandVars(VarName);
    if (Pos('%', Value)=0) and (Pos(Value, S)=1) then
      SReplace(S, Value, VarName);
  end;
begin
  Result:= fn;
  CollapseVar(Result, '%ATViewer%');
  if FPluginsTotalcmdVar then
    CollapseVar(Result, '%COMMANDER_PATH%');
end;

function TFormViewUV.GetShowToolbar: boolean;
begin
  Result:= Toolbar.Visible;
end;

procedure TFormViewUV.SetShowToolbar(AValue: boolean);
begin
  Toolbar.Visible:= AValue;
end;

function TFormViewUV.GetShowHidden: boolean;
begin
  Result:= not FFileList.SkipHidden;
end;

procedure TFormViewUV.SetShowHidden(AValue: boolean);
begin
  FFileList.SkipHidden:= not AValue;
  FFileList.ExtIgnore:= FExtIgnore;
  FFileList.ExtIgnoreUse:= FExtIgnoreUse;
end;

function TFormViewUV.GetShowBorder: boolean;
begin
  Result:= Viewer.BorderStyleInner = bsSingle;
end;

procedure TFormViewUV.SetShowBorder(AValue: boolean);
begin
  if AValue then
    Viewer.BorderStyleInner:= bsSingle
  else
    Viewer.BorderStyleInner:= bsNone;
end;

{$ifdef MENX}
procedure LoadShortcutsStr;
var
  k: TMenuKeyCap;
begin
  for k:= Low(MenuKeyCaps) to High(MenuKeyCaps) do
    MenuKeyCaps[k]:= MsgString(Ord(k) + 400);
end;

procedure DefaultShortcutsStr;
const
  cMenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);
var
  k: TMenuKeyCap;
begin
  for k:= Low(MenuKeyCaps) to High(MenuKeyCaps) do
    MenuKeyCaps[k]:= cMenuKeyCaps[k];
end;
{$endif}


procedure TFormViewUV.LoadShortcuts;
const
  SUnknown = '--';
var
  i: integer;
  S: string;
  Rec: PToolbarButtonRec;
begin
  {$ifdef MENX}
  DefaultShortcutsStr;
  {$endif}

  for i:= 1 to cToolbarButtonsMax do
    begin
    if not FToolbarList.GetAvail(i, Rec) then Break;
    S:= FIni.ReadString(csShortcuts, GetToolbarButtonId(Rec^), SUnknown);
    if S <> SUnknown then
      Rec.FMenuItem.Shortcut:= TextToShortCut(S);
    end;

  {$ifdef MENX}
  LoadShortcutsStr;
  {$endif}
end;

procedure TFormViewUV.SaveShortcuts;
var
  i: integer;
  S: string;
  Rec: PToolbarButtonRec;
begin
  {$ifdef MENX}
  DefaultShortcutsStr;
  {$endif}

  for i:= 1 to cToolbarButtonsMax do
    begin
    if not FToolbarList.GetAvail(i, Rec) then Break;
    if Rec.FMenuItem.Caption <> '-' then
      begin
      S:= ShortcutToText(Rec.FMenuItem.Shortcut);
      FIniSave.WriteString(csShortcuts, GetToolbarButtonId(Rec^), S);
      end;
    end;

  {$ifdef MENX}
  LoadShortcutsStr;
  {$endif}
end;

procedure TFormViewUV.LoadRecents;
var
  i: integer;
  S: WideString;
begin
  with FRecentList do
    begin
    Clear;
    for i:= 0 to High(TRecentMenus) do
      begin
      S:= UTF8Decode(FIniHist.ReadString(csRecent, IntToStr(i), ''));
      if S <> '' then
        if (not IsFilenameFixed(S)) or IsFileExist(S) then
          Add(S);
      end;
    end;
end;

procedure TFormViewUV.InitRecents;
begin
  FRecentMenus[0]:= mnuRecent0;
  FRecentMenus[1]:= mnuRecent1;
  FRecentMenus[2]:= mnuRecent2;
  FRecentMenus[3]:= mnuRecent3;
  FRecentMenus[4]:= mnuRecent4;
  FRecentMenus[5]:= mnuRecent5;
  FRecentMenus[6]:= mnuRecent6;
  FRecentMenus[7]:= mnuRecent7;
  FRecentMenus[8]:= mnuRecent8;
  FRecentMenus[9]:= mnuRecent9;

  FRecentMenusBar[0]:= mnuBarRecent0;
  FRecentMenusBar[1]:= mnuBarRecent1;
  FRecentMenusBar[2]:= mnuBarRecent2;
  FRecentMenusBar[3]:= mnuBarRecent3;
  FRecentMenusBar[4]:= mnuBarRecent4;
  FRecentMenusBar[5]:= mnuBarRecent5;
  FRecentMenusBar[6]:= mnuBarRecent6;
  FRecentMenusBar[7]:= mnuBarRecent7;
  FRecentMenusBar[8]:= mnuBarRecent8;
  FRecentMenusBar[9]:= mnuBarRecent9;
end;

procedure TFormViewUV.SaveRecents;
var
  i: integer;
begin
  with FRecentList do
    begin
    for i:= 0 to Count - 1 do
      FIniHistSave.WriteString(csRecent, IntToStr(i), UTF8Encode(Strings[i]));

    for i:= Count to High(TRecentMenus) do
      FIniHistSave.DeleteKey(csRecent, IntToStr(i));
    end;
end;

procedure TFormViewUV.ApplyRecents;
var
  i: integer;
  S: WideString;
begin
  for i:= 0 to High(TRecentMenus) do
    begin
    if i < FRecentList.Count then
      S:= FRecentList[i]
    else
      S:= '';
    FRecentMenus[i].Visible:= S <> '';
    FRecentMenusBar[i].Visible:= S <> '';
    end;

  mnuRecentClear.Enabled:= FRecentList.Count > 0;
  mnuBarRecentClear.Enabled:= mnuRecentClear.Enabled;
end;

procedure TFormViewUV.ClearRecents;
begin
  FRecentList.Clear;
  ApplyRecents;
  SaveRecents;
end;

procedure TFormViewUV.ClearSearch;
begin
  FFindHistory.Clear;
  FFindText:= '';
  FFindWords:= false;
  FFindCase:= false;
  FFindBack:= false;
  FFindHex:= false;
  FFindRegex:= false;
  FFindMLine:= false;
  FFindAll:= false;
  FFindOrigin:= false;
  SaveSearch;
end;


procedure TFormViewUV.AddRecent(const S: WideString);
var
  i: integer;
begin
  if FSaveRecents then
    if S <> '' then
      begin
      with FRecentList do
        begin
        i:= IndexOf(S);
        if i >= 0 then Delete(i);
        Insert(0, S);
        while Count > High(TRecentMenus) + 1 do
          Delete(Count-1);
        end;
      ApplyRecents;
      end;
end;


procedure TFormViewUV.LoadSearch;
var
  i: integer;
  S: WideString;
begin
  with FFindHistory do
    begin
    Clear;

    for i:= 0 to cFindCount - 1 do
      begin
      S:= UTF8Decode(FIniHist.ReadString(csSearchHist, IntToStr(i), ''));
      if S <> '' then Add(S);
      end;

    if Count > 0 then
      FFindText:= Strings[0];
    end;

  FFindWords:= FIniHist.ReadBool(csSearchOpt, ccSrchWords, FFindWords);
  FFindCase:= FIniHist.ReadBool(csSearchOpt, ccSrchCase, FFindCase);
  FFindBack:= FIniHist.ReadBool(csSearchOpt, ccSrchBack, FFindBack);
  FFindHex:= FIniHist.ReadBool(csSearchOpt, ccSrchHex, FFindHex);
  FFindRegex:= FIniHist.ReadBool(csSearchOpt, ccSrchRegex, FFindRegex);
  FFindMLine:= FIniHist.ReadBool(csSearchOpt, ccSrchMLine, FFindMLine);
  FFindAll:= FIniHist.ReadBool(csSearchOpt, ccSrchAll, FFindAll);
  FFindOrigin:= FIniHist.ReadBool(csSearchOpt, ccSrchOrigin, FFindOrigin);
end;

procedure TFormViewUV.LoadNav;
begin
  {$ifdef NAV}
  if FShowNavStart then
    ShowNav:= true;
  {$endif}
end;

procedure TFormViewUV.LoadOptions;
begin
  Left:= FIniHist.ReadInteger(csWindow, ccWinLeft, Left);
  Top:= FIniHist.ReadInteger(csWindow, ccWinTop, Top);
  Width:= FIniHist.ReadInteger(csWindow, ccWinWidth, Width);
  Height:= FIniHist.ReadInteger(csWindow, ccWinHeight, Height);
  if FIniHist.ReadBool(csWindow, ccWinMaximized, false) then
    WindowState:= wsMaximized;

  SetMsgLanguage(FIni.ReadString(csOpt, ccOLang, 'English'));
  IconsName:= FIni.ReadString(csOpt, ccOIcons, 'Tango 22x22');
  FSingleInstance:= FIni.ReadBool(csOpt, ccOSingleInst, FSingleInstance);

  FViewerTitle:= FIni.ReadInteger(csOpt, ccOViewerTitle, FViewerTitle);
  FViewerMode:= FIni.ReadInteger(csOpt, ccOViewerMode, FViewerMode);
  if FViewerMode > 0 then
    begin
    Viewer.ModeDetect:= false;
    Viewer.Mode:= IntegerToMode(FViewerMode, vmodeText);
    end;

  FSuggRename:= FIni.ReadBool(csOpt, ccORen, true);
  ShowMenu:= FIni.ReadBool(csOpt, ccOShowMenu, ShowMenu);
  ShowMenuIcons:= FIni.ReadBool(csOpt, ccOShowMenuIcons, false);
  ShowToolbar:= FIni.ReadBool(csOpt, ccOShowToolbar, ShowToolbar);
  ShowToolbarFS:= FIni.ReadBool(csOpt, ccOShowToolbarFS, true);
  ShowBorder:= FIni.ReadBool(csOpt, ccOShowBorder, ShowBorder);
  ShowStatusBar:= FIni.ReadBool(csOpt, ccOShowStatusBar, ShowStatusBar);
  ShowHidden:= FIni.ReadBool(csOpt, ccOShowHidden, false);
  Viewer.ModeUndetectedCfm:= FIni.ReadBool(csOpt, ccOShowCfm, true);
  FShowConv:= FIni.ReadBool(csOpt, ccOShowConv, true);
  FShowNavStart:= FIni.ReadBool(csOpt, ccOShowNav, false);

  FUText:= FIni.ReadBool(csOpt, ccUText, false);
  FUImage:= FIni.ReadBool(csOpt, ccUImage, false);
  FUWeb:= FIni.ReadBool(csOpt, ccUWeb, false);
  FUOffice:= FIni.ReadBool(csOpt, ccUOffice, false);
  FUPlug:= FIni.ReadBool(csOpt, ccUPlug, false);

  FHText:= FIni.ReadInteger(csOpt, ccHText, 300);
  FHImage:= FIni.ReadInteger(csOpt, ccHImage, 300);
  FHWeb:= FIni.ReadInteger(csOpt, ccHWeb, 300);
  FHOffice:= FIni.ReadInteger(csOpt, ccHOffice, 300);
  FHPlug:= FIni.ReadInteger(csOpt, ccHPlug, 300);

  FSaveRecents:= FIni.ReadBool(csOpt, ccOSaveRecents, FSaveRecents);
  FSavePosition:= FIni.ReadBool(csOpt, ccOSavePos, FSavePosition);
  FSaveSearch:= FIni.ReadBool(csOpt, ccOSaveSearch, FSaveSearch);
  FSaveFolder:= FIni.ReadBool(csOpt, ccOSaveFolder, FSaveFolder);
  FSaveFile:= FIni.ReadBool(csOpt, ccOSaveFile, FSaveFile);

  FFileList.SortOrder:= TATFileSort(FIni.ReadInteger(csOpt, ccOFileSortOrder, integer(FFileList.SortOrder)));
  //FFileList.SkipHidden:= FIni.ReadBool(csOpt, ccOFileSkipHidden, FFileList.SkipHidden);
  FFileNextMsg:= FIni.ReadBool(csOpt, ccOFileNextMsg, FFileNextMsg);
  FFileMoveDelay:= FIni.ReadInteger(csOpt, ccOFileMoveDelay, FFileMoveDelay);
  with StatusBar1.Panels[2] do
    Width:= FIni.ReadInteger(csOpt, ccOStatusUrlWidth, Width);

  FResolveLinks:= FIni.ReadBool(csOpt, ccOResolveLinks, true);
  FShowNoFindError:= FIni.ReadBool(csOpt, ccOSearchNoMsg, FShowNoFindError);
  FShowNoFindReset:= FIni.ReadBool(csOpt, ccOSearchNoCfm, FShowNoFindReset);
  FShowFindSelection:= FIni.ReadBool(csOpt, ccOSearchSel, FShowFindSelection);

  FPluginsTotalcmdVar:= FIni.ReadBool(csOpt, ccPTcVar, FPluginsTotalcmdVar);
  FPluginsHideKeys:= FIni.ReadBool(csOpt, ccPHideKeys, FPluginsHideKeys);
  MediaAutoAdvance:= FIni.ReadBool(csMedia, ccOMediaAutoAdvance, MediaAutoAdvance);
  MediaFitWindow:= FIni.ReadBool(csMedia, ccOMediaFitWindow, MediaFitWindow);

  ShowOnTop:= FIni.ReadBool(csOpt, ccOShowOnTop, ShowOnTop);
  ShowFullScreen:= FIni.ReadBool(csOpt, ccOShowFullScreen, ShowFullScreen);

  LoadToolbar;
  LoadShortcuts;
  LoadSearch;
  LoadMargins;
  ApplyToolbar;
  LoadRecents;
  ApplyRecents;

  with Viewer do
    begin
    ModeUndetected:= IntegerToMode(FIni.ReadInteger(csOpt, ccOModeUndetected, 0), ModeUndetected);
    ModesDisabledForDetect:= SListToModes(FIni.ReadString(csOpt, ccOModesDisabled, ''));

    TextDetect:= FIni.ReadBool(csText, ccOTextDetect, TextDetect);
    TextDetectOEM:= FIni.ReadBool(csText, ccOTextDetectOEM, TextDetectOEM);
    TextDetectUTF8:= FIni.ReadBool(csText, ccOTextDetectUTF8, TextDetectUTF8);
    TextDetectSize:= FIni.ReadInteger(csText, ccOTextDetectSize, TextDetectSize);
    TextDetectLimit:= FIni.ReadInteger(csText, ccOTextDetectLimit, TextDetectLimit);
    TextEncoding:= TATEncoding(FIni.ReadInteger(csText, ccOTextEncoding, integer(TextEncoding)));
    TextWrap:= FIni.ReadBool(csText, ccOTextWrap, TextWrap);
    TextUrlHilight:= FIni.ReadBool(csText, ccOTextURLs, TextUrlHilight);
    TextNonPrintable:= FIni.ReadBool(csText, ccOTextNonPrint, TextNonPrintable);
    TextWidth:= FIni.ReadInteger(csText, ccOTextWidth, 80);
    TextSearchIndentVert:= FIni.ReadInteger(csText, ccOTextSearchIndent, TextSearchIndentVert);
    TextSearchIndentHorz:= TextSearchIndentVert;
    TextTabSize:= FIni.ReadInteger(csText, ccOTextTabSize, TextTabSize);
    TextMaxLengths[vbmodeText]:= FIni.ReadInteger(csText, ccOTextMaxLength, TextMaxLengths[vbmodeText]);
    TextMaxLengths[vbmodeUnicode]:= TextMaxLengths[vbmodeText];
    TextMaxClipboardDataSizeMb:= FIni.ReadInteger(csText, ccOTextMaxClipSize, TextMaxClipboardDataSizeMb);

    {$ifdef OFFLINE}
    WebOffline:= FIni.ReadBool(csOpt, ccOWebOffline, false);
    {$endif}
    WebAcceptAllFiles:= false;
      //FIni.ReadBool(csOpt, ccOWebAcceptAll, false);

    //Fonts
    SSetFont(TextFont, FIni.ReadString(csFonts, ccOFont, ''));
    SSetFont(TextFontOem, FIni.ReadString(csFonts, ccOFontOem, ''));
    SSetFont(TextFontFooter, FIni.ReadString(csFonts, ccOFontFooter, ''));
    SSetFont(TextFontGutter, FIni.ReadString(csFonts, ccOFontGutter, ''));

    TextColor:= FIni.ReadInteger(csText, ccOTextBackColor, TextColor);
    TextColorHex:= FIni.ReadInteger(csText, ccOTextHexColor1, TextColorHex);
    TextColorHex2:= FIni.ReadInteger(csText, ccOTextHexColor2, TextColorHex2);
    TextColorHexBack:= FIni.ReadInteger(csText, ccOTextHexColorBack, TextColorHexBack);
    TextColorGutter:= FIni.ReadInteger(csText, ccOTextGutterColor, TextColorGutter);
    TextColorURL:= FIni.ReadInteger(csText, ccOTextUrlColor, TextColorURL);
    TextColorHi:= FIni.ReadInteger(csText, ccOTextHiColor, TextColorHi);

    TextWidthFit:= FIni.ReadBool(csText, ccOTextWidthFit, TextWidthFit);
    TextWidthFitHex:= TextWidthFit;
    TextWidthFitUHex:= TextWidthFit;
    TextOemSpecial:= FIni.ReadBool(csText, ccOTextOemSpec, Win32Platform <> VER_PLATFORM_WIN32_NT);

    TextGutter:= FIni.ReadBool(csText, ccOTextGutter, true);
    TextGutterLines:= FIni.ReadBool(csText, ccOTextGutterLines, false);
    TextGutterLinesBufSize:= FIni.ReadInteger(csText, ccOTextGutterLinesSize, 300) * 1024;
    TextGutterLinesCount:= FIni.ReadInteger(csText, ccOTextGutterLinesCount, 2000);
    TextGutterLinesStep:= FIni.ReadInteger(csText, ccOTextGutterLinesStep, TextGutterLinesStep);
    TextGutterLinesExtUse:= FIni.ReadBool(csText, ccOTextGutterLinesExtUse, false);
    TextGutterLinesExtList:= FIni.ReadString(csText, ccOTextGutterLinesExtList, 'c,cpp,h,hpp,pas,dpr,bas,asm,mak,inc');

    TextAutoReload:= FIni.ReadBool(csText, ccOTextAutoReload, TextAutoReload);
    TextAutoReloadBeep:= FIni.ReadBool(csText, ccOTextAutoReloadBeep, TextAutoReloadBeep);
    TextAutoReloadFollowTail:= FIni.ReadBool(csText, ccOTextAutoReloadTail, TextAutoReloadFollowTail);
    TextAutoCopy:= FIni.ReadBool(csText, ccOTextAutoCopy, TextAutoCopy);

    ImageColor:= FIni.ReadInteger(csMedia, ccOImageColor, ImageColor);
    ImageResample:= FIni.ReadBool(csMedia, ccOImageResample, true);
    ImageTransparent:= FIni.ReadBool(csMedia, ccOImageTransparent, false);
    ImageErrorMessageBox:= false;
    FImageLabelVisible:= FIni.ReadBool(csMedia, ccOImageLabel, FImageLabelVisible);
    FImageLabelColor:= FIni.ReadInteger(csMedia, ccOImageLabelColor, FImageLabelColor);
    FImageLabelColorErr:= FIni.ReadInteger(csMedia, ccOImageLabelColorErr, FImageLabelColorErr);

    MediaFit:= FIni.ReadBool(csMedia, ccOMediaFit, MediaFit);
    MediaFitOnlyBig:= FIni.ReadBool(csMedia, ccOMediaFitOnlyBig, MediaFitOnlyBig);
    MediaFitWidth:= FIni.ReadBool(csMedia, ccOMediaFitWidth, MediaFitWidth);
    MediaFitHeight:= FIni.ReadBool(csMedia, ccOMediaFitHeight, MediaFitHeight);
    MediaCenter:= FIni.ReadBool(csMedia, ccOMediaCenter, MediaCenter);

    with ATViewerOptions do
      begin
      ExtText:= FIni.ReadString(csExt, ccOExtText, ExtText);
      ExtImages:= FIni.ReadString(csExt, ccOExtImages, ExtImages);
      //if Pos('jp2', ExtImages) = 0 then
      //  ExtImages:= ExtImages + ',jp2,jpc,pnm,ras,mis';
      ExtInet:= FIni.ReadString(csExt, ccOExtInet, ExtInet);
      ExtRTF:= FIni.ReadString(csExt, ccOExtRTF, ExtRTF);
      FExtConv:= FIni.ReadString(csExt, ccOExtConv, FExtConv);
      FExtIgnore:= FIni.ReadString(csExt, ccOExtIgnore, FExtIgnore);
      FExtIgnoreUse:= FIni.ReadBool(csExt, ccOExtIgnoreUse, FExtIgnoreUse);
      ShowHidden:= ShowHidden; //upd FFileList.ExtIgnore

      ExtImagesUse:= FIni.ReadBool(csExt, ccOExtImagesUse, ExtImagesUse);
      ExtInetUse:= FIni.ReadBool(csExt, ccOExtInetUse, ExtInetUse);
      end;

    PluginsHighPriority:= FIni.ReadBool(csOpt, ccPPrior, PluginsHighPriority);

    {$ifdef IVIEW}
    with IViewIntegration do
      begin
      Enabled:= FIni.ReadBool(csOpt, ccOIViewEnabled, Enabled);
      ExeName:= SExpandVars(FIni.ReadString(csOpt, ccOIViewExeName, ExeName));
      ExtList:= FIni.ReadString(csExt, ccOExtIView, ExtList);
      HighPriority:= FIni.ReadBool(csOpt, ccOIViewPriority, HighPriority);
      end;
    {$endif}

    {$ifdef IJL}
    with IJLIntegration do
      begin
      Enabled:= FIni.ReadBool(csOpt, ccOIJLEnabled, Enabled);
      ExtList:= FIni.ReadString(csExt, ccOExtIJL, ExtList);
      end;
    {$endif}
    end;

  //ViewerHistory.ini
  FGotoMode:= TViewerGotoMode(FIniHist.ReadInteger(csOpt, ccOGotoMode, integer(FGotoMode)));
  OpenDialog1.InitialDir:= UTF8Decode(FIniHist.ReadString(csWindow, ccOLastFolder, ''));
  SaveDialog1.InitialDir:= UTF8Decode(FIniHist.ReadString(csWindow, ccOLastFolderSave, ''));
  FFileFolder:= OpenDialog1.InitialDir;
end;

procedure TFormViewUV.LoadUserTools;
var
  i: integer;
  Tool: TATUserTool;
begin
  ClearUserTools(FUserTools);

  for i:= Low(TATUserTools) to High(TATUserTools) do
    begin
    ClearUserTool(Tool);
    Tool.FCaption:= FIni.ReadString(csUserTools, IntToStr(i) + ccUCaption, '');
    Tool.FCommand:= UTF8Decode(FIni.ReadString(csUserTools, IntToStr(i) + ccUCommand, ''));
    Tool.FParams:= UTF8Decode(FIni.ReadString(csUserTools, IntToStr(i) + ccUParams, ''));
    Tool.FActions:= FIni.ReadString(csUserTools, IntToStr(i) + ccUActions, '');
    AddUserTool(FUserTools, Tool);
    end;

  ApplyUserTools;
end;

procedure TFormViewUV.SaveUserTools;
var
  i: integer;
begin
  for i:= Low(TATUserTools) to High(TATUserTools) do
    with FUserTools[i] do
      begin
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUCaption, FCaption);
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUCommand, UTF8Encode(FCommand));
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUParams, UTF8Encode(FParams));
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUActions, FActions);
      end;
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ApplyUserTools;
var
  i, N: integer;
  S: WideString;
  MItems: array[Low(TATUserTools)..High(TATUserTools)] of TMenuItem;
begin
  //Initialize menu array
  MItems[1]:= mnuUserTool1;
  MItems[2]:= mnuUserTool2;
  MItems[3]:= mnuUserTool3;
  MItems[4]:= mnuUserTool4;
  MItems[5]:= mnuUserTool5;
  MItems[6]:= mnuUserTool6;
  MItems[7]:= mnuUserTool7;
  MItems[8]:= mnuUserTool8;

  //Delete old tools icons from ImageList
  for i:= High(TATUserTools) downto Low(TATUserTools) do
    with MItems[i] do
      if (ImageIndex >= 0) and (ImageIndex < ImageList1.Count) then
        begin
        N:= ImageIndex;
        ImageIndex:= -1;
        ImageList1.Delete(N);
        end;

  //Add/update tools captions and icons
  N:= NumOfUserTools(FUserTools);
  mnuTools.Visible:= mnuFile.Visible and (N > 0);

  for i:= Low(TATUserTools) to High(TATUserTools) do
    with FUserTools[i] do
      with MItems[i] do
        begin
        if (i <= N) then
          begin
          Visible:= true;
          S:= SExpandVars(FCommand);
          ImageIndex:= AddCommandIcon(S, ImageList1);
          Caption:= Format('&%d  %s', [i, FCaption]);
          end
        else
          begin
          Visible:= false;
          ImageIndex:= -1;
          Caption:= '';
          end;
        end;
end;

procedure TFormViewUV.mnuUserTool1Click(Sender: TObject);
begin
  DoUserTool(1);
end;

procedure TFormViewUV.mnuUserTool2Click(Sender: TObject);
begin
  DoUserTool(2);
end;

procedure TFormViewUV.mnuUserTool3Click(Sender: TObject);
begin
  DoUserTool(3);
end;

procedure TFormViewUV.mnuUserTool4Click(Sender: TObject);
begin
  DoUserTool(4);
end;

procedure TFormViewUV.mnuUserTool5Click(Sender: TObject);
begin
  DoUserTool(5);
end;

procedure TFormViewUV.mnuUserTool6Click(Sender: TObject);
begin
  DoUserTool(6);
end;

procedure TFormViewUV.mnuUserTool7Click(Sender: TObject);
begin
  DoUserTool(7);
end;

procedure TFormViewUV.mnuUserTool8Click(Sender: TObject);
begin
  DoUserTool(8);
end;

procedure TFormViewUV.DoUserTool(AIndex: integer);
var
  ACmd, AParams: WideString;
begin
  if Viewer.FileName = '' then Exit;
  with FUserTools[AIndex] do
  begin
    ACmd:= SExpandVars(FCommand);
    AParams:= SExpandVars(FParams);
    SReplaceAllW(AParams, '{PosLine}', IntToStr(Viewer.PosLine));
    SReplaceAllW(AParams, '{PosOffset}', IntToStr(Viewer.PosOffset));
    SReplaceAllW(AParams, '"', '|');

    {$ifdef NAV}
    if IsFileExist(ACmd) then
    begin
      DoUserToolActions1(FUserTools[AIndex]);
      NavOp('tool', ACmd, AParams, FFileName, '', False{fWait});
      DoUserToolActions2(FUserTools[AIndex])
    end
    else
      MsgError(SFormatW(MsgString(0151), [ACmd]));
    {$endif}
  end;
end;

procedure TFormViewUV.DoUserToolActions1(const Tool: TATUserTool);
begin
  if UserToolHasAction(Tool, 'SelectAll') then
    Viewer.SelectAll;
  if UserToolHasAction(Tool, 'Copy') then
    Viewer.CopyToClipboard;
end;

procedure TFormViewUV.DoUserToolActions2(const Tool: TATUserTool);
begin
  if UserToolHasAction(Tool, 'Exit') then
    mnuFileExitClick(Self);
end;


procedure TFormViewUV.SaveSearch;
var
  i: integer;
begin
  with FFindHistory do
    begin
    for i:= 0 to Count - 1 do
      FIniHistSave.WriteString(csSearchHist, IntToStr(i), UTF8Encode(Strings[i]));
    for i:= Count to cFindCount - 1 do
      FIniHistSave.DeleteKey(csSearchHist, IntToStr(i));
    end;

  FIniHistSave.WriteBool(csSearchOpt, ccSrchWords, FFindWords);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchCase, FFindCase);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchBack, FFindBack);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchHex, FFindHex);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchRegex, FFindRegex);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchMLine, FFindMLine);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchAll, FFindAll);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchOrigin, FFindOrigin);
end;

procedure TFormViewUV.SavePosition;
const
  DefWidth = 630;
  DefHeight = 450;
begin
  if (WindowState <> wsMaximized) and (not ShowFullScreen) then
    begin
    //Save current position, if valid
    if (ClientWidth > 0) and (ClientHeight > 0) and
      not (FMediaFitWindow) then
      begin
      FIniHistSave.WriteInteger(csWindow, ccWinLeft, Left);
      FIniHistSave.WriteInteger(csWindow, ccWinTop, Top);
      FIniHistSave.WriteInteger(csWindow, ccWinWidth, Width);
      FIniHistSave.WriteInteger(csWindow, ccWinHeight, Height);
      end;
    end
  else
    begin
    if ShowFullScreen then
      begin
      //Save previous (not Full Screen) position
      with FBoundsRectOld do
        begin
        FIniHistSave.WriteInteger(csWindow, ccWinLeft, Left);
        FIniHistSave.WriteInteger(csWindow, ccWinTop, Top);
        FIniHistSave.WriteInteger(csWindow, ccWinWidth, Right-Left);
        FIniHistSave.WriteInteger(csWindow, ccWinHeight, Bottom-Top);
        end;
      end
    else
      begin
      //Save default position
      FIniHistSave.WriteInteger(csWindow, ccWinLeft, (Screen.Width - DefWidth) div 2);
      FIniHistSave.WriteInteger(csWindow, ccWinTop, (Screen.Height - DefHeight) div 2);
      FIniHistSave.WriteInteger(csWindow, ccWinWidth, DefWidth);
      FIniHistSave.WriteInteger(csWindow, ccWinHeight, DefHeight);
      end;
    end;

  //Save maximized state
  FIniHistSave.WriteBool(csWindow, ccWinMaximized, WindowState = wsMaximized);
  FIniHistSave.UpdateFile;
end;

//Saves options changable in main menu
procedure TFormViewUV.SaveOptionsInt;
begin
  if FSavePosition then
    SavePosition;

  with Viewer do
    begin
    FIniSave.WriteBool(csMedia, ccOMediaFit, MediaFit);
    FIniSave.WriteBool(csMedia, ccOMediaFitOnlyBig, MediaFitOnlyBig);
    FIniSave.WriteBool(csMedia, ccOMediaFitWidth, MediaFitWidth);
    FIniSave.WriteBool(csMedia, ccOMediaFitHeight, MediaFitHeight);
    FIniSave.WriteBool(csMedia, ccOMediaCenter, MediaCenter);
    FIniSave.WriteBool(csMedia, ccOMediaFitWindow, MediaFitWindow);

    FIniSave.WriteString(csFonts, ccOFont, SFontToString(TextFont));
    FIniSave.WriteString(csFonts, ccOFontOem, SFontToString(TextFontOem));

    FIniSave.WriteInteger(csText, ccOTextEncoding, integer(TextEncoding));
    FIniSave.WriteBool(csText, ccOTextWrap, TextWrap);
    FIniSave.WriteBool(csText, ccOTextNonPrint, TextNonPrintable);
    FIniSave.WriteBool(csText, ccOTextAutoReload, TextAutoReload);
    FIniSave.WriteBool(csText, ccOTextAutoReloadTail, TextAutoReloadFollowTail);

    {$ifdef OFFLINE}
    FIniSave.WriteBool(csOpt, ccOWebOffline, WebOffline);
    {$endif}
    FIniSave.WriteBool(csOpt, ccOWebAcceptAll, WebAcceptAllFiles);

    //ViewerHistory
    FIniHistSave.WriteInteger(csOpt, ccOGotoMode, integer(FGotoMode));
    end;

  FIniSave.WriteBool(csMedia, ccOImageLabel, FImageLabelVisible);
  FIniSave.WriteBool(csOpt, ccOShowOnTop, ShowOnTop);
  FIniSave.WriteBool(csOpt, ccOShowFullScreen, ShowFullScreen);
  FIniSave.WriteBool(csOpt, ccOShowMenu, ShowMenu);
  FIniSave.WriteBool(csOpt, ccOShowToolbar, ShowToolbar);
  FIniSave.WriteBool(csOpt, ccOShowToolbarFS, ShowToolbarFS);
  FIniSave.WriteBool(csOpt, ccOShowStatusBar, ShowStatusBar);
  FIniSave.WriteBool(csOpt, ccOShowNav, FShowNavStart);

  if FSaveFolder then
    begin
    FIniHistSave.WriteString(csWindow, ccOLastFolder, UTF8Encode(OpenDialog1.InitialDir));
    FIniHistSave.WriteString(csWindow, ccOLastFolderSave, UTF8Encode(SaveDialog1.InitialDir));
    end
  else
    begin
    FIniHistSave.WriteString(csWindow, ccOLastFolder, '');
    FIniHistSave.WriteString(csWindow, ccOLastFolderSave, '');
    end;

  if FSaveRecents then SaveRecents;
  if FSaveSearch then SaveSearch;

  FIniSave.UpdateFile;
  FIniHistSave.UpdateFile;
end;

//Saves options changable only in Configure dialog
procedure TFormViewUV.SaveOptionsDlg;
begin
  FIniSave.WriteString(csOpt, ccOLang, SMsgLanguage);
  FIniSave.WriteString(csOpt, ccOIcons, IconsName);
  FIniSave.WriteBool(csOpt, ccOSingleInst, FSingleInstance);
  FIniSave.WriteInteger(csOpt, ccOViewerTitle, FViewerTitle);
  FIniSave.WriteInteger(csOpt, ccOViewerMode, FViewerMode);

  FIniSave.WriteBool(csOpt, ccORen, FSuggRename);
  FIniSave.WriteBool(csOpt, ccOShowMenu, ShowMenu);
  FIniSave.WriteBool(csOpt, ccOShowMenuIcons, ShowMenuIcons);
  FIniSave.WriteBool(csOpt, ccOShowToolbar, ShowToolbar);
  FIniSave.WriteBool(csOpt, ccOShowToolbarFS, ShowToolbarFS);
  FIniSave.WriteBool(csOpt, ccOShowStatusBar, ShowStatusBar);
  FIniSave.WriteBool(csOpt, ccOShowBorder, ShowBorder);
  FIniSave.WriteBool(csOpt, ccOShowHidden, ShowHidden);
  FIniSave.WriteBool(csOpt, ccOShowNav, FShowNavStart);
  FIniSave.WriteBool(csOpt, ccOShowCfm, Viewer.ModeUndetectedCfm);
  FIniSave.WriteBool(csOpt, ccOShowConv, FShowConv);

  FIniSave.WriteBool(csOpt, ccUText, FUText);
  FIniSave.WriteBool(csOpt, ccUImage, FUImage);
  FIniSave.WriteBool(csOpt, ccUWeb, FUWeb);
  FIniSave.WriteBool(csOpt, ccUOffice, FUOffice);
  FIniSave.WriteBool(csOpt, ccUPlug, FUPlug);

  FIniSave.WriteInteger(csOpt, ccHText, FHText);
  FIniSave.WriteInteger(csOpt, ccHImage, FHImage);
  FIniSave.WriteInteger(csOpt, ccHWeb, FHWeb);
  FIniSave.WriteInteger(csOpt, ccHOffice, FHOffice);
  FIniSave.WriteInteger(csOpt, ccHPlug, FHPlug);

  FIniSave.WriteBool(csOpt, ccOSaveRecents, FSaveRecents);
  FIniSave.WriteBool(csOpt, ccOSavePos, FSavePosition);
  FIniSave.WriteBool(csOpt, ccOSaveSearch, FSaveSearch);
  FIniSave.WriteBool(csOpt, ccOSaveFolder, FSaveFolder);
  FIniSave.WriteBool(csOpt, ccOSaveFile, FSaveFile);
  FIniSave.WriteInteger(csOpt, ccOFileSortOrder, integer(FFileList.SortOrder));
  FIniSave.WriteBool(csOpt, ccOResolveLinks, FResolveLinks);

  with Viewer do
    begin
    FIniSave.WriteBool(csText, ccOTextDetect, TextDetect);
    FIniSave.WriteBool(csText, ccOTextDetectOEM, TextDetectOEM);
    FIniSave.WriteBool(csText, ccOTextDetectUTF8, TextDetectUTF8);
    FIniSave.WriteInteger(csText, ccOTextDetectSize, TextDetectSize);
    FIniSave.WriteInteger(csText, ccOTextDetectLimit, TextDetectLimit);

    //Fonts
    FIniSave.WriteString(csFonts, ccOFont, SFontToString(TextFont));
    FIniSave.WriteString(csFonts, ccOFontOem, SFontToString(TextFontOem));
    FIniSave.WriteString(csFonts, ccOFontFooter, SFontToString(TextFontFooter));
    FIniSave.WriteString(csFonts, ccOFontGutter, SFontToString(TextFontGutter));

    FIniSave.WriteInteger(csText, ccOTextBackColor, TextColor);
    FIniSave.WriteInteger(csText, ccOTextHexColor1, TextColorHex);
    FIniSave.WriteInteger(csText, ccOTextHexColor2, TextColorHex2);
    FIniSave.WriteInteger(csText, ccOTextHexColorBack, TextColorHexBack);
    FIniSave.WriteInteger(csText, ccOTextGutterColor, TextColorGutter);
    FIniSave.WriteInteger(csText, ccOTextUrlColor, TextColorURL);
    FIniSave.WriteInteger(csText, ccOTextHiColor, TextColorHi);

    FIniSave.WriteInteger(csText, ccOTextWidth, TextWidth);
    FIniSave.WriteBool(csText, ccOTextWidthFit, TextWidthFit);
    FIniSave.WriteBool(csText, ccOTextOemSpec, TextOemSpecial);
    FIniSave.WriteBool(csText, ccOTextWrap, TextWrap);
    FIniSave.WriteBool(csText, ccOTextURLs, TextUrlHilight);
    FIniSave.WriteBool(csText, ccOTextNonPrint, TextNonPrintable);

    FIniSave.WriteBool(csText, ccOTextGutter, TextGutter);
    FIniSave.WriteBool(csText, ccOTextGutterLines, TextGutterLines);
    FIniSave.WriteInteger(csText, ccOTextGutterLinesSize, TextGutterLinesBufSize div 1024);
    FIniSave.WriteInteger(csText, ccOTextGutterLinesCount, TextGutterLinesCount);
    FIniSave.WriteInteger(csText, ccOTextGutterLinesStep, TextGutterLinesStep);
    FIniSave.WriteBool(csText, ccOTextGutterLinesExtUse, TextGutterLinesExtUse);
    FIniSave.WriteString(csText, ccOTextGutterLinesExtList, TextGutterLinesExtList);

    FIniSave.WriteInteger(csText, ccOTextSearchIndent, TextSearchIndentVert);
    FIniSave.WriteInteger(csText, ccOTextMaxLength, TextMaxLengths[vbmodeText]);
    FIniSave.WriteInteger(csText, ccOTextTabSize, TextTabSize);

    FIniSave.WriteBool(csOpt, ccOSearchSel, FShowFindSelection);
    FIniSave.WriteBool(csOpt, ccOSearchNoMsg, FShowNoFindError);
    FIniSave.WriteBool(csOpt, ccOSearchNoCfm, FShowNoFindReset);

    FIniSave.WriteBool(csText, ccOTextAutoReload, TextAutoReload);
    FIniSave.WriteBool(csText, ccOTextAutoReloadBeep, TextAutoReloadBeep);
    FIniSave.WriteBool(csText, ccOTextAutoReloadTail, TextAutoReloadFollowTail);
    FIniSave.WriteBool(csText, ccOTextAutoCopy, TextAutoCopy);

    FIniSave.WriteInteger(csMedia, ccOImageColor, ImageColor);

    FIniSave.WriteBool(csMedia, ccOMediaFit, MediaFit);
    FIniSave.WriteBool(csMedia, ccOMediaFitOnlyBig, MediaFitOnlyBig);
    FIniSave.WriteBool(csMedia, ccOMediaFitWidth, MediaFitWidth);
    FIniSave.WriteBool(csMedia, ccOMediaFitHeight, MediaFitHeight);
    FIniSave.WriteBool(csMedia, ccOMediaCenter, MediaCenter);
    FIniSave.WriteBool(csMedia, ccOImageResample, ImageResample);
    FIniSave.WriteBool(csMedia, ccOImageTransparent, ImageTransparent);
    FIniSave.WriteInteger(csMedia, ccOImageLabelColor, FImageLabelColor);
    FIniSave.WriteInteger(csMedia, ccOImageLabelColorErr, FImageLabelColorErr);

    FIniSave.WriteString(csExt, ccOExtText, ATViewerOptions.ExtText);
    FIniSave.WriteString(csExt, ccOExtImages, ATViewerOptions.ExtImages);
    FIniSave.WriteString(csExt, ccOExtInet, ATViewerOptions.ExtInet);
    FIniSave.WriteString(csExt, ccOExtRTF, ATViewerOptions.ExtRTF);
    FIniSave.WriteString(csExt, ccOExtConv, FExtConv);
    FIniSave.WriteString(csExt, ccOExtIgnore, FExtIgnore);
    FIniSave.WriteBool(csExt, ccOExtIgnoreUse, FExtIgnoreUse);

    FIniSave.WriteBool(csExt, ccOExtImagesUse, ATViewerOptions.ExtImagesUse);
    FIniSave.WriteBool(csExt, ccOExtInetUse, ATViewerOptions.ExtInetUse);

    {$ifdef IVIEW}
    with IViewIntegration do
      begin
      FIniSave.WriteBool(csOpt, ccOIViewEnabled, Enabled);
      FIniSave.WriteString(csOpt, ccOIViewExeName, ExeName);
      FIniSave.WriteString(csExt, ccOExtIView, ExtList);
      FIniSave.WriteBool(csOpt, ccOIViewPriority, HighPriority);
      end;
    {$endif}

    {$ifdef IJL}
    with IJLIntegration do
      begin
      FIniSave.WriteBool(csOpt, ccOIJLEnabled, Enabled);
      FIniSave.WriteString(csExt, ccOExtIJL, ExtList);
      end;
    {$endif}
    end;

  SaveShortcuts;

  FIniSave.UpdateFile;
  FIniHistSave.UpdateFile;
end;


procedure TFormViewUV.LoadMargins;
begin
  {
  with Viewer do
    begin
    MarginLeft:=   FIni.ReadFloat(csPrintOpt, ccPMarginL, MarginLeft);
    MarginTop:=    FIni.ReadFloat(csPrintOpt, ccPMarginT, MarginTop);
    MarginRight:=  FIni.ReadFloat(csPrintOpt, ccPMarginR, MarginRight);
    MarginBottom:= FIni.ReadFloat(csPrintOpt, ccPMarginB, MarginBottom);
    PrintFooter:= FIni.ReadBool(csPrintOpt, ccPFooter, PrintFooter);
    end;
    }
end;

procedure TFormViewUV.SaveMargins;
begin
  {
  with Viewer do
    begin
    FIniSave.WriteFloat(csPrintOpt, ccPMarginL, MarginLeft);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginT, MarginTop);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginR, MarginRight);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginB, MarginBottom);
    FIniSave.WriteBool(csPrintOpt, ccPFooter, PrintFooter);
    end;
    }
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.FormCreate(Sender: TObject);
begin
  //Dialogs
  OpenDialog1:= TTntOpenDialog.Create(Self);
  SaveDialog1:= TTntSaveDialog.Create(Self);
  OpenDialog1.Options:= OpenDialog1.Options + [ofFileMustExist];
  OpenDialog1.Filter:= '*.*|*.*';
  SaveDialog1.Filter:= '*.*|*.*';

  //events
  Viewer.OnImageLClick:= TestLClick;
  Viewer.OnImageRClick:= TestRClick;

  //Conv panel
  PanelTop:= TATTextPanel.Create(Self);
  with PanelTop do
    begin
    Parent:= ViewerPanel;
    Visible:= False;
    Align:= alTop;
    Color:= $D0FFC0;
    TATTextPanel(PanelTop).LabCaption:= 'Text converter is available';
    TATTextPanel(PanelTop).OnLabClick:= PanelTopClick;
    end;

  //Fix Vista 'Alt' key, ImageList
  if IsWindowsVista then
    TVistaAltFix.Create(Self);
  FixImageList32Bit(ImageList1);
  FixImageList32Bit(ImageListS);

  //Init configs
  FIniName:= '';
  FIniNameHist:= '';
  FIniNameLS:= '';
  FIni:= nil;
  FIniHist:= nil;
  FIniSave:= nil;
  FIniHistSave:= nil;
  InitConfigs;

  //Init fields
  FFileName:= '';
  FFileFolder:= '';
  FFileNameWM:= '';

  FFileList:= TATFileList.Create;
  FRecentList:= TTntStringList.Create;
  InitRecents;
  FToolbarList:= TToolbarList.Create(ImageList1, cToolbarListDefault);
  FFormFindProgress:= nil;
  FFindHistory:= TTntStringList.Create;
  FFindText:= '';
  FFindWords:= false;
  FFindCase:= false;
  FFindBack:= false;
  FFindHex:= false;
  FFindRegex:= false;
  FFindMLine:= false;
  FFindAll:= false;
  FFindOrigin:= false;
  FGotoMode:= vgPercent;
  FFileNextMsg:= true;
  FFileMoveDelay:= 800;

  FIconsName:= '';
  FSingleInstance:= false;
  FViewerTitle:= 1; //Name only
  FViewerMode:= 0; //Autodetect

  FShowConv:= true;
  FShowNavStart:= false;
  FExtIgnore:= 'sfv,md5,sha';
  FExtIgnoreUse:= true;
  FExtConv:= //'pdf,mht,' +
    'doc,xls,ppt,docx,docm,xlsx,xlsm,pptx,pptm,' +
    'odt,ods,odp,odg,sxw,sxc,sxi,sxd,' +
    'oas,oa2,oa3,wj2,wj3,wk3,wk4,123,' +
    'wri,eml';

  FShowMenu:= true;
  FShowStatusBar:= true;
  FShowFullScreen:= false;
  FShowNoFindError:= false;
  FShowNoFindReset:= true;
  FShowFindSelection:= false;
  FMediaAutoAdvance:= true;
  FMediaFitWindow:= false;
  FImageLabelVisible:= true;
  FImageLabelColor:= clBlue;
  FImageLabelColorErr:= clRed;

  FSaveRecents:= true;
  FSavePosition:= true;
  FSaveSearch:= true;
  FSaveFolder:= true;
  FSaveFile:= false;

  FPluginsTotalcmdVar:= false;
  FPluginsHideKeys:= false;

  FQuickViewMode:= false;
  FNoTaskbarIcon:= false;
  FBoundsRectOld:= Rect(0, 0, 0, 0);
  FActivateBusy:= false;

  {$ifdef CMD}
  FStartupPosDo:= false;
  FStartupPosLine:= false;
  FStartupPosPercent:= false;
  FStartupPos:= 0;
  FStartupPrint:= false;
  FNavHandle:= 0;
  {$endif}

  //Load options, plugins and tools
  LoadUserTools;
  LoadOptions;
  LoadPluginsOptions;

  //Init Drag&Drop
  DragAcceptFiles(Self.Handle, true);

  //Init event handlers
  Viewer.OnOptionsChange:= ViewerOptionsChange;
  Viewer.OnFileLoad:= ViewerFileLoad;
  Viewer.OnPluginsBeforeLoading:= ViewerPluginsBeforeLoading;
  Viewer.OnPluginsAfterLoading:= ViewerPluginsAfterLoading;
  Viewer.OnWebStatusTextChange:= ViewerStatusTextChange;
  Viewer.OnWebTitleChange:= ViewerTitleChange;

  Application.OnActivate:= AppActivate;
  Application.OnMessage:= AppMessage;

  {$ifdef CMD}
  FFileName:= ReadCommandLine;
  {$endif}
end;

procedure TFormViewUV.FormDestroy(Sender: TObject);
begin
  //Save options, when not in QV mode
  if not FQuickViewMode then
    SaveOptionsInt;

  //Close Nav
  {$ifdef NAV}
  ShowNav:= false;
  {$endif}

  //Free objects
  FreeAndNil(FToolbarList);
  FreeAndNil(FFindHistory);
  FreeAndNil(FRecentList);
  FreeAndNil(FFileList);

  FreeAndNil(FIni);
  FreeAndNil(FIniHist);
  FreeAndNil(FIniSave);
  FreeAndNil(FIniHistSave);

  if Assigned(FFormFindProgress) then
    begin
    FFormFindProgress.Release;
    FFormFindProgress:= nil;
    end;
end;

procedure TFormViewUV.UpdateCaption(
  const APluginName: string = '';
  ABeforeLoading: boolean = true;
  const AWebTitle: WideString = '');
var
  sFileName: WideString;
  sPluginName: string;
  sResult: WideString;
begin
  sFileName:= FFileName;
  if FViewerTitle = 1 then
    sFileName:= SExtractFileName(sFileName);

  if sFileName = '' then
    begin
    sResult:= MsgViewerCaption;
    end
  else
    begin
    sResult:= '';

    //If web title passed
    if AWebTitle <> '' then
      sFileName:= AWebTitle + ' (' + sFileName + ')';

    //If @Filelist read, show number in square brackets:
    if FFileList.Locked then
      sResult:= sResult + Format(' [%d/%d]', [FFileList.ListIndex + 1, FFileList.Count]);

    sResult:= sResult + ' - ' + MsgViewerCaption;

    //Show plugin name
    if APluginName <> '' then
      begin
      if ABeforeLoading then
        sResult:= sResult + Format(' (%s...)', [APluginName]);
      end
    else
      begin
      sPluginName:= Viewer.ActivePluginName;
      if sPluginName <> '' then
        sResult:= sResult + Format(' (%s)', [sPluginName]);
      end;
    end;

  Caption:= sFileName + sResult;
  TntApplication.Title:= SExtractFileName(sFileName) + sResult;
end;


function TFormViewUV.PluginPresent(const AFileName: TWlxFilename): boolean;
var
  i: integer;
begin
  Result:= false;
  for i:= Low(FPluginsList) to High(FPluginsList) do
    with FPluginsList[i] do
      if UpperCase(FFileName) = UpperCase(AFileName) then
        begin Result:= true; Break end;
end;


function TFormViewUV.LoadArc(const AFileName: WideString): boolean;
var
  SPluginsFolder: WideString;
  SDesc, SType, SDefDir,
  sAdded, sDups: string;
  SPlugin: string;
begin
  Result:= FArchiveProp(AFileName, SDesc, SType, SDefDir);
  if not Result then Exit;

  Result:= (SDesc <> '') and (SType <> '');
  if not Result then Exit;

  if LowerCase(SType) <> 'wlx' then
    begin MsgError(Format(MsgViewerPluginUnsup, [SType])); Exit end;

  if MsgBox(
    Format(MsgViewerPluginSup, [SDesc]),
    MsgViewerCaption,
    MB_OKCANCEL or MB_ICONINFORMATION, Handle) <> IDOK then Exit;

  SPluginsFolder:= ConfigFolder + '\Plugins';
  FCreateDir(SPluginsFolder);

  if FAddPluginZip(AFileName, SPluginsFolder, Handle, SPlugin) then
    begin
    if PluginPresent(SPlugin) then
      begin
      sAdded:= '';
      sDups:= SPluginName(SPlugin) + #13;
      end
    else
      begin
      sAdded:= SPluginName(SPlugin) + #13;
      sDups:= '';
      if FPluginsNum < High(TPluginsList) then
        begin
        Inc(FPluginsNum);
        FPluginsList[FPluginsNum].FFileName:= SPlugin;
        FPluginsList[FPluginsNum].FDetectStr:= WlxGetDetectString(SPlugin);
        FPluginsList[FPluginsNum].FEnabled:= True;
        Viewer.AddPlugin(
          FPluginsList[FPluginsNum].FFileName,
          FPluginsList[FPluginsNum].FDetectStr);
        SavePluginsOptions;
        end;
      end;
    MsgInstall(sAdded, sDups, True, Handle);
    end;
end;


function IsBadExt(const fn: WideString; var ok: WideString): boolean;
var
  buf: array[0 .. 10] of AnsiChar;
  h: THandle;
  b: Cardinal;
begin
  Result:= false;
  h:= FFileOpen(fn);
  if h <> invalid_handle_value then
  try
    FillChar(buf, Sizeof(buf), 0);
    if not ReadFile(h, buf, SizeOf(buf) - 1, b, nil) then Exit;
    if not SFileExtensionMatch(fn, 'jpg,jpe,jpeg,jfif') and (Copy(buf, 1, 2) = #$ff#$d8) then
      begin Result:= true; ok:= WideChangeFileExt(fn, '.jpg'); Exit end;
    if not SFileExtensionMatch(fn, 'bmp') and (Copy(buf, 1, 2) = 'BM') then
      begin Result:= true; ok:= WideChangeFileExt(fn, '.bmp'); Exit end;
    if not SFileExtensionMatch(fn, 'gif') and (Copy(buf, 1, 3) = 'GIF') then
      begin Result:= true; ok:= WideChangeFileExt(fn, '.gif'); Exit end;
    if not SFileExtensionMatch(fn, 'png') and (Copy(buf, 1, 4) = #$89'PNG') then
      begin Result:= true; ok:= WideChangeFileExt(fn, '.png'); Exit end;
  finally
    CloseHandle(h);
  end;  
end;

function TFormViewUV.LoadFile(
  AFileName: WideString;
  AKeepList: boolean = false;
  ASyncNav: boolean = true;
  ADoConv: boolean = false): boolean;
var
  S, SCopy: WideString;
begin
  Result:= false;

  //Handle folder name
  if IsDirExist(AFileName) then
    begin
    FFileName:= '';
    FFileFolder:= AFileName;
    Result:= Viewer.OpenFolder(FFileFolder);
    Viewer.ModeDetect:= true;
    UpdateOptions(true);
    {$ifdef NAV}
    if ASyncNav then
      NavSync;
    {$endif}
    Exit;
    end;

  //Handle ignore
  if FExtIgnoreUse and SFileExtensionMatch(AFileName, FExtIgnore) then
    if MsgBox(
      Format(MsgString(315), [ExtractFileExt(AFileName)]),
      MsgViewerCaption,
      mb_iconwarning or mb_okcancel,
      Handle) <> idok then Exit;

  //Handle archive with plugin
  if SFileExtensionMatch(AFileName, 'zip,rar') then
    if LoadArc(AFileName) then
      begin
      FFileName:= '';
      FFileFolder:= '';
      Result:= Viewer.Open('');
      UpdateOptions(true);
      Exit;
      end;

  //Handle img with bad ext
  if SFileExtensionMatch(AFileName, 'bmp,jpg,jpeg,jfif,jpe,gif,png') then
    if IsBadExt(AFileName, S) then
      begin
      if FSuggRename and (MsgBox(
        SFormatW(MsgString(316), [SExtractFileName(AFileName), SExtractFileExt(S)]),
        MsgViewerCaption, mb_iconwarning or mb_okcancel, Handle) = idok) then
          begin //rename
          if not FFileMove(AFileName, S) then
            begin MsgCopyMoveError(AFileName, S, Handle); Exit end;
          AFileName:= S;
          end
        else //copy to temp
          begin
          SCopy:= FTempPic(SExtractFileExt(S));
          if not FFileCopy(AFileName, SCopy) then
            begin MsgCopyMoveError(AFileName, SCopy, Handle); Exit end;
          end
      end;

  //Handle img with Unicode fn
  if (SCopy = '') and
    ATViewerOptions.ExtImagesUse and
    SFileExtensionMatch(AFileName, ATViewerOptions.ExtImages) and
    (AFileName <> WideString(AnsiString(AFileName))) then
    begin //copy to temp
    SCopy:= FTempPic(SExtractFileExt(AFileName));
    if not FFileCopy(AFileName, SCopy) then
      begin MsgCopyMoveError(AFileName, SCopy, Handle); Exit end;
    end;

  //Filename is expanded in ATViewer, do the same here
  //for commands "Save as", "Move" etc to work properly.
  FFileName:= FGetFullPathName(AFileName);

  PanelTop.Visible:= FShowConv and
    SFileExtensionMatch(FFileName, FExtConv);

  {
  if ATViewerOptions.ExtMediaUse and SFileExtensionMatch(FFileName, ATViewerOptions.ExtMedia) then
  begin
    if (Viewer.MediaMode = vmmodeWMP64) and (not IsWMP6Installed) then
      begin PanelMed.Visible:= true; Viewer.MediaMode:= vmmodeWMP9; end;
    if (Viewer.MediaMode = vmmodeWMP9) and (not IsWMP9Installed) then
      begin PanelMed.Visible:= true; Viewer.MediaMode:= vmmodeMCI; end;
  end;
  }

  if not AKeepList then
    begin
    FFileList.Locked:= false; //Clear filelist
    if IsFilenameFixed(FFileName) then //Get file number, if not floppy:
      FFileList.GetNext(FFileName, nfCurrent);
    end;

  try
    if FResolveLinks and SFileExtensionMatch(FFileName, 'lnk') then
      //Open .lnk target
      begin
      S:= FLinkInfo(FFileName);
      if not IsFileExist(S) then
        begin S:= ''; FFileName:= '' end;
      Result:= Viewer.Open(S);
      Viewer.ModeDetect:= true;
      end
    else
      //Open file
      begin
      S:= FFileName;
      if SCopy <> '' then
        S:= SCopy
      else
      if ADoConv then
        begin
        S:= ConvName(S);
        if S = '' then Exit;
        PanelTop.Visible:= false;
        end;
      Result:= Viewer.Open(S);
      Viewer.ModeDetect:= true;
      end;

    //Wait for MHT, it may give exception:
    if IsMHT then Viewer.WebWait;
  except
    on E: Exception do
      MsgError(E.Message);
  end;

  if FFileName <> '' then
    if Result then
      begin
      AddRecent(FFileName);
      FFileFolder:= SExtractFileDir(FFileName);
      OpenDialog1.InitialDir:= FFileFolder;
      {$ifdef NAV}
      if ASyncNav then
        NavSync;
      {$endif}
      end
    else
      begin
      FFileName:= '';
      PanelTop.Visible:= false;
      end;
  UpdateOptions(true);
end;

procedure TFormViewUV.Demo;
begin
  with TATTextPanel.Create(Self) do
  begin
    parent:= Self;
    align:= alBottom;
    color:= $9090FF;
    labCaption:= 'D';
    labCaption:= labCaption+'e';
    labCaption:= labCaption+'m';
    labCaption:= labCaption+'o';
  end;
end;

procedure TFormViewUV.FormShow(Sender: TObject);
var
  AKeepList: boolean;
begin
  //Demo;

  {$I Lang.FormView.inc}
  ApplyToolbarCaptions;
  SetForegroundWindow(Application.Handle); //For focusing taskbar button
  Application.BringToFront;               //For bringing to front

  //Reopen last used file
  if (SParamCount = 0) and FSaveRecents and FSaveFile then
    if FRecentList.Count > 0 then
      FFileName:= FRecentList[0];

  AKeepList:= (FFileList.Count > 0);
  LoadFile(FFileName, AKeepList);

  //Start timer for changing position
  TimerShow.Enabled:= true;
  //Start nav after LoadFile
  LoadNav;
end;

procedure TFormViewUV.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormViewUV.mnuFileOpenClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
    FileName:= '';
    if not FSaveFolder then
      InitialDir:= 'C:\';
    if Execute then
      LoadFile(FileName);
    end;
end;

procedure TFormViewUV.mnuFileSaveAsClick(Sender: TObject);
begin
  with SaveDialog1 do
    begin
    FileName:= WideChangeFileExt(FFileName, ' (2)' + SExtractFileExt(FFileName));
    InitialDir:= SExtractFileDir(FFileName);
    if Execute then
      try
        Screen.Cursor:= crHourGlass;
        if not FFileCopy(FFileName, FileName) then
          MsgCopyMoveError(FFileName, FileName, Handle);
      finally
        Screen.Cursor:= crDefault;
      end;
    end;
end;


procedure TFormViewUV.UpdateOptions(AUpdateFitWindow: boolean = false);
var
  En, En2,
  IsText, IsTextVar, IsTextAnsi, IsTextBH,
  IsMedia, IsWeb, IsImage, IsIcon, //IsMMedia, IsWMP,
  IsSearch, IsSearchNext, IsSearchPrev,
  IsPrint, IsPrintPreview,
  IsWLX, IsWLXSearch, IsWLXPrint, IsWLXCmd: boolean;
  AMode: TATViewerMode;
  AEnc: TATEncoding;
  N: integer;
begin
  UpdateCaption;

  En:= (FFileName <> ''); //File loaded
  En2:= En or (Viewer.FileName <> ''); //File or folder loaded
  AMode:= Viewer.Mode;
  AEnc:= Viewer.TextEncoding;

  IsText:= AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF];
  IsTextBH:= AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode];
  IsTextVar:= AMode in [vmodeText, vmodeUnicode, vmodeRTF];
  IsTextAnsi:= AMode in [vmodeText, vmodeBinary, vmodeHex];
  IsMedia:= AMode = vmodeMedia;
  IsWeb:= AMode = vmodeWeb;

  IsImage:= IsMedia and Viewer.IsImage;
  IsIcon:= IsMedia and Viewer.IsIcon;
  //IsMMedia:= IsMedia and Viewer.IsMedia;
  //IsWMP:= IsMMedia and (Viewer.MediaMode<>vmmodeMCI);

  IsWLX:= (AMode = vmodeWLX) and (Viewer.ActivePluginName <> '');
  IsWLXSearch:= Viewer.ActivePluginSupportsSearch;
  IsWLXPrint:= Viewer.ActivePluginSupportsPrint;
  IsWLXCmd:= Viewer.ActivePluginSupportsCommands;

  IsSearch:= (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF, vmodeWeb]);
  IsSearchNext:= (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF]);
  IsSearchPrev:= (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode]) and Viewer.SearchStarted and (not FFindRegex);
  IsPrint:= (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF, vmodeWeb]) or IsImage;
  IsPrintPreview:= (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeWeb]) or IsImage;

  with FToolbarList do
    begin
    Update(mnuFileSaveAs, En);
    Update(mnuFileReload, En2);
    Update(mnuFileClose, En2);

    Update(mnuFilePrint,     En2 and (IsPrint or (IsWLX and IsWLXPrint)));
    Update(mnuFilePrintSetup, En2 and (IsPrint or (IsWLX and IsWLXPrint)));
    Update(mnuFilePrintPreview, {$ifdef PREVIEW} En and IsPrintPreview {$else} false {$endif});

    Update(mnuFileNext, En);
    Update(mnuFilePrev, En);
    Update(mnuFileCopyFN, En);
    Update(mnuFileProp, En);

    Update(mnuFileDelete, {$ifdef NAV} En {$else} false {$endif});
    Update(mnuFileRename, {$ifdef NAV} En {$else} false {$endif});
    Update(mnuFileCopy, {$ifdef NAV} En {$else} false {$endif});
    Update(mnuFileMove, {$ifdef NAV} En {$else} false {$endif});
    Update(mnuFileEmail, {$ifdef NAV} En {$else} false {$endif});
    Update(mnuFileLink, {$ifdef NAV} En {$else} false {$endif});

    Update(mnuEditCopy, En2 and (IsText or (IsImage and (not IsIcon)) or IsWeb or (IsWLX and IsWLXCmd)));
    //Update(mnuEditCopyHex, En and IsHex);
    Update(mnuEditCopyToFile, En and IsText);
    Update(mnuEditSelectAll, En2 and (IsText or IsWeb or (IsWLX and IsWLXCmd)));
    Update(mnuEditFind, En2 and (IsSearch or (IsWLX and IsWLXSearch)));
    Update(mnuEditFindNext, En2 and (IsSearchNext or (IsWLX and IsWLXSearch)));
    Update(mnuEditFindPrev, En and (IsSearchPrev {or (IsWLX and IsWLXSearch)}));
    Update(mnuEditGoto, En2 and (IsText or IsWeb or (IsWLX and IsWLXCmd)));

    Update(mnuViewMode1, En, integer(AMode = vmodeText));
    Update(mnuViewMode2, En, integer(AMode = vmodeBinary));
    Update(mnuViewMode3, En, integer(AMode = vmodeHex));
    Update(mnuViewMode4, En, integer(AMode = vmodeMedia));
    Update(mnuViewMode5, En, integer(AMode = vmodeWeb));
    Update(mnuViewMode6, En, integer(AMode = vmodeUnicode));
    Update(mnuViewMode7, En2, integer(AMode = vmodeWLX));
    Update(mnuViewMode8, En, integer(AMode = vmodeRTF));

    mnuModes1.Checked:= mnuViewMode1.Checked;
    mnuModes2.Checked:= mnuViewMode2.Checked;
    mnuModes3.Checked:= mnuViewMode3.Checked;
    mnuModes4.Checked:= mnuViewMode4.Checked;
    mnuModes5.Checked:= mnuViewMode5.Checked;
    mnuModes6.Checked:= mnuViewMode6.Checked;
    mnuModes7.Checked:= mnuViewMode7.Checked;
    mnuModes8.Checked:= mnuViewMode8.Checked;

    Update(mnuViewTextEncSubmenu, En2 and (IsTextAnsi or (IsWLX and IsWLXCmd)));
    Update(mnuViewTextANSI, En2 and (IsTextAnsi or (IsWLX and IsWLXCmd)), integer(AEnc = vencANSI));
    Update(mnuViewTextOEM,  En2 and (IsTextAnsi or (IsWLX and IsWLXCmd)), integer(AEnc = vencOEM));
    Update(mnuViewTextMac,    En and IsTextAnsi, integer(AEnc = vencMac));
    Update(mnuViewTextEncPrev, En and IsTextAnsi);
    Update(mnuViewTextEncNext, En and IsTextAnsi);
    Update(mnuViewTextEncMenu, En and IsTextBH);
    Update(mnuViewTextWrap, En2 and (IsTextVar or (IsWLX and IsWLXCmd)), integer(Viewer.TextWrap));
    Update(mnuViewTextNonPrint, En and IsTextBH, integer(Viewer.TextNonPrintable));
    Update(mnuViewTextTail, En and IsTextBH, integer(FollowTail));

    Update(mnuViewZoomIn, En and (IsText or IsWeb or IsImage));
    Update(mnuViewZoomOut, En and (IsText or IsWeb or IsImage));
    Update(mnuViewZoomOriginal, En and IsImage);

    Update(mnuViewWebGoBack, En and IsWeb);
    Update(mnuViewWebGoForward, En and IsWeb);
    Update(mnuViewWebOffline, {$ifdef OFFLINE} En and IsWeb, integer(Viewer.WebOffline) {$else} false {$endif});

    Update(mnuViewImageFit,        En2 and (IsMedia or (IsWLX and IsWLXCmd)), integer(Viewer.MediaFit));
    Update(mnuViewImageFitOnlyBig, En2 and (IsImage or (IsWLX and IsWLXCmd)) and Viewer.MediaFit, integer(Viewer.MediaFitOnlyBig));
    Update(mnuViewImageFitWidth,   En and IsImage, integer(Viewer.MediaFitWidth));
    Update(mnuViewImageFitHeight,  En and IsImage, integer(Viewer.MediaFitHeight));
    Update(mnuViewImageCenter,     En2 and (IsImage or (IsWLX and IsWLXCmd)), integer(Viewer.MediaCenter));
    Update(mnuViewImageFitWindow,  En, integer(MediaFitWindow));

    Update(mnuViewImageShowEXIF, {$ifdef EXIF} En and IsImage {$else} false {$endif} );
    Update(mnuViewImageRotateRight, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageRotateLeft, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageFlipVert, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageFlipHorz, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageGrayscale, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageNegative, En and IsImage, 0, integer(En and IsImage));
    Update(mnuViewImageShowLabel, En and IsImage, integer(FImageLabelVisible), integer(En and IsImage));
    Update(mnuViewMediaEffect, En and IsImage);

    Update(mnuViewShowMenu, true, integer(ShowMenu));
    Update(mnuViewShowToolbar, true, integer(ShowToolbar));
    Update(mnuViewShowStatusbar, true, integer(ShowStatusBar));
    Update(mnuViewShowNav, {$ifdef NAV} not ShowFullScreen, integer(ShowNav) {$else} false {$endif});
    Update(mnuViewAlwaysOnTop, true, integer(ShowOnTop));
    Update(mnuViewFullScreen, true, integer(ShowFullScreen));

    N:= NumOfUserTools(FUserTools);
    Update(mnuUserTool1, En, 0, integer(N >= 1));
    Update(mnuUserTool2, En, 0, integer(N >= 2));
    Update(mnuUserTool3, En, 0, integer(N >= 3));
    Update(mnuUserTool4, En, 0, integer(N >= 4));
    Update(mnuUserTool5, En, 0, integer(N >= 5));
    Update(mnuUserTool6, En, 0, integer(N >= 6));
    Update(mnuUserTool7, En, 0, integer(N >= 7));
    Update(mnuUserTool8, En, 0, integer(N >= 8));
    end;

  UpdateImageLabel;
  UpdateStatusBar;
  UpdateShortcuts;

  if AUpdateFitWindow then
    begin
    UpdateFitWindow(true);
    if Viewer.MediaFit then
      UpdateFitWindow(false);
    end;

  if IsImage then
    if Assigned(Viewer.ImageBox) then
      begin
      Viewer.ImageBox.PopupMenu:= MenuImage;
      CopyMenuItem(mnuViewImageFit, mnuImageFit);
      CopyMenuItem(mnuViewImageFitOnlyBig, mnuImageFitOnlyBig);
      CopyMenuItem(mnuViewImageFitWidth, mnuImageFitWidth);
      CopyMenuItem(mnuViewImageFitHeight, mnuImageFitHeight);
      CopyMenuItem(mnuViewImageCenter, mnuImageCenter);
      CopyMenuItem(mnuViewImageFitWindow, mnuImageFitWindow);
      CopyMenuItem(mnuViewImageShowEXIF, mnuImageShowEXIF);
      CopyMenuItem(mnuViewImageShowLabel, mnuImageShowLabel);
      CopyMenuItem(mnuViewImageRotateRight, mnuImageRotateRight);
      CopyMenuItem(mnuViewImageRotateLeft, mnuImageRotateLeft);
      CopyMenuItem(mnuViewImageFlipVert, mnuImageFlipVert);
      CopyMenuItem(mnuViewImageFlipHorz, mnuImageFlipHorz);
      CopyMenuItem(mnuViewImageGrayscale, mnuImageGrayscale);
      CopyMenuItem(mnuViewImageNegative, mnuImageNegative);
      end;
end;

procedure TFormViewUV.mnuFileCloseClick(Sender: TObject);
begin
  CloseFile;
end;

procedure TFormViewUV.mnuViewMode1Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeText;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode3Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeHex;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode2Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeBinary;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode4Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeMedia;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode5Click(Sender: TObject);
begin
  Viewer.WebWaitForNavigate:= false; //No need to wait here
  Viewer.Mode:= vmodeWeb;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode6Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeUnicode;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode8Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeRTF;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode7Click(Sender: TObject);
begin
  Viewer.Mode:= vmodeWLX;
  UpdateOptions;
  ResizePlugin;
end;

procedure TFormViewUV.mnuViewTextANSIClick(Sender: TObject);
begin
  Viewer.TextEncoding:= vencANSI;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextOEMClick(Sender: TObject);
begin
  Viewer.TextEncoding:= vencOEM;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextMacClick(Sender: TObject);
begin
  Viewer.TextEncoding:= vencMac;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextWrapClick(Sender: TObject);
begin
  Viewer.TextWrap:= not Viewer.TextWrap;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextNonPrintClick(Sender: TObject);
begin
  Viewer.TextNonPrintable:= not Viewer.TextNonPrintable;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextTailClick(Sender: TObject);
begin
  FollowTail:= not FollowTail;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFitClick(Sender: TObject);
begin
  Viewer.MediaFit:= not Viewer.MediaFit;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFitOnlyBigClick(Sender: TObject);
begin
  Viewer.MediaFitOnlyBig:= not Viewer.MediaFitOnlyBig;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageCenterClick(Sender: TObject);
begin
  Viewer.MediaCenter:= not Viewer.MediaCenter;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewWebOfflineClick(Sender: TObject);
begin
  {$ifdef OFFLINE}
  Viewer.WebOffline:= not Viewer.WebOffline;
  {$endif}
  UpdateOptions;
end;

procedure TFormViewUV.SearchPrepareAndStart;
var
  fString: WideString;
  fStringA: string;
  fOptions: TATStreamSearchOptions;
  i: integer;
begin
  if FFindHex then
    begin
    if not SHexToNormal(FFindText, fStringA) then
      begin
      MsgWarning(SFormatW(MsgViewerErrInvalidHex, [FFindText]), Handle);
      Exit
      end;
    fString:= fStringA;
    end
  else
    begin
    fString:= FFindText;
    if not FFindRegex then
      SDecodeSearchW(fString);
    end;

  with FFindHistory do
    begin
    i:= IndexOf(FFindText);
    if i>=0 then Delete(i);
    Insert(0, FFindText);
    end;

  fOptions:= [];
  if FFindWords then Include(fOptions, asoWholeWords);
  if FFindCase then Include(fOptions, asoCaseSens);
  if FFindBack then Include(fOptions, asoBackward);
  {$IFDEF REGEX}
  if FFindRegex then Include(fOptions, asoRegex);
  if FFindMLine then Include(fOptions, asoRegexMLine);
  {$ENDIF}
  if FFindAll then Include(fOptions, asoShowAll);
  if FFindOrigin then Include(fOptions, asoFromPage);

  InitFormFindProgress;
  if Assigned(FFormFindProgress) then
    with TFormViewFindProgress(FFormFindProgress) do
      begin
      FViewer:= Viewer;
      FFindText:= fString;
      FFindTextOrig:= FFindText;
      FFindOptions:= fOptions;
      FFindFirst:= true;
      FShowNoErrorMsg:= Self.FShowNoFindError;
      StartSearch;
      end;
end;

function TFormViewUV.SelTextShort: WideString;
begin
  if Viewer.Mode = vmodeUnicode then
    Result:= Viewer.TextSelTextShortW
  else
    Result:= Viewer.TextSelTextShort;

  //Strip leading CRs
  while (Result <> '') and (Pos(Result[1], #13#10) > 0) do
    Delete(Result, 1, 1);

  //Leave only first line
  SDeleteFromStrW(Result, #13);
  SDeleteFromStrW(Result, #10);
end;

procedure TFormViewUV.DoFindFirst;
var
  OK: boolean;
  i: integer;
begin
  //Try to show custom dialog
  //in Internet/Plugins mode
  if Viewer.FindDialog(false) then
    Exit;

  //Show our own dialog
  with TFormViewFindText.Create(Self) do
    try
      with FFindHistory do
        for i:= 0 to Count-1 do
          edText.Items.Add(Strings[i]);

      if FShowFindSelection then
        edText.Text:= SelTextShort;
      if edText.Text = '' then
        edText.Text:= FFindText;
      chkWords.Checked:= FFindWords;
      chkCase.Checked:= FFindCase;
      chkHex.Checked:= FFindHex;
      chkRegex.Checked:= FFindRegex;
      chkMLine.Checked:= FFindMLine;
      chkAll.Checked:= FFindAll;
      chkDirBackward.Checked:= FFindBack;
      chkDirForward.Checked:= not chkDirBackward.Checked;
      chkOriginCursor.Checked:= FFindOrigin;
      chkOriginEntire.Checked:= not chkOriginCursor.Checked;

      BackEnabled:= Viewer.Mode<>vmodeRTF;
      HexEnabled:= Viewer.Mode<>vmodeUnicode;
      {$ifdef REGEX}
      RegexEnabled:= ((Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex]) and (Viewer.TextEncoding in [vencANSI, vencOEM]))
        or (Viewer.Mode = vmodeUnicode);
      {$else}
      RegexEnabled:= false;
      {$endif}
      OriginEnabled:= Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF];
      HiEnabled:= Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF];

      OK:= (ShowModal=mrOk) and (edText.Text <> '');
      if OK then
        begin
        FFindText:= edText.Text;
        FFindWords:= chkWords.Checked;
        FFindCase:= chkCase.Checked;
        FFindHex:= chkHex.Checked;
        FFindRegex:= chkRegex.Checked;
        FFindMLine:= chkMLine.Checked;
        FFindAll:= chkAll.Checked;
        FFindBack:= chkDirBackward.Checked;
        FFindOrigin:= chkOriginCursor.Checked;
        end;
    finally
      Release;
    end;

  if OK then
    SearchPrepareAndStart;
end;


procedure TFormViewUV.DoFindNext(AFindPrevious: boolean = false);
begin
  //Try to show custom search dialog
  //in Internet/Plugins modes
  if Viewer.FindDialog(true) then
    Exit;

  if Viewer.SearchStarted then
    //Continue search, or start search again
    //(when search is finished and option is on)
    begin
    InitFormFindProgress;
    if Assigned(FFormFindProgress) then
      with TFormViewFindProgress(FFormFindProgress) do
        begin
        FViewer:= Viewer;
        FFindFirst:= Self.FShowNoFindError and Viewer.SearchFinished;
        FFindPrevious:= AFindPrevious;
        FShowNoErrorMsg:= Self.FShowNoFindError;
        StartSearch;
        end;
    end
  else
    begin
    if Self.FShowNoFindReset and (FFindText <> '') then
      //Start search with previously saved params
      //(when option is on)
      SearchPrepareAndStart
    else
      //Show search dialog
      mnuEditFindClick(Self)
    end;
end;

procedure TFormViewUV.mnuEditFindClick(Sender: TObject);
begin
  DoFindFirst;
  UpdateOptions;
  Toolbar.Invalidate;
end;

procedure TFormViewUV.mnuEditFindNextClick(Sender: TObject);
begin
  DoFindNext;
  UpdateOptions;
end;

procedure TFormViewUV.mnuEditFindPrevClick(Sender: TObject);
begin
  DoFindNext(true);
  UpdateOptions;
end;


function TFormViewUV.TextNotSelected: boolean;
begin
  Result :=
    (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF]) and
    (Viewer.TextSelLength = 0);
end;

procedure TFormViewUV.mnuEditCopyClick(Sender: TObject);
begin
  if TextNotSelected then
    begin
    MsgTextNotSelected;
    Exit;
    end;
  Viewer.CopyToClipboard;
end;

procedure TFormViewUV.mnuEditCopyHexClick(Sender: TObject);
begin
  if TextNotSelected then
    begin
    MsgTextNotSelected;
    Exit;
    end;
  Viewer.CopyToClipboard(true);
end;

procedure TFormViewUV.mnuEditSelectAllClick(Sender: TObject);
begin
  Viewer.SelectAll;
end;

procedure TFormViewUV.mnuHelpAboutClick(Sender: TObject);
begin
  with TFormViewAbout.Create(Self) do
    try
      labVersion.Caption:= Format('%s %s (%s)', [
        MsgCaption(411),
        cViewerVersion,
        cViewerDate ]);
      //memoCredits.Lines.Add(cViewerComps);
      //memoCredits.SelStart:= 0;
      ShowModal;
    finally
      Release;
    end;
end;

procedure TFormViewUV.mnuFilePrintClick(Sender: TObject);
begin
  InitPreview;
  //Viewer.PrintDialog;
  SaveMargins;
end;

procedure TFormViewUV.mnuFilePrintPreviewClick(Sender: TObject);
begin
  InitPreview;
  //Viewer.PrintPreview;
  SaveMargins;
end;

procedure TFormViewUV.mnuFilePrintSetupClick(Sender: TObject);
begin
  //Viewer.PrintSetup;
  SaveMargins;
end;

procedure TFormViewUV.mnuOptionsConfigureClick(Sender: TObject);
var
  ALanguage: string;
  AIcons: string;
  AExtension: boolean;
  S: WideString;
begin
  with TFormViewOptions.Create(Self) do
    try
      FPlugin:= Viewer.ActivePluginName;

      //Restore tab
      PageControl1.ActivePageIndex:=
        FIniSave.ReadInteger(csOpt, 'Tab', 0);

      if IsImageListSaved
        then ffImgList:= ImageListS
        else ffImgList:= ImageList1;

      ffToolbar:= FToolbarList;
      ffClearRecent:= ClearRecents;
      ffClearSearch:= ClearSearch;

      with ATViewerOptions do
        begin
        edText.Text:= ExtText;
        edImages.Text:= ExtImages;
        edInet.Text:= ExtInet;
        edConv.Text:= FExtConv;
        edIgnore.Text:= FExtIgnore;
        chkIgnore.Checked:= FExtIgnoreUse;
        chkImages.Checked:= ExtImagesUse;
        chkInet.Checked:= ExtInetUse;
        end;

      ffTextDetect:= Viewer.TextDetect;
      ffTextDetectOEM:= Viewer.TextDetectOEM;
      ffTextDetectUTF8:= Viewer.TextDetectUTF8;
      ffTextDetectSize:= Viewer.TextDetectSize;
      ffTextDetectLimit:= Viewer.TextDetectLimit;

      ffTextFontName:= Viewer.TextFont.Name;
      ffTextFontSize:= Viewer.TextFont.Size;
      ffTextFontColor:= Viewer.TextFont.Color;
      ffTextFontStyle:= Viewer.TextFont.Style;
      ffTextFontCharset:= Viewer.TextFont.CharSet;

      ffTextFontOEMName:= Viewer.TextFontOEM.Name;
      ffTextFontOEMSize:= Viewer.TextFontOEM.Size;
      ffTextFontOEMColor:= Viewer.TextFontOEM.Color;
      ffTextFontOEMStyle:= Viewer.TextFontOEM.Style;
      ffTextFontOEMCharset:= Viewer.TextFontOEM.CharSet;

      ffFooterFontName:= Viewer.TextFontFooter.Name;
      ffFooterFontSize:= Viewer.TextFontFooter.Size;
      ffFooterFontColor:= Viewer.TextFontFooter.Color;
      ffFooterFontStyle:= Viewer.TextFontFooter.Style;
      ffFooterFontCharset:= Viewer.TextFontFooter.CharSet;

      ffTextBackColor:= Viewer.TextColor;
      ffTextHexColor1:= Viewer.TextColorHex;
      ffTextHexColor2:= Viewer.TextColorHex2;
      ffTextHexColorBack:= Viewer.TextColorHexBack;
      ffTextGutterColor:= Viewer.TextColorGutter;
      ffTextUrlColor:= Viewer.TextColorURL;
      ffTextHiColor:= Viewer.TextColorHi;

      ffMediaColor:= Viewer.ImageColor;
      ffMediaColorLabel:= FImageLabelColor;
      ffMediaColorLabelErr:= FImageLabelColorErr;

      chkTextReload.Checked:= Viewer.TextAutoReload;
      chkTextReloadBeep.Checked:= Viewer.TextAutoReloadBeep;
      chkTextReloadTail.Checked:= Viewer.TextAutoReloadFollowTail;
      chkTextAutoCopy.Checked:= Viewer.TextAutoCopy;

      chkTextWidthFit.Checked:= Viewer.TextWidthFit;
      chkTextOemSpecial.Checked:= Viewer.TextOemSpecial;
      chkTextWrap.Checked:= Viewer.TextWrap;
      chkTextURLs.Checked:= Viewer.TextUrlHilight;
      {$ifndef REGEX}
      chkTextURLs.Enabled:= false;
      chkTextURLs.Checked:= false;
      {$endif}

      chkTextNonPrint.Checked:= Viewer.TextNonPrintable;
      edTextWidth.Value:= Viewer.TextWidth;
      edTextLength.Value:= Viewer.TextMaxLengths[vbmodeText];
      edTextTabSize.Value:= Viewer.TextTabSize;

      edSearchIndent.Value:= Viewer.TextSearchIndentVert;
      chkSearchSel.Checked:= FShowFindSelection;
      chkSearchNoMsg.Checked:= FShowNoFindError;
      chkSearchNoCfm.Checked:= FShowNoFindReset;

      chkImageFit.Checked:= Viewer.MediaFit;
      chkImageFitBig.Checked:= Viewer.MediaFitOnlyBig;
      chkImageFitWidth.Checked:= Viewer.MediaFitWidth;
      chkImageFitHeight.Checked:= Viewer.MediaFitHeight;
      chkImageCenter.Checked:= Viewer.MediaCenter;
      chkImageFitWindow.Checked:= FMediaFitWindow;
      chkImageLabel.Checked:= FImageLabelVisible;

      chkImageResample.Checked:= Viewer.ImageResample;
      chkImageResample.Enabled:= Win32Platform = VER_PLATFORM_WIN32_NT; //Doesn't work under Win9x
      chkImageTransp.Checked:= Viewer.ImageTransparent;

      chkWebOffline.Checked:= Viewer.WebOffline;
      chkResolveLinks.Checked:= FResolveLinks;
      chkShowHidden.Checked:= ShowHidden;
      chkNav.Checked:= FShowNavStart;
      chkShowCfm.Checked:= Viewer.ModeUndetectedCfm;
      chkShowConv.Checked:= FShowConv;

      chkHText.Checked:= FUText;
      chkHImage.Checked:= FUImage;
      chkHWeb.Checked:= FUWeb;
      chkHRtf.Checked:= FURtf;
      chkHPlug.Checked:= FUPlug;

      edHText.Value:= FHText;
      edHImage.Value:= FHImage;
      edHWeb.Value:= FHWeb;
      edHRtf.Value:= FHRtf;
      edHPlug.Value:= FHPlug;

      ALanguage:= SMsgLanguage;
      AIcons:= IconsName;
      AExtension:= IsShellExtensionEnabled;
      ffOptLang:= ALanguage;
      ffOptIcon:= AIcons;
      chkShell.Checked:= AExtension;

      chkRen.Checked:= FSuggRename;
      chkMenu.Checked:= ShowMenu;
      chkMenuIcons.Checked:= ShowMenuIcons;
      chkToolbar.Checked:= ShowToolbar;
      chkToolbarFS.Checked:= ShowToolbarFS;
      chkBorder.Checked:= ShowBorder;
      chkStatusBar.Checked:= ShowStatusBar;
      chkSingleInst.Checked:= FSingleInstance;
      edViewerTitle.ItemIndex:= FViewerTitle;
      edViewerMode.ItemIndex:= FViewerMode;
      edFileSort.ItemIndex:= integer(FFileList.SortOrder);

      chkSaveRecents.Checked:= FSaveRecents;
      chkSavePosition.Checked:= FSavePosition;
      chkSaveSearch.Checked:= FSaveSearch;
      chkSaveFolder.Checked:= FSaveFolder;
      chkSaveFile.Checked:= FSaveFile;

      {$ifndef NAV}
      chkNav.Checked:= false;
      chkNav.Enabled:= false;
      {$endif}
      {$ifndef CMD}
      chkShell.Checked:= false;
      chkShell.Enabled:= false;
      chkSingleInst.Checked:= false;
      chkSingleInst.Enabled:= false;
      {$endif}

      {$ifdef IVIEW}
      with Viewer.IViewIntegration do
        begin
        ffIViewEnabled:= Enabled;
        ffIViewExeName:= ExeName;
        ffIViewExtList:= ExtList;
        ffIViewHighPriority:= HighPriority;
        end;
      {$endif}

      {$ifdef IJL}
      with Viewer.IJLIntegration do
        begin
        ffIJLEnabled:= Enabled;
        ffIJLExtList:= ExtList;
        end;
      {$endif}

      ffShowGutter:= Viewer.TextGutter;
      ffShowLines:= Viewer.TextGutterLines;
      ffLinesBufSize:= Viewer.TextGutterLinesBufSize div 1024;
      ffLinesCount:= Viewer.TextGutterLinesCount;
      ffLinesStep:= Viewer.TextGutterLinesStep;
      ffLinesExtUse:= Viewer.TextGutterLinesExtUse;
      ffLinesExtList:= Viewer.TextGutterLinesExtList;

      with Viewer.TextFontGutter do
        begin
        ffGutterFontName:= Name;
        ffGutterFontSize:= Size;
        ffGutterFontColor:= Color;
        ffGutterFontStyle:= Style;
        ffGutterFontCharset:= CharSet;
        end;

      if ShowModal=mrOk then
        begin
        //Apply options
        with ATViewerOptions do
          begin
          ExtText:= edText.Text;
          ExtImages:= edImages.Text;
          ExtInet:= edInet.Text;
          FExtConv:= edConv.Text;
          FExtIgnore:= edIgnore.Text;
          FExtIgnoreUse:= chkIgnore.Checked;
          ShowHidden:= ShowHidden; //FFileList.ExtIgnore
          ExtImagesUse:= chkImages.Checked;
          ExtInetUse:= chkInet.Checked;
          end;

        Viewer.TextDetect:= ffTextDetect;
        Viewer.TextDetectOEM:= ffTextDetectOEM;
        Viewer.TextDetectUTF8:= ffTextDetectUTF8;
        Viewer.TextDetectSize:= ffTextDetectSize;
        Viewer.TextDetectLimit:= ffTextDetectLimit;

        Viewer.TextFont.Name:= ffTextFontName;
        Viewer.TextFont.Size:= ffTextFontSize;
        Viewer.TextFont.Color:= ffTextFontColor;
        Viewer.TextFont.Style:= ffTextFontStyle;
        Viewer.TextFont.CharSet:= ffTextFontCharset;

        Viewer.TextFontOEM.Name:= ffTextFontOEMName;
        Viewer.TextFontOEM.Size:= ffTextFontOEMSize;
        Viewer.TextFontOEM.Color:= ffTextFontOEMColor;
        Viewer.TextFontOEM.Style:= ffTextFontOEMStyle;
        Viewer.TextFontOEM.CharSet:= ffTextFontOEMCharset;

        Viewer.TextFontFooter.Name:= ffFooterFontName;
        Viewer.TextFontFooter.Size:= ffFooterFontSize;
        Viewer.TextFontFooter.Color:= ffFooterFontColor;
        Viewer.TextFontFooter.Style:= ffFooterFontStyle;
        Viewer.TextFontFooter.CharSet:= ffFooterFontCharset;

        Viewer.TextColor:= ffTextBackColor;
        Viewer.TextColorHex:= ffTextHexColor1;
        Viewer.TextColorHex2:= ffTextHexColor2;
        Viewer.TextColorHexBack:= ffTextHexColorBack;
        Viewer.TextColorGutter:= ffTextGutterColor;
        Viewer.TextColorURL:= ffTextUrlColor;
        Viewer.TextColorHi:= ffTextHiColor;

        Viewer.TextWidth:= edTextWidth.Value;
        Viewer.TextWidthFit:= chkTextWidthFit.Checked;
        Viewer.TextWidthFitHex:= Viewer.TextWidthFit;
        Viewer.TextWidthFitUHex:= Viewer.TextWidthFit;
        Viewer.TextOemSpecial:= chkTextOemSpecial.Checked;
        Viewer.TextWrap:= chkTextWrap.Checked;
        Viewer.TextUrlHilight:= chkTextURLs.Checked;
        Viewer.TextNonPrintable:= chkTextNonPrint.Checked;
        Viewer.TextSearchIndentVert:= edSearchIndent.Value;
        Viewer.TextSearchIndentHorz:= Viewer.TextSearchIndentVert;
        Viewer.TextMaxLengths[vbmodeText]:= edTextLength.Value;
        Viewer.TextMaxLengths[vbmodeUnicode]:= Viewer.TextMaxLengths[vbmodeText];
        Viewer.TextTabSize:= edTextTabSize.Value;

        FShowFindSelection:= chkSearchSel.Checked;
        FShowNoFindError:= chkSearchNoMsg.Checked;
        FShowNoFindReset:= chkSearchNoCfm.Checked;

        Viewer.TextAutoReload:= chkTextReload.Checked;
        Viewer.TextAutoReloadBeep:= chkTextReloadBeep.Checked;
        Viewer.TextAutoReloadFollowTail:= chkTextReloadTail.Checked;
        Viewer.TextAutoCopy:= chkTextAutoCopy.Checked;

        Viewer.ImageColor:= ffMediaColor;
        FImageLabelColor:= ffMediaColorLabel;
        FImageLabelColorErr:= ffMediaColorLabelErr;

        Viewer.MediaFit:= chkImageFit.Checked;
        Viewer.MediaFitOnlyBig:= chkImageFitBig.Checked;
        Viewer.MediaFitWidth:= chkImageFitWidth.Checked;
        Viewer.MediaFitHeight:= chkImageFitHeight.Checked;
        Viewer.MediaCenter:= chkImageCenter.Checked;
        FMediaFitWindow:= chkImageFitWindow.Checked;
        FImageLabelVisible:= chkImageLabel.Checked;
        Viewer.ImageResample:= chkImageResample.Checked;
        Viewer.ImageTransparent:= chkImageTransp.Checked;

        {$ifdef IVIEW}
        with Viewer.IViewIntegration do
          begin
          Enabled:= ffIViewEnabled;
          ExeName:= ffIViewExeName;
          ExtList:= ffIViewExtList;
          HighPriority:= ffIViewHighPriority;
          end;
        {$endif}

        {$ifdef IJL}
        with Viewer.IJLIntegration do
          begin
          Enabled:= ffIJLEnabled;
          ExtList:= ffIJLExtList;
          end;
        {$endif}

        Viewer.TextGutter:= ffShowGutter;
        Viewer.TextGutterLines:= ffShowLines;
        Viewer.TextGutterLinesBufSize:= ffLinesBufSize * 1024;
        Viewer.TextGutterLinesCount:= ffLinesCount;
        Viewer.TextGutterLinesStep:= ffLinesStep;
        Viewer.TextGutterLinesExtUse:= ffLinesExtUse;
        Viewer.TextGutterLinesExtList:= ffLinesExtList;

        with Viewer.TextFontGutter do
          begin
          Name:= ffGutterFontName;
          Size:= ffGutterFontSize;
          Color:= ffGutterFontColor;
          Style:= ffGutterFontStyle;
          CharSet:= ffGutterFontCharset;
          end;

        Viewer.WebOffline:= chkWebOffline.Checked;
        Viewer.ModeUndetectedCfm:= chkShowCfm.Checked;
        FShowConv:= chkShowConv.Checked;
        FShowNavStart:= chkNav.Checked;
        {$ifdef NAV}
        ShowNav:= FShowNavStart;
        {$endif}
        FSuggRename:= chkRen.Checked;
        ShowMenu:= chkMenu.Checked;
        ShowMenuIcons:= chkMenuIcons.Checked;
        ShowToolbar:= chkToolbar.Checked;
        ShowToolbarFS:= chkToolbarFS.Checked;
        ShowBorder:= chkBorder.Checked;
        ShowStatusBar:= chkStatusBar.Checked;
        ShowHidden:= chkShowHidden.Checked;

        FUText:= chkHText.Checked;
        FUImage:= chkHImage.Checked;
        FUWeb:= chkHWeb.Checked;
        FURtf:= chkHRtf.Checked;
        FUPlug:= chkHPlug.Checked;

        FHText:= edHText.Value;
        FHImage:= edHImage.Value;
        FHWeb:= edHWeb.Value;
        FHRtf:= edHRtf.Value;
        FHPlug:= edHPlug.Value;

        FSingleInstance:= chkSingleInst.Checked;
        FViewerTitle:= edViewerTitle.ItemIndex;
        FViewerMode:= edViewerMode.ItemIndex;
        FFileList.SortOrder:= TATFileSort(edFileSort.ItemIndex);
        FResolveLinks:= chkResolveLinks.Checked;

        FSaveRecents:= chkSaveRecents.Checked;
        FSavePosition:= chkSavePosition.Checked;
        FSaveSearch:= chkSaveSearch.Checked;
        FSaveFolder:= chkSaveFolder.Checked;
        FSaveFile:= chkSaveFile.Checked;

        if not FSaveRecents then
          ClearRecents;
        if not FSaveSearch then
          ClearSearch;

        if ALanguage <> ffOptLang then
          SetMsgLanguage(ffOptLang);

        if AIcons <> ffOptIcon then
          IconsName:= ffOptIcon;

        if AExtension <> chkShell.Checked then
          begin
          if not ApplyShellExtension(chkShell.Checked) then
            MsgError(MsgString(152));
          end;

        //Save options and reload file
        Application.ProcessMessages;
        FIniSave.WriteInteger(csOpt, 'Tab', PageControl1.ActivePageIndex);
        SaveOptionsDlg;
        //close, reopen file
        S:= FFileName;
        CloseFile;
        Self.FormShow(Self);
        LoadFile(S);
        end;
    finally
      Release;
    end;

  //Update shortcuts, even if user cancelled the dialog:
  UpdateShortcuts;
end;

procedure TFormViewUV.ReloadFile;
begin
  if (ActiveFileName <> '') and IsFileOrDirExist(ActiveFileName) then
    begin
    Viewer.Reload;
    UpdateOptions;
    end
  else
    CloseFile;
end;

{
procedure TFormViewUV.ReopenFile;
var
  S: WideString;
begin
  if (ActiveFileName <> '') and IsFileOrDirExist(ActiveFileName) then
    begin
    S:= ActiveFileName;
    CloseFile;
    LoadFile(S);
    end
  else
    CloseFile;
end;
}

procedure TFormViewUV.CloseFile(AKeepList: boolean = false);
begin
  LoadFile('', AKeepList);
end;

procedure TFormViewUV.mnuFileReloadClick(Sender: TObject);
begin
  ReloadFile;
end;

procedure TFormViewUV.mnuEditGotoClick(Sender: TObject);
var
  APos: Int64;
  AMode: TViewerGotoMode;
begin
  APos:= -1;
  AMode:= FGotoMode;

  with TFormViewGoto.Create(nil) do
    try
      if not (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF, vmodeWeb]) then
        begin
        AMode:= vgPercent;
        chkHex.Enabled:= false;
        chkDec.Enabled:= false;
        chkSelStart.Enabled:= false;
        chkSelEnd.Enabled:= false;
        end;

      if not (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF]) then
        begin
        if AMode = vgLine then
          AMode:= vgPercent;
        chkLine.Enabled:= false;
        end;

      if (Viewer.TextSelLength = 0) then
        begin
        if AMode in [vgSelStart, vgSelEnd] then
          AMode:= vgPercent;
        chkSelStart.Enabled:= false;
        chkSelEnd.Enabled:= false;
        end;

      case AMode of
        vgPercent:
          begin
          chkPercent.Checked:= true;
          edPos.Text:= IntToStr(Viewer.PosPercent);
          end;
        vgLine:
          begin
          chkLine.Checked:= true;
          edPos.Text:= IntToStr(Viewer.PosLine);
          end;
        vgHex:
          begin
          chkHex.Checked:= true;
          edPos.Text:= IntToHex(Viewer.PosOffset, 1);
          end;
        vgDec:
          begin
          chkDec.Checked:= true;
          edPos.Text:= IntToStr(Viewer.PosOffset);
          end;
        vgSelStart:
          begin
          chkSelStart.Checked:= true;
          edPos.Text:= IntToStr(Viewer.PosOffset);
          end;
        vgSelEnd:
          begin
          chkSelEnd.Checked:= true;
          edPos.Text:= IntToStr(Viewer.PosOffset);
          end;
      end;

      if ShowModal=mrOk then
        begin
        if chkPercent.Checked then
          begin
          AMode:= vgPercent;
          APos:= StrToIntDef(edPos.Text, -1);
          end
        else
        if chkLine.Checked then
          begin
          AMode:= vgLine;
          APos:= StrToIntDef(edPos.Text, -1);
          end
        else
        if chkHex.Checked then
          begin
          AMode:= vgHex;
          APos:= HexToIntDef(edPos.Text, -1);
          end
        else
        if chkDec.Checked then
          begin
          AMode:= vgDec;
          APos:= StrToIntDef(edPos.Text, -1);
          end
        else
        if chkSelStart.Checked then
          begin
          AMode:= vgSelStart;
          APos:= 0;
          end
        else
        if chkSelEnd.Checked then
          begin
          AMode:= vgSelEnd;
          APos:= 0;
          end;
        end;
    finally
      Release;
    end;

  if APos >= 0 then
    begin
    FGotoMode:= AMode;
    case AMode of
      vgPercent:
        Viewer.PosPercent:= APos;
      vgLine:
        Viewer.PosLine:= APos;
      vgHex,
      vgDec:
        Viewer.PosOffset:= APos;
      vgSelStart:
        Viewer.PosOffset:= Viewer.TextSelStart;
      vgSelEnd:
        Viewer.PosOffset:= Viewer.TextSelStart + Viewer.TextSelLength - 1;
    end;
    end;
end;

procedure TFormViewUV.mnuFilePrevClick(Sender: TObject);
begin
  DoFileNext(false);
end;

procedure TFormViewUV.mnuFileNextClick(Sender: TObject);
begin
  DoFileNext(true);
end;

procedure TFormViewUV.DoFileNext(ANext: boolean; AImgOnly: boolean = false);
const
  F: array[boolean] of TATNextFile = (nfPrev, nfNext);
var
  fn: WideString;
begin
  fn:= FFileName;
  repeat
    fn:= FFileList.GetNext(fn, F[ANext], FFileNextMsg and (not FFileList.Locked));
  until
    (fn = '') or
    (UpperCase(fn) = UpperCase(FFileName)) or
    (not AImgOnly) or
    SFileExtensionMatch(fn, ATViewerOptions.ExtImages);
    
  if fn <> '' then
    LoadFile(fn, true);
end;

procedure TFormViewUV.InitPlugins;
begin
  Viewer.InitPluginsParams(Self, FIniNameLS);
end;


function TFormViewUV.LoadPluginPre(const sFN, sExt: string): boolean;
var
  i: integer;
  fn: TWlxFilename;
  sExtOld: string; //(1)
begin
  Result:= False;
  fn:= SParamDir + '\Plugins\' + sFN;
  if IsFileExist(fn) then
    begin
    for i:= 0 to FPluginsNum do
      if UpperCase(FPluginsList[i].FFileName) = UpperCase(fn) then
      begin
        //such plugin exists: fix detect string
        sExtOld:= FPluginsList[i].FDetectStr;
        if ExtractFileName(sFN)='slister.wlx' then
          if (Pos(',mobi,', sExtOld)=0) or
            (Pos(',pdb,', sExtOld)=0) then
            FPluginsList[i].FDetectStr:= sExt;
        Exit;
      end;
    //add this plugin
    if FPluginsNum < High(TPluginsList) then
      begin
      Result:= True;
      Inc(FPluginsNum);
      FPluginsList[FPluginsNum].FFileName:= fn;
      FPluginsList[FPluginsNum].FDetectStr:= sExt;
      FPluginsList[FPluginsNum].FEnabled:= true;
      end;
    end;
end;

procedure TFormViewUV.LoadPluginsOptions;
const
  cPdfFN = 'sLister\slister.wlx';
  cPdfExt = 'EXT:pdf,djvu,djv,xps,cbz,cbr,chm,mobi,epub,fb2,fbz,fb2z,pdb,prc,tcr';
  cIcoFN = 'ICLView\ICLView.wlx';
  cIcoExt = 'EXT:ico,icl,exe,dll,scr,ocx,bpl,wlx,wfx,wcx,wdx,wlx64,wfx64,wcx64,wdx64,cpl,acm,ax';
var
  i: integer;
  fn: TWlxFilename;
  detect: string;
  en: boolean;
begin
  //Load plugins
  FPluginsNum:= 0;
  for i:= 0 to High(TPluginsList) - 1 do
    begin
    fn:= FIni.ReadString(csPlugins, IntToStr(i), '');
    fn:= SExpandVars(fn);
    if fn = '' then Break;
    detect:= FIni.ReadString(csPlugins, IntToStr(i) + ccPDetect, '');
    en:= FIni.ReadBool(csPlugins, IntToStr(i) + ccPEnabled, true);

    if FPluginsNum < High(TPluginsList) then
      begin
      Inc(FPluginsNum);
      FPluginsList[FPluginsNum].FFileName:= fn;
      FPluginsList[FPluginsNum].FDetectStr:= detect;
      FPluginsList[FPluginsNum].FEnabled:= en;
      end;
    end;

  //Load preinst
  LoadPluginPre(cIcoFN, cIcoExt);
  LoadPluginPre(cPdfFN, cPdfExt);

  //Load into Viewer
  Viewer.RemovePlugins;
  for i:= Low(TPluginsList) to High(TPluginsList) do
    with FPluginsList[i] do
      if FEnabled then
        Viewer.AddPlugin(FFileName, FDetectStr);
  InitPlugins;
end;

procedure TFormViewUV.SavePluginsOptions;
var
  i: integer;
  S: string;
begin
  for i:= Low(TPluginsList) to High(TPluginsList) do
    begin
    S:= IntToStr(i-1);
    if i <= FPluginsNum then
      with FPluginsList[i] do
        begin
        FIniSave.WriteString(csPlugins, S, SCollapseVars(FFileName));
        FIniSave.WriteString(csPlugins, S + ccPDetect, FDetectStr);
        FIniSave.WriteBool(csPlugins, S + ccPEnabled, FEnabled);
        end
    else
      begin
      FIniSave.DeleteKey(csPlugins, S);
      FIniSave.DeleteKey(csPlugins, S + ccPDetect);
      FIniSave.DeleteKey(csPlugins, S + ccPEnabled);
      end;
    end;

  FIniSave.WriteBool(csOpt, ccPPrior, Viewer.PluginsHighPriority);
  FIniSave.WriteBool(csOpt, ccPTcVar, FPluginsTotalcmdVar);
  FIniSave.WriteBool(csOpt, ccPHideKeys, FPluginsHideKeys);
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ResizePlugin;
var
  Pnt: TPoint;
begin
  with Viewer do
    begin
    Pnt:= Self.ScreenToClient(ClientToScreen(Point(0, 0)));
    ResizeActivePlugin(Rect(Pnt.X, Pnt.Y, Pnt.X + Width, Pnt.Y + Height));
    end;
end;

procedure TFormViewUV.ViewerPluginsBeforeLoading(const APluginName: String);
begin
  UpdateCaption(APluginName, true);
end;

procedure TFormViewUV.ViewerPluginsAfterLoading(const APluginName: String);
begin
  UpdateCaption(APluginName, false);
end;

procedure TFormViewUV.TntFormResize(Sender: TObject);
begin
  ResizePlugin;
  UpdateImageLabel;
  {$ifdef NAV}
  NavMove;
  {$endif}
end;

procedure TFormViewUV.mnuOptionsPluginsClick(Sender: TObject);
var
  i: integer;
  OldFileName: WideString;
begin
  with TFormPluginsOptions.Create(Self) do
    try
      List.Items.BeginUpdate;
      List.Items.Clear;
      for i:= Low(TPluginsList) to High(TPluginsList) do
        if i<=FPluginsNum then
          with FPluginsList[i] do
            with List.Items.Add do
              begin
              Checked:= FEnabled;
              Caption:= SPluginName(FFileName);
              SubItems.Add(FDetectStr);
              SubItems.Add(FFileName);
              end;
      List.Items.EndUpdate;

      chkPriority.Checked:= Viewer.PluginsHighPriority;
      chkTCVar.Checked:= FPluginsTotalcmdVar;
      chkHideKeys.Checked:= FPluginsHideKeys;
      FConfigFolder:= ConfigFolder;

      if ShowModal=mrOk then
        begin
        //Close file
        OldFileName:= FFileName;
        CloseFile;
        Application.ProcessMessages;

        //Reload and init plugins
        FPluginsNum:= 0;
        for i:= 0 to List.Items.Count-1 do
          with List.Items[i] do
            if FPluginsNum<High(TPluginsList) then
              begin
              Inc(FPluginsNum);
              FPluginsList[FPluginsNum].FFileName:= SubItems[1];
              FPluginsList[FPluginsNum].FDetectStr:= SubItems[0];
              FPluginsList[FPluginsNum].FEnabled:= Checked;
              end;

        Viewer.RemovePlugins;
        for i:= Low(TPluginsList) to High(TPluginsList) do
          if i<=FPluginsNum then
            with FPluginsList[i] do
              if FEnabled then
                Viewer.AddPlugin(FFileName, FDetectStr);
        InitPlugins;

        Viewer.PluginsHighPriority:= chkPriority.Checked;
        FPluginsTotalcmdVar:= chkTCVar.Checked;
        FPluginsHideKeys:= chkHideKeys.Checked;

        //Save options and reopen previous file
        SavePluginsOptions;
        LoadFile(OldFileName);
        end;
    finally
      Release;
    end;
end;


procedure TFormViewUV.WMDropFiles(var Message: TWMDROPFILES);
var
  Count: UINT;
  BufA: array[0..MAX_PATH] of char;
  BufW: array[0..MAX_PATH] of WideChar;
  Name: WideString;
begin
  Name:= '';
  Count:= DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  if Count>0 then
    begin
    if Win32Platform=VER_PLATFORM_WIN32_NT then
      begin
      DragQueryFileW(Message.Drop, 0, @BufW, SizeOf(BufW) div 2);
      Name:= BufW;
      end
    else
      begin
      DragQueryFileA(Message.Drop, 0, @BufA, SizeOf(BufA));
      Name:= string(BufA);
      end;
    end;
  DragFinish(Message.Drop);

  if (Name <> '') and IsFileExist(Name) then
    LoadFile(Name);
end;

procedure TFormViewUV.WMCommand(var Message: TMessage);
begin
  inherited;
  if Message.WParamHi=itm_percent then
    Viewer.PluginsSendMessage(Message);
end;

procedure TFormViewUV.WMActivate(var Msg: TWMActivate);
begin
  inherited;

  if Msg.Active = WA_ACTIVE then
    if Viewer.IsFocused then
      Viewer.FocusActiveControl;

  Msg.Result:= 0;
end;

procedure TFormViewUV.AppActivate(Sender: TObject);
begin
  if FNoTaskbarIcon then
    ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormViewUV.ViewerMediaPlaybackEnd(Sender: TObject);
begin
  if MediaAutoAdvance then
    if Assigned(FFileList) then
      with FFileList do
        if Locked and (ListIndex < Count-1) then
          begin
          mnuFileNextClick(Self);
          end;
end;

procedure TFormViewUV.mnuViewAlwaysOnTopClick(Sender: TObject);
begin
  ShowOnTop:= not ShowOnTop;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewFullScreenClick(Sender: TObject);
begin
  ShowFullScreen:= not ShowFullScreen;
  UpdateOptions;
end;

function TFormViewUV.GetShowOnTop: boolean;
begin
  Result:= GetFormOnTop(Self);
end;

procedure TFormViewUV.SetShowOnTop(AValue: boolean);
begin
  if GetShowOnTop<>AValue then
    SetFormOnTop(Self, AValue);
end;

procedure TFormViewUV.SetShowFullScreen(AValue: boolean);
begin
  if FShowFullScreen <> AValue then
    begin
    FShowFullScreen:= AValue;
    {$ifdef NAV}
    if AValue then
      ShowNav:= false;
    {$endif}

    //Update menu and form state
    ShowMenu:= ShowMenu;
    SetFormStyle(Self, not AValue);

    if AValue then
      begin
      if not ShowToolbarFS then
      begin
        Toolbar.AutoSize:= false;
        Toolbar.Height:= 1;
      end;  
      FBoundsRectOld:= BoundsRect;
      BoundsRect:= Monitor.BoundsRect; //Seems like correct, puts on current monitor
      end
    else
      begin
      Toolbar.Autosize:= true;
      BoundsRect:= FBoundsRectOld;
      end;
    end;
end;

procedure TFormViewUV.SetShowMenu(AValue: boolean);
var
  En: boolean;
begin
  FShowMenu:= AValue;
  En:= FShowMenu and not ShowFullScreen;
  mnuFile.Visible:= En;
  mnuEdit.Visible:= En;
  mnuView.Visible:= En;
  mnuMode.Visible:= En;
  mnuOptions.Visible:= En;
  mnuTools.Visible:= En and (NumOfUserTools(FUserTools)>0);
  mnuHelp.Visible:= En;
end;

function TFormViewUV.GetShowMenuIcons: boolean;
begin
  Result:= Assigned(MainMenu1.Images);
end;

procedure TFormViewUV.SetShowMenuIcons(AValue: boolean);
begin
  if AValue then
    MainMenu1.Images:= ImageList1
  else
    MainMenu1.Images:= nil;
end;

function TFormViewUV.GetEnableMenu: boolean;
begin
  Result:= mnuFile.Enabled;
end;

procedure TFormViewUV.SetEnableMenu(AValue: boolean);
begin
  mnuFile.Enabled:= AValue;
  mnuEdit.Enabled:= AValue;
  mnuView.Enabled:= AValue;
  mnuOptions.Enabled:= AValue;
  mnuHelp.Enabled:= AValue;
end;

procedure TFormViewUV.mnuRecentClearClick(Sender: TObject);
begin
  ClearRecents;
end;

procedure TFormViewUV.mnuRecent0Click(Sender: TObject);
begin
  LoadFile(FRecentList[RecentItemIndex(Sender)]);
end;

procedure TFormViewUV.btnImageRotate90Click(Sender: TObject);
begin
  Viewer.ImageEffect(vieRotate90);
  UpdateOptions(true);
end;

procedure TFormViewUV.btnImageRotate270Click(Sender: TObject);
begin
  Viewer.ImageEffect(vieRotate270);
  UpdateOptions(true);
end;

procedure TFormViewUV.btnImageNegativeClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieNegative);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageGrayscaleClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieGrayscale);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageNegativeClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieNegative);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFlipVertClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieFlipVertical);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFlipHorzClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieFlipHorizontal);
  UpdateOptions;
end;


procedure TFormViewUV.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CloseFile;
  Action := caFree;
end;

procedure TFormViewUV.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if IsMHT then
    CanClose := True
  else
    CanClose := (not Viewer.WebBusy) or Application.Terminated;
end;

function TFormViewUV.IsMHT: boolean;
begin
  //Some MHT can cause webbrowser to hang and give
  //exception on loading (ZeroDevide). No wait for them.
  Result := SFileExtensionMatch(FFileName, 'mht');
end;


procedure TFormViewUV.LoadToolbar;
var
  S: AnsiString;
begin
  FToolbarList.AddAvail(mnuSep);
  FToolbarList.AddAvail(mnuFileOpen, MenuRecents);
  FToolbarList.AddAvail(mnuFileReload);
  FToolbarList.AddAvail(mnuFileSaveAs);
  FToolbarList.AddAvail(mnuFileClose);
  FToolbarList.AddAvail(mnuFilePrint);
  FToolbarList.AddAvail(mnuFilePrintPreview);
  FToolbarList.AddAvail(mnuFilePrintSetup);
  FToolbarList.AddAvail(mnuFilePrev);
  FToolbarList.AddAvail(mnuFileNext);
  FToolbarList.AddAvail(mnuFileRename);
  FToolbarList.AddAvail(mnuFileCopy);
  FToolbarList.AddAvail(mnuFileMove);
  FToolbarList.AddAvail(mnuFileDelete);
  FToolbarList.AddAvail(mnuFileCopyFN);
  FToolbarList.AddAvail(mnuFileEmail);
  FToolbarList.AddAvail(mnuFileLink);
  FToolbarList.AddAvail(mnuFileProp);
  FToolbarList.AddAvail(mnuFileExit);
  FToolbarList.AddAvail(mnuEditCopy);
  //FToolbarList.AddAvail(mnuEditCopyHex);
  FToolbarList.AddAvail(mnuEditCopyToFile);
  FToolbarList.AddAvail(mnuEditPaste);
  FToolbarList.AddAvail(mnuEditSelectAll);
  FToolbarList.AddAvail(mnuEditFind);
  FToolbarList.AddAvail(mnuEditFindNext);
  FToolbarList.AddAvail(mnuEditFindPrev);
  FToolbarList.AddAvail(mnuEditGoto);
  FToolbarList.AddAvail(mnuViewMode1);
  FToolbarList.AddAvail(mnuViewMode2);
  FToolbarList.AddAvail(mnuViewMode3);
  FToolbarList.AddAvail(mnuViewMode4);
  FToolbarList.AddAvail(mnuViewMode5);
  FToolbarList.AddAvail(mnuViewMode6);
  FToolbarList.AddAvail(mnuViewMode7);
  FToolbarList.AddAvail(mnuViewMode8);
  FToolbarList.AddAvail(mnuViewTextWrap);
  FToolbarList.AddAvail(mnuViewTextNonPrint);
  FToolbarList.AddAvail(mnuViewTextTail);
  FToolbarList.AddAvail(mnuViewTextANSI);
  FToolbarList.AddAvail(mnuViewTextOEM);
  FToolbarList.AddAvail(mnuViewTextMac);
  FToolbarList.AddAvail(mnuViewTextEncPrev);
  FToolbarList.AddAvail(mnuViewTextEncNext);
  FToolbarList.AddAvail(mnuViewTextEncMenu);
  FToolbarList.AddAvail(mnuViewImageFit);
  FToolbarList.AddAvail(mnuViewImageFitOnlyBig);
  FToolbarList.AddAvail(mnuViewImageFitWidth);
  FToolbarList.AddAvail(mnuViewImageFitHeight);
  FToolbarList.AddAvail(mnuViewImageCenter);
  FToolbarList.AddAvail(mnuViewImageFitWindow);
  FToolbarList.AddAvail(mnuViewImageShowEXIF);
  FToolbarList.AddAvail(mnuViewImageShowLabel);
  FToolbarList.AddAvail(mnuViewImageRotateRight);
  FToolbarList.AddAvail(mnuViewImageRotateLeft);
  FToolbarList.AddAvail(mnuViewImageFlipVert);
  FToolbarList.AddAvail(mnuViewImageFlipHorz);
  FToolbarList.AddAvail(mnuViewImageGrayscale);
  FToolbarList.AddAvail(mnuViewImageNegative);

  FToolbarList.AddAvail(mnuViewWebGoBack);
  FToolbarList.AddAvail(mnuViewWebGoForward);
  FToolbarList.AddAvail(mnuViewWebOffline);

  FToolbarList.AddAvail(mnuViewZoomIn);
  FToolbarList.AddAvail(mnuViewZoomOut);
  FToolbarList.AddAvail(mnuViewZoomOriginal);

  FToolbarList.AddAvail(mnuViewShowNav);
  FToolbarList.AddAvail(mnuViewShowMenu);
  FToolbarList.AddAvail(mnuViewShowToolbar);
  FToolbarList.AddAvail(mnuViewShowStatusbar);
  FToolbarList.AddAvail(mnuViewAlwaysOnTop);
  FToolbarList.AddAvail(mnuViewFullScreen);

  FToolbarList.AddAvail(mnuOptionsConfigure);
  FToolbarList.AddAvail(mnuOptionsPlugins);
  FToolbarList.AddAvail(mnuOptionsToolbar);
  FToolbarList.AddAvail(mnuOptionsUserTools);
  FToolbarList.AddAvail(mnuOptionsEditIni);
  FToolbarList.AddAvail(mnuOptionsEditIniHistory);
  FToolbarList.AddAvail(mnuOptionsSavePos);

  FToolbarList.AddAvail(mnuUserTool1);
  FToolbarList.AddAvail(mnuUserTool2);
  FToolbarList.AddAvail(mnuUserTool3);
  FToolbarList.AddAvail(mnuUserTool4);
  FToolbarList.AddAvail(mnuUserTool5);
  FToolbarList.AddAvail(mnuUserTool6);
  FToolbarList.AddAvail(mnuUserTool7);
  FToolbarList.AddAvail(mnuUserTool8);
  FToolbarList.AddAvail(mnuHelpContents);
  FToolbarList.AddAvail(mnuHelpAbout);

  //Read option
  S:= FIni.ReadString(csToolbars, ccToolbarMain, cToolbarListDefault);
  SDelLastSpace(S);
  FToolbarList.CurrentString:= S;
end;

procedure TFormViewUV.SaveToolbar;
begin
  FIniSave.WriteString(csToolbars, ccToolbarMain, FToolbarList.CurrentString);
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ApplyToolbar;
begin
  FToolbarList.ApplyTo(Toolbar);
end;

procedure TFormViewUV.ApplyToolbarCaptions;
begin
  FToolbarList.UpdateCaptions;
end;

procedure TFormViewUV.mnuToolbarCustomizeClick(Sender: TObject);
begin
  if CustomizeToolbarDialog(FToolbarList) then
    begin
    ApplyToolbar;
    SaveToolbar;
    UpdateOptions;
    end;
end;

procedure TFormViewUV.mnuViewWebGoBackClick(Sender: TObject);
begin
  Viewer.WebGoBack;
end;

procedure TFormViewUV.mnuViewWebGoForwardClick(Sender: TObject);
begin
  Viewer.WebGoForward;
end;


procedure TFormViewUV.mnuHelpWebHomepageClick(Sender: TObject);
begin
  FOpenURL('http://www.uvviewsoft.com', Handle);
end;

procedure TFormViewUV.mnuHelpWebPluginsClick(Sender: TObject);
begin
  FOpenURL('http://www.uvviewsoft.com/lister_plugins.htm', Handle);
end;

procedure TFormViewUV.mnuHelpWebEmailClick(Sender: TObject);
begin
  FOpenURL('mailto:support@uvviewsoft.com', Handle);
end;


procedure TFormViewUV.UpdateImageLabel;
var
  S: string;
begin
  with Viewer do
    if IsImage and Assigned(ImageBox) then
      if ImageError then
        begin
        ImageBox.ImageLabel.Caption:= ImageErrorMessage;
        ImageBox.ImageLabel.Visible:= True;
        ImageBox.ImageLabel.Font.Color:= FImageLabelColorErr;
        end
      else
        begin
        S:= Format('%d x %d', [ImageWidth, ImageHeight]);
        if ImageScale <> 100 then
          S:= S + Format(' (%d%%)', [ImageScale]);
        ImageBox.ImageLabel.Caption:= S;
        ImageBox.ImageLabel.Visible:= FImageLabelVisible;
        ImageBox.ImageLabel.Font.Color:= FImageLabelColor;
        end;
end;

procedure TFormViewUV.mnuFileDeleteClick(Sender: TObject);
begin
  {$ifdef NAV}
  DoFileDelete;
  {$endif}
end;

procedure TFormViewUV.ViewerTextFileReload(Sender: TObject);
begin
  if IsFileExist(FFileName) then
    UpdateStatusBar
  else
    CloseFile;
end;

procedure TFormViewUV.mnuOptionsUserToolsClick(Sender: TObject);
begin
  with TFormViewToolList.Create(Self) do
    try
      CopyUserTools(Self.FUserTools, Tools);
      if ShowModal=mrOk then
        begin
        CopyUserTools(Tools, Self.FUserTools);
        SaveUserTools;
        ApplyUserTools;
        ApplyToolbar;
        UpdateOptions;
        end;
    finally
      Release;
    end;
end;

procedure TFormViewUV.mnuViewImageShowLabelClick(Sender: TObject);
begin
  FImageLabelVisible:= not FImageLabelVisible;
  UpdateOptions;
end;

procedure TFormViewUV.InitFormFindProgress;
begin
  if not Assigned(FFormFindProgress) then
    FFormFindProgress:= TFormViewFindProgress.Create(Self);
end;

procedure TFormViewUV.TimerShowTimer(Sender: TObject);
begin
  TimerShow.Enabled:= false;

  {$ifdef NAV}
  NavSync;
  {$endif}

  {$ifdef CMD}
  if FStartupPosDo then
    begin
    FStartupPosDo:= false;
    if FStartupPosPercent then
      Viewer.PosPercent:= FStartupPos
    else
    if FStartupPosLine then
      Viewer.PosLine:= FStartupPos
    else
      Viewer.PosOffset:= FStartupPos;
    end;

  if FStartupPrint then
    begin
    //Viewer.PrintDialog;
    Close;
    end;
  {$endif}
end;

//---------------------------------------------------------
// http://www.mustangpeak.net/phpBB2/viewtopic.php?p=3781#3781
//
procedure TFormViewUV.AppMessage(var Msg: TMsg; var Handled: boolean);
begin
  case Msg.Message of
    WM_XBUTTONUP:
      case HiWord(Msg.wParam) of
        $0001{MK_XBUTTON1}:
          begin
          if mnuFilePrev.Enabled then
            mnuFilePrevClick(Self);
          Handled:= true;
          end;
        $0002{MK_XBUTTON2}:
          begin
          if mnuFileNext.Enabled then
            mnuFileNextClick(Self);
          Handled:= true;
          end;
      end;
  end;
end;

function TFormViewUV.GetStatusVisible: boolean;
begin
  Result:= not ShowFullscreen;
end;


procedure TFormViewUV.UpdateStatusBar;
var
  PanelIndex: integer;

  procedure ClearText;
  var
    i: integer;
  begin
    PanelIndex:= 0;
    with StatusBar1 do
      for i:= 0 to Panels.Count-1 do
        Panels[i].Text:= '';
  end;

  procedure AddText(const AText: string; AWidth: integer = 0);
  begin
    with StatusBar1 do
      begin
      Panels[PanelIndex].Text:= AText;
      if AWidth > 0 then
        Panels[PanelIndex].Width:= AWidth;
      Inc(PanelIndex);
      end;
  end;

var
  ASize: Int64;
  ATime: TFileTime;
  S: string;
begin
  with StatusBar1 do
    begin
    Visible:= ShowStatusBar{Option} and GetStatusVisible{Need to show};
    if not Visible then Exit;
    end;

  ClearText;

  if FFileName = '' then Exit;

  if FGetFileInfo(FFileName, ASize, ATime) then
    begin
    AddText(FormatFileSize(ASize));
    AddText(FormatFileTime(ATime));
    end
  else
    begin
    AddText('');
    AddText('');
    end;

  case Viewer.Mode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode,
    vmodeRTF:
      AddText(Viewer.TextEncodingName);
    vmodeMedia:
      if Viewer.IsImage then
        begin
        S := Format('%d x %d', [Viewer.ImageWidth, Viewer.ImageHeight]);
        if Viewer.ImageBPP > 0 then
          S := S + Format(', %d BPP', [Viewer.ImageBPP]);
        AddText(S);
        end
      else
        AddText('');
    else
      AddText('');
  end;

  //Show file number only when list read
  if (FFileList.Count > 0) and
    (FFileList.ListIndex >= 0) then
    begin
    if FFileList.Locked then
      S := MsgString(307)
    else
      S := MsgString(306);
    AddText(Format(S, [FFileList.ListIndex + 1, FFileList.Count]));
    end;
end;


procedure TFormViewUV.mnuViewShowMenuClick(Sender: TObject);
begin
  ShowMenu:= not ShowMenu;
  ResizePlugin;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowToolbarClick(Sender: TObject);
begin
  ShowToolbar:= not ShowToolbar;
  ResizePlugin;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowStatusbarClick(Sender: TObject);
begin
  ShowStatusBar:= not ShowStatusBar;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowNavClick(Sender: TObject);
begin
  {$ifdef NAV}
  ShowNav:= not ShowNav;
  {$endif}
  UpdateOptions;
end;

procedure TFormViewUV.mnuOptionsEditIniClick(Sender: TObject);
begin
  FOpenURL(FIniName, Handle);
end;

procedure TFormViewUV.mnuOptionsEditIniHistoryClick(Sender: TObject);
begin
  FOpenURL(FIniNameHist, Handle);
end;

procedure TFormViewUV.mnuViewZoomInClick(Sender: TObject);
begin
  Viewer.IncreaseScale(true);
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewZoomOutClick(Sender: TObject);
begin
  Viewer.IncreaseScale(false);
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewZoomOriginalClick(Sender: TObject);
begin
  if (Viewer.Mode=vmodeMedia) and (Viewer.IsImage) then
    begin
    Viewer.ImageScale:= 100;
    UpdateOptions(true);
    end;
end;

procedure TFormViewUV.mnuViewImageFitWindowClick(Sender: TObject);
begin
  MediaFitWindow:= not MediaFitWindow;
  UpdateOptions(true);
end;

procedure TFormViewUV.ViewerOptionsChange(ASender: TObject);
begin
  UpdateOptions;
end;

procedure TFormViewUV.ViewerFileLoad(S: TObject);
begin
  if ShowFullScreen then Exit;
  case Viewer.Mode of
   vmodeText,
   vmodeBinary,
   vmodeHex,
   vmodeUnicode:
     if FUText then Height:= FHText;
   vmodeMedia:
     if FUImage and Viewer.IsImage then Height:= FHImage;
   vmodeWeb:
     if FUWeb then Height:= FHWeb;
   vmodeWLX:
     begin
     if FUPlug then Height:= FHPlug;
     FixLister;
     end;
   vmodeRTF:
     if FURtf then Height:= FHRtf;
  end;
end;

procedure TFormViewUV.mnuHelpContentsClick(Sender: TObject);
begin
  ShowHelp(Handle);
end;

procedure TFormViewUV.mnuFileRenameClick(Sender: TObject);
begin
  {$ifdef NAV}
  DoFileRename;
  {$endif}
end;

procedure TFormViewUV.mnuFileCopyClick(Sender: TObject);
begin
  {$ifdef NAV}
  DoFileCopy;
  {$endif}
end;

procedure TFormViewUV.mnuFileMoveClick(Sender: TObject);
begin
  {$ifdef NAV}
  DoFileMove;
  {$endif}
end;

procedure TFormViewUV.InitPreview;
begin
  {$I Lang.FormViewPreview.inc}
end;

procedure TFormViewUV.mnuOptionsSavePosClick(Sender: TObject);
begin
  SavePosition;
end;

procedure TFormViewUV.mnuFilePropClick(Sender: TObject);
begin
  FShowProperties(FFileName, Handle);
end;

procedure TFormViewUV.mnuViewTextEncMenuClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Mouse.CursorPos;
  Viewer.TextEncodingsMenu(P.X, P.Y);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextEncPrevClick(Sender: TObject);
begin
  with Viewer do
  begin
    if TextEncoding > 0  then
      TextEncoding := Pred(TextEncoding)
    else
      TextEncoding := High(cCodepages);
  end;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextEncNextClick(Sender: TObject);
begin
  with Viewer do
  begin
    if TextEncoding < High(cCodepages) then
      TextEncoding := Succ(TextEncoding)
    else
      TextEncoding := 0;
  end;
  UpdateOptions;
end;

procedure TFormViewUV.UpdateShortcuts;
begin
  if FPluginsHideKeys then
  begin
    if (FFileName <> '') and (Viewer.Mode = vmodeWLX) then
      FToolbarList.PrepareShortcuts
    else
      FToolbarList.RestoreShortcuts;
  end;
end;

procedure TFormViewUV.StatusBar1Click(Sender: TObject);
var
  P: TPoint;
  X1: Integer;
begin
  with StatusBar1 do
    begin
    P := ScreenToClient(Mouse.CursorPos);
    X1 := Panels[0].Width + Panels[1].Width;
    if (P.X >= X1) and (P.X <= X1 + Panels[2].Width) then
      if mnuViewTextEncMenu.Enabled then
        mnuViewTextEncMenuClick(Self);
    end;
end;

function TFormViewUV.GetFollowTail: boolean;
begin
  Result:=
    Viewer.TextAutoReload and
    Viewer.TextAutoReloadFollowTail;
end;

procedure TFormViewUV.SetFollowTail(AValue: boolean);
begin
  Viewer.TextAutoReloadFollowTail:= AValue;
  if AValue then
    Viewer.TextAutoReload:= AValue;
end;

procedure TFormViewUV.mnuEditCopyToFileClick(Sender: TObject);
var
  OK: boolean;
begin
  if TextNotSelected then
    begin
    MsgTextNotSelected;
    Exit;
    end;

  with SaveDialog1 do
    begin
    FileName:= FNumberName( SExtractFileDir(FFileName) + '\Text (%d).txt' );
    InitialDir:= SExtractFileDir(FFileName);
    if Execute then
      begin
      Screen.Cursor:= crHourGlass;
      try
        if Viewer.Mode <> vmodeUnicode
          then OK:= FFileWriteStringA(FileName, Viewer.TextSelText)
          else OK:= FFileWriteStringW(FileName, Viewer.TextSelTextW);
      finally
        Screen.Cursor:= crDefault;
      end;
      if not OK then
        MsgCopyMoveError('(Text)', FileName, Handle);
      end;
    end;
end;

//--------------------------------------------------------
function TFormViewUV.RecentItemIndex(Sender: TObject): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to High(TRecentMenus) do
    if (Sender = FRecentMenus[i]) or (Sender = FRecentMenusBar[i]) then
      begin
      Result:= i;
      Break
      end;
end;

const
  cMenuOffsetX = 18; //Offset lefter than menu item text
  cMenuOffsetX2 = 16; //Offset righter then menu item text

procedure TFormViewUV.mnuRecent0MeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
const
  cHeight = 18;
begin
  Width:= STextWidth(ACanvas, FRecentList[RecentItemIndex(Sender)])
    + cMenuOffsetX
    + cMenuOffsetX2;
  if not ShowMenuIcons then
    Height:= cHeight;
end;

procedure TFormViewUV.mnuRecent0DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
const
  cColors: array[boolean] of TColor = (clMenu, clHighlight);
  cOffsetX = 4; //Offsets to draw menuitem correctly
  cOffsetY = 2;
begin
  ACanvas.Brush.Color := cColors[Selected];
  ACanvas.FillRect(ARect);
  STextOut(ACanvas,
    ARect.Left + cMenuOffsetX + cOffsetX,
    ARect.Top + cOffsetY,
    FRecentList[RecentItemIndex(Sender)]);
end;

//--------------------------------------------------------
function TFormViewUV.IsImageListSaved: boolean;
begin
  Result:= ImageListS.Count > 0;
end;

//--------------------------------------------------------
procedure TFormViewUV.SetIconsName(const Name: string);
begin
  if FIconsName <> Name then
  begin
    FIconsName:= Name;
    if FIconsName = '' then
      begin
      if IsImageListSaved then
        begin
        ImageList1.Clear;
        ImageList1.Width:= 16;
        ImageList1.Height:= 16;
        ImageList1.AddImages(ImageListS);
        end;
      end
    else
      begin
      if not IsImageListSaved then
        ImageListS.AddImages(ImageList1);
      FLoadIcons(ImageList1, SIconsFN(Name));
      end;

    ApplyToolbar;
    ApplyUserTools;
  end;
end;

procedure TFormViewUV.mnuViewImageShowEXIFClick(Sender: TObject);
begin
  {$ifdef EXIF}
  ShowEXIF(FFileNameWideToAnsi(FFileName));
  {$endif}
end;


procedure TFormViewUV.mnuEditPasteClick(Sender: TObject);
var
  S: WideString;
begin
  //Is Clipboard file opened?
  if (FFileName <> '') and
    (FFileName = FTempClip(SExtractFileExt(FFileName))) then
    CloseFile;

  S := FPasteToFile;
  if (S <> '') then
    LoadFile(S);
end;


procedure TFormViewUV.mnuFileEmailClick(Sender: TObject);
begin
  {$ifdef NAV}
  NavOp('mail', MsgString(153), FFileName, '', '', False{fWait});
  {$endif}
end;


procedure TFormViewUV.ViewerStatusTextChange;
var
  S: string;
  N: Integer;
begin
  S := Text;
  with StatusBar1 do
  begin
    N := Panels[2].Width - 8;
    Canvas.Font := Font; //VCL misses Canvas.Font setting
    if Canvas.TextWidth(S) > N then
    begin
      S := S + #$85;
      while (Length(S) > 1) and (Canvas.TextWidth(S) > N) do
        Delete(S, Length(S) - 1, 1);
    end;
    Panels[2].Text := S;
  end;
end;

procedure TFormViewUV.ViewerTitleChange;
begin
  UpdateCaption('', false, Text);
end;

procedure TFormViewUV.mnuFileCopyFNClick(Sender: TObject);
begin
  SCopyToClipboardW(FFileName);
end;

{$ifdef NAV}
function TFormViewUV.GetShowNav: boolean;
begin
  Result:= FNavHandle <> 0;
end;
{$endif}

{$ifdef NAV}
procedure TFormViewUV.SetShowNav(AValue: boolean);
var
  S: WideString;
begin
  if AValue <> GetShowNav then
    if AValue then
    begin
      S := SParamDir + '\Nav.exe';
      if IsFileExist(S) then
      begin
        FExecute(S, SFormatW('%s "%s" "%s" "%s"', [
            IntToStr(Handle),
            SMsgLanguage,
            ConfigFolder + '\ViewerHistory.ini',
            ActiveFileName]),
          Handle);
      end
      else
        MsgError(MsgViewerNavMissed);
    end
    else
      SendMessage(FNavHandle, WM_CLOSE, 0, 0);
end;
{$endif}

{$ifdef NAV}
procedure TFormViewUV.WMDisp(var Msg: TMessage);
begin
  case Msg.WParam of
    cAppHandle:
    begin
      Msg.Result := 1;
      FNavHandle := Msg.LParam;
      UpdateOptions;
    end;
    else
      Msg.Result := 0;
  end;
end;
{$endif}

function TFormViewUV.ActiveFileName: WideString;
begin
  Result := FFileName;
  if Result = '' then
    Result := FFileFolder;
end;

{$ifdef NAV}
procedure TFormViewUV.NavSync;
var
  Data: TCopyDataStruct;
  S: WideString;
begin
  S := ActiveFileName;
  if S <> '' then
  begin
    Application.ProcessMessages; //Wait to receive nav handle
    FillChar(Data, SizeOf(Data), 0);
    Data.dwData := 101; //"Open Unicode filename"
    Data.cbData := (Length(S) + 1) * 2;
    Data.lpData := PWideChar(S);
    SendMessage(FNavHandle, WM_COPYDATA, Handle, integer(@Data));
  end;
end;
{$endif}

{$ifdef NAV}
procedure TFormViewUV.NavMove;
begin
  SetWindowPos(FNavHandle, Handle, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SendMessage(FNavHandle, EM_DISPLAYBAND, 0, 0);
end;

procedure TFormViewUV.WMMove;
begin
  NavMove;
end;
{$endif}

procedure TFormViewUV.TimerWMTimer(Sender: TObject);
begin
  TimerWM.Enabled:= false;
  LoadFile(FFileNameWM, true{AKeepList}, false{ASyncNav});
end;

procedure TFormViewUV.PanelTopClick(Sender: TObject);
begin
  if FFileName <> '' then
    LoadFile(FFileName, true{AKeepList},
      false{ASyncNav}, true{ADoConv});
end;

function TFormViewUV.ConvName(const AFileName: WideString): WideString;
begin
  Result:= FTempText;
  FDelete(Result);
  if IsFileExist(Result) then
    begin
    MsgError(MsgString(156));
    Result:= '';
    Exit
    end;
  {$ifdef NAV}
  NavOp('conv', AFileName, Result);
  {$endif}

  if IsFileExist(Result) and (FGetFileSize(Result) = 0) then
    FDelete(Result);
  if not IsFileExist(Result) then
    begin
    MsgError(MsgString(155) + #13#13 + MsgString(313));
    Result:= '';
    end;
end;

(*
function TFormViewUV.ChmUrl(const AFileName: WideString): WideString;
var
  S: WideString;
  f: TextFile;
begin
  Result:= '';

  S:= SParamDir + '\Conv\chmidxfinder.exe';
  if not IsFileExist(S) then Exit;

  FDelete(FTempText);
  if not FExecShell(S, SFormatW('"%s" "%s"', [AFileName, FTempText]),
           '', SW_HIDE, True{fWait}) then Exit;
  if not IsFileExist(FTempText) then Exit;

  {$I-}
  System.AssignFile(f, FTempText);
  System.Reset(f);
  Readln(f, Result);
  System.CloseFile(f);
  {$I+}

  FDelete(FTempText);
end;
*)

//-------------------------
procedure TFormViewUV.mnuFileLinkClick(Sender: TObject);
var
  S, fn: WideString;
begin
  if WideSelectDirectory(MsgString(310), '', S) then
  begin
    if (S <> '') and (S[Length(S)] = '\') then
      Delete(S, Length(S), 1);
    if (S <> '') and (S[Length(S)] <> ':') and not IsDirExist(S) then
    begin
      MsgError(Format(MsgViewerErrCannotFindFolder, [S]));
      Exit
    end;
    fn := S + '\Viewer - ' + SExtractFileName(FFileName) + '.lnk';
    if not FCreateLink('"' + Application.ExeName + '"', fn, '', '"' + FFileName + '"') then
      MsgError(MsgString(311) + #13 + fn)
    else
      MsgInfo(MsgString(312) + #13 + fn);
  end;
end;

procedure TFormViewUV.SetShowToolbarFS(Value: boolean);
begin
  if FShowToolbarFS <> Value then
  begin
    FShowToolbarFS := Value;
    if ShowFullScreen and ShowToolbar then
      if Value then
        Toolbar.Autosize:= true
      else
      begin
        Toolbar.AutoSize:= false;
        Toolbar.Height:= 1;
      end;
  end;
end;

procedure TFormViewUV.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Viewer.Mode = vmodeMedia) and Viewer.IsImage then
  begin
    if (Key = vk_space) and (Shift = []) then
    begin
      DoFileNext(true, true);
      Key:= 0;
      Exit
    end;
    if (Key = vk_back) and (Shift = []) then
    begin
      DoFileNext(false, true);
      Key:= 0;
      Exit
    end;
  end;

end;

procedure TFormviewUV.FixLister;
begin
  if LowerCase(Viewer.ActivePluginName) = 'slister' then
  begin
    SendToBack;
    BringToFront;
    Viewer.SetFocus;
    Viewer.FocusActiveControl;
  end;
end;

function TFormviewUV.FTempPic;
begin
  Result:= FTempPath + 'UV_temp' + ext;
end;

procedure TFormViewUV.mnuViewImageFitWidthClick(Sender: TObject);
begin
  Viewer.MediaFitWidth:= not Viewer.MediaFitWidth;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFitHeightClick(Sender: TObject);
begin
  Viewer.MediaFitHeight:= not Viewer.MediaFitHeight;
  UpdateOptions;
end;

procedure TFormViewUV.mnuHelpForumEngClick(Sender: TObject);
begin
  FOpenURL('http://ghisler.ch/board/viewtopic.php?t=10913', Handle);
end;

procedure TFormViewUV.mnuHelpForumRusClick(Sender: TObject);
begin
  FOpenURL('http://forum.wincmd.ru/viewtopic.php?t=5654', Handle);
end;

procedure TFormViewUV.TestLClick;
begin
  //Caption:= 'l';
end;

procedure TFormViewUV.TestRClick;
begin
  //Caption:= 'r';
end;

initialization
  MsgViewerCaption := 'Universal Viewer';
  SSetEnv('ATViewer', SParamDir);
  {$ifdef CMD}
  CheckCommandLine;
  {$endif}
end.

