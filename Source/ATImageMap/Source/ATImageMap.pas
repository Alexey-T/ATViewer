{*********************************************}
{                                             }
{ ATImageMap component                        }
{ Copyright (c) 2008 Alexey Torgashin         }
{ http://atorg.net.ru                         }
{                                             }
{*********************************************}

{$BOOLEVAL OFF} //Short bool evaluation
//Note: define "TEST" will draw test grid

unit ATImageMap;

interface

uses
  Windows, Messages, Classes, Controls, Graphics,
  StdCtrls, ExtCtrls, Dialogs,
  Forms, FBits, ATImage;

{ Constants }
const
  cATMaxImagesX = 10 * 1000; //Max parts on X, Y
  cATMaxImages = 100 * 1000; //Max parts total
  cATMinScale = 0.0;    //Min scale
  cATMaxScale = 1000.0; //Max scale

type
  PATImageRec = ^TATImageRec;
  TATImageRec = record
    Image: TATImageEx;
    Shown: Boolean;
  end;

  PATImageArray = ^TATImageArray;
  TATImageArray = array[0 .. Pred(cATMaxImages)] of TATImageRec;

type
  TImageBoxIndexShow = procedure(Sender: TObject; AI, AJ: Integer; AValue: Boolean) of object;

type
  TATImageMap = class(TScrollBox)
  private
    FImageW: Integer; //Tested with 250x190
    FImageH: Integer;
    FImage: PATImageArray;
    FPanel: TPaintBox;
    FFocusable: Boolean;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FImageScale: Extended;
    FImageKeepPosition: Boolean;
    FImageDrag: Boolean;
    FImageDragCursor: TCursor;
    FImageDragging: Boolean;
    FImageDraggingPoint: TPoint;
    FOnScroll: TNotifyEvent;
    FOnOptionsChange: TNotifyEvent;
    FOnIndexShow: TImageBoxIndexShow;
    FBitsObject: TBitsObject;

    //FX: Integer;
    //FY: Integer;
    //procedure SavePosition;
    //procedure RestorePosition;

    procedure DoScroll;
    procedure DoOptionsChange;
    procedure DoIndexShow(AI, AJ: Integer; AValue: Boolean);

    procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);

    procedure UpdateImage(I, J: Integer);
    procedure UpdateImagePosition(AKeep: Boolean = False);
    procedure UpdateImageShown;

    procedure SetImageScale(AValue: Extended);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParts(APartsX, APartsY: Integer);
    procedure CreateImage(I, J: Integer);

    function GetImage(X, Y: Integer): PATImageRec;
    procedure IncreaseImageScale(AIncrement: Boolean);
    property ImageWidth: Integer read FImageWidth;
    property ImageHeight: Integer read FImageHeight;
    property ImageScale: Extended read FImageScale write SetImageScale;
    property Panel: TPaintBox read FPanel;

    //Bits code
    function AddBit(const Info: TBitInfo; Redraw: Boolean = True): Integer;
    function GetBit(Id: Integer; var Info: TBitInfo; Scaled: Boolean = True): Boolean;
    function DeleteBit(Id: Integer; Redraw: Boolean = True): Boolean;
    function SetBit(Id: Integer; const Info: TBitInfo; InfoSet: TBitInfoSet; Redraw: Boolean = True): Boolean;
    function AddTrackItem(Id: Integer; P: TPoint; Redraw: Boolean = True): Boolean;
    function BitsCount: Integer;
    property BitsObject: TBitsObject read FBitsObject;

    //Indexes code
    procedure PanelPaint(Sender: TObject);
    function ShowRect(I, J: Integer): TRect;
    function IndexRect(I, J: Integer): TRect;

    procedure PaintIndexes(LastOnly: Boolean = False);
    procedure LoadIndexFromFile(I, J: Integer; const FN: string);
    procedure FreeIndex(I, J: Integer);
    procedure PositionToIndex(I, J: Integer; center: boolean = false);
    function IsIndexLoaded(I, J: Integer): Boolean;
    function IsIndexShown(I, J: Integer): Boolean;

  protected
    procedure WMHScroll(var Msg: TMessage); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TMessage); message WM_VSCROLL;
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

  published
    property Focusable: Boolean read FFocusable write FFocusable default True;
    property ImageKeepPosition: Boolean read FImageKeepPosition write FImageKeepPosition default True;
    property ImageDrag: Boolean read FImageDrag write FImageDrag default True;
    property ImageDragCursor: TCursor read FImageDragCursor write FImageDragCursor default crSizeAll;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnOptionsChange: TNotifyEvent read FOnOptionsChange write FOnOptionsChange;
    property OnIndexShow: TImageBoxIndexShow read FOnIndexShow write FOnIndexShow;
  end;

