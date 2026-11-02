#!/usr/bin/env bash
# Holt ein offizielles PhotoCraft-Release, fuehrt es in den Branch "eigen" und baut die eigene Version.
#
#   eigen/aktualisieren.sh                neuestes Release
#   eigen/aktualisieren.sh v0.20.0        bestimmtes Release
#   eigen/aktualisieren.sh --nur-bauen    aktuellen Stand von "eigen" bauen und installieren
#   eigen/aktualisieren.sh --mit-tests    zusaetzlich cargo test --workspace
#
# Die offizielle App in C:\Program Files bleibt unberuehrt. Bei einem Merge-Konflikt stoppt das Skript,
# installiert nichts und laesst den Konflikt zum Aufloesen stehen.
set -euo pipefail

ZIEL="${PHOTOCRAFT_EIGEN_ZIEL:-$HOME/Apps/PhotoCraft-Eigen}"
REPO="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
cd "$REPO"

TAG=""
NUR_BAUEN=0
TESTS=0
for arg in "$@"; do
  case "$arg" in
    --nur-bauen) NUR_BAUEN=1 ;;
    --mit-tests) TESTS=1 ;;
    v*) TAG="$arg" ;;
    *) echo "Unbekannte Option: $arg" >&2; exit 2 ;;
  esac
done

if [ "$(git branch --show-current)" != "eigen" ]; then
  echo "Abbruch: Bitte auf Branch 'eigen' wechseln." >&2
  exit 1
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "Abbruch: Es gibt uncommittete Aenderungen." >&2
  exit 1
fi

if [ "$NUR_BAUEN" -eq 0 ]; then
  git fetch upstream --tags --force
  [ -n "$TAG" ] || TAG="$(git tag --list 'v*' --merged upstream/main --sort=-v:refname | head -n 1)"
  echo "Release: $TAG"
  if git merge-base --is-ancestor "$TAG" HEAD; then
    echo "Schon enthalten: $TAG"
  elif ! git merge --no-edit "$TAG"; then
    echo "Merge-Konflikt mit $TAG. Es wurde nichts installiert." >&2
    echo "Dateien: $(git diff --name-only --diff-filter=U | tr '\n' ' ')" >&2
    exit 3
  fi
fi

cargo build --release -p photocraft -p photocraft-cli
[ "$TESTS" -eq 0 ] || cargo test --workspace

mkdir -p "$ZIEL/vorher"
for exe in photocraft.exe photocraft-cli.exe; do
  [ ! -f "$ZIEL/$exe" ] || cp -f "$ZIEL/$exe" "$ZIEL/vorher/$exe"
  cp -f "target/release/$exe" "$ZIEL/$exe"
done
cp -f eigen/PhotoCraft-Eigen.cmd "$ZIEL/PhotoCraft-Eigen.cmd"
git describe --tags --always > "$ZIEL/stand.txt"

if [ "$NUR_BAUEN" -eq 0 ]; then
  git push origin refs/remotes/upstream/main:refs/heads/main eigen
fi
echo "Fertig: $("$ZIEL/photocraft-cli.exe" --version) in $ZIEL"
