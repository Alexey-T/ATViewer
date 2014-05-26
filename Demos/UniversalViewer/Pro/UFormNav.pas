unit UFormNav;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ExtCtrls, Menus,

  MPCommonObjects, EasyListview,
  VirtualExplorerEasyListview, VirtualTrees, VirtualExplorerTree, Buttons,
  IniFiles, MPShellUtilities, StdCtrls, ToolWin, VirtualShellToolBar,
  ComCtrls;

const
  EM_DISPLAYBAND = WM_USER + 51;
  cAppHandle = 100;

type
  TFormNavUV = class(TForm)
    Panel1: TPanel;
    Tree: TVirtualExplorerTreeview;
    List: TVirtualExplorerEasyListview;
    MainMenu1: TMainMenu;
    mnuHelp: TMenuItem;
    Splitter1: TSplitter;
    XPManifest1: TXPManifest;
    mnuView: TMenuItem;
    mnuV2: TMenuItem;
    mnuV3: TMenuItem;
    mnuV1: TMenuItem;
    mnuV4: TMenuItem;
    N1: TMenuItem;
    mnuHid: TMenuItem;
    mnuAbout: TMenuItem;
    mnuDock: TMenuItem;
    mnuHorz: TMenuItem;
    Panel2: TPanel;
    mnuComb: TMenuItem;
    Comb: TVirtualExplorerCombobox;
    labFolder: TLabel;
    btnUp: TSpeedButton;
    Drv: TVirtualDriveToolbar;
    mnuDrv: TMenuItem;
    Fold: TVirtualSpecialFolderToolbar;
    mnuFold: TMenuItem;
    N2: TMenuItem;
    Stat: TStatusBar;
    mnuStat: TMenuItem;
    mnuOpenFold: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListItemSelectionChanged(Sender: TCustomEasyListview;
      Item: TEasyItem);
    procedure FormShow(Sender: TObject);
    procedure mnuV1Click(Sender: TObject);
    procedure mnuV2Click(Sender: TObject);
    procedure mnuV3Click(Sender: TObject);
    procedure mnuV4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuHidClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuDockClick(Sender: TObject);
    procedure mnuHorzClick(Sender: TObject);
    procedure ListRootChanging(Sender: TCustomVirtualExplorerEasyListview;
      const NewValue: TRootFolder; const CurrentNamespace,
      Namespace: TNamespace; var Allow: Boolean);
    procedure ListRootChange(Sender: TCustomVirtualExplorerEasyListview);
    procedure FormResize(Sender: TObject);
    procedure mnuCombClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure mnuDrvClick(Sender: TObject);
    procedure mnuFoldClick(Sender: TObject);
    procedure ListCustomColumnAdd(
      Sender: TCustomVirtualExplorerEasyListview;
      AddColumnProc: TELVAddColumnProc);
    procedure ListCustomColumnCompare(
      Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
      Group: TEasyGroup; Item1, Item2: TExplorerItem;
      var CompareResult: Integer);
    procedure ListCustomColumnGetCaption(
      Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
      Item: TExplorerItem; var ACaption: WideString);
    procedure mnuStatClick(Sender: TObject);
    procedure mnuOpenFoldClick(Sender: TObject);
  private
    { Private declarations }
    FWnd: THandle;
    FIniHist: TIniFile;
    FIniLang: TIniFile;
    FLang: string;
    FHidden,
    FDock,
    FOpenFold: boolean;
    FNavSortDir: TEasySortDirection;
    FNavSortColumn: integer;
    FNavColumns: array[0 .. Pred(200)] of record
      Visible: boolean; Width, Position: integer end;
    FNavBusy: boolean;
    FSendBusy: boolean;

    procedure NavBrowse(const S: WideString);
    procedure ListSave;
    procedure ListRestore;
    function GetColumns: string;
    procedure SetColumns(const AValue: string);
    procedure SetFN(const fn: WideString);
    procedure SetView(h: THandle);
    function GetTreeW: integer;
    procedure SetTreeW(Value: integer);
    function GetComb: boolean;
    procedure SetComb(Value: boolean);
    function GetHorz: boolean;
    procedure SetHorz(Value: boolean);
    procedure ReadLang;
    procedure ReadIni;
    procedure SaveIni;
    procedure UpdateSt;
    procedure UpdateStatus;
    //procedure UpdateCaption;
    procedure SetHidden(AValue: boolean);
    procedure SetDockV(AValue: boolean);
    property OpenFold: boolean read FOpenFold write FOpenFold;
    property ShowComb: boolean read GetComb write SetComb;
    property Hidden: boolean read FHidden write SetHidden;
    property DockV: boolean read FDock write SetDockV;
    property TreeW: integer read GetTreeW write SetTreeW;
    property Horz: boolean read GetHorz write SetHorz;
    property Columns: string read GetColumns write SetColumns;
    procedure Dock2Nav;
    procedure Dock2Viewer;
  public
    { Public declarations }
  protected
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMMove(var Msg: TMessage); message WM_MOVE;
    procedure WMDisp(var Msg: TMessage); message EM_DISPLAYBAND;
  end;

