{***************************************}
{                                       }
{  ATPrintPreview Component             }
{  Copyright (C) Alexey Torgashin       }
{  http://uvviewsoft.com                }
{                                       }
{***************************************}

unit ATPrintPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,
  ATxPrintProc, ATxUpEdit, ATImageBox;

type
  TATPreviewCallback = procedure(
    ACanvas: TCanvas;
    AOptPosition: TATPrintPosition;
    AOptFit: TATPrintFitMode;
    AOptFitSize: TFloatSize;
    const AOptMargins: TFloatRect;
    const AOptGamma: Double;
    const AOptFooter: TATPrintFooter) of object;

type
  TFormATPreview = class(TForm)
    boxOptions: TGroupBox;
    boxPreview: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnPrintSetup: TButton;
    boxPosition: TGroupBox;
    PrinterSetupDialog1: TPrinterSetupDialog;
    boxMargins: TGroupBox;
    edMarginTop: TUpEdit;
    labMarginTop: TLabel;
    labMarginBottom: TLabel;
    edMarginBottom: TUpEdit;
    labMarginLeft: TLabel;
    edMarginLeft: TUpEdit;
    labMarginRight: TLabel;
    edMarginRight: TUpEdit;
    Panel2: TPanel;
    btnPos1: TSpeedButton;
    btnPos2: TSpeedButton;
    btnPos3: TSpeedButton;
    btnPos4: TSpeedButton;
    btnPos5: TSpeedButton;
    btnPos6: TSpeedButton;
    btnPos7: TSpeedButton;
    btnPos8: TSpeedButton;
    btnPos9: TSpeedButton;
    boxGamma: TGroupBox;
    labGamma: TLabel;
    edGamma: TUpEdit;
    FontDialog1: TFontDialog;
    panFit: TPanel;
    labFit: TLabel;
    labSizeX: TLabel;
    labSizeY: TLabel;
    labMm2: TLabel;
    labMm1: TLabel;
    edFit: TComboBox;
    edSizeX: TUpEdit;
    edSizeY: TUpEdit;
    chkFitProp: TCheckBox;
    panFooter: TPanel;
    chkFooter: TCheckBox;
    btnFont: TButton;
    V: TATImageBox;
    labHint: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrintSetupClick(Sender: TObject);
    procedure btnPos1Click(Sender: TObject);
    procedure edMarginTopChange(Sender: TObject);
    procedure edFitChange(Sender: TObject);
    procedure edSizeXChange(Sender: TObject);
    procedure edSizeYChange(Sender: TObject);
    procedure chkFitPropClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure chkFooterClick(Sender: TObject);
  private
    { Private declarations }
    FBitmap: TBitmap;
    FBitmapSizeX: Integer;
    FBitmapSizeY: Integer;
    FPreview: TATPreviewCallback;
    FEnabled: Boolean;
    FFitting: Boolean;
    FUnit: TATPrintUnit;
    FFooterCaption: WideString;
    FFooterLine: Boolean;
    function GetPosition: TATPrintPosition;
    function GetFitSize: TFloatSize;
    function InitBitmap: Boolean;
    procedure DoPreview;
    procedure FitChange;
    procedure FooterChange;
    function GetFitMode: TATPrintFitMode;
    function GetMargins: TFloatRect;
    function GetGamma: Double;
    function GetFooter: TATPrintFooter;
    procedure FitSizeY;
    procedure FitSizeX;
  public
    { Public declarations }
  end;

//-----------------------------------------------------
var
  //Captions:
  MsgPreviewDlgCaption: string = 'Print preview';
  MsgPreviewDlgPrintSetup: string = '&Print setup...';
  MsgPreviewDlgPrint: string = 'Print';
  MsgPreviewDlgCancel: string = 'Cancel';
  MsgPreviewDlgOptions: string = ' Options ';
  MsgPreviewDlgPosition: string = ' Position ';
  MsgPreviewDlgPreview: string = ' Preview ';
  MsgPreviewDlgMargins: string = ' Margins ';
  MsgPreviewDlgGamma: string = ' Gamma ';

  MsgPreviewDlgMarginLeft: string = '&Left:';
  MsgPreviewDlgMarginTop: string = '&Top:';
  MsgPreviewDlgMarginRight: string = '&Right:';
  MsgPreviewDlgMarginBottom: string = '&Bottom:';
  MsgPreviewDlgOptFitMode: string = '&Fit mode:';
  MsgPreviewDlgOptFitSizeX: string = '&Width:';
  MsgPreviewDlgOptFitSizeY: string = '&Height:';
  MsgPreviewDlgOptFitSizeProp: string = 'Proportio&nal';
  MsgPreviewDlgOptFooter: string = 'F&ooter text';
  MsgPreviewDlgOptFooterFont: string = 'Font...';
  MsgPreviewDlgOptGamma: string = '&Gamma value:';

  MsgPreviewDlgUnit: array[TATPrintUnit] of string =
    ('mm', 'cm', 'inches');
  MsgPreviewDlgFitModes: array[TATPrintFitMode] of string =
    ('Normal', 'Best fit to page', 'Stretch to page', 'Custom size');
  MsgPreviewDlgPos: array[TATPrintPosition] of string =
    ('Top-Left', 'Top', 'Top-Right',
     'Left', 'Center', 'Right',
     'Bottom-Left', 'Bottom', 'Bottom-Right');

  //Error messages:
  MsgPreviewDlgCannotAllocateMemory: string = 'Cannot allocate temporary bitmap, not enougth memory.';

  //Font:
  MsgPreviewDlgFontName: string = 'Tahoma';
  MsgPreviewDlgFontSize: Integer = 8;

//-----------------------------------------------------

function ShowImagePreviewDialog(
  ACallback: TATPreviewCallback;
  var AOptions: TATPrintOptions;
  ABitmapSizeX,
  ABitmapSizeY: Integer): Boolean;

function ShowTextPreviewDialog(
  ACallback: TATPreviewCallback;
  AFailOnErrors: Boolean): Boolean;

function PreviewPageWidth(APixelsPerInch: Integer): Integer;
function PreviewPageHeight(APixelsPerInch: Integer): Integer;

var PreviewParentWnd: integer = 0;

implementation

uses
  Printers;

{$R *.dfm}

//-------------------------------------------------------------------
function ShowImagePreviewDialog(
  ACallback: TATPreviewCallback;
  var AOptions: TATPrintOptions;
  ABitmapSizeX,
  ABitmapSizeY: Integer): Boolean;
const
  cInc: array[TATPrintUnit] of Double =
    (1.0, 0.5, 0.2);
begin
  with TFormATPreview.Create(nil) do
    try
      if not InitBitmap then
      begin
        Result := not AOptions.FailOnErrors;
        Exit;
      end;

      FPreview := ACallback;
      FBitmapSizeX := ABitmapSizeX;
      FBitmapSizeY := ABitmapSizeY;

      FUnit := AOptions.OptUnit;
      edSizeX.Inc        := cInc[FUnit];
      edSizeY.Inc        := cInc[FUnit];
      edSizeX.Min        := cInc[FUnit];
      edSizeY.Min        := cInc[FUnit];
      edMarginLeft.Inc   := cInc[FUnit];
      edMarginRight.Inc  := cInc[FUnit];
      edMarginTop.Inc    := cInc[FUnit];
      edMarginBottom.Inc := cInc[FUnit];

      boxMargins.Caption := Format('%s(%s) ', [MsgPreviewDlgMargins, MsgPreviewDlgUnit[FUnit]]);
      labMm1.Caption := MsgPreviewDlgUnit[FUnit];
      labMm2.Caption := MsgPreviewDlgUnit[FUnit];

      case AOptions.OptPosition of
        pPosTopLeft   : btnPos1.Down := True;
        pPosTop       : btnPos2.Down := True;
        pPosTopRight  : btnPos3.Down := True;
        pPosLeft      : btnPos4.Down := True;
        pPosCenter    : btnPos5.Down := True;
        pPosRight     : btnPos6.Down := True;
        pPosBottomLeft: btnPos7.Down := True;
        pPosBottom    : btnPos8.Down := True;
        else            btnPos9.Down := True;
      end;

      edFit.ItemIndex := Ord(AOptions.OptFit);
      edGamma.Value := AOptions.OptGamma;
      FFooterCaption := AOptions.OptFooter.Caption;
      FFooterLine := AOptions.OptFooter.EnableLine;
      chkFooter.Checked := AOptions.OptFooter.Enabled;

      with AOptions.OptFooter, FontDialog1 do
      begin
        Font.Name := FontName;
        Font.Size := FontSize;
        Font.Style := FontStyle;
        Font.Color := FontColor;
        Font.Charset := FontCharset;
      end;

      with AOptions.OptMargins do
      begin
        edMarginLeft.Value := Left;
        edMarginTop.Value := Top;
        edMarginRight.Value := Right;
        edMarginBottom.Value := Bottom;
      end;

      edSizeX.Value := AOptions.OptFitSize.X;
      chkFitProp.Checked := True;

      Result := ShowModal = mrOk;
      if Result then
      begin
        AOptions.OptFit := GetFitMode;
        AOptions.OptFitSize := GetFitSize;
        AOptions.OptPosition := GetPosition;
        AOptions.OptMargins := GetMargins;
        AOptions.OptGamma := GetGamma;
        AOptions.OptFooter := GetFooter;
      end;
    finally
      Release;
    end;
end;

//-------------------------------------------------------------------
function ShowTextPreviewDialog(
  ACallback: TATPreviewCallback;
  AFailOnErrors: Boolean): Boolean;
begin
  with TFormATPreview.Create(nil) do
    try
      if not InitBitmap then
      begin
        Result := not AFailOnErrors;
        Exit;
      end;

      //Hide image options
      boxOptions.Visible := False;
      boxMargins.Visible := False;
      boxPosition.Visible := False;
      boxGamma.Visible := False;
      Width := Width - boxGamma.Width - boxGamma.Left;
      //Width := Width - boxGamma.Width - boxOptions.Left;
      //panFit.Visible := False;
      //panFooter.Top := 80;

      FPreview := ACallback;
      Result := ShowModal = mrOk;
    finally
      Release;
    end;
end;

//-------------------------------------------------------------------
function TFormATPreview.GetPosition: TATPrintPosition;
begin
  if btnPos1.Down then Result := pPosTopLeft else
   if btnPos2.Down then Result := pPosTop else
    if btnPos3.Down then Result := pPosTopRight else
     if btnPos4.Down then Result := pPosLeft else
      if btnPos5.Down then Result := pPosCenter else
       if btnPos6.Down then Result := pPosRight else
        if btnPos7.Down then Result := pPosBottomLeft else
         if btnPos8.Down then Result := pPosBottom else
                               Result := pPosBottomRight;
end;

//-------------------------------------------------------------------
function TFormATPreview.GetFitSize: TFloatSize;
begin
  Result.x := edSizeX.Value;
  Result.y := edSizeY.Value;
end;

//-------------------------------------------------------------------
function TFormATPreview.GetMargins: TFloatRect;
begin
  Result.Left := edMarginLeft.Value;
  Result.Top := edMarginTop.Value;
  Result.Right := edMarginRight.Value;
  Result.Bottom := edMarginBottom.Value;
end;

//-------------------------------------------------------------------
function TFormATPreview.GetGamma: Double;
begin
  Result := edGamma.Value;
end;

function TFormATPreview.GetFooter: TATPrintFooter;
begin
  with Result do
  begin
    Enabled := chkFooter.Checked;
    EnableLine := FFooterLine;
    Caption := FFooterCaption;
    with FontDialog1 do
    begin
      FontName := Font.Name;
      FontSize := Font.Size;
      FontStyle := Font.Style;
      FontColor := Font.Color;
      FontCharset := Font.Charset;
    end;
  end;
end;

//-------------------------------------------------------------------
function TFormATPreview.GetFitMode: TATPrintFitMode;
begin
  Result := TATPrintFitMode(edFit.ItemIndex);
end;

//-------------------------------------------------------------------
procedure TFormATPreview.DoPreview;
begin
  if not FEnabled then Exit;

  Assert(Assigned(FPreview), 'Callback not assigned');
  Screen.Cursor := crHourGlass;
  try
    with FBitmap do
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(Rect(0, 0, Width, Height));
    end;

    FPreview(
      FBitmap.Canvas,
      GetPosition,
      GetFitMode,
      GetFitSize,
      GetMargins,
      GetGamma,
      GetFooter);

    V.LoadBitmap(FBitmap, False);
    V.Image.Resample := True;
    V.ImageFitToWindow := True;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormATPreview.FormCreate(Sender: TObject);
var
  i: TATPrintFitMode;
begin
  Font.Name := MsgPreviewDlgFontName;
  Font.Size := MsgPreviewDlgFontSize;

  Caption := MsgPreviewDlgCaption;
  btnPrintSetup.Caption := MsgPreviewDlgPrintSetup;
  btnOK.Caption := MsgPreviewDlgPrint;
  btnCancel.Caption := MsgPreviewDlgCancel;
  boxOptions.Caption := MsgPreviewDlgOptions;
  boxPosition.Caption := MsgPreviewDlgPosition;

  boxMargins.Caption := MsgPreviewDlgMargins;
  labMarginLeft.Caption := MsgPreviewDlgMarginLeft;
  labMarginTop.Caption := MsgPreviewDlgMarginTop;
  labMarginRight.Caption := MsgPreviewDlgMarginRight;
  labMarginBottom.Caption := MsgPreviewDlgMarginBottom;

  boxGamma.Caption := MsgPreviewDlgGamma;
  labGamma.Caption := MsgPreviewDlgOptGamma;

  boxPreview.Caption := MsgPreviewDlgPreview;
  labFit.Caption := MsgPreviewDlgOptFitMode;
  labSizeX.Caption := MsgPreviewDlgOptFitSizeX;
  labSizeY.Caption := MsgPreviewDlgOptFitSizeY;
  chkFitProp.Caption := MsgPreviewDlgOptFitSizeProp;
  chkFooter.Caption := MsgPreviewDlgOptFooter;
  btnFont.Caption := MsgPreviewDlgOptFooterFont;

  with edFit.Items do
  begin
    BeginUpdate;
    Clear;
    for i := Low(TATPrintFitMode) to High(TATPrintFitMode) do
      Add(MsgPreviewDlgFitModes[i]);
    EndUpdate;
  end;

  btnPos1.Hint := MsgPreviewDlgPos[pPosTopLeft];
  btnPos2.Hint := MsgPreviewDlgPos[pPosTop];
  btnPos3.Hint := MsgPreviewDlgPos[pPosTopRight];
  btnPos4.Hint := MsgPreviewDlgPos[pPosLeft];
  btnPos5.Hint := MsgPreviewDlgPos[pPosCenter];
  btnPos6.Hint := MsgPreviewDlgPos[pPosRight];
  btnPos7.Hint := MsgPreviewDlgPos[pPosBottomLeft];
  btnPos8.Hint := MsgPreviewDlgPos[pPosBottom];
  btnPos9.Hint := MsgPreviewDlgPos[pPosBottomRight];

  FBitmap := TBitmap.Create;
  with FBitmap do
  begin
    PixelFormat := pf24bit;
    Width := 100;
    Height := 100;
  end;

  with edGamma do
  begin
    Min := 0.1;
    Max := 7.0;
    Inc := 0.1;
  end;

  FPreview := nil;
  FFitting := False;
  FEnabled := False;
end;

procedure TFormATPreview.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
end;

procedure TFormATPreview.FormShow(Sender: TObject);
begin
  FitChange;
  FEnabled := True;
  DoPreview;
end;

//-------------------------------------------------------------------
// Helper class to implement callback function for preview form
type
  TATImagePreviewHelper = class
  public
    FBitmap: TBitmap;
    FOptUnit: TATPrintUnit;
    FPixelsPerInch: Integer;
    procedure Callback(
      ACanvas: TCanvas;
      AOptPosition: TATPrintPosition;
      AOptFit: TATPrintFitMode;
      AOptFitSize: TFloatSize;
      const AOptMargins: TFloatRect;
      const AOptGamma: Double;
      const AOptFooter: TATPrintFooter);
  end;

procedure TATImagePreviewHelper.Callback;
begin
  BitmapPrintAction(
    FBitmap,
    ACanvas,
    PreviewPageWidth(FPixelsPerInch), //ATargetWidth
    PreviewPageHeight(FPixelsPerInch), //ATargetHeight
    FPixelsPerInch, //ATargetPPIX
    FPixelsPerInch, //ATargetPPIY
    AOptFit,
    AOptFitSize,
    AOptPosition,
    AOptMargins,
    FOptUnit,
    AOptGamma,
    AOptFooter,
    True, //AOptPreviewMode
    FPixelsPerInch);
end;

//-------------------------------------------------------------------
function BitmapPreview(
  ABitmap: TBitmap;
  var AOptions: TATPrintOptions): Boolean;
begin
  with TATImagePreviewHelper.Create do
    try
      FBitmap := ABitmap;
      FOptUnit := AOptions.OptUnit;
      FPixelsPerInch := AOptions.PixelsPerInch;
      Result := ShowImagePreviewDialog(
        Callback,
        AOptions,
        ABitmap.Width,
        ABitmap.Height);
    finally
      Free;
    end;
end;


//-------------------------------------------------------------------
function PreviewPageWidth(APixelsPerInch: Integer): Integer;
begin
  Result := Trunc(Printer.PageWidth / (GetDeviceCaps(Printer.Handle, LOGPIXELSX) / APixelsPerInch));
end;

function PreviewPageHeight(APixelsPerInch: Integer): Integer;
begin
  Result := Trunc(Printer.PageHeight / (GetDeviceCaps(Printer.Handle, LOGPIXELSY) / APixelsPerInch));
end;


//-------------------------------------------------------------------
function TFormATPreview.InitBitmap: Boolean;
begin
  try
    FBitmap.Width := PreviewPageWidth(Screen.PixelsPerInch);
    FBitmap.Height := PreviewPageHeight(Screen.PixelsPerInch);
    Result := True;
  except
    Application.MessageBox(
      PChar(MsgPreviewDlgCannotAllocateMemory),
      PChar(MsgPreviewDlgCaption),
      MB_OK or MB_ICONERROR);
    Result := False;
  end;
end;

//-------------------------------------------------------------------
procedure TFormATPreview.btnPrintSetupClick(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then
  begin
    InitBitmap;
    DoPreview;
  end;
end;

//-------------------------------------------------------------------
procedure TFormATPreview.btnPos1Click(Sender: TObject);
begin
  DoPreview;
end;

procedure TFormATPreview.edMarginTopChange(Sender: TObject);
begin
  DoPreview;
end;

procedure TFormATPreview.FitChange;
var
  En: Boolean;
begin
  En := GetFitMode = pFitSize;
  edSizeX.Enabled := En;
  edSizeY.Enabled := En;
  labSizeX.Enabled := En;
  labSizeY.Enabled := En;
  labMm1.Enabled := En;
  labMm2.Enabled := En;
  chkFitProp.Enabled := En;
end;

procedure TFormATPreview.edFitChange(Sender: TObject);
begin
  FitChange;
  DoPreview;
end;

procedure TFormATPreview.FitSizeY;
begin
  edSizeY.Value :=
    edSizeX.Value / FBitmapSizeX * FBitmapSizeY;
end;

procedure TFormATPreview.FitSizeX;
begin
  edSizeX.Value :=
    edSizeY.Value / FBitmapSizeY * FBitmapSizeX;
end;

procedure TFormATPreview.edSizeXChange(Sender: TObject);
begin
  if FFitting then Exit;

  if chkFitProp.Checked then
  try
    FFitting := True;
    FitSizeY;
  finally  
    FFitting := False;
  end;

  DoPreview;
end;

procedure TFormATPreview.edSizeYChange(Sender: TObject);
begin
  if FFitting then Exit;

  if chkFitProp.Checked then
  try
    FFitting := True;
    FitSizeX;
  finally
    FFitting := False;
  end;
    
  DoPreview;
end;

procedure TFormATPreview.chkFitPropClick(Sender: TObject);
begin
  if chkFitProp.Checked then
    FitSizeY;
end;

procedure TFormATPreview.btnFontClick(Sender: TObject);
begin
  if FontDialog1.Execute then
    DoPreview;
end;

procedure TFormATPreview.chkFooterClick(Sender: TObject);
begin
  FooterChange;
  DoPreview;
end;

procedure TFormATPreview.FooterChange;
begin
  btnFont.Enabled := chkFooter.Checked;
end;

initialization

  //Use the BitmapPreview code:
  ATxPrintProc.ATBitmapPreview := BitmapPreview;


end.
