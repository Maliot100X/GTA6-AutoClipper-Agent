# AUDIT: gtavi-claudecode (Step 1)

**Repo:** https://github.com/Bodila51/gtavi-claudecode  
**Cloned to:** `/workspace/gtavi-claudecode`  
**Remote:** `origin https://github.com/Bodila51/gtavi-claudecode`  
**Commit audited:** `dd95d393c6f74fe2ac14b0239f8826691e5dcb0e`  
**Commit date (author, +0200):** 2026-11-19 11:30:05 +0200 → **10:30 AM Europe/Skopje (UTC+1)**  
**Subject:** Facecam: keep the face crop inside the webcam's inner borders  
**License:** MIT (Copyright 2026 Bodila51)  
**Audit date:** 2026-11-20, early morning Europe/Skopje (UTC+1)  
**Python venv:** `/workspace/gtavi-claudecode/.venv`  
**Security verdict:** Clean enough to install. No malware, credential theft, obfuscation, or curl|bash of unknown hosts. See [Security pass](#security-pass) for residual ToS/legal notes (not blockers).

This document is the Step 1 architecture/audit only. Additional skills, GitHub tools, and MCPs listed at the end are **recommendations with verified URLs**. They were **not installed**.

---

## 1. What this repo is

A Claude Code plugin ("GTA 6 Clip Desk") plus a set of local Python scripts for running a faceless GTA 6 clipping page.

It can:

- Find live paid clipping campaigns (Whop Content Rewards, Clip.tech) — skill-only, no script; needs a browser or Firecrawl.
- Rank recent YouTube GTA 6 videos by views per hour (`trends.py`).
- List who is live on YouTube, Twitch (keyless GQL, or official Helix if keys exist), and Kick (`streams.py`).
- Find the best moments in a VOD or file using loudness, hype words, YouTube "most replayed", and chat spikes (`moments.py` + faster-whisper).
- Record a live YouTube or Twitch stream and auto-cut when chat explodes (`live.py`).
- Cut 1080×1920, 30 fps vertical clips with word-by-word captions, a hook box, and −14 LUFS loudness (`cut.py`). Layouts: fill, blur, facecam, react (face on top, game below).
- Auto-find the streamer's webcam box with OpenCV YuNet (`facecam.py`).
- Write hook options and reaction titles (`hook-writer` skill, no script).
- Check a finished clip against resolution, fps, audio, duration, banned terms, required hashtags/mentions (`check.py`).
- Translate one clip into ES/PT/DE/RU (and more) with optional stock Microsoft TTS hook voice (`translate.py`). Never clones a real voice.
- Pull repeated fan questions from Reddit and draft HOW TO posts from `facts.md` only (`questions.py`).
- Build a verified map of hidden spots/cars/collectibles (`secrets_map.py`). Exploits and leaks are refused.
- Turn reported GTA 6 cheat codes into a 4-slide carousel (`cheat-codes` skill + `references/cheats.md`).
- Log real post metrics and campaign payouts the human types in (`learning-loop` + `payouts.py`). Rates are never invented.
- Run a daily playbook. **Nothing is uploaded automatically. Every post needs a human "yes".**

Hard content rules baked in: no leaks, no "play early"/piracy, no GTA Online money or AFK bots, no fake news, never pretends to be Rockstar, credit the creator in the caption (not burned into the video).

This is an unofficial fan project, not affiliated with Rockstar, Take-Two, or Anthropic.

---

## 2. Layout (what is and is not in the repo)

```
/workspace/gtavi-claudecode/
  README.md
  LICENSE                    MIT
  requirements.txt
  .gitignore                 .venv, jobs/, media dumps
  .claude-plugin/
    plugin.json              Claude Code plugin manifest, v0.1.0, skills: ./skills/
    marketplace.json         marketplace entry for /plugin marketplace add
  docs/logo.png
  scripts/                   13 Python modules (see below)
  skills/                    16 SKILL.md skills (2 with references/)
```

**Not present (and not needed for this plugin):** `CLAUDE.md`, `agents/`, `commands/`, hooks, MCP server configs, `package.json`, postinstall scripts, `.npmrc`.

It is a skills + local scripts desk, not an MCP server. External services are called directly (yt-dlp, public APIs, optional Twitch Helix).

---

## 3. Components

### 3.1 Scripts

| Script | What it enables | External calls / deps |
|---|---|---|
| `scripts/common.py` | Shared paths (`CLIP_DESK_HOME` or cwd), `jobs/`, yt-dlp and ffmpeg/ffprobe wrappers | local ffmpeg, yt-dlp |
| `scripts/trends.py` | YouTube search, last N hours, ranked by views/hour | YouTube via yt-dlp, no API key |
| `scripts/streams.py` | Live streams ranked by viewers (YouTube, Twitch, Kick) | yt-dlp; Twitch GQL or Helix; Kick public API |
| `scripts/twitch.py` | Keyless Twitch helpers: public web GQL + anonymous IRC chat (`justinfan`) | `https://gql.twitch.tv/gql`; `irc.chat.twitch.tv:6697` |
| `scripts/moments.py` | Scores 15–40s (default) candidates; writes `jobs/<id>/candidates.md` + `.json` | yt-dlp download, ffmpeg wav extract, faster-whisper `small` model |
| `scripts/live.py` | Records live YT/Twitch in 60s segments; cuts on chat spikes | yt-dlp + ffmpeg; YT live_chat or Twitch IRC |
| `scripts/cut.py` | Renders `jobs/<id>/edits/clip_<n>.mp4` + sidecar JSON | ffmpeg; optional `facecam.py` for `--cam auto` / `--layout react` |
| `scripts/facecam.py` | Finds webcam box (stable face + static border) | downloads YuNet ONNX once from official OpenCV zoo; OpenCV |
| `scripts/check.py` | Pre-post gate. Exit 1 on any FAIL | ffprobe only; optional `campaigns.md` rules |
| `scripts/translate.py` | Per-language captioned cuts + platform caption file | deep-translator (Google Translate unofficial); optional edge-tts (Microsoft neural stock voices) |
| `scripts/questions.py` | Cluster Reddit + pasted comments into HOW TO drafts | `https://www.reddit.com/...json` unauthenticated, 1 req/s |
| `scripts/secrets_map.py` | Scan transcripts into `secrets.csv`; posts only if `verified` | local files only |
| `scripts/payouts.py` | Append/report `payouts.csv`. `est_payout = views/1000 * rate you typed` | local CSV only |

### 3.2 Skills (16)

All are valid `SKILL.md` files with YAML frontmatter (`name`, `description`).

| Skill | Role |
|---|---|
| `setup` | Install ffmpeg / yt-dlp / pip deps; ask 4 questions; after one "yes", build the page folder |
| `campaign-finder` | Live-read Whop / contentrewards.com / clip.tech; write `campaigns.md`; never invent rates |
| `trend-radar` | Runs `trends.py`, picks 3 sources, skips leaks |
| `stream-finder` | Runs `streams.py`, recommends 1–3 public streams |
| `moment-finder` | Runs `moments.py`, recommends best 3, then clip-cutter |
| `live-mode` | Runs `live.py`, reviews spike clips, asks human to post |
| `twitch-reaction` | Face-on-top react layout via `cut.py --layout react --cam auto` |
| `clip-cutter` | Runs `cut.py`; default trim text still says 7–30s (see length gap) |
| `hook-writer` | 3 hook options; reaction title formulas; no clickbait, no fake quotes |
| `rule-check` | Runs `check.py` against `campaigns.md` before any "please post" |
| `multilang` | Runs `translate.py`; stock voices only; human reads translations first |
| `questions-to-posts` | Runs `questions.py`; unanswered items go to `idea-bank.md` as research |
| `secrets-map` | Runs `secrets_map.py`; post verified tips only, credit the finder |
| `cheat-codes` | Carousel from `references/cheats.md` only; status is `reported` until tested in-game |
| `playbook` | Daily routine, launch-day plan, caption templates, safety rules |
| `learning-loop` | Scoreboard + one test/day + real payouts only; no verdict before 24h, prefer 72h |

Reference files:

- `skills/playbook/references/playbook.md` — full page operating system
- `skills/cheat-codes/references/cheats.md` — reported cheat table (as of 2026-11-18); sources are GameSpot, Red Bull, Insider Gaming, Stupid Dope. Not officially confirmed by Rockstar.

### 3.3 Intended workflow

```
setup (once, after user answers 4 questions + "yes")
  -> campaign-finder, trend-radar, stream-finder
      -> moment-finder  or  live-mode
          -> hook-writer
              -> clip-cutter  (or twitch-reaction)
                  -> rule-check
                      -> human "yes"  (they post or schedule)
                          -> learning-loop at 12h / 24h / 72h
```

Side loops: `questions-to-posts`, `secrets-map`, `cheat-codes`, `multilang`.

Page folder (not created in Step 1 — setup skill requires the user's answers and an explicit "yes"): `playbook.md`, `facts.md`, `idea-bank.md`, `watchlist.md`, `log.md`, `scoreboard.csv`, `learning.md`, `takedowns.md`, `campaigns.md`, `payouts.csv`, `media/official`, `media/raw`, `media/edits`.

---

## 4. Security pass

Reviewed all scripts, skills, plugin JSON, requirements, and a pattern scan for curl|bash, eval/exec, os.system, obfuscation, webhooks, credential exfil, postinstall hooks.

**No malicious behavior found.** Install proceeded.

Findings that are **not malware**, but should stay in the threat model:

1. **Hardcoded Twitch web Client-Id** in `scripts/twitch.py`: `kimne78kx3ncx6brgo4mv6wki5h1ko`. This is the well-known public Twitch website Client-Id (also used by yt-dlp), not a stolen private key. Still unofficial; Twitch can block it.
2. **Unofficial Twitch GQL + anonymous IRC** (`justinfan` nick, no password) and a best-effort Kick public API call. These can break or conflict with platform ToS. Official Helix is used only if `TWITCH_CLIENT_ID` and `TWITCH_TOKEN` are set.
3. **yt-dlp downloads** YouTube/Twitch media. Copyright: clip only with campaign permission or the creator's consent; credit in the caption; never auto-upload (the repo already requires a human "yes").
4. **`facecam.py` downloads** `face_detection_yunet_2023mar.onnx` (232,589 bytes) on first use from the official OpenCV zoo: `https://github.com/opencv/opencv_zoo/raw/main/models/face_detection_yunet/face_detection_yunet_2023mar.onnx`. Cached at `~/.cache/gtavi-claudecode/models/`. Verified downloaded and `FaceDetectorYN.create` succeeded.
5. **`moments.py` will download** the faster-whisper `small` model from Hugging Face on first transcription. Not pre-fetched in Step 1 (large). CPU-only on this box (no NVIDIA GPU).
6. **`deep-translator`** talks to unofficial Google Translate; **`edge-tts`** talks to Microsoft Edge TTS. Both can rate-limit or change. Voices are stock neural voices, not voice clones (code and skill text are explicit about this).
7. **`questions.py`** hits Reddit's public JSON with a descriptive User-Agent, 1 request/sec, retry on 429. Reddit often blocks datacenter IPs.
8. **`subprocess.run` / `Popen`** are used only to run ffmpeg, ffprobe, and yt-dlp with argument lists (not `shell=True`). No `curl | bash`, no `eval`, no credential upload, no unexpected domains.
9. **Setup skill** suggests `sudo apt install -y ffmpeg` on Linux. ffmpeg was already present; sudo was not used.
10. **No secrets are bundled.** Optional env vars only: `CLIP_DESK_HOME`, `TWITCH_CLIENT_ID`, `TWITCH_TOKEN`, plus `LOCALAPPDATA` for the Windows model cache path.

---

## 5. Install status (verified)

Clone:

```
git clone https://github.com/Bodila51/gtavi-claudecode /workspace/gtavi-claudecode
CLONE_OK
commit=dd95d393c6f74fe2ac14b0239f8826691e5dcb0e
```

Environment created and deps installed from `requirements.txt` into `/workspace/gtavi-claudecode/.venv` (`pip install -U -r requirements.txt`, exit 0).

| Tool / package | Version (proof) | Status |
|---|---|---|
| Python | 3.13.5 (`python --version`) | OK (repo asks 3.10+) |
| pip | 26.3 | OK |
| ffmpeg | 7.1.5-0+deb13u1 (Debian, already on the box; not freshly apt-installed) | OK |
| ffprobe | 7.1.5-0+deb13u1 | OK |
| yt-dlp | 2026.10.26 (`yt-dlp --version` and `yt_dlp.version`) | Installed in venv |
| faster-whisper | 1.2.1 | Installed |
| numpy | 2.5.5 | Installed |
| requests | 2.34.2 | Installed |
| deep-translator | 1.11.4 (`pip show`; module `__version__` still says 1.9.1, ignore that) | Installed |
| edge-tts | 7.3.1 | Installed |
| opencv-python-headless | 5.1.0.95 (`cv2.__version__` 5.1.0) | Installed |
| ctranslate2 | 4.9.0 | Installed (CPU) |
| NVIDIA GPU | `nvidia-smi` missing | CPU transcription only |
| YuNet face model | 232,589 bytes at `/home/box/.cache/gtavi-claudecode/models/face_detection_yunet_2023mar.onnx` | Downloaded; detector created OK |
| faster-whisper `small` weights | not downloaded yet | First `moments.py` run will fetch them |

Smoke tests (no missing secrets required):

- Every script with a CLI accepted `--help` (`twitch.py` is a library; import succeeded).
- `payouts.py report` → `no payouts logged yet`.
- `secrets_map.py map` → `0 entries`.
- Synthetic 8s 1080×1920 30fps clip: `check.py` **PASS** (default 7–60s window).
- Synthetic 3s 1080×1920: **FAIL** duration `[3.0s]` (expected).
- Synthetic 8s 1280×720: **FAIL** resolution `[1280x720]` (expected).
- Synthetic **75s** 1080×1920 against a `campaigns.md` with `min_seconds: 60`, `max_seconds: 90`, required `#GTA6 #GTAVI` and `@creator`: **PASS**. This is the path that matches the user's 60–90s cap.
- Same 8s clip against that 60–90 campaign file: **FAIL** duration (expected).
- Live Twitch GQL (no key): `twitch_gql_ok rows=3` (sample at run time: illojuan / rubius / alanzoka). Counts change continuously; this only proves the endpoint works from this box.

Not run (need a real VOD, a long download, and the Whisper model): full `moments.py` / `cut.py` / `live.py` / `trends.py` / `translate.py --voice` pipelines. `trends.py` was skipped in Step 1 to avoid a heavy YouTube scrape; YouTube often returns HTTP 403 to datacenter IPs if yt-dlp is stale — the installed yt-dlp is current (2026.10.26).

How to run later:

```
/workspace/gtavi-claudecode/.venv/bin/python /workspace/gtavi-claudecode/scripts/trends.py --query "gta 6" --hours 24
```

Or: `source /workspace/gtavi-claudecode/.venv/bin/activate`.

---

## 6. Missing secrets, connectors, and first-run work

No API key is required for the core local pipeline (YouTube via yt-dlp, Twitch via public GQL, transcription local, cutting local).

| Item | Needed? | Status on this bot |
|---|---|---|
| `TWITCH_CLIENT_ID` + `TWITCH_TOKEN` | Optional. Official Helix instead of unofficial GQL | Not set. Keyless GQL worked in the smoke test |
| YouTube Data API key | Not used by this repo | User already has a YouTube connector — use it as a complement, not a repo requirement |
| Firecrawl key | Not used by repo scripts; useful for `campaign-finder` page reads | Present as `FIRECRAWL_API_KEY` |
| Hugging Face token | Not required for public Whisper `small` | First `moments.py` will download the model |
| Google / Microsoft keys for translate or TTS | Not required (unofficial public endpoints) | Fragile; may need a fallback later |
| Reddit API credentials | Not required | Public JSON may be blocked (429 / 403) |
| Page folder + `campaigns.md` / `facts.md` | Required before a real posting day | **Not created.** `setup` asks 4 questions (page name/handle, platforms, niche angle, time zone) and one "yes" |
| Human approval to post | Required by design | Do not auto-upload. User has Postpone, YouTube, X, blitzreels, socialync — those are for after "yes" |

Connectors the user already has that map cleanly onto this desk (do not reinstall; wire them in when work starts):

- **YouTube + YouTube Transcript + Supadata:** metadata and captions without always running Whisper; still run Whisper when word timestamps are needed for burned captions.
- **vidIQ MCP:** keywords, outliers, trending videos, title scoring — stronger than views-per-hour alone.
- **Postpone:** schedule after human approval (repo default scheduler mention is Buffer).
- **Firecrawl:** live campaign pages on Whop / contentrewards.com / clip.tech (`campaign-finder`).
- **Canva:** cheat-code and secrets carousels.
- **Google Drive:** `media/` storage mentioned in the playbook.
- **X:** first-wave posting surface in the launch playbook; trends on X.
- **blitzreels / socialync / Zernio:** short-form / social publishing complements; confirm each connector's exact tools before relying on them.
- **GitHub / Vercel:** not required for clipping, already connected.

---

## 7. Important gap: clip length vs the user's 60–90s cap

The user asked for clips **max 60–90 seconds**.

Repo defaults are shorter:

- Playbook and `clip-cutter` skill: **"7 to 30 seconds"** for most clips.
- `moments.py` defaults: `--min 15 --max 40`. (`--max-minutes 90` is the source-VOD cap, not the clip length.)
- `check.py` default window: **7–60s** if no `campaigns.md`.
- `live.py` default cut is about 15s before + 20s after a spike (~35s).

Good news: `check.py` already honors `campaigns.md` (`min_seconds` / `max_seconds`). A 75s 1080×1920 clip **passed** against a 60–90 rule file in the smoke test.

When the page folder is created, put this in `campaigns.md` (and later patch skill text / `moments.py` defaults):

```
min_seconds: 60
max_seconds: 90
```

And call moment finding as:

```
python scripts/moments.py <url> --top 8 --min 60 --max 90
```

Do not ship 7–30s as the default if the user wants 60–90s packages.

---

## 8. Skills copied into the workflow library

Copied for parent review (namespaced `gtavi-*` so nothing already in `/home/box/agent-data/workflows` was overwritten). No unprefixed collisions existed. Parent should finalize skill saving.

| Slug | Path |
|---|---|
| gtavi-campaign-finder | `/home/box/agent-data/workflows/gtavi-campaign-finder/SKILL.md` |
| gtavi-cheat-codes | `/home/box/agent-data/workflows/gtavi-cheat-codes/SKILL.md` + `references/cheats.md` |
| gtavi-clip-cutter | `/home/box/agent-data/workflows/gtavi-clip-cutter/SKILL.md` |
| gtavi-hook-writer | `/home/box/agent-data/workflows/gtavi-hook-writer/SKILL.md` |
| gtavi-learning-loop | `/home/box/agent-data/workflows/gtavi-learning-loop/SKILL.md` |
| gtavi-live-mode | `/home/box/agent-data/workflows/gtavi-live-mode/SKILL.md` |
| gtavi-moment-finder | `/home/box/agent-data/workflows/gtavi-moment-finder/SKILL.md` |
| gtavi-multilang | `/home/box/agent-data/workflows/gtavi-multilang/SKILL.md` |
| gtavi-playbook | `/home/box/agent-data/workflows/gtavi-playbook/SKILL.md` + `references/playbook.md` |
| gtavi-questions-to-posts | `/home/box/agent-data/workflows/gtavi-questions-to-posts/SKILL.md` |
| gtavi-rule-check | `/home/box/agent-data/workflows/gtavi-rule-check/SKILL.md` |
| gtavi-secrets-map | `/home/box/agent-data/workflows/gtavi-secrets-map/SKILL.md` |
| gtavi-setup | `/home/box/agent-data/workflows/gtavi-setup/SKILL.md` |
| gtavi-stream-finder | `/home/box/agent-data/workflows/gtavi-stream-finder/SKILL.md` |
| gtavi-trend-radar | `/home/box/agent-data/workflows/gtavi-trend-radar/SKILL.md` |
| gtavi-twitch-reaction | `/home/box/agent-data/workflows/gtavi-twitch-reaction/SKILL.md` |

16 of 16 copied. Skill bodies still point at `${CLAUDE_PLUGIN_ROOT}/scripts/...`. For this box, run the scripts from `/workspace/gtavi-claudecode` with the venv Python. A later skill tweak can hard-point that path.

---

## 9. Step 2 recommendations (verified URLs only — do not install in Step 1)

Priority is to fill gaps this repo does not cover: SEO/keywords, hashtags, cross-platform trend radars, tighter speech-based editing, official analytics, and scheduling. Prefer tools the user already has before adding new ones. Audit any new GitHub skill in the same way as this repo before curl/npx install.

### Already connected — use first

- vidIQ MCP (keyword research, outliers, trending videos, transcripts, title scores): https://github.com/vid-io/vidiq-mcp and hosted `https://mcp.vidiq.com/mcp`
- Postpone MCP (schedule after approval): https://developers.postpone.app/getting-started/ai-mcp and `https://api.postpone.app/mcp`
- Firecrawl MCP: https://github.com/firecrawl/firecrawl-mcp-server (key already in `FIRECRAWL_API_KEY`)
- YouTube, YouTube Transcript, Supadata, X, Canva, Google Drive, blitzreels, socialync, Zernio, GitHub, Vercel — already on this bot

### Skills (skills.sh / GitHub)

- YouTube SEO metadata (titles, chapters, transcript-matched search): https://www.skills.sh/illyism/seo-skills/youtube-seo — source https://github.com/illyism/seo-skills
- Hashtag + social SEO (2026 platform caps, keyword-first): https://www.skills.sh/social-media-skills/skills/hashtag-strategy — source https://github.com/social-media-skills/skills
- Social trend research (pytrends / Reddit / web): https://www.skills.sh/drshailesh88/integrated_content_os/social-media-trends-research
- OpenClip skills + optional hosted editor MCP: https://www.skills.sh/openclip-app/agent-skills — https://github.com/openclip-app/agent-skills — MCP `https://openclip.app/mcp` (clipping pipeline is a paid OpenClip subscription; five media utilities are free with an account)
- Universal video clipper (YouTube URL or local file → Reels/TikTok): https://www.skills.sh/dkyazzentwatwa/vid-clipper/universal-video-clipper — https://github.com/dkyazzentwatwa/vid-clipper (audit before install; overlaps this repo)
- Transcribe any social URL with yt-dlp + Whisper: https://www.skills.sh/criscatalyst/creator-skills/transcribe — https://github.com/criscatalyst/creator-skills
- Auto-Editor transcribe/cut-by-speech skill: https://github.com/WyattBlue/auto-editor/blob/master/skills/auto-editor-transcribe/SKILL.md

Use with caution (paid scrapers / extra API keys; audit ToS):  

- TikTok public-data skill (ScraperSocial): https://www.skills.sh/nikhonit/social-media-api-skills/tiktok-api  
- TikTok Creative Center trends (Crawlora key): https://www.skills.sh/crawlora-org/crawlora-skills/tiktok-trend-research  
- gooseworks `video-clipper` needs Klap + Captions.ai paid keys: https://www.skills.sh/gooseworks-ai/goose-skills/video-clipper — skip unless those accounts are wanted

### GitHub tools

- yt-dlp (already installed): https://github.com/yt-dlp/yt-dlp
- faster-whisper (already installed): https://github.com/SYSTRAN/faster-whisper
- Auto-Editor (cut dead air / cut by speech; good for 60–90s tighten): https://github.com/WyattBlue/auto-editor
- pytrends (Google Trends, no official API): https://github.com/GeneralMills/pytrends
- OpenCV YuNet model (already cached): https://github.com/opencv/opencv_zoo

### MCPs (new, optional)

- OpenClip hosted MCP: https://openclip.app/mcp (see paid caveat above)
- Video decomposer (yt-dlp + WhisperX + frames): https://github.com/icooper/video-decomposer-mcp
- Alternate YouTube transcript MCP (caption-first, Whisper fallback): https://github.com/Eli-xir/youtube-transcript-mcp — only if the existing YouTube Transcript connector is not enough
- Unofficial Google Trends MCPs (no official Google Trends API): https://github.com/HasData/google-trends-mcp and https://github.com/trendsmcp-ai/google-trends-mcp — treat as unofficial

### Marketplaces (Grok / Hermes)

- Grok Bot Marketplace: https://x.ai/bot/marketplace — relevant listings seen: **Clip Bot**, **Stills & Clips Desk**, **SEO & AEO Desk**
- Hermes content-engine (scores 45–60s clips + social copy; close to, but shorter than, a 60–90s cap): https://hermes-agent.nousresearch.com/marketplace/content-engine
- Hermes Studio (local FFmpeg/Whisper shorts, does not post): https://hermes-agent.nousresearch.com/marketplace/hermes-studio
- Hermes SEO: https://hermes-agent.nousresearch.com/marketplace/hermes-seo
- Hermes catalog index: https://hermes-agent.nousresearch.com/marketplace

---

## 10. What Step 1 did not do (by design)

- Did not create the page folder or invent page name / handle / niche / platforms.
- Did not install anything from skills.sh, Grok marketplace, Hermes, or other GitHub repos.
- Did not create subagents, auto-approval rules, or memory/guide files.
- Did not post, schedule, or join Whop/Clip campaigns.
- Could not read the user-attached image (private to the parent agent). Parent should overlay whatever that image specified onto this architecture in a later step.
- GTA 6 launch window: repo playbook treats Nov 19 as launch day. This audit is **20 Nov 2026, Europe/Skopje (UTC+1)**, so the "post every 1–2 hours for 48 hours" launch plan may still be in effect once the user starts work.

---

## 11. Recommended next actions (for the parent / user, not done here)

1. Confirm page name, handle, platforms, niche, and time zone, then run the `setup` skill to create the page folder.
2. Set campaign/page rules to **60–90s** clips and update `moments.py` / skill text accordingly.
3. In Step 2, install only after a per-repo security audit: start with hashtag-strategy, youtube-seo, pytrends or a Trends MCP, and Auto-Editor. Wire existing vidIQ, Postpone, Firecrawl, YouTube Transcript, Canva, and X first.
4. Before the first real `moments.py` run, allow time to download the Whisper `small` model and a source VOD.
