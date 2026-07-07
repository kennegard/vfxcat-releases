# vfxcat — releases

Binary releases and installer for **vfxcat**, a self-hosted media asset
catalog for VFX and post-production studios: point it at a directory and get
a browsable, searchable, previewable index of every shot, plate, render, and
rough cut on disk — EXR/DPX sequences and camera raw handled natively, all
local, nothing leaves your network.

## Install (macOS / Linux)

```sh
curl -fsSL https://raw.githubusercontent.com/kennegard/vfxcat-releases/main/install.sh | sh
```

Or download an archive from [Releases](https://github.com/kennegard/vfxcat-releases/releases),
extract, and put `vfxcat` on your `PATH`. macOS note: browser downloads get
Gatekeeper-quarantined — clear it once with `xattr -d com.apple.quarantine ./vfxcat`
(the curl installer avoids this entirely).

## Optional preview tools

vfxcat runs with zero dependencies; two external tools unlock the full
preview pipeline (`vfxcat doctor` reports what's detected):

```sh
brew install ffmpeg openimageio                # macOS
sudo apt install ffmpeg openimageio-tools      # Debian/Ubuntu
```

## Quickstart

```sh
vfxcat serve --root /path/to/footage --port 8080
```

Binaries are Apache-2.0 licensed (see LICENSE).
