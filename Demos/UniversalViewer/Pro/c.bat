@echo off
dcc32 -m Nav.dpr
if errorlevel 1 exit

cls
cd ..
start Viewer
nav 0 "Russian" "d:\uv\ViewerHistory.ini"


