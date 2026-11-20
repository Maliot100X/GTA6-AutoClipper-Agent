# Approval pack — GTA 6 clip job 2026-11-20 (1 clip)

Prepared Fri 20 Nov 2026, ~3:05 AM Europe/Skopje (UTC+1). **Nothing has been posted, uploaded, or scheduled.** Needs CLAWCADE's explicit "yes" before any post.

## The clip
| Field | Value |
|---|---|
| File | `/workspace/clipper-stack/jobs/clip-2026-11-20/gta6-bag-chase-luxedude-2026-11-20.mp4` (95.4 MB) |
| Thumbnail | `/workspace/clipper-stack/jobs/clip-2026-11-20/gta6-bag-chase-luxedude-2026-11-20-thumb.jpg` (frame at 1.5s: GIVE BAG / DECLINE prompt + hook) |
| Duration | 89.8 s |
| Format | 1080x1920, 30 fps, H.264 + AAC 48 kHz, layout fill, word-by-word burned captions, hook box first seconds |
| Loudness | -13.2 LUFS integrated (ebur128; target about -14, loudnorm I=-14) |
| Hook (on screen) | "One duffel bag started this GTA 6 chase" |
| Source | https://www.youtube.com/watch?v=2EaoIgWAW5g — **LuxeDude**, "10 HOURS of GTA 6 Free Roam Gameplay! (No Spoilers)" |
| Source range | 4:16:47 – 4:18:17 |
| What happens | A guy demands LuxeDude's duffel bag (GIVE BAG / DECLINE), he declines, the crew calls reinforcements, gang chase, he pushes one car into a head-on crash ("That is a Grand Theft Auto moment right there"), then the cops join the chase. Free roam, no story spoilers. |

Hook options (gtavi-hook-writer): 1) **One duffel bag started this GTA 6 chase (picked)** 2) Never flash your bag in GTA 6 3) He wanted the bag. Then the whole block came.

## Why this moment (viral score, real numbers)
Source stats (YouTube Data API v3, 20 Nov ~2:40 AM): 453,999 views, 1,103 likes, 25 comments; published 19 Nov 07:49 Skopje. Scout ranking: 25,174 views/hour at 18.0 h old. Title explicitly "No Spoilers", which makes it the safest source in launch week.

Score = hype words (max 30) + action words (max 40) + 10 if no story/prologue + comment corroboration (max 10) − 25 for menu or talking-only. Signals per source:
- **Most-replayed heatmap:** 0 points on all 4 sources (yt-dlp returned an empty heatmap).
- **Comment timestamps:** TubeAlfred top comments had no timestamps on these moments.
- **Scene action:** PySceneDetect found 95 scenes in the 130 s section (adaptive detector, high-motion driving).
- **Loudness:** RMS logged in `rms.txt`.
```
77.0 | LuxeDude 2EaoIgWAW5g 256:50-258:40 | hype=9 action=17 npc_lines=5 comment_likes=0 | gang steals bag -> reinforcements chase -> head-on crash -> cop chase (free roam, No Spoilers VOD)
 56.0 | LuxeDude 2EaoIgWAW5g 162:38-164:08 | hype=2 action=21 npc_lines=5 comment_likes=0 | car alarm -> hiding from cops in bushes (free roam)
 46.0 | Jynxzi k3esjgmbphQ 26:55-28:25 | hype=2 action=21 npc_lines=22 comment_likes=0 | robbery shootout -> run -> carjack (prologue mission)
 40.0 | Asmongold TV oyHFwPNd_c4 33:28-34:58 | hype=10 action=4 npc_lines=5 comment_likes=0 | shootout escape onto seaplane, "the game is broke" (prologue mission)
 19.0 | Jynxzi k3esjgmbphQ 14:10-15:31 | hype=8 action=2 npc_lines=27 comment_likes=25 | screen-narrator menu rant (MENU - fails user rule)
  0.0 | Asmongold TV oyHFwPNd_c4 174:50-176:12 | hype=5 action=0 npc_lines=1 comment_likes=0 | "redneck anime" talk (TALKING - fails user rule)
```
The user rule removed the Jynxzi narrator-menu clip and the Asmongold "redneck anime" talk clip. The Jynxzi and Asmongold action moments scored lower and are prologue-mission footage, which carries a spoiler risk.

## check.py (gtavi rule-check)
```
PASS  resolution 1080x1920  [1080x1920]
PASS  fps about 30  [30.00]
PASS  has audio
PASS  duration 60-90s (default)  [89.8s]
PASS  no banned terms in caption/hook
PASS  campaign rules file  [none given, defaults used (NOT a rules check)]
RESULT: PASS
```
Exit code 0. Caption read manually: the creator is credited, there is no "official" wording, and it carries the fan-clip disclaimer. No campaign rules apply (own page).

## Captions per account
### 1. YouTube Shorts — rakazaiterminal (Zernio <ZERNIO_ID_YOUTUBE>)
**Title:** GTA 6 Police Chase Started Over One Duffel Bag 😳 #GTA6 #Shorts
**Description:**
```
GTA 6 car chase in free roam: a guy demands LuxeDude's duffel bag, his crew rolls up, a head-on crash, then the cops join in. No story spoilers.

🎮 Gameplay: LuxeDude — full stream: https://www.youtube.com/watch?v=2EaoIgWAW5g

Unofficial fan clip, not affiliated with Rockstar Games.

#GTA6 #GTA6Gameplay #Shorts
```
Tags: gta 6, gta 6 police chase, gta 6 car chase, gta 6 gameplay, gta vi, grand theft auto 6, gta 6 police, gta 6 free roam, luxedude

