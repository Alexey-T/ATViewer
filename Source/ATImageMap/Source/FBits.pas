unit FBits;

interface

uses
  Windows, Graphics, SysUtils, Controls;

const
  cBitTextOff = 12; //Offset between label coord and text

type
  TBitTyp = (
    bbNone,
    bbBitmap,
    bbLine,
    bbOval,
    bbPoint,
    bbLabel,
    bbTrack,
    bbILIcon //ImageList icon
    );

  TBitInfo = record
    ID: Integer;
    Typ: TBitTyp;
    X1, Y1, X2, Y2: Integer;
    Data: TObject;
    DataNotOwn: Boolean;
    Color: TColor;
    Color2: TColor;
    Text: string;
    Font: string;
    Size, Size2: Integer;
    Style: TFontStyles;
  end;

  TBitInfoSet = set of (
    bbsCoord, //change X1, Y1, X2, Y2
    bbsColor, //change Color, Color2
    bbsText, //change Text
    bbsFont, //change Font
    bbsSizes, //change Size, Size2
    bbsStyle //change Style
    );

const
  cBitsCount = 1000; //Max bits number
type
  TBits = array[0 .. Pred(cBitsCount)] of TBitInfo;

function BitInfo(
  ATyp: TBitTyp;
  AX1, AY1, AX2, AY2: Integer;
  AData: TObject;
  AColor: TColor;
  AColor2: TColor;
  const AText: string;
  const AFont: string;
  ASize, ASize2: Integer;
  AStyle: TFontStyles): TBitInfo;

type
  TBitsObject = class
    FBits: TBits;
    FBitsCount: Integer;
    FBitsLastId: Integer;
    constructor Create;
    destructor Destroy; override;

    //--------
    //Adds item(bit) to layers list.
    //Result is Id >= 0, when item was added, or negative if error occured.
    function AddBit(const Info: TBitInfo): Integer;

    //Changes bit info.
    //Id: Id returned by AddBit.
    //Info: Info to set.
    //InfoSet: shows which fields of Info are used (it may be only [bbsCoord]).
    //Result True if item exists.
    //Note: Info.Data must not be assigned (currently)
    function SetBit(Id: Integer; const Info: TBitInfo; InfoSet: TBitInfoSet): Boolean;

    //Checks is bit index valid (note: not Id, but internal index).
    function IsBitIndexValid(Index: Integer): Boolean;

    //Gets internal item index from Id.
    //Result >= 0 if Id valid, or negative if not valid.
    function IndexFromId(Id: Integer): Integer;

    //Gets bit info to Info variable.
    function GetBit(Id: Integer; var Info: TBitInfo): Boolean;

    //Deletes bit.
    function DeleteBit(Id: Integer): Boolean;

    //Adds track item. Id: Track id (returned by AddBit). P: coordinates.
    //Result True if item was added.
    function AddTrackItem(Id: Integer; P: TPoint): Boolean;

    //Returns number of bits.
    property BitsCount: Integer read FBitsCount;
    //--------------
  end;


implementation

uses FTrack;

function BitInfo;
begin
  FillChar(Result, SizeOf(Result), 0);
  with Result do
  begin
    Typ := ATyp;
    X1 := AX1;
    Y1 := AY1;
    X2 := AX2;
    Y2 := AY2;
    Data := AData;
    Color := AColor;
    Color2 := AColor2;
    Text := AText;
    Font := AFont;
    Size := ASize;
    Size2 := ASize2;
    Style := AStyle;
  end;
end;

procedure ClearBit(var Info: TBitInfo);
begin
  with Info do
  begin
    Typ := bbNone;
    X1 := 0;
    Y1 := 0;
    X2 := 0;
    Y2 := 0;
    Color := clNone;
    Color2 := clNone;
    Text := '';
    Font := '';
    Size := 0;
    Size2 := 0;
    Style := [];

    if DataNotOwn then
      Data := nil
    else
      if Assigned(Data) then
        FreeAndNil(Data);
  end;
end;


constructor TBitsObject.Create;
begin
  inherited;
  FBitsCount := 0;
  FBitsLastId := -1;
  FillChar(FBits, SizeOf(FBits), 0);
end;

destructor TBitsObject.Destroy;
var
  i: Integer;
begin
  for i := FBitsCount - 1 downto 0 do
    ClearBit(FBits[i]);
  FBitsCount := 0;

  inherited;
