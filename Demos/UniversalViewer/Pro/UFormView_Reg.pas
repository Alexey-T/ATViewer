unit UFormView_Reg;

interface

implementation

(*
uses Windows, SysUtils, Forms,
  UFormView_Op,
  ATxParamStr, ATxUtilExec, IniFiles;
*)

(*
function TestTemp(const fn: string): boolean;
begin
  FileSetAttr(fn, 0);
  DeleteFile(fn);
  NavOp('ct', fn, '');
  with TInifile.create(fn) do
  try
    Result:= ReadInteger('Op', 'Op', 0)=4;
  finally
    Free;
  end;
  DeleteFile(fn);
end;
*)

end.
