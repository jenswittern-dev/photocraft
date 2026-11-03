@echo off
rem Startpunkt fuer den Explorer-Rechtsklick: skaliert ein Bild 2x und oeffnet es in PhotoCraft.
title KI-Hochskalieren
"%ProgramFiles%\Git\bin\bash.exe" "%~dp0hochskalieren.sh" --neben --oeffnen "%~1"
if errorlevel 1 (
  echo.
  echo Das hat nicht geklappt, Meldung siehe oben.
  pause
  exit /b 1
)
timeout /t 5 >nul
