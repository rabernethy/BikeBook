#!/usr/bin/env bash
# Launcher — serves the app locally and opens it in your browser.
# Your data lives in the browser (IndexedDB) keyed to this exact URL, so
# ALWAYS launch it the same way (same port) or you'll get a fresh empty store.
set -e
cd "$(dirname "$0")"
PORT="${1:-8787}"
URL="http://127.0.0.1:${PORT}/"

# Find a Python 3 (skip any Claude Code PATH shim).
PY=""
for c in /usr/bin/python3 python3 python; do
  if command -v "$c" >/dev/null 2>&1 && "$c" -c 'import sys;exit(0 if sys.version_info[0]==3 else 1)' 2>/dev/null; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then echo "Need Python 3. Install it, or serve index.html with any static server."; exit 1; fi

open_browser(){ ( sleep 1; (xdg-open "$URL" || open "$URL" || true) >/dev/null 2>&1 ) & }

# If something is already listening on this port, don't crash — just open it.
if "$PY" -c "import socket,sys; s=socket.socket(); s.settimeout(0.3); sys.exit(0 if s.connect_ex(('127.0.0.1',$PORT))==0 else 1)"; then
  echo "Already serving at ${URL} — opening browser."
  echo "(If that isn't this app, pick another port:  ./start.sh 9000 )"
  open_browser
  exit 0
fi

echo "Running at ${URL}  (Ctrl-C to stop)"
open_browser
exec "$PY" -m http.server "$PORT" --bind 127.0.0.1