### 2. YouTube Shorts — @hashiraauraedits (Postpone <POSTPONE_ACCOUNT_ID>)
**Title:** He Wanted the Bag… Then the Cops Showed Up | GTA 6 Gameplay #shorts
**Description:**
```
GTA 6 gameplay with no spoilers: a street crew tries to take the duffel bag, a chase starts, one car ends up in a head-on crash, and the police join the chase.

🎮 Credit: LuxeDude — https://www.youtube.com/watch?v=2EaoIgWAW5g
Fan clip, not affiliated with Rockstar Games.

#GTA6 #GTAVI #shorts
```
Tags: gta 6 gameplay, gta 6 police chase, gta vi police chase, gta 6 police, gta 6, grand theft auto 6, gta 6 no spoilers

### 3. Instagram Reels — animelabhub (Zernio <ZERNIO_ID_INSTAGRAM>), 5 hashtags (IG cap)
```
GTA 6 police chase that started over one duffel bag 😳 A crew wanted LuxeDude's bag, backup rolled in, one car took a head-on crash, then the cops joined. Pure GTA 6 free roam gameplay, no story spoilers.

🎮 Gameplay: LuxeDude on YouTube — full stream: youtube.com/watch?v=2EaoIgWAW5g
Fan clip, not affiliated with Rockstar.

#GTA6 #GTA6Gameplay #GTAVI #ViceCity #GrandTheftAuto6
```
### 4. Facebook Reels — Animelabhub (Zernio <ZERNIO_ID_FACEBOOK_1>)
```
GTA 6 car chase: all it took was one duffel bag 😳

A crew tried to take LuxeDude's bag, called backup, and the chase ended with a head-on crash and the cops on his tail. Free roam gameplay, no story spoilers.

🎮 Gameplay: LuxeDude — https://www.youtube.com/watch?v=2EaoIgWAW5g

#GTA6 #GTA6Gameplay #ViceCity
```
### 5. Facebook Reels — AHDomo (Zernio <ZERNIO_ID_FACEBOOK_2>)
```
Would you hand over the bag or run? 👀 GTA 6 free roam turned into a full police chase for LuxeDude: backup crew, a head-on crash, then the cops. No spoilers.

🎮 Credit: LuxeDude (YouTube) — https://www.youtube.com/watch?v=2EaoIgWAW5g

#GTA6 #GrandTheftAuto6 #GTAVI
```
### 6. TikTok — demonslayerdoses (Zernio <ZERNIO_ID_TIKTOK>)
```
GTA 6 police chase over one duffel bag 😳 gta 6 gameplay, free roam, no spoilers. Hand over the bag or run? 🎮 Gameplay: LuxeDude (YouTube) #GTA6 #GTA6Gameplay #GTAVI #GTA6PoliceChase #ViceCity
```

Keyword data (one vidIQ keyword_research call, "gta 6 police chase"):
- "gta 6 police chase": ~91,096/mo, competition 52
- "gta 6 police": ~192,699/mo, +408.9%
- "gta 6 car chase": ~8,692/mo
- "gta vi police chase": ~7,444/mo, +74.8%
- "gta 6 gameplay": ~10.42M/mo, +917.4%

## Prep checks (read-only)
- **Zernio accounts_list:** the same 5 accounts are connected.
- **Zernio validate_post** (5 accounts, captions only): the only error is "YouTube posts require video content". That is expected, because the MP4 is still local and has not been uploaded. There were no caption-length or hashtag errors.
- **Zernio show_post_preview:** shows the same 5 targets and the same single YouTube media error. Nothing was published.
- **Media spec:** 1080x1920 9:16 at 89.8 s fits YouTube Shorts (≤3 min), IG Reels, FB Reels, and TikTok. YouTube Shorts over 60 s can hit Content ID claims on third-party footage, so credit the creator as above.

## Recommended post times (Europe/Skopje)
- **@hashiraauraedits (Postpone recommended_post_times, 20–22 Nov):** Fri 20 Nov **17:00**, then 16:00 or 18:00.
- **Zernio accounts (analytics best_time_to_post, all accounts, UTC slots; these are thin samples):**
  - Top slot: day_of_week 0, 18:00 UTC = **19:00 Skopje**. Average engagement 2,720.7 over 3 posts. If 0 means Sunday, that is Sun 22 Nov.
  - Next: day 6, 19:00 UTC = 20:00 Skopje (28.75, 4 posts).
  - Day 5: 21:00 UTC = 22:00 Skopje (12.5, 2 posts) and 19:00 UTC = 20:00 Skopje (12, 1 post).
  - Suggestion for today: post the 5 Zernio accounts Fri 20 Nov around **20:00 Skopje** and @hashiraauraedits at 17:00. Alternatively, hold for the Sunday 19:00 Skopje slot.

## Note
All 6 target accounts are anime-named pages (animelabhub, demonslayerdoses, hashiraauraedits…). Posting GTA 6 gameplay there is the user's decision (20 Nov). The audience match is unproven, so read the first 24h metrics before scaling.

## After "yes" (not done)
1. Upload the MP4 to Zernio media.
2. Schedule the 5 Zernio accounts with posts_create.
3. Schedule @hashiraauraedits with postpone_create_social_post.

None of these steps has been run.
