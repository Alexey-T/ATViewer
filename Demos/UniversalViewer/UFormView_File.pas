//------------------------
procedure TFormViewUV.DoFileRename;
var
  OldName, NewName,
  NewNameFull: WideString;
begin
  OldName:= FFileName;
  NewName:= '';

  with TFormViewRename.Create(nil) do
    try
      edName.Text:= WideChangeFileExt(SExtractFileName(OldName), '');
      edExt.Text:= Copy(SExtractFileExt(OldName), 2, MaxInt);
      if ShowModal = mrOk then
        NewName:= GetFN;
    finally
      Release;
    end;

  if NewName <> '' then
    begin
    CloseFile;

    //Wait for PDF
    repeat Sleep(FFileMoveDelay) until not Viewer.WebBusy;

    NewNameFull:= SExtractFilePath(OldName) + NewName;

    NavOp('move', OldName, NewNameFull);
    if IsFileExist(NewNameFull) then
      begin
      LoadFile(NewNameFull);
      end
    else
      begin
      MsgCopyMoveError(OldName, NewName, Handle);
      LoadFile(OldName);
      end;
    end;
end;

//---------------------------------------------------------------
procedure TFormViewUV.DoFileCopy;
var
  OldName, NewName, DestDir: WideString;
begin
  DestDir:= WideExtractFileDir(FFileName);
  if WideSelectDirectory(mnuFileCopy.Caption, '', DestDir) then
    begin
    OldName:= FFileName;
    NewName:= DestDir + '\' + WideExtractFileName(OldName);

    NavOp('copy', OldName, NewName);
    if not IsFileExist(NewName) then
      MsgCopyMoveError(OldName, NewName, Handle);
    end;
end;

//---------------------------------------------------------------
procedure TFormViewUV.DoFileMove;
var
  OldName, NewName,
  NextName, DestDir: WideString;
begin
  DestDir:= WideExtractFileDir(FFileName);
  if WideSelectDirectory(mnuFileMove.Caption, '', DestDir) then
    begin
    OldName:= FFileName;
    NewName:= DestDir + '\' + WideExtractFileName(OldName);

    NextName:= FFileList.GetNext(OldName, nfNext);
    if SCompareIW(NextName, OldName) = 0 then
      NextName:= '';

    CloseFile;

    //Wait for PDF
    repeat Sleep(FFileMoveDelay) until not Viewer.WebBusy;

    NavOp('move', OldName, NewName);
    if IsFileExist(NewName) then
      begin
      LoadFile(NextName);
      end
    else
      begin
      MsgCopyMoveError(OldName, NewName, Handle);
      LoadFile(OldName);
      end;
    end;
end;

//------------------------
procedure TFormViewUV.DoFileDelete;
var
  OldName, NewName: WideString;
begin
  OldName:= FFileName;

  if MsgBox(
       SFormatW(MsgViewerDeleteWarningRecycle, [SExtractFileName(OldName)]),
       MsgViewerDeleteCaption,
       MB_OKCANCEL or MB_ICONWARNING,
       Handle
       ) = IDOK then
    begin
    NewName:= FFileList.GetNext(OldName, nfNext);
    if UpperCase(NewName) = UpperCase(OldName) then
      NewName:= '';

    CloseFile(true{Keep});
    NavOp('del', OldName, '');

    if not IsFileExist(OldName) then
      begin
      FFileList.Delete(OldName);
      if NewName <> '' then
      begin
        FFileList.GetNext(NewName, nfCurrent); //Upd index
        LoadFile(NewName, true{Keep});
      end;
      end
    else
      begin
      MsgDeleteError(OldName, Handle);
      LoadFile(OldName, true);
      end;
    end;
end;







