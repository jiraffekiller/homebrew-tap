#!/bin/bash
# Update Casks/sail.rb to the latest GitHub release of jiraffekiller/sail.
# Prints "changed (old -> new)" or "unchanged (version)". Needs curl and jq; no credentials.
set -euo pipefail

cask="Casks/sail.rb"
repo="jiraffekiller/sail"

latest=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")
tag=$(jq -r .tag_name <<<"${latest}")
version="${tag#v}"
sha_url=$(jq -r '.assets[] | select(.name | endswith(".zip.sha256")) | .browser_download_url' <<<"${latest}")

if [[ -z "${version}" || -z "${sha_url}" ]]
then
  echo "release metadata incomplete" >&2
  exit 1
fi

sha=$(curl -fsSL "${sha_url}" | awk '{print $1}')
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "${cask}")

if [[ "${current}" == "${version}" ]]
then
  echo "unchanged (${version})"
  exit 0
fi

sed -i.bak \
  -e "s/^  version \".*\"$/  version \"${version}\"/" \
  -e "s/^  sha256 \".*\"$/  sha256 \"${sha}\"/" \
  "${cask}"
rm -f "${cask}.bak"
echo "changed (${current} -> ${version})"
