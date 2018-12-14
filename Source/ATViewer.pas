{****************************************}
{                                        }
{  ATViewer component                    }
{  Copyright (C) Alexey Torgashin        }
{  http://uvviewsoft.com                 }
{                                        }
{****************************************}

{$OPTIMIZATION OFF} //Delphi 5 cannot compile this with optimization on
{$BOOLEVAL OFF}    //Short boolean evaluation required
{$RANGECHECKS OFF} //For Loword/Hiword functions to work

{$I Compilers.inc}      //Compilers defines
{$I ATViewerOptions.inc} //ATViewer options

unit ATViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics,
  StdCtrls, ExtCtrls, ComCtrls, Forms, Menus, Jpeg,
  ATxPanel,
  {$ifdef TNT} TntExtCtrls, {$endif}
  {$ifdef WLX} WLXProc, {$endif}
  {$ifdef IE4X} WebBrowser4_TLB, {$else} SHDocVw, {$endif}
  {$ifdef PRINT} Dialogs, {$endif}
  {$ifdef SEARCH} ATStreamSearch, {$endif}
  {$ifdef PREVIEW} ATPrintPreview, ATxPrintProc, {$endif}
  ATBinHex,
  ATImageBox,
  ATxCodepages,
  ATxREProc;

type
  TATViewerMode = (
    vmodeNone,
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode,
    vmodeRTF,
    vmodeMedia,
    vmodeWeb
    {$ifdef WLX}, vmodeWLX {$endif}
    );

  TATViewerModes = set of TATViewerMode;

  TATViewerOfficeEvent = procedure(Sender: TObject; var ADo: boolean) of object;
  TATViewerImageMouseEvent = procedure(Sender: TObject; Btn, Shift, X, Y: Integer) of object;

const
  vfo_Words = 1;
  vfo_Case = 2;
  vfo_Back = 4;
  vfo_RegEx = 8;
  vfo_FromPage = 16;
  vfo_ShowAll = 32;

type
  TATViewerImageEffect = (
    vieNone,
    vieRotate90,
    vieRotate270,
    vieRotate180,
    vieGrayscale,
    vieSepia,
    vieNegative,
    vieFlipVertical,
    vieFlipHorizontal
    );

{$ifdef IJL}
type
  TATIJLIntegration = record
    Enabled: Boolean;
    ExtList: AnsiString;
  end;
{$endif}

type
  TATViewerLoadImageStream = procedure(Sender: TObject;
    AImageBox: TATImageBox; AStream: TStream) of object;
  TATViewerLoadWebStream = procedure(Sender: TObject;
    ABrowser: TWebBrowser; AStream: TStream) of object;

type
  TATViewer = class({$ifdef TNT}TTntPanel{$else}TPanel{$endif})
  private
    FNoCtx: boolean;
    FPanelDemo: TATTextPanel;
    FLic: WideString;
    FFileName: WideString;
    FFileSize: Int64;
    FFileTime: TFileTime;
    FStream: TStream;
    FBinHex: TATBinHex;
    FTextPanel,
    FTextPanel0,
    FTextPanelErr: TATTextPanel;
    FImageBox: TATImageBox;
    FImageUpDown: TUpDown;
    FEdit: TRichEdit;
    FEditShowAll: Boolean;
    FEditMenu: TPopupMenu;
    FEditMenuItemCopy: TMenuItem;
    FEditMenuItemSelectAll: TMenuItem;
    FEditMenuItemSep: TMenuItem;
    FErrTimer: TTimer;

    FBrowser: TWebBrowser;

    {$ifdef WLX}
    FPlugins: TWlxPlugins;
    FPluginsHighPriority: Boolean;
    {$endif}

    {$ifdef PRINT}
    FPrintDialog: TPrintDialog;
    FPageSetupDialog: {$ifdef COMPILER_7_UP} TPageSetupDialog {$else} TPrintDialog {$endif};
    {$endif}

    {$ifdef IJL}
    FIJLIntegration: TATIJLIntegration;
    {$endif}

    FMode: TATViewerMode;
    FModeDetect: Boolean;
    FModeUndetected: TATViewerMode;
    FModeUndetectedCfm: Boolean;
    FModesDisabledForDetect: TATViewerModes;
    FSourceType: TATFileSource;
    FTextEncoding: TATEncoding;
    FTextWrap: Boolean;
    FTextDetect: Boolean;
    FTextDetectSize: DWORD;
    FTextDetectLimit: DWORD;
    FTextDetectOEM: Boolean;
    FTextDetectUTF8: Boolean;
    FMediaFit,
    FMediaFitOnlyBig,
    FMediaFitWidth,
    FMediaFitHeight,
    FMediaCenter: Boolean;
    {$ifdef OFFLINE}
    FWebOffline: Boolean;
    {$endif}
    FWebAcceptAllFiles: Boolean;
    FWebWaitForNavigate: Boolean;
    FTextColor: TColor;
    FTextAutoCopy: Boolean;
    FFocused: Boolean;
    FBorderStyleInner: TBorderStyle;

    {$ifdef SEARCH}
    FFindText: WideString;
    FFindOptions: TATStreamSearchOptions;
    FFindFinished: Boolean;
    FEditLastSearch: TRELastSearch;
    {$endif}

    FIsImage: Boolean;       //Image is currently loaded
    FIsImageBefore: Boolean; //Image was loaded before the last FreeData call
    FIsImageIView: Boolean;  //Image was loaded using IrfanView/XnView
    FIsImageIJL: Boolean;    //Image was loaded using IJL
    FIsIcon: Boolean;        //Icon is currently loaded
    FIsMetafile: Boolean;    //Metafile is currently loaded
    FIsGif: Boolean;

    FImageBPP: Integer;
    FImageColor: TColor;
    FImageAnimate: Boolean;
    FImageTransparent: Boolean;
    FImageResample: Boolean;
    FImageKeepPosition: Boolean;
    FImageDrag: Boolean;
    FImageCursor: TCursor;
    FImageDragCursor: TCursor;
    FImageError: Boolean;
    FImageErrorMessage: AnsiString;
    FImageErrorMessageBox: Boolean;
    FImagePage: Integer;
    FImagePagesCount: Integer;

    FSearchIndentVert: Integer;
    FSearchIndentHorz: Integer;

    FOnImageMouseUp: TATViewerImageMouseEvent;
    FOnImageMouseDown: TATViewerImageMouseEvent;
    FOnImageMouseMove: TATViewerImageMouseEvent;
    FOnImageLClick: TNotifyEvent;
    FOnImageRClick: TNotifyEvent;
    FOnWebDocumentComplete: TNotifyEvent;
    FOnWebNavigateComplete: TNotifyEvent;
    FOnWebStatusTextChange: TWebBrowserStatusTextChange;
    FOnWebTitleChange: TWebBrowserTitleChange;
    FOnModeDetected: TNotifyEvent;
    FOnFileLoad: TNotifyEvent;
    FOnFileUnload: TNotifyEvent;
    FOnOptionsChange: TNotifyEvent;
    FOnLoadImageStream: TATViewerLoadImageStream;
    FOnLoadWebStream: TATViewerLoadWebStream;

    procedure SetNoCtx(V: boolean);
    {$ifdef PRINT}
    procedure InitDialogs;
    {$endif}
    procedure InitEdit;
    procedure InitImage;
    procedure InitWeb;
    function CanSetFocus: Boolean;
    procedure SetBorderStyleInner(AValue: TBorderStyle);
    procedure SetMode(AValue: TATViewerMode);
    function GetTextEncoding: TATEncoding;
    procedure SetTextEncoding(AValue: TATEncoding);
    procedure SetTextWrap(AValue: Boolean);
    function GetTextWidth: Integer;
    function GetTextWidthHex: Integer;
    function GetTextWidthFit: Boolean;
    function GetTextWidthFitHex: Boolean;
    function GetTextWidthFitUHex: Boolean;
    function GetTextOemSpecial: Boolean;
    function GetTextNonPrintable: Boolean;
    function GetTextUrlHilight: Boolean;

    function GetTextGutter: Boolean;
    function GetTextGutterLines: Boolean;
    function GetTextGutterLinesStep: Integer;
    function GetTextGutterLinesBufSize: Integer;
    function GetTextGutterLinesCount: Integer;
    function GetTextGutterLinesExtUse: Boolean;
    function GetTextGutterLinesExtList: AnsiString;

    procedure SetTextWidth(AValue: Integer);
    procedure SetTextWidthHex(AValue: Integer);
    procedure SetTextWidthFit(AValue: Boolean);
    procedure SetTextWidthFitHex(AValue: Boolean);
    procedure SetTextWidthFitUHex(AValue: Boolean);
    procedure SetTextOemSpecial(AValue: Boolean);
    procedure SetTextNonPrintable(AValue: Boolean);
    procedure SetTextUrlHilight(AValue: Boolean);

    procedure SetTextGutter(AValue: Boolean);
    procedure SetTextGutterLines(AValue: Boolean);
    procedure SetTextGutterLinesStep(AValue: Integer);
    procedure SetTextGutterLinesBufSize(AValue: Integer);
    procedure SetTextGutterLinesCount(AValue: Integer);
    procedure SetTextGutterLinesExtUse(AValue: Boolean);
    procedure SetTextGutterLinesExtList(const AValue: AnsiString);

    procedure SetSearchIndentVert(AValue: Integer);
    procedure SetSearchIndentHorz(AValue: Integer);
    procedure SetMediaFit(AValue: Boolean);
    procedure SetMediaFitOnlyBig(AValue: Boolean);
    procedure SetMediaFitWidth(AValue: Boolean);
    procedure SetMediaFitHeight(AValue: Boolean);
    procedure SetMediaCenter(AValue: Boolean);
    {$ifdef OFFLINE}
    procedure SetWebOffline(AValue: Boolean);
    {$endif}
    procedure SetTextColor(AValue: TColor);
    procedure SetTextColorBin(A: TColor);
    procedure SetTextFont(AValue: TFont);
    procedure SetTextFontOEM(AValue: TFont);
    procedure SetTextFontFooter(AValue: TFont);
    procedure SetTextFontGutter(AValue: TFont);
    function GetTextFont: TFont;
    function GetTextFontOEM: TFont;
    function GetTextFontFooter: TFont;
    function GetTextFontGutter: TFont;
    function GetTextColorHex: TColor;
    function GetTextColorHex2: TColor;
    function GetTextColorHexBack: TColor;
    function GetTextColorLines: TColor;
    function GetTextColorError: TColor;
    function GetTextColorGutter: TColor;
    function GetTextColorURL: TColor;
    function GetTextColorHi: TColor;
    procedure SetTextColorHex(AValue: TColor);
    procedure SetTextColorHex2(AValue: TColor);
    procedure SetTextColorHexBack(AValue: TColor);
    procedure SetTextColorLines(AValue: TColor);
    procedure SetTextColorError(AValue: TColor);
    procedure SetTextColorGutter(AValue: TColor);
    procedure SetTextColorURL(AValue: TColor);
    procedure SetTextColorHi(AValue: TColor);

    //ActiveX:
    function GetMessagesEnabled: boolean;
    procedure SetMessagesEnabled(V: boolean);
    function GetExtImages: Widestring;
    procedure SetExtImages(const S: Widestring);
    function GetExtInet: Widestring;
    procedure SetExtInet(const S: Widestring);

    procedure DetectMode;
    procedure LoadRTF;
    procedure LoadRTFStream;
    procedure LoadBinary;
    procedure LoadBinaryStream;
    procedure LoadImage(APicture: TPicture = nil; ANewImage: Boolean = True);
    procedure LoadImagePage(N: Integer);
    procedure LoadMedia(APicture: TPicture = nil);
    procedure ShowError(S: AnsiString);
    procedure UnloadImage;
    procedure ShowImageError(const Msg: AnsiString);
    procedure LoadImageStream;
    procedure LoadWeb;
    procedure LoadWebStream;

    {$ifdef WLX}
    function LoadWLX: Boolean;
    procedure HideWLX;
    procedure SendWLXCommand(ACmd, AParam: Integer);
    procedure SendWLXParams;
    function GetPluginsBeforeLoading: TWlxNameEvent;
    function GetPluginsAfterLoading: TWlxNameEvent;
    procedure SetPluginsBeforeLoading(AProc: TWlxNameEvent);
    procedure SetPluginsAfterLoading(AProc: TWlxNameEvent);
    function OpenByPlugins(AFileIsNew: Boolean): Boolean;
    function GetActivePluginSupportsSearch: Boolean;
    function GetActivePluginSupportsPrint: Boolean;
    function GetActivePluginSupportsCommands: Boolean;
    function GetActivePluginWindowHandle: THandle;
    procedure CloseActivePlugin;
    {$endif}

    procedure FreeSearch;
    procedure FreeData(AFreeImage: Boolean = True;
                       AFreeOffice: Boolean = True);
    procedure HideAll;
    procedure HideEdit;
    procedure HideImage;
    procedure HideWeb;
    procedure Enter(Sender: TObject);
    procedure ImageUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ImageBoxScroll(Sender: TObject);
    procedure ImageBoxScrollAlt(Sender: TObject; Inc: Boolean);
    procedure ImageBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    {$ifdef SEARCH}
    function GetSearchStarted: Boolean;
    function GetOnTextSearchProgress: TATStreamSearchProgress;
    procedure SetOnTextSearchProgress(AValue: TATStreamSearchProgress);
    {$endif}

    procedure ErrTimerTimer(Sender: TObject);
    procedure WebBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserStatusTextChange(Sender: TObject; const Text: WideString);
    procedure WebBrowserTitleChange(Sender: TObject; const Text: WideString);
    {$ifdef IE4X}
    procedure WebBrowserFileDownload(Sender: TObject; ActiveDocument: WordBool; var Cancel: WordBool);
    {$endif}
    function WebBrowserSafe: Boolean;
    function GetWebBusy: Boolean;

    {$ifdef PRINT}
    function PrinterCaption: AnsiString;
    procedure PrintEdit(ASelectionOnly: Boolean; ACopies: Integer);
    {$endif}

    function GetActivePluginName: AnsiString;
    function GetPosPercent: Integer;
    procedure SetPosPercent(APos: Integer);
    function GetPosOffset: Int64;
    procedure SetPosOffset(const APos: Int64);

    procedure EditMenuItemCopyClick(Sender: TObject);
    procedure EditMenuItemSelectAllClick(Sender: TObject);
    procedure TextURLClick(Sender: TObject; const S: AnsiString);
    procedure TextSelectionChange(Sender: TObject);
    procedure TextPanelClick(Sender: TObject);
    function DetectTextAndUnicode: Boolean;

    procedure DoWebDocumentComplete;
    procedure DoWebNavigateComplete;
    procedure DoWebStatusTextChange(const Text: WideString);
    procedure DoWebTitleChange(const Text: WideString);
    procedure DoModeDetected;
    procedure DoFileLoad;
    procedure DoFileUnload;
    procedure DoOptionsChange;
    procedure DoLoadImageStream;
    procedure DoLoadWebStream;

    {$ifdef NOTIF}
    function GetTextAutoReload: Boolean;
    function GetTextAutoReloadBeep: Boolean;
    function GetTextAutoReloadFollowTail: Boolean;
    procedure SetTextAutoReload(AValue: Boolean);
    procedure SetTextAutoReloadBeep(AValue: Boolean);
    procedure SetTextAutoReloadFollowTail(AValue: Boolean);
    function GetOnTextFileReload: TNotifyEvent;
    procedure SetOnTextFileReload(AEvent: TNotifyEvent);
    {$endif}

    function GetTextTabSize: Integer;
    procedure SetTextTabSize(AValue: Integer);
    function GetTextLineSpacing: Integer;
    procedure SetTextLineSpacing(AValue: Integer);
    function GetTextPopupCommands: TATPopupCommands;
    function GetTextEnableSel: Boolean;
    procedure SetTextEnableSel(AValue: Boolean);
    procedure SetTextPopupCommands(AValue: TATPopupCommands);
    function GetTextMaxLengths(AIndex: TATBinHexMode): Integer;
    procedure SetTextMaxLengths(AIndex: TATBinHexMode; AValue: Integer);
    function GetTextEncodingName: AnsiString;
    procedure FocusWebBrowser;
    function GetSelStart: Int64;
    procedure SetSelStart(const AValue: Int64);
    function GetSelLength: Int64;
    procedure SetSelLength(const AValue: Int64);
    function GetSelText: AnsiString;
    function GetSelTextShort: AnsiString;
    function GetSelTextW: WideString;
    function GetSelTextShortW: WideString;
    function GetImageDrag: Boolean;
    procedure SetImageDrag(AValue: Boolean);
    function GetImageCursor: TCursor;
    procedure SetImageCursor(AValue: TCursor);
    function GetImageDragCursor: TCursor;
    procedure SetImageDragCursor(AValue: TCursor);
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    function GetImageBPP: Integer;
    function GetImageScale: Integer;
    procedure SetImageScale(AValue: Integer);
    function GetMediaFit: Boolean;
    function GetMediaFitOnlyBig: Boolean;
    function GetMediaFitWidth: Boolean;
    function GetMediaFitHeight: Boolean;
    function GetMediaCenter: Boolean;
    function GetTextMaxClipboardDataSizeMb: Integer;
    procedure SetTextMaxClipboardDataSizeMb(AValue: Integer);
    procedure SetOnOptionsChange(AEvent: TNotifyEvent);

    function ActualExtText: AnsiString;
    function ActualExtImages: AnsiString;
    function ActualExtRTF: AnsiString;
    function ActualExtInet: AnsiString;

    procedure SetPosLine(ALine: Integer);
    function GetPosLine: Integer;

    {$ifdef PRINT}
    function GetMarginLeft: Double;
    function GetMarginTop: Double;
    function GetMarginRight: Double;
    function GetMarginBottom: Double;
    function GetPrintFooter: Boolean;
    procedure SetMarginLeft(const AValue: Double);
    procedure SetMarginTop(const AValue: Double);
    procedure SetMarginRight(const AValue: Double);
    procedure SetMarginBottom(const AValue: Double);
    procedure SetPrintFooter(const AValue: Boolean);
    function MarginsRectPx: TRect;
    {$endif}

    procedure SetParentWnd(H: integer);

  {$ifdef AX}
  published
  {$else}
  public
  {$endif}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(const AFileName: WideString {$ifdef OPP}; APicture: TPicture = nil {$endif}): Boolean;
    function OpenStream(AStream: TStream; AMode: TATViewerMode): Boolean;
    procedure Reload;
    procedure CopyToClipboard(AsHex: Boolean = False);
    procedure SelectAll;
    procedure SelectNone;
    procedure WebWait;

    {$ifdef SEARCH}
    function FindFirst(const AText: WideString; AOptions: TATStreamSearchOptions): Boolean;
    function FindFirst_(const AText: WideString; AOptions: integer): Boolean;
    function FindNext(AFindPrevious: Boolean = False): Boolean;
    function FindDialog(AFindNext: Boolean): Boolean;
    {$endif}

    {$ifdef PRINT}
    procedure PrintDialog;
    procedure PrintPreview;
    procedure PrintSetup;
    {$endif}
    {$ifdef PREVIEW}
    function PrintOptions(ACopies: Integer; AFailOnErrors: Boolean): TATPrintOptions;
    {$endif}

    procedure FocusActiveControl;
    procedure TextScroll(const APos: Int64; AIndentVert, AIndentHorz: Integer);
    procedure TextPopupMenu(AX, AY: Integer);
    procedure TextEncodingsMenu(AX, AY: Integer);
    function ImageEffect(AEffect: TATViewerImageEffect): Boolean;
    procedure WebGoBack;
    procedure WebGoForward;
    property NoCtx: boolean read FNoCtx write SetNoCtx;

    //for ActiveX:
    property LicenseKey: WideString read FLic write FLic;
    property ParentWnd: integer write SetParentWnd;
    procedure SetTextPopupCaption(AIndex: TATPopupCommand; const AValue: WideString);
    procedure SetMessageText(Id: Integer; const S: WideString);

    {$ifdef WLX}
    function OpenFolder(const AFolderName: WideString): Boolean;
    procedure InitPluginsParams(AParent: TWinControl; const AIniFilename: AnsiString);
    procedure ResizeActivePlugin(const Rect: TRect);
    procedure RemovePlugins;
    function AddPlugin(const AFileName: TWlxFilename; const ADetectStr: TWlxDetectString): Boolean;
    function GetPlugin(AIndex: Word; var AFileName: TWlxFilename; var ADetectStr: TWlxDetectString): Boolean;
    property ActivePluginSupportsSearch: Boolean read GetActivePluginSupportsSearch;
    property ActivePluginSupportsPrint: Boolean read GetActivePluginSupportsPrint;
    property ActivePluginSupportsCommands: Boolean read GetActivePluginSupportsCommands;
    property ActivePluginWindowHandle: THandle read GetActivePluginWindowHandle;
    property PluginsHighPriority: Boolean read FPluginsHighPriority write FPluginsHighPriority;
    procedure PluginsSendMessage(const AMessage: TMessage);
    {$endif}

    property ActivePluginName: AnsiString read GetActivePluginName;
    procedure IncreaseScale(AIncrement: Boolean);
    property FileName: WideString read FFileName;
    property FileSize: Int64 read FFileSize;
    property FileTime: TFileTime read FFileTime;
    property IsImage: Boolean read FIsImage;
    property IsIcon: Boolean read FIsIcon;
    property IsMetafile: Boolean read FIsMetafile;
    property IsGif: Boolean read FIsGif;
    property BinHex: TATBinHex read FBinHex;
    property ImageBox: TATImageBox read FImageBox;
    property ImageWidth: Integer read GetImageWidth;
    property ImageHeight: Integer read GetImageHeight;
    property ImageBPP: Integer read FImageBPP; //saved on image reading

    property ImageScale: Integer read GetImageScale write SetImageScale;
    property ImageError: Boolean read FImageError;
    property ImageErrorMessage: AnsiString read FImageErrorMessage;

    procedure ImageScaleInc;
    procedure ImageScaleDec;
    property WebBusy: Boolean read GetWebBusy;

    property PosPercent: Integer read GetPosPercent write SetPosPercent;
    property PosOffset: Int64 read GetPosOffset write SetPosOffset;
    property PosLine: Integer read GetPosLine write SetPosLine;

    {$ifdef SEARCH}
    property SearchStarted: Boolean read GetSearchStarted;
    property SearchFinished: Boolean read FFindFinished;
    {$endif}

    {$ifdef PRINT}
    property MarginLeft: Double read GetMarginLeft write SetMarginLeft;
    property MarginTop: Double read GetMarginTop write SetMarginTop;
    property MarginRight: Double read GetMarginRight write SetMarginRight;
    property MarginBottom: Double read GetMarginBottom write SetMarginBottom;
    property PrintFooter: Boolean read GetPrintFooter write SetPrintFooter;
    {$endif}

    property TextMaxClipboardDataSizeMb: Integer read GetTextMaxClipboardDataSizeMb write SetTextMaxClipboardDataSizeMb;
    property TextSelStart: Int64 read GetSelStart write SetSelStart;
    property TextSelLength: Int64 read GetSelLength write SetSelLength;
    property TextSelText: AnsiString read GetSelText;
    property TextSelTextShort: AnsiString read GetSelTextShort;
    property TextSelTextW: WideString read GetSelTextW;
    property TextSelTextShortW: WideString read GetSelTextShortW;
    property TextEncodingName: AnsiString read GetTextEncodingName;

  protected
    procedure Click; override;

  public
    //these array props moved here, in separate "public" section, so
    //prev. section can be made "published" for ActiveX
    property TextPopupCaption[AIndex: TATPopupCommand]: WideString write SetTextPopupCaption;
    property TextMaxLengths[AIndex: TATBinHexMode]: Integer read GetTextMaxLengths write SetTextMaxLengths;
    
  published
    property Mode: TATViewerMode read FMode write SetMode default vmodeNone;
    property ModeUndetected: TATViewerMode read FModeUndetected write FModeUndetected default vmodeBinary;
    property ModeUndetectedCfm: Boolean read FModeUndetectedCfm write FModeUndetectedCfm default True;
    property ModeDetect: Boolean read FModeDetect write FModeDetect default True;
    property ModesDisabledForDetect: TATViewerModes read FModesDisabledForDetect write FModesDisabledForDetect default [];

    //for ActiveX:
    property MessagesEnabled: boolean read GetMessagesEnabled write SetMessagesEnabled;
    property ExtImages: Widestring read GetExtImages write SetExtImages;
    property ExtInet: Widestring read GetExtInet write SetExtInet;

    property TextDetect: Boolean read FTextDetect write FTextDetect default True;
    property TextDetectOEM: Boolean read FTextDetectOEM write FTextDetectOEM default True;
    property TextDetectUTF8: Boolean read FTextDetectUTF8 write FTextDetectUTF8 default True;
    property TextDetectSize: DWORD read FTextDetectSize write FTextDetectSize default 4;
    property TextDetectLimit: DWORD read FTextDetectLimit write FTextDetectLimit default 0;
    property TextEncoding: TATEncoding read GetTextEncoding write SetTextEncoding default vencANSI;
    property TextWrap: Boolean read FTextWrap write SetTextWrap default False;
    property TextWidth: Integer read GetTextWidth write SetTextWidth default 80;
    property TextWidthHex: Integer read GetTextWidthHex write SetTextWidthHex default 16;
    property TextWidthFit: Boolean read GetTextWidthFit write SetTextWidthFit default False;
    property TextWidthFitHex: Boolean read GetTextWidthFitHex write SetTextWidthFitHex default False;
    property TextWidthFitUHex: Boolean read GetTextWidthFitUHex write SetTextWidthFitUHex default False;
    property TextOemSpecial: Boolean read GetTextOemSpecial write SetTextOemSpecial default False;
    property TextUrlHilight: Boolean read GetTextUrlHilight write SetTextUrlHilight default True;

    property TextGutter: Boolean read GetTextGutter write SetTextGutter default False;
    property TextGutterLines: Boolean read GetTextGutterLines write SetTextGutterLines default True;
    property TextGutterLinesStep: Integer read GetTextGutterLinesStep write SetTextGutterLinesStep default 5;
    property TextGutterLinesBufSize: Integer read GetTextGutterLinesBufSize write SetTextGutterLinesBufSize stored False;
    property TextGutterLinesCount: Integer read GetTextGutterLinesCount write SetTextGutterLinesCount stored False;
    property TextGutterLinesExtUse: Boolean read GetTextGutterLinesExtUse write SetTextGutterLinesExtUse default False;
    property TextGutterLinesExtList: AnsiString read GetTextGutterLinesExtList write SetTextGutterLinesExtList;

    property TextNonPrintable: Boolean read GetTextNonPrintable write SetTextNonPrintable default False;
    property TextSearchIndentVert: Integer read FSearchIndentVert write SetSearchIndentVert default 5;
    property TextSearchIndentHorz: Integer read FSearchIndentHorz write SetSearchIndentHorz default 5;
    property TextTabSize: Integer read GetTextTabSize write SetTextTabSize default 8;
    property TextLineSpacing: Integer read GetTextLineSpacing write SetTextLineSpacing default 0;
    property TextColor: TColor read FTextColor write SetTextColor default clWindow;
    property TextColorBin: TColor write SetTextColorBin default clInfobk;
    property TextColorHex: TColor read GetTextColorHex write SetTextColorHex default clNavy;
    property TextColorHex2: TColor read GetTextColorHex2 write SetTextColorHex2 default clBlue;
    property TextColorHexBack: TColor read GetTextColorHexBack write SetTextColorHexBack default cATBinHexBkColor;
    property TextColorLines: TColor read GetTextColorLines write SetTextColorLines default clGray;
    property TextColorError: TColor read GetTextColorError write SetTextColorError default clRed;
    property TextColorGutter: TColor read GetTextColorGutter write SetTextColorGutter default clLtGray;
    property TextColorURL: TColor read GetTextColorURL write SetTextColorURL default clBlue;
    property TextColorHi: TColor read GetTextColorHi write SetTextColorHi default clYellow;
    property TextFont: TFont read GetTextFont write SetTextFont;
    property TextFontOEM: TFont read GetTextFontOEM write SetTextFontOEM;
    property TextFontFooter: TFont read GetTextFontFooter write SetTextFontFooter;
    property TextFontGutter: TFont read GetTextFontGutter write SetTextFontGutter;
    property TextAutoCopy: Boolean read FTextAutoCopy write FTextAutoCopy default False;
    property TextPopupCommands: TATPopupCommands read GetTextPopupCommands write SetTextPopupCommands default cATBinHexCommandSet;
    property TextEnableSel: Boolean read GetTextEnableSel write SetTextEnableSel default True;

    property MediaFit: Boolean read GetMediaFit write SetMediaFit default True;
    property MediaFitOnlyBig: Boolean read GetMediaFitOnlyBig write SetMediaFitOnlyBig default True;
    property MediaFitWidth: Boolean read GetMediaFitWidth write SetMediaFitWidth default False;
    property MediaFitHeight: Boolean read GetMediaFitHeight write SetMediaFitHeight default False;
    property MediaCenter: Boolean read GetMediaCenter write SetMediaCenter default True;

    property ImageColor: TColor read FImageColor write FImageColor default clDkGray;
    property ImageDrag: Boolean read GetImageDrag write SetImageDrag default True;
    property ImageCursor: TCursor read GetImageCursor write SetImageCursor default crDefault;
    property ImageDragCursor: TCursor read GetImageDragCursor write SetImageDragCursor default crSizeAll;
    property ImageAnimate: Boolean read FImageAnimate write FImageAnimate default True;
    property ImageTransparent: Boolean read FImageTransparent write FImageTransparent default False;
    property ImageResample: Boolean read FImageResample write FImageResample default False;
    property ImageKeepPosition: Boolean read FImageKeepPosition write FImageKeepPosition default True;
    property ImageErrorMessageBox: Boolean read FImageErrorMessageBox write FImageErrorMessageBox default True;

    {$ifdef NOTIF}
    property TextAutoReload: Boolean read GetTextAutoReload write SetTextAutoReload default False;
    property TextAutoReloadBeep: Boolean read GetTextAutoReloadBeep write SetTextAutoReloadBeep default False;
    property TextAutoReloadFollowTail: Boolean read GetTextAutoReloadFollowTail write SetTextAutoReloadFollowTail default True;
    property OnTextFileReload: TNotifyEvent read GetOnTextFileReload write SetOnTextFileReload;
    {$endif}

    {$ifdef IJL}
    property IJLIntegration: TATIJLIntegration read FIJLIntegration write FIJLIntegration;
    {$endif}

    {$ifdef OFFLINE}
    property WebOffline: Boolean read FWebOffline write SetWebOffline default False;
    {$endif}

    property WebAcceptAllFiles: Boolean read FWebAcceptAllFiles write FWebAcceptAllFiles default False;
    property WebWaitForNavigate: Boolean read FWebWaitForNavigate write FWebWaitForNavigate default False;
    property IsFocused: Boolean read FFocused write FFocused default False;
    property BorderStyleInner: TBorderStyle read FBorderStyleInner write SetBorderStyleInner default bsSingle;

    property OnImageMouseDown: TATViewerImageMouseEvent read FOnImageMouseDown write FOnImageMouseDown;
    property OnImageMouseUp: TATViewerImageMouseEvent read FOnImageMouseUp write FOnImageMouseUp;
    property OnImageMouseMove: TATViewerImageMouseEvent read FOnImageMouseMove write FOnImageMouseMove;
    property OnImageLClick: TNotifyEvent read FOnImageLClick write FOnImageLClick;
    property OnImageRClick: TNotifyEvent read FOnImageRClick write FOnImageRClick;
    property OnWebDocumentComplete: TNotifyEvent read FOnWebDocumentComplete write FOnWebDocumentComplete;
    property OnWebNavigateComplete: TNotifyEvent read FOnWebNavigateComplete write FOnWebNavigateComplete;
    property OnWebStatusTextChange: TWebBrowserStatusTextChange read FOnWebStatusTextChange write FOnWebStatusTextChange;
    property OnWebTitleChange: TWebBrowserTitleChange read FOnWebTitleChange write FOnWebTitleChange;

    property OnModeDetected: TNotifyEvent read FOnModeDetected write FOnModeDetected;
    property OnFileLoad: TNotifyEvent read FOnFileLoad write FOnFileLoad;
    property OnFileUnload: TNotifyEvent read FOnFileUnload write FOnFileUnload;
    property OnOptionsChange: TNotifyEvent read FOnOptionsChange write SetOnOptionsChange;
    property OnLoadImageStream: TATViewerLoadImageStream read FOnLoadImageStream write FOnLoadImageStream;
    property OnLoadWebStream: TATViewerLoadWebStream read FOnLoadWebStream write FOnLoadWebStream;

    {$ifdef SEARCH}
    property OnTextSearchProgress: TATStreamSearchProgress read GetOnTextSearchProgress write SetOnTextSearchProgress;
    {$endif}

    {$ifdef WLX}
    property OnPluginsBeforeLoading: TWlxNameEvent read GetPluginsBeforeLoading write SetPluginsBeforeLoading;
    property OnPluginsAfterLoading: TWlxNameEvent read GetPluginsAfterLoading write SetPluginsAfterLoading;
    {$endif}
  end;


type
  TATViewerGlobalOptions = record
    ExtText,
    ExtRTF,
    ExtImages,
    ExtInet: AnsiString;
    ExtImagesUse,
    ExtInetUse: Boolean;
  end;

var
  ATViewerOptions: TATViewerGlobalOptions;

procedure ATViewerOptionsReset;
procedure Register;

implementation

uses
  Clipbrd,
  {$ifdef TNT} TntClasses, {$endif}
  {$ifdef WLX} WLXPlugin, {$endif}
  {$ifdef GEX} GraphicEx, {$endif}
  {$ifdef GIF} GIFImage, {$endif}
  {$ifdef PNG} PNGImage, {$endif}
  {$ifdef IJL} IJL, JPEG_IO, {$endif}
  {$ifdef JP2} jp2img, {$endif}
  ATxSProc, ATxFProc, ATxWBProc, ATxREUrl,
  ATxImageProc, ATViewerMsg;

{ Helper functions }

{$I ATViewerExt.inc}
{$ifdef AX}
{$I AX\Lic.inc}
{$endif}

procedure DoCursorHours;
begin
  Screen.Cursor := crHourGlass;
end;

procedure DoCursorDefault;
begin
  Screen.Cursor := crDefault;
end;

{$ifdef SEARCH}
function ATSSOptionsToREOptions(AOptions: TATStreamSearchOptions): TSearchTypes;
begin
  Result := [];
  if asoWholeWords in AOptions then
    Include(Result, stWholeWord);
  if asoCaseSens in AOptions then
    Include(Result, stMatchCase);
end;
{$endif}

{ TATViewer }

function TATViewer.CanSetFocus: Boolean;
begin
  Result :=
    Application.Active and
    CanFocus and
    (FFocused or Focused) and
    ([csLoading, csDesigning] * ComponentState = []);
end;

constructor TATViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := 'Viewer';

  //Demo
  FNoCtx:= false;
  FLic := '';
  FPanelDemo := TATTextPanel.Create(Self);
  with FPanelDemo do
  begin
    Visible := False;
    Parent := Self;
    Align := alTop;
    Color := $8080FF;
    LabCaption := 'D';
    LabCaption := LabCaption + 'e';
    LabCaption := LabCaption + 'm';
    LabCaption := #13 + LabCaption + 'o'#13;
  end;

  //Init inherited properties
  Caption := '';
  BevelOuter := bvNone;
  Width := 200;
  Height := 150;

  //Init variables
  FFileName := '';
  FFileSize := 0;
  FillChar(FFileTime, SizeOf(TFileTime), 0);

  FStream := nil;
  FSourceType := vfSrcNone;
  FMode := vmodeNone;
  FModeDetect := True;
  FModeUndetected := vmodeBinary;
  FModeUndetectedCfm := True;
  FModesDisabledForDetect := [];
  FTextColor := clWindow;
  FTextEncoding := vencANSI;
  FTextWrap := False;
  FTextDetect := True;
  FTextDetectOEM := True;
  FTextDetectUTF8 := True;
  FTextDetectSize := 4;
  FTextDetectLimit := 0;

  FMediaFit := True;
  FMediaFitOnlyBig := True;
  FMediaFitWidth := False;
  FMediaFitHeight := False;
  FMediaCenter := True;

  {$ifdef OFFLINE}
  FWebOffline := False;
  {$endif}
  FWebAcceptAllFiles := False;
  FWebWaitForNavigate := False;

  FSearchIndentVert := 5;
  FSearchIndentHorz := 5;

  FFocused := False;
  FBorderStyleInner := bsSingle;

  FIsImage := False;
  FIsImageBefore := False;
  FIsImageIView := False;
  FIsImageIJL := False;
  FIsIcon := False;
  FIsMetafile := False;
  FIsGif := False;

  FImageBPP := 0;
  FImageColor := clDkGray;
  FImageAnimate := True;
  FImageTransparent := False;
  FImageResample:= False;
  FImageKeepPosition := True;
  FImageDrag := True;
  FImageCursor := crDefault;
  FImageDragCursor := crSizeAll;
  FImageError := False;
  FImageErrorMessage := '';
  FImageErrorMessageBox := True;
  FImagePage := 0;
  FImagePagesCount := 1;

  //Init event handlers
  OnEnter := Enter;

  //Init objects
  FErrTimer := TTimer.Create(Self);
  with FErrTimer do
  begin
    Interval := 4000;
    OnTimer := ErrTimerTimer;
  end;

  FBinHex := TATBinHex.Create(Self);
  with FBinHex do
  begin
    Name := 'VBinHex';
    Width := 1; //To "hide" control initially during text loading
    Height := 1;
    Parent := Self;
    Align := alClient;
    Color := FTextColor;
    OnSelectionChange := TextSelectionChange;
    OnClickURL := TextURLClick;
  end;

  FTextPanel := TATTextPanel.Create(Self);
  with FTextPanel do
  begin
    Parent := Self;
    Align := alTop;
    Color := clInfoBk;
    Visible := False;
    OnLabClick := TextPanelClick;
  end;

  FTextPanel0 := TATTextPanel.Create(Self);
  with FTextPanel0 do
  begin
    Parent := Self;
    Align := alTop;
    Color := $7070FF;
    Visible := False;
    OnLabClick := TextPanelClick;
  end;

  FTextPanelErr := TATTextPanel.Create(Self);
  with FTextPanelErr do
  begin
    Parent := Self;
    Align := alTop;
    Color := $7070FF;
    Visible := False;
  end;

  FImageBox := nil;

  FEdit := nil;
  FEditShowAll := False;
  FEditMenuItemCopy := nil;
  FEditMenuItemSelectAll := nil;
  FEditMenuItemSep := nil;
  FEditMenu := nil;

  FBrowser := nil;

  {$ifdef WLX}
  FPlugins := TWlxPlugins.Create;
  FPluginsHighPriority := True;
  {$endif}

  {$ifdef PRINT}
  FPrintDialog := nil;
  FPageSetupDialog := nil;
  {$endif}

  {$ifdef IJL}
  with FIJLIntegration do
  begin
    Enabled := True;
    ExtList := cIJLDefaultExtensions;
  end;
  {$endif}

  //Init events
  FOnWebDocumentComplete := nil;
  FOnWebNavigateComplete := nil;
  FOnWebStatusTextChange := nil;
  FOnWebTitleChange := nil;

  FOnFileUnload := nil;
  FOnModeDetected := nil;
  FOnFileLoad := nil;
  FOnOptionsChange := nil;
  FOnLoadImageStream := nil;
  FOnLoadWebStream := nil;

  //Hide all
  HideAll;
end;

destructor TATViewer.Destroy;
begin
  FreeData;

  {$ifdef WLX}
  FPlugins.Free;
  {$endif}

  inherited Destroy;
end;

{$ifdef PRINT}
procedure TATViewer.InitDialogs;
begin
  if not Assigned(FPrintDialog) then
  begin
    FPrintDialog := TPrintDialog.Create(Self);
  end;

  {$ifdef COMPILER_7_UP}
  if not Assigned(FPageSetupDialog) then
  begin
    FPageSetupDialog := TPageSetupDialog.Create(Self);
    FPageSetupDialog.Units := pmMillimeters;
  end;
  {$endif};
end;
{$endif}

procedure TATViewer.InitEdit;
begin
  if not Assigned(FEdit) then
  begin
    FEdit := TRichEditURL.Create(Self);
    with FEdit do
    begin
      Name := 'VRichEdit';
      Parent := Self;
      Align := alClient;
      ReadOnly := True;
      ScrollBars := ssBoth;
      HideSelection := False;
      OnSelectionChange := TextSelectionChange;
      TRichEditURL(FEdit).OnURLClick := TextURLClick;
    end;

    FEditMenuItemCopy := TMenuItem.Create(Self);
    with FEditMenuItemCopy do
    begin
      Caption := FBinHex.TextPopupCaption[vpCmdCopy];
      OnClick := EditMenuItemCopyClick;
    end;

    FEditMenuItemSelectAll := TMenuItem.Create(Self);
    with FEditMenuItemSelectAll do
    begin
      Caption := FBinHex.TextPopupCaption[vpCmdSelectAll];
      OnClick := EditMenuItemSelectAllClick;
    end;

    FEditMenuItemSep := TMenuItem.Create(Self);
    with FEditMenuItemSep do
    begin
      Caption := '-';
    end;

    FEditMenu := TPopupMenu.Create(Self);
    with FEditMenu do
    begin
      Items.Add(FEditMenuItemCopy);
      Items.Add(FEditMenuItemSep);
      Items.Add(FEditMenuItemSelectAll);
    end;

    if not FNoCtx then
      FEdit.PopupMenu := FEditMenu;
  end;
end;

procedure TATViewer.InitImage;
begin
  if not Assigned(FImageBox) then
  begin
    FImageBox := TATImageBox.Create(Self);
    with FImageBox do
    begin
      Name := 'VImageBox';
      Parent := Self;

      Width := 1; //To "hide" control initially
      Height := 1;
      Align := alClient;
      OnOptionsChange := Self.FOnOptionsChange;
      OnScroll := ImageBoxScroll;
      OnScrollAlt := ImageBoxScrollAlt;
      OnClick := FOnImageLClick;
      Image.OnClick := FOnImageLClick;
      Image.OnMouseDown := ImageMouseDown;
      Image.OnMouseUp := ImageMouseUp;
      Image.OnMouseMove:= ImageMouseMove;
      OnContextPopup := ImageBoxContextPopup;
    end;

    FImageUpDown := TUpDown.Create(Self);
    with FImageUpDown do
    begin
      Parent := FImageBox;
      Visible := False;
      Orientation := udHorizontal;
      Height := 22;
      Width := Height * 2;
      Position := 0;
      Min := Low(ShortInt);
      Max := High(ShortInt);
      ShowHint := True;
      OnClick := ImageUpDownClick;
    end;
  end;
end;

procedure TATViewer.InitWeb;
begin
  if not Assigned(FBrowser) then
  begin
    FBrowser := TWebBrowser.Create(Self);
    with FBrowser do
    begin
      TControl(FBrowser).Parent := Self;
      Align := alClient;
      Silent := True;
      //Workaround for WebBrowser bug: it first opens BMP files
      //in a new window:
      Navigate('about:blank');
      OnDocumentComplete := WebBrowserDocumentComplete;
      OnNavigateComplete2 := WebBrowserNavigateComplete2;
      OnStatusTextChange := WebBrowserStatusTextChange;
      OnTitleChange := WebBrowserTitleChange;
      {$ifdef IE4X}
      OnFileDownload := WebBrowserFileDownload;
      {$endif}
    end;
    HideWeb;
  end;
end;


procedure TATViewer.HideAll;
var
  IsEmpty, IsImage: Boolean;
begin
  IsEmpty := (FFileName = '');
  IsImage := (FFileName <> '') and SFileExtensionMatch(FFileName, ActualExtImages);

  //Hide Edit/BinHex/Browser controls when different mode is set
  if IsEmpty or not (FMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode]) then
    FBinHex.Hide;

  if IsEmpty or (FMode <> vmodeRTF) then
    HideEdit;

  if IsEmpty or (FMode <> vmodeWeb) then
    HideWeb;

  //Hide image control when non-image is to be loaded
  if IsEmpty or (FMode <> vmodeMedia) or (not IsImage) then
    HideImage;

  //Hide plugins when different mode is set
  {$ifdef WLX}
  if IsEmpty or (FMode <> vmodeWLX) then
    HideWLX;
  {$endif}

  FTextPanel.Hide;
  FTextPanel0.Hide;
