#!/usr/bin/env bash
set -euo pipefail

IMG_DIR="${1:?Missing image directory}"
SIZE="${2:?Missing size}"

LOG="logs/images.log"
OUT="output/processed_images"

mkdir -p logs "$OUT"

if ! command -v convert >/dev/null 2>&1; then
  echo "ERROR: ImageMagick (convert) not found"
  exit 1
fi

for img in "$IMG_DIR"/*.jpg; do
  convert "$img" -resize "$SIZE" "$OUT/$(basename "$img")"
done
