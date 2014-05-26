@echo off

copy /b *.inc ..\..\Source
dcc32 -m BrowserBHDemo.dpr
if errorlevel 1 exit
copy /b ..\..\Source\UV\*.inc ..\..\Source

BrowserBHDemo
