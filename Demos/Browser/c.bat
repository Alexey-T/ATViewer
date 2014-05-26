@echo off

copy /b *.inc ..\..\Source
C:\Borland\Delphi7\Bin\dcc32.exe -m BrowserDemo.dpr
if errorlevel 1 exit
copy /b ..\..\Source\UV\*.inc ..\..\Source

BrowserDemo