procedure FixIcon(AIcon: TIcon);
function FixPictureFormat(APicture: TPicture; ABackColor: TColor): Boolean;

procedure Register;


//-----------------------------------------------------------------
implementation

uses
  SysUtils, FTrack;


{ Constants }

const
  cImageLineSize = 50; //Line size: pixels to scroll by arrows and mouse sheel
  cImageGapSize = 20; //Gap size: PgUp/PgDn/Home/End scroll by control size minus gap size

{ Helper functions }

procedure FixIcon(AIcon: TIcon);
var
  Bmp: TBitmap;
begin
  try
    Bmp := TBitmap.Create;
    try
      Bmp.PixelFormat := pf24bit;
      Bmp.Canvas.Draw(0, 0, AIcon);
    finally
      Bmp.Free;
    end;
  except
  end;
end;

{
Scaling doesn't work with icons. So, we need to convert icon to a bitmap,
preferrably with PixelFormat = pf24bit.
}
function FixPictureFormat(APicture: TPicture; ABackColor: TColor): Boolean;
var
  bmp: TBitmap;
begin
  Result := True;
  with APicture do
    if (not (Graphic is TBitmap)) or ((TBitmap(Graphic).PixelFormat <> pf24Bit)) then
      try
        bmp := TBitmap.Create;
        try
          bmp.PixelFormat := pf24bit;
          bmp.Width := Graphic.Width;
          bmp.Height := Graphic.Height;
          bmp.Canvas.Brush.Color:= ABackColor;
          bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
          bmp.Canvas.Draw(0, 0, Graphic);
          APicture.Graphic := bmp;
        finally
          bmp.Free;
        end;
      except
        Result := False;
      end;
end;


{ TATImageMap }

constructor TATImageMap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //Create initial parts
  FImage := nil;
  FImageW := 0;
  FImageH := 0;
  CreateParts(2, 2);

  //Init inherited properties
  AutoScroll := False;
  DoubleBuffered := True; //To remove flicker when new image is loaded
  HorzScrollBar.Tracking := True;
  VertScrollBar.Tracking := True;

  //Init fields
  FFocusable := True;
  FImageWidth := 0;
  FImageHeight := 0;
  FImageScale := 100;
  FImageKeepPosition := True;
  FImageDrag := True;
  FImageDragCursor := crSizeAll;
  FImageDragging := False;
  FImageDraggingPoint := Point(0, 0);

  //Init objects
  FBitsObject := TBitsObject.Create;

  FPanel := TPaintBox.Create(Self);
  with FPanel do
  begin
    Parent := Self;
    SetBounds(0, 0, 200, 200);
    OnMouseDown := ImageMouseDown;
    OnMouseUp := ImageMouseUp;
    OnMouseMove := ImageMouseMove;
    {$ifdef Test}
    OnPaint := PanelPaint;
    {$endif}
  end;

  //Init event handlers
  OnMouseWheelUp := MouseWheelUp;
  OnMouseWheelDown := MouseWheelDown;
end;


destructor TATImageMap.Destroy;
var
  i, j: Integer;
begin
  for i := 1 to FImageW  do
    for j := 1 to FImageH do
      with GetImage(i, j)^ do
        if Assigned(Image) then
          FreeAndNil(Image);

  FreeMem(FImage);
  FreeAndNil(FBitsObject);
  inherited;
end;


procedure TATImageMap.CreateImage(I, J: Integer);
begin
  with GetImage(I, J)^ do
    if not Assigned(Image) then
    begin
      Image := TATImageEx.CreateObj(Self, FBitsObject);
      with Image do
      begin
        Parent := Self;
        Align := alNone;
        OnMouseDown := ImageMouseDown;
        OnMouseUp := ImageMouseUp;
        OnMouseMove := ImageMouseMove;
      end;
    end;
end;


//---------------------------
procedure TATImageMap.DoScroll;
begin
  UpdateImageShown;
  if Assigned(FOnScroll) then
    FOnScroll(Self);
