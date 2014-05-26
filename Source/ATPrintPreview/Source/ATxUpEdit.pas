{************************************}
{                                    }
{  ATUpEdit Component                }
{  Copyright (C) Alexey Torgashin    }
{  http://uvviewsoft.com             }
{                                    }
{************************************}

unit ATxUpEdit;

interface

uses
  Windows, SysUtils, Classes, Controls,
  StdCtrls, ComCtrls;

type
  TUpEdit = class(TEdit)
  private
    FUp: TUpDown;
    FPrec: Integer;
    FMin: Extended;
    FMax: Extended;
    FInc: Extended;
    procedure UpChange(Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
    function GetValue: Extended;
    procedure SetValue(AVal: Extended);
  public
    constructor Create(AOwner: TComponent); override;
    property Prec: Integer read FPrec write FPrec;
    property Min: Extended read FMin write FMin;
    property Max: Extended read FMax write FMax;
    property Inc: Extended read FInc write FInc;
    property Value: Extended read GetValue write SetValue;
  protected
    procedure Resize; override;
    procedure SetParent(AValue: TWinControl); override;
    procedure SetEnabled(AValue: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

procedure Register;


implementation

constructor TUpEdit.Create(AOwner: TComponent);
begin
  inherited;
  FPrec := 1;
  FMin := 0.0;
  FMax := 1e10;
  FInc := 1.0;
  Value := 0;
  FUp := TUpDown.Create(Self);
  with FUp do
  begin
    Parent := nil;
    OnChangingEx := UpChange;
    Max := High(Max);
    Min := Low(Min);
  end;
end;

procedure TUpEdit.SetParent(AValue: TWinControl);
begin
  inherited;
  if Assigned(AValue) then
    FUp.Parent := AValue;
end;

procedure TUpEdit.SetEnabled(AValue: Boolean);
begin
  inherited;
  FUp.Enabled := AValue;
end;

procedure TUpEdit.Resize;
begin
  FUp.Left := Left + Width;
  FUp.Top := Top;
  FUp.Height := Height;
end;

function FStr(const Value: Extended; FPrec: Integer): string;
begin
  try
    Result := FloatToStrF(Value, ffFixed, 15, FPrec);
  except
    Result := '0';
  end;
end;

procedure TUpEdit.UpChange;
const
  cInc: array[TUpDownDirection] of Integer = (0, 1, -1);
var
  V: Extended;
begin
  try
    V := StrToFloat(Text) + cInc[Direction] * FInc;
  except
    V := FMin;
  end;
  if (V < FMin) then V := FMin;
  if (V > FMax) then V := FMax;
  Text := FStr(V, FPrec);
end;

function TUpEdit.GetValue;
begin
  try
    Result := StrToFloat(Text);
  except
    Result := 0;
  end;
end;

procedure TUpEdit.SetValue;
begin
  Text := FStr(AVal, FPrec); 
end;

procedure TUpEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  F: Boolean;
begin
  case Key of
    VK_UP:
    begin
      UpChange(Self, F, 0, updUp);
      Key := 0;
    end;
    VK_DOWN:
    begin
      UpChange(Self, F, 0, updDown);
      Key := 0;
    end;
  end;
end;

{ Registration }

procedure Register;
begin
  RegisterComponents('Samples', [TUpEdit]);
end;


end.
