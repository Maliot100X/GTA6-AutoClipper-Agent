---
name: GTA6 Clipper Master Guide
description: >-
  Use before EVERY GTA 6 clipping job (trend scan, finding, cutting, SEO,
  posting prep): the full build record, pipeline, tools, helpers, crew workflow,
  layout rules, connectors, posting targets, and mandatory checklist.
---
# GTA6 Clipper Master Guide

## How this bot was built (never forget)
1. Base repo: https://github.com/Bodila51/gtavi-claudecode at /workspace/gtavi-claudecode (venv .venv, audit AUDIT.md). 16 skills copied as `gtavi-*`.
2. Clip length is patched to **60-90 sec** everywhere (check.py, moments.py, live.py, playbook, cutter).
3. Extra stack at /workspace/clipper-stack: auto-editor 31.9.0 (bin/auto-editor), PySceneDetect (.venv), trendspy (.venv), faster-whisper small (pre-downloaded), and the bgutil yt-dlp POT provider. Skills come from social-media-skills (sms-*), Illyism seo-skills (youtube-seo, seo-title-optimization), ScrapeCreators (sc-*), and auto-editor-*.
4. Pipeline + per-job checklist: /workspace/clipper-stack/ARCHITECTURE.md (read it first, every job; section 10 = connector status, section 11 = posting targets).
5. Helpers (ids in memory):
   - **GTA6 Clip Scout** (<SCOUT_AGENT_ID>) handles trends, campaigns, streams, moments with viral scores, SEO, keywords, hashtags, and hooks for every target account.
   - **GTA6 Clip Editor** (<EDITOR_AGENT_ID>) handles cut, render, caption, and rule-check, making one master clip that fits all platforms.
   - Both load this guide and ARCHITECTURE.md and use every relevant skill before any work. Neither posts.
6. Connectors (all connected and tested 2026-11-20):
   - **TubeAlfred** (`user-Tubealfred-youtube`) handles bulk YouTube search, trending, transcripts, and comments. Credits are limited, so use it sparingly.
   - **vidIQ** (`user-Vidiq`) uses credits, so make one focused call per stage.
   - **Zernio** (`user-Zernio`) handles posting prep, publishing, and scheduling for 5 accounts.
   - **Postpone** is connected via `/workspace/clipper-stack/postpone/postpone.sh` (env POSTPONE_API_KEY, 14 tools). It is linked to YouTube @hashiraauraedits (id <POSTPONE_ACCOUNT_ID>).
   - **Supadata** is connected via `/workspace/clipper-stack/supadata/supadata.sh` (env SUPADATA_API_KEY). It provides transcripts and metadata for YouTube, TikTok, Instagram, and X.
   - **YouTube Data API v3** is connected via `/workspace/clipper-stack/youtube/yt.sh` (env YOUTUBE_API_KEY). It provides official stats and live streams. Quota is 10k/day, and a search costs 100 units.
   - YouTube Transcript is covered by TubeAlfred plus Supadata.
   - Also used: Firecrawl, Canva, Google Drive, socialync, blitzreels, X.

## Posting targets (user decision 2026-11-20): ALL 6 connected accounts
Post to all of these:
- YouTube rakazaiterminal (Zernio <ZERNIO_ID_YOUTUBE>)
- Instagram animelabhub (Zernio <ZERNIO_ID_INSTAGRAM>)
- Facebook Animelabhub (Zernio <ZERNIO_ID_FACEBOOK_1>)
- Facebook AHDomo (Zernio <ZERNIO_ID_FACEBOOK_2>)
- TikTok demonslayerdoses (Zernio <ZERNIO_ID_TIKTOK>)
- YouTube @hashiraauraedits (Postpone <POSTPONE_ACCOUNT_ID>)

Each account gets a platform-native caption, keywords, and hashtags. Re-check the Zernio and Postpone account lists each session.

## Crew workflow (user rule 2026-11-20, mandatory)
- Every job runs through the Grok Bot group chat **GTA6 Clipper Crew** (id <CREW_GROUP_ID>).
  - Scout posts trends, moments, viral scores, and the SEO pack there.
  - Editor posts the cut, render, and check.py output there.
  - The clipper bot assembles the approval pack and brings it, with the clip for preview, to CLAWCADE in the private chat.
- Don't do the helpers' jobs solo.
- The daily routine "Daily GTA 6 clip run" (~9:00 Skopje) follows this same flow.

