unit ATImage;

interface

uses
  Windows, Messages, Classes, Controls, Graphics,
  ExtCtrls,
  FBits, FTrack;


//These are global flags (for all images)
var
  FMapImagesStop: Boolean = False; //Disables drawing during dragging
  FMapImagesResample: Boolean = True; //Enables resampling on drawing


type
  TATImageEx = class(TGraphicControl)
  private
    FBitmap: TBitmap;
    FTimer: TTimer;

    FBitsObject: TBitsObject;
    FXOffset: Integer;
    FYOffset: Integer;
    FScale: Extended;

    procedure TimerTimer(Sender: TOBject);
    procedure PaintResampled;
    procedure PaintBitmaps(LastOnly: Boolean = False);

  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateObj(AOwner: TComponent; ABitsObject: TBitsObject);
      //Creates object with Bits object attached
    destructor Destroy; override;
    procedure PaintLast;
    procedure LoadFromFile(const fn: string);

    function ImageWidth: integer;
    function ImageHeight: integer;
    property XOffset: Integer read FXOffset write FXOffset;
    property YOffset: Integer read FYOffset write FYOffset;
    property Scale: Extended read FScale write FScale;

  published
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
  end;

function IMax(N1, N2: Integer): Integer;
function IMin(N1, N2: Integer): Integer;


implementation

uses
  SysUtils, Jpeg;


{ TATImageEx }

constructor TATImageEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 20;
  Height := 20;                                
end;


constructor TATImageEx.CreateObj(AOwner: TComponent; ABitsObject: TBitsObject);
begin
  Create(AOwner);

  FBitsObject := ABitsObject;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf24bit;
  FBitmap.Width := 20;
  FBitmap.Height := 20;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 500;
  FTimer.OnTimer := TimerTimer;
  FTimer.Enabled := False;

  FXOffset := 0;
  FYOffset := 0;
  FScale := 1.0;
end;


destructor TATImageEx.Destroy;
begin
  FTimer.Enabled := False;
  FreeAndNil(FTimer);

  FreeAndNil(FBitmap);

  inherited;
end;


procedure TATImageEx.Paint;
begin
  if FMapImagesStop then 
  begin
    inherited Canvas.Brush.Color := clWhite;
    inherited Canvas.FillRect(ClientRect);
    Exit;
  end;

  with inherited Canvas do
    StretchDraw(ClientRect, FBitmap);

  PaintBitmaps;

  if FMapImagesResample then
  begin
    FTimer.Enabled := False;
    FTimer.Enabled := True;
  end;
end;


procedure TATImageEx.TimerTimer;
begin
  FTimer.Enabled := False;
  PaintResampled;
end;


procedure TATImageEx.PaintResampled;
begin
  with inherited Canvas do
  begin
    SetStretchBltMode(Handle, STRETCH_HALFTONE);
    SetBrushOrgEx(Handle, 0, 0, nil);
    StretchBlt(
      Handle, 0, 0, ClientWidth, ClientHeight,
      FBitmap.Canvas.Handle, 0, 0, FBitmap.Width, FBitmap.Height, SRCCOPY);
  end;

  PaintBitmaps;
end;


procedure TATImageEx.PaintLast;
begin
  PaintBitmaps(True);
end;


//---------------------------
function IMax(N1, N2: Integer): Integer;
begin
  if N1 >= N2 then
    Result := N1
  else
    Result := N2;
end;

function IMin(N1, N2: Integer): Integer;
begin
  if N1 <= N2 then
    Result := N1
  else
    Result := N2;
end;


//---------------------------
procedure TATImageEx.PaintBitmaps;
var
  i, iFrom, n: Integer;
  XX1, YY1, XX2, YY2: Integer;
  TextX, TextY: Integer;
  Bitmap: TBitmap;
  IL: TImageList;
  ACanvas: TCanvas;
  DestRect: TRect;
