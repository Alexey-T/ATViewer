unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ATFileNotification, ExtCtrls, XPMan, Filectrl;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    EditDir: TEdit;
    btnBrowseDir: TButton;
    EditFile: TEdit;
    btnBrowseFile: TButton;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    Bevel1: TBevel;
    btnWatchDir: TButton;
    btnWatchFile: TButton;
    Bevel2: TBevel;
    btnClose: TButton;
    Notif: TATFileNotification;
    GroupBox1: TGroupBox;
    chkSubtree: TCheckBox;
    chkFilenames: TCheckBox;
    chkDirnames: TCheckBox;
    chkAttr: TCheckBox;
    chkSize: TCheckBox;
    chkModif: TCheckBox;
    XPManifest1: TXPManifest;
    procedure btnBrowseDirClick(Sender: TObject);
    procedure btnBrowseFileClick(Sender: TObject);
    procedure btnWatchDirClick(Sender: TObject);
    procedure btnWatchFileClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure DirChanged(Sender: TObject);
  private
    { Private declarations }
    procedure NotifyDir;
    procedure NotifyFile;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}

procedure TFormMain.NotifyDir;
begin
  with Notif do
    begin
    Stop;
    Directory:= EditDir.Text;
    Subtree:= chkSubtree.Checked;
    Options:= [];
    if chkFilenames.Checked then Options:= Options+[foNotifyFilename];
    if chkDirnames.Checked then Options:= Options+[foNotifyDirname];
    if chkAttr.Checked then Options:= Options+[foNotifyAttributes];
    if chkSize.Checked then Options:= Options+[foNotifySize];
    if chkModif.Checked then Options:= Options+[foNotifyLastWrite];
    Start;
    end;
end;

procedure TFormMain.NotifyFile;
begin
  with Notif do
    begin
    Stop;
    FileName:= EditFile.Text;
    Options:= [];
    if chkFilenames.Checked then Options:= Options+[foNotifyFilename];
    if chkDirnames.Checked then Options:= Options+[foNotifyDirname];
    if chkAttr.Checked then Options:= Options+[foNotifyAttributes];
    if chkSize.Checked then Options:= Options+[foNotifySize];
    if chkModif.Checked then Options:= Options+[foNotifyLastWrite];
    Start;
    end;
end;

procedure TFormMain.DirChanged(Sender: TObject);
begin
  Application.MessageBox('Dir/file has been changed', 'Notification', MB_ICONWARNING or MB_TOPMOST);
end;

procedure TFormMain.btnBrowseDirClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('Directory to watch:', '', Dir) then
    EditDir.Text:= Dir;
end;

procedure TFormMain.btnBrowseFileClick(Sender: TObject);
begin
  with OpenDialog1 do
    if Execute then
      begin
      EditFile.Text:= FileName;
      end;
end;

procedure TFormMain.btnWatchDirClick(Sender: TObject);
begin
  if EditDir.Text<>'' then
    NotifyDir;
end;

procedure TFormMain.btnWatchFileClick(Sender: TObject);
begin
  if EditFile.Text<>'' then
    NotifyFile;
end;

procedure TFormMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