var
  FormNavUV: TFormNavUV;

implementation

uses
  ATxParamStr, ATxFProc, ATxSProc,
  VirtualResources, TntSysUtils,
  ShellAPI,
  RegisterProc;

{$R *.dfm}

//--------------------------------------------------------
{
Creating Windows Vista Ready Applications with Delphi
http://www.installationexcellence.com/articles/VistaWithDelphi/Index.html
}
procedure FixFormFont(AFont: TFont);
var
  LogFont: TLogFont;
begin
  if SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont), @LogFont, 0) then
    AFont.Handle := CreateFontIndirect(LogFont)
  else
    AFont.Handle := GetStockObject(DEFAULT_GUI_FONT);
end;

//------------------
(*
procedure TFormNavUV.UpdateCaption;
var
  S: string;
  RegName: string;
  DaysLeft: integer;
  LicType: TLicType;
begin
  if ReadRegistrationInfo(RegName, DaysLeft, LicType) then
  begin
    S := ' - ' + RegName;
    mnuReg.Enabled := False;
  end
  else
  begin
    S := Format(' - %d day(s) left', [DaysLeft]);
    if DaysLeft <=0 then
    begin
      Application.MessageBox(
        'Trial period is expired. Please put .key file into program folder.',
        'NavPanel', mb_ok or mb_iconerror);
      Application.Terminate;
    end;
  end;

  if (RegName = cRName) and (not IsUSSR) then
  begin
    Application.MessageBox(
      'Russian registration can be used only under Russian locale',
      'NavPanel', mb_ok or mb_iconerror);
    Application.Terminate;
  end;

  Application.Title := FIniLang.ReadString('Nav', '200', Caption);
  Caption := Application.Title + S;
end;
*)

procedure TFormNavUV.ReadLang;
begin
  //UpdateCaption;
  with btnUp do Hint := FIniLang.ReadString('Nav', '201', Hint);
  with mnuView do Caption := FIniLang.ReadString('Nav', '202', Caption);
  with mnuV1 do Caption := FIniLang.ReadString('Nav', '211', Caption);
  with mnuV2 do Caption := FIniLang.ReadString('Nav', '212', Caption);
  with mnuV3 do Caption := FIniLang.ReadString('Nav', '213', Caption);
  with mnuV4 do Caption := FIniLang.ReadString('Nav', '214', Caption);
  with mnuHid do Caption := FIniLang.ReadString('Nav', '216', Caption);
  with mnuHorz do Caption := FIniLang.ReadString('Nav', '215', Caption);
  with mnuDock do Caption := FIniLang.ReadString('Nav', '217', Caption);
  with mnuComb do Caption := FIniLang.ReadString('Nav', '218', Caption);

  with Drv do Caption := FIniLang.ReadString('Nav', '207', Caption);
  with mnuDrv do Caption := FIniLang.ReadString('Nav', '219', Caption);
  with mnuFold do Caption := FIniLang.ReadString('Nav', '220', Caption);
  with mnuStat do Caption := FIniLang.ReadString('Nav', '221', Caption);
  with mnuOpenFold do Caption := FIniLang.ReadString('Nav', '222', Caption);

  with mnuHelp do Caption := FIniLang.ReadString('Nav', '203', Caption);
  //with mnuReg do Caption := FIniLang.ReadString('Nav', '204', Caption);
  with mnuAbout do Caption := FIniLang.ReadString('Nav', '205', Caption);
  with labFolder do Caption := FIniLang.ReadString('Nav', '206', Caption);
  with List.BackGround do Caption := FIniLang.ReadString('Nav', '210', Caption);

  STR_HEADERMENUMORE:= FIniLang.ReadString('Captions', '780', '');
  STR_COLUMNMENU_MORE:= STR_HEADERMENUMORE;
  STR_COLUMNDLG_CAPTION:= FIniLang.ReadString('Captions', '781', '');
  STR_COLUMNDLG_LABEL1:= FIniLang.ReadString('Captions', '782', '');
  STR_COLUMNDLG_LABEL2:= FIniLang.ReadString('Captions', '783', '');
  STR_COLUMNDLG_LABEL3:= FIniLang.ReadString('Captions', '784', '');
  STR_COLUMNDLG_CHECKBOXLIVEUPDATE:= FIniLang.ReadString('Captions', '785', '');
  STR_COLUMNDLG_BUTTONOK:= FIniLang.ReadString('Captions', '350', '');
  STR_COLUMNDLG_BUTTONCANCEL:= FIniLang.ReadString('Captions', '351', '');
