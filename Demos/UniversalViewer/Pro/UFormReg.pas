unit UFormReg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormViewReg = class(TForm)
    btnOK: TButton;
    boxInfo: TGroupBox;
    edName: TEdit;
    labName: TLabel;
    labKey: TLabel;
    edKey: TEdit;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  RegisterProc;

{$R *.dfm}

procedure TFormViewReg.FormShow(Sender: TObject);
begin
  edNameChange(Self);
end;

procedure TFormViewReg.btnOKClick(Sender: TObject);
begin
  if EnterRegistrationInfo(edName.Text, edKey.Text) then
  begin
    Application.MessageBox(
      'Registered successfully, thank you.',
      'NavPanel', mb_ok or mb_iconinformation);
    ModalResult := mrOK;
  end
  else
    Application.MessageBox(
      'Wrong registration data.',
      'NavPanel', mb_ok or mb_iconwarning);
end;

procedure TFormViewReg.edNameChange(Sender: TObject);
begin
  btnOK.Enabled := (edName.Text <> '') and (edKey.Text <> '');
end;


//------------------------
var
  RegName: string;
  DaysLeft: integer;
  LicType: TLicType;

initialization
  if not ReadRegistrationInfo(RegName, DaysLeft, LicType) then
   if DaysLeft <= 0 then
   begin
     if MessageBox(0, 'Trial period is expired! Press OK to register.', 
       'NavPanel', mb_okcancel or mb_iconwarning) = IDCANCEL then Halt;
     with TFormViewReg.Create(nil) do
       try
         if ShowModal = mrCancel then Halt;
       finally
         Release
       end
   end;
-------form not used
end.
