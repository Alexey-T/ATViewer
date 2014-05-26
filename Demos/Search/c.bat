@echo off

copy /b  ATBinHexOptions.inc ..\..\Source
dcc32 SearchDemo.dpr
if errorlevel 1 exit
copy /b  ..\..\Source\UV\ATBinHexOptions.inc ..\..\Source

SearchDemo.exe
