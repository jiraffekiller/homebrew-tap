cask "sail-battery" do
  version "0.2.0"
  sha256 "5fb64d16f56c0af37297afedb8d9a4e6c9c4540271ebe0916af56d6bbfae4caa"

  url "https://github.com/jiraffekiller/sail/releases/download/v#{version}/Sail-v#{version}.zip"
  name "Sail"
  desc "Battery charge limiter with Sailing mode and heat protection"
  homepage "https://github.com/jiraffekiller/sail"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Sail.app"

  uninstall launchctl: "com.jiraffekiller.sail.agent",
            quit:      "com.jiraffekiller.sail",
            script:    {
              executable:   "/Applications/Sail.app/Contents/Resources/uninstall-helper.sh",
              sudo:         true,
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Application Support/Sail",
    "~/Library/Preferences/com.jiraffekiller.sail.plist",
  ]

  caveats <<~EOS
    Sail is ad-hoc signed (not notarized), so macOS blocks the first launch.
    Either allow it under System Settings > Privacy & Security > Open Anyway,
    or clear the quarantine flag once:
      xattr -dr com.apple.quarantine /Applications/Sail.app
    Limits below 80% need the privileged helper; the Setup window installs it.
  EOS
end
