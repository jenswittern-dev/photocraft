@echo off
rem Richtet den Explorer-Rechtsklick "Mit KI hochskalieren (2x)" fuer Bilder ein, nur fuer diesen Benutzer.
rem   kontextmenue-einrichten.cmd              einrichten, nach Aenderungen am Skript erneut ausfuehren
rem   kontextmenue-einrichten.cmd /entfernen   Eintrag wieder entfernen
setlocal
set "ZIEL=%USERPROFILE%\Apps\KI-Hochskalieren"
set "KEY=HKCU\Software\Classes\SystemFileAssociations\image\shell\KIHochskalieren"
if /i "%~1"=="/entfernen" (
  reg delete "%KEY%" /f >nul 2>&1
  echo Eintrag entfernt. Der Ordner %ZIEL% bleibt bestehen.
  exit /b 0
)
if not exist "%ZIEL%" mkdir "%ZIEL%"
copy /y "%~dp0hochskalieren.sh" "%ZIEL%\" >nul || exit /b 1
copy /y "%~dp0KI-Hochskalieren.cmd" "%ZIEL%\" >nul || exit /b 1
reg add "%KEY%" /ve /d "Mit KI hochskalieren (2x)" /f >nul || exit /b 1
reg add "%KEY%" /v Icon /d "%ProgramFiles%\ArtCraft\PhotoCraft\photocraft.exe,0" /f >nul
reg add "%KEY%\command" /ve /d "\"%ZIEL%\KI-Hochskalieren.cmd\" \"%%1\"" /f >nul || exit /b 1
echo Eingerichtet: Rechtsklick auf ein Bild, "Mit KI hochskalieren (2x)".
