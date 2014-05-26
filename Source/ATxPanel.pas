unit ATxPanel;

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls;

type
  TATTextPanel = class(TPanel)
  private
    lab: TLabel;
    procedure SetClick(Value: TNotifyEvent);
    function GetLab: string;
    procedure SetLab(Value: string);
  public
    constructor Create(Owner: TComponent); override;
    property OnLabClick: TNotifyEvent write SetClick;
    property LabCaption: string read GetLab write SetLab;
  protected
    procedure Paint; override;
  end;

implementation

uses Graphics;

procedure TATTextPanel.Paint;
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
end;

constructor TATTextPanel.Create;
begin
  inherited;
  lab := TLabel.Create(Self);
  with lab do
  begin
    Parent := Self;
    Align := alTop;
    Alignment := taCenter;
    LabCaption := 'Format not known';
  end;
end;

procedure TATTextPanel.SetClick;
begin
  lab.OnClick := Value;
end;

procedure TATTextPanel.SetLab(Value: string);
begin
  lab.Caption := Value;
  Height := lab.Height + 4;
end;

function TATTextPanel.GetLab: string;
begin
  Result:= lab.Caption;
end;

end.
