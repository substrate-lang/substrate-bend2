#!/usr/bin/env bash
# Times checking and compiling the module that proofs.sh writes, RUNS times (1 by default). Each run starts from a copy
# of a cache that holds bend2's own modules but not that module. SUBSTRATE names the substrate command, which is
# substrate by default or a checkout's bin/substrate.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/../.." && pwd)"
n="${1:-3200}"
runs="${2:-1}"
substrate="${SUBSTRATE:-substrate}"
out="$root/build/bench/compile"
mkdir -p "$out"
{ printf '(package proofs (version "0.1.0") (dependencies (bend2 (path "%s"))))\n' "$root"
  "$here/proofs.sh" "$n"; } > "$out/proofs-$n.sub"
warm="$out/warm-cache"
mkdir -p "$warm"
(cd "$here" && "$substrate" build warm.sub -o "$out/warm" -c "$warm" > /dev/null)
log="$out/time.log"
for ((i = 0; i < runs; i++)); do
  rm -rf "${out:?}/proofs-$n" "${out:?}/cache"
  cp -r "$warm" "$out/cache"
  (cd "$out" && command time -f '%e %M' "$substrate" build "proofs-$n.sub" -o "$out/proofs-$n" -c "$out/cache" \
     > "$log" 2>&1) || { cat "$log"; exit 1; }
  read -r real kb < <(tail -1 "$log")
  printf "proofs-%s %6s s  %5s MB\n" "$n" "$real" "$((kb / 1024))"
done
