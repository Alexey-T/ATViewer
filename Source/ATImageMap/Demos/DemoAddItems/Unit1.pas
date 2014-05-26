unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, ATImageMap, ExtCtrls, StdCtrls, Spin, ComCtrls, ImgList,
  XPMan;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    P: TOpenPictureDialog;
    P2: TOpenPictureDialog;
    FontDialog1: TFontDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    eBX: TSpinEdit;
    eBY: TSpinEdit;
    btnAddBmp: TButton;
    btnOpenBmp: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    eLX1: TSpinEdit;
    eLY1: TSpinEdit;
    eLX2: TSpinEdit;
    eLY2: TSpinEdit;
    btnAddLine: TButton;
    ColorBox1: TColorBox;
    eLW: TSpinEdit;
    bOval: TCheckBox;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    ePX: TSpinEdit;
    ePY: TSpinEdit;
    btnAddPoint: TButton;
    ColorBox2: TColorBox;
    eWP: TSpinEdit;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    eLLX: TSpinEdit;
    eLLY: TSpinEdit;
    btnAddLabel: TButton;
    eLLText: TEdit;
    btnLabFont: TButton;
    TabSheet5: TTabSheet;
    ImageList1: TImageList;
    Box: TATImageMap;
    boxBits: TGroupBox;
    eBitNum: TSpinEdit;
    btnDelBit: TButton;
    Label11: TLabel;
    labText: TLabel;
    labText2: TLabel;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    ddX: TSpinEdit;
    Label16: TLabel;
    ddY: TSpinEdit;
    Label17: TLabel;
    ddIndex: TSpinEdit;
    btnAddIL: TButton;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    TabSheet6: TTabSheet;
    Label21: TLabel;
    Label22: TLabel;
    btnOpenImg: TButton;
    Label23: TLabel;
    XPManifest1: TXPManifest;
    procedure btnOpenImgClick(Sender: TObject);
    procedure btnAddBmpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOpenBmpClick(Sender: TObject);
    procedure btnAddLineClick(Sender: TObject);
    procedure btnAddLabelClick(Sender: TObject);
    procedure btnLabFontClick(Sender: TObject);
    procedure BoxResize(Sender: TObject);
    procedure BoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAddPointClick(Sender: TObject);
    procedure btnDelBitClick(Sender: TObject);
    procedure btnAddILClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenImg(const fn: string);
    procedure OpenBmp(const fn: string);
    function AddBit(X, Y: Integer): integer;
    function AddIL(X, Y: Integer; ImageList: TImageList; Index: Integer): integer;
    function AddLine(Oval: Boolean; X1, Y1, X2, Y2: Integer; AColor: TColor; AWidth: Integer): Integer;
    function AddPoint(X, Y: Integer; AColor: TColor; AWidth: Integer): integer;
    function AddLabel(X, Y: Integer; const AText, AFont: string;
      AColor, AColor2: TColor; ASize: Integer; AStyle: TFontStyles): integer;
    procedure AddTrack(AColor: TColor; ALineWidth, ADotWidth: Integer; const Data: array of TPoint);
  end;

var
  Form1: TForm1;

implementation

uses
  FBits;

{$R *.dfm}

procedure TForm1.OpenImg;
begin
  try
    Box.CreateParts(2, 2); //Create 2x2 map
    Box.LoadIndexFromFile(1, 1, fn);
    Box.LoadIndexFromFile(1, 2, fn);
    Box.LoadIndexFromFile(2, 1, fn);
    Box.LoadIndexFromFile(2, 2, fn);
    Box.PositionToIndex(1, 1);
  except
    ShowMessage('Couldn''t load a image');
  end;
end;

procedure TForm1.OpenBmp;
begin
  with Image1 do
  try
    Picture.LoadFromFile(fn);
    if Picture.Graphic is TIcon then //To load icons too
    begin
      FixIcon(Picture.Graphic as TIcon);
      FixPictureFormat(Picture, clCream); //clCream - for example
    end;
  except
    ShowMessage('Couldn''t load a image');
  end;
end;

procedure TForm1.btnOpenImgClick(Sender: TObject);
begin
  with P do
    if Execute then
      OpenImg(FileName);
end;

procedure TForm1.btnOpenBmpClick(Sender: TObject);
begin
  with P2 do
    if Execute then
      OpenBmp(FileName);
end;

function TForm1.AddBit;
begin
  Result := Box.AddBit(BitInfo(bbBitmap, X, Y, 0, 0,
    Image1.Picture.Bitmap, 0, 0, '', '', 0, 0, []));
end;

function TForm1.AddIL(X, Y: Integer; ImageList: TImageList; Index: Integer):integer;
begin
  Result := Box.AddBit(BitInfo(bbILIcon, X, Y, 0, 0,
    ImageList, Index, 0, '', '', 0, 0, []));
