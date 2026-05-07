# Notes & Thoughts

Hugo blog using the [hugo-primer-blog](https://github.com/ngs/hugo-primer-blog) theme (Primer CSS), deployed to GitHub Pages at https://jagdeep1.github.io/.

## Local development

Requires Hugo extended ≥ 0.146.0 (`brew install hugo`).

```bash
# Preview locally with drafts shown
hugo server -D

# Build the static site (output in ./public)
hugo --minify
```

## Writing posts

Posts live under `content/en/posts/` (the theme expects this multilingual layout, even with a single language).

Two ways to add a post:

```bash
# 1. Create an empty stub from the archetype
bin/new-post.sh --title "My Post Title"

# 2. Convert an existing raw markdown file into a Hugo post
bin/new-post.sh path/to/raw.md
```

The conversion script:
- Slugifies the title/filename to produce `content/en/posts/<slug>.md`
- Prepends frontmatter (`title`, `date`, `draft: false`, `tags: []`) — unless the file already starts with `---`
- Refuses to overwrite an existing post

After running, edit the file in `content/en/posts/` and commit.

## Deployment

`git push origin main` triggers `.github/workflows/hugo.yml`, which builds the site and deploys to GitHub Pages. Watch the **Actions** tab for status.

**One-time setup in GitHub:** Settings → Pages → Build and deployment → **Source: GitHub Actions**. Without this, the workflow runs but nothing publishes.

## Configuration

Key knobs in `hugo.toml`:

- `[params]`: `primaryColor`, `dateFormat`, `recentPostsCount`, `showAuthor`, `showReadingTime`, `showShareButtons`, `sidebar`
- `[[params.sidebarModules]]`: which sidebar widgets render (available: `recentPosts`, `tags`, `categories`, `archive`, `links`)
- `[params.social]`: `github`, `x`, `bluesky` (drives the social links partial)
- `[[menus.main]]`: top-nav items
- `[taxonomies]`: `tag`, `category`, `archive`

See the theme's [README](https://github.com/ngs/hugo-primer-blog/blob/main/README.md) for the full option list.

## Swapping themes

```bash
git submodule deinit -f themes/hugo-primer-blog
git rm -f themes/hugo-primer-blog
git submodule add --depth=1 <new-theme-repo> themes/<NewTheme>
```

Then update `theme = '...'` in `hugo.toml` and rewrite `[params]` to match the new theme's schema.