end;

//-----------------------------
procedure TFormNavUV.ReadIni;
var
  R: TRect;
begin
  R := BoundsRect;
  R.Left := FIniHist.ReadInteger('Nav', 'Left', R.Left);
  R.Top := FIniHist.ReadInteger('Nav', 'Top', R.Top);
  R.Right := FIniHist.ReadInteger('Nav', 'Right', R.Right);
  R.Bottom := FIniHist.ReadInteger('Nav', 'Bottom', R.Bottom);
  BoundsRect := R;

  TreeW := FIniHist.ReadInteger('Nav', 'TreeWidth', TreeW);
  List.View := TEasyListStyle(FIniHist.ReadInteger('Nav', 'ListView', integer(List.View)));

  FNavSortDir := TEasySortDirection(FIniHist.ReadInteger('Nav', 'SortDir', integer(esdAscending)));
  FNavSortColumn := FIniHist.ReadInteger('Nav', 'SortCol', 2);
  Columns := FIniHist.ReadString('Nav', 'Columns', '');
  ListRestore;

  OpenFold := FIniHist.ReadBool('Nav', 'OpenFold', False);
  Hidden := FIniHist.ReadBool('Nav', 'Hidden', False);
  DockV := FIniHist.ReadBool('Nav', 'DockV', False);
  Horz := FIniHist.ReadBool('Nav', 'Horz', False);
  ShowComb := FIniHist.ReadBool('Nav', 'Comb', True);
  Drv.Visible := FIniHist.ReadBool('Nav', 'Drv', True);
  Fold.Visible := FIniHist.ReadBool('Nav', 'Fold', True);
  Stat.Visible := FIniHist.ReadBool('Nav', 'Stat', True);
  UpdateSt;
end;

procedure TFormNavUV.SaveIni;
var
  R: TRect;
begin
  R := BoundsRect;
  FIniHist.WriteInteger('Nav', 'Left', R.Left);
  FIniHist.WriteInteger('Nav', 'Top', R.Top);
  FIniHist.WriteInteger('Nav', 'Right', R.Right);
  FIniHist.WriteInteger('Nav', 'Bottom', R.Bottom);
  FIniHist.WriteInteger('Nav', 'TreeWidth', TreeW);
  FIniHist.WriteInteger('Nav', 'ListView', integer(List.View));
  FIniHist.WriteBool('Nav', 'OpenFold', OpenFold);
  FIniHist.WriteBool('Nav', 'Hidden', Hidden);
  FIniHist.WriteBool('Nav', 'DockV', DockV);
  FIniHist.WriteBool('Nav', 'Horz', Horz);
  FIniHist.WriteBool('Nav', 'Comb', ShowComb);
  FIniHist.WriteBool('Nav', 'Drv', Drv.Visible);
  FIniHist.WriteBool('Nav', 'Fold', Fold.Visible);
  FIniHist.WriteBool('Nav', 'Stat', Stat.Visible);

  ListSave;
  FIniHist.WriteInteger('Nav', 'SortDir', integer(FNavSortDir));
  FIniHist.WriteInteger('Nav', 'SortCol', FNavSortColumn);
  FIniHist.WriteString('Nav', 'Columns', Columns);
