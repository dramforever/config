#!/usr/bin/env nix-shell
#!nix-shell -i bash -p dotnet-sdk_3
set -eo pipefail
if [[ $# != 1 ]]; then
  echo "Usage: $0 <project_repo_dir>"
  exit 1
fi
proj_dir="$1"
out_file="$(realpath "$(dirname "${BASH_SOURCE[0]}")/deps.nix")"

pushd "$proj_dir"

# Setup empty nuget package folder to force reinstall.
tmp_config="$(mktemp ./nuget.config.XXX)"
tmp_pkgs="$(mktemp -d ./nuget.packages.XXX)"
cat >"$tmp_config" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
  <config>
    <add key="globalPackagesFolder" value="$tmp_pkgs" />
  </config>
</configuration>
EOF

dotnet restore osu.Desktop --configfile "$tmp_config"

echo "{ fetchNuGet }: [" >"$out_file"
while read pkg_spec; do
  { read pkg_name; read pkg_version; } < <(
    # Build version part should be ignored: `3.0.0-beta2.20059.3+77df2220` -> `3.0.0-beta2.20059.3`
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkg_spec")
  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkg_spec")"/*.nupkg)"
  cat >>"$out_file" <<EOF
  (fetchNuGet {
    name = "$pkg_name";
    version = "$pkg_version";
    sha256 = "$pkg_sha256";
  })
EOF
done < <(find "$tmp_pkgs" -name '*.nuspec' | sort)
echo "]" >>"$out_file"

rm -r "$tmp_config" "$tmp_pkgs"

popd
