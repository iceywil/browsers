# browsers

Docker base images with one automation browser each, on `node:22-bookworm`, published to `ghcr.io/iceywil/browsers`.

| Tag | Contents |
|---|---|
| `chrome-pr<patchright>` | Google Chrome, as Patchright installs it |
| `chromium-pw<playwright>` | Playwright's Chromium and chromium-headless-shell |
| `firefox-pw<playwright>` | Playwright's Firefox |
| `camoufox-cf<camoufox-js>` | Camoufox |
| `all-pw…-pr…-cf…` | All of them |

Every image also has Xvfb, tini, fonts, and `/etc/browsers.env` with the package versions it was built from (see `versions.env`). Use the same Playwright / Patchright / camoufox-js versions in your app so the browser builds match.

```dockerfile
FROM ghcr.io/iceywil/browsers:chrome-pr1.64.2
```

Bump `versions.env` and push: GitHub Actions builds and publishes the new tags.
