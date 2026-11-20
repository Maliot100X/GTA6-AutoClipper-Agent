# Quickstart

## 1. Install
```bash
curl -fsSL https://raw.githubusercontent.com/Maliot100X/GTA6-AutoClipper-Agent/main/install.sh | bash
cd ~/GTA6-AutoClipper-Agent
nano .env            # YOUTUBE_API_KEY, SUPADATA_API_KEY, POSTPONE_API_KEY, FIRECRAWL_API_KEY
source .venv/bin/activate && set -a && . ./.env && set +a
export PATH="$PWD/bin:$PATH"
```

## 2. Connect your agent's connectors (Grok Bot / Claude)
Zernio (posting), vidIQ (keywords), TubeAlfred (YouTube search + transcripts), Firecrawl (web). Optional: Postpone via `scripts/helpers/postpone.sh`.

## 3. Run one job by hand
```bash
scripts/gtavi.sh trends --hours 24 --limit 20              # what's hot (views/hour)
scripts/gtavi.sh streams --limit 10                        # who is live now
scripts/gtavi.sh moments "https://www.youtube.com/watch?v=VIDEO_ID" --top 5 --min 60 --max 90
scripts/gtavi.sh cut jobs/<id> --pick 1 --layout blur --hook "One duffel bag started this GTA 6 chase"
auto-editor jobs/<id>/edits/clip_1.mp4 --margin 0.3s -o out/clip_tight.mp4   # trim dead air
scripts/gtavi.sh check out/clip_tight.mp4 --caption "$(cat caption.txt)"     # must PASS (60-90 s)
```

## 4. Or let the agent do it
> Load the `gta6-clipper-master-guide` skill. Run one clip job: trend scan, pick the single best viral gameplay moment, cut it 60-90 s in the full-view blur layout, run auto-editor and check.py, write the publish pack for all my accounts, show me the preview and wait for my yes.
