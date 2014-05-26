{************************************************}
{                                                }
{  Project: Ini Relocation for Universal Viewer  }
{  Copyright (C) 2006 Alexey Torgashin           }
{  http://atorg.net.ru                           }
{                                                }
{************************************************}

program IniReloc;

uses
  Forms,
  UFormReloc in 'UFormReloc.pas' {FormReloc};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Ini relocation tool for Universal Viewer';
  Application.CreateForm(TFormReloc, FormReloc);
  Application.Run;
end.
