@echo off
set arc=UniversalViewer.zip
if exist %arc% del %arc%

md Temp
md Temp\Language
md Temp\Help
md Temp\Icons
md Temp\Conv
md Temp\Plugins
md Temp\Plugins\ICLView
md Temp\Plugins\sLister

copy /b ..\Viewer.exe      Temp          >nul
copy /b ..\Nav.exe         Temp          >nul
copy /b ..\ijl*.dll        Temp          >nul
copy /b ..\amn*.dll        Temp          >nul
copy /b ..\un*.dll         Temp          >nul
copy /b ..\v*.dll          Temp          >nul
copy /b ..\dso*.dll        Temp          >nul
copy /b ..\Help\*.chm      Temp\Help     >nul
copy /b ..\Help\History.*  Temp\Help     >nul
copy /b ..\Language\*.lng  Temp\Language >nul
copy /b ..\Language\*.txt  Temp\Language >nul
copy /b ..\Icons\*.bmp     Temp\Icons    >nul
copy /b ..\Conv\*.*        Temp\Conv     >nul

copy /b ..\Plugins\ICLView\*.* Temp\Plugins\ICLView >nul
copy /b ..\Plugins\sLister\*.* Temp\Plugins\sLister >nul

cd Temp
start /min /wait winrar a -r ..\%arc% *.*
cd ..

rem echo y| del Temp\Plugins\Syn2\Lang\*.*
rem echo y| del Temp\Plugins\Syn2\HL\*.*
rem echo y| del Temp\Plugins\Syn2\*.*
echo y| del Temp\Plugins\ICLView\*.*
echo y| del Temp\Plugins\sLister\*.*
echo y| del Temp\Plugins\*.*
echo y| del Temp\Language\*.*
echo y| del Temp\Help\*.*
echo y| del Temp\Icons\*.*
echo y| del Temp\Conv\*.*
echo y| del Temp\*.*

rem rd Temp\Plugins\Syn2\Lang
rem rd Temp\Plugins\Syn2\HL
rem rd Temp\Plugins\Syn2
rd Temp\Plugins\ICLView
rd Temp\Plugins\sLister
rd Temp\Plugins
rd Temp\Language
rd Temp\Help
rd Temp\Icons
rd Temp\Conv
rd Temp
cls
