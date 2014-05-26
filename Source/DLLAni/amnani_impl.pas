{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:  amnani.dll                                }
{           Source Language:  Delphi                                    }
{           Author Name and Contact Information:                        }
{           Alexey M. Novosselov                                        }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           amnani.dll interface unit                                   }
{                                                                       }
{-----------------------------------------------------------------------}

unit amnani_impl;

interface

uses
   Windows, Graphics;
   
   
   function _GetFrames(Handle: THandle; FileName: PChar): THandle;
   function _GetAniCursorInfo(Handle: THandle; FileName: PChar): Boolean;
   function _GetFramesRate(Handle: THandle; FileName: PChar): Integer;
   function _GetCursorCreator(Handle: THandle; FileName: PChar): ShortString;
   function _GetCursorTitle(Handle: THandle; FileName: PChar): ShortString;
   
implementation

var
   GetFrames: function(FileName: PChar): THandle; stdcall;
   GetAniCursorInfo: function(Handle: THandle; FileName: PChar): Boolean; stdcall;
   GetFramesRate: function(FileName: PChar): Integer; stdcall;
   GetCursorCreator: function(Handle: THandle; FileName: PChar): ShortString; stdcall;
   GetCursorTitle: function(Handle: THandle; FileName: PChar): ShortString; stdcall;
   SaveFrameToFile: procedure(const FileName: PChar; const OutFileName: PChar; Index: Integer); stdcall;
   SaveAllFramesToFile: procedure(const FileName: PChar; const OutFileNameTemplate: PChar); stdcall;
   SaveAsBitmap: procedure(const FileName: PChar; const Bitmap: PChar;  Background: TColor; Vertical: Boolean); stdcall;


function _GetFrames(Handle: THandle; FileName: PChar): THandle;
var
   H: hInst;
begin
   {$T+}
   H := LoadLibrary(PChar('amnani.dll'));
   if H <= 0 then begin
      Result := 0;
      Exit;
   end
   else
   begin
      @GetFrames := GetProcAddress(H, PChar('GetFrames'));
      if @GetFrames = nil
      then
      begin
         Result := 0;
         Exit;
      end
      else
         Result := GetFrames(FileName);
   end;
   FreeLibrary(H);
   {$T-}
end;

function _GetAniCursorInfo(Handle: THandle; FileName: PChar): Boolean;
var
   H: hInst;
begin
   H := LoadLibrary(PChar('amnani.dll'));
   if H <= 0 then begin
      Result := False;
      Exit;
   end
   else
   begin
      @GetAniCursorInfo := GetProcAddress(H, PChar('GetAniCursorInfo'));
      if @GetAniCursorInfo = nil
      then
      begin
         Result := False;
         Exit;
      end
      else
         Result := GetAniCursorInfo(Handle, FileName);
   end;
   FreeLibrary(H);
end;

function _GetFramesRate(Handle: THandle; FileName: PChar): Integer;
const
   cErrorFileNotFound = - 1;
   cError = - 2;
var
   H: hInst;
begin
   H := LoadLibrary(PChar('amnani.dll'));
   if H <= 0 then begin
      Result := cErrorFileNotFound;
      Exit;
   end
   else
   begin
      @GetFramesRate := GetProcAddress(H, PChar('GetFramesRate'));
      if @GetFramesRate = nil
      then
      begin
         result := cError;
         Exit;
      end
      else
         Result := GetFramesRate( FileName);
   end;
   FreeLibrary(H);
end;

function _GetCursorCreator(Handle: THandle; FileName: PChar): ShortString;
var
   H: hInst;
begin
   H := LoadLibrary(PChar('amnani.dll'));
   if H <= 0 then begin
      Result := '';
      Exit;
   end
   else
   begin
      @GetCursorCreator := GetProcAddress(H, PChar('GetCursorCreator'));
      if @GetCursorCreator = nil
      then
      begin
         result := '';
         Exit;
      end
      else
         Result := GetCursorCreator(Handle, FileName);
   end;
   FreeLibrary(H);
end;

function _GetCursorTitle(Handle: THandle; FileName: PChar): ShortString;
var
   H: hInst;
begin
   H := LoadLibrary(PChar('amnani.dll'));
   if H <= 0 then begin
      Result := '';
      Exit;
   end
   else
   begin
      @GetCursorTitle := GetProcAddress(H, PChar('GetCursorTitle'));
      if @GetCursorTitle = nil
      then
      begin
         result := '';
         Exit;
      end
      else
         Result := GetCursorTitle(Handle, FileName);
   end;
   FreeLibrary(H);
end;

end.

