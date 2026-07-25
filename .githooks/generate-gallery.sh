#!/usr/bin/env bash
#
# Regenerate versions/index.html — a simple, clickable gallery listing every
# V<N> snapshot. Called by the pre-commit hook, but safe to run by hand too:
#   bash .githooks/generate-gallery.sh
#
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

versions_dir="versions"
out="$versions_dir/index.html"
mkdir -p "$versions_dir"

# Collect V<N> folders, numerically sorted (newest first).
nums=()
for d in "$versions_dir"/V*/; do
  [ -d "$d" ] || continue
  n="$(basename "$d")"; n="${n#V}"
  case "$n" in ''|*[!0-9]*) continue ;; esac
  nums+=("$n")
done
IFS=$'\n' sorted=($(printf '%s\n' "${nums[@]:-}" | sort -rn)); unset IFS

# Build the clickable cards. Each version offers two equal choices: the full
# 2-day invite and the wedding-day-only invite (the latter only if present).
cards=""
for n in "${sorted[@]:-}"; do
  [ -n "$n" ] || continue
  ver="V$n"
  wedding_choice=""
  if [ -f "$versions_dir/$ver/wedding.html" ]; then
    wedding_choice="
        <a class=\"choice\" href=\"$ver/wedding.html\">
          <span class=\"label\">Wedding day only</span>
          <span class=\"desc\">Wedding ceremony · 5 Sep</span>
          <span class=\"go\">Open →</span>
        </a>"
  fi
  cards="$cards
    <li class=\"card\">
      <span class=\"num\">Version $n</span>
      <div class=\"choices\">
        <a class=\"choice\" href=\"$ver/index.html\">
          <span class=\"label\">Full celebration</span>
          <span class=\"desc\">Seemant Poojan, Sangeet &amp; Wedding · 4–5 Sep</span>
          <span class=\"go\">Open →</span>
        </a>$wedding_choice
      </div>
    </li>"
done

if [ -z "$cards" ]; then
  cards="<li class=\"empty\">No versions yet — they appear here after the first commit.</li>"
fi

cat > "$out" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Ajinkya weds Tanmayee — all versions</title>
<style>
  :root { --maroon:#7a1f2b; --gold:#c99700; --cream:#fff8ec; --ink:#3a2a20; }
  * { box-sizing: border-box; }
  body {
    margin:0; padding:32px 18px 56px; font-family: Georgia, "Times New Roman", serif;
    background: radial-gradient(circle at 50% -10%, #fff 0%, var(--cream) 60%);
    color: var(--ink); min-height:100vh;
  }
  header { text-align:center; margin: 8px auto 30px; max-width:640px; }
  h1 { color: var(--maroon); font-size: 1.7rem; margin:0 0 6px; letter-spacing:.5px; }
  header p { margin:4px 0; color:#6b5544; font-size:.98rem; }
  .rule { width:70px; height:2px; background:var(--gold); margin:14px auto; border-radius:2px; }
  ul { list-style:none; padding:0; margin:0 auto; max-width:560px; display:grid; gap:14px; }
  .card {
    background:#fff; border:1px solid #eadfce; border-left:5px solid var(--gold);
    border-radius:12px; box-shadow:0 4px 14px rgba(122,31,43,.07); overflow:hidden;
    padding:16px 20px 18px;
  }
  .num { font-size:1.25rem; font-weight:bold; color:var(--maroon); }
  .choices { display:grid; gap:10px; margin-top:14px; }
  @media (min-width:460px){ .choices { grid-template-columns:1fr 1fr; } }
  .choice {
    display:flex; flex-direction:column; gap:3px; text-decoration:none; color:inherit;
    border:1px solid #eadfce; border-radius:10px; padding:12px 14px; background:#fdf9f1;
    transition: background .15s, border-color .15s;
  }
  .choice:hover { background:#fdf6ea; border-color:var(--gold); }
  .choice .label { font-size:1.02rem; color:var(--maroon); font-weight:bold; }
  .choice .desc { font-size:.82rem; color:#8a6d2f; }
  .choice .go { font-size:.82rem; color:var(--gold); margin-top:2px; }
  .empty { text-align:center; color:#8a7; padding:40px; }
  footer { text-align:center; margin-top:34px; color:#9a8a7a; font-size:.8rem; }
</style>
</head>
<body>
  <header>
    <h1>Ajinkya weds Tanmayee</h1>
    <p>Every saved version of the invitation.</p>
    <p style="font-size:.85rem;color:#9a8a7a;">Each version offers two invites — pick the one you want. Higher numbers are newer.</p>
    <div class="rule"></div>
  </header>
  <ul>$cards
  </ul>
  <footer>This page is generated automatically — the newest version is always at the top.</footer>
</body>
</html>
HTML

echo "generate-gallery: wrote $out (${#sorted[@]} version(s))"