end;


procedure TATImageMap.DoOptionsChange;
begin
  if Assigned(FOnOptionsChange) then
    FOnOptionsChange(Self);
end;


procedure TATImageMap.DoIndexShow;
begin
  if Assigned(FOnIndexShow) then
    FOnIndexShow(Self, AI, AJ, AValue);
end;


//---------------------------
procedure TATImageMap.WMHScroll(var Msg: TMessage);
begin
  inherited;
  DoScroll;
end;

procedure TATImageMap.WMVScroll(var Msg: TMessage);
begin
  inherited;
  DoScroll;
end;

procedure TATImageMap.MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (Shift = []) then
  begin
    IncreaseImageScale(True);
    FImageDragging := False;
  end;

  Handled := True;
end;

procedure TATImageMap.MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (Shift = []) then
  begin
    IncreaseImageScale(False);
    FImageDragging := False;
  end;

  Handled := True;
end;

procedure TATImageMap.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS;
end;

//---------------------------
procedure TATImageMap.KeyDown(var Key: Word; Shift: TShiftState);
  function PageSize(AClientSize: Integer): Integer;
  begin
    Result := IMax(AClientSize - cImageGapSize, AClientSize div 3 * 2);
  end;
begin
  case Key of
    VK_LEFT:
    begin
      if Shift = [] then
      begin
        with HorzScrollBar do
          Position := Position - cImageLineSize;
        DoScroll;
        Key := 0;
      end
      else
      if Shift = [ssCtrl] then
      begin
        with HorzScrollBar do
          Position := 0;
        DoScroll;
        Key := 0;
      end;
    end;

    VK_RIGHT:
    begin
      if Shift = [] then
      begin
        with HorzScrollBar do
          Position := Position + cImageLineSize;
        DoScroll;
        Key := 0;
      end
      else
      if Shift = [ssCtrl] then
      begin
        with HorzScrollBar do
          Position := Range;
        DoScroll;
        Key := 0;
      end;
    end;

    VK_HOME:
      if Shift = [] then
      begin
        with HorzScrollBar do
          Position := Position - PageSize(ClientWidth);
        DoScroll;
        Key := 0;
      end;

    VK_END:
      if Shift = [] then
      begin
        with HorzScrollBar do
          Position := Position + PageSize(ClientWidth);
        DoScroll;
        Key := 0;
      end;

    VK_UP:
    begin
      if Shift = [] then
      begin
        with VertScrollBar do
          Position := Position - cImageLineSize;
        DoScroll;
        Key := 0;
      end
      else
      if Shift = [ssCtrl] then
      begin
        with VertScrollBar do
          Position := 0;
        DoScroll;
        Key := 0;
      end;
    end;

    VK_DOWN:
    begin
      if Shift = [] then
      begin
        with VertScrollBar do
          Position := Position + cImageLineSize;
        DoScroll;
        Key := 0;
      end
      else
      if Shift = [ssCtrl] then
      begin
        with VertScrollBar do
          Position := Range;
        DoScroll;
        Key := 0;
      end;
    end;

    VK_PRIOR:
      if Shift = [] then
      begin
        with VertScrollBar do
          Position := Position - PageSize(ClientHeight);
        DoScroll;
        Key := 0;
      end;

    VK_NEXT:
      if Shift = [] then
      begin
        with VertScrollBar do
          Position := Position + PageSize(ClientHeight);
        DoScroll;
        Key := 0;
      end;
  end;
end;


//---------------------------
function TATImageMap.IndexRect(I, J: Integer): TRect;
var
  ANewWidth, ANewHeight,
  ANewLeft, ANewTop: Integer;
begin
  ANewWidth := Trunc(FImageWidth * FImageScale / 100);
  ANewHeight := Trunc(FImageHeight * FImageScale / 100);
  ANewLeft := Trunc((i - 1) * FImageWidth  * FImageScale / 100);
  ANewTop := Trunc((j - 1) * FImageHeight * FImageScale / 100);

  Result := Bounds(
    ANewLeft,
    ANewTop,
    ANewWidth,
    ANewHeight);
end;


function TATImageMap.ShowRect(I, J: Integer): TRect;
begin
  Result := IndexRect(i, j);
  OffsetRect(Result, FPanel.Left, FPanel.Top);
