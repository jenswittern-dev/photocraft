@echo off
rem Startet die eigene PhotoCraft-Version mit eigenen Einstellungen, getrennt von der offiziellen App.
set "PHOTOCRAFT_CONFIG_DIR=%~dp0einstellungen"
set "PHOTOCRAFT_NEW_INSTANCE=1"
start "" "%~dp0photocraft.exe" %*