end;

function TForm1.AddLine;
const
  Typ: array[Boolean] of TBitTyp = (bbLine, bbOval);
begin
  Result := Box.AddBit(BitInfo(Typ[Oval], X1, Y1, X2, Y2,
    nil, AColor, 0, '', '', AWidth, 0, []));
end;

function TForm1.AddPoint;
begin
  Result := Box.AddBit(BitInfo(bbPoint, X, Y, 0, 0,
    nil, AColor, 0, '', '', AWidth, 0, []));
end;

function TForm1.AddLabel(X, Y: Integer; const AText, AFont: string;
      AColor, AColor2: TColor; ASize: Integer; AStyle: TFontStyles):integer;
begin
  Result := Box.AddBit(BitInfo(bbLabel, X, Y, 0, 0,
    nil, AColor, AColor2, AText, AFont, ASize, 0, AStyle));
end;

procedure TForm1.btnAddBmpClick(Sender: TObject);
begin
  AddBit(eBX.Value, eBY.Value);
end;

procedure TForm1.btnAddLineClick(Sender: TObject);
begin
  AddLine(
    bOval.Checked,
    eLX1.Value,
    eLY1.Value,
    eLX2.Value,
    eLY2.Value,
    ColorBox1.Selected,
    eLW.Value);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 0;
  Box.SetFocus;

  //Open map
  OpenImg('Images\Big_logo.jpg');
  OpenBmp('Images\ie_icon.bmp');

  //Test bits
  AddBit(30+10, 10);
  AddBit(30+200, 50);
  AddBit(30+500, 500);
  AddBit(30+200, 700);
  AddLine(False, 5+10, 5+10, 5+200, 5+50, clGreen, 3);
  AddLabel(150, 75, 'Text near the track point', 'Tahoma', clGreen, clWhite, 11, [fsBold]);
  AddLabel(150, 720, 'Text near the track end', 'Tahoma', clGreen, clWhite, 11, [fsBold]);
  AddTrack(clRed, 3, 6, [Point(10, 10), Point(200, 50), Point(500, 500), Point(200, 700)]);

  //Update label
  BoxResize(Self);
end;

procedure TForm1.btnAddLabelClick(Sender: TObject);
begin
  AddLabel(
    eLLX.Value,
    eLLY.Value,
    eLLText.Text,
    FontDialog1.Font.Name,
    FontDialog1.Font.Color,
    clWhite,
    FontDialog1.Font.Size,
    FontDialog1.Font.Style);
end;

procedure TForm1.btnLabFontClick(Sender: TObject);
begin
  FontDialog1.Execute;
end;

procedure TForm1.BoxResize(Sender: TObject);
var
  N: Integer;
  Info, InfoSc: TBitInfo;
begin
  N := eBitNum.Value;
  if Box.GetBit(N, Info, False) and
    Box.GetBit(N, InfoSc, True) then
  begin
    labText.Caption := Format('%d-th item coord: %d,%d - %d,%d, scaled: %d,%d - %d,%d',
      [N, Info.X1, Info.Y1, Info.X2, Info.Y2,
       InfoSc.X1, InfoSc.Y1, InfoSc.X2, InfoSc.Y2]);
  end
  else
    labText.Caption := Format('%d-th item doesn''t exist', [N]);
end;

procedure TForm1.BoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  P: TPoint;
begin
  P:= Point(X, Y);
  P:= Box.ScreenToClient(TControl(Sender).ClientToScreen(P));
  P.X := Trunc(P.X * 100 / Box.ImageScale);
  P.Y := Trunc(P.Y * 100 / Box.ImageScale);

  labText2.Caption := Format('Mouse coord relative to Map corner (not scaled): %d, %d',
    [P.X, P.Y]);
end;

procedure TForm1.btnAddPointClick(Sender: TObject);
begin
  AddPoint(
    ePX.Value,
    ePY.Value,
    ColorBox2.Selected,
    eWP.Value);
end;

procedure TForm1.btnDelBitClick(Sender: TObject);
begin
  Box.DeleteBit(eBitNum.Value);
  BoxResize(Self);
end;

procedure TForm1.AddTrack;
var
  Id, i: Integer;
begin
  Id:= Box.AddBit(BitInfo(bbTrack, 0, 0, 0, 0,
    nil, AColor, 0, '', '', ALineWidth, ADotWidth, []));
  if Id >= 0 then
    for i:= Low(Data) to High(Data) do
      Box.AddTrackItem(Id, Data[i]);
end;

procedure TForm1.btnAddILClick(Sender: TObject);
begin
  AddIL(ddX.Value, ddY.Value, ImageList1, ddIndex.Value);
end;

end.
