unit JPEG_IO;

{
Revision history:

2010 AT: magenta fix
2000 Nov 03  First version
2000 Nov 20  Add more error checking on read
2000 Dec 04  Remove comment field until Intel library fixed
2001 Apr 08  Add ability to read scale down images for thumbnails
2001 Sep 23  Support IJL V1.51, allows comment field and optimised CPU-type
2001 Nov 24  Add GetJpegInfo function
2009 Jun 20  Delphi 2009 work required
2009 Jun 28  Try to make the externals UnicodeString with AnsiString internally
2009 Nov 22  Correct repeated use of local AnsiString as both comment and
             filename in the SaveBmpToJpegFile procedure
2010 Apr 09  Experimental update for 32bpp JPEGs, no colour space conversion

Copyright © David J Taylor, Edinburgh
Web site:  www.satsignal.eu
E-mail:    davidtaylor@writeme.com
}

interface

uses Windows, SysUtils, Classes, Graphics, IJL;   // Intel JPEG Library

type
  TIJLScale = (ijlFullSize, ijlHalf, ijlQuarter, ijlEighth);


function SaveBmpToJpegFile (const bitmap: TBitmap;  const filename: string;
                    const quality: integer;  const comment: string): boolean;

function LoadBmpFromJpegFile (bitmap: TBitmap;  const filename: string;
                              const set_pixel_format: boolean;
                              const scale: TIJLScale = ijlFullSize): boolean;

function GetJpegInfo (const filename: string;
                      var Width, Height, Channels: Integer): boolean;


implementation

function SaveBmpToJpegFile (const bitmap: TBitmap;  const filename: string;
                    const quality: integer;  const comment: string): boolean;
var
  jcprops : TJPEG_CORE_PROPERTIES;
  iWidth, iHeight, iNChannels : Integer;
  iStatus: integer;
  DIB: TDIBSection;
  _Afilename, _Acomment: AnsiString;
begin
  // Should raise an exception if it fails
  Result := False;

  // Initialise the JPEG library
  FillChar (jcprops, SizeOf (jcprops), 0);  // Just to be sure...
  iStatus := ijlInit (@jcprops);
  if iStatus = IJL_OK then
  try  {
    with ijlGetLibVersion^ do
      if (Major = 1) and (Minor >= 51) then
        begin
        _Acomment := comment;
        jcprops.jprops.jpeg_comment := PAnsiChar (_Acomment);
        jcprops.jprops.jpeg_comment_size := Length (_Acomment);
        end;}
    FillChar (DIB, SizeOf (DIB), 0);
    GetObject (Bitmap.Handle, SizeOf (DIB), @DIB);
    iWidth  := DIB.dsBm.bmWidth;
    iHeight := DIB.dsBm.bmHeight;
    case bitmap.PixelFormat of
      pf8bit: iNChannels := 1;
      pf24bit: iNChannels := 3;
    else
      Raise EInvalidOperation.Create ('Cannot save bitmap as JPEG with specified PixelFormat');
    end;

    jcprops.DIBWidth := iWidth;
    jcprops.DIBHeight := -iHeight;
    jcprops.DIBChannels := iNChannels;
    case bitmap.PixelFormat of
       pf8bit: jcprops.DIBColor := IJL_G;
      pf24bit: jcprops.DIBColor := IJL_BGR;
    end;
    jcprops.DIBPadBytes := ((((iWidth*iNChannels)+3) div 4)*4)-(iWidth*iNChannels);
    jcprops.DIBBytes := PByte (DIB.dsBm.bmBits);

    _Afilename := filename;
    jcprops.JPGFile := PAnsiChar (_Afilename);
    jcprops.JPGWidth := iWidth;
    jcprops.JPGHeight := iHeight;
    jcprops.JPGChannels := 3;
    jcprops.JPGColor := IJL_YCBCR;
    jcprops.jquality := quality;
    Result := IJL_OK = ijlWrite (@jcprops, IJL_JFILE_WRITEWHOLEIMAGE);
    ijlFree (@jcprops);
  except
  end;
  if not Result then Raise (EWriteError.Create ('Error writing JPEG to file'));
end;


function GetJpegInfo (const filename: string;
                      var Width, Height, Channels: Integer): boolean;
var
  iStatus: integer;
  jcprops: TJPEG_CORE_PROPERTIES;
  _Afilename: AnsiString;
begin
  Result := False;
  if not FileExists (filename) then Exit;

  // Initialise the JPEG library
  FillChar (jcprops, SizeOf (jcprops), 0);  // Just to be sure...
  iStatus := ijlInit (@jcprops);
  if iStatus = IJL_OK then
  try
    _Afilename := filename;
    jcprops.JPGFile := PAnsiChar (_Afilename);
    iStatus := ijlRead (@jcprops, IJL_JFILE_READPARAMS);
    if iStatus = IJL_OK then
      begin
      Width := jcprops.JPGWidth;
      Height := jcprops.JPGHeight;
      Channels := jcprops.JPGChannels;
      Result := True;
      end;
  finally
    ijlFree (@jcprops);
  end;
