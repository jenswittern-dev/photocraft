# PhotoCraft: Jens' Fork

Fork von `storytold/photocraft`. Regeln des Projekts: `AGENTS.md`, danach `docs/`.

## Branches

- `main` spiegelt `upstream/main` und bekommt nie eigene Commits.
- `eigen` ist Jens' Version: Release-Tags plus eigene Funktionen plus der Ordner `eigen/` und diese Datei.
- `feature/<name>`: eine Funktion je Branch, abgezweigt vom Tag, auf dem `eigen` steht, danach in `eigen` gemergt.
- Pull Requests ans offizielle Repo kommen aus einem Branch von `upstream/main`, nie aus `eigen`. `eigen/` und diese `CLAUDE.md` gehen nicht mit.
- Vor jedem PR oder öffentlichen Kommentar den Text Jens vorlegen.

## Eigene Funktionen

Neuer Code möglichst in eigene Dateien, im offiziellen Code nur kurze Anschlussstellen. Das hält Konflikte klein. Was allgemein nützt, wird PR; ist es offiziell übernommen, fällt der eigene Patch weg.

## Bauen und aktualisieren

`eigen/aktualisieren.sh` holt das neueste Release, mergt es in `eigen`, baut, installiert nach `~/Apps/PhotoCraft-Eigen` und pusht. Bei einem Konflikt stoppt es ohne Installation. Die vorherige Version liegt in `~/Apps/PhotoCraft-Eigen/vorher`.

Start über `PhotoCraft-Eigen.cmd` im Installationsordner, mit eigenem Einstellungsordner. Die offizielle App in `C:\Program Files` aktualisiert weiter der Launcher.

Ein Build ohne Cache dauert auf dem Laptop etwa 50 Minuten (gemessen 03.11.2026). Vorher den Schlafmodus abwenden, sonst bricht er ab. Danach geht es dank `target/` schneller.

GitHub Actions sind im Fork abgeschaltet.

## KI-Skalierung

`eigen/hochskalieren.sh` skaliert die Bilder aus `~/Documents/Craft/ein` nach `~/Documents/Craft/aus`: zuerst Real-ESRGAN (`~/Apps/realesrgan`, Modell x4plus) 4x, danach PhotoCraft (bicubicSharper) auf den Faktor (Standard 2, längste Kante höchstens 3840). Das ist ein externer Ablauf, im PhotoCraft-Code ist nichts eingebaut.

## Wiedereinstieg

Stand 03.11.2026: Grundgerüst steht. v0.19.0 ist als eigene Version gebaut und in `~/Apps/PhotoCraft-Eigen` installiert. `eigen` enthält noch keine eigenen Funktionen. Offen ist die Qualitätsprobe des Skalier-Skripts mit Jens' Fotos. Einen Kommentar in Issue #2942 (externes Programm oder Aufbau auf PR #8104) hat Jens am 03.11.2026 abgelehnt; nicht erneut vorschlagen, solange er es nicht selbst anspricht.

Bei „weitermachen“: `git status`, `git log --oneline -5`, dann diesen Abschnitt prüfen. Bei „Stand sichern“: diesen Abschnitt aktualisieren, committen, `eigen` pushen.
