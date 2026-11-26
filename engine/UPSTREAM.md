# Upstream

- Source: https://github.com/MaryCache/imozuru (MIT, see LICENSE)
- Pinned: commit d33a9d8b261293b6051ec74f135f6b726d58b1be, version 2.3.3 (2026-11-26)
- Port changes: dashboard.py / make_guide_shots.py / make_textures.py omitted (not needed for the dig itself). All other scripts are verbatim upstream. references/tools.md had its dashboard lines removed to match.
- Audit record: ~/workspace/tools/imozuru-audit/ (upstream clone + notes). Upstream test suite: 418 tests, all passed on this VM at pin time.
- Local patch: fetch.py / watch.py carry the IMOZURU_ALLOW_FAKE_IP change from upstream PR MaryCache/imozuru#26 (unmerged as of 2026-11-26). All other scripts remain verbatim.
