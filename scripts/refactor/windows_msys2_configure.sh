#!/usr/bin/env bash
set -euo pipefail

MILESTONE="${1:-M1}"
HOST_TAG="${2:-windows-v4-msys2}"
LOG_DIR="logs/refactor/${MILESTONE}/${HOST_TAG}"
BUILD_ROOT="build-refactor/${MILESTONE}/${HOST_TAG}"
mkdir -p "${LOG_DIR}" "${BUILD_ROOT}"

cmake -S . -B "${BUILD_ROOT}/default" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
  > "${LOG_DIR}/configure-default.log" 2>&1

cmake -S . -B "${BUILD_ROOT}/static-lto" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DSVT_ENABLE_LTO=ON \
  -DSVT_ENABLE_FULL_STATIC=ON \
  -DSVT_ENABLE_PORTABLE_RPATH=ON \
  -DSVT_ENABLE_INSTALL_RPATH=ON \
  > "${LOG_DIR}/configure-static-lto.log" 2>&1

echo "Wrote logs to ${LOG_DIR}"
