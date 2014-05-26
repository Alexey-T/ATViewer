unit fTrack;

interface

uses Windows, SysUtils;

const
  cMaxTrackItems = 1000 * 1000;
type
  TTrackArray = array[0 .. Pred(cMaxTrackItems)] of TPoint; //This array is static, 8Meg
  TTrackInfo = class
  public
    FCount: Integer;
    FData: TTrackArray;
    constructor Create;
    procedure Clear; //Clears track
    function AddItem(P: TPoint): Boolean; //Adds track item
  end;

implementation


constructor TTrackInfo.Create;
begin
  inherited Create;
  Clear;
end;

procedure TTrackInfo.Clear;
begin
  FCount := 0;
  FillChar(FData, SizeOf(FData), 0);
end;

function TTrackInfo.AddItem;
begin
  Result := FCount < High(TTrackArray);
  if Result then
  begin
    Inc(FCount);
    FData[FCount - 1] := P;
  end;
end;


end.
