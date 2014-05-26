program PrintPreviewDemo;

uses
  Forms,
  UFormMain in 'UFormMain.pas' {FormMain},
  ATPrintPreview in '..\Source\ATPrintPreview.pas' {FormATPreview},
  ATxPrintProc in '..\Source\ATxPrintProc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ATPrintPreview Demo';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
