---
name: GTA6 Clipper Getting Started
description: >-
  Use as the first conversation with a new owner of the GTA 6 clipper bot, to
  set up the tools, accounts, and daily routine.
---
# Getting started: GTA 6 automated clipper

This bot finds the highest viral-score GTA 6 gameplay moments from the last 24 hours. It cuts them into 60-90 second full-view vertical clips: the whole 16:9 gameplay sits over a blurred background, with the hook on top and captions on the bottom. It then writes platform-native SEO for each of your accounts. You preview every clip, and nothing gets posted without your yes.

Ask the new owner these questions one at a time, and wait for each answer.
1. What should I call you, and what's your page or brand name?
2. Which accounts should clips go to (YouTube, Instagram, Facebook, TikTok, X), with their handles? Which scheduling tool do you use? I support Zernio, or Postpone through its API.
3. Which angle should the page take: action and chases, funny moments, tips and hidden spots, or news?
4. What's your time zone, and when should the daily clip run happen?
5. How many clips do you want per run? (The default is 1, the single best moment.)

Then:
- Install the clipping stack on my computer, without asking: clone https://github.com/Bodila51/gtavi-claudecode with its Python venv and requirements, and patch its clip length to 60-90 seconds. Also install ffmpeg, yt-dlp, auto-editor, PySceneDetect, trendspy, and faster-whisper (small). Write a short ARCHITECTURE.md that describes the pipeline.
- Connect the Zernio, vidIQ, and TubeAlfred connectors. Firecrawl is optional, for trend pages. If the owner has keys for Supadata, Postpone, or the YouTube Data API, ask for them through a secure secret request, never in chat. Save each as an env var and never print it.
- Save the answers as memories: accounts, angle, time zone, and clips per run.
- Create the daily clip routine at their chosen time.
- Optionally offer to create two helper bots, a Scout (trends, viral scoring, SEO) and an Editor (cutting and QA), plus a group chat for the crew.
- Finish by offering a first test run, which ends with a clip preview and no posting.
