#!/bin/bash
BASE="ddr3_cache.cfg"

mk() {
  PORTS=$1
  OUT="32KB_4w_45nm_${PORTS}port.cfg"
  sed -e "s/^-size (bytes).*/-size (bytes) 32768/" \
      -e "s/^-associativity.*/-associativity 4/" \
      -e "s/^-technology (u).*/-technology (u) 0.045/" \
      -e "s/^-read-write port .*/-read-write port ${PORTS}/" \
      "$BASE" > "$OUT"
  echo "created $OUT"
}

mk 1
mk 2
mk 4
