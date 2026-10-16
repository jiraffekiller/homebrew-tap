# jiraffekiller/homebrew-tap

Homebrew cask for [Sail](https://github.com/jiraffekiller/sail), a battery charge limiter
for Apple Silicon MacBooks. The token is `sail-battery` because `sail` is taken by an
unrelated formula in homebrew-core.

```bash
brew install --cask jiraffekiller/tap/sail-battery
```

Sail is ad-hoc signed, so macOS blocks the first launch. Allow it under
System Settings → Privacy & Security → Open Anyway, or clear the quarantine flag once:

```bash
xattr -dr com.apple.quarantine /Applications/Sail.app
```

Upgrade with `brew upgrade --cask sail-battery`, remove with
`brew uninstall --cask sail-battery` (`--zap` also deletes settings).

The cask is kept current automatically: a scheduled workflow checks the latest Sail
release every six hours and commits the new version and checksum.
