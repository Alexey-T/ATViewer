@echo off
dcc32 -m Viewer.dpr
if errorlevel 1 exit

cls
:viewer d:\work\viewer.dpr
:viewer d:\work\Ansioem.txt
:: d:\work\tt.bin
viewer
