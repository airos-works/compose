#!/usr/bin/env bash
# Build the docker-compose .hpkg(s) on Linux with the host Haiku `package`
# tool. Installs the binary as bin/docker-compose and as a Docker CLI plugin
# (lib/docker/cli-plugins/docker-compose) so `docker compose` works.
# Usage: tools/package-haiku-cross.sh [arch ...]   (default: amd64 arm64)
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
PACKAGE_TOOL=${PACKAGE_TOOL:-/mnt/HaikuWork/x399/build/x86_64/objects/linux/x86_64/release/tools/package/package}
BASETAG=$(git tag -l 'v2.*' --sort=-v:refname | head -1)
AHEAD=$(git rev-list --count "$BASETAG"..HEAD 2>/dev/null || echo 0)
VERSION=$(echo "$BASETAG" | sed 's/^v//')~git.$AHEAD.$(git rev-parse --short HEAD)
STAGE=$(mktemp -d /tmp/compose-pkg-XXXXXX)
trap 'rm -rf -- "$STAGE"' EXIT
mkdir -p "$ROOT/artifacts" "$STAGE/bin" "$STAGE/lib/docker/cli-plugins" \
    "$STAGE/documentation/packages/docker_compose"

for arch in "${@:-amd64 arm64}"; do
    haiku_arch=$arch
    [ "$arch" = "amd64" ] && haiku_arch=x86_64
    bin="build/haiku-$arch/docker-compose"
    [ -f "$bin" ] || { echo ">> building $arch first"; bash tools/build-haiku.sh "$arch"; }
    rm -rf "$STAGE/bin/docker-compose" "$STAGE/lib/docker/cli-plugins/docker-compose" "$STAGE/.PackageInfo"
    cp "$bin" "$STAGE/bin/docker-compose"
    cp "$bin" "$STAGE/lib/docker/cli-plugins/docker-compose"
    cp docs/airos.md "$STAGE/documentation/packages/docker_compose/"
    cat > "$STAGE/.PackageInfo" <<PKGEOF
name docker_compose
version $VERSION-1
architecture $haiku_arch
summary "Docker Compose for air/OS"
description "The docker compose plugin for air/OS, ported from the open-source Docker Compose. Drives the Docker Engine (airos-works/moby) over its API; installed both as docker-compose and as a Docker CLI plugin so 'docker compose' works out of the box."
packager "air/OS contributors"
vendor "air/OS"
copyrights { "2026 air/OS contributors" "Docker Compose CLI authors" }
licenses { "Apache v2" }
provides {
    docker_compose = $VERSION
    cmd:docker_compose = $VERSION
}
requires {
    haiku >= r1~beta5
    docker_cli
}
PKGEOF
    out="$ROOT/artifacts/docker_compose-$VERSION-1-${haiku_arch}.hpkg"
    "$PACKAGE_TOOL" create -C "$STAGE" "$out"
    echo ">> $out"
done
