#!/usr/bin/env bash
# Skaliert Bilder mit Real-ESRGAN hoch: 4x mit dem Modell, danach mit PhotoCraft auf die Zielgroesse.
#
#   eigen/hochskalieren.sh                      alle Bilder in Documents/Craft/ein, Faktor 2
#   eigen/hochskalieren.sh --faktor 3 bild.png  bestimmte Dateien, anderer Faktor
#   eigen/hochskalieren.sh --max 3840           laengste Kante hoechstens 3840 px (Standard: 3840, also 4K)
#
# Ergebnis als PNG in Documents/Craft/aus, Name <name>-<faktor>x.png. Vorhandene Ergebnisse werden
# uebersprungen. Alles laeuft lokal, kein Bild verlaesst den Rechner.
set -euo pipefail
ESRGAN="${REALESRGAN_DIR:-$HOME/Apps/realesrgan}"
PC="${PHOTOCRAFT_CLI:-/c/Program Files/ArtCraft/PhotoCraft/photocraft-cli.exe}"
EIN="$HOME/Documents/Craft/ein"
AUS="$HOME/Documents/Craft/aus"
FAKTOR=2
MAX=3840
DATEIEN=()
while [ $# -gt 0 ]; do
  case "$1" in
    --faktor) FAKTOR="$2"; shift 2 ;;
    --max) MAX="$2"; shift 2 ;;
    -*) echo "Unbekannte Option: $1" >&2; exit 2 ;;
    *) DATEIEN+=("$1"); shift ;;
  esac
done
if [ ${#DATEIEN[@]} -eq 0 ]; then
  shopt -s nullglob nocaseglob
  DATEIEN=("$EIN"/*.{png,jpg,jpeg,webp})
fi
[ ${#DATEIEN[@]} -gt 0 ] || { echo "Keine Bilder gefunden in $EIN" >&2; exit 1; }
mkdir -p "$AUS"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
for f in "${DATEIEN[@]}"; do
  name="$(basename "${f%.*}")"
  ziel="$AUS/$name-${FAKTOR}x.png"
  if [ -f "$ziel" ]; then echo "Schon da: $ziel"; continue; fi
  read -r w h < <("$PC" info "$(cygpath -w "$f")" | python -I -c "import json,sys; d=json.load(sys.stdin); print(d['width'], d['height'])" | tr -d '\r')
  zw=$(python -I -c "w,h,f,m=$w,$h,$FAKTOR,$MAX; s=min(f, m/max(w,h)); print(round(w*s))" | tr -d '\r')
  [ "$zw" -gt "$w" ] || { echo "Uebersprungen, schon groesser als $MAX px: $f"; continue; }
  s=$(date +%s)
  "$ESRGAN/realesrgan-ncnn-vulkan.exe" -i "$(cygpath -w "$f")" -o "$(cygpath -w "$TMP/4x.png")" \
    -n realesrgan-x4plus -t 128 > "$TMP/log.txt" 2>&1 \
    || { echo "Real-ESRGAN fehlgeschlagen bei $f:" >&2; tail -5 "$TMP/log.txt" >&2; exit 1; }
  "$PC" run "$(cygpath -w "$TMP/4x.png")" --cmd image.imageSize \
    --params "{\"width\":$zw,\"resample\":\"bicubicSharper\"}" --out "$(cygpath -w "$ziel")" > /dev/null
  echo "Fertig: $ziel (${w}x$h -> Breite $zw, $(( $(date +%s)-s )) s)"
done
