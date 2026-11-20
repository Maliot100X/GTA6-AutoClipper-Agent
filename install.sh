#!/usr/bin/env bash
# GTA6 AutoClipper Agent - one-command installer
#   curl -fsSL https://raw.githubusercontent.com/Maliot100X/GTA6-AutoClipper-Agent/main/install.sh | bash
#
# Options (env vars):
#   INSTALL_DIR=~/GTA6-AutoClipper-Agent   where the repo lives (cloned if missing)
#   SKILLS_DIR=~/.claude/skills             where agent skills are copied (never overwrites existing ones)
#   DRY_RUN=1                               print every step, change nothing
#   SKIP_SYSTEM=1                           skip apt/brew/dnf (ffmpeg, git, python3 already installed)
#   WITH_POT=1                              also install the bgutil yt-dlp PO-token plugin (helps with YouTube bot checks)
#   WHISPER_PREFETCH=1                      pre-download the faster-whisper "small" model (~460 MB)
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/Maliot100X/GTA6-AutoClipper-Agent.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/GTA6-AutoClipper-Agent}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
DRY_RUN="${DRY_RUN:-0}"
AE_VERSION="${AE_VERSION:-31.9.0}"

c(){ printf '\033[1;35m==>\033[0m \033[1;36m%s\033[0m\n' "$*"; }
run(){ if [ "$DRY_RUN" = 1 ]; then printf '   [dry-run] %s\n' "$*"; else eval "$@"; fi; }
have(){ command -v "$1" >/dev/null 2>&1; }
SUDO=""; if [ "$(id -u)" != 0 ] && have sudo; then SUDO="sudo"; fi

c "GTA6 AutoClipper Agent installer (dry-run=$DRY_RUN)"

# 1. System packages ----------------------------------------------------------
if [ "${SKIP_SYSTEM:-0}" != 1 ]; then
  c "1/7 System packages: ffmpeg, git, python3, venv, curl"
  if have apt-get; then
    run "$SUDO apt-get update -y"
    run "$SUDO apt-get install -y ffmpeg git curl python3 python3-venv python3-pip fonts-dejavu-core"
  elif have brew; then
    run "brew install ffmpeg git python@3.12 curl"
  elif have dnf; then
    run "$SUDO dnf install -y ffmpeg git curl python3 python3-pip"
  elif have pacman; then
    run "$SUDO pacman -Sy --noconfirm ffmpeg git curl python python-pip"
  else
    echo "   No supported package manager found. Install ffmpeg, git, python3 (3.10+) and curl, then re-run with SKIP_SYSTEM=1."
  fi
else
  c "1/7 System packages: skipped (SKIP_SYSTEM=1)"
fi

# 2. Repo ---------------------------------------------------------------------
SELF_DIR=""
# only trust the script's own folder when run as a file (not when piped from curl)
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/install.sh" ] && [ -d "$SELF_DIR/vendor/gtavi-claudecode" ]; then
  INSTALL_DIR="$SELF_DIR"
  c "2/7 Using this checkout: $INSTALL_DIR"
elif [ -d "$INSTALL_DIR/.git" ]; then
  c "2/7 Updating $INSTALL_DIR"
  run "git -C '$INSTALL_DIR' pull --ff-only"
else
  c "2/7 Cloning into $INSTALL_DIR"
  run "git clone --depth 1 '$REPO_URL' '$INSTALL_DIR'"
fi

# 3. Python venv + Python tools ---------------------------------------------
c "3/7 Python venv + yt-dlp, faster-whisper, PySceneDetect, trendspy"
PY="${PYTHON:-python3}"
run "$PY -m venv '$INSTALL_DIR/.venv'"
VPIP="'$INSTALL_DIR/.venv/bin/pip'"
run "$VPIP install --upgrade pip wheel"
run "$VPIP install -r '$INSTALL_DIR/requirements.txt'"
if [ "${WITH_POT:-0}" = 1 ]; then
  run "$VPIP install bgutil-ytdlp-pot-provider"
  echo "   PO-token plugin installed. It also needs its token server: see https://github.com/Brainicism/bgutil-ytdlp-pot-provider"
fi

