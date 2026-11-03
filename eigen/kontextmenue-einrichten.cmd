@echo off
rem Richtet den Explorer-Rechtsklick "Mit KI hochskalieren (2x)" fuer Bilder ein, nur fuer diesen Benutzer.
rem   kontextmenue-einrichten.cmd              einrichten, nach Aenderungen am Skript erneut ausfuehren
rem   kontextmenue-einrichten.cmd /entfernen   Eintrag wieder entfernen
rem Je Dateiendung ein Eintrag wie bei PdfCraft.
rem Jens startet es selbst per Doppelklick: Aus einer Claude-Desktop-Sitzung heraus landet der
rem Registry-Eintrag in der privaten Registry des App-Pakets, und der Explorer sieht ihn nie.
setlocal
set "ZIEL=%USERPROFILE%\Apps\KI-Hochskalieren"
set "BASIS=HKCU\Software\Classes\SystemFileAssociations"
set "ENDUNGEN=.png .jpg .jpeg .webp .bmp"
reg delete "%BASIS%\image\shell\KIHochskalieren" /f >nul 2>&1
if /i "%~1"=="/entfernen" (
  for %%E in (%ENDUNGEN%) do reg delete "%BASIS%\%%E\shell\KIHochskalieren" /f >nul 2>&1
  echo Eintrag entfernt. Der Ordner %ZIEL% bleibt bestehen.
  exit /b 0
)
if not exist "%ZIEL%" mkdir "%ZIEL%"
copy /y "%~dp0hochskalieren.sh" "%ZIEL%\" >nul || exit /b 1
copy /y "%~dp0KI-Hochskalieren.cmd" "%ZIEL%\" >nul || exit /b 1
for %%E in (%ENDUNGEN%) do (
  reg add "%BASIS%\%%E\shell\KIHochskalieren" /ve /d "Mit KI hochskalieren (2x)" /f >nul || exit /b 1
  reg add "%BASIS%\%%E\shell\KIHochskalieren" /v Icon /d "%ProgramFiles%\ArtCraft\PhotoCraft\photocraft.exe,0" /f >nul
  reg add "%BASIS%\%%E\shell\KIHochskalieren\command" /ve /d "\"%ZIEL%\KI-Hochskalieren.cmd\" \"%%1\"" /f >nul || exit /b 1
)
echo Eingerichtet fuer %ENDUNGEN%: Rechtsklick auf ein Bild, "Mit KI hochskalieren (2x)".
pause
