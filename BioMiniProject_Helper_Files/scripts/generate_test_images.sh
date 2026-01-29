#!/usr/bin/env bash
set -euo pipefail

OUT="data/images"
mkdir -p "$OUT"

convert -size 640x480 xc:lightblue -gravity center -pointsize 48   -annotate 0 "Microscope A" "$OUT/microscope_1.jpg"

convert -size 640x480 xc:lightgreen -gravity center -pointsize 48   -annotate 0 "Microscope B" "$OUT/microscope_2.jpg"

convert -size 640x480 xc:lightyellow -gravity center -pointsize 48   -annotate 0 "Microscope C" "$OUT/microscope_3.jpg"
