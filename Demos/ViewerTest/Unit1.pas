unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, ATViewer, StdCtrls, TntDialogs,
  TntStdCtrls;

type
  TForm1 = class(TForm)
    boxViewer: TGroupBox;
    V: TATViewer;
    Panel1: TPanel;
    ed: TTntEdit;
    TntOpenDialog1: TTntOpenDialog;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses atxSproc;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  with TntOpendialog1 do
    if Execute then
    begin
      ed.Text:= Filename;
      V.Open(Filename);
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  V.Open('');
end;

procedure TForm1.FormCreate(Sender: TObject);
var fn: Widestring;
begin
  ATViewerOptions.ExtInet:= 'htm,html,mht,xml';

  //fn:= GetModuleName(HInstance);
  //fn:= SExtractFileDir(fn) + '\PdfDll\slister.dll';
  fn:= 'c:\ProgView\Demos\OcxTest\PdfDll\slister.dll';
  if not FileExists(fn) then
    begin ShowMessage('Not found: '+ fn); Exit end;
    
  V.InitPluginsParams(Self, SExpandVars('%AppData%\lsplugin.ini'));
  V.AddPlugin(fn, 'ext:pdf');

  V.Open('D:\Office\Acrobat _.pdf');
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  V.ResizeActivePlugin(boxViewer.ClientRect);
end;

end.
