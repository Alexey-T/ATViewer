unit UFormViewOptionsGutter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormViewOptionsGutter = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Bevel1: TBevel;
    boxGutter: TGroupBox;
    chkShowGutter: TCheckBox;
    chkShowLines: TCheckBox;
    chkLineExt: TCheckBox;
    edLineExt: TEdit;
    edLineSize: TEdit;
    labLineKb: TLabel;
    labLineSize: TLabel;
    btnFont: TButton;
    labFontShow: TLabel;
    labFont: TLabel;
    FontDialog1: TFontDialog;
    labLineCount: TLabel;
    edLineCount: TEdit;
    labLineStep: TLabel;
    edLineStep: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure chkShowLinesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ffFontName: string;
    ffFontSize: integer;
    ffFontColor: TColor;
    ffFontStyle: TFontStyles;
    ffFontCharset: TFontCharSet;
  end;


implementation

uses
  ATxMsgProc, ATViewerMsg;

{$R *.DFM}

procedure TFormViewOptionsGutter.FormShow(Sender: TObject);
begin
  {$I Lang.FormViewOptionsGutter.inc}

  labFontShow.Caption:= ffFontName + ', ' + IntToStr(ffFontSize);
  chkShowLinesClick(Self);
end;

procedure TFormViewOptionsGutter.btnFontClick(Sender: TObject);
begin
  with FontDialog1 do
    begin
    Font.Name:= ffFontName;
    Font.Size:= ffFontSize;
    Font.Color:= ffFontColor;
    Font.Style:= ffFontStyle;
    Font.CharSet:= ffFontCharset;
    if Execute then
      begin
      ffFontName:= Font.Name;
      ffFontSize:= Font.Size;
      ffFontColor:= Font.Color;
      ffFontStyle:= Font.Style;
      ffFontCharset:= Font.CharSet;
      labFontShow.Caption:= ffFontName + ', ' + IntToStr(ffFontSize);
      end;
    end;
end;

procedure TFormViewOptionsGutter.chkShowLinesClick(Sender: TObject);
var
  En: boolean;
begin
  En:= chkShowLines.Checked;
  btnFont.Enabled:= En;
  labFont.Enabled:= En;
  labFontShow.Enabled:= En;
  chkLineExt.Enabled:= En;
  edLineExt.Enabled:= En;
  edLineSize.Enabled:= En;
  edLineCount.Enabled:= En;
  edLineStep.Enabled:= En;
  labLineKb.Enabled:= En;
  labLineSize.Enabled:= En;
  labLineCount.Enabled:= En;
  labLineStep.Enabled:= En;
end;

end.
