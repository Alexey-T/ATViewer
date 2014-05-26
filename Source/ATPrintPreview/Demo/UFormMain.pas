unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Dialogs, ExtDlgs, IniFiles,
  ATPrintPreview,
  ATxPrintProc, XPMan;

type
  TFormMain = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    btnOpen: TButton;
    btnPreview: TButton;
    btnClose: TButton;
    Panel2: TPanel;
    boxMain: TGroupBox;
    Image1: TImage;
    edMm: TComboBox;
    labMm: TLabel;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkMmClick(Sender: TObject);
  private
    { Private declarations }
    FFileName: string;
    FIni: TIniFile;
    FOpt: TATPrintOptions;
    FOldMm: TATPrintUnit;
    procedure LoadImage(const fn: string);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  {$ifdef GIF}
  GIFImage,
  {$endif}
  Jpeg;

{$R *.dfm}

procedure TFormMain.FormShow(Sender: TObject);
begin
  LoadImage(ExtractFilePath(Application.ExeName) + 'Test_image_nature.jpg');
end;

procedure TFormMain.LoadImage(const fn: string);
begin
  try
    FFileName := fn;
    Image1.Picture.LoadFromFile(FFileName);
    btnPreview.Enabled := True;
  except
    Application.MessageBox(
      PChar(Format('Could not load image from "%s"', [FFileName])),
      PChar(Caption), MB_OK or MB_ICONERROR);
  end;
end;

procedure TFormMain.btnOpenClick(Sender: TObject);
begin
  with OpenPictureDialog1 do
    if Execute then
      LoadImage(FileName);
end;

procedure TFormMain.btnPreviewClick(Sender: TObject);
begin
  with FOpt do
  begin
    OptUnit := TATPrintUnit(edMm.ItemIndex);
    OptFooter.Caption := ExtractFileName(FFileName);    
  end;
  ImagePrint(Image1, FOpt);
end;

procedure TFormMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: TATPrintUnit;
begin
  FIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  with edMm do
  begin
    Items.Clear;
    for i := Low(i) to High(i) do
      Items.Add(MsgPreviewDlgUnit[i]);
    ItemIndex := FIni.ReadInteger('Opt', 'Unit', 0);
    FOldMm := TATPrintUnit(ItemIndex);
  end;

  FillChar(FOpt, SizeOf(FOpt), 0);
  with FOpt do
  begin
    Copies := 1;
    OptFit := pFitNormal;
    OptPosition := pPosCenter;
    OptUnit := pUnitMm;

    OptMargins.Left := FIni.ReadFloat('Opt', 'MarginL', 20);
    OptMargins.Top := FIni.ReadFloat('Opt', 'MarginT', 10);
    OptMargins.Right := FIni.ReadFloat('Opt', 'MarginR', 10);
    OptMargins.Bottom :=  FIni.ReadFloat('Opt', 'MarginB', 10);

    OptFit := TATPrintFitMode(FIni.ReadInteger('Opt', 'Fit', 0));
    OptFitSize.x := FIni.ReadFloat('Opt', 'SizeX', 100);
    OptFitSize.y := FIni.ReadFloat('Opt', 'SizeY', 100);
    OptGamma := FIni.ReadFloat('Opt', 'Gamma', 1.0);

    with OptFooter do
    begin
      Enabled := True;
      EnableLine := True;
      FontName := FIni.ReadString('Opt', 'FontName', 'Arial');
      FontSize := FIni.ReadInteger('Opt', 'FontSize', 9);
      FontStyle := TFontStyles(byte(FIni.ReadInteger('Opt', 'FontStyle', 0)));
      FontColor := FIni.ReadInteger('Opt', 'FontColor', clBlack);
      FontCharset := FIni.ReadInteger('Opt', 'FontCharset', DEFAULT_CHARSET);
    end;

    PixelsPerInch := Screen.PixelsPerInch;
    JobCaption := Self.Caption;
    FailOnErrors := True;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FIni.WriteFloat('Opt', 'MarginL', FOpt.OptMargins.Left);
  FIni.WriteFloat('Opt', 'MarginT', FOpt.OptMargins.Top);
  FIni.WriteFloat('Opt', 'MarginR', FOpt.OptMargins.Right);
  FIni.WriteFloat('Opt', 'MarginB', FOpt.OptMargins.Bottom);
  FIni.WriteInteger('Opt', 'Fit', Integer(FOpt.OptFit));
  FIni.WriteFloat('Opt', 'SizeX', FOpt.OptFitSize.x);
  FIni.WriteFloat('Opt', 'SizeY', FOpt.OptFitSize.y);
  FIni.WriteFloat('Opt', 'Gamma', FOpt.OptGamma);
  FIni.WriteString('Opt', 'FontName', FOpt.OptFooter.FontName);
  FIni.WriteInteger('Opt', 'FontSize', FOpt.OptFooter.FontSize);
  FIni.WriteInteger('Opt', 'FontStyle', byte(FOpt.OptFooter.FontStyle));
  FIni.WriteInteger('Opt', 'FontColor', FOpt.OptFooter.FontColor);
  FIni.WriteInteger('Opt', 'FontCharset', FOpt.OptFooter.FontCharset);
  FIni.WriteInteger('Opt', 'Unit', edMm.ItemIndex);
  FreeAndNil(FIni);
end;

procedure EMul(var E: Double; const Mul: Double);
begin
  E := E * Mul;
end;

procedure TFormMain.chkMmClick(Sender: TObject);
var
  M: Extended;
  FNewMm: TATPrintUnit;
begin
  FNewMm := TATPrintUnit(edMm.ItemIndex);
  if FNewMm <> FOldMm then
  begin
    M := cUnitIn[FNewMm] / cUnitIn[FOldMm];
    FOldMm := FNewMm;

    EMul(FOpt.OptMargins.Left, M);
    EMul(FOpt.OptMargins.Top, M);
    EMul(FOpt.OptMargins.Right, M);
    EMul(FOpt.OptMargins.Bottom, M);
    EMul(FOpt.OptFitSize.x, M);
    EMul(FOpt.OptFitSize.y, M);
  end;
end;

end.
