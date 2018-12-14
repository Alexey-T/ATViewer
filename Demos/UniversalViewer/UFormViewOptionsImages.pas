{$I ATViewerOptions.inc}

unit UFormViewOptionsImages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormViewOptionsImages = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    OpenDialog1: TOpenDialog;
    boxIJL: TGroupBox;
    labExtIJL: TLabel;
    chkUseIJL: TCheckBox;
    edExtIJL: TEdit;
    procedure FormShow(Sender: TObject);
    procedure chkUseIJLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
  ATxMsgProc, ATViewerMsg;

{$R *.DFM}

procedure TFormViewOptionsImages.FormShow(Sender: TObject);
begin
  {$I Lang.FormViewOptionsImages.inc}

  {$ifndef IJL}
  chkUseIJL.Checked:= false;
  chkUseIJL.Enabled:= false;
  {$endif}

  chkUseIJLClick(Self);
end;


procedure TFormViewOptionsImages.chkUseIJLClick(Sender: TObject);
var
  En: Boolean;
begin
  En:= chkUseIJL.Checked;
  labExtIJL.Enabled:= En;
  edExtIJL.Enabled:= En;
end;

end.
