@echo off
set arc=UniversalViewerIniReloc.zip
if exist %arc% del %arc%

md Temp

copy/b ..\IniReloc.exe Temp
copy/b "..\Readme\Readme IniReloc.txt" Temp\Readme.txt

cd Temp
start /wait winrar a -r ..\%arc% *.*
cd ..

echo y|del Temp\*.*
rd Temp
