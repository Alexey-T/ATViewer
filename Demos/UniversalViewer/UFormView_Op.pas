unit UFormView_Op;

interface

procedure NavOp(const Op: string;
  const S1, S2: WideString;
  const S3: WideString = '';
  const S4: WideString = '';
  fWait: boolean = True);

implementation

uses
  Windows, ATViewerMsg, ATxMsg,
  ATxParamStr, ATxSProc, ATxFProc, ATxUtilExec;

procedure NavOp;
var
  S: WideString;
begin
  S := SParamDir + '\Nav.exe';
  if IsFileExist(S) then
    FExecShell(S, SFormatW('op%s "%s" "%s" "%s" "%s"', [Op, S1, S2, S3, S4]), '', SW_SHOW, fWait)
  else
    MsgError(MsgViewerNavMissed);
end;
end.