end;

procedure TATViewer.HideEdit;
begin
  if Assigned(FEdit) then
    FEdit.Hide;
end;

procedure TATViewer.HideImage;
begin
  if Assigned(FImageBox) then
    FImageBox.Hide;
end;

procedure TATViewer.HideWeb;
begin
  if Assigned(FBrowser) then
    FBrowser.Hide;
end;


function TATViewer.OpenStream(AStream: TStream; AMode: TATViewerMode): Boolean;
begin
  Result := True;
  FSourceType := vfSrcNone;

  FStream := AStream;
  FMode := AMode;

  FreeData;
  HideAll;
  if AStream = nil then Exit;

  FSourceType := vfSrcStream;
  FFileName := '';
  FFileSize := FStream.Size;
  FillChar(FFileTime, SizeOf(FFileTime), 0);

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      LoadBinaryStream;
    vmodeRTF:
      LoadRTFStream;
    vmodeMedia:
      LoadImageStream;
    vmodeWeb:
      LoadWebStream;
  end;
end;

function TATViewer.Open(const AFileName: WideString {$ifdef OPP}; APicture: TPicture = nil{$endif}): Boolean;
var
  NewFileName: WideString;
begin
  Result := True;
  FSourceType := vfSrcNone;

  //Need to expand given filename, since filename can be passed from application
  //without path at all, and this causes problems with WebBrowser and plugins.
  NewFileName := FGetFullPathName(AFileName);

  if (FFileName <> NewFileName) then
  begin
    DoFileUnload;

    FFileName := NewFileName;
    FGetFileInfo(FFileName, FFileSize, FFileTime);
    FreeData;

    if FFileName = '' then
    begin
      HideAll;
      while WebBusy and not Application.Terminated do //Wait for PDF
      begin
        Application.ProcessMessages;
        Sleep(0);
      end;
      Result := True;
      Exit
    end;

    if not IsFileExist(FFileName) then
    begin
      FFileName := '';
      HideAll;
      MsgError(SFormatW(MsgViewerErrCannotFindFile, [NewFileName]));
      Result := False;
      Exit
    end;

    if not IsFileAccessed(FFileName) then
    begin
      FFileName := '';
      HideAll;
      MsgError(SFormatW(MsgViewerErrCannotOpenFile, [NewFileName]));
      Result := False;
      Exit
    end;

    FSourceType := vfSrcFile;
    if FModeDetect then
    begin
      DetectMode; //LoadWLX called implicitly
      DoModeDetected;
    end;
    HideAll;

    case FMode of
      vmodeNone:
        begin
          FTextPanel.LabCaption := MsgViewerShowCfm;
          FTextPanel0.LabCaption := MsgViewerShowEmpty;
          FTextPanel.Visible := FFileSize > 0;
          FTextPanel0.Visible := not FTextPanel.Visible;
        end;
      vmodeText,
      vmodeBinary,
      vmodeHex,
      vmodeUnicode:
        LoadBinary;
      vmodeRTF:
        LoadRTF;
      vmodeMedia:
        LoadMedia({$ifdef OPP}APicture{$else}nil{$endif});
      vmodeWeb:
        LoadWeb;
      {$ifdef WLX}
      vmodeWLX:
        begin
          //When FModeDetect = True, there is no need to call LoadWLX,
          //it's already called in DetectMode above.
          if not FModeDetect then
            LoadWLX;
        end;
      {$endif}
    end;

    DoFileLoad;
  end;
