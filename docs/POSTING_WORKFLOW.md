# Posting workflow (human approval required)

```mermaid
sequenceDiagram
  participant Bot as Clipper bot
  participant Z as Zernio
  participant P as Postpone
  participant U as Owner
  Bot->>Bot: check.py PASS + publish-pack.md
  Bot->>Z: validate_post (5 accounts)
  Bot->>Z: show_post_preview
  Bot->>Z: analytics_get_best_time_to_post
  Bot->>U: approval pack: preview clip, captions, times
  U-->>Bot: explicit "yes" for THIS clip
  Bot->>Z: posts_create (YouTube, Instagram, Facebook x2, TikTok)
  Bot->>P: postpone_create_social_post (earliest slot, 2nd YouTube)
  Bot->>U: live links + reminder: set YouTube tags + Gaming in Studio
```

1. **Preview first.** The owner watches the master clip before anything is posted.
2. **One explicit yes per clip.** No yes, no post. A yes for one clip never covers the next.
3. **Zernio** (5 accounts): `accounts_list` (re-check every session) → `validate_post` → `show_post_preview` → `posts_create` after yes. Per-platform caption for each account.
4. **Postpone** (YouTube #2): there is no publish-now, so schedule the earliest recommended slot with `scripts/helpers/postpone.sh call postpone_create_social_post '{...}'`.
5. **After posting:** collect live links, post them back, set YouTube tags + Gaming category in Studio, log in `log.md`, feed results into `gtavi-learning-loop` after 24-72 h.

Account IDs are private. Put yours in your agent's memory, never in the repo.