begin
  ACanvas := inherited Canvas;
  DestRect := ClientRect;

  if LastOnly then
    iFrom := IMax(fBitsobject.FBitsCount - 1, 0)
  else
    iFrom := 0;

  //Draw tracks first
  for i := iFrom to fBitsobject.FBitsCount - 1 do
    with fBitsobject.FBits[i] do
    begin
      if Typ = bbTrack then
        begin
          Assert(Assigned(Data), 'Track not assigned');

          ACanvas.Pen.Style := psSolid;
          ACanvas.Pen.Color := Color;
          ACanvas.Pen.Width := Size;
          ACanvas.Brush.Style := bsClear;
          ACanvas.Brush.Color := Color;

          with TTrackInfo(Data) do
            if FCount > 0 then
            begin
              for n := 0 to FCount - 1 do
              begin
                XX1 := -XOffset + Trunc((FData[n].X) * FScale);
                YY1 := -YOffset + Trunc((FData[n].Y) * FScale);

                //Line
                if n > 0 then
                  ACanvas.LineTo(XX1, YY1);
                ACanvas.MoveTo(XX1, YY1);

                //Dot
                ACanvas.Pen.Width := 1;
                ACanvas.Pie(
                  XX1 - Size2, YY1 - Size2,
                  XX1 + Size2, YY1 + Size2, 0, 0, 0, 0);
                ACanvas.Pen.Width := Size;
              end;
            end;
        end;
    end;

  //Other
  for i := iFrom to FBitsObject.FBitsCount - 1 do
    with FBitsObject.FBits[i] do
    begin
      XX1 := -XOffset + Trunc((X1) * FScale);
      YY1 := -YOffset + Trunc((Y1) * FScale);
      XX2 := -XOffset + Trunc((X2) * FScale);
      YY2 := -YOffset + Trunc((Y2) * FScale);

      case Typ of
        bbBitmap:
        begin
          Bitmap := TBitmap(Data);
          Assert(Assigned(Bitmap), 'Bitmap not assigned');
          ACanvas.Draw(
            XX1 - Bitmap.Width div 2,
            YY1 - Bitmap.Height div 2,
            TBitmap(Data));
        end;
        bbILIcon:
        begin
          IL := TImageList(Data);
          Assert(Assigned(IL), 'Imagelist not assigned');
          IL.Draw(ACanvas,
            XX1 - IL.Width div 2,
            YY1 - IL.Height div 2,
            Integer(Color));
        end;
        bbLine:
        begin
          ACanvas.Pen.Style := psSolid;
          ACanvas.Pen.Color := Color;
          ACanvas.Pen.Width := Size;
          ACanvas.MoveTo(XX1, YY1);
          ACanvas.LineTo(XX2, YY2);
        end;
        bbOval:
        begin
          ACanvas.Brush.Style := bsClear;
          ACanvas.Pen.Style := psSolid;
          ACanvas.Pen.Color := Color;
          ACanvas.Pen.Width := Size;
          ACanvas.Ellipse(XX1, YY1, XX2, YY2);
        end;
        bbPoint:
        begin
          ACanvas.Brush.Style := bsClear;
          ACanvas.Brush.Color := Color;
          ACanvas.Pen.Style := psSolid;
          ACanvas.Pen.Color := Color;
          ACanvas.Pen.Width := 1;
          ACanvas.Pie(
            XX1 - Size, YY1 - Size,
            XX1 + Size, YY1 + Size, 0, 0, 0, 0);
        end;
        bbLabel:
        begin
          ACanvas.Brush.Style := bsClear;
          ACanvas.Brush.Color := Color2;

          ACanvas.Font.Color := Color;
          ACanvas.Font.Name := Font;
          ACanvas.Font.Size := Size;
          ACanvas.Font.Style := Style;

          TextX := XX1 + cBitTextOff;
          TextY := YY1 - ACanvas.TextHeight(Text) div 2;
          ACanvas.FillRect(Rect(TextX, TextY, TextX + ACanvas.TextWidth(Text), TextY + ACanvas.TextHeight(Text)));
          ACanvas.TextOut(TextX, TextY, Text);
        end;
      end;
    end;
end;


//---------------------------
function TATImageEx.ImageWidth: integer;
begin
  if Assigned(FBitmap) then
    Result := FBitmap.Width
  else
    Result := 0;
end;

function TATImageEx.ImageHeight: integer;
begin
  if Assigned(FBitmap) then
    Result := FBitmap.Height
  else
    Result := 0;  
end;

//---------------------------
procedure TATImageEx.LoadFromFile(const fn: string);
var
  j: TJpegImage;
begin
  j := TJpegImage.Create;
  try
    try
      j.LoadFromFile(fn);
      FBitmap.Assign(j);
    finally
      j.Free;
    end;
  except
    raise Exception.Create('Cannot load image: "'+ fn + '"');
  end;
end;


end.
