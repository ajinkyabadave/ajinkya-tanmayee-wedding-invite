# Ajinkya weds Tanmayee — digital wedding invite

A self-contained, mobile-first, animated invitation for WhatsApp sharing.
No build step, no dependencies (fonts load from Google Fonts CDN).

> **Working rule:** commit every iteration. After each meaningful change (design tweak,
> content edit, regenerated image), make a git commit with a short descriptive message
> and push it, so the history captures every step.

## Two versions (same design, different events)
| File | Who it's for | Events shown |
|------|--------------|--------------|
| `index.html`   | Guests invited to **both days** | Seemant Poojan + Sangeet (4 Sep) **and** Wedding (5 Sep) |
| `wedding.html` | Guests invited to the **wedding day only** | Wedding (5 Sep, 12:33 PM) |

## Files
```
index.html / wedding.html   the two invites
css/style.css               palette, layout, animations
js/invite.js                scroll reveal + floating petals (respects reduced-motion)
assets/logo.jpg             the TA mandala logo
assets/ganesha.svg          hand-built gold Ganesha motif
assets/og-full.jpg          1200x630 WhatsApp preview (2-day)
assets/og-wedding.jpg       1200x630 WhatsApp preview (wedding-only)
assets/og.html              source layout used to regenerate the OG images
poster-full.png             tall poster image to forward on WhatsApp (2-day)
poster-wedding.png          tall poster image to forward on WhatsApp (wedding-only)
reference/marathi-reference.jpeg   the Marathi reference invite (kept for record)
```

## How to share on WhatsApp
1. Host the site (see below) so each version has a public URL.
2. Forward the matching **poster image** (`poster-*.png`) with a caption like:
   > With the blessings of Shree Ganesha 🙏 We'd love for you to join us — details & map here: `https://YOUR-URL/`
3. When someone opens the link, the OG preview card (`og-*.jpg`) shows the couple, dates and venue — a trustworthy preview so relatives know the link is genuine.

## Hosting (personal account — NOT Toast)
Both work; pick one:

**Netlify (easiest, no git needed)**
- Go to app.netlify.com → "Add new site" → "Deploy manually" → drag this whole folder in.
- You get `https://<name>.netlify.app`. Rename the subdomain in Site settings.

**GitHub Pages (free)**
- Create a repo on your **personal** GitHub, push this folder.
- Settings → Pages → deploy from `main` / root. URL: `https://<user>.github.io/<repo>/`.

### One required edit after hosting
In `index.html` and `wedding.html`, replace every `SITE_URL` in the `<meta property="og:*">` tags with your real base URL (e.g. `https://ajinkya-tanmayee.netlify.app`). This makes the WhatsApp preview image load. Then validate at https://www.opengraph.xyz and send the link to yourself on WhatsApp to confirm the card renders.

## Optional: enable RSVP
Both HTML files contain a commented-out RSVP block. Uncomment it and fill in the name + phone number; it becomes tap-to-call.

## Regenerating the images
- **Posters:** open a file in Chrome, DevTools device toolbar at ~440px wide, capture a full-page screenshot.
- **OG cards:** open `assets/og.html` (add `?v=full` for the 2-day variant) at exactly 1200×630 and screenshot the viewport; export JPEG and keep it under ~300 KB.
