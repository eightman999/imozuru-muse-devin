# imozuru for Muse and Devin CLI

Ports of [MaryCache/imozuru](https://github.com/MaryCache/imozuru) (v2.3.3, MIT) — a research skill that digs into an unfamiliar field by following citations, links and authors to the original sources, saving them **without summarizing** and machine-checking every quoted extract — adapted so it runs natively in two agent harnesses:

- **muse-imozuru** for Muse (Meta's personal agent): the two web-searcher subagents from the original map to Muse subagents running in parallel; results land in `~/workspace/research/<topic>/` and reports are delivered as chat attachments.
- **devin-imozuru** for Devin CLI: no subagents are assumed, so the two searchers become two sequential search passes recorded separately (the saturation rule still counts their overlap), with per-round `map.md`/`log.md` checkpointing so a long dig survives session/machine restarts.

Both ports share one engine and one output store, so a dig started by one harness can be continued by the other.

## Layout

- `engine/` — the upstream scripts verbatim (minus `dashboard.py` and the texture/guide generators, which the dig itself does not need), plus `references/`, image `assets/`, and two additions:
  - `shims/tesseract`, `shims/yt-dlp` — remote-exec shims that run OCR and subtitle downloads on a second machine over SSH (see below)
- `muse-imozuru/`, `devin-imozuru/` — the harness-specific `SKILL.md` files and the `run-imozuru.sh` wrapper
- `install.sh` — installs the engine to `~/workspace/tools/imozuru-engine` and the skills to their harness locations

## Install

```bash
./install.sh        # both
./install.sh muse   # Muse only
./install.sh devin  # Devin CLI only
```

Then ask Muse for a dig in Japanese (「芋づる式に調べて: …」), or run `/devin-imozuru` in Devin CLI.

## Environment notes (why the wrapper exists)

The wrapper `run-imozuru.sh` is the only supported way to call the engine. It:

- prepends `engine/shims/` to `PATH`, so `tesseract` and `yt-dlp` resolve to the remote shims
- sets `IMOZURU_ALLOW_PRIVATE=1` for that invocation only. Some environments (fake-IP DNS in VPN/proxy setups, e.g. Clash/Surge-style resolvers or this VM's egress proxy) resolve **every** hostname into a non-global range such as 198.18.0.0/15, which makes upstream `fetch.py`'s SSRF guard reject every URL. The variable lifts the guard; never set it globally, and never fetch local/LAN addresses on purpose.

## Remote OCR / yt-dlp shims

`fetch.py` shells out to `tesseract` (OCR for scanned PDFs) and `yt-dlp` (YouTube subtitles). On a small cloud VM both are heavy or egress-limited, so the shims forward them over SSH to a bigger machine on the same tailnet (default host alias `imac`, override with `IMOZURU_OCR_HOST` / `IMOZURU_YTDLP_HOST`):

- `tesseract --list-langs` and `tesseract <img> <out> -l … -c …` run on the remote host; result `.txt`/`.tsv` files are copied back
- `yt-dlp` runs remotely (residential egress reaches YouTube more reliably); downloaded `.vtt` files are copied back

Note: tesseract is CPU-only software — the offload target should be a machine with spare CPU threads, not a GPU.

## License

MIT. The engine and the skill text derive from MaryCache/imozuru (see `engine/LICENSE` and `engine/UPSTREAM.md` for the pinned upstream commit). The port-specific files in this repository are also MIT.
