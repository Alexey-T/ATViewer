unit ATViewerMCI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, MPlayer, ComCtrls;

type
  TMediaFrame = class(TFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    P: TMediaPlayer;
    TrackBar1: TTrackBar;
    Timer1: TTimer;
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PNotify(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FBusy: boolean;
    procedure PlayPause;
  end;

implementation

{$R *.dfm}

procedure TMediaFrame.TrackBar1Change(Sender: TObject);
begin
  if not FBusy then
    P.Position := Trackbar1.Position;
end;

procedure TMediaFrame.Timer1Timer(Sender: TObject);
begin
  FBusy := True;
  with P do
    if FileName <> '' then
    begin
      if Position = Length then
      begin
        Position := 0;
        Stop;
      end;
      TrackBar1.Position := Position;
    end;
  FBusy := False;
end;

procedure TMediaFrame.PNotify(Sender: TObject);
begin
  with P do
  begin
    if Mode = mpStopped then
    begin
      Notify := False;
      //PreparePlaybackEnd;
      Exit
    end;
    Notify := True;
  end;  
end;

procedure TMediaFrame.PlayPause;
begin
  with P do
    if Mode = mpPlaying then
    begin
      //Pause;
      Perform(wm_lbuttondown, mk_lbutton, MakeLong(Height+5, 5));
      Perform(wm_lbuttonup, mk_lbutton, MakeLong(Height+5, 5));
    end
    else
    begin
      //Play;
      Perform(wm_lbuttondown, mk_lbutton, MakeLong(5, 5));
      Perform(wm_lbuttonup, mk_lbutton, MakeLong(5, 5));
    end;
end;

end.