end;

//-----------------------------
procedure TFormNavUV.FormCreate(Sender: TObject);
begin
  FNavBusy := False;
  FSendBusy := False;

  FWnd := StrToIntDef(ParamStr(1), 0);
  if FWnd = 0 then
    FWnd := FindWindow('TFormViewUV.UnicodeClass', nil);
  if FWnd = 0 then
  begin
    Application.MessageBox(
      'Cannot find Universal Viewer window',
      'NavPanel', mb_ok or mb_iconerror);
    Application.Terminate;
  end;

  FLang := ParamStr(2);
  FIniLang := TIniFile.Create(SLangFN(FLang));
  FIniHist := TIniFile.Create(SParamStrW(3));

  ReadLang;
  ReadIni;

  FixFormFont(Tree.Font);
  FixFormFont(List.Font);
  FixFormFont(List.Header.Font);

  Comb.Left := labFolder.Left + labFolder.Width + 6;
  Comb.Width := btnUp.Left - Comb.Left - 2;
end;

//------------------------
procedure TFormNavUV.SetFN(const fn: WideString);
var
  Data: TCopyDataStruct;
begin
  if FNavBusy then Exit;
  if fn <> '' then
  try
    FSendBusy := True;
    FillChar(Data, SizeOf(Data), 0);
    Data.dwData := 101; //"Open Unicode filename"
    Data.cbData := (Length(fn) + 1) * 2;
    Data.lpData := PWChar(fn);

    SetWindowPos(FWnd, Handle,
      0, 0, 0, 0,
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    SendMessage(FWnd, WM_COPYDATA, Handle, integer(@Data));
  finally
    FSendBusy := False;
  end;
end;

procedure TFormNavUV.SetView(h: THandle);
begin
  SendMessage(FWnd, EM_DISPLAYBAND, cAppHandle, h);
end;

//---------------------------
procedure TFormNavUV.ListItemSelectionChanged(Sender: TCustomEasyListview;
  Item: TEasyItem);
var
  NS: TNameSpace;
begin
  Stat.SimpleText := '';
  if Assigned(Item) and Item.Selected then
  begin
    NS := TExplorerItem(Item).Namespace;
    if NS.FileSystem then
      if OpenFold or IsFileExist(NS.NameForParsing) then
      begin
        Stat.SimpleText := ' ' + NS.DetailsDefaultOf(1) + '  ' + NS.DetailsDefaultOf(3);
        SetFN(NS.NameForParsing);
      end;
  end;
end;

//---------------------------------------------------------------
procedure TFormNavUV.FormShow(Sender: TObject);
begin
  UpdateStatus;
  SetView(Handle);
  Tree.Active := True;
  List.Active := True;
  Comb.Active := True;
  try
    //FNavBusy := True;
    //FSendBusy := true;
    NavBrowse(SParamStrW(4));
  finally
    //FNavBusy := false;
    //FSendBusy := false;
  end;
end;

procedure TFormNavUV.UpdateStatus;
begin
  Fold.Top := Stat.Top - 40;
end;

procedure TFormNavUV.mnuV1Click(Sender: TObject);
begin
  List.View := elsIcon;
  UpdateSt;
end;

procedure TFormNavUV.mnuV2Click(Sender: TObject);
begin
  List.View := elsList;
  UpdateSt;
end;

procedure TFormNavUV.mnuV3Click(Sender: TObject);
begin
  List.View := elsReport;
  UpdateSt;
end;

procedure TFormNavUV.mnuV4Click(Sender: TObject);
begin
  List.View := elsThumbnail;
  UpdateSt;
end;

procedure TFormNavUV.mnuHidClick(Sender: TObject);
begin
  Hidden := not Hidden;
  UpdateSt;
end;

procedure TFormNavUV.mnuHorzClick(Sender: TObject);
begin
  Horz := not Horz;
  UpdateSt;
end;

procedure TFormNavUV.mnuDockClick(Sender: TObject);
begin
  DockV := not DockV;
  UpdateSt;
end;

procedure TFormNavUV.UpdateSt;
begin
  UpdateStatus;
  mnuV1.Checked := List.View = elsIcon;
  mnuV2.Checked := List.View = elsList;
  mnuV3.Checked := List.View = elsReport;
  mnuV4.Checked := List.View = elsThumbnail;
  mnuHid.Checked := Hidden;
  mnuOpenFold.Checked := OpenFold;
  mnuHorz.Checked := Horz;
  mnuComb.Checked := ShowComb;
  mnuDrv.Checked := Drv.Visible;
  mnuFold.Checked := Fold.Visible;
  mnuStat.Checked := Stat.Visible;
  mnuDock.Checked := DockV;
end;

procedure TFormNavUV.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_ESCAPE) or (Key = VK_F4)) and (Shift = []) then
    Close;
