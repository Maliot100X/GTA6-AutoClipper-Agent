# Grok Bot template + crew

Import the whole bot (skills, memories, routine, connectors) in one click:

- **x.ai:** https://x.ai/bot/HxIcmO9dnz8X_puS1ssan
- **Grok Bot Directory:** https://grok-bot.directory/bots/gta-6-automated-clipper

On first run the imported bot uses `gta6-clipper-getting-started`: it asks for your accounts, installs this toolchain on its own computer (same steps as `install.sh`) and offers to create its two helpers.

## Crew (group chat "GTA6 Clipper Crew")

| Role | Job | Never |
|---|---|---|
| **Clipper bot** (lead) | Runs the job, talks to the owner, approval + posting | posts without an explicit yes |
| **Scout** | Campaigns, last-24 h GTA 6 videos and live streams, viral scores, top-50 keywords, per-platform titles/hashtags/hooks | posts or uploads |
| **Editor** | Cuts 60-90 s full-view clips, auto-editor, captions, -14 LUFS, `check.py` PASS, hands back paths + check output | posts or uploads |

## Daily routine
Every day ~09:00 local: load the guide → ask Scout for the report in the crew chat → Editor cuts the **1 best** clip → owner previews → after yes, post to all accounts.

## What a template does NOT carry
API keys, installed binaries, your account IDs. The new owner adds their own.
