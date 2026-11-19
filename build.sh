#!/usr/bin/env bash
# Build the AI Assistant plugin against a built Constellation.
#
#   ./build.sh                   compile and package build/updates/*.nbm + updates.xml
#   ./build.sh test              run the unit tests
#   ./build.sh <ant target>...   any other suite target (clean, build, nbms, ...)
#
# Environment:
#   CONSTELLATION_DIR  Constellation checkout that has been built (default ../constellation)
#   JAVA_HOME_FX       JDK that includes JavaFX
#   NETBEANS_HOME      NetBeans platform (with harness)
set -euo pipefail
cd "$(dirname "$0")"

export JAVA_HOME="${JAVA_HOME_FX:-${JAVA_HOME:-}}"
NB="${NETBEANS_HOME:-$HOME/Tools/netbeans}"
CONSTELLATION_DIR="$(cd "${CONSTELLATION_DIR:-../constellation}" && pwd)"

if [[ ! -d "$CONSTELLATION_DIR/build/cluster/modules" ]]; then
  echo "Constellation hasn't been built: $CONSTELLATION_DIR/build/cluster is missing." >&2
  exit 1
fi

TARGETS=("$@")
[[ ${#TARGETS[@]} -eq 0 ]] && TARGETS=(nbms)

ant \
  -Dnbplatform.active.dir="$NB" \
  -Dnbplatform.default.netbeans.dest.dir="$NB" \
  -Dnbplatform.default.harness.dir="$NB/harness" \
  -Dconstellation.dir="$CONSTELLATION_DIR" \
  "${TARGETS[@]}"
