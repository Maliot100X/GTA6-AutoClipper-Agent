# Skills (37)

Drop-in `SKILL.md` folders for Grok Bot, Claude Code, Cursor, Codex or any agent that reads Agent Skills. `install.sh` copies them to `$SKILLS_DIR` (default `~/.claude/skills`) without overwriting existing ones.

| Group | Skills | Author |
|---|---|---|
| **Master** | `gta6-clipper-master-guide` (load before EVERY job), `gta6-clipper-getting-started` (first-run setup for new owners) | [@Maliot100X](https://github.com/Maliot100X) |
| **GTA 6 desk** | `gtavi-setup`, `gtavi-playbook`, `gtavi-trend-radar`, `gtavi-stream-finder`, `gtavi-campaign-finder`, `gtavi-moment-finder`, `gtavi-clip-cutter`, `gtavi-hook-writer`, `gtavi-live-mode`, `gtavi-twitch-reaction`, `gtavi-multilang`, `gtavi-rule-check`, `gtavi-learning-loop`, `gtavi-questions-to-posts`, `gtavi-secrets-map`, `gtavi-cheat-codes` | [@Bodila51](https://github.com/Bodila51/gtavi-claudecode) (patched to 60-90 s and full-view default) |
| **Editing** | `auto-editor`, `auto-editor-effects`, `auto-editor-export`, `auto-editor-transcribe`, `auto-editor-transitions` | [@WyattBlue](https://github.com/WyattBlue/auto-editor) |
| **SEO** | `youtube-seo`, `seo-title-optimization` | [@Illyism](https://github.com/Illyism/seo-skills) |
| **Social growth** | `hashtag-strategy`, `social-seo`, `sms-hook-writer`, `captions-and-clipping`, `platform-specs-and-validation`, `instagram-seo`, `tiktok-growth`, `youtube-shorts` | [@social-media-skills](https://github.com/social-media-skills/skills) |
| **Research** | `sc-comment-mining`, `sc-outlier-post-finder`, `sc-transcript-intelligence`, `sc-trend-discovery` | [@ScrapeCreators](https://github.com/ScrapeCreators/social-media-research-skills) |

Each copied skill keeps its original text and author metadata. Paths inside the master guide point at the original build box (`/workspace/...`); after `install.sh` the equivalents are `vendor/gtavi-claudecode`, `scripts/helpers/*.sh` and `bin/auto-editor` in your install dir. Account IDs in the guide are placeholders (`<ZERNIO_ID_...>`): put your own in your agent's memory.
