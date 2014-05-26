unit ATxUtilExec;

interface

function FExecShell(const cmd, params, dir: WideString; ShowCmd: integer; fWait: boolean): boolean;

implementation

uses
  Windows, SysUtils, ShellApi;

//------------------------
function FExecShellA(const cmd, params, dir: AnsiString; ShowCmd: integer; fWait: boolean): boolean;
var
  si: TShellExecuteInfoA;
begin
  FillChar(si, SizeOf(si), 0);
  si.cbSize := SizeOf(si);
  si.fMask := SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
  si.lpFile := PAnsiChar(cmd);
  si.lpParameters := PAnsiChar(params);
  si.lpDirectory := PAnsiChar(dir);
  si.nShow := ShowCmd;
  Result := ShellExecuteExA(@si);
  if Result then
    if fWait then
      WaitForSingleObject(si.hProcess, INFINITE);
end;

function FExecShellW(const cmd, params, dir: WideString; ShowCmd: integer; fWait: boolean): boolean;
var
  si: TShellExecuteInfoW;
begin
  FillChar(si, SizeOf(si), 0);
  si.cbSize := SizeOf(si);
  si.fMask := SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
  si.lpFile := PWChar(cmd);
  si.lpParameters := PWChar(params);
  si.lpDirectory := PWChar(dir);
  si.nShow := ShowCmd;
  Result := ShellExecuteExW(@si);
  if Result then
    if fWait then
      WaitForSingleObject(si.hProcess, INFINITE);
end;

function FExecShell(const cmd, params, dir: WideString; ShowCmd: integer; fWait: boolean): boolean;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := FExecShellW(cmd, params, dir, ShowCmd, fWait)
  else
    Result := FExecShellA(cmd, params, dir, ShowCmd, fWait);
end;

end.