end;

function IsRoot(const Dir: Widestring): boolean;
begin
  Result := (Length(Dir) = 3) and (Copy(Dir, 2, 2) = ':\');
end;

{$ifdef WLX}
function TATViewer.OpenFolder(const AFolderName: WideString): Boolean;
var
  NewFolderName: WideString;
begin
  Result := True;

  //Need to expand given filename, since filename can be passed from application
  //without path at all, and this causes problems with WebBrowser and plugins.
  NewFolderName := FGetFullPathName(AFolderName);

  if (FFileName <> NewFolderName) then
  begin
    DoFileUnload;

    FFileName := NewFolderName;
    FFileSize := 0;
    FillChar(FFileTime, SizeOf(FFileTime), 0);

    FMode := vmodeWLX;
    FreeData;
    HideAll;

    if FFileName = '' then
    begin
      Exit
    end;

    if not IsRoot(FFileName) and not IsDirExist(FFileName) then
    begin
      MsgError(SFormatW(MsgViewerErrCannotFindFolder, [NewFolderName]));
      FFileName := '';
      Result := False;
      Exit
    end;

    if not OpenByPlugins(True) then
    begin
      FFileName := '';
      Result := False;
      Exit;
    end;

    DoFileLoad;
  end;
end;
{$endif}

procedure TATViewer.Reload;
begin
  Assert(FFileName <> '', 'File not loaded: Reload');
  SetMode(FMode);
end;

procedure TATViewer.FreeSearch;
begin
  {$ifdef SEARCH}
  FFindText := '';
  FFindOptions := [];
  FFindFinished := False;
  {$endif}
end;

procedure TATViewer.FreeData(AFreeImage: Boolean = True;
                             AFreeOffice: Boolean = True);
begin
  FBinHex.Open('', False);
  FBinHex.OpenStream(nil, False);

  {FIsImageBefore := Assigned(FImageBox) and
    Assigned(FImageBox.Image.Picture.Graphic);
  if FIsImageBefore and AFreeImage then
    FImageBox.Unload;
  }
  if Assigned(FImageBox) then
    FImageBox.Unload;

  if not (csDestroying in ComponentState) then
  begin
    if Assigned(FEdit) and (FEdit.Lines.Count > 0) then
      FEdit.Lines.Clear;

    if Assigned(FBrowser) then
      FreeAndNil(FBrowser);
  end;

  FIsImage := False;
  FIsIcon := False;
  FIsMetafile := False;
  FIsGif := False;

  FreeSearch;
end;

procedure TATViewer.DetectMode;
begin
  //Reset encoding
  if FTextDetectOEM then
    FTextEncoding := vencANSI;

  {$ifdef WLX}
  if (not (vmodeWLX in FModesDisabledForDetect)) and
    FPluginsHighPriority and OpenByPlugins(True) then FMode := vmodeWLX else
  {$endif}

  if (not (vmodeRTF in FModesDisabledForDetect)) and
    SFileExtensionMatch(FFileName, ActualExtRTF) then FMode := vmodeRTF else

  if (not (vmodeText in FModesDisabledForDetect)) and
    SFileExtensionMatch(FFileName, ActualExtText) then FMode := vmodeText else

  if (not (vmodeMedia in FModesDisabledForDetect)) and
    SFileExtensionMatch(FFileName, ActualExtImages)
                                                 then FMode := vmodeMedia else

  if (not (vmodeWeb in FModesDisabledForDetect)) and
    SFileExtensionMatch(FFileName, ActualExtInet) then FMode := vmodeWeb else

  //Test for FModesDisabledForDetect is in DetectTextAndUnicode
  if FTextDetect and DetectTextAndUnicode then begin end else

  {$ifdef WLX}
  if (not (vmodeWLX in FModesDisabledForDetect)) and
    (not FPluginsHighPriority) and OpenByPlugins(True) then FMode := vmodeWLX else
  {$endif}

  //Set default
  if FModeUndetectedCfm then
    FMode := vmodeNone
  else
  begin
    FMode := FModeUndetected;
    //d
    ShowError(MsgViewerErrDetect);
  end;
end;


function TATViewer.ActualExtImages: AnsiString;
begin
  with ATViewerOptions do
  begin
    if ExtImagesUse then
      Result := ExtImages
    else
      Result := '';
  end;
end;

function TATViewer.ActualExtInet: AnsiString;
begin
  with ATViewerOptions do
  begin
    if ExtInetUse then
      Result := ExtInet
    else
      Result := '';
  end;
end;

function TATViewer.ActualExtText: AnsiString;
begin
  with ATViewerOptions do
  begin
    Result := ExtText;
  end;
end;

function TATViewer.ActualExtRTF: AnsiString;
begin
  with ATViewerOptions do
  begin
    Result := ExtRTF;
  end;
end;

procedure TATViewer.UnloadImage;
begin
  FImageBox.Unload;
end;

procedure TATViewer.ShowImageError(const Msg: AnsiString);
begin
  UnloadImage;
  FImageError := True;
  FImageErrorMessage := Msg;
  if FImageErrorMessageBox then
    ShowError(Msg);
end;


procedure TATViewer.LoadImageStream;
begin
  Assert(FStream <> nil, 'Stream not assigned');
  FreeData(False);

  FIsImage := True;
  FIsIcon := False;
  FIsMetafile := False;
  FIsGif := False;

  FImageError := False;
  FImageErrorMessage := '';
  FImageBPP := 0;
  FIsImageIView := False;
  FIsImageIJL := False;

  InitImage;
  if Assigned(FImageBox) then
  begin
    FImageBox.Color := FImageColor;
    FImageBox.ImageDrag := FImageDrag;
    FImageBox.Image.Cursor := FImageCursor;
    FImageBox.ImageDragCursor := FImageDragCursor;
    FImageBox.Image.Transparent := FImageTransparent;
    FImageBox.Image.Resample := FImageResample;
    FImageBox.Image.ResampleBackColor := FImageColor;

    try
      DoLoadImageStream;
    except
      on E: EInvalidGraphic do
        ShowImageError(E.Message)
      else
        ShowImageError(MsgViewerErrImage);
    end;

    FImageBox.ImageFitToWindow := FMediaFit;
    FImageBox.ImageFitOnlyBig := FMediaFitOnlyBig;
    FImageBox.ImageFitWidth := FMediaFitWidth;
    FImageBox.ImageFitHeight := FMediaFitHeight;
    FImageBox.ImageCenter := FMediaCenter;
    FImageBox.ImageKeepPosition := FImageKeepPosition;
    FImageBox.BorderStyle := FBorderStyleInner;
    FImageBox.Show;
    if CanSetFocus then
      FImageBox.SetFocus;
  end;
end;


procedure TATViewer.LoadImage(APicture: TPicture = nil; ANewImage: Boolean = True);
  //
  {$ifdef TIFF}
  function LoadTiff: Boolean;
  var
    h: THandle;
    Func: function(S: TStream; B: TBitmap; Page: Integer; var PagesCount: Integer): Boolean;
    Bmp: TBitmap;
    S: TStream;
  begin
    Result := False;
    h := LoadLibrary('VTiff.dll');
    if h = 0 then
      raise EInvalidGraphic.Create(Format(MsgViewerErrCannotLoadFile, ['VTiff.dll']));
    try
      Func := GetProcAddress(h, 'ReadTIFFIntoBitmap');
      if @Func = nil then Exit;

      S := {$IFDEF TNT}TTntFileStream{$ELSE}TFileStream{$ENDIF}.Create(
        FFileName, fmOpenRead or fmShareDenyNone);
      Bmp := TBitmap.Create;

      try
        if Func(S, Bmp, FImagePage, FImagePagesCount) then
        begin
          FImageBox.LoadBitmap(Bmp, False);
          Result := True;
        end;
      finally
        FreeAndNil(Bmp);
        FreeAndNil(S);
      end;
    finally
      FreeLibrary(h);
    end;
  end;
  {$endif}

  //
  function LoadCur: Boolean;
  const
    cSize = 32; //max cursor size
  var
    h: HCursor;
    B: TBitmap;
  begin
    {if Win32Platform = VER_PLATFORM_WIN32_NT then
      h := LoadCursorFromFileW(PWideChar(FFileName))
    else }
      h := LoadCursorFromFileA(PAnsiChar(FFileNameWideToAnsi(FFileName)));

    Result := h <> 0;
    if Result then
    begin
      B := TBitmap.Create;
      try
        B.PixelFormat := pf16bit;
        B.Width := cSize;
        B.Height := cSize;
        B.Canvas.Brush.Color := clBtnface;
        B.Canvas.FillRect(Rect(0, 0, b.Width, b.Height));
        DrawIcon(B.Canvas.Handle, 0, 0, h);

        FImageBox.LoadBitmap(b, False);
      finally
        B.Free;
        DestroyCursor(h);
      end;
    end;
  end;

  //
  procedure LoadImageWithDelphi;
  begin
    FImageBox.LoadFromFile(FFileName);
  end;

  //
  {$ifdef IJL}
  function LoadImageWithIJL: Boolean;
  var
    bmp: TBitmap;
  begin
    Result := False;
    FIsImageIJL := True;

    //Load IJL dinamycally here
    if (ijlLib = 0) then
      if not LoadIJL then Exit;

    bmp := TBitmap.Create;
    bmp.PixelFormat := pf24bit;
    try
      if LoadBmpFromJpegFile(bmp, FFileNameWideToAnsi(FFileName), False) then
      begin
        FImageBox.LoadBitmap(Bmp, False);
        Result := True;
      end;
    finally
      bmp.Free;
    end;
  end;
  {$endif}

  //
  procedure LoadImageFromPicture(APicture: TPicture);
  begin
    FImageBox.LoadPicture(APicture);
  end;

var
  OldImageScale: Integer;
begin
  FImageError := False;
  FImageErrorMessage := '';
  FImageBPP := 0;
  FIsImageIView := False;
  FIsImageIJL := False;
  if ANewImage then
  begin
    FImagePage := 0;
    FImagePagesCount := 1;
  end;
  OldImageScale := GetImageScale;

  //If an image was loaded before, then we need to switch between
  //"internal library" and "IrfanView" modes. We do this by setting the
  //IViewHighPriority local variable to False/True, otherwise it's set
  //according to IViewIntegration.HighPriority property.

  if Assigned(FImageBox) then
    try
      try
        DoCursorHours;

        //Load from TPicture object
        if Assigned(APicture) then
        begin
          LoadImageFromPicture(APicture);
          Exit;
        end;

        {$ifdef TIFF}
        //2b) Load TIFF
        if SFileExtensionMatch(FFileName, 'tif,tiff') then
        begin
          if not LoadTiff then
            raise Exception.Create('');
          Exit;
        end;
        {$endif}

        //2c) Load CUR
        if SFileExtensionMatch(FFileName, 'cur') then
        begin
          if not LoadCur then
            raise Exception.Create('');
          Exit;
        end;

        {$ifdef IJL}
        //3) Load with IJL
        if FIJLIntegration.Enabled then
          if SFileExtensionMatch(FFileName, FIJLIntegration.ExtList) then
          begin
            if LoadImageWithIJL then Exit;
          end;
        {$endif}

        //4) Load with Delphi
        if SFileExtensionMatch(FFileName, ATViewerOptions.ExtImages) then
        begin
          LoadImageWithDelphi;
          Exit;
        end;

        UnloadImage;

      finally
        DoCursorDefault;
        FImageBPP := GetImageBPP; //Updated only on image reading
        FImageUpDown.Visible := FImagePagesCount > 1;
        if not ANewImage then //Restore scale for prev page
          SetImageScale(OldImageScale);
      end;
    except
      on E: EInvalidGraphic do
        ShowImageError(E.Message)
      else
        ShowImageError(MsgViewerErrImage);
    end;
end;

procedure TATViewer.ShowError(S: AnsiString);
begin
  FTextPanelErr.Visible := True;
  FTextPanelErr.LabCaption :=
    WrapText(' '#13 + S + #13' ', ClientWidth div Canvas.TextWidth('0'));
  FErrTimer.Enabled := False;
  FErrTimer.Enabled := True;
end;

procedure TATViewer.LoadMedia(APicture: TPicture = nil);
begin
  Assert(FFileName <> '', 'FileName not assigned');

  //Load image
  if SFileExtensionMatch(FFileName, ActualExtImages) then
    try
      FreeData(False);
      FIsImage := True;
      InitImage;

      if Assigned(FImageBox) then
      begin
        FImageBox.Color := FImageColor;
        FImageBox.ImageDrag := FImageDrag;
        FImageBox.Image.Cursor := FImageCursor;
        FImageBox.ImageDragCursor := FImageDragCursor;
        FImageBox.Image.Transparent := FImageTransparent;
        FImageBox.Image.Resample := FImageResample;
        FImageBox.Image.ResampleBackColor := FImageColor;

        LoadImage(APicture);

        {$ifdef GIF}
        (*
        if Assigned(FImageBox.Image.Picture.Graphic) and
          (FImageBox.Image.Picture.Graphic is TGifImage) then
          with (FImageBox.Image.Picture.Graphic as TGifImage) do
          begin
            Animate := FImageAnimate;
            if FImageTransparent or
              ((Images.Count > 1) and IsTransparent) //Always set transparency for (animaged + transparent) images
            then
              DrawOptions := DrawOptions + [goTransparent]
            else
              DrawOptions := DrawOptions - [goTransparent];
          end;
          *)
        {$endif}

        FImageBox.ImageFitToWindow := FMediaFit;
        FImageBox.ImageFitOnlyBig := FMediaFitOnlyBig;
        FImageBox.ImageFitWidth := FMediaFitWidth;
        FImageBox.ImageFitHeight := FMediaFitHeight;
        FImageBox.ImageCenter := FMediaCenter;
        FImageBox.ImageKeepPosition := FImageKeepPosition;
        FImageBox.BorderStyle := FBorderStyleInner;
        FImageBox.Show;
        if CanSetFocus then
          FImageBox.SetFocus;

        FIsIcon := SFileExtensionMatch(FFileName, 'ico');
        FIsGif := SFileExtensionMatch(FFileName, 'gif');
        FIsMetafile := FImageBox.Image.Picture.Graphic is TMetafile;
      end;
    except
    end
end;


procedure TATViewer.LoadBinaryStream;
begin
  Assert(FStream <> nil, 'Stream not assigned');
  FreeData;
  FreeSearch;

  with FBinHex do
  begin
    Color := FTextColor;
    BorderStyle := FBorderStyleInner;
    TextEncoding := FTextEncoding;
    TextWrap := FTextWrap;

    case Self.FMode of
      vmodeText:
        Mode := vbmodeText;
      vmodeBinary:
        Mode := vbmodeBinary;
      vmodeHex:
        Mode := vbmodeHex;
      vmodeUnicode:
        Mode := vbmodeUnicode;
    end;

    OpenStream(FStream);

    Show;
    if CanSetFocus then
      SetFocus;
  end;
end;


procedure TATViewer.LoadBinary;
var
  ANewFile: Boolean;
begin
  Assert(FFileName <> '', 'FileName not assigned');

  //Is file new for ATBinHex component?
  ANewFile := FFileName <> FBinHex.FileName;

  //Clear data only when file is new,
  //and clear search anyway:
  if ANewFile then
    FreeData;
  FreeSearch;

  with FBinHex do
  begin
    Color := FTextColor;
    BorderStyle := FBorderStyleInner;
    TextEncoding := FTextEncoding;
    TextWrap := FTextWrap;

    case Self.FMode of
      vmodeText:
        Mode := vbmodeText;
      vmodeBinary:
        Mode := vbmodeBinary;
      vmodeHex:
        Mode := vbmodeHex;
      vmodeUnicode:
        //If Unicode mode already activated, switch to UHex mode:
        if (not ANewFile) and (Mode = vbmodeUnicode) then
          Mode := vbmodeUHex
        else
          Mode := vbmodeUnicode;
    end;

    if ANewFile then
      Open(FFileName);

    Show;
    if CanSetFocus then
      SetFocus;
  end;
end;


procedure TATViewer.LoadRTFStream;
begin
  Assert(FStream <> nil, 'Stream not assigned');
  FreeData;

  InitEdit;
  if Assigned(FEdit) then
    with FEdit do
    begin
      //work around RichEdit bug, reset font
      Font.Name := 'Webdings';
      Font.Size := 8;
      Font.Color := clWhite;
      Font := GetTextFont;

      //RichEdit bug: WordWrap assignment must be after Font assignment, or font will be broken
      Color := FTextColor;
      WordWrap := FTextWrap;
      BorderStyle := FBorderStyleInner;

      try
        try
          DoCursorHours;
          RE_LoadStream(FEdit, FStream, 0, 0);
          TextSelectionChange(Self);
        finally
          DoCursorDefault;
        end;
      except
        MsgError(MsgViewerErrCannotReadStream);
      end;

      Show;
      if CanSetFocus then
        SetFocus;
    end;
end;

procedure TATViewer.LoadRTF;
begin
  Assert(FFileName <> '', 'FileName not assigned');
  FreeData;

  InitEdit;
  if Assigned(FEdit) then
    with FEdit do
    begin
      //work around RichEdit bug, reset font
      Font.Name := 'Webdings';
      Font.Size := 8;
      Font.Color := clWhite;
      Font := GetTextFont;

      //RichEdit bug: WordWrap assignment must be after Font assignment, or font will be broken
      Color := FTextColor;
      WordWrap := FTextWrap;
      BorderStyle := FBorderStyleInner;

      try
        try
          DoCursorHours;
          RE_LoadFile(FEdit, FFileName, 0, 0);
          TextSelectionChange(Self);
        finally
          DoCursorDefault;
        end;
      except
        MsgError(SFormatW(MsgViewerErrCannotLoadFile, [FFileName]));
      end;

      Show;
      if CanSetFocus then
        SetFocus;
    end;
end;


procedure TATViewer.LoadWebStream;
begin
  Assert(FStream <> nil, 'Stream not assigned');
  FreeData;

  InitWeb;
  if Assigned(FBrowser) then
    try
      if WebBrowserSafe then
        if FBorderStyleInner = bsNone then
          WB_Set3DBorderStyle(FBrowser, FBorderStyleInner <> bsNone);
      FBrowser.Show;
      {$ifdef OFFLINE}
      WB_SetGlobalOffline(FWebOffline);
      {$endif}
      DoLoadWebStream;
    except
    end;
end;

procedure TATViewer.LoadWeb;
begin
  Assert(FFileName <> '', 'FileName not assigned');
  FreeData;

  InitWeb;
  if Assigned(FBrowser) then
    try
      if WebBrowserSafe then
        if FBorderStyleInner = bsNone then
          WB_Set3DBorderStyle(FBrowser, FBorderStyleInner <> bsNone);
      FBrowser.Show;
      {$ifdef OFFLINE}
      WB_SetGlobalOffline(FWebOffline);
      {$endif}
      WB_NavigateFilename(FBrowser, FFileName, FWebWaitForNavigate);
    except
    end;
end;


procedure TATViewer.SetMode(AValue: TATViewerMode);
begin
  Assert(FSourceType in [vfSrcNone, vfSrcFile],
    'Mode can be changed only for file');

  DoFileUnload;

  FMode := AValue;
  DoModeDetected;
  HideAll;

  if (FMode = vmodeNone) and FTextDetect then
  begin
    DetectTextAndUnicode;
    DoModeDetected;
  end;

  if FFileName <> '' then
  begin
    case FMode of
      vmodeNone:
        begin
          FTextPanel.Visible := FGetFileSize(FFileName) > 0;
          FTextPanel0.Visible := not FTextPanel.Visible;
        end;
      vmodeText,
      vmodeBinary,
      vmodeHex,
      vmodeUnicode:
        LoadBinary;
      vmodeRTF:
        LoadRTF;
      vmodeMedia:
        LoadMedia;
      vmodeWeb:
        LoadWeb;
      {$ifdef WLX}
      vmodeWLX:
        LoadWLX;
      {$endif}
    end;

    DoFileLoad;
  end;
end;

function TATViewer.GetTextEncoding: TATEncoding;
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FTextEncoding := FBinHex.TextEncoding;
  end;
  Result := FTextEncoding;
end;

procedure TATViewer.SetTextEncoding(AValue: TATEncoding);
begin
  if FTextEncoding <> AValue then
  begin
    FTextEncoding := AValue;

    case FMode of
      vmodeText,
      vmodeBinary,
      vmodeHex,
      vmodeUnicode:
        FBinHex.TextEncoding := FTextEncoding;

      {$ifdef WLX}
      vmodeWLX:
        SendWLXParams;
      {$endif}
    end;
  end;
end;

procedure TATViewer.SetTextWrap(AValue: Boolean);
begin
  if FTextWrap <> AValue then
  begin
    FTextWrap := AValue;

    FBinHex.TextWrap := FTextWrap;

    if Assigned(FEdit) then
      FEdit.WordWrap := FTextWrap;

    {$ifdef WLX}
    if FMode = vmodeWLX then
      SendWLXParams;
    {$endif}
  end;
end;

function TATViewer.GetTextWidth: Integer;
begin
  Result := FBinHex.TextWidth;
end;

function TATViewer.GetTextWidthHex: Integer;
begin
  Result := FBinHex.TextWidthHex;
end;

function TATViewer.GetTextWidthFit: Boolean;
begin
  Result := FBinHex.TextWidthFit;
end;

function TATViewer.GetTextWidthFitHex: Boolean;
begin
  Result := FBinHex.TextWidthFitHex;
end;

function TATViewer.GetTextWidthFitUHex: Boolean;
begin
  Result := FBinHex.TextWidthFitUHex;
end;

function TATViewer.GetTextOemSpecial: Boolean;
begin
  Result := FBinHex.TextOemSpecial;
end;

function TATViewer.GetTextUrlHilight: Boolean;
begin
  Result := FBinHex.TextUrlHilight;
end;

function TATViewer.GetTextGutter: Boolean;
begin
  Result := FBinHex.TextGutter;
end;

function TATViewer.GetTextGutterLines: Boolean;
begin
  Result := FBinHex.TextGutterLines;
end;

function TATViewer.GetTextGutterLinesStep: Integer;
begin
  Result := FBinHex.TextGutterLinesStep;
end;

function TATViewer.GetTextGutterLinesBufSize: Integer;
begin
  Result := FBinHex.TextGutterLinesBufSize;
end;

function TATViewer.GetTextGutterLinesCount: Integer;
begin
  Result := FBinHex.TextGutterLinesCount;
end;

function TATViewer.GetTextGutterLinesExtUse: Boolean;
begin
  Result := FBinHex.TextGutterLinesExtUse;
end;

function TATViewer.GetTextGutterLinesExtList: AnsiString;
begin
  Result := FBinHex.TextGutterLinesExtList;
end;

function TATViewer.GetTextNonPrintable: Boolean;
begin
  Result := FBinHex.TextNonPrintable;
end;

procedure TATViewer.SetTextWidth(AValue: Integer);
begin
  FBinHex.TextWidth := AValue;
end;

procedure TATViewer.SetTextWidthHex(AValue: Integer);
begin
  FBinHex.TextWidthHex := AValue;
end;

procedure TATViewer.SetTextWidthFit(AValue: Boolean);
begin
  FBinHex.TextWidthFit := AValue;
end;

procedure TATViewer.SetTextWidthFitHex(AValue: Boolean);
begin
  FBinHex.TextWidthFitHex := AValue;
end;

procedure TATViewer.SetTextWidthFitUHex(AValue: Boolean);
begin
  FBinHex.TextWidthFitUHex := AValue;
end;

procedure TATViewer.SetTextOemSpecial(AValue: Boolean);
begin
  FBinHex.TextOemSpecial := AValue;
end;

procedure TATViewer.SetTextUrlHilight(AValue: Boolean);
begin
  FBinHex.TextUrlHilight := AValue;
end;

procedure TATViewer.SetTextGutter(AValue: Boolean);
begin
  FBinHex.TextGutter := AValue;
end;

procedure TATViewer.SetTextGutterLines(AValue: Boolean);
begin
  FBinHex.TextGutterLines := AValue;
end;

procedure TATViewer.SetTextGutterLinesStep(AValue: Integer);
begin
  FBinHex.TextGutterLinesStep := AValue;
end;

procedure TATViewer.SetTextGutterLinesBufSize(AValue: Integer);
begin
  FBinHex.TextGutterLinesBufSize := AValue;
end;

procedure TATViewer.SetTextGutterLinesCount(AValue: Integer);
begin
  FBinHex.TextGutterLinesCount := AValue;
end;

procedure TATViewer.SetTextGutterLinesExtUse(AValue: Boolean);
begin
  FBinHex.TextGutterLinesExtUse := AValue;
end;

procedure TATViewer.SetTextGutterLinesExtList(const AValue: AnsiString);
begin
  FBinHex.TextGutterLinesExtList := AValue;
end;

procedure TATViewer.SetTextNonPrintable(AValue: Boolean);
begin
  FBinHex.TextNonPrintable:= AValue;
end;

procedure TATViewer.SetSearchIndentVert(AValue: Integer);
const
  cMaxIndent = 80;
begin
  if FSearchIndentVert <> AValue then
  begin
    FSearchIndentVert := AValue;
    ILimitMin(FSearchIndentVert, 0);
    ILimitMax(FSearchIndentVert, cMaxIndent);
    FBinHex.TextSearchIndentVert := FSearchIndentVert;
  end;
end;

procedure TATViewer.SetSearchIndentHorz(AValue: Integer);
const
  cMaxIndent = 80;
begin
  if FSearchIndentHorz <> AValue then
  begin
    FSearchIndentHorz := AValue;
    ILimitMin(FSearchIndentHorz, 0);
    ILimitMax(FSearchIndentHorz, cMaxIndent);
    FBinHex.TextSearchIndentHorz := FSearchIndentHorz;
  end;
end;

procedure TATViewer.SetMediaFit(AValue: Boolean);
begin
  if GetMediaFit <> AValue then
  begin
    FMediaFit := AValue;
    case FMode of
      vmodeMedia:
        begin
          if Assigned(FImageBox) then
            FImageBox.ImageFitToWindow := FMediaFit;
        end;

      {$ifdef WLX}
      vmodeWLX:
        SendWLXParams;
      {$endif}
    end;
  end;
end;

procedure TATViewer.SetMediaFitOnlyBig(AValue: Boolean);
begin
  if GetMediaFitOnlyBig <> AValue then
  begin
    FMediaFitOnlyBig := AValue;

    case FMode of
      vmodeMedia:
        if Assigned(FImageBox) then
          FImageBox.ImageFitOnlyBig := FMediaFitOnlyBig;

      {$ifdef WLX}
      vmodeWLX:
        SendWLXParams;
      {$endif}
    end;
  end;
end;

procedure TATViewer.SetMediaFitWidth(AValue: Boolean);
begin
  if GetMediaFitWidth <> AValue then
  begin
    FMediaFitWidth := AValue;
    if AValue then
      FMediaFitHeight := False;
    if FMode = vmodeMedia then
      if Assigned(FImageBox) then
      begin
        FImageBox.ImageFitWidth := FMediaFitWidth;
        FImageBox.ImageFitHeight := FMediaFitHeight;
      end;
  end;
end;

procedure TATViewer.SetMediaFitHeight(AValue: Boolean);
begin
  if GetMediaFitHeight <> AValue then
  begin
    FMediaFitHeight := AValue;
    if AValue then
      FMediaFitWidth := False;
    if FMode = vmodeMedia then
      if Assigned(FImageBox) then
      begin
        FImageBox.ImageFitWidth := FMediaFitWidth;
        FImageBox.ImageFitHeight := FMediaFitHeight;
      end;
  end;
end;

procedure TATViewer.SetMediaCenter(AValue: Boolean);
begin
  if GetMediaCenter <> AValue then
  begin
    FMediaCenter := AValue;

    case FMode of
      vmodeMedia:
        if Assigned(FImageBox) then
          FImageBox.ImageCenter := FMediaCenter;

      {$ifdef WLX}
      vmodeWLX:
        SendWLXParams;
      {$endif}
    end;
  end;
end;

{$ifdef OFFLINE}
procedure TATViewer.SetWebOffline(AValue: Boolean);
begin
  if FWebOffline <> AValue then
  begin
    FWebOffline := AValue;
    if Assigned(FBrowser) then
    begin
      WB_SetGlobalOffline(FWebOffline);
      if (FMode = vmodeWeb) and (FBrowser.Visible) then
        WB_NavigateFilename(FBrowser, FFileName, FWebWaitForNavigate);
    end;
  end;
end;
{$endif}

procedure TATViewer.SetTextColor(AValue: TColor);
begin
  if FTextColor <> AValue then
  begin
    FTextColor := AValue;
    FBinHex.Color := FTextColor;
    if Assigned(FEdit) then
      FEdit.Color := FTextColor;
  end;
end;

function TATViewer.GetTextFont: TFont;
begin
  Result := FBinHex.Font;
end;

procedure TATViewer.SetTextFont(AValue: TFont);
begin
  FBinHex.Font := AValue;

  if Assigned(FEdit) then
    FEdit.Font := AValue;
end;

function TATViewer.GetTextFontOEM: TFont;
begin
  Result := FBinHex.FontOEM;
end;

procedure TATViewer.SetTextFontOEM(AValue: TFont);
begin
  FBinHex.FontOEM := AValue;
end;

function TATViewer.GetTextFontFooter: TFont;
begin
  Result := FBinHex.FontFooter;
end;

function TATViewer.GetTextFontGutter: TFont;
begin
  Result := FBinHex.FontGutter;
end;

procedure TATViewer.SetTextFontFooter(AValue: TFont);
begin
  FBinHex.FontFooter := AValue;
end;

procedure TATViewer.SetTextFontGUtter(AValue: TFont);
begin
  FBinHex.FontGutter:= AValue;
end;

function TATViewer.GetTextColorHex: TColor;
begin
  Result := FBinHex.TextColorHex;
end;

function TATViewer.GetTextColorHex2: TColor;
begin
  Result := FBinHex.TextColorHex2;
end;

function TATViewer.GetTextColorHexBack: TColor;
begin
  Result := FBinHex.TextColorHexBack;
end;

function TATViewer.GetTextColorLines: TColor;
begin
  Result := FBinHex.TextColorLines;
end;

function TATViewer.GetTextColorError: TColor;
begin
  Result := FBinHex.TextColorError;
end;

function TATViewer.GetTextColorGutter: TColor;
begin
  Result := FBinHex.TextColorGutter;
end;

function TATViewer.GetTextColorURL: TColor;
begin
  Result := FBinHex.TextColorURL;
end;

function TATViewer.GetTextColorHi: TColor;
begin
  Result := FBinHex.TextColorHi;
end;

procedure TATViewer.SetTextColorHex(AValue: TColor);
begin
  FBinHex.TextColorHex := AValue;
end;

procedure TATViewer.SetTextColorHex2(AValue: TColor);
begin
  FBinHex.TextColorHex2 := AValue;
end;

procedure TATViewer.SetTextColorHexBack(AValue: TColor);
begin
  FBinHex.TextColorHexBack := AValue;
end;

procedure TATViewer.SetTextColorLines(AValue: TColor);
begin
  FBinHex.TextColorLines := AValue;
end;

procedure TATViewer.SetTextColorError(AValue: TColor);
begin
  FBinHex.TextColorError := AValue;
end;

procedure TATViewer.SetTextColorGutter(AValue: TColor);
begin
  FBinHex.TextColorGutter := AValue;
end;

procedure TATViewer.SetTextColorURL(AValue: TColor);
begin
  FBinHex.TextColorURL := AValue;
end;

procedure TATViewer.SetTextColorHi(AValue: TColor);
begin
  FBinHex.TextColorHi := AValue;
end;


{$ifdef SEARCH}
function TATViewer.GetSearchStarted: Boolean;
begin
  if FMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode] then
    Result := FBinHex.SearchStarted
  else
    Result := (FFindText <> '');
end;
{$endif}

procedure TATViewer.Enter(Sender: TObject);
begin
  FocusActiveControl;
end;

procedure TATViewer.FocusWebBrowser;
begin
  if Assigned(FBrowser) then
    if FBrowser.Visible and (FMode = vmodeWeb) then
      if CanSetFocus and WebBrowserSafe then
        WB_SetFocus(FBrowser);
end;

procedure TATViewer.FocusActiveControl;
begin
  if CanSetFocus then
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      if FBinHex.Visible and FBinHex.Enabled then
        FBinHex.SetFocus;

    vmodeRTF:
      if Assigned(FEdit) then
        if FEdit.Visible and FEdit.Enabled then
          FEdit.SetFocus;

    vmodeMedia:
      begin
        if FIsImage then
        begin
          if Assigned(FImageBox) and FImageBox.Visible and FImageBox.Enabled then
            FImageBox.SetFocus;
        end
      end;

    vmodeWeb:
      FocusWebBrowser;

    {$ifdef WLX}
    vmodeWLX:
      FPlugins.SetFocusToActive;
    {$endif}
  end;
end;

procedure TATViewer.Click;
begin
  SetFocus;
end;

procedure TATViewer.ErrTimerTimer(Sender: TObject);
begin
  FErrTimer.Enabled := False;
  FTextPanelErr.Visible := False;
end;

{$ifdef SEARCH}
function TATViewer.FindFirst_(const AText: WideString; AOptions: integer): Boolean;
var
  O: TATStreamSearchOptions;
begin
  O := [];
  if (AOptions and vfo_Back)<>0 then Include(o, asoBackward);
  if (AOptions and vfo_Case)<>0 then Include(o, asoCaseSens);
  if (AOptions and vfo_Words)<>0 then Include(o, asoWholeWords);
  {$ifdef REGEX}
  if (AOptions and vfo_RegEx)<>0 then Include(o, asoRegEx);
  {$endif}
  if (AOptions and vfo_FromPage)<>0 then Include(o, asoFromPage);
  if (AOptions and vfo_ShowAll)<>0 then Include(o, asoShowAll);
  Result := FindFirst(AText, O);
end;
{$endif}

{$ifdef SEARCH}
function TATViewer.FindFirst(const AText: WideString; AOptions: TATStreamSearchOptions): Boolean;
var
  AEditStartPos: Integer;
begin
  Result := False;

  FFindText := AText;
  FFindOptions := AOptions;

  if FFindText = '' then Exit;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      begin
        try
          if not Assigned(OnTextSearchProgress) then
            DoCursorHours;

          Result := FBinHex.FindFirst(FFindText, FFindOptions);
        finally
          if not Assigned(OnTextSearchProgress) then
            DoCursorDefault;
        end;

        if Result then
          with FBinHex do
            SetSelection(SearchResultStart, SearchResultLength, True);
      end;

    vmodeRTF:
      if Assigned(FEdit) then
        try
          DoCursorHours;

          AEditStartPos := 0;
          if (asoFromPage in AOptions) then
            AEditStartPos := RE_PosFromLine(FEdit, RE_CurrentLine(FEdit));

          Result := RE_FindFirst(
            FEdit,
            AText,
            AEditStartPos,
            ATSSOptionsToREOptions(AOptions),
            FSearchIndentVert,
            FSearchIndentHorz,
            FEditLastSearch);

          if FEditShowAll then
            RE_HiAll(FEdit, TextColor);
          FEditShowAll := asoShowAll in AOptions;
          if FEditShowAll then
            RE_Hi(FEdit, AText, ATSSOptionsToREOptions(AOptions), TextColorHi);
        finally
          DoCursorDefault;
        end;

    {$ifdef WLX}
    vmodeWLX:
      try
        DoCursorHours;
        Result := FPlugins.SearchActive(
          FFindText,
          True, //AFindFirst
          asoWholeWords in FFindOptions,
          asoCaseSens in FFindOptions,
          asoBackward in FFindOptions);
      finally
        DoCursorDefault;
      end;
    {$endif}
  end;

  FFindFinished := not Result;
end;
{$endif}

{$ifdef SEARCH}
function TATViewer.FindNext(AFindPrevious: Boolean = False): Boolean;
begin
  Result := False;

  if FFindText = '' then
    begin FFindFinished := True; Exit end;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      begin
        try
          if not Assigned(OnTextSearchProgress) then
            DoCursorHours;

          Result := FBinHex.FindNext(AFindPrevious);
        finally
          if not Assigned(OnTextSearchProgress) then
            DoCursorDefault;
        end;

        if Result then
          with FBinHex do
            SetSelection(SearchResultStart, SearchResultLength, True);
      end;

    vmodeRTF:
      if Assigned(FEdit) then
        try
          DoCursorHours;
          Result := RE_FindNext(
            FEdit,
            FSearchIndentVert,
            FSearchIndentHorz,
            FEditLastSearch);
        finally
          DoCursorDefault;
        end;

    {$ifdef WLX}
    vmodeWLX:
      try
        DoCursorHours;
        Result := FPlugins.SearchActive(
          FFindText,
          False, //AFindFirst
          asoWholeWords in FFindOptions,
          asoCaseSens in FFindOptions,
          asoBackward in FFindOptions);
      finally
        DoCursorDefault;
      end;
    {$endif}
  end;

  FFindFinished := not Result;
end;
{$endif}

{$ifdef SEARCH}
function TATViewer.FindDialog(AFindNext: Boolean): Boolean;
begin
  Result := False;

  case FMode of
    vmodeWeb:
      if Assigned(FBrowser) then
      begin
        WB_ShowFindDialog(FBrowser);
        Result := True;
      end;

    {$ifdef WLX}
    vmodeWLX:
      Result := FPlugins.SearchDialogActive(AFindNext);
    {$endif}
  end;
end;
{$endif}

procedure TATViewer.CopyToClipboard(AsHex: Boolean = False);
begin
  case FMode of
    vmodeRTF:
      if Assigned(FEdit) then
        try
          FEdit.CopyToClipboard;
        except
          MsgError(MsgViewerErrCannotCopyData);
        end;

    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.CopyToClipboard(AsHex);

    vmodeMedia:
      if Assigned(FImageBox) then
        try
          if FIsImage and (not FIsIcon) then
            Clipboard.Assign(FImageBox.CurrentPicture);
        except
          MsgError(MsgViewerErrCannotCopyData);
        end;

    vmodeWeb:
      if Assigned(FBrowser) then
        WB_Copy(FBrowser);

    {$ifdef WLX}
    vmodeWLX:
      SendWLXCommand(lc_copy, 0);
    {$endif}
  end;
end;

procedure TATViewer.SelectAll;
begin
  case FMode of
    vmodeRTF:
      if Assigned(FEdit) then
        FEdit.SelectAll;

    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.SelectAll;

    vmodeWeb:
      if Assigned(FBrowser) then
        WB_SelectAll(FBrowser);

    {$ifdef WLX}
    vmodeWLX:
      SendWLXCommand(lc_selectall, 0);
    {$endif}
  end;
end;

procedure TATViewer.SelectNone;
begin
  case FMode of
    vmodeRTF:
      if Assigned(FEdit) then
        FEdit.SelLength := 0;

    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.SelectNone;

    vmodeWeb:
      if Assigned(FBrowser) then
        WB_SelectNone(FBrowser);
  end;
end;


procedure TATViewer.DoWebDocumentComplete;
begin
  if Assigned(FOnWebDocumentComplete) then
    FOnWebDocumentComplete(Self);
end;

procedure TATViewer.DoWebNavigateComplete;
begin
  if Assigned(FOnWebNavigateComplete) then
    FOnWebNavigateComplete(Self);
end;

procedure TATViewer.DoWebStatusTextChange;
begin
  if Assigned(FOnWebStatusTextChange) then
    FOnWebStatusTextChange(Self, Text);
end;

procedure TATViewer.DoWebTitleChange;
begin
  if Assigned(FOnWebTitleChange) then
    FOnWebTitleChange(Self, Text);
end;

procedure TATViewer.DoModeDetected;
begin
  if FFileName <> '' then
    if Assigned(FOnModeDetected) then
      FOnModeDetected(Self);
end;

procedure TATViewer.DoFileLoad;
const
  c: array[boolean] of TAlign = (alTop, alBottom);
begin
  if FFileName <> '' then
    if Assigned(FOnFileLoad) then
      FOnFileLoad(Self);

  {$ifdef AX}
  if IsAX then
  begin
    Resize;
    FPanelDemo.Visible := not IsLic(FLic, FPanelDemo.LabCaption);
    FPanelDemo.Align := c[Random(2) = 1];
  end;
  {$endif}
end;

procedure TATViewer.DoFileUnload;
begin
  if FFileName <> '' then
    if Assigned(FOnFileUnload) then
      FOnFileUnload(Self);
end;

procedure TATViewer.DoOptionsChange;
begin
  if Assigned(FOnOptionsChange) then
    FOnOptionsChange(Self);
end;

procedure TATViewer.DoLoadImageStream;
begin
  if Assigned(FOnLoadImageStream) then
    FOnLoadImageStream(Self, FImageBox, FStream);
end;

procedure TATViewer.DoLoadWebStream;
begin
  if Assigned(FOnLoadWebStream) then
    FOnLoadWebStream(Self, FBrowser, FStream);
end;

{$ifdef PRINT}
function TATViewer.PrinterCaption: AnsiString;
begin
  Result := MsgViewerCaption + ' - ' + SExtractFileName(FFileName);
end;
{$endif}

{$ifdef PRINT}
procedure TATViewer.PrintEdit(ASelectionOnly: Boolean; ACopies: Integer);
var
  OldSelStart,
  OldSelLength: Integer;
begin
  if Assigned(FEdit) then
    with FEdit do
      try
        Lines.BeginUpdate;

        OldSelStart := SelStart;
        OldSelLength := SelLength;

        FEdit.PageRect := MarginsRectPx;
        RE_Print(
          FEdit,
          ASelectionOnly,
          ACopies,
          PrinterCaption);

        //Reload file after printing
        //and restore selection
        try
          try
            DoCursorHours;
            RE_LoadFile(FEdit, FFileName, OldSelStart, OldSelLength);
          finally
            DoCursorDefault;
          end;
        except
          MsgError(SFormatW(MsgViewerErrCannotLoadFile, [FFileName]));
        end;

      finally
        Lines.EndUpdate;
      end;
end;
{$endif}

procedure TATViewer.WebBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if Assigned(FBrowser) then
    if FBrowser.Visible and (FMode = vmodeWeb) then begin
      if (not TextEnableSel) and
        (not SFileExtensionMatch(FFileName, 'pdf')) then
      begin
        FBrowser.OleObject.document.parentWindow.execScript(
          'document.oncontextmenu='+
          'function(){event.returnValue=false;}','JavaScript');
        FBrowser.OleObject.document.parentWindow.execScript(
          'document.onselectstart='+
          'function(){event.returnValue=false;}','JavaScript');
      end;

      if WebBrowserSafe then
      begin
        FocusWebBrowser;
        if FBorderStyleInner = bsNone then
          WB_Set3DBorderStyle(FBrowser, False);
      end;
    end;
  DoWebDocumentComplete;
end;

procedure TATViewer.WebBrowserNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  DoWebNavigateComplete;
end;

procedure TATViewer.WebBrowserStatusTextChange(Sender: TObject; const Text: WideString);
begin
  DoWebStatusTextChange(Text);
end;

procedure TATViewer.WebBrowserTitleChange(Sender: TObject; const Text: WideString);
begin
  if Text <> 'about:blank' then
    DoWebTitleChange(Text);
end;


{$ifdef PRINT}
procedure TATViewer.PrintDialog;
var
  ASelection: Boolean;
  {$ifdef PREVIEW}
  APrintOptions: TATPrintOptions;
  APageOld, APageFrom, APageTo, i: Integer;
  OK: Boolean;
  {$endif}
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode,
    vmodeRTF,
    vmodeMedia:
      begin
        InitDialogs;
        if Assigned(FPrintDialog) then
          with FPrintDialog do
          begin
            Copies := 1;
            PrintRange := prAllPages;

            if (FMode = vmodeMedia) and IsImage and (FImagePagesCount > 1) then
            begin
              MinPage := 1;
              MaxPage := FImagePagesCount;
              FromPage := MinPage;
              ToPage := MaxPage;
            end
            else
            begin
              MinPage := 1;
              MaxPage := MaxInt;
              FromPage := 1;
              ToPage := 1;
            end;

            case FMode of
              vmodeText,
              vmodeBinary,
              vmodeHex,
              vmodeUnicode:
                begin
                  Options := [poWarning, poPageNums];
                  ASelection := (FBinHex.SelLength > 0);
                end;
              vmodeRTF:
                begin
                  Options := [poWarning];
                  ASelection := Assigned(FEdit) and (FEdit.SelLength > 0);
                end;
              vmodeMedia:
                begin
                  Options := [poWarning];
                  if IsImage and (FImagePagesCount > 1) then
                    Options := Options + [poPageNums];
                  ASelection := False;
                end;
              else
                begin
                  Options := [poWarning];
                  ASelection := False;
                end;
            end;

            if ASelection then
            begin
              Options := Options + [poSelection];
              PrintRange := prSelection;
            end;

            if Execute then
              case FMode of
                vmodeText,
                vmodeBinary,
                vmodeHex,
                vmodeUnicode:
                  FBinHex.Print(PrintRange, FromPage, ToPage, Copies);

                vmodeRTF:
                  PrintEdit(PrintRange = prSelection, Copies);

                {$ifdef PREVIEW}
                vmodeMedia:
                  if IsImage and Assigned(FImageBox) then
                  begin
                    APrintOptions := PrintOptions(Copies, False);
                    if FImagePagesCount > 1 then
                    begin
                      //Print multipage
                      OK := True;
                      APageOld := FImagePage;
                      if PrintRange = prPageNums then
                      begin
                        APageFrom := FromPage;
                        APageTo := ToPage;
                      end
                      else
                      begin
                        APageFrom := 1;
                        APageTo := FImagePagesCount;
                      end;
                      for i := APageFrom to APageTo do
                      begin
                        LoadImagePage(Pred(i));
                        APrintOptions.JobCaption := PrinterCaption + Format(' - %d/%d', [i, FImagePagesCount]);
                        APrintOptions.NoPreview := i > APageFrom;
                        OK := PicturePrint(FImageBox.CurrentPicture, APrintOptions);
                        if not OK then Break;
                      end;
                      LoadImagePage(APageOld);
                    end
                    else
                      //Print single page
                      OK := PicturePrint(FImageBox.CurrentPicture, APrintOptions);
                    //Save margins
                    if OK then
                    begin
                      MarginLeft := APrintOptions.OptMargins.Left;
                      MarginTop := APrintOptions.OptMargins.Top;
                      MarginRight := APrintOptions.OptMargins.Right;
                      MarginBottom := APrintOptions.OptMargins.Bottom;
                      PrintFooter := APrintOptions.OptFooter.Enabled;
                    end;
                  end;
                {$endif}
              end;
          end;
      end;

    vmodeWeb:
      if Assigned(FBrowser) then
        WB_ShowPrintDialog(FBrowser);

    {$ifdef WLX}
    vmodeWLX:
      FPlugins.PrintActive(Rect(
        Trunc(MarginLeft * 10),
        Trunc(MarginTop * 10),
        Trunc(MarginRight * 10),
        Trunc(MarginBottom * 10)));
    {$endif}
  end;
end;
{$endif}

{$ifdef PREVIEW}
function TATViewer.PrintOptions(
  ACopies: Integer;
  AFailOnErrors: Boolean): TATPrintOptions;
begin
  FillChar(Result, SizeOf(Result), 0);
  with Result do
  begin
    Copies := ACopies;
    OptFit := pFitNormal;
    OptFitSize.X := 100.0;
    OptFitSize.Y := 100.0;
    OptPosition := pPosCenter;
    with OptMargins do
    begin
      Left := MarginLeft;
      Top := MarginTop;
      Right := MarginRight;
      Bottom := MarginBottom;
    end;
    OptUnit := pUnitMm;
    OptGamma := 1.0;
    with OptFooter do
    begin
      Enabled := PrintFooter;
      Caption := SExtractFileName(FFileName);
      FontName := TextFontFooter.Name;
      FontSize := TextFontFooter.Size;
      FontStyle := TextFontFooter.Style;
      FontColor := TextFontFooter.Color;
      FontCharset := TextFontFooter.Charset;
    end;
    PixelsPerInch := Screen.PixelsPerInch;
    JobCaption := PrinterCaption;
    FailOnErrors := AFailOnErrors;
  end;
end;
{$endif}

{$ifdef PRINT}
procedure TATViewer.PrintPreview;
{$ifdef PREVIEW}
  var
    APrintOptions: TATPrintOptions;
{$endif}
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      begin
        FBinHex.PrintPreview;
      end;

    {$ifdef PREVIEW}
    vmodeMedia:
      begin
        if IsImage then
          if Assigned(FImageBox) then
          begin
            APrintOptions := PrintOptions(1, True);
            if PicturePrint(
              FImageBox.CurrentPicture,
              APrintOptions) then
              begin
                MarginLeft := APrintOptions.OptMargins.Left;
                MarginTop := APrintOptions.OptMargins.Top;
                MarginRight := APrintOptions.OptMargins.Right;
                MarginBottom := APrintOptions.OptMargins.Bottom;
                PrintFooter := APrintOptions.OptFooter.Enabled;
              end;
          end;
      end;
    {$endif}

    vmodeWeb:
      begin
        if Assigned(FBrowser) then
          WB_ShowPrintPreview(FBrowser);
      end;
  end;
end;
{$endif}

{$ifdef PRINT}
procedure TATViewer.PrintSetup;
const
  cIn = 100; //For millimeters
begin
  case FMode of
    vmodeWeb:
    begin
      if Assigned(FBrowser) then
        WB_ShowPageSetup(FBrowser);
    end;
    else
    begin
      InitDialogs;
      if Assigned(FPageSetupDialog) then
        with FPageSetupDialog do
        begin
          MarginLeft := Trunc(Self.MarginLeft) * cIn;
          MarginTop := Trunc(Self.MarginTop) * cIn;
          MarginRight := Trunc(Self.MarginRight) * cIn;
          MarginBottom := Trunc(Self.MarginBottom) * cIn;
          if Execute then
          begin
            Self.MarginLeft := MarginLeft / cIn;
            Self.MarginTop := MarginTop / cIn;
            Self.MarginRight := MarginRight / cIn;
            Self.MarginBottom := MarginBottom / cIn;
          end;
        end;
    end;
  end;
end;
{$endif}

function TATViewer.GetPosPercent: Integer;
var
  Num: Integer;
begin
  Result := 0;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.PosPercent;

    vmodeRTF:
      if Assigned(FEdit) then
      begin
        Num := FEdit.Lines.Count;
        if Num = 0 then
          Result := 0
        else
          Result := RE_CurrentLine(FEdit) * 100 div Num;
      end;

    vmodeWeb:
      if Assigned(FBrowser) then
        if WebBrowserSafe then
        begin
          Num := WB_GetScrollHeight(FBrowser);
          if Num = 0 then
            Result := 0
          else
            Result := WB_GetScrollTop(FBrowser) * 100 div Num;
        end;

    {$ifdef WLX}
    vmodeWLX:
      Result := FPlugins.ActivePosPercent;
    {$endif}
  end;
end;

procedure TATViewer.SetPosPercent(APos: Integer);
begin
  ILimitMin(APos, 0);
  ILimitMax(APos, 100);

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.PosPercent := APos;

    vmodeRTF:
      if Assigned(FEdit) then
        RE_ScrollToPercent(FEdit, APos);

    vmodeWeb:
      if Assigned(FBrowser) then
        if WebBrowserSafe then
          WB_SetScrollTop(FBrowser, WB_GetScrollHeight(FBrowser) * APos div 100);

    {$ifdef WLX}
    vmodeWLX:
      SendWLXCommand(lc_setpercent, APos);
      //ActivePosPercent property is just informational
    {$endif}
  end;
end;

function TATViewer.GetPosOffset: Int64;
begin
  Result := 0;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.PosOffset;

    vmodeRTF:
      if Assigned(FEdit) then
        Result := FEdit.SelStart;

    vmodeWeb:
      if Assigned(FBrowser) then
        if WebBrowserSafe then
          Result := WB_GetScrollTop(FBrowser);
  end;
end;

procedure TATViewer.SetPosOffset(const APos: Int64);
var
  Pos, Len: Integer;
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.PosOffset := APos;

    vmodeRTF:
      if Assigned(FEdit) then
      begin
        Len := Length(FEdit.Text);
        if APos <= 0 then Pos := 0 else
          if Len = 0 then Pos := 0 else
            if APos > Len - 1 then
              Pos := Len - 1
            else
              Pos := APos;
        RE_ScrollToLine(FEdit, RE_LineFromPos(FEdit, Pos), 0);
      end;

    vmodeWeb:
      if Assigned(FBrowser) then
        if WebBrowserSafe then
          WB_SetScrollTop(FBrowser, APos);
  end;
end;

{$ifdef WLX}
procedure TATViewer.HideWLX;
begin
  CloseActivePlugin;
end;

function TATViewer.LoadWLX: Boolean;
begin
  Assert(FFileName <> '', 'FileName not assigned');
  FreeData;

  Result := OpenByPlugins(False);
  //Param is False here because LoadWLX always called for the loaded file.
  //Param is True in DetectString, because DetectString always called for the new file.
end;

procedure TATViewer.SendWLXCommand(ACmd, AParam: Integer);
begin
  FPlugins.SendCommandToActive(ACmd, AParam);
end;

procedure TATViewer.SendWLXParams;
begin
  FPlugins.SendParamsToActive(
    FMediaFit,
    FMediaFitOnlyBig,
    FMediaCenter,
    FTextWrap,
    FTextEncoding = vencANSI
    );
end;

procedure TATViewer.InitPluginsParams(AParent: TWinControl; const AIniFilename: AnsiString);
begin
  FPlugins.InitParams(AParent, AIniFilename);
end;

procedure TATViewer.ResizeActivePlugin(const Rect: TRect);
begin
  FPlugins.ResizeActive(Rect);
end;

procedure TATViewer.CloseActivePlugin;
begin
  FPlugins.CloseActive;
end;

procedure TATViewer.RemovePlugins;
begin
  FPlugins.Clear;
end;

function TATViewer.AddPlugin(const AFileName: TWlxFilename; const ADetectStr: TWlxDetectString): Boolean;
begin
  Result := FPlugins.AddPlugin(AFileName, ADetectStr);
end;

function TATViewer.GetPlugin(AIndex: Word; var AFileName: TWlxFilename; var ADetectStr: TWlxDetectString): Boolean;
begin
  Result := FPlugins.GetPlugin(AIndex, AFileName, ADetectStr);
end;

function TATViewer.GetPluginsBeforeLoading: TWlxNameEvent;
begin
  Result := FPlugins.OnBeforeLoading;
end;

function TATViewer.GetPluginsAfterLoading: TWlxNameEvent;
begin
  Result := FPlugins.OnAfterLoading;
end;

procedure TATViewer.SetPluginsBeforeLoading(AProc: TWlxNameEvent);
begin
  FPlugins.OnBeforeLoading := AProc;
end;

procedure TATViewer.SetPluginsAfterLoading(AProc: TWlxNameEvent);
begin
  FPlugins.OnAfterLoading := AProc;
end;

function TATViewer.OpenByPlugins(AFileIsNew: Boolean): Boolean;
begin
  FPlugins.IsFocused := FFocused;
  Result := FPlugins.OpenMatched(
    FFileName,
    FMediaFit,
    FMediaFitOnlyBig,
    FMediaCenter,
    FTextWrap,
    FTextEncoding = vencANSI,
    AFileIsNew);
end;

function TATViewer.GetActivePluginSupportsSearch: Boolean;
begin
  Result := FPlugins.ActiveSupportsSearch;
end;

function TATViewer.GetActivePluginSupportsPrint: Boolean;
begin
  Result := FPlugins.ActiveSupportsPrint;
end;

function TATViewer.GetActivePluginSupportsCommands: Boolean;
begin
  Result := FPlugins.ActiveSupportsCommands;
end;

function TATViewer.GetActivePluginWindowHandle: THandle;
begin
  Result := FPlugins.ActiveWindowHandle;
end;

procedure TATViewer.PluginsSendMessage(const AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_COMMAND:
      begin
        if AMessage.WParamHi = itm_percent then
          FPlugins.ActivePosPercent := AMessage.WParamLo;
      end;
    else
      FPlugins.SendMessageToActive(AMessage);
  end;
end;

{$endif}


//Function can be used not only in Plugins mode
function TATViewer.GetActivePluginName: AnsiString;
begin
  Result := '';

  case FMode of
    //Stub to compile when defines are commented
    vmodeText:
      Result := '';

    {$ifdef WLX}
    vmodeWLX:
      Result := FPlugins.GetActiveName;
    {$endif}
  end;
end;


{$ifdef SEARCH}
function TATViewer.GetOnTextSearchProgress: TATStreamSearchProgress;
begin
  Result := FBinHex.OnSearchProgress;
end;

procedure TATViewer.SetOnTextSearchProgress(AValue: TATStreamSearchProgress);
begin
  FBinHex.OnSearchProgress := AValue;
end;
{$endif}

procedure TATViewer.EditMenuItemCopyClick(Sender: TObject);
begin
  if Assigned(FEdit) then
    try
      FEdit.CopyToClipboard;
    except
      MsgError(MsgViewerErrCannotCopyData);
    end;
end;

procedure TATViewer.EditMenuItemSelectAllClick(Sender: TObject);
begin
  if Assigned(FEdit) then
    FEdit.SelectAll;
end;

procedure TATViewer.TextSelectionChange(Sender: TObject);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      with FBinHex do
      begin
        if FTextAutoCopy then
          if SelLength > 0 then
            CopyToClipboard;
      end;

    vmodeRTF:
      if Assigned(FEdit) then
        with FEdit do
        begin
          if not TextEnableSel then
            SelLength := 0;
          FEditMenuItemCopy.Enabled := SelLength > 0;
          FEditMenuItemSelectAll.Enabled := TextEnableSel and (not ((SelStart = 0) and (SelLength >= Length(Text))));
          if FTextAutoCopy then
            if SelLength > 0 then
              CopyToClipboard;
        end;
  end;
end;

procedure TATViewer.SetTextPopupCaption(AIndex: TATPopupCommand; const AValue: WideString);
begin
  FBinHex.TextPopupCaption[AIndex] := AValue;

  case AIndex of
    vpCmdCopy:
      if Assigned(FEditMenuItemCopy) then
        FEditMenuItemCopy.Caption := AValue;
    vpCmdSelectAll:
      if Assigned(FEditMenuItemSelectAll) then
        FEditMenuItemSelectAll.Caption := AValue;
  end;
end;

function TATViewer.DetectTextAndUnicode: Boolean;
const
  Enc: array[Boolean] of TATEncoding = (vencANSI, vencOEM);
var
  h: THandle;
  IsOEM, IsUTF8: Boolean;
begin
  Result := False;

  h := FFileOpen(FFileName);
  if h = INVALID_HANDLE_VALUE then Exit;

  try
    if (not (vmodeUnicode in FModesDisabledForDetect)) and
      IsFileUnicode(h) then
        begin FMode := vmodeUnicode; Result := True end
    else

    if (not (vmodeRTF in FModesDisabledForDetect)) and
      IsFileUTF8(h) then
        begin FMode := vmodeRTF; Result := True end
    else

    if (not (vmodeWeb in FModesDisabledForDetect)) and
      IsFileWeb(h) then
        begin FMode := vmodeWeb; Result := True end
    else

    if (not (vmodeText in FModesDisabledForDetect)) and
      ((FTextDetectLimit = 0) or (FFileSize <= Int64(FTextDetectLimit) * 1024)) and
      IsFileText(h, FTextDetectSize,
        FTextDetectOEM, FTextDetectUTF8, IsOEM, IsUTF8) then
      begin
        FMode := vmodeText;
        if FTextDetectOEM then
          FTextEncoding := Enc[IsOEM];
        if FTextDetectUTF8 and IsUTF8 then
          FMode := vmodeRTF;
        Result := True
      end;
  finally
    CloseHandle(h);
  end;
end;

{$ifdef NOTIF}

function TATViewer.GetTextAutoReload: Boolean;
begin
  Result := FBinHex.AutoReload;
end;

function TATViewer.GetTextAutoReloadBeep: Boolean;
begin
  Result := FBinHex.AutoReloadBeep;
end;

function TATViewer.GetTextAutoReloadFollowTail: Boolean;
begin
  Result := FBinHex.AutoReloadFollowTail;
end;

procedure TATViewer.SetTextAutoReload(AValue: Boolean);
begin
  FBinHex.AutoReload := AValue;
end;

procedure TATViewer.SetTextAutoReloadBeep(AValue: Boolean);
begin
  FBinHex.AutoReloadBeep := AValue;
end;

procedure TATViewer.SetTextAutoReloadFollowTail(AValue: Boolean);
begin
  FBinHex.AutoReloadFollowTail := AValue;
end;

function TATViewer.GetOnTextFileReload: TNotifyEvent;
begin
  Result := FBinHex.OnFileReload;
end;

procedure TATViewer.SetOnTextFileReload(AEvent: TNotifyEvent);
begin
  FBinHex.OnFileReload := AEvent;
end;

{$endif}

function TATViewer.GetTextTabSize: Integer;
begin
  Result := FBinHex.TextTabSize;
end;

procedure TATViewer.SetTextTabSize(AValue: Integer);
begin
  FBinHex.TextTabSize := AValue;
end;

function TATViewer.GetTextPopupCommands: TATPopupCommands;
begin
  Result := FBinHex.TextPopupCommands;
end;

procedure TATViewer.SetTextPopupCommands(AValue: TATPopupCommands);
begin
  FBinHex.TextPopupCommands := AValue;
end;


function TATViewer.ImageEffect(AEffect: TATViewerImageEffect): Boolean;
const
  Effects: array[TATViewerImageEffect] of TATImageEffect = (
    aieCorrectOnly,
    aieRotate90,
    aieRotate270,
    aieRotate180,
    aieGrayscale,
    aieSepia,
    aieNegative,
    aieFlipVertical,
    aieFlipHorizontal
    );
begin
  Result := False;
  if FIsGif then Exit;
  if Assigned(FImageBox)
    and Assigned(FImageBox.Image.Picture)
    and Assigned(FImageBox.Image.Picture.Graphic) then
  begin
    Result := PictureEffect(FImageBox.Image.Picture, Effects[AEffect], FImageColor);
    if Result then
      FImageBox.UpdateInfo;
  end;
end;

function TATViewer.GetTextMaxLengths(AIndex: TATBinHexMode): Integer;
begin
  Result := FBinHex.MaxLengths[AIndex];
end;

procedure TATViewer.SetTextMaxLengths(AIndex: TATBinHexMode; AValue: Integer);
begin
  FBinHex.MaxLengths[AIndex] := AValue;
end;

{$ifdef IE4X}
procedure TATViewer.WebBrowserFileDownload(Sender: TObject; ActiveDocument: WordBool; var Cancel: WordBool);
begin
  Cancel := not FWebAcceptAllFiles;
end;
{$endif}


function TATViewer.GetImageScale: Integer;
begin
  Result := 100;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageScale;
end;

procedure TATViewer.SetImageScale(AValue: Integer);
begin
  if Assigned(FImageBox) then
    FImageBox.ImageScale := AValue;
end;

procedure TATViewer.ImageScaleInc;
begin
  if Assigned(FImageBox) then
    FImageBox.IncreaseImageScale(True);
end;

procedure TATViewer.ImageScaleDec;
begin
  if Assigned(FImageBox) then
    FImageBox.IncreaseImageScale(False);
end;

procedure TATViewer.TextPopupMenu(AX, AY: Integer);
begin
  if FNoCtx then Exit;
  
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.PopupMenu.Popup(AX, AY);

    vmodeRTF:
      if Assigned(FEdit) then
        FEdit.PopupMenu.Popup(AX, AY);
  end;
end;

procedure TATViewer.TextEncodingsMenu(AX, AY: Integer);
begin
  FBinHex.TextEncodingsMenu(AX, AY);
end;

procedure TATViewer.WebGoBack;
begin
  if Assigned(FBrowser) then
    try
      FBrowser.GoBack;
    except
    end;
end;

procedure TATViewer.WebGoForward;
begin
  if Assigned(FBrowser) then
    try
      FBrowser.GoForward;
    except
    end;
end;

function TATViewer.GetSelStart: Int64;
begin
  Result := 0;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.SelStart;

    vmodeRTF:
      if Assigned(FEdit) then
        Result := FEdit.SelStart;
  end;
end;

procedure TATViewer.SetSelStart(const AValue: Int64);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      with FBinHex do
        SetSelection(AValue, SelLength, False{Don't scroll});

    vmodeRTF:
      if Assigned(FEdit) then
        FEdit.SelStart := AValue;
  end;
end;

function TATViewer.GetSelLength: Int64;
begin
  Result := 0;

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.SelLength;

    vmodeRTF:
      if Assigned(FEdit) then
        Result := FEdit.SelLength;
  end;
end;

procedure TATViewer.SetSelLength(const AValue: Int64);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      with FBinHex do
        SetSelection(SelStart, AValue, False{Don't scroll});

    vmodeRTF:
      if Assigned(FEdit) then
        FEdit.SelLength := AValue;
  end;
end;

function TATViewer.GetSelText: AnsiString;
begin
  Result := '';

  Assert(FMode <> vmodeUnicode, 'TextSelText is called in Unicode mode');

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.SelText;

    vmodeRTF:
      if Assigned(FEdit) then
        Result := FEdit.SelText;
  end;
end;

const
  cMaxShortLength = 256;

function TATViewer.GetSelTextShort: AnsiString;
begin
  Result := '';

  Assert(FMode <> vmodeUnicode, 'TextSelText is called in Unicode mode');

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.SelTextShort;

    vmodeRTF:
      if Assigned(FEdit) then
        Result := Copy(FEdit.SelText, 1, cMaxShortLength);
  end;
end;

function TATViewer.GetSelTextW: WideString;
begin
  Assert(FMode = vmodeUnicode, 'TextSelTextW is called in non-Unicode mode');

  Result := FBinHex.SelTextW;
end;

function TATViewer.GetSelTextShortW: WideString;
begin
  Assert(FMode = vmodeUnicode, 'TextSelTextW is called in non-Unicode mode');

  Result := FBinHex.SelTextShortW;
end;

procedure TATViewer.TextScroll(const APos: Int64; AIndentVert, AIndentHorz: Integer);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.Scroll(APos, AIndentVert, AIndentHorz);

    vmodeRTF:
      if Assigned(FEdit) then
        RE_ScrollToPos(FEdit, APos, AIndentVert, AIndentHorz);
  end;
end;

procedure TATViewer.IncreaseScale(AIncrement: Boolean);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.IncreaseFontSize(AIncrement);

    vmodeRTF:
      if Assigned(FEdit) then
      begin
        if TextIncreaseFontSize(FEdit.Font, Self.Canvas, AIncrement) then
          GetTextFont.Size := FEdit.Font.Size;
      end;

    vmodeMedia:
      if IsImage then
      begin
        if AIncrement then
          ImageScaleInc
        else
          ImageScaleDec;
      end;

    vmodeWeb:
      if Assigned(FBrowser) then
        if WebBrowserSafe then
          WB_IncreaseFont(FBrowser, AIncrement);
  end;
end;

function TATViewer.GetImageDrag: Boolean;
begin
  Result := FImageDrag;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageDrag;
end;

procedure TATViewer.SetImageDrag(AValue: Boolean);
begin
  FImageDrag := AValue;
  if Assigned(FImageBox) then
    FImageBox.ImageDrag := AValue;
end;

function TATViewer.GetImageCursor: TCursor;
begin
  Result := FImageCursor;
  if Assigned(FImageBox) then
    Result := FImageBox.Image.Cursor;
end;

procedure TATViewer.SetImageCursor(AValue: TCursor);
begin
  FImageCursor := AValue;
  if Assigned(FImageBox) then
    FImageBox.Image.Cursor := AValue;
end;

function TATViewer.GetImageDragCursor: TCursor;
begin
  Result := FImageDragCursor;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageDragCursor;
end;

procedure TATViewer.SetImageDragCursor(AValue: TCursor);
begin
  FImageDragCursor := AValue;
  if Assigned(FImageBox) then
    FImageBox.ImageDragCursor := AValue;
end;

function TATViewer.GetImageWidth: Integer;
begin
  Result := 0;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageWidth;
end;

function TATViewer.GetImageHeight: Integer;
begin
  Result := 0;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageHeight;
end;

function TATViewer.GetImageBPP: Integer;
var
  G: TGraphic;
const
  PN: array[TPixelFormat] of Integer =
    (0, 1, 4, 8, 15, 16, 24, 32, 0);
begin
  Result := 0;
  if Assigned(FImageBox) and
    Assigned(FImageBox.Image) and
    Assigned(FImageBox.Image.Picture) then
  begin
    G := FImageBox.Image.Picture.Graphic;

    {$ifdef GIF}
    if (G is TGifImage) then
      Result := (G as TGifImage).BitsPerPixel;
    {$endif}

    {$ifdef GEX}
    if (G is TGraphicExGraphic) then
      Result := (G as TGraphicExGraphic).ImageProperties.BitsPerPixel;
    {$endif}

    {$ifdef PNG}
    //Code similar to PngImage
    if (G is TPngObject) then
      with (G as TPngObject).Header do
        case ColorType of
          COLOR_GRAYSCALE, COLOR_PALETTE:
            Result := BitDepth;
          COLOR_RGB:
            Result := BitDepth * 3;
          COLOR_GRAYSCALEALPHA:
            Result := BitDepth * 2;
          COLOR_RGBALPHA:
            Result := BitDepth * 4;
          else
            Result := 0;
        end;
    {$endif}

    if (G is TBitmap) and (not FIsIcon) then
      Result := PN[(G as TBitmap).PixelFormat];
  end;
end;

//We need to get MediaFit from ImageBox object, since current FMediaFit
//value can be not actual (fit option can be changed during scaling)
function TATViewer.GetMediaFit: Boolean;
begin
  Result := FMediaFit;
  if (FMode = vmodeMedia) and FIsImage then
    if Assigned(FImageBox) then
      Result := FImageBox.ImageFitToWindow;
end;

function TATViewer.GetMediaFitOnlyBig: Boolean;
begin
  Result := FMediaFitOnlyBig;
  if (FMode = vmodeMedia) and FIsImage then
    if Assigned(FImageBox) then
      Result := FImageBox.ImageFitOnlyBig;
end;

function TATViewer.GetMediaFitWidth: Boolean;
begin
  Result := FMediaFitWidth;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageFitWidth;
end;

function TATViewer.GetMediaFitHeight: Boolean;
begin
  Result := FMediaFitHeight;
  if Assigned(FImageBox) then
    Result := FImageBox.ImageFitHeight;
end;

function TATViewer.GetMediaCenter: Boolean;
begin
  Result := FMediaCenter;
  if (FMode = vmodeMedia) and FIsImage then
    if Assigned(FImageBox) then
      Result := FImageBox.ImageCenter;
end;

function TATViewer.GetTextMaxClipboardDataSizeMb: Integer;
begin
  Result := FBinHex.MaxClipboardDataSizeMb;
end;

procedure TATViewer.SetTextMaxClipboardDataSizeMb(AValue: Integer);
begin
  FBinHex.MaxClipboardDataSizeMb := AValue;
end;


procedure TATViewer.SetOnOptionsChange(AEvent: TNotifyEvent);
begin
  FOnOptionsChange := AEvent;
  FBinHex.OnOptionsChange := FOnOptionsChange;
  if Assigned(FImageBox) then
    FImageBox.OnOptionsChange := FOnOptionsChange;
end;

function TATViewer.WebBrowserSafe: Boolean;
begin
  //Acrobat OCX can be non-safe in some cases, e.g.
  //after focusing it the program may crash on exit.
  Result := not SFileExtensionMatch(FFileName, 'pdf');
end;

function TATViewer.GetWebBusy: Boolean;
begin
  Result := False;
  if Assigned(FBrowser) then
  begin
    if FBrowser.Busy then
      FBrowser.Stop;
    Result := FBrowser.Busy;
  end;
end;


function TATViewer.GetTextEncodingName: AnsiString;
begin
  Result := '';

  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.TextEncodingName;
    vmodeRTF:
      if Assigned(FEdit) then
        if FEdit.PlainText then
          Result := 'UTF-8'
        else
          Result := 'RTF';
  end;
end;


{$ifdef PRINT}
function TATViewer.GetMarginLeft;
begin
  Result := FBinHex.MarginLeft;
end;

function TATViewer.GetMarginTop;
begin
  Result := FBinHex.MarginTop;
end;

function TATViewer.GetMarginRight;
begin
  Result := FBinHex.MarginRight;
end;

function TATViewer.GetMarginBottom;
begin
  Result := FBinHex.MarginBottom;
end;

procedure TATViewer.SetMarginLeft;
begin
  FBinHex.MarginLeft := AValue;
end;

procedure TATViewer.SetMarginTop;
begin
  FBinHex.MarginTop := AValue;
end;

procedure TATViewer.SetMarginRight;
begin
  FBinHex.MarginRight := AValue;
end;

procedure TATViewer.SetMarginBottom;
begin
  FBinHex.MarginBottom := AValue;
end;

function TATViewer.MarginsRectPx: TRect;
begin
  Result := FBinHex.MarginsRectRealPx;
end;

function TATViewer.GetPrintFooter;
begin
  Result := FBinHex.PrintFooter;
end;

procedure TATViewer.SetPrintFooter;
begin
  FBinHex.PrintFooter := AValue;
end;
{$endif}

procedure TATViewer.SetPosLine(ALine: Integer);
begin
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      FBinHex.PosLine := ALine;
    vmodeRTF:
      if Assigned(FEdit) then
        RE_ScrollToLine(FEdit, ALine - 1, 0);
  end;
end;

function TATViewer.GetPosLine: Integer;
begin
  Result := 0;
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      Result := FBinHex.PosLine;
    vmodeRTF:
      if Assigned(FEdit) then
        Result := RE_CurrentLine(FEdit) + 1;
  end;
end;


procedure TATViewer.TextURLClick(Sender: TObject; const S: AnsiString);
begin
  FOpenURL(S, Handle);
end;

procedure TATViewer.LoadImagePage(N: Integer);
begin
  if (N >= 0) and (N <= Pred(FImagePagesCount)) then
  begin
    FImagePage := N;
    LoadImage(nil, False);
  end
  else
    MessageBeep(MB_ICONWARNING);
end;

procedure TATViewer.ImageUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if Button = ComCtrls.btNext then
    LoadImagePage(Succ(FImagePage))
  else
    LoadImagePage(Pred(FImagePage));
end;

procedure TATViewer.ImageBoxScroll;
begin
  with FImageUpDown do
  begin
    Left := Parent.ClientWidth - Width;
    Top := 0;
    Hint := Format(MsgViewerPageHint, [Succ(FImagePage), FImagePagesCount]);
  end;
end;

procedure TATViewer.ImageBoxScrollAlt;
begin
  if Inc then
    ImageUpDownClick(Self, ComCtrls.btNext)
  else
    ImageUpDownClick(Self, ComCtrls.btPrev);
end;

procedure TATViewer.TextPanelClick;
begin
  FTextPanel.Hide;
  FTextPanel0.Hide;
  FMode := FModeUndetected;
  case FMode of
    vmodeText,
    vmodeBinary,
    vmodeHex,
    vmodeUnicode:
      LoadBinary;
    vmodeRTF:
      LoadRTF;
  end;
  DoFileLoad;
  DoOptionsChange;
end;

procedure TATViewer.WebWait;
begin
  if Assigned(FBrowser) then
    WB_Wait(FBrowser);
end;

function TATViewer.GetTextEnableSel: Boolean;
begin
  Result := FBinHex.TextEnableSel;
end;

procedure TATViewer.SetTextEnableSel(AValue: Boolean);
begin
  FBinHex.TextEnableSel := AValue;
end;

procedure TATViewer.SetTextColorBin(A: TColor);
begin
  FTextPanel.Color := A;
end;

procedure TATViewer.SetParentWnd(H: integer);
begin
  Parent := nil;
  ParentWindow := H;
  FBinHex.Parent := nil;
  FBinHex.ParentWindow := Self.Handle;
  {$ifdef WLX}
  FPlugins.InitParams2(Self.Handle, SExpandVars('%temp%\lsplugin.ini'));
  {$endif}
end;

procedure TATViewer.SetBorderStyleInner(AValue: TBorderStyle);
begin
  FBorderStyleInner := AValue;
  FBinHex.BorderStyle := FBorderStyleInner;
  if Assigned(FImageBox) then
    FImageBox.BorderStyle := FBorderStyleInner;
  if Assigned(FEdit) then
    FEdit.BorderStyle := FBorderStyleInner;

  if Assigned(FBrowser) then
    if WebBrowserSafe then
      WB_Set3DBorderStyle(FBrowser, FBorderStyleInner <> bsNone);
end;

function TATViewer.GetTextLineSpacing: Integer;
begin
  Result:= FBinHex.TextLineSpacing;
end;

procedure TATViewer.SetTextLineSpacing(AValue: Integer);
begin
  FBinHex.TextLineSpacing:= AValue;
end;

function TATViewer.GetMessagesEnabled: boolean;
begin
  Result := ATViewerMessagesEnabled;
end;

procedure TATViewer.SetMessagesEnabled(V: boolean);
begin
  ATViewerMessagesEnabled := V;
end;

function TATViewer.GetExtImages: Widestring;
begin
  Result := ATViewerOptions.ExtImages;
end;

procedure TATViewer.SetExtImages(const S: Widestring);
begin
  ATViewerOptions.ExtImages := S;
end;

function TATViewer.GetExtInet: Widestring;
begin
  Result := ATViewerOptions.ExtInet;
end;

procedure TATViewer.SetExtInet(const S: Widestring);
begin
  ATViewerOptions.ExtInet := S;
end;

procedure TATViewer.SetMessageText(Id: Integer; const S: Widestring);
begin
  case Id of
    0:  MsgViewerCaption:= S;
    1:  MsgViewerShowCfm:= S;
    2:  MsgViewerShowEmpty:= S;
    3:  MsgViewerErrCannotFindFile:= S;
    4:  MsgViewerErrCannotFindFolder:= S;
    5:  MsgViewerErrCannotOpenFile:= S;
    6:  MsgViewerErrCannotLoadFile:= S;
    7:  MsgViewerErrCannotReadFile:= S;
    8:  MsgViewerErrCannotReadStream:= S;
    9:  MsgViewerErrCannotReadPos:= S;
    10:  MsgViewerErrDetect:= S;
    11:  MsgViewerErrImage:= S;
    14:  MsgViewerErrInitControl:= S;
    15:  MsgViewerErrInitOffice:= S;
    16:  MsgViewerErrCannotCopyData:= S;
    17:  MsgViewerWlxException:= S;
    18:  MsgViewerWlxParentNotSpecified:= S;
    21:  MsgViewerPageHint:= S;
  end;
end;

procedure TATViewer.ImageBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(FOnImageRClick) then
    FOnImageRClick(Self);
end;

procedure TATViewer.SetNoCtx(V: boolean);
begin
  FNoCtx:= V;
  if V then
  begin
    if Assigned(FEdit) then
      FEdit.PopupMenu:= nil;
    FBinHex.PopupMenu:= nil;
  end;
end;

function ShiftToInt(const Shift: TShiftState): Integer;
begin
  Result:= 0;
  if ssShift in Shift then Result:= Result or 1;
  if ssAlt in Shift then Result:= Result or 2;
  if ssCtrl in Shift then Result:= Result or 4;
  if ssLeft in Shift then Result:= Result or 8;
  if ssRight in Shift then Result:= Result or 16;
  if ssMiddle in Shift then Result:= Result or 32;
end;

procedure TATViewer.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnImageMouseDown) then
    FOnImageMouseDown(Sender, Integer(Button), ShiftToInt(Shift), X, Y);
end;

procedure TATViewer.ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnImageMouseUp) then
    FOnImageMouseUp(Sender, Integer(Button), ShiftToInt(Shift), X, Y);
end;

procedure TATViewer.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnImageMouseMove) then
    FOnImageMouseMove(Sender, 0, ShiftToInt(Shift), X, Y);
end;


{ Registration }
procedure Register;
begin
  RegisterComponents('Samples', [TATViewer]);
end;

initialization
  {$ifdef JP2}
  TJP2Image.RegisterFileFormats;
  {$endif}
  ATViewerOptionsReset;

end.
