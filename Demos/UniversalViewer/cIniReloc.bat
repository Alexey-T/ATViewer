@echo off
dcc32 -m IniReloc.dpr
if errorlevel 1 exit
IniReloc