end;

procedure TFormNavUV.FormDestroy(Sender: TObject);
begin
  if Assigned(FIniHist) then
  begin
    SaveIni;
    FreeAndNil(FIniHist);
    FreeAndNil(FIniLang);
  end;
end;

procedure TFormNavUV.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetView(0);
end;

procedure TFormNavUV.SetHidden(AValue: boolean);
begin
  FHidden := AValue;
  with Tree do
  begin
    FileObjects:= FileObjects - [foHidden];
    if AValue then
      FileObjects:= FileObjects + [foHidden];
  end;
  with List do
  begin
    FileObjects:= FileObjects - [foHidden];
    if AValue then
      FileObjects:= FileObjects + [foHidden];
  end;
end;

procedure TFormNavUV.SetDockV(AValue: boolean);
var
  Plc: TWindowPlacement;
  R: TRect;
begin
  FDock := AValue;
  if FDock then
  begin
    FillChar(Plc, SizeOf(Plc), 0);
    Plc.length := SizeOf(Plc);
    GetWindowPlacement(FWnd, @Plc);
    R := Plc.rcNormalPosition;
    if R.Left < Width then
    begin
      SetWindowPos(FWnd, HWND_TOP,
        Width, R.Top, R.Right - R.Left, R.Bottom - R.Top,
        SWP_SHOWWINDOW);
      R.Left := Width;
    end;
    SetBounds(R.Left - Width, R.Top, Width, R.Bottom - R.Top);
  end;
end;

//-------------
procedure TFormNavUV.Dock2Nav;
var
  Plc: TWindowPlacement;
  R: TRect;
