@echo off
cls
"C:\Program Files\HTML Help Workshop\hhc.exe" Viewer.Russian.hhp >nul
copy /b Viewer.Russian.chm ..
