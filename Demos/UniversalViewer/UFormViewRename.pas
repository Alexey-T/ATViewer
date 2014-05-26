unit UFormViewRename;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TFormViewRename = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edName: TTntEdit;
    labRename: TLabel;
    edExt: TTntEdit;
    Label1: TLabel;
    procedure edNameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FOldName: WideString;
  public
    { Public declarations }
    function GetFN: Widestring;
  end;

implementation

uses
  ATxMsgProc, ATxSProc;

{$R *.dfm}

procedure TFormViewRename.edNameChange(Sender: TObject);
begin
  btnOK.Enabled:= (edName.Text <> '') and (GetFN <> FOldName);
end;

procedure TFormViewRename.FormShow(Sender: TObject);
begin
  {$I Lang.FormViewRename.inc}
  FOldName:= GetFN;
  edNameChange(Self);
end;

function TFormViewRename.GetFN: Widestring;
begin
  Result:= edName.Text;
  if edExt.Text<>'' then
    Result:= Result+'.'+edExt.Text;
end;

end.