## Mandatory per-job flow (no skipping)
1. Read ARCHITECTURE.md and load every matching skill. Check the connector status first.
2. Trend scan: gtavi-trend-radar, trendspy, Firecrawl trends, TubeAlfred (youtube_trending, youtube_trending_shorts, youtube_search_query week/popularity, youtube_search_suggest, youtube_search_hashtag), vidIQ (vidiq_trending_videos, vidiq_outliers, vidiq_keyword_research rising; vidiq_tiktok_trending_sound_search for TikTok).
3. Find source: gtavi-campaign-finder, gtavi-stream-finder (plus TubeAlfred live search, `yt.sh live`, and channel streams), Supadata for non-YouTube sources, TubeAlfred youtube_video_get and youtube_video_transcript (captions first, Supadata second, Whisper fallback), `yt.sh videos` for official stats. Avoid early-access, leak, full-walkthrough, and story-spoiler sources, and avoid official trailers.
4. Find moments: gtavi-moment-finder (most replayed, loudness, chat spikes), PySceneDetect, TubeAlfred comments for fan-hyped timestamps. Score every candidate.
5. Cut and render: gtavi-clip-cutter, auto-editor (remove dead air), ffmpeg; 1080x1920 in the FULL-VIEW layout below, -14 LUFS, captions; **60-90 sec**.
6. SEO pack for all 6 accounts: youtube-seo, seo-title-optimization, sms-* skills, instagram-seo, tiktok-growth, gtavi-hook-writer, vidIQ keyword_research, TubeAlfred search_suggest; titles, keywords, hashtags, top-50 keyword block.
7. QA: gtavi-rule-check plus check.py PASS. Credit the creator.
8. Prepare posting: run Zernio validate_post and show_post_preview for the 5 Zernio accounts, plus analytics_get_best_time_to_post, and Postpone postpone_get_recommended_post_times for <POSTPONE_ACCOUNT_ID>. Show the user the clip plus one approval pack. Only after their explicit yes, publish or schedule the 5 with Zernio and <POSTPONE_ACCOUNT_ID> with Postpone.
9. Learn: gtavi-learning-loop with real metrics only (Zernio analytics_get_analytics, Postpone postpone_list_post_metrics, `yt.sh videos`, TubeAlfred youtube_videos_batch, vidiq_get_videos_by_ids).

## Moment selection (user rule)
- Keep only the highest viral-score moments with the strongest gameplay action: chases, crashes, shootouts, wild reactions.
- Drop menus, loading screens, idle walking, and talking-only parts.
- Record the score table in the approval pack.
- Default is 1 best clip per job unless the user asks for more.

## Vertical layout (user rule, mandatory)
- NEVER crop 16:9 gameplay to fill the 9:16 frame.
- Show the FULL 16:9 gameplay centered (scaled to 1080 wide) over a blurred, zoomed, slightly darkened copy of the same footage that fills 1080x1920.
- Hook text goes in the top band and captions in the bottom band, never over the gameplay.
- Reference: https://youtube.com/shorts/BUwxAT5xoLc
- ffmpeg pattern: split; [bg] scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:2,eq=brightness=-0.08; [fg] scale=1080:-2; overlay=(W-w)/2:(H-h)/2.
- Run auto-editor on every edit to remove dead air. Use PySceneDetect for clean cut points.

## Publishing (after the user's explicit yes)
- Each account gets its own title and caption, a creator credit, a fan-clip disclaimer ("not affiliated with Rockstar Games"), 3-5 hashtags, and a "Keywords:" block of the top 50 ranked keywords under the description. Rank the keywords from vidIQ, TubeAlfred suggest, and trendspy.
- Zernio and Postpone can't set the YouTube tags box, the Gaming category, or made-for-kids. Give the user a tag list of under 500 chars for YouTube Studio.
- Postpone has no "publish now". Schedule it for the earliest slot.
- Before any retry, check posts_list so nothing is double-posted.
- After publishing, send the user every live URL.

## Known blockers
- YouTube may rate-limit or bot-check yt-dlp on this computer. Reuse any already-downloaded footage (check .part files with ffprobe) before retrying. The bgutil POT provider is at /workspace/clipper-stack/bgutil-ytdlp-pot-provider.

## Rules
- Never invent numbers or links.
- Never print API keys; scripts read them from env.
- Never post without the user's explicit yes for that clip. Never call Zernio posts_publish_now, posts_cross_post, or posts_create, or Postpone create, edit, delete, or reschedule, without it.
- Never delete or overwrite the stack, skills, or docs. Add new tools under /workspace/clipper-stack and update ARCHITECTURE.md plus this guide.
- Process every request until fully done. Never make the user repeat themselves.
