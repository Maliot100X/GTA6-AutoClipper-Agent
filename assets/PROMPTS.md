# Image prompts

All artwork uses **one shared style block** so the set looks like one campaign. Generated with an AI image model (Grok Bot image generation), 16:9.

## Shared style
```
dark neon retro-futuristic Vice City / Leonida Florida vibe, synthwave pink-magenta and cyan sunset gradient,
silhouetted palm trees, ocean skyline at dusk, glowing neon grid, sleek glassmorphism tech UI panels,
crisp clean sans-serif typography, high contrast, cinematic lighting, no logos, no Rockstar branding, no real people.
```

## Per image (appended to the shared style)
| File | Subject prompt |
|---|---|
| `hero-banner.jpg` | wide GitHub README hero banner; centered bold neon title "GTA6 AutoClipper Agent", subtitle "Viral gameplay -> 60-90s vertical clips -> 6 platforms"; floating vertical phone showing a sports-car chase on a sunset highway; icons: film strip, waveform, scissors, upload arrow |
| `pipeline-infographic.jpg` | 7 glowing glass cards left-to-right with neon arrows: TREND RADAR, FIND SOURCE, BEST MOMENT, CUT + BLUR LAYOUT, CAPTIONS + SEO, HUMAN YES, POST x6; title "The Clipping Pipeline" |
| `layout-before-after.jpg` | two vertical phones: LEFT "BEFORE: CROPPED" tight crop with red X; RIGHT "AFTER: FULL VIEW" full 16:9 gameplay centered over its blurred copy, hook band top, captions bottom, green check |
| `toolchain-card.jpg` | grid of 8 glass tiles: yt-dlp, ffmpeg, faster-whisper, PySceneDetect, auto-editor, trendspy, gtavi scripts, check.py; header "Toolchain" |
| `connectors-card.jpg` | central AI core orb wired to 7 tiles: Zernio, Postpone, vidIQ, TubeAlfred, Supadata, YouTube Data API, Firecrawl; header "Connectors" |

## Real frames (not generated)
| File | Source |
|---|---|
| `frame-full-view-layout.jpg`, `demo-full-view-layout.mp4/.gif` | rendered with `scripts/blur_layout.sh` from LuxeDude's free-roam VOD |
| `frame-live-clip.jpg`, `demo-live-clip-preview.mp4`, `demo-live-clip.gif` | the published 2026-11-20 bag-chase clip (18 s / 6 s excerpts, 540x960) |
| `clip-thumbnail.jpg` | the thumbnail used for that post |

Want to regenerate with Grok Imagine or another model? Paste the shared style + one subject line.