end;


//---------------------------
procedure TATImageMap.UpdateImage(I, J: Integer);
begin
  with GetImage(i, j)^ do
    if Assigned(Image) then
    begin
      Image.XOffset := IndexRect(i, j).Left;
      Image.YOffset := IndexRect(i, j).Top;
      Image.Scale := FImageScale / 100;
      Image.BoundsRect := ShowRect(i, j);
      Image.Invalidate;
    end;
end;


//---------------------------
procedure TATImageMap.UpdateImagePosition;
var
  i, j: Integer;
  SW, SH: Integer;
begin
  if not AKeep then
  begin
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;
  end;

  SW := Round(FImageWidth * FImageW * FImageScale / 100);
  SH := Round(FImageHeight * FImageH * FImageScale / 100);
  FPanel.Width:= SW;
  FPanel.Height:= SH;
  HorzScrollBar.Range := SW;
  VertScrollBar.Range := SH;

  UpdateImageShown;

  for i := 1 to FImageW do
    for j := 1 to FImageH do
    begin
      UpdateImage(i, j);
    end;
end;


//---------------------------
{
procedure TATImageMap.SavePosition;
var
  p: TPoint;
begin
  p := FPanel.ScreenToClient(Mouse.CursorPos);
  FX := Trunc(p.x *100 / FImageScale / FImageWidth) + 1;
  FY := Trunc(p.y *100 / FImageScale / FImageHeight) + 1;
end;

procedure TATImageMap.RestorePosition;
begin
  PositionToIndex(FX, FY, True);
end;
}


procedure TATImageMap.Resize;
begin
  inherited;
  DoScroll;
end;


//---------------------------
procedure TATImageMap.SetImageScale(AValue: Extended);
begin
  Assert((AValue >= cATMinScale) and (AValue <= cATMaxScale), 'Invalid scale value');

  if FImageScale <> AValue then
  begin
    FImageScale := AValue;
    UpdateImagePosition(True);
    DoOptionsChange;
  end;
end;


//---------------------------
procedure TATImageMap.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FFocusable then
    SetFocus;
end;


//---------------------------
procedure TATImageMap.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FFocusable then
    SetFocus;

  if (Button = mbLeft) then
  begin
    if FImageDrag then
    begin
      FImageDragging := True;
      FImageDraggingPoint := Point(X, Y);
      Screen.Cursor := FImageDragCursor;

      FMapImagesStop := True; //Don't redraw on dragging!
    end;
  end;
end;

procedure TATImageMap.ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    FImageDragging := False;
    Screen.Cursor := crDefault;

    FMapImagesStop := False; //Can redraw again
    Repaint;
    DoScroll;
  end;
end;

procedure TATImageMap.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if FImageDrag and FImageDragging then
  begin
    HorzScrollBar.Position := HorzScrollBar.Position + (FImageDraggingPoint.X - X);
    VertScrollBar.Position := VertScrollBar.Position + (FImageDraggingPoint.Y - Y);
    //Repaint; //To draw on mouse move
    //DoScroll;
  end;
end;


//---------------------------
procedure TATImageMap.IncreaseImageScale(AIncrement: Boolean);
const
  cViewerImageScales: array[1 .. 34] of Integer = (
    1, 2, 4, 7, 10, 15, 20, 25, 30,
    40, 50, 60, 70, 80, 90, 100, 110,
    125, 150, 175, 200, 250, 300, 350, 400, 450, 500,
    600, 700, 800, 1000, 1200, 1400, 1600);
var
  i: Integer;
begin
  if AIncrement then
  begin
    for i := Low(cViewerImageScales) to High(cViewerImageScales) do
      if cViewerImageScales[i] > ImageScale then
      begin
        ImageScale := cViewerImageScales[i];
        Break;
      end;
  end
  else
  begin
    for i := High(cViewerImageScales) downto Low(cViewerImageScales) do
      if cViewerImageScales[i] < ImageScale then
      begin
        ImageScale := cViewerImageScales[i];
        Break;
      end;
  end;
end;


//---------------------------
function TATImageMap.GetBit;
var
  AScale: Extended;
