#!/usr/bin/env bash
# Full-view vertical layout: FULL 16:9 gameplay centered over a blurred copy of itself (1080x1920).
# Never crops the gameplay. Hook text in the top band, captions (optional .srt/.ass) in the bottom band.
# Audio is loudness-normalized to -14 LUFS.
#
# Usage: scripts/blur_layout.sh <input> <output.mp4> [start_sec] [duration_sec] ["HOOK TEXT"] [captions.srt]
# Example: scripts/blur_layout.sh raw/source.mp4 out/clip.mp4 7.75 89.5 "One duffel bag started this GTA 6 chase" out/clip.srt
set -euo pipefail
IN=${1:?input}; OUT=${2:?output}; SS=${3:-0}; DUR=${4:-}; HOOK=${5:-}; SUBS=${6:-}
FONT=${FONT:-$(fc-match -f '%{file}' 'DejaVu Sans:bold' 2>/dev/null || echo /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf)}
esc(){ printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e "s/'/\\\\'/g" -e 's/:/\\:/g' -e 's/%/\\%/g'; }
VF="[0:v]split=2[bg][fg];"
VF+="[bg]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:2,eq=brightness=-0.08[bgb];"
VF+="[fg]scale=1080:-2[fgs];"
VF+="[bgb][fgs]overlay=(W-w)/2:(H-h)/2,setsar=1,fps=30"
if [ -n "$HOOK" ]; then
  # wrap the hook to ~22 chars per line so it always fits the 1080px top band
  HOOKFILE=$(mktemp); trap 'rm -f "$HOOKFILE"' EXIT
  printf '%s' "$HOOK" | fold -s -w "${HOOK_WRAP:-22}" | sed 's/ *$//' > "$HOOKFILE"
  VF+=",drawtext=fontfile='$FONT':textfile='$HOOKFILE':fontsize=${HOOK_SIZE:-72}:line_spacing=14:fontcolor=white:borderw=6:bordercolor=black@0.9:box=1:boxcolor=black@0.35:boxborderw=24:x=(w-text_w)/2:y=${HOOK_Y:-328}-text_h/2"
fi
if [ -n "$SUBS" ]; then
  VF+=",subtitles='$(esc "$SUBS")':force_style='Alignment=2,MarginV=330,FontSize=16,Bold=1,Outline=3'"
fi
VF+="[v]"
ARGS=(-y -ss "$SS"); [ -n "$DUR" ] && ARGS+=(-t "$DUR")
ffmpeg "${ARGS[@]}" -i "$IN" -filter_complex "$VF" -map "[v]" -map 0:a? \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -c:a aac -b:a 160k -ar 48000 \
  -af loudnorm=I=-14:TP=-1.5:LRA=11 -movflags +faststart "$OUT"
echo "wrote $OUT"
