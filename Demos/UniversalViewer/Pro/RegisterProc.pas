unit RegisterProc;

interface

type
  TLicType = (
    licNonCom,
    licPersonal,
    licBusiness,
    licSite
    );

const
  cLicName: array[TLicType] of string = (
    'Non-commercial license',
    'Personal license',
    'Business license (7 computers)',
    'Site license (unlim. num of computers)'
    );
const
  cRName = 'Русская регистрация';

//function EnterRegistrationInfo(const Name, Key: string): boolean;
//function ReadRegistrationInfo(var RegName: string; var RegDaysLeft: integer; var LicType: TLicType): boolean;
//function IsUSSR: boolean;

implementation

uses
  Windows, SysUtils,
  Forms, Graphics,
  DateUtils;

//--------------------------------------------------------------------------
const
  RDays: array[1..7] of string =
    ('понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье');

(*
function EnterRegistrationInfo(const Name, Key: string): boolean;
var
  AKey: string;
begin
  {$I aspr_crypt_begin1.inc}
  AKey:= Key;
  if (Name = cRName) and (Key = RDays[ DayOfTheWeek(Now) ]) then
    AKey:= cRKey;
  Result:= CheckKeyAndDecrypt(PChar(AKey), PChar(Name), true);
  {$I aspr_crypt_end1.inc}
end;
*)

//--------------------------------------------------------------------------
function SDeleteLast(var S: string; const SubStr: string): boolean;
var
  N: integer;
begin
  Result:= false;
  N:= Pos(SubStr, S);
  if (N > 0) and (N = Length(S) - Length(SubStr) + 1) then
    begin
    Result:= true;
    Delete(S, N, MaxInt);
    end;
end;

function CheckLicType(var S: string): TLicType;
begin
  if S = cRName then Result:= licNonCom else
   if SDeleteLast(S, '[B]') then Result:= licBusiness else
    if SDeleteLast(S, '[S]') then Result:= licSite else
     Result:= licPersonal;
end;

//--------------------------------------------------------------------------
(*
function ReadRegistrationInfo(var RegName: string;
  var RegDaysLeft: integer; var LicType: TLicType): boolean;
var
  UserKey: PChar;
  UserName: PChar;
  ModeName: PChar;
  TrialDaysTotal: DWORD;
  TrialDaysLeft: DWORD;
begin
  Result:= false;
  RegName:= '';
  RegDaysLeft:= 0;
  LicType:= licPersonal;

  //{$I aspr_crypt_begin1.inc}

  UserKey:= nil;
  UserName:= nil;
  ModeName:= nil;
  TrialDaysTotal:= DWORD(-1);
  TrialDaysLeft:= DWORD(-1);

  GetRegistrationInformation(0, UserKey, UserName);
  if (UserKey <> nil) and (StrLen(UserKey) > 0) then
  begin
    Result:= true;
    RegName:= StrPas(UserName);
    LicType:= CheckLicType(RegName);
    //GetModeInformation(0, ModeName, ModeStatus); //Mode info not needed yet
  end
  else
  begin
    if GetTrialDays(0, TrialDaysTotal, TrialDaysLeft) then
      RegDaysLeft:= TrialDaysLeft - 50 {!};
  end;

  {$I aspr_crypt_end1.inc}
end;
*)

function GetUserDefaultUILanguage: Word; stdcall; external 'kernel32.dll';

//--------------------------------------------------------------------------
function IsUSSR: boolean;
var
  _xAPag: word;                 //ANSI Code Page, для нас = 1251
  _xOPag: word;                 //OEM Code Page, для нас = 866
  _xLCID: integer;              //Windows Locale ID, для нас = 1049 ($0419)
  u1, u2: Word;
begin
  _xAPag := GetACP;
  _xOPag := GetOEMCP;
  _xLCID := GetSystemDefaultLCID;
  u1:= GetUserDefaultUILanguage;
  u2:= GetUserDefaultLangID;

  Result:= (_xAPag = 1251)
    and (_xOPag = 866)
    and (_xLCID = 1049)
    and (u1 = 1049)
    and (u2 = 1049)
    {
    and (_xLFormats.LongMonthNames[11] = 'Ноябрь')
    and (_xLFormats.ShortMonthNames[5] = 'май')
    and (_xLFormats.LongDayNames[4] = 'среда')
    };
end;

end.
