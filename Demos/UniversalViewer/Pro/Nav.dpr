program Nav;

uses
  Forms,
  UFormNav in 'UFormNav.pas' {FormNavUV},
  RegisterProc in 'RegisterProc.pas',
  NavProc;

{$R *.res}

begin
  CheckParam;
  Application.Initialize;
  Application.Title := 'Navigation Panel';
  Application.CreateForm(TFormNavUV, FormNavUV);
  Application.Run;
end.
