#!/bin/sh
# vfxcat installer — downloads the latest release binary for this machine.
# SOURCE OF TRUTH lives here (private repo); the served copy is
# kennegard/vfxcat-releases/install.sh — sync it after editing.
#
#   curl -fsSL https://raw.githubusercontent.com/kennegard/vfxcat-releases/main/install.sh | sh
#
# curl downloads don't get macOS's quarantine xattr, so the binary runs
# without Gatekeeper prompts — this is the recommended install path.
#
# Overrides:
#   VFXCAT_VERSION=v0.2.0     install a specific release (default: latest)
#   VFXCAT_INSTALL_DIR=~/bin  install somewhere else (default: ~/.local/bin —
#                             one predictable location, never needs sudo)
set -eu

REPO="kennegard/vfxcat-releases"

os=$(uname -s)
case "$os" in
  Darwin) os=darwin ;;
  Linux)  os=linux ;;
  *) echo "error: unsupported OS: $os (darwin and linux builds are published)" >&2; exit 1 ;;
esac

arch=$(uname -m)
case "$arch" in
  arm64|aarch64) arch=arm64 ;;
  x86_64|amd64)  arch=amd64 ;;
  *) echo "error: unsupported architecture: $arch" >&2; exit 1 ;;
esac

version="${VFXCAT_VERSION:-}"
if [ -z "$version" ]; then
  version=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
  if [ -z "$version" ]; then
    echo "error: could not determine the latest release — is one published yet?" >&2
    echo "       https://github.com/$REPO/releases" >&2
    exit 1
  fi
fi

# Archive names come from .goreleaser.yaml: vfxcat_<version-without-v>_<os>_<arch>.tar.gz
url="https://github.com/$REPO/releases/download/$version/vfxcat_${version#v}_${os}_${arch}.tar.gz"

install_dir="${VFXCAT_INSTALL_DIR:-$HOME/.local/bin}"
mkdir -p "$install_dir"

echo "Installing vfxcat $version ($os/$arch) to $install_dir"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fSL --progress-bar "$url" -o "$tmp/vfxcat.tar.gz"
tar -xzf "$tmp/vfxcat.tar.gz" -C "$tmp" vfxcat
install -m 0755 "$tmp/vfxcat" "$install_dir/vfxcat"

echo
"$install_dir/vfxcat" version || true
echo
echo "Installed: $install_dir/vfxcat"
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    # Piped installs can't prompt (stdin is the script), so give exact
    # copy-paste steps instead of a bare warning.
    case "${SHELL:-}" in
      */zsh)  rc="$HOME/.zshrc" ;;
      */bash) rc="$HOME/.bashrc" ;;
      *)      rc="your shell profile" ;;
    esac
    echo
    echo "$install_dir is not on your PATH, so 'vfxcat' won't be found yet."
    echo "To fix, run:"
    echo
    if [ "$rc" = "your shell profile" ]; then
      echo "  add 'export PATH=\"$install_dir:\$PATH\"' to $rc"
    else
      echo "  echo 'export PATH=\"$install_dir:\$PATH\"' >> $rc"
    fi
    echo
    echo "then open a new terminal. Until then, run it via the full path:"
    echo
    echo "  $install_dir/vfxcat"
    ;;
esac
echo
echo "Optional tools unlock previews (vfxcat runs without them):"
echo "  macOS:  brew install ffmpeg openimageio"
echo "  Debian: sudo apt install ffmpeg openimageio-tools"
echo "Run 'vfxcat doctor' to see what's detected and what each tool unlocks."