# 4. auto-editor (official prebuilt binary from WyattBlue/auto-editor) -------
c "4/7 auto-editor $AE_VERSION"
OS="$(uname -s)"; ARCH="$(uname -m)"
case "$OS-$ARCH" in
  Linux-x86_64)  AE_ASSET=auto-editor-linux-x86_64 ;;
  Linux-aarch64|Linux-arm64) AE_ASSET=auto-editor-linux-aarch64 ;;
  Linux-armv7l)  AE_ASSET=auto-editor-linux-armv7 ;;
  Darwin-arm64)  AE_ASSET=auto-editor-macos-arm64 ;;
  *) AE_ASSET="" ;;
esac
run "mkdir -p '$INSTALL_DIR/bin'"
if [ -n "$AE_ASSET" ]; then
  run "curl -fsSL -o '$INSTALL_DIR/bin/auto-editor' 'https://github.com/WyattBlue/auto-editor/releases/download/$AE_VERSION/$AE_ASSET'"
  run "chmod +x '$INSTALL_DIR/bin/auto-editor'"
else
  echo "   No prebuilt auto-editor for $OS-$ARCH; falling back to the PyPI package."
  run "$VPIP install auto-editor"
fi

# 5. Skills ---------------------------------------------------------------------
c "5/7 Agent skills -> $SKILLS_DIR (existing skills are kept)"
run "mkdir -p '$SKILLS_DIR'"
if [ "$DRY_RUN" = 1 ]; then
  echo "   [dry-run] copy $INSTALL_DIR/skills/* -> $SKILLS_DIR/"
else
  for d in "$INSTALL_DIR"/skills/*/; do
    n="$(basename "$d")"
    if [ -e "$SKILLS_DIR/$n" ]; then echo "   keep  $n (already exists)"; else cp -r "$d" "$SKILLS_DIR/$n"; echo "   added $n"; fi
  done
fi

# 6. .env -----------------------------------------------------------------------
c "6/7 .env (API keys stay local, never commit it)"
if [ -f "$INSTALL_DIR/.env" ]; then echo "   .env already exists, left untouched"
else run "cp '$INSTALL_DIR/.env.example' '$INSTALL_DIR/.env'"; run "chmod 600 '$INSTALL_DIR/.env'"; fi
run "chmod +x '$INSTALL_DIR'/scripts/*.sh '$INSTALL_DIR'/scripts/helpers/*.sh"

if [ "${WHISPER_PREFETCH:-0}" = 1 ]; then
  c "   Pre-downloading faster-whisper small model"
  run "'$INSTALL_DIR/.venv/bin/python' -c \"from faster_whisper import WhisperModel; WhisperModel('small', device='cpu', compute_type='int8')\""
fi

# 7. Verify ---------------------------------------------------------------------
c "7/7 Verify"
if [ "$DRY_RUN" = 1 ]; then
  echo "   [dry-run] would check: ffmpeg, yt-dlp, scenedetect, faster_whisper, trendspy, auto-editor, check.py"
else
  ok(){ if eval "$2" >/dev/null 2>&1; then echo "   OK   $1"; else echo "   MISS $1"; fi; }
  V="$INSTALL_DIR/.venv/bin"
  ok ffmpeg "ffmpeg -version"
  ok yt-dlp "'$V/yt-dlp' --version"
  ok scenedetect "'$V/scenedetect' version"
  ok faster-whisper "'$V/python' -c 'import faster_whisper'"
  ok trendspy "'$V/python' -c 'import trendspy'"
  ok auto-editor "'$INSTALL_DIR/bin/auto-editor' --version || '$V/auto-editor' --version"
  ok check.py "'$V/python' '$INSTALL_DIR/vendor/gtavi-claudecode/scripts/check.py' --help"
fi

cat <<MSG

Done. Next:
  1) Put your keys in $INSTALL_DIR/.env (YOUTUBE_API_KEY, SUPADATA_API_KEY, POSTPONE_API_KEY, FIRECRAWL_API_KEY)
  2) cd $INSTALL_DIR && source .venv/bin/activate && set -a && . ./.env && set +a
  3) Read docs/QUICKSTART.md, or tell your agent: "Load the gta6-clipper-master-guide skill and run one clip job."
MSG
