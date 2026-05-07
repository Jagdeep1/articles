# Notes & Thoughts

Hugo blog using a custom in-repo theme `dev-terminal` (Technical Editorial — refined dark, long-form), deployed to GitHub Pages at https://jagdeep1.github.io/.

The theme is defined in `themes/dev-terminal/` and follows the design system in [`DESIGN.md`](./DESIGN.md): Space Grotesk + Newsreader + Inter + JetBrains Mono, an obsidian/charcoal palette with cyan + emerald accents, an 800px reading column, and tonal-layer depth instead of shadows.

## Local development

Requires Hugo extended ≥ 0.146.0 (`brew install hugo`).

```bash
hugo server -D     # preview at http://localhost:1313 with drafts
hugo --minify      # build to ./public
```

## Writing posts

Posts live at `content/posts/<slug>.md`.

```bash
bin/new-post.sh --title "My Post Title"   # new stub from archetype
bin/new-post.sh path/to/raw.md            # convert raw markdown into a post
```

The conversion script slugifies, prepends frontmatter, and refuses to overwrite. If the source already has frontmatter (`---` first line) it preserves it.

### Useful frontmatter fields

```yaml
title: "..."           # required
date: 2026-05-07T...   # required (set automatically)
draft: false
tags: ["engineering"]  # first tag becomes the hero pill
category: "Engineering"
summary: "1-2 sentences for cards/SEO"
author: "Jagdeep"      # falls back to site author
authorRole: "Principal Systems Engineer"
```

### Writing code blocks with filename header

The custom render hook reads a `filename` attribute on the fenced block:

````
```ts {filename="cluster-manager.ts"}
async function replicateLog(...) { /* ... */ }
```
````

Renders with the filename in the header bar and a working Copy button. Without `filename`, the language id is shown.

### Captioned figures

```
{{</* figure src="/img/cluster.png" alt="Cluster diagram" caption="Fig 1.0: Real-time visualization of node synchronization." */>}}
```

## Theme structure

```
themes/dev-terminal/
├── theme.toml
├── archetypes/default.md
├── assets/
│   ├── css/main.css           # all design tokens + components
│   └── js/theme.js            # copy buttons + TOC scroll-spy
└── layouts/
    ├── _default/
    │   ├── baseof.html        # base wrapper
    │   ├── single.html        # article view (hero + 2-col + sidebar)
    │   ├── list.html          # section/tag listings
    │   └── _markup/
    │       └── render-codeblock.html   # filename + copy
    ├── _partials/
    │   ├── head.html
    │   ├── header.html        # top nav (logo, nav, search, subscribe)
    │   ├── footer.html        # brand + read/connect cols
    │   ├── article-card.html  # homepage/list card
    │   ├── toc.html           # "On this page"
    │   ├── related.html       # "Recommended"
    │   └── newsletter.html    # "Stay Terminal" card
    ├── shortcodes/
    │   └── figure.html
    ├── index.html             # homepage
    └── 404.html
```

## Site config

Site-level knobs live in `hugo.toml`:

- `[params]`: `description`, `author`, `tagline`, `newsletterEnabled`, `searchEnabled`, `copyrightStart`
- `[[params.nav]]`: top-nav items (`name`, `url`)
- `[[params.social]]`: footer social/RSS links

The newsletter form is a no-op stub by default — wire its `action` to your provider (Buttondown, ConvertKit, etc.) by editing `themes/dev-terminal/layouts/_partials/newsletter.html`.

## Deployment

`git push origin main` triggers `.github/workflows/hugo.yml`. Watch the **Actions** tab.

**One-time GitHub setting:** Settings → Pages → Build and deployment → **Source: GitHub Actions**.
