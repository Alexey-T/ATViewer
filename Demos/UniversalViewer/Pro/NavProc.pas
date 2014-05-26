unit NavProc;

interface

procedure CheckParam;

implementation

uses
  SysUtils, Windows, inifiles,
  ATxParamStr, ATxFProc, atxSProc,
  ATxUtilMail, ATxUtilExec,
  ShellAPI, TntDialogs;


procedure MsgErr(const s: string);
begin
  MessageBox(0, PChar(s), 'NavPanel', mb_ok or mb_iconerror);
end;

//-----------------------------
function FCopyW(Handle: THandle; const S1, S2: WideString): boolean;
var
  op: TSHFileOpStructW;
  SFrom, STo: WideString;
begin
  SFrom := S1 + #0#0;
  STo := S2 + #0#0;
  FillChar(op, SizeOf(op), 0);
  op.Wnd := Handle;
  op.wFunc := FO_COPY;
  op.pFrom := PWideChar(SFrom);
  op.pTo := PWideChar(STo);
  op.fFlags := 0;
  Result := SHFileOperationW(op) = 0;
end;

function FCopyA(Handle: THandle; const S1, S2: AnsiString): boolean;
var
  op: TSHFileOpStructA;
  SFrom, STo: AnsiString;
begin
  SFrom := S1 + #0#0;
  STo := S2 + #0#0;
  FillChar(op, SizeOf(op), 0);
  op.Wnd := Handle;
  op.wFunc := FO_COPY;
  op.pFrom := PAnsiChar(SFrom);
  op.pTo := PAnsiChar(STo);
  op.fFlags := 0;
  Result := SHFileOperationA(op) = 0;
end;

function FCopyEx(Handle: THandle; const S1, S2: WideString): boolean;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := FCopyW(Handle, S1, S2)
  else
    Result := FCopyA(Handle, S1, S2);
end;


//-------------------
procedure SParse(var S: WideString; const FN: WideString);
begin
  SReplaceAllW(S, '{FileName}', FN);
  SReplaceAllW(S, '{FileDir}', SExtractFileDir(FN));
  SReplaceAllW(S, '{FileNameShort}', FGetShortName(FN));
  SReplaceAllW(S, '{FileNameOnly}', SExtractFileName(FN));
  SReplaceAllW(S, '{FileNameOnlyShort}', SExtractFileName(FGetShortName(FN)));
end;


procedure SMake(const fn:string);
begin
  with TIniFile.Create(fn) do
  try
    WriteInteger('Op', 'Op', 4);
  finally
    Free;
  end;
end;

//-------------------
procedure CheckParam;
var
  Op: string;
  S, S1, S2, S3, S4: WideString;
  OK: boolean;
begin
  if (ParamCount > 0) and (Pos('op', ParamStr(1)) = 1) then
  begin
    Op := Copy(ParamStr(1), 3, MaxInt);
    S1 := SParamStrW(2);
    S2 := SParamStrW(3);
    S3 := SParamStrW(4);
    S4 := SParamStrW(5);

    if (Op = 'ct') then begin SMake(S1); end;
    if (Op = 'del') then begin FDeleteToRecycle(0, S1) end;
    if (Op = 'move') then begin FFileMove(S1, S2) end;
    if (Op = 'copy') then begin FCopyEx(0, S1, S2) end;
    if (Op = 'mail') then begin FSendEmail(S1, '', '', '', FFileNameWideToAnsi(S2)); end;

    if (Op = 'tool') then
    begin
      S := S2;
      SReplaceAllW(S, '|', '"');
      SParse(S, S3);
      OK := True;
      if (S <> '') and (S[1] = '?') then
      begin
        Delete(S, 1, 1);
        OK := WideInputQuery('NavPanel', SExtractFileName(S1), S);
      end;
      if OK then
        FExecute(S1, S, 0);
    end;

    if (Op = 'conv') then
    begin
      if IsFileExist(SParamDir + '\Conv\xdoc2txt.exe') then
        FExecShell(
          SExpandVars('%ComSpec%'),
          SFormatW('/c xdoc2txt.exe "%s" > "%s"',
            [FFileNameWideToAnsi(S1), S2]),
          SParamDir + '\Conv',
          SW_HIDE,
          True{fWait})
      else
        MsgErr('Cannot find converter');
    end;

    Halt;
  end;

  if (ParamCount < 3) then
  begin
    MessageBox(0, 'This add-on must be started from within Universal Viewer only',
      'NavPanel', mb_ok or mb_iconerror);
    Halt;
  end;
end;

end.
