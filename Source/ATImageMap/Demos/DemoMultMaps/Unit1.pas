//Images are loaded dynamically in this demo,
//procedure BoxIndexShow.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ATImageMap, StdCtrls, FBits, ImgList, Spin, ComCtrls,
  ExtCtrls, XPMan;

type
  TForm1 = class(TForm)
    Box: TATImageMap;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    btnDebugForm: TButton;
    edBit: TSpinEdit;
    btnDelBit: TButton;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    btnVisImage: TButton;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    ImageList1: TImageList;
    XPManifest1: TXPManifest;
    labMap: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BoxScroll(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDebugFormClick(Sender: TObject);
    procedure btnDelBitClick(Sender: TObject);
    procedure btnVisImageClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    function AddTrack(AColor: TColor; ALineWidth, ADotWidth: Integer; Data: array of TPoint): Integer;
    function AddIL(X, Y: integer; ImageList: TImageList; Index: integer): Integer;
    function AddLabel(X, Y: integer; Text, Font: string; Color, Color2: TColor; FontSize: Integer): Integer;
    procedure BoxIndexShow(Sender: TObject; AI, AJ: Integer; AValue: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

const
  cXMax = 200; //Map size 200x100
  cYMax = 100;
  cX1 = 100; //Index 100,50
  cY1 = 50;
  cScale1 = 20; //Scale

function IndexFilename(X, Y: integer): string;
begin
  Result := Format('..\Images\%d-%d.jpg', [X - cX1 + 1, Y - cY1 + 1]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fn: string;
begin
  Box.OnIndexShow := BoxIndexShow;
  Box.CreateParts(cXMax, cYMax);

  fn := IndexFilename(cX1, cY1);
  if FileExists(fn) then
    Box.LoadIndexFromFile(cX1, cY1, fn)
  else
    ShowMessage('Cannot load startup file: ' + fn);

  Box.ImageScale := cScale1;
  Box.PositionToIndex(cX1, cY1);
end;


function TForm1.AddTrack(AColor: TColor; ALineWidth, ADotWidth: Integer; Data: array of TPoint): Integer;
var
  i: Integer;
begin
  Result := Box.AddBit(BitInfo(bbTrack, 0, 0, 0, 0,
    nil, AColor, clNone, '', '', ALineWidth, ADotWidth, []));

  if Result >= 0 then
    for i := Low(Data) to High(Data) do
      Box.AddTrackItem(Result, Data[i]);
end;

function TForm1.AddIL;
begin
  Result := Box.AddBit(BitInfo(bbILIcon,
    X, Y, 0, 0, ImageList, Index, 0,
    '', '', 0, 0, []));
end;

function TForm1.AddLabel;
begin
  Result := Box.AddBit(BitInfo(bbLabel,
    X, Y, 0, 0, nil, Color, Color2,
    Text, Font, FontSize, 0, []));
end;


procedure TForm1.BoxScroll(Sender: TObject);
const
  cTrue: array[Boolean] of string = ('no', 'yes');
begin
  Statusbar1.SimpleText := Format('%d,%d', [box.Panel.Width, box.Panel.Height]);
  Trackbar1.Position := Trunc(box.ImageScale);
  label1.Caption := 'Scale: ' + IntToStr(Trunc(box.ImageScale)) + '%';

{
  //Debug form
  if Assigned(FormDeb) then
  begin
    with FormDeb.ListBox1 do
    begin
      Items.Clear;
      for j := 1 to cImageH do
        for i := 1 to cImageW do
          Items.Add( Format('%d,%d loaded: %d',
            [j, i, cTrue[Box.IsIndexLoaded(i, j)]]) );
      end;

    with FormDeb.ListBox2 do
    begin
      Items.Clear;
      for j := 1 to cImageH do
        for i := 1 to cImageW do
          Items.Add( Format('%d,%d shown: %d',
            [j, i, cTrue[Box.IsIndexShown(i, j)]]) );
      end;
  end;
  }
end;


procedure TForm1.FormShow(Sender: TObject);
var
  x, y, dx: integer;
const
  X1 = 10; Y1 = 10;
  X2 = 1500; Y2 = 500;
  X3 = 2700; Y3 = 2400;
begin
  labMap.Caption := Format('Map contains %dx%d cells',
    [cXMax, cYMax]); 

  x := (cX1 - 1) * Box.ImageWidth;
  y := (cY1 - 1) * Box.ImageHeight;
  dx:= Box.ImageWidth div 10;
  AddTrack(clRed, 3, 6,
    [Point(x + x1, y + y1),
    Point(x + x2, y + y2),
    Point(x + x3, y + y3)]);
  AddIL(x + x1 + dx, y + y1 + dx, ImageList1, 1);
  AddIL(x + x2 + dx, y + y2 + dx, ImageList1, 2);
  AddLabel(x + x2 - dx, y + y2 + 2 * dx,
    'Icons from Imagelist', 'Tahoma', clGreen, clLtGray, 10);

  BoxScroll(Self);
end;


procedure TForm1.BoxIndexShow;
const
  c: array[Boolean] of string = ('Hidden', 'Shown');
var
  FN: string;
begin
  //Debug form
  if Assigned(FormDeb) then
    with FormDeb.ListBox3 do
      Items.Add(Format('[%d,%d] %s', [AI, AJ, c[AValue]]));

  if AValue then
  begin
    //Load image if was not loaded
    if not Box.IsIndexLoaded(AI, AJ) then
    begin
      FN := IndexFilename(AI, AJ);
      if FileExists(FN) then
        Box.LoadIndexFromFile(AI, AJ, FN);
    end;
  end
  else
  begin
    //Unload image
    if Box.IsIndexLoaded(AI, AJ) then
      Box.FreeIndex(AI, AJ);
  end;
end;

procedure TForm1.btnDebugFormClick(Sender: TObject);
begin
  if Assigned(FormDeb) then
    FormDeb.Show;
end;

procedure TForm1.btnDelBitClick(Sender: TObject);
begin
  if not Box.DeleteBit(edBit.Value) then
    ShowMessage('Cannot delete bit');
end;

procedure TForm1.btnVisImageClick(Sender: TObject);
begin
  Box.PositionToIndex(cX1, cY1);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Box.ImageScale := Trackbar1.Position;
end;

end.

