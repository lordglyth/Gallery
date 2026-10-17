# Sno's Gallery

A mobile-friendly gallery powered by **Perl + GitHub Actions**, displayed at **https://gallery.snoplay.com** through Cloudflare.

Upload image files to **`photos/`**. GitHub Actions runs `scripts/build_gallery.pl`, finds images in that folder (including subfolders), and refreshes `gallery.json`. The homepage then shows them automatically, with no manual HTML editing.

Image formats: JPG, JPEG, PNG, GIF, WEBP, AVIF. The page supports captions, a fullscreen viewer, search, sorting, and opening originals.

## How to add pictures and captions

1. In the **photos/** folder, choose **Add file → Upload files**, and select your picture(s).
2. At the bottom, fill in GitHub's **Commit message** (the photo caption headline).
3. Fill in **Extended description** (the rest of the photo caption; optional).
4. Click **Commit changes**. Once the **Refresh photo gallery** GitHub Action finishes, the pictures and captions appear at **https://gallery.snoplay.com**.

For example:

- **Commit message:** `Moonlit Lumenfox`
- **Extended description:** `A little magic from tonight's experiment. Blue moonlight, silver leaves, and a curious fox.`

The gallery uses the **most recent Git commit that changed each image** to get the commit message and extended description. If you upload multiple pictures in the same commit, **those pictures share the same caption**. Upload or update images in separate commits for individual captions.

If the extended description is empty, only the commit message appears. If the image has no usable commit subject, its filename is shown instead.

To change a caption later, modify or re-upload that image in a new commit with the desired message and description. Editing unrelated files does not change its caption.

The **photos/** folder (including subfolders) is scanned automatically. No manual HTML editing, external services, or API keys are necessary. The GitHub Actions checkout must include the full Git history to read older image commit descriptions.

The gallery and all pictures in this **public** repository are publicly visible; please do not upload private photos.

## Run the Perl generator manually

```bash
perl scripts/build_gallery.pl
```

This rewrites `gallery.json` based on the image files under `photos/`.

## Notes

- Cloudflare serves the static GitHub-hosted gallery; **Perl runs in GitHub Actions when images change**, not on every page request.
- Pictures uploaded to a public repository are public. Do not upload private photos.
- No ads, trackers, API keys, or third-party JavaScript libraries.
- Existing image files remain untouched by the build script.
