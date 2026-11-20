# Credits

This project stands on other people's open-source work. Every tool below was installed, used or bundled while building the GTA 6 clipper. Authors are verified against their GitHub repos (Nov 2026).

## GitHub tools and skill packs

| Tool | Author | Link | License | How it is used here |
|---|---|---|---|---|
| gtavi-claudecode | [@Bodila51](https://github.com/Bodila51) | https://github.com/Bodila51/gtavi-claudecode | MIT | **Base desk.** Trend radar, stream finder, campaign finder, moment finder, cutter, `check.py`, 16 skills. Bundled in `vendor/` and patched to 60-90 s clips. |
| auto-editor | [@WyattBlue](https://github.com/WyattBlue) | https://github.com/WyattBlue/auto-editor | Unlicense | Dead-air removal on every edit; 5 auto-editor skills. |
| PySceneDetect | [@Breakthrough](https://github.com/Breakthrough) (Brandon Castellano) | https://github.com/Breakthrough/PySceneDetect | BSD-3-Clause | Scene cuts so clips start and end on a shot change. |
| faster-whisper | [@SYSTRAN](https://github.com/SYSTRAN) | https://github.com/SYSTRAN/faster-whisper | MIT | Word-level captions (small model). |
| Whisper (model) | [@openai](https://github.com/openai) | https://github.com/openai/whisper | MIT | Model weights used by faster-whisper. |
| yt-dlp | [@yt-dlp](https://github.com/yt-dlp) | https://github.com/yt-dlp/yt-dlp | Unlicense | Section downloads of source VODs. |
| bgutil-ytdlp-pot-provider | [@Brainicism](https://github.com/Brainicism) | https://github.com/Brainicism/bgutil-ytdlp-pot-provider | GPL-3.0 | Optional PO-token plugin for yt-dlp (`WITH_POT=1`). |
| trendspy | [@sdil87](https://github.com/sdil87) | https://github.com/sdil87/trendspy | MIT | Google Trends keywords for titles and tags. |
| FFmpeg | [@FFmpeg](https://github.com/FFmpeg) | https://ffmpeg.org · https://github.com/FFmpeg/FFmpeg | LGPL/GPL | Full-view blur layout, captions burn-in, loudnorm -14 LUFS. |
| social-media-skills | [@social-media-skills](https://github.com/social-media-skills) (Frank Heijdenrijk) | https://github.com/social-media-skills/skills | MIT | hashtag-strategy, social-seo, hook-writer (`sms-hook-writer`), captions-and-clipping, platform-specs-and-validation, instagram-seo, tiktok-growth, youtube-shorts. |
| seo-skills | [@Illyism](https://github.com/Illyism) (Ilias Ism) | https://github.com/Illyism/seo-skills | MIT | youtube-seo, seo-title-optimization. |
| social-media-research-skills | [@ScrapeCreators](https://github.com/ScrapeCreators) | https://github.com/ScrapeCreators/social-media-research-skills | MIT | sc-comment-mining, sc-outlier-post-finder, sc-transcript-intelligence, sc-trend-discovery. |
| Firecrawl | [@firecrawl](https://github.com/firecrawl) | https://github.com/firecrawl/firecrawl | AGPL-3.0 | Web scraping / search of campaign pages and news (used as a connector). |
| vidIQ MCP | [@vid-io](https://github.com/vid-io) | https://github.com/vid-io/vidiq-mcp | see repo | Keyword research, competition, trending (connector). |

## Services / connectors

| Service | Link | Role |
|---|---|---|
| Zernio | https://zernio.com | Validate, preview and publish to YouTube, Instagram, Facebook x2, TikTok |
| Postpone | https://www.postpone.app | Schedule the second YouTube channel |
| vidIQ | https://vidiq.com | Keywords, scores, trending |
| TubeAlfred | https://tubealfred.com | YouTube search + transcripts (MCP) |
| Supadata | https://supadata.ai | Transcripts and metadata fallback |
| YouTube Data API v3 | https://developers.google.com/youtube/v3 | Official stats, search, live |
| Firecrawl | https://www.firecrawl.dev | Web data |

## Footage

The demo clip uses free-roam gameplay from **LuxeDude**: [10 HOURS of GTA 6 Free Roam Gameplay! (No Spoilers)](https://www.youtube.com/watch?v=2EaoIgWAW5g). Every published clip credits the source creator.

## Artwork

Banner, pipeline, layout, toolchain and connector images were generated for this repo with one shared style prompt (see [assets/PROMPTS.md](assets/PROMPTS.md)). No Rockstar Games logos or artwork are used.

## Built by

**Maliot100X / CLAWCADE**: [GitHub @Maliot100X](https://github.com/Maliot100X) · [X @CLAWRENAi](https://x.com/CLAWRENAi)

> Unofficial fan project. Not affiliated with Rockstar Games or Take-Two Interactive. GTA and Grand Theft Auto are trademarks of their owners.
