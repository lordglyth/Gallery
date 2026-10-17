# Sno's Gallery

A mobile-friendly gallery powered by **Perl + GitHub Actions + GitHub Pages**.

Upload image files to **`photos/`**. GitHub Actions runs `scripts/build_gallery.pl`, finds images in that folder (including subfolders), and refreshes `gallery.json`. The homepage then shows them automatically, with no manual HTML editing.

Image formats: JPG, JPEG, PNG, GIF, WEBP, AVIF. The page supports a fullscreen viewer, search, sorting, and downloading originals.

## Getting it online

1. Make this repository **public** if using free GitHub Pages (only do this if you want uploaded images public).
2. Open **Settings → Pages**, choose **Deploy from a branch**, and select **main / (root)**.
3. In **Settings → Actions → General → Workflow permissions**, allow **Read and write permissions** so the manifest can update itself.
4. Add photos through the GitHub website: **Add file → Upload files → photos/**. You can also upload using Git, or create subfolders below `photos/`.
5. Watch the **Actions** tab for “Refresh photo gallery” to finish. Reload the published homepage.

Preview the page at the usual GitHub Pages URL when enabled: `https://lordglyth.github.io/Gallery/`.

## Run the Perl generator manually

```bash
perl scripts/build_gallery.pl
```

This rewrites `gallery.json` based on the image files under `photos/`.

## Notes

- GitHub Pages serves static files; **Perl runs in GitHub Actions when images change**, not on every page request.
- Pictures uploaded to a public repository are public. Do not upload private photos.
- No ads, trackers, API keys, or third-party libraries.
- Existing image files remain untouched by the build script.
