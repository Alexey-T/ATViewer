unit UFormViewAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormViewAbout = class(TForm)
    PanelText: TPanel;
    PanelCaption: TPanel;
    labCaption: TLabel;
    labCopyright: TLabel;
    labVersion: TLabel;
    PanelImage: TPanel;
    Image1: TImage;
    btnOK: TButton;
    Bevel1: TBevel;
    labUn: TLabel;
    procedure FormShow(Sender: TObject);
    procedure labHomepageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  ATxMsgProc, ATxFProc;

{$R *.DFM}

procedure TFormViewAbout.FormShow(Sender: TObject);
begin
  {$I Lang.FormViewAbout.inc}
end;

procedure TFormViewAbout.labHomepageClick(Sender: TObject);
begin
  FOpenURL('http://www.uvviewsoft.com', Handle);
end;

end.
