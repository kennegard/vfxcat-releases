# vfxcat — releases

Binary releases and installer for **vfxcat**, a self-hosted media asset
catalog for VFX and post-production studios: point it at a directory and get
a browsable, searchable, previewable index of every shot, plate, render, and
rough cut on disk — EXR/DPX sequences and camera raw handled natively, all
local, nothing leaves your network.

> **Closed beta.** vfxcat is currently in a private beta and requires a
> license file to run. The app is closed source; this repository only hosts
> the installer and release binaries. Interested in joining the beta?
> Email **help@vfxnerds.com**.

## Install (macOS / Linux)

```sh
curl -fsSL https://raw.githubusercontent.com/kennegard/vfxcat-releases/main/install.sh | sh
```

Or download an archive from [Releases](https://github.com/kennegard/vfxcat-releases/releases),
extract, and put `vfxcat` on your `PATH`. macOS note: browser downloads get
Gatekeeper-quarantined — clear it once with `xattr -d com.apple.quarantine ./vfxcat`
(the curl installer avoids this entirely).

Installing is free; the server won't start without the license file issued
to you as a beta tester.

## Optional preview tools

vfxcat runs with zero dependencies; two external tools unlock the full
preview pipeline (`vfxcat doctor` reports what's detected):

```sh
brew install ffmpeg openimageio                # macOS
sudo apt install ffmpeg openimageio-tools      # Debian/Ubuntu
```

## Quickstart

Save the `vfxcat.license` file from your beta welcome email first (Downloads
is fine). When the installer finishes it starts guided setup, which finds the
license, asks which folders to catalog and who should be able to open the
catalog, then starts vfxcat and opens it in your browser, signed in. On a Mac
it can also start vfxcat automatically when you log in.

Afterwards:

```sh
vfxcat          # status and a menu: open, start, share the sign-in link, change settings
vfxcat setup    # change settings
vfxcat doctor   # check the license, data folder, port and preview tools
```

Prefer flags? `vfxcat serve --root /path/to/footage --license /path/to/vfxcat.license`
does the same by hand, and setup prints the exact command for your settings
when it finishes.

## License

vfxcat is proprietary software (see [LICENSE](LICENSE)). Use is limited to
beta testers under their beta agreement. Questions or support:
**help@vfxnerds.com**.
