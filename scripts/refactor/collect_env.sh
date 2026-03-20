#!/usr/bin/env bash
set -euo pipefail

MILESTONE="${1:-M0}"
HOST_TAG="${2:-unknown-host}"
LOG_DIR="logs/refactor/${MILESTONE}/${HOST_TAG}"
mkdir -p "${LOG_DIR}"

{
  echo "timestamp=$(date -Iseconds)"
  echo "host_tag=${HOST_TAG}"
  echo "uname=$(uname -a)"
  echo "cmake=$(cmake --version | head -n 1 || true)"
  echo "cc=${CC:-unset}"
  echo "cxx=${CXX:-unset}"
  command -v gcc >/dev/null 2>&1 && echo "gcc=$(gcc --version | head -n 1)"
  command -v clang >/dev/null 2>&1 && echo "clang=$(clang --version | head -n 1)"
  command -v yasm >/dev/null 2>&1 && echo "yasm=$(yasm --version | head -n 1)"
  command -v nasm >/dev/null 2>&1 && echo "nasm=$(nasm -v)"
} > "${LOG_DIR}/env.log"

echo "Wrote ${LOG_DIR}/env.log"
