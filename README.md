# Notes & Thoughts

Hugo blog using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme, deployed to GitHub Pages at https://jagdeep1.github.io/.

## Local development

Requires Hugo extended (`brew install hugo`).

```bash
# Preview locally with drafts shown
hugo server -D

# Build the static site (output in ./public)
hugo --minify
```

## Writing posts

Two ways to add a post:

```bash
# 1. Create an empty stub from the archetype
bin/new-post.sh --title "My Post Title"

# 2. Convert an existing raw markdown file into a Hugo post
bin/new-post.sh path/to/raw.md
```

The conversion script:
- Slugifies the title/filename to produce `content/posts/<slug>.md`
- Prepends frontmatter (`title`, `date`, `draft: false`, `tags: []`) — unless the file already starts with `---`
- Refuses to overwrite an existing post

After running, edit the file in `content/posts/` and commit.

## Deployment

`git push origin main` triggers `.github/workflows/hugo.yml`, which builds the site and deploys to GitHub Pages. Watch the **Actions** tab for status.

**One-time setup in GitHub:** Settings → Pages → Build and deployment → **Source: GitHub Actions**. Without this, the workflow runs but nothing publishes.

## Swapping themes

PaperMod is included as a git submodule at `themes/PaperMod`. To swap:

```bash
git submodule deinit -f themes/PaperMod
git rm -f themes/PaperMod
git submodule add --depth=1 <new-theme-repo> themes/<NewTheme>
```

Then update `theme = '...'` in `hugo.toml` and adjust `[params]` to match the new theme's options.

## Extension points

Left intentionally minimal in `hugo.toml` — extend when needed:
- Menus → `[[menu.main]]` entries
- Profile mode → `params.profileMode`
- Search page → add `content/search.md` with `layout: search`
- Custom CSS → `assets/css/extended/*.css`

See PaperMod's [docs](https://github.com/adityatelange/hugo-PaperMod/wiki) for options.
