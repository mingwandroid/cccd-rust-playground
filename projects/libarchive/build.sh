#!/usr/bin/env bash

. ~/conda/cccd-rust-playground/bootstrap/rust-activate.sh

cargo clean

if [[ $(uame) == Darwin ]]; then
  _LIBARCHIVE_LDFLAGS="-Bstatic -L${CONDA_PREFIX}/lib -llzo2 -llzma -llz4 -lcharset -lbz2 -lz -lxml2 -Bdynamic"
else
  _LIBARCHIVE_LDFLAGS="-Bstatic -L${CONDA_PREFIX}/lib -llzo2 -llzma -llz4 -lbz2 -lz -lxml2 -licui18n -licuuc -licudata -L${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/lib -lstdc++ -lcrypto -Bdynamic"
fi

LIBARCHIVE_LIB_DIR=${CONDA_PREFIX}/lib \
LIBARCHIVE_INCLUDE_DIR=${CONDA_PREFIX}/include \
LIBARCHIVE_LDFLAGS=${_LIBARCHIVE_LDFLAGS} \
LIBARCHIVE_STATIC=true \
  cargo build -vv
