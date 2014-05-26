@echo off
cls
"C:\Program Files\HTML Help Workshop\hhc.exe" Viewer.English.hhp >nul
copy /b Viewer.English.chm ..