begin
  FillChar(Plc, SizeOf(Plc), 0);
  Plc.length := SizeOf(Plc);
  GetWindowPlacement(FWnd, @Plc);
  R := Plc.rcNormalPosition;

  if Plc.ShowCmd = SW_SHOWMAXIMIZED then
  begin
    Plc.ShowCmd := SW_SHOWNORMAL;
    SetWindowPlacement(FWnd, @Plc);
  end;

  SetWindowPos(FWnd, Handle,
    0, 0, 0, 0,
    SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(FWnd, 0,
    Left + Width, Top, R.Right - R.Left, Height,
    SWP_NOACTIVATE);
end;

procedure TFormNavUV.Dock2Viewer;
var
  Plc: TWindowPlacement;
  R: TRect;
begin
  FillChar(Plc, SizeOf(Plc), 0);
  Plc.length := SizeOf(Plc);
  GetWindowPlacement(FWnd, @Plc);
  R := Plc.rcNormalPosition;
  SetBounds(R.Left - Width, R.Top, Width, R.Bottom - R.Top);
end;

//--------------------------------
procedure TFormNavUV.mnuAboutClick(Sender: TObject);
const
  cr = #13;
(*var
  S: string;
  RegName: string;
  DaysLeft: integer;
  LicType: TLicType;*)
begin
  (*
  if ReadRegistrationInfo(RegName, DaysLeft, LicType) then
    S := 'Registered to:' +cr+ RegName +cr+ cLicName[LicType]
  else
    S := 'Unregistered,' +cr+ Inttostr(DaysLeft) + ' day(s) left';
  *)

  Application.MessageBox(PChar(
    'Navigation Panel for Universal Viewer' +cr+
    'Copyright © UVViewSoft'),
    'NavPanel', mb_ok or mb_iconinformation);
end;

//-----------------------
function TFormNavUV.GetTreeW: integer;
begin
  if Tree.Align = alLeft then
    Result := Tree.Width
  else
    Result := Tree.Height;
end;

procedure TFormNavUV.SetTreeW(Value: integer);
begin
  if Tree.Align = alLeft then
    Tree.Width := Value
  else
    Tree.Height := Value;
end;

//-----------------------
function TFormNavUV.GetHorz: boolean;
begin
  Result := Tree.Align <> alLeft;
end;

procedure TFormNavUV.SetHorz(Value: boolean);
const
  Al: array[boolean] of TAlign = (alLeft, alTop);
var
  w: integer;
begin
  w := TreeW;
  Tree.Align := Al[Value];
  Splitter1.Align := Al[Value];
  TreeW := w;

  if Value then
    Splitter1.Top := Tree.Top + 4
  else
    Splitter1.Left := Tree.Left + 4;
end;

//------------------------
function TFormNavUV.GetColumns: string;
var
  n, n1, n2, n3: integer;
begin
  Result:= '';
  for n := 0 to High(FNavColumns) do
  begin
    with FNavColumns[n] do
    begin
      n1 := integer(Visible);
      n2 := Width;
      n3 := Position;
    end;
    if (n1 = 0) and (n2 = 0) and (n3 = 0) then Break;
    Result := Result + Format('%d,%d,%d,', [n1, n2, n3]);
  end;
end;

function SGetItem(var SList: string): string;
var
  k: integer;
begin
  k := Pos(',', SList);
  if k = 0 then k := MaxInt;
  Result := Copy(SList, 1, k - 1);
  Delete(SList, 1, k);
end;

procedure TFormNavUV.SetColumns(const AValue: string);
var
  S: string;
  n, n1, n2, n3: integer;
begin
  S:= AValue;
  for n := 0 to High(FNavColumns) do
  begin
    n1 := StrToIntDef(SGetItem(S), 0);
    n2 := StrToIntDef(SGetItem(S), 0);
    n3 := StrToIntDef(SGetItem(S), 0);
    if (n1 = 0) and (n2 = 0) and (n3 = 0) then Break;
    with FNavColumns[n] do
    begin
      Visible := boolean(n1);
      Width := n2;
      Position := n3;
    end;
  end;
end;

//--------------------------
procedure TFormNavUV.ListRestore;
var
  i: integer;
begin
  with List do
    if RootFolderNamespace.FileSystem then
    begin
      for i := 0 to Header.Columns.Count - 1 do
        if FNavSortColumn = i then
          Header.Columns[i].SortDirection := FNavSortDir
        else
          Header.Columns[i].SortDirection := esdNone;

      for i := 0 to Header.Columns.Count - 1 do
        if i <= High(FNavColumns) then
          with FNavColumns[i] do
            if not ((Visible = False) and (Width = 0) and (Position = 0)) then
            begin
              Header.Columns[i].Visible := Visible;
              Header.Columns[i].Width := Width;
              Header.Columns[i].Position := Position;
            end;
    end;
end;

procedure TFormNavUV.ListSave;
var
  i: integer;
begin
  with List do
  begin
    for i:= 0 to Header.Columns.Count - 1 do
      if Header.Columns[i].SortDirection <> esdNone then
      begin
        FNavSortColumn:= i;
        FNavSortDir:= Header.Columns[i].SortDirection;
        Break
      end;

    FillChar(FNavColumns, SizeOf(FNavColumns), 0);
    for i:= 0 to Header.Columns.Count - 1 do
      if i <= High(FNavColumns) then
      begin
        FNavColumns[i].Visible:= Header.Columns[i].Visible;
        FNavColumns[i].Width:= Header.Columns[i].Width;
        FNavColumns[i].Position:= Header.Columns[i].Position;
      end;
  end;
end;

//---------------------------
procedure TFormNavUV.ListRootChanging(
  Sender: TCustomVirtualExplorerEasyListview; const NewValue: TRootFolder;
  const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
begin
  if Assigned(CurrentNamespace) then
    if CurrentNamespace.FileSystem then
      ListSave;
end;

procedure TFormNavUV.ListRootChange(
  Sender: TCustomVirtualExplorerEasyListview);
begin
  ListRestore;
end;

//-------------------------
procedure TFormNavUV.WMCopyData(var Msg: TWMCopyData);
var
  S: WideString;
begin
  Msg.Result := 1;
  if FSendBusy then Exit;

  with Msg.CopyDataStruct^ do
    case dwData of
      101: //"Open Unicode filename"
        S := WideString(PWideChar(lpData));
      else
        S := '';
    end;

  try
    FNavBusy := True;
    NavBrowse(S);
  finally
    FNavBusy := False;
  end;
end;

//-------------------------
procedure TFormNavUV.NavBrowse(const S: Widestring);
begin
  if S <> '' then
    if IsDirExist(S) then
      Tree.BrowseTo(S, False)
    else
      List.BrowseTo(S);
end;

procedure TFormNavUV.ListCustomColumnAdd(
  Sender: TCustomVirtualExplorerEasyListview;
  AddColumnProc: TELVAddColumnProc);
var
  Column: TExplorerColumn;
begin
  Column := AddColumnProc;
  Column.Caption := '.Ext';
  Column.Width := 60;
  Column.Alignment := taLeftJustify;
  Column.Visible := True;
end;

function FExt(Item: TExplorerItem): WideString;
begin
  Result := '';
  if Assigned(Item) and Assigned(Item.Namespace) then
    if not Item.Namespace.Folder then
      Result := WideLowerCase(WideExtractFileExt(Item.Namespace.NameForParsing));
end;

function FName(Item: TExplorerItem): WideString;
begin
  Result := '';
  if Assigned(Item) and Assigned(Item.Namespace) then
    Result := WideExtractFileName(Item.Namespace.NameForParsing);
end;

procedure TFormNavUV.ListCustomColumnCompare(
  Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
  Group: TEasyGroup; Item1, Item2: TExplorerItem;
  var CompareResult: Integer);
begin
  CompareResult := WideCompareStr(FExt(Item1), FExt(Item2));
  if CompareResult = 0 then
    CompareResult := WideCompareStr(FName(Item1), FName(Item2));
  if Column.SortDirection = esdDescending then
    CompareResult := -CompareResult;
end;

procedure TFormNavUV.ListCustomColumnGetCaption(
  Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
  Item: TExplorerItem; var ACaption: WideString);
begin
  ACaption := FExt(Item);
end;

procedure TFormNavUV.FormResize(Sender: TObject);
begin
  if FDock then
    Dock2Nav;
end;

procedure TFormNavUV.WMMove;
begin
  FormResize(Self);
end;

procedure TFormNavUV.WMDisp(var Msg: TMessage);
begin
  Msg.Result := 1;
  {
  if Msg.WParam = cAppRestore then
    Application.Restore;}

  if FDock then
    Dock2Viewer;
end;

function TFormNavUV.GetComb: boolean;
begin
  Result := Panel2.Visible;
end;

procedure TFormNavUV.SetComb(Value: boolean);
begin
  Panel2.Visible := Value;
end;

procedure TFormNavUV.mnuCombClick(Sender: TObject);
begin
  ShowComb := not ShowComb;
  UpdateSt;
end;

procedure TFormNavUV.btnUpClick(Sender: TObject);
begin
  List.BrowseToPrevLevel;
end;

procedure TFormNavUV.mnuDrvClick(Sender: TObject);
begin
  Drv.Visible := not Drv.Visible;
  UpdateSt;
end;

procedure TFormNavUV.mnuFoldClick(Sender: TObject);
begin
  Fold.Visible := not Fold.Visible;
  UpdateSt;
end;

procedure TFormNavUV.mnuStatClick(Sender: TObject);
begin
  Stat.Visible := not Stat.Visible;
  UpdateSt;
end;

procedure TFormNavUV.mnuOpenFoldClick(Sender: TObject);
begin
  OpenFold := not OpenFold;
  UpdateSt;
end;

function L(const s: WideString): Widestring;
var
  p: TSHFileInfoW;
begin
  Fillchar(p, sizeof(p), 0);
  SHGetFileInfoW(PAnsiChar(PWIdeChar(s)), 0, p, sizeof(p), SHGFI_DISPLAYNAME);
  Result:= p.szDisplayName;
end;

end.