end;


function TBitsObject.AddBit;
begin
  if FBitsCount >= High(FBits) then
    begin Result := -1; Exit end;

  Inc(FBitsCount);
  Inc(FBitsLastId);
  Result := FBitsLastId;

  with FBits[FBitsCount - 1] do
  begin
    Id := FBitsLastId;
    Typ := Info.Typ;
    X1 := Info.X1;
    Y1 := Info.Y1;
    X2 := Info.X2;
    Y2 := Info.Y2;

    Data := nil;
    DataNotOwn := False;

    case Typ of
      bbBitmap:
      begin
        Assert(Assigned(Info.Data), 'Bitmap not assigned');
        Assert(Info.Data is TBitmap, 'Bitmap wrong');
        Data := TBitmap.Create;
        TBitmap(Data).Assign(TBitmap(Info.Data));
      end;
      bbTrack:
      begin
        Data := TTrackInfo.Create;
      end;
      bbILIcon:
      begin
        Assert(Assigned(Info.Data), 'ImageList not assigned');
        Assert(Info.Data is TImageList, 'ImageList wrong');
        Data := Info.Data;
        DataNotOwn := True; //Not own object
      end;
    end;

    Color := Info.Color;
    Color2 := Info.Color2;
    Text := Info.Text;
    Font := Info.Font;
    Size := Info.Size;
    Size2 := Info.Size2;
    Style := Info.Style;
  end;
end;

//------------------
function TBitsObject.IsBitIndexValid;
begin
  Result := (Index >= 0) and (Index < FBitsCount);
end;

function TBitsObject.IndexFromId;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FBitsCount - 1 do
    if FBits[i].ID = Id then
      begin Result := i; Break end;
end;


function TBitsObject.GetBit;
var
  Index: Integer;
begin
  Index := IndexFromId(Id);
  Result := IsBitIndexValid(Index);
  if Result then
    with FBits[Index] do
    begin
      Info.Typ := Typ;
      Info.X1 := X1;
      Info.Y1 := Y1;
      Info.X2 := X2;
      Info.Y2 := Y2;
      Info.Data := Data;
      Info.Color := Color;
      Info.Color2 := Color2;
      Info.Text := Text;
      Info.Font := Font;
      Info.Size := Size;
      Info.Size2 := Size2;
      Info.Style := Style;
    end;
end;


function TBitsObject.SetBit;
var
  Index: Integer;
begin
  Assert(not Assigned(Info.Data), 'Data not assigned');

  Index := IndexFromId(Id);
  Result := IsBitIndexValid(Index);
  if Result then
    with FBits[Index] do
    begin
      if bbsCoord in InfoSet then
      begin
        X1 := Info.X1;
        Y1 := Info.Y1;
        X2 := Info.X2;
        Y2 := Info.Y2;
      end;
      if bbsColor in InfoSet then
      begin
        Color := Info.Color;
        Color2 := Info.Color2;
      end;
      if bbsText in InfoSet then
      begin
        Text := Info.Text;
      end;
      if bbsFont in InfoSet then
      begin
        Font := Info.Font;
      end;
      if bbsSizes in InfoSet then
      begin
        Size := Info.Size;
        Size2 := Info.Size2;
      end;
      if bbsStyle in InfoSet then
      begin
        Style := Info.Style;
      end;
    end;
end;


function TBitsObject.DeleteBit;
var
  Index, i: Integer;
begin
  Index := IndexFromId(Id);
  Result := IsBitIndexValid(Index);
  if Result then
  begin
    ClearBit(FBits[Index]);
    for i := Index to FBitsCount - 2 do
      Move(FBits[i + 1], FBits[i], SizeOf(TBitInfo));
    FillChar(FBits[FBitsCount - 1], SizeOf(TBitInfo), 0);
    Dec(FBitsCount);
  end;
end;


function TBitsObject.AddTrackItem;
var
  Index: Integer;
begin
  Index := IndexFromId(Id);
  Result := IsBitIndexValid(Index);
  if Result then
    with FBits[Index] do
    begin
      Assert(Assigned(Data), 'Track not assigned');
      Assert(Data is TTrackInfo, 'Track wrong');
      with TTrackInfo(Data) do
        Result := AddItem(P);
    end;
end;


end.