begin
  Result := fBitsObject.GetBit(Id, Info);

  if Scaled and (FImageWidth > 0) then
    AScale := Width / FImageWidth
  else
    AScale := 1.0;

  Info.X1 := Trunc(Info.X1 * AScale);
  Info.Y1 := Trunc(Info.Y1 * AScale);
  Info.X2 := Trunc(Info.X2 * AScale);
  Info.Y2 := Trunc(Info.Y2 * AScale);
end;


function TATImageMap.AddBit(const Info: TBitInfo; Redraw: Boolean = True): Integer;
begin
  Result := fBitsObject.AddBit(Info);

  if Redraw then
    PaintIndexes(True);
end;


function TATImageMap.DeleteBit;
begin
  Result := fBitsObject.DeleteBit(Id);

  if Redraw then
    PaintIndexes;
end;

function TATImageMap.SetBit;
begin
  Result := fBitsObject.SetBit(Id, Info, InfoSet);

  if Redraw then
    PaintIndexes;
end;


function TATImageMap.AddTrackItem;
begin
  Result := fBitsobject.AddTrackItem(Id, P);

  if Redraw then
    PaintIndexes;
end;


procedure TATImageMap.PaintIndexes;
var
  i, j: Integer;
begin
  for i := 1 to FImageW do
    for j := 1 to FImageH do
      with GetImage(i, j)^ do
        if Assigned(Image) then
        begin
          if LastOnly then
            Image.PaintLast
          else
            Image.Invalidate;
        end;
end;


//-----------------------------
procedure TATImageMap.FreeIndex(I, J: Integer);
begin
  with GetImage(i, j)^ do
    if Assigned(Image) then
      FreeAndNil(Image);
end;


//-----------------------------
procedure TATImageMap.LoadIndexFromFile(I, J: Integer; const FN: string);
begin
  Assert((i > 0) and (i <= FImageW), Format('Wrong index X: %d', [I]));
  Assert((j > 0) and (j <= FImageH), Format('Wrong index Y: %d', [J]));

  CreateImage(i, j);
  with GetImage(i, j)^ do
  begin
    Assert(Assigned(Image), 'Image not assigned after CreateImage');
    Image.Visible := False;
    Image.LoadFromFile(FN);
    FImageWidth := Image.ImageWidth;
    FImageHeight := Image.ImageHeight;
    UpdateImage(i, j);
    Image.Visible := True;
    Application.ProcessMessages;
  end;
end;


//-----------------------------
procedure TATImageMap.PositionToIndex;
var
  X, Y: Integer;
begin
  X := 0;
  Y := 0;
  if Center then X := Trunc(FImageWidth / 2 * FImageScale / 100) - ClientWidth div 2;
  if Center then Y := Trunc(FImageheight / 2 * FImageScale / 100) - ClientHeight div 2;

  HorzScrollBar.Range := Trunc(FImageWidth * FImageW * FImageScale / 100);
  VertScrollBar.Range := Trunc(FImageHeight * FImageH * FImageScale / 100);

  HorzScrollBar.Position := Trunc(FImageWidth * (I - 1) * FImageScale / 100) + X;
  VertScrollBar.Position := Trunc(FImageHeight * (J - 1) * FImageScale / 100) + Y;

  DoScroll;
end;


//-----------------------------
function TATImageMap.IsIndexLoaded(I, J: Integer): Boolean;
begin
  Assert((i > 0) and (i <= FImageW), Format('Wrong index X: %d', [I]));
  Assert((j > 0) and (j <= FImageH), Format('Wrong index Y: %d', [J]));

  with GetImage(i, j)^ do
    Result := Assigned(Image) and
      (Image.ImageWidth > 0) and (Image.ImageHeight > 0);
end;

function TATImageMap.IsIndexShown(I, J: Integer): Boolean;
begin
  with GetImage(i, j)^ do
    Result := Shown;
end;


//-----------------------------
//Check which images are shown on screen, which not
//(saved in Shown flags)
procedure TATImageMap.UpdateImageShown;
var
  i, j: Integer;
  R: TRect;
  i0, i01, j0, j01: Integer;
type
  PShArray = ^TShArray;
  TShArray = array[0 .. Pred(cATMaxImages)] of Bool;
var
  sh: PShArray;
  Size: Integer;
  ImgPtr: PATImageRec;
  ShPtr: PBool;

  function GetSh(X, Y: Integer): PBool;
  begin
    //Must work the same as GetImage
    Result:= @(sh^[(X - 1) * FImageH + (Y - 1)]);
  end;

