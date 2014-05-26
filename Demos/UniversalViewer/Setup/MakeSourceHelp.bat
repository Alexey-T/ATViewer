@echo off
set arc=UniversalViewer-HelpSource.rar
if exist %arc% del %arc%

start /wait /min winrar a %arc% -x*.chm -ep1 -inul C:\ProgView\Demos\UniversalViewer\Help
