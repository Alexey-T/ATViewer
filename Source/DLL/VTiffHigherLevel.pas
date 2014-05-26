unit VTiffHigherLevel;

interface

uses
  Windows, SysUtils, Classes, Graphics, LibTiffDelphi;

{uses LibTiffDelphi, download it here:
     http://www.awaresystems.be/imaging/tiff/delphi.html }

procedure WriteBmpToTiff(h: HBitmap; fn: PAnsiChar);
function ReadTIFFIntoBitmap(
  S: TStream; B: TBitmap;
  Page: Integer; var PagesCount: Integer): Boolean;


implementation

procedure TIFFReadRGBAImageSwapRB(Width,Height: Cardinal; Memory: Pointer);
{$IFDEF DELPHI_5}
type
  PCardinal = ^Cardinal;
{$ENDIF}
var
  m: PCardinal;
  n: Cardinal;
  o: Cardinal;
begin
  m:=Memory;
  for n:=0 to Width*Height-1 do
  begin
    o:=m^;
    m^:= (o and $FF00FF00) or                {G and A}
        ((o and $00FF0000) shr 16) or        {B}
        ((o and $000000FF) shl 16);          {R}
    Inc(m);
  end;
end;

function ReadTIFFIntoBitmap(S: TStream; B: TBitmap; Page: Integer; var PagesCount: Integer): Boolean;
var
  OpenTiff: PTIFF;
  FirstPageWidth,FirstPageHeight: Cardinal;
  B2: TBitmap;
  ScaleX, ScaleY: Single;
  Units: Cardinal;
begin
  Result := False;
  PagesCount := 1;
  Units := 0;
  ScaleX := 1.0;
  ScaleY := 1.0;

  OpenTiff := TIFFOpenStream(S,'r');
  if OpenTiff = nil then Exit; //raise Exception.Create('Cannot open TIFF stream');

  PagesCount := TIFFNumberOfDirectories(OpenTiff);
  TIFFSetDirectory(OpenTiff, Page);

  TIFFGetField(OpenTiff, TIFFTAG_RESOLUTIONUNIT, @Units);
  TIFFGetField(OpenTiff, TIFFTAG_XRESOLUTION, @ScaleX);
  TIFFGetField(OpenTiff, TIFFTAG_YRESOLUTION, @ScaleY);
  
  TIFFGetField(OpenTiff,TIFFTAG_IMAGEWIDTH,@FirstPageWidth);
  TIFFGetField(OpenTiff,TIFFTAG_IMAGELENGTH,@FirstPageHeight);
  try
    B.PixelFormat := pf32bit;
    B.Width := FirstPageWidth;
    B.Height := FirstPageHeight;
  except
    TIFFClose(OpenTiff);
    Exit; //raise Exception.Create('Cannot create bitmap buffer');
  end;
  TIFFReadRGBAImage(OpenTiff,FirstPageWidth,FirstPageHeight,
               B.Scanline[FirstPageHeight-1],0);
  TIFFClose(OpenTiff);
  TIFFReadRGBAImageSwapRB(FirstPageWidth,FirstPageHeight,
               B.Scanline[FirstPageHeight-1]);
  Result := True;

  if (Units<>RESUNIT_NONE) and (ScaleX<>ScaleY) then
  begin
    B2:= TBitmap.Create;
    B2.PixelFormat:= B.PixelFormat;
    if ScaleY > ScaleX then
    begin
      B2.Width:= Trunc(B.Width * (ScaleY/ScaleX));
      B2.Height:= B.Height;
    end
    else
    begin
      B2.Width:= B.Width;
      B2.Height:= Trunc(B.Height * (ScaleX/ScaleY));
    end;

    B2.Canvas.Brush.Color:= clWhite;
    B2.Canvas.FillRect(Rect(0, 0, B2.Width, B2.Height));
    B2.Canvas.StretchDraw(Rect(0, 0, B2.Width, B2.Height), B);

      {
      //Test
      B2.Canvas.Brush.Color:= clYellow;
      B2.Canvas.FillRect(Rect(0, 0, B2.Width, B2.Height));
      B2.Canvas.Draw(0, 0, B);
      }

    B.Width:= B2.Width;
    B.Height:= B2.Height;
    B.Canvas.Draw(0, 0, B2);

    {Messagebox(0, PChar(Format('was %d-%d, %d-%d', [B.Width, B.Height,
      B2.Width, B2.Height])), '',0);
      }
    FreeAndNil(B2);
  end;
end;

//----------
procedure WriteBitmapToTiff(Bitmap: TBitmap; const Filename: string);
var
  OpenTiff: PTIFF;
  RowsPerStrip: Longword;
  StripMemory: Pointer;
  StripIndex: Longword;
  StripRowOffset: Longword;
  StripRowCount: Longword;
  ma,mb: PByte;
  nx,ny: Longword;
begin
  if (Bitmap.PixelFormat<>pf24bit) and 
     (Bitmap.PixelFormat<>pf32bit) then
    raise Exception.Create('WriteBitmapToTiff is designed for 24bit and 32bit bitmaps only');
  RowsPerStrip:=((256*1024) div (Bitmap.Width*3));
  if RowsPerStrip>Bitmap.Height then
    RowsPerStrip:=Bitmap.Height
  else if RowsPerStrip=0 then
    RowsPerStrip:=1;
  StripMemory:=GetMemory(RowsPerStrip*Bitmap.Width*3);
  OpenTiff:=TIFFOpen(PAnsiChar(Filename),'w');
  if OpenTiff=nil then
  begin
    FreeMemory(StripMemory);
    raise Exception.Create('Unable to create file '''+Filename+'''');
  end;
  TIFFSetField(OpenTiff,TIFFTAG_IMAGEWIDTH,Bitmap.Width);
  TIFFSetField(OpenTiff,TIFFTAG_IMAGELENGTH,Bitmap.Height);
  TIFFSetField(OpenTiff,TIFFTAG_PHOTOMETRIC,PHOTOMETRIC_RGB);
  TIFFSetField(OpenTiff,TIFFTAG_SAMPLESPERPIXEL,3);
  TIFFSetField(OpenTiff,TIFFTAG_BITSPERSAMPLE,8);
  TIFFSetField(OpenTiff,TIFFTAG_PLANARCONFIG,PLANARCONFIG_CONTIG);
  TIFFSetField(OpenTiff,TIFFTAG_COMPRESSION,COMPRESSION_LZW);
  TIFFSetField(OpenTiff,TIFFTAG_PREDICTOR,2);
  TIFFSetField(OpenTiff,TIFFTAG_ROWSPERSTRIP,RowsPerStrip);
  StripIndex:=0;
  StripRowOffset:=0;
  while StripRowOffset<Bitmap.Height do
  begin
    StripRowCount:=RowsPerStrip;
    if StripRowCount>Bitmap.Height-StripRowOffset then
      StripRowCount:=Bitmap.Height-StripRowOffset;
    if Bitmap.PixelFormat=pf24bit then
    begin
      mb:=StripMemory;
      for ny:=StripRowOffset to StripRowOffset+StripRowCount-1 do
      begin
        ma:=Bitmap.ScanLine[ny];
        for nx:=0 to Bitmap.Width-1 do
        begin
          mb^:=PByte(Cardinal(ma)+2)^;
          Inc(mb);
          mb^:=PByte(Cardinal(ma)+1)^;
          Inc(mb);
          mb^:=PByte(Cardinal(ma)+0)^;
          Inc(mb);
          Inc(ma,3);
        end;
      end;
    end
    else
    begin
      mb:=StripMemory;
      for ny:=StripRowOffset to StripRowOffset+StripRowCount-1 do
      begin
        ma:=Bitmap.ScanLine[ny];
        for nx:=0 to Bitmap.Width-1 do
        begin
          mb^:=PByte(Cardinal(ma)+2)^;
          Inc(mb);
          mb^:=PByte(Cardinal(ma)+1)^;
          Inc(mb);
          mb^:=PByte(Cardinal(ma)+0)^;
          Inc(mb);
          Inc(ma,4);
        end;
      end;
    end;
    if TIFFWriteEncodedStrip(OpenTiff,StripIndex,
        StripMemory,StripRowCount*Bitmap.Width*3)=0 then
    begin
      TIFFClose(OpenTiff);
      FreeMemory(StripMemory);
      raise Exception.Create('Failed to write '''+Filename+'''');
    end;
    Inc(StripIndex);
    Inc(StripRowOffset,StripRowCount);
  end;
  TIFFClose(OpenTiff);
  FreeMem(StripMemory);
end;


procedure WriteBmpToTiff(h: HBitmap; fn: PAnsiChar);
var
  b: TBitmap;
begin
  b:= TBitmap.Create;
  b.PixelFormat:= pf24bit;
  try
    b.Handle:= h;
    WriteBitmapToTiff(b, AnsiString(fn));
  finally
    b.Free;
  end;
end;


end.