begin
  Size:= FImageW * FImageH * SizeOf(Bool);
  GetMem(sh, Size);
  FillChar(sh^, Size, 0);

  try
    R := Bounds(
      HorzScrollbar.Position,
      VertScrollbar.Position,
      ClientWidth,
      ClientHeight);

    //Images are visible with indexes:
    // I = I0 .. I01,
    // J = J0 .. Y01

    I0 := 1;
    J0 := 1;
    I01 := 1;
    J01 := 1;

    for i := 1 to FImageW do
      if (FImageWidth * i * FImageScale / 100) > R.Left then begin I0 := i; Break end;
    for i := FImageW downto 1 do
      if (FImageWidth * (i - 1) * FImageScale / 100) < R.Right then begin I01 := i; Break end;
    for j := 1 to FImageH do
      if (FImageHeight * j * FImageScale / 100) > R.Top then begin J0 := j; Break end;
    for j := FImageH downto 1 do
      if (FImageHeight * (j - 1) * FImageScale / 100) < R.Bottom then begin J01 := j; Break end;

    //d
    //ShowMessage(Format('Shown: %d %d %d %d', [i0, i01, j0, j01]));

    for i := i0 to i01 do
      for j := j0  to j01 do
        GetSh(i, j)^ := True;

    for j := 1 to FImageH do
      for i := 1 to FImageW do
      begin
        ImgPtr := GetImage(i, j);
        ShPtr := GetSh(i, j);
        if Assigned(ImgPtr) and Assigned(ShPtr) then
          if (ImgPtr^.Shown <> ShPtr^) then
          begin
            ImgPtr^.Shown := ShPtr^;
            DoIndexShow(i, j, ShPtr^);
          end;
      end;
  finally
    FreeMem(sh);
  end;
end;


//----------------------------
function TATImageMap.BitsCount: Integer;
begin
  Result := FBitsObject.BitsCount;
end;


//----------------------------
//Debug procedure
procedure TATImageMap.PanelPaint(Sender: TObject);
var
  i,j : Integer;
  s: string;
begin
  if FImageScale >=5 then
    for i := 1 to FImageW do
      for j := 1 to FImageH do
        with FPanel.Canvas do
        begin
          if Assigned(GetImage(i, j)^.Image) then
            Brush.Style := bsSolid
          else
            Brush.Style := bsClear;

          Rectangle(
            Trunc((i - 1) * FImageWidth * FImageScale / 100),
            Trunc((j - 1) * FImageHeight * FImageScale / 100),
            Trunc(i * FImageWidth  * FImageScale / 100),
            Trunc(j * FImageHeight  * FImageScale /100));

          s := Format('%d,%d', [i, j]);
          if Assigned(GetImage(i, j)^.Image) then
            s := '(loaded)';

          TextOut(
            Trunc((i-1)*FImageWidth * FImageScale / 100),
            Trunc((j-1)*FImageHeight * FImageScale / 100), s);
        end;
end;


//-------------------------------
procedure TATImageMap.CreateParts(APartsX, APartsY: Integer);
var
  Size: Integer;
begin
  Assert((APartsX > 0) and (APartsX <= cATMaxImagesX), 'Invalid parts number X');
  Assert((APartsY > 0) and (APartsY <= cATMaxImagesX), 'Invalid parts number Y');
  Assert((APartsX * APartsY) <= cATMaxImages, 'Too many parts X * Y');

  if Assigned(FImage) then
  begin
    FreeMem(FImage);
    FImage := nil;
  end;

  try
    FImageW := APartsX;
    FImageH := APartsY;
    Size := FImageW * FImageH * SizeOf(TATImageRec);
    GetMem(FImage, Size);
    FillChar(FImage^, Size, 0);
  except
    FImage := nil;
    FImageW := 0;
    FImageH := 0;
  end;
end;


//----------------------------
function TATImageMap.GetImage(X, Y: Integer): PATImageRec;
begin
  Assert((X > 0) and (X <= FImageW), 'Invalid image index X');
  Assert((Y > 0) and (Y <= FImageH), 'Invalid image index Y');

  Result := @(FImage^[(X - 1) * FImageH + (Y - 1)]);
end;


//----------------------------
{ Registration }

procedure Register;
begin
  RegisterComponents('Samples', [TATImageMap]);
end;

end.
