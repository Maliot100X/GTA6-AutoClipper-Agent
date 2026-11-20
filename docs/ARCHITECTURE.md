> Sanitized copy of the build-box architecture doc. Paths (`/workspace/...`) refer to the original box; after install.sh the equivalents live in your install dir (`vendor/gtavi-claudecode`, `scripts/helpers`, `bin/auto-editor`). Private account IDs are placeholders.

# Clipper stack architecture (Step 2)

**Date:** 20 Nov 2026, early morning, Europe/Skopje (UTC+1)  
**Purpose:** Automated GTA 6 clipping desk. Clips are always **60–90 seconds** (min 60, max 90). Nothing is uploaded or scheduled without an explicit human "yes".

This document is the operating architecture for the box after Step 1 (install and audit of [gtavi-claudecode](https://github.com/Bodila51/gtavi-claudecode)) and Step 2 (length patch, complementary tools, skills, and the per-job checklist). MCP/connector servers were **not** added here; candidates for the parent to connect are in §7.

Related docs:

- Step 1 audit: `/workspace/gtavi-claudecode/AUDIT.md`
- This file: `/workspace/clipper-stack/ARCHITECTURE.md`

---

## 1. Clip length patch (verified)

Defaults in `/workspace/gtavi-claudecode` and the `gtavi-*` workflow copies were changed from 7–30s / 15–40s / 7–60s to **min 60, max 90**.

| File | Change |
|---|---|
| `scripts/check.py` | Default rules `min=60.0`, `max=90.0` |
| `scripts/moments.py` | `--min` default 60, `--max` default 90 (`--max-minutes 90` is still the source-VOD cap) |
| `scripts/live.py` | `--before` 30, `--after` 50 (about 80s, inside the window) |
| `skills/clip-cutter/SKILL.md` + workflow copy | Trim 60–90s for every clip |
| `skills/moment-finder/SKILL.md` + workflow copy | Command includes `--min 60 --max 90` |
| `skills/live-mode/SKILL.md` + workflow copy | Spike window 30s before / 50s after |
| `skills/playbook/references/playbook.md` + workflow copy | Tight trim and platform tables set to 60–90s |
| `README.md` | Hook rule and moment-finder blurb updated |

`check.py` smoke test after the patch (1080×1920, 30 fps, audio present):

| Clip | Expected | Result |
|---|---|---|
| 8s | FAIL duration | `FAIL duration 60-90s (default) [8.0s]`, EXIT 1 |
| 60s | PASS | `PASS duration 60-90s (default) [60.0s]`, EXIT 0 |
| 75s | PASS | `PASS duration 60-90s (default) [75.0s]`, EXIT 0 |
| 90s | PASS | `PASS duration 60-90s (default) [90.0s]`, EXIT 0 |
| 95s | FAIL duration | `FAIL duration 60-90s (default) [95.0s]`, EXIT 1 |

If a campaign file is present, its `min_seconds` / `max_seconds` still override, but the page default is 60–90. After auto-editor tightens a clip, always re-run `check.py`. A 75s test clip with 15s of silence was cut to **60.4s** and still **PASS**ed.

---

## 2. How the desk is arranged

```
Trend scan  ->  Find source  ->  Cut  ->  Caption / SEO / hashtags  ->  Rule-check  ->  Human yes  ->  Schedule / post  ->  Learn
```

Every job walks this path. The checklist in §8 is mandatory. If a tool, skill, or already-connected connector in a stage cannot be used, write the reason in the job log (`log.md`) and use the listed fallback. Do not silently skip a stage.

Local roots:

- Core desk: `/workspace/gtavi-claudecode` (venv `.venv`, scripts, original skills)
- Complementary stack: `/workspace/clipper-stack/<name>`
- Copied skills: `/home/box/agent-data/workflows/<slug>/SKILL.md`

Run the core scripts with:

```
/workspace/gtavi-claudecode/.venv/bin/python /workspace/gtavi-claudecode/scripts/<script>.py ...
```

---

## 3. Components

### 3.1 Core repo (Step 1, still the cutter of record)

**https://github.com/Bodila51/gtavi-claudecode** — cloned at `/workspace/gtavi-claudecode`, commit `dd95d393c6f74fe2ac14b0239f8826691e5dcb0e`, MIT, venv Python 3.13.5.

| Piece | When it is used |
|---|---|
| `setup` | Once, after the user answers page name, handle, platforms, niche, timezone and says "yes" |
| `campaign-finder` | Start of every job: live Whop / contentrewards.com / clip.tech rules (via Firecrawl or browser). Never invent rates. |
| `trend-radar` / `trends.py` | Trend scan: YouTube GTA 6 videos, last 24h, views per hour |
| `stream-finder` / `streams.py` | Find who is live on YouTube / Twitch / Kick |
| `moment-finder` / `moments.py` | Find 60–90s moments (loudness, hype words, most replayed, chat) |
| `live-mode` / `live.py` | Record a live stream and cut ~80s around chat spikes |
| `twitch-reaction` / `facecam.py` | Face-on-top react layout when the source is a streamer webcam |
| `hook-writer` (`gtavi-hook-writer`) | Three GTA-specific hook options per clip |
| `clip-cutter` / `cut.py` | Render 1080×1920, 30 fps, captions, hook box, −14 LUFS |
| `multilang` / `translate.py` | Localized ES/PT/DE/RU versions when that is the plan |
| `rule-check` / `check.py` | Gate every clip (now 60–90s by default) |
| `questions-to-posts` / `secrets-map` / `cheat-codes` | Side loops for HOW TO, verified tips, cheat carousels |
| `playbook` / `learning-loop` / `payouts.py` | Daily routine and real-number learning |

Already installed here: ffmpeg / ffprobe 7.1.5, yt-dlp 2026.10.26, faster-whisper 1.2.1, OpenCV 5.1.0, edge-tts 7.3.1, deep-translator 1.11.4, YuNet face model cached. No GPU; Whisper runs on CPU. The Whisper `small` model downloads on the first `moments.py` run.

### 3.2 New local tools (Step 2, installed and smoke-tested)

#### auto-editor

- URL: https://github.com/WyattBlue/auto-editor
- License: Unlicense (public domain)
- Source clone: `/workspace/clipper-stack/auto-editor` @ `779a6024347912947130ef4b97d58f9829c5e031` (19 Nov 2026 19:27 -0500 → **20 Nov 2026, 01:27 AM Europe/Skopje**)
- Runtime: official Linux x86_64 binary **31.9.0** (release published 13 Nov 2026, 19:17 Europe/Skopje) at `/workspace/clipper-stack/auto-editor/bin/auto-editor`
- SHA256: `5a921b1396ebf72e27d4bec106894782b739b30a908bd195d63a42e80524548e`
- Current Git HEAD is a Nim rewrite; pip is no longer the install path. The official binary was used instead of compiling from source.
- When: after a raw 60–90s candidate is cut (or on a slightly longer window before the final cut) to remove dead air / motionless game. Then re-check 60–90s. If the result falls under 60s, widen the source window and re-cut; do not ship a short clip.
- Smoke: 75.0s test clip with 15s of silence → **60.4s** output; `check.py` **PASS** (`duration 60-90s [60.4s]`). `--version` printed `31.9.0`.

#### PySceneDetect

- URL: https://github.com/Breakthrough/PySceneDetect
- License: BSD-3-Clause
- Path: `/workspace/clipper-stack/PySceneDetect` @ `8a0b5cea50fef0bc216fb230c7010556dcf5010e` (17 Nov 2026 22:14 -0500 → **18 Nov 2026, 04:14 AM Europe/Skopje**)
- Venv: `/workspace/clipper-stack/PySceneDetect/.venv`
- Version: **0.7.4-dev0** (editable install of the audited clone; PyPI stable is 0.7.3)
- CLI: `/workspace/clipper-stack/PySceneDetect/.venv/bin/scenedetect`
- When: find hard cuts and shot changes in a VOD or clip so moment starts/ends snap to a clean edit, complementary to audio/chat scoring in `moments.py`.
- Smoke: 8s video with a color cut at 4s → scenes at `00:00:00.000` and `00:00:04.000` (exactly 4.000s / 120 frames each).

#### trendspy (Google Trends)

- URL: https://github.com/sdil87/trendspy
- License: MIT
- Path: `/workspace/clipper-stack/trendspy` @ `5803287794edcfb5cd5685a2b0a6148dce3d3cd7` (25 Dec 2024 14:29 +0300 → **25 Dec 2024, 12:29 PM Europe/Skopje**)
- Venv: `/workspace/clipper-stack/trendspy/.venv`
- Version: **0.1.6**
- When: trend scan for Google Search interest (and region) on "GTA 6" and clip-topic keywords. Unofficial Google endpoint; can 429. If it fails, use Firecrawl `firecrawl-trends` and vidIQ. Do not invent volumes.
- Smoke: `interest_over_time("GTA 6")` returned a 53-week DataFrame; interest index reached **100** in the week of 15 Nov 2026 (UTC, marked partial). `interest_by_region` also succeeded. `related_queries` hit a quota error; `trending_now` failed to parse. Primary methods work; treat related-queries as best-effort.

### 3.3 Skill packs copied into the workflow library (no overwrites)

33 skills copied; none skipped (no slug collisions). Full folders including `references/` when present.

**From https://github.com/social-media-skills/skills** (MIT, 106-skill pack, clone `f28cef2`, 15 Oct 2026 16:55 +0200 → **15:55 Europe/Skopje**). Focused subset, not all 106:

`hashtag-strategy`, `social-seo`, `caption-writer`, `captions-and-clipping`, `sms-hook-writer` (from their `hook-writer`; kept distinct from `gtavi-hook-writer`), `short-form-video-script`, `reels-script`, `platform-specs-and-validation`, `scheduling-and-queue`, `analytics-and-reporting`, `youtube-shorts`, `youtube-publishing-and-metadata`, `youtube-long-form`, `tiktok-growth`, `tiktok-script`, `instagram-seo`, `instagram-growth`, `x-growth`, `trend-jacking`, `cross-platform-repurposing`, `thumbnail-design`, `competitor-analysis`.

**From auto-editor:** `auto-editor`, `auto-editor-transcribe`, `auto-editor-effects`, `auto-editor-transitions`, `auto-editor-export`.

**From https://github.com/Illyism/seo-skills** (README: MIT © Ilias Ism; no LICENSE file in the clone; last commit `99d51a3`, 16 Nov 2026 22:27 +0700 → **16:27 Europe/Skopje**). Only the video-relevant pair was copied: `youtube-seo`, `seo-title-optimization`. The other 28 skills stay in the clone (many need Ahrefs / DataForSEO paid keys or are website-SEO).

**From https://github.com/ScrapeCreators/social-media-research-skills** (MIT, `64ba7b4`, 26 Aug 2026): `sc-trend-discovery`, `sc-outlier-post-finder`, `sc-comment-mining`, `sc-transcript-intelligence`. These skills prefer `SCRAPECREATORS_API_KEY`. That key is **not** on this box. Use the same job steps, but pull live data from **Firecrawl's already-available ScrapeCreators / anyapi / youtube-com / firecrawl-trends providers**, plus vidIQ and YouTube Transcript. Do not invent a key.

All of these packs say the agent drafts and the human approves before posting. Keep that rule.

### 3.4 User connectors already on this bot (do not reinstall)

Wire these in at the stages below. Confirm each is actually usable at the start of a work session.

| Connector | Pipeline role |
|---|---|
| **TubeAlfred** (`user-Tubealfred-youtube`, CONNECTED + tested 2026-11-20) | Replaces the YouTube / YouTube Transcript / Supadata role: `youtube_search_query` (upload_date=week, sort=popularity, live/shorts filters), `youtube_trending`, `youtube_trending_shorts`, `youtube_search_suggest` (keywords), `youtube_search_hashtag`, `youtube_video_transcript` (caption-first, before local Whisper), `youtube_video_get/enhanced`, `youtube_videos_batch`, `youtube_comments_list` (fan questions), `youtube_related_videos`, `youtube_channel_*` (streams, shorts). Skills: `youtube-discovery-research`, `youtube-video-research`, `youtube-audience-research`. Read-only. |
| YouTube, YouTube Transcript, Supadata, Postpone | NOT in this account's connector catalog (searched 2026-11-20). Not connected. TubeAlfred + Firecrawl `youtube-com` cover reads; posting goes via Zernio / socialync / blitzreels after "yes". |
| **vidIQ** (`user-Vidiq`, CONNECTED + tested 2026-11-20, 98 tools; most calls cost vidIQ credits) | `vidiq_keyword_research` (volume/competition/rising/questions), `vidiq_trending_videos`, `vidiq_outliers`, `vidiq_instagram_tiktok_outlier_search`, `vidiq_tiktok_trending_sound_search`, `vidiq_youtube_search`, `vidiq_get_videos_by_ids` (VPH, outlier score). Keyword research, outliers, trending videos, title/thumbnail scoring, comment insights. Hosted MCP: `https://mcp.vidiq.com/mcp` — https://github.com/vid-io/vidiq-mcp |
| **Firecrawl** | Live campaign pages (Whop, Clip.tech); also Alexandria providers already discoverable on this session: `firecrawl-trends` (trending now / suggestions), `anyapi` TikTok trending hashtags, `youtube-com` video details/transcripts/search, `scrapecreators` TikTok/YouTube/Instagram public data. `FIRECRAWL_API_KEY` is configured on the Firecrawl connector (not in the box shell env). |
| **Canva** | Cheat-code and secrets carousels, thumbnails, cover slides |
| **X** | Launch-day first wave, trends on X, posting after "yes" |
| **Google Drive** | `media/` backup and share |
| **blitzreels** | Short-form publishing / reel tooling after "yes" |
| **socialync** | Cross-network social publishing after "yes" |
| **Zernio** (`user-Zernio`, CONNECTED + tested 2026-11-20, 53 tools) | Posting prep and scheduling AFTER "yes": `accounts_list`, `validate_post` and `show_post_preview` (pre-flight, no publish), `analytics_get_best_time_to_post`, `posts_create` with schedule (only after yes), `analytics_get_analytics` and `show_analytics` (learning loop), `comments_list_inbox_comments`. Never call posts_publish_now / posts_cross_post / posts_create without the user's explicit yes for that clip and account. |
| GitHub / Vercel | Not required for a clipping job; already connected |

---

## 4. When each piece is used

### Stage A — Trend scan (every job, before picking a source)

Must use:

1. `gtavi-trend-radar` (`trends.py`) for YouTube velocity.
2. vidIQ trending / keyword / outlier tools.
3. trendspy `interest_over_time` (and region if useful) for the target keywords.
4. Firecrawl `firecrawl-trends` and, for TikTok hashtags, Firecrawl `anyapi` / `scrapecreators` providers; follow `sc-trend-discovery` and `trend-jacking`.
5. `gtavi-campaign-finder` via Firecrawl or a live page read. Refresh `campaigns.md`. Skip leak / "play early" campaigns.

Output: a short brief (what's rising, campaign rules, 3 candidate sources) written to the page folder.

### Stage B — Find the source and the 60–90s moment

Must use:

1. `gtavi-stream-finder` if the job is live; else the trend-radar / vidIQ picks.
2. YouTube + YouTube Transcript (or Supadata) for metadata and captions when the source is YouTube.
3. `gtavi-moment-finder` with `--min 60 --max 90`, or `gtavi-live-mode` for a live URL.
4. PySceneDetect on the downloaded source (or the candidate window) to snap starts/ends to clean cuts.
5. `sc-outlier-post-finder` / vidIQ outliers when comparing which source is actually performing.
6. Drop leaks, spoilers in launch week, nudity, and anything without credit/permission or campaign coverage.

Output: `jobs/<id>/candidates.md` plus a recommended pick of 60–90s.

### Stage C — Cut

Must use:

1. `gtavi-hook-writer` (three options, pick one). General social hook craft can consult `sms-hook-writer`, but the on-screen GTA hook comes from the GTA skill.
2. `gtavi-clip-cutter` / `cut.py` (or `gtavi-twitch-reaction` when it is a webcam reaction).
3. auto-editor to tighten dead air **without** going below 60s or above 90s. Re-cut a wider window if tightening undershoots 60s.
4. `auto-editor` / `captions-and-clipping` skills for optional extra caption or transition passes; the burned captions from `cut.py` remain the default.

Output: `jobs/<id>/edits/clip_<n>.mp4` at 1080×1920, 30 fps, 60–90s.

### Stage D — Caption, SEO, hashtags

Must use:

1. `social-seo` then `hashtag-strategy` (keywords first, tight niche tags, platform caps).
2. `caption-writer` plus playbook caption templates. Credit the creator in the caption, not burned into the video.
3. Platform-specific skills: `youtube-publishing-and-metadata` + `youtube-seo` + `seo-title-optimization` + vidIQ title scoring for Shorts; `tiktok-growth` / `tiktok-script` for TikTok; `instagram-seo` for Reels; `x-growth` for X (X captions have no hashtags in the GTA playbook).
4. `platform-specs-and-validation` against current limits.
5. `sc-comment-mining` / vidIQ comments / `questions-to-posts` when the post type is HOW TO.
6. Canva for carousels and thumbnails (`thumbnail-design`, `gtavi-cheat-codes`, `gtavi-secrets-map`).

Never invent search volume. If a research tool fails, say so and use a smaller evidence-backed tag set.

### Stage E — Rule-check (hard gate)

Must use `gtavi-rule-check` / `check.py` on the final file (and each language version). Check length 60–90s, 1080×1920, audio, banned terms, required campaign hashtags/mentions, credit, no "official" wording, no leaks. Fix and re-check until PASS. Then show the human the file, caption, credit, and destination.

### Stage F — Schedule / post (only after "yes")

The human posts, or asks to schedule. Then:

1. `scheduling-and-queue` for the plan.
2. Postpone as the default scheduler.
3. X, YouTube, blitzreels, socialync, or the platform's own connector as applicable.
4. Never auto-upload from yt-dlp, auto-editor, or any script.

### Stage G — Learn

`gtavi-learning-loop` at 12h / 24h / 72h with numbers the human pastes or a connector can actually read. `analytics-and-reporting` for the write-up. `payouts.py` only with rates and views the campaign really showed. One test per day.

---

## 5. Installed (name, URL, version, proof)

| Name | URL | Version / commit | Proof |
|---|---|---|---|
| gtavi-claudecode (from Step 1, length-patched) | https://github.com/Bodila51/gtavi-claudecode | `dd95d39` + local 60–90 defaults | `check.py`: 60/75/90s PASS, 8s and 95s FAIL |
| auto-editor official binary | https://github.com/WyattBlue/auto-editor/releases/tag/31.9.0 | **31.9.0** (`./auto-editor --version`) | 75.0s → 60.4s; `check.py` PASS |
| auto-editor source + skills | https://github.com/WyattBlue/auto-editor | `779a602` | cloned; five skills copied |
| PySceneDetect | https://github.com/Breakthrough/PySceneDetect | **0.7.4-dev0** | hard cut detected at 00:00:04.000 |
| trendspy | https://github.com/sdil87/trendspy | **0.1.6** | `interest_over_time("GTA 6")` 53 rows, peak 100 week of 15 Nov 2026 UTC |
| social-media-skills (selected) | https://github.com/social-media-skills/skills | `f28cef2` | 22 skills copied (incl. `sms-hook-writer`) |
| seo-skills (selected) | https://github.com/Illyism/seo-skills | `99d51a3` | `youtube-seo`, `seo-title-optimization` copied |
| social-media-research-skills (selected) | https://github.com/ScrapeCreators/social-media-research-skills | `64ba7b4` | four `sc-*` skills copied |

Commands:

```
/workspace/clipper-stack/auto-editor/bin/auto-editor --version
/workspace/clipper-stack/PySceneDetect/.venv/bin/scenedetect version
/workspace/clipper-stack/trendspy/.venv/bin/python -c "from trendspy import Trends; print('trendspy OK')"
```

---

## 6. Rejected or not installed (and why)

| Candidate | Why |
|---|---|
| m-bain/whisperX | Strong aligner, but needs a large PyTorch stack and prefers a GPU this box does not have. faster-whisper is already in the core desk. Revisit if a GPU appears. |
| GeneralMills/pytrends | Older unofficial client; **trendspy** plus Firecrawl `firecrawl-trends` cover this job better. |
| dkyazzentwatwa/vid-clipper | ~12 stars, no license, last push Mar 2026, overlaps `cut.py`. |
| kiy0ni/auto-video-editor | ~12 stars; heavily overlaps the GTA desk (facecam, YuNet, vertical shorts). |
| aiXander/auto-caption-videos | 1 star; redundant with `cut.py` captions. |
| frsname/capforge | UI-heavy caption app; not needed once `cut.py` + youtube-seo are in the stack. |
| sorabhv/social-media-strategist | 1 star, hackathon prototype. |
| rushindrasinha/youtube-shorts-pipeline | End-to-end pipeline that includes upload. Against the no-auto-upload rule. |
| haziq-exe/tiktokautouploader | Auto-uploads to TikTok. Rejected. |
| Unofficial TikTok scrapers (e.g. riyagoelrs/tiktok-scraper) | Weak/unofficial, ToS and security risk. Use Firecrawl / vidIQ instead. |
| OpenClip-App/agent-skills | Not installed locally. Clipping pipeline needs an OpenClip subscription. Listed as an MCP candidate only. |
| gooseworks-ai video-clipper | Requires paid Klap and Captions.ai keys. |
| apify/agent-skills trend pack | Requires an Apify token. |
| dudleypeacockqa "youtube-seo" agency repo | Needs PostgreSQL and a mixed marketing tree; Illyism `youtube-seo` is cleaner. |
| Hermes content-engine / hermes-studio / hermes-seo | Hermes-runtime plugins, not installable as this bot's local stack. URLs kept as marketplace references: https://hermes-agent.nousresearch.com/marketplace/content-engine , https://hermes-agent.nousresearch.com/marketplace/hermes-studio , https://hermes-agent.nousresearch.com/marketplace/hermes-seo |
| Grok Bot Marketplace desks (Clip Bot, Stills & Clips Desk, SEO & AEO Desk) | The user adds these in bot settings: https://x.ai/bot/marketplace |
| pip `auto-editor` 29.3.1 | Officially discontinued on PyPI; official binary 31.9.0 was used instead. |
| Building auto-editor from Nim source (`nimble makeff`) | Heavy dependency build; official binary is the supported path. |
| Compiling / adding any MCP server or connector | Explicitly out of scope for this step. |
| Remaining 28 Illyism skills and the other ~80 social-media-skills | Left in the clones for later; many are website-SEO, LinkedIn, Pinterest, or need paid SERP APIs. |

Security scan of everything that was cloned: no `curl | bash`, no credential exfil, no obfuscation, no postinstall hooks. trendspy talks only to `trends.google.com`. ScrapeCreators skills are markdown and document `https://api.scrapecreators.com` behind an env key we do not have.

---

## 7. MCP / connector candidates for the parent to add

Do **not** add these from the box. Already-connected connectors should be preferred before adding duplicates.

**Connected / installed (see §10 for live status):** TubeAlfred (connected), vidIQ (connected), Zernio (connected), Firecrawl (including its trends / YouTube / TikTok providers), Canva, X, Google Drive, blitzreels, socialync, Zernio, GitHub, Vercel.

**Worth adding if the connected set has gaps:**

1. **Virlo TikTok MCP** — trending sounds, hashtags, hooks, public TikTok transcripts. https://virlo.ai/mcp/tiktok — server `https://dev.virlo.ai/api/mcp/mcp`
2. **Trends MCP** — multi-source boards including Google Trends, YouTube, TikTok hashtags. https://api.trendsmcp.ai/mcp — listing https://mcp.so/ja/servers/trends-mcp (and https://github.com/trendsmcp-ai/google-trends-mcp). Useful if trendspy or Firecrawl trends prove brittle.
3. **OpenClip MCP** — hosted editor for captioned shorts. `https://openclip.app/mcp` — https://github.com/OpenClip-App/agent-skills — clipping pipeline is paid; five media utilities are free with an account.
4. ~~TubeAlfred~~ — installed and connected in Step 4 (§10).

**Optional / lower priority:**

- Illyism SEO MCPs bundled in the clone's `.mcp.json` (website SEO, not required for clipping): `https://aiseotracker.com/api/agent/mcp`, `https://scribiz.com/mcp`, `https://awesome.tools/mcp`
- Unofficial Google Trends MCPs: https://github.com/HasData/google-trends-mcp , https://github.com/trendsmcp-ai/google-trends-mcp
- video-decomposer-mcp (yt-dlp + WhisperX): https://github.com/icooper/video-decomposer-mcp — heavy, needs GPU for a fair shot
- Eli-xir/youtube-transcript-mcp: https://github.com/Eli-xir/youtube-transcript-mcp — redundant if YouTube Transcript already works

**Marketplaces (not MCP installs):** https://x.ai/bot/marketplace (Clip Bot, SEO & AEO Desk, Stills & Clips Desk); https://hermes-agent.nousresearch.com/marketplace ; https://www.skills.sh ; https://skillsmp.com ; https://clawhub.ai ; https://agentskills.io

A useful paid key the parent could add later, without a new MCP: `SCRAPECREATORS_API_KEY` for the `sc-*` skills. Until then, Firecrawl's ScrapeCreators providers are the path.

---

## 8. Mandatory per-job checklist

Copy this into the job log and tick every line. Clips are always 60–90 seconds. If a box cannot be completed, write why and the fallback used. Do not start the next stage with an incomplete gate.

```
JOB ID:
SOURCE URL / FILE:
CAMPAIGN (or "none — own page"):
DATE / TIME (Europe/Skopje):

[A] TREND SCAN
[ ] gtavi-campaign-finder ran (Firecrawl or live page); campaigns.md updated; no invented rates
[ ] gtavi-trend-radar / trends.py ran
[ ] TubeAlfred youtube_trending / trending_shorts / search_query (week, popularity) / search_suggest consulted
[ ] vidIQ keyword_research + trending_videos + outliers consulted (+ tiktok_trending_sound_search for TikTok)
[ ] trendspy interest_over_time (and region if useful) for the target keywords
[ ] Firecrawl trends and/or TikTok hashtag providers consulted (sc-trend-discovery / trend-jacking)
[ ] Leak / play-early / piracy sources dropped

[B] FIND
[ ] stream-finder or a VOD/url pick documented
[ ] TubeAlfred: youtube_video_get + youtube_video_transcript (+ comments) used when the source is YouTube
[ ] YouTube Data API (yt.sh videos/live) for official stats and live streams
[ ] Supadata (supadata.sh) transcript/metadata as second source or for non-YouTube sources
[ ] moments.py --min 60 --max 90  OR  live.py (30s before / 50s after)
[ ] PySceneDetect run to snap to a clean cut
[ ] Permission or campaign coverage confirmed; creator recorded for credit

[C] CUT
[ ] gtavi-hook-writer produced 3 options; one picked
[ ] cut.py (or twitch-reaction) rendered 1080x1920 30fps
[ ] auto-editor used to tighten dead air
[ ] Duration still 60–90s after tightening (re-cut if not)

[D] CAPTION / SEO / HASHTAGS
[ ] social-seo + hashtag-strategy applied (keywords first, tight tags, platform caps)
[ ] caption-writer + credit in the caption (not on the video)
[ ] Platform pack used (youtube-seo / youtube-publishing-and-metadata / tiktok-* / instagram-seo / x-growth)
[ ] vidIQ title/keyword score when posting to YouTube
[ ] platform-specs-and-validation checked
[ ] Canva only if a carousel/thumbnail is part of this job

[E] RULE-CHECK (HARD GATE)
[ ] check.py PASS at 60–90s, 1080x1920, audio, no banned terms, campaign tags/mentions
[ ] Manual read: no fake facts, no "official", no spoilers in launch week, credit present
[ ] Human shown file + caption + credit + destination; waiting for "yes"

[F] POST / SCHEDULE (ONLY AFTER YES)
[ ] scheduling-and-queue plan
[ ] Zernio validate_post + show_post_preview passed; best_time_to_post checked
[ ] Postpone postpone_create_social_post for @hashiraauraedits (after yes)
[ ] Zernio posts_create (scheduled) / socialync / blitzreels / X ONLY on the account the human named, after "yes"
[ ] Nothing uploaded by a script

[G] LEARN
[ ] scoreboard row written
[ ] 12h / 24h / 72h reads planned or filled with real numbers only
[ ] payouts.csv only if a campaign showed a real rate and view count
```

Lock: do not mark a job done, and do not start a second clip as "done", until A–E are complete and F has a human "yes" or an explicit "hold".

---

## 9. What is still waiting on the user

- Page setup questions (name, handle, platforms, niche, timezone) and one "yes" to create the page folder.
- Connecting any MCP from §7 that they want (none were added here).
- Optional `TWITCH_CLIENT_ID` / `TWITCH_TOKEN` for official Helix (keyless GQL already worked in Step 1).
- Optional `SCRAPECREATORS_API_KEY`.
- First real `moments.py` run will download the Whisper `small` model.
- The image attached in the original request could not be read by the Step 1/2 executor (private to the parent). Overlay any extra instructions from that image onto this checklist if needed.

Subagents, memory/guide files, and auto-approval rules were not created in this step.


---

## 10. Step 4 — App connections (2026-11-20, Europe/Skopje)

| App from user's image | Status | Server id | Proof |
|---|---|---|---|
| Supadata | CONNECTED via REST helper `/workspace/clipper-stack/supadata/supadata.sh` (env `SUPADATA_API_KEY`) | — | live test 2026-11-20: transcript of https://www.youtube.com/watch?v=169ZzvPxvvM (hi) and metadata (8,689,332 views, 7516s). Use as transcript/metadata fallback after TubeAlfred, and for non-YouTube sources (TikTok, Instagram, X) via `supadata.sh raw` |
| YouTube (official Data API v3) | CONNECTED via helper `/workspace/clipper-stack/youtube/yt.sh` (env `YOUTUBE_API_KEY`) | — | live test 2026-11-20: videos.list on https://www.youtube.com/watch?v=169ZzvPxvvM (8,711,948 views, PT2H5M16S); search for GTA 6 videos from the last 7 days returned results. Use for official stats, `live` stream finding, and campaign view verification. Quota is 10k/day (search=100 units), so bulk discovery stays on TubeAlfred |
| YouTube Transcript | Covered by TubeAlfred youtube_video_transcript + Supadata (no separate key needed). Previously substituted by **TubeAlfred** (plugin 68849961) — CONNECTED | `user-Tubealfred-youtube` | 34 tools listed; live test `youtube_search_query("GTA 6", week, popularity)` returned real results, e.g. https://www.youtube.com/watch?v=LMbea5SozeM (Mythpat, 15.4M views) and https://www.youtube.com/watch?v=169ZzvPxvvM (Techno Gamerz, 8.66M views) |
| vidIQ MCP | CONNECTED (plugin 89150879, 98 tools, 15 vidiq-* skills) | `user-Vidiq` | live test `vidiq_keyword_research("gta 6")`: ~53.8M est. monthly searches, competition 70, +508.7% growth; best related: "gta 6 gameplay" (10.4M, comp 61), "gta 6 secrets" (98K, +1699.7%), "gta 6 features" (188K, comp 41) |
| Zernio MCP | CONNECTED (plugin, 53 tools) | `user-Zernio` | live test `accounts_list`: 5 accounts are linked: YouTube rakazaiterminal, Instagram animelabhub, Facebook Animelabhub and AHDomo, and TikTok demonslayerdoses. None is GTA-specific, so the user picks the target page and account before any post. |
| Postpone | CONNECTED via MCP helper `/workspace/clipper-stack/postpone/postpone.sh` (env `POSTPONE_API_KEY`, endpoint https://api.postpone.app/mcp) | — | live test 2026-11-20: 14 tools; `postpone_list_social_accounts` → YouTube @hashiraauraedits (id <POSTPONE_ACCOUNT_ID>, 3,010 followers, connected). Use `postpone_get_recommended_post_times`, `postpone_get_account_stats`, `postpone_list_post_metrics`; create/edit/delete/reschedule only after yes |

Step 4 complete 2026-11-20: all reachable apps are connected and tested.


---

## 11. Posting targets (set by the user 2026-11-20)

Every finished clip is prepared for ALL connected accounts (5 in Zernio + 1 in Postpone), each with its own platform-native caption, keywords, and hashtags:

| Platform | Account | Zernio account ID |
|---|---|---|
| YouTube Shorts | rakazaiterminal | <ZERNIO_ID_YOUTUBE> |
| Instagram Reels | animelabhub | <ZERNIO_ID_INSTAGRAM> |
| Facebook Reels | Animelabhub | <ZERNIO_ID_FACEBOOK_1> |
| Facebook Reels | AHDomo | <ZERNIO_ID_FACEBOOK_2> |
| TikTok | demonslayerdoses | <ZERNIO_ID_TIKTOK> |
| YouTube Shorts (via **Postpone**) | @hashiraauraedits | Postpone social_account_id <POSTPONE_ACCOUNT_ID> |

Flow per clip: run Zernio validate_post and show_post_preview for all 5 accounts and analytics_get_best_time_to_post, then show the user one approval pack (file, captions, times). After the user's yes, schedule all 5 with posts_create. Re-check accounts_list at the start of each session, because accounts can change.
