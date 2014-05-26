[Setup]
AppName=Universal Viewer Free
AppVersion=5.7.3.0
AppPublisher=UVViewSoft
AppPublisherURL=http://uvviewsoft.com
AppSupportURL=http://uvviewsoft.com/support.htm
DefaultDirName={pf}\Universal Viewer
DefaultGroupName=Universal Viewer
DisableProgramGroupPage=yes
OutputDir=C:\ProgView\Demos\UniversalViewer\Setup
OutputBaseFilename=UniversalViewer
SetupIconFile=c:\ProgView\Demos\UniversalViewer\Res\Icons\uv.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "C:\ProgView\Demos\UniversalViewer\Viewer.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\Nav.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\amn*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\dso*.dll"; DestDir: "{app}"; Flags: ignoreversion regserver
Source: "C:\ProgView\Demos\UniversalViewer\ijl*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\un*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\V*.dll"; DestDir: "{app}"; Flags: ignoreversion

Source: "C:\ProgView\Demos\UniversalViewer\Language\*"; DestDir: "{app}\Language"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\Help\*"; DestDir: "{app}\Help"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\Icons\*"; DestDir: "{app}\Icons"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\Conv\*"; DestDir: "{app}\Conv"; Flags: ignoreversion

Source: "C:\ProgView\Demos\UniversalViewer\Plugins\ICLView\*"; DestDir: "{app}\Plugins\ICLView"; Flags: ignoreversion
Source: "C:\ProgView\Demos\UniversalViewer\Plugins\sLister\*"; DestDir: "{app}\Plugins\sLister"; Flags: ignoreversion

[Icons]
Name: "{group}\Universal Viewer"; Filename: "{app}\Viewer.exe"
Name: "{group}\Universal Viewer Help"; Filename: "{app}\Help\Viewer.English.chm"
Name: "{group}\Versions History"; Filename: "{app}\Help\History.html"
Name: "{group}\{cm:UninstallProgram,Universal Viewer}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Universal Viewer"; Filename: "{app}\Viewer.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\Viewer.exe"; Description: "{cm:LaunchProgram,Universal Viewer}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\Help\History.html"; Description: "View versions history"; Flags: nowait shellexec postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\*.ini"
Type: filesandordirs; Name: "{userappdata}\ATViewer"

[Registry]
Root: HKCR; Subkey: "*\shell\Universal Viewer"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\Universal Viewer\command"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\Universal Viewer\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Viewer.exe"" ""%1"""

[Code]
function InitializeUninstall(): boolean;
begin
  Result:= FindWindowByClassName('TFormViewUV.UnicodeClass')=0;
  if not Result then
  begin
   MsgBox('Universal Viewer is running, close it first.', mbCriticalError, mb_ok);
   Exit
  end;
end;
