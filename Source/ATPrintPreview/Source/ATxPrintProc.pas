{************************************************}
{                                                }
{  ATPrintPreview- printing procedures           }
{  Copyright (C) Alexey Torgashin                }
{  http://uvviewsoft.com                         }
{                                                }
{************************************************}
{$I _Print.inc}

unit ATxPrintProc;

interface

uses
  Windows, Graphics, ExtCtrls;

type
  TATPrintFitMode = (
    pFitNormal,
    pFitBest,
    pFitStretch,
    pFitSize
    );

  TATPrintPosition = (
    pPosTopLeft,
    pPosTop,
    pPosTopRight,
    pPosLeft,
    pPosCenter,
    pPosRight,
    pPosBottomLeft,
    pPosBottom,
    pPosBottomRight
    );

  TATPrintUnit = (
    pUnitMm,
    pUnitCm,
    pUnitIn
    );

const
  cUnitIn: array[TATPrintUnit] of Double =
    (2.54 * 10, 2.54, 1);

type
  TFloatRect = record
    Left, Top, Right, Bottom: Double;
  end;

  TFloatSize = record
    X, Y: Double;
  end;

  TATPrintFooter = record
    Enabled: Boolean;
    EnableLine: Boolean;
    Caption: WideString;
    FontName: TFontName;
    FontSize: Integer;
    FontStyle: TFontStyles;
    FontColor: TColor;
    FontCharset: TFontCharset;
  end;

type
  TATPrintOptions = record
    Copies: Integer;
    OptFit: TATPrintFitMode;
    OptFitSize: TFloatSize;
    OptPosition: TATPrintPosition;
    OptMargins: TFloatRect;
    OptUnit: TATPrintUnit;
    OptGamma: Double;
    OptFooter: TATPrintFooter;
    PixelsPerInch: Integer;
    JobCaption: string;
    FailOnErrors,
    NoPreview: Boolean;
  end;

function BitmapPrint(
  ABitmap: TBitmap;
  var AOptions: TATPrintOptions): Boolean;

function BitmapPrintAction(
  ABitmap: TBitmap;
  ATargetCanvas: TCanvas;
  ATargetWidth, ATargetHeight: Integer;
  ATargetPPIX, ATargetPPIY: Integer;
  AOptFit: TATPrintFitMode;
  AOptFitSize: TFloatSize;
  AOptPosition: TATPrintPosition;
  const AOptMargins: TFloatRect;
  AOptUnit: TATPrintUnit;
  const AOptGamma: Double;
  const AOptFooter: TATPrintFooter;
  AOptPreviewMode: Boolean;
  APixelsPerInch: Integer): Boolean;

function PicturePrint(
  APicture: TPicture;
  var AOptions: TATPrintOptions): Boolean;

function ImagePrint(
  AImage: TImage;
  var AOptions: TATPrintOptions): Boolean;

type
  TATBitmapPreviewProc = function(
    ABitmap: TBitmap;
    var AOptions: TATPrintOptions): Boolean;

var
  ATBitmapPreview: TATBitmapPreviewProc = nil;


implementation

uses
  SysUtils, Classes, Jpeg, Printers, Forms;

//------------------------------------------------------------------------------
function ImagePrint(
  AImage: TImage;
  var AOptions: TATPrintOptions): Boolean;
begin
  Assert(Assigned(AImage), 'Image not assigned');
  Result := PicturePrint(AImage.Picture, AOptions);
end;

//------------------------------------------------------------------------------
function PicturePrint(
  APicture: TPicture;
  var AOptions: TATPrintOptions): Boolean;
var
  bmp: TBitmap;
begin
  if not Assigned(APicture.Graphic) then
  begin
    Result := False;
    Exit
  end;

  bmp := TBitmap.Create;
  try
    with APicture do
    begin
      bmp.PixelFormat := pf24bit;
      bmp.Width := Graphic.Width;
      bmp.Height := Graphic.Height;
      bmp.Canvas.Draw(0, 0, Graphic);
    end;

    Result := BitmapPrint(bmp, AOptions);
  finally
    bmp.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure ValidateRect(var R: TRect);
const
  cMinRectSize = 4; //px
begin
  with R do
  begin
    if Right < Left then Right := Left + cMinRectSize;
    if Bottom < Top then Bottom := Top + cMinRectSize;
  end;
end;

//------------------------------------------------------------------------------
// Original copyright: Fedorovskih Nikolay
// Date: 5 Jun 2002
//
procedure BitmapGamma(Bitmap: TBitmap; L: Double);
  function Power(Base, Exponent: Double): Double;
  begin
    Result := Exp(Exponent * Ln(Base));
  end;
type
  TRGB = record
    B, G, R: Byte;
  end;
  pRGB = ^TRGB;
var
  Dest: pRGB;
  X, Y: Word;
  GT: array[0..255] of Byte;
begin
  //Added
  Assert(Assigned(Bitmap), 'Bitmap not assigned');
  Assert(Bitmap.PixelFormat = pf24Bit, 'Bitmap format incorrect');

  //Added
  if L < 0.01 then L := 0.01;
  if L > 7.0 then L := 7.0;

  GT[0] := 0;
  for X := 1 to 255 do
    GT[X] := Round(255 * Power(X / 255, 1 / L));

  for Y := 0 to Bitmap.Height - 1 do
  begin
    Dest := Bitmap.ScanLine[y];
    for X := 0 to Bitmap.Width - 1 do
    begin
      with Dest^ do
      begin
        R := GT[R];
        G := GT[G];
        B := GT[B];
      end;
      Inc(Dest);
    end;
  end;
end;

//------------------------------------------------------------------------------
function FloatRect(
  const Left, Top, Right, Bottom: Double): TFloatRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

//------------------------------------------------------------------------------
function PreviewMarginsRect(
  ATargetWidth,
  ATargetHeight: Integer;
  ATargetPPIX,
  ATargetPPIY: Integer;
  const AOptMargins: TFloatRect;
  AOptUnit: TATPrintUnit): TRect;
begin
  Result := Rect(
    Trunc(AOptMargins.Left / cUnitIn[AOptUnit] * ATargetPPIX),
    Trunc(AOptMargins.Top / cUnitIn[AOptUnit] * ATargetPPIY),
    ATargetWidth - Trunc(AOptMargins.Right / cUnitIn[AOptUnit] * ATargetPPIX),
    ATargetHeight - Trunc(AOptMargins.Bottom / cUnitIn[AOptUnit] * ATargetPPIY)
    );
  ValidateRect(Result);
end;

//------------------------------------------------------------------------------
function FontHeight(ACanvas: TCanvas): Integer;
var
  Metric: TTextMetric;
begin
  if GetTextMetrics(ACanvas.Handle, Metric) then
    Result := Metric.tmHeight
  else
    Result := Abs(ACanvas.Font.Height);
end;

//------------------------------------------------------------------------------
procedure STextOut(C: TCanvas; X, Y: Integer; const S: WideString);
begin
  TextOutW(C.Handle, X, Y, PWChar(S), Length(S));
end;


//------------------------------------------------------------------------------
function BitmapPrintAction(
  ABitmap: TBitmap;
  ATargetCanvas: TCanvas;
  ATargetWidth, ATargetHeight: Integer;
  ATargetPPIX, ATargetPPIY: Integer;
  AOptFit: TATPrintFitMode;
  AOptFitSize: TFloatSize;
  AOptPosition: TATPrintPosition;
  const AOptMargins: TFloatRect;
  AOptUnit: TATPrintUnit;
  const AOptGamma: Double;
  const AOptFooter: TATPrintFooter;
  AOptPreviewMode: Boolean;
  APixelsPerInch: Integer): Boolean;
  //
  function FooterHeightSrc: Integer;
  var
    b: TBitmap;
  begin
    b := TBitmap.Create;
    b.Width := 10;
    b.Height := 10;
    with b.Canvas do
    try
      Font.Name := AOptFooter.FontName;
      Font.Size := AOptFooter.FontSize;
      Font.Style := AOptFooter.FontStyle;
      Font.Charset := AOptFooter.FontCharset;
      Result := Trunc(FontHeight(b.Canvas) * 1.2);
    finally
      b.Free;
    end;
  end;
  //
  function FooterOffset: Integer;
  begin
    Result := AOptFooter.FontSize div 2;
  end;
  //
var
  Bitmap2: TBitmap;
  UseBitmap2: Boolean;
  Scale, ScalePX, ScalePY,
  ScaleX, ScaleY: Double;
  AvailWidth, AvailHeight,
  RectSizeX, RectSizeY,
  RectOffsetX, RectOffsetY: Integer;
  XLine, YLine,
  XText, YText: Integer;
  AvailRect,
  MarginsRect: TRect;
begin
  Result := True;

  ScalePX := ATargetPPIX / APixelsPerInch;
  ScalePY := ATargetPPIY / APixelsPerInch;

  //Calc margins
  MarginsRect := PreviewMarginsRect(
    ATargetWidth,
    ATargetHeight,
    ATargetPPIX,
    ATargetPPIY,
    AOptMargins,
    AOptUnit);

  //Calc avalilable rect (margins minus footer)
  AvailRect := MarginsRect;
  if AOptFooter.Enabled then
    Dec(AvailRect.Bottom, Trunc(FooterHeightSrc * ScalePY));
  ValidateRect(AvailRect);

  with AvailRect do
  begin
    AvailWidth := Right - Left;
    AvailHeight := Bottom - Top;
  end;

  case AOptFit of
  pFitStretch:
    begin
      RectSizeX := AvailWidth;
      RectSizeY := AvailHeight;
      RectOffsetX := 0;
      RectOffsetY := 0;
    end;
  else
    begin
      if (AOptFit = pFitSize) then
      begin
        RectSizeX := Trunc(AOptFitSize.X / cUnitIn[AOptUnit] * ATargetPPIX);
        RectSizeY := Trunc(AOptFitSize.Y / cUnitIn[AOptUnit] * ATargetPPIY);
      end
      else
      begin
        ScaleX := AvailWidth / ABitmap.Width / ScalePX;
        ScaleY := AvailHeight / ABitmap.Height / ScalePY;

        if ScaleX < ScaleY then
          Scale := ScaleX
        else
          Scale := ScaleY;

        if (AOptFit = pFitNormal) and (Scale > 1.0) then
          Scale := 1.0;

        RectSizeX := Trunc(ABitmap.Width * Scale * ScalePX);
        RectSizeY := Trunc(ABitmap.Height * Scale * ScalePY);
      end;

      case AOptPosition of
        pPosTopLeft:
          begin
            RectOffsetX := 0;
            RectOffsetY := 0;
          end;
        pPosTop:
          begin
            RectOffsetX := (AvailWidth - RectSizeX) div 2;
            RectOffsetY := 0;
          end;
        pPosTopRight:
          begin
            RectOffsetX := (AvailWidth - RectSizeX);
            RectOffsetY := 0;
          end;
        pPosLeft:
          begin
            RectOffsetX := 0;
            RectOffsetY := (AvailHeight - RectSizeY) div 2;
          end;
        pPosCenter:
          begin
            RectOffsetX := (AvailWidth - RectSizeX) div 2;
            RectOffsetY := (AvailHeight - RectSizeY) div 2;
          end;
        pPosRight:
          begin
            RectOffsetX := (AvailWidth - RectSizeX);
            RectOffsetY := (AvailHeight - RectSizeY) div 2;
          end;
        pPosBottomLeft:
          begin
            RectOffsetX := 0;
            RectOffsetY := (AvailHeight - RectSizeY);
          end;
        pPosBottom:
          begin
            RectOffsetX := (AvailWidth - RectSizeX) div 2;
            RectOffsetY := (AvailHeight - RectSizeY);
          end;
        else
          begin
            RectOffsetX := (AvailWidth - RectSizeX);
            RectOffsetY := (AvailHeight - RectSizeY);
          end;
      end;
    end;
  end; //case AOptFit

  //Apply gamma
  UseBitmap2 := AOptGamma <> 1.0;
  if UseBitmap2 then
  begin
    Bitmap2 := TBitmap.Create;
    Bitmap2.PixelFormat := pf24bit;
    try
      Bitmap2.Assign(ABitmap);
      BitmapGamma(Bitmap2, AOptGamma);
    except
      Application.MessageBox('Cannot allocate gamma bitmap', 'Error', MB_OK or MB_ICONERROR);
      UseBitmap2 := False;
      FreeAndNil(Bitmap2);
      Bitmap2 := ABitmap;
    end;
  end
  else
    Bitmap2 := ABitmap;

  try
    //Draw bitmap
    ATargetCanvas.StretchDraw(
      Rect(
        MarginsRect.Left + RectOffsetX,
        MarginsRect.Top + RectOffsetY,
        MarginsRect.Left + RectOffsetX + RectSizeX,
        MarginsRect.Top + RectOffsetY + RectSizeY),
      Bitmap2);

    //Draw footer
    if AOptFooter.Enabled then
    begin
      XLine := Trunc(FooterOffset * ScalePX);
      YLine := AvailHeight;
      YText := YLine + Trunc(2 * ScalePY);

      if AOptFooter.EnableLine then
      begin
        ATargetCanvas.Brush.Color := clWhite;
        ATargetCanvas.Pen.Color := clBlack;
        ATargetCanvas.Pen.Style := psSolid;
        ATargetCanvas.MoveTo(MarginsRect.Left + XLine, MarginsRect.Top + YLine);
        ATargetCanvas.LineTo(MarginsRect.Left + AvailWidth - XLine, MarginsRect.Top + YLine);
      end;

      ATargetCanvas.Font.Name := AOptFooter.FontName;
      ATargetCanvas.Font.Size := AOptFooter.FontSize;
      ATargetCanvas.Font.Style := AOptFooter.FontStyle;
      ATargetCanvas.Font.Color := AOptFooter.FontColor;
      ATargetCanvas.Font.Charset := AOptFooter.FontCharset;

      XText := (AvailWidth - ATargetCanvas.TextWidth(AOptFooter.Caption)) div 2;
      if XText < 0 then
        XText := 0;

      STextOut(ATargetCanvas,
        MarginsRect.Left + XText,
        MarginsRect.Top + YText,
        AOptFooter.Caption);
    end;

    //Draw empty space
    ATargetCanvas.Brush.Color := clWhite;
    ATargetCanvas.FillRect(Rect(0, 0, ATargetWidth + 1, MarginsRect.Top));
    ATargetCanvas.FillRect(Rect(0, 0, MarginsRect.Left, ATargetHeight + 1));
    ATargetCanvas.FillRect(Rect(0, MarginsRect.Bottom + 1, ATargetWidth + 1, ATargetHeight + 1));
    ATargetCanvas.FillRect(Rect(MarginsRect.Right + 1, 0, ATargetWidth + 1, ATargetHeight + 1));

    //Draw margins
    if AOptPreviewMode then
    begin
      ATargetCanvas.Brush.Style := bsClear;
      ATargetCanvas.Pen.Color := clBlack;
      ATargetCanvas.Pen.Style := psDash;
      ATargetCanvas.Rectangle(MarginsRect);
    end;

  except
    Result := False;
  end;

  if UseBitmap2 then
    FreeAndNil(Bitmap2);
end;

//------------------------------------------------------------------------------
{$I _Print2.inc}

function BitmapPrint(
  ABitmap: TBitmap;
  var AOptions: TATPrintOptions): Boolean;
begin
  Result := False;
  Assert(
    Assigned(ABitmap) and (ABitmap.Width > 0) and (ABitmap.Height > 0),
    'BitmapPrint: bitmap is empty.');

  //Preview code
  if not AOptions.NoPreview then
  begin
    if Assigned(ATBitmapPreview) then
    begin
      if not ATBitmapPreview(ABitmap, AOptions) then Exit;
    end
    else
    begin
      if AOptions.FailOnErrors then Exit;
    end;
  end;
  //end of preview code

  try
    if AOptions.Copies <= 0 then
      AOptions.Copies := 1;
    Printer.Title := AOptions.JobCaption;
    Printer.Copies := AOptions.Copies;
    Printer.BeginDoc;
    try
      Result := BitmapPrintAction(
        ABitmap,
        Printer.Canvas,
        Printer.PageWidth,
        Printer.PageHeight,
        GetDeviceCaps(Printer.Handle, LOGPIXELSX),
        GetDeviceCaps(Printer.Handle, LOGPIXELSY),
        AOptions.OptFit,
        AOptions.OptFitSize,
        AOptions.OptPosition,
        AOptions.OptMargins,
        AOptions.OptUnit,
        AOptions.OptGamma,
        AOptions.OptFooter,
        False, //AOptPreviewMode
        AOptions.PixelsPerInch
        );
    finally
      Printer.EndDoc;
    end;
  except
    Result := False;
  end;
end;

end.
