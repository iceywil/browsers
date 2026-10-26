# Browser base images on node:22-bookworm, one browser per image (plus "all"):
#   chrome    Google Chrome, as Patchright installs it
#   chromium  Playwright's Chromium (+ chromium-headless-shell)
#   firefox   Playwright's Firefox
#   camoufox  Camoufox (Firefox-based), with Firefox's system libraries
#   all       every one of the above
# Each also has Xvfb (DISPLAY for headed browsers), tini and fonts, and /etc/browsers.env with the versions it was
# built from. Browsers live under /ms-playwright (PLAYWRIGHT_BROWSERS_PATH); Camoufox under /root/.cache/camoufox.
#   docker build --target chrome -t browsers:chrome .
FROM node:22-bookworm AS base
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    DEBIAN_FRONTEND=noninteractive
COPY versions.env /etc/browsers.env
RUN apt-get update \
 && apt-get install -y --no-install-recommends tini xvfb xauth fonts-liberation fonts-noto-color-emoji \
 && rm -rf /var/lib/apt/lists/*

FROM base AS chrome
RUN . /etc/browsers.env && npx -y "patchright@$PATCHRIGHT_VERSION" install --with-deps chrome \
 && rm -rf /var/lib/apt/lists/* /root/.npm

FROM base AS chromium
RUN . /etc/browsers.env && npx -y "playwright@$PLAYWRIGHT_VERSION" install --with-deps chromium \
 && rm -rf /var/lib/apt/lists/* /root/.npm

FROM base AS firefox
RUN . /etc/browsers.env && npx -y "playwright@$PLAYWRIGHT_VERSION" install --with-deps firefox \
 && rm -rf /var/lib/apt/lists/* /root/.npm

FROM base AS camoufox
RUN . /etc/browsers.env && npx -y "playwright@$PLAYWRIGHT_VERSION" install-deps firefox \
 && npx -y "camoufox-js@$CAMOUFOX_JS_VERSION" fetch \
 && rm -rf /var/lib/apt/lists/* /root/.npm

FROM base AS all
RUN . /etc/browsers.env \
 && npx -y "patchright@$PATCHRIGHT_VERSION" install --with-deps chrome \
 && npx -y "playwright@$PLAYWRIGHT_VERSION" install --with-deps chromium firefox \
 && npx -y "camoufox-js@$CAMOUFOX_JS_VERSION" fetch \
 && rm -rf /var/lib/apt/lists/* /root/.npm
