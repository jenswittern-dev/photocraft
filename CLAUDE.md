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

GitHub Actions sind im Fork abgeschaltet.

## Wiedereinstieg

Stand 03.11.2026: Grundgerüst steht, `eigen` enthält noch keine eigenen Funktionen. KI-Skalierung ist noch nicht eingebaut: Real-ESRGAN liegt in `~/Apps/realesrgan`, offen sind die Qualitätsprobe mit Jens' Bildern und die Nachfrage in Issue #2942 (externes Programm oder Aufbau auf PR #8104).

Bei „weitermachen“: `git status`, `git log --oneline -5`, dann diesen Abschnitt prüfen. Bei „Stand sichern“: diesen Abschnitt aktualisieren, committen, `eigen` pushen.