end;


function LoadBmpFromJpegFile (bitmap: TBitmap;  const filename: string;
                              const set_pixel_format: boolean;
                              const scale: TIJLScale = ijlFullSize): boolean;
var
  iWidth, iHeight, iNChannels: Integer;
  iDIBChannels: integer;
  iStatus: integer;
  row, col: integer;
  pRGBA: PRGBQuad;
  tmp: byte;
  gain: byte;
  jcprops: TJPEG_CORE_PROPERTIES;
  DIB: TDIBSection;
  _Afilename: AnsiString;
begin
  Result := False;
  if not Assigned (bitmap) then Exit;
  if not FileExists (filename) then Exit;

  case bitmap.PixelFormat of
    pf8Bit: iDIBchannels := 1;
    pf24Bit: iDIBchannels := 3;
  else
    iDIBchannels := 0;
  end;
  if (iDIBChannels = 0) and (not set_pixel_format) then Exit;

  // Initialise the JPEG library
  FillChar (jcprops, SizeOf (jcprops), 0);  // Just to be sure...
  iStatus := ijlInit (@jcprops);
  if iStatus = IJL_OK then
  try
    _Afilename := filename;
    jcprops.JPGFile := PAnsiChar (_Afilename);
    iStatus := ijlRead (@jcprops, IJL_JFILE_READPARAMS);
    if iStatus = IJL_OK then
      begin
      iWidth := jcprops.JPGWidth;
      iHeight := jcprops.JPGHeight;
      case scale of
        ijlHalf: begin
                 iWidth := (iWidth + 1) div 2;
                 iHeight := (iHeight + 1) div 2;
                 end;
        ijlQuarter: begin
                 iWidth := (iWidth + 3) div 4;
                 iHeight := (iHeight + 3) div 4;
                 end;
        ijlEighth: begin
                 iWidth := (iWidth + 7) div 8;
                 iHeight := (iHeight + 7) div 8;
                 end;
      end;
      iNChannels := jcprops.JPGChannels;
      if (iNChannels = 1) or (iNChannels = 3) or (iNChannels = 4) then
        begin
        bitmap.Height := 0;
        bitmap.Width := 0;
        if set_pixel_format then
          begin
          iDIBChannels := iNChannels;
          case iDIBChannels of
            1: bitmap.PixelFormat := pf8Bit;
            3: bitmap.PixelFormat := pf24Bit;
            4: bitmap.PixelFormat := pf32Bit;
          end;
          end;
        bitmap.Width := iWidth;
        bitmap.Height := iHeight;
        FillChar (DIB, SizeOf (DIB), 0);
        iStatus := GetObject (bitmap.Handle, SizeOf (DIB), @DIB);
        if iStatus <> 0 then
          begin
          jcprops.DIBWidth := iWidth;
          jcprops.DIBHeight := -iHeight;
          jcprops.DIBChannels := iDIBChannels;
          case iDIBChannels of
            1: jcprops.DIBColor := IJL_G;
            3: jcprops.DIBColor := IJL_BGR;
            4: jcprops.DIBColor := IJL_RGBA_FPX;
          end;
          jcprops.DIBPadBytes := ((((iWidth*iDIBChannels)+3) div 4)*4)-(iWidth*iDIBChannels);
          jcprops.DIBBytes := PByte (DIB.dsBm.bmBits);

          case scale of
            ijlHalf: iStatus := ijlRead (@jcprops, IJL_JFILE_READONEHALF);
            ijlQuarter: iStatus := ijlRead (@jcprops, IJL_JFILE_READONEQUARTER);
            ijlEighth: iStatus := ijlRead (@jcprops, IJL_JFILE_READONEEIGHTH);
          else
            iStatus := ijlRead (@jcprops, IJL_JFILE_READWHOLEIMAGE);
          end;

          if iDIBChannels = 4 then
            begin
            for row := 0 to iHeight - 1 do
              begin
              pRGBA := bitmap.ScanLine [row];
              for col := 0 to iWidth - 1 do
                begin
                gain := pRGBA.rgbReserved;
                pRGBA.rgbRed := pRGBA.rgbRed * gain div 255;
                pRGBA.rgbGreen := pRGBA.rgbGreen * gain div 255;
                pRGBA.rgbBlue := pRGBA.rgbBlue * gain div 255;
                Inc (pRGBA);
                end;
              end;
            end;

          if iStatus >= 0 then
            begin
            bitmap.Modified := True;
            Result := True;
            end;
          end;
        end;
      end;
  finally
    ijlFree (@jcprops);
  end;
end;

end.

