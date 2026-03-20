#!/usr/bin/env bash
set -euo pipefail

# One-shot synchronization run for non-primary Windows MSYS2 host.
# Executes all required checks for current milestones in one pass.

MILESTONE="${1:-M1}"
HOST_TAG="${2:-windows-v4-msys2}"
LOG_DIR="logs/refactor/${MILESTONE}/${HOST_TAG}"
mkdir -p "${LOG_DIR}"

{
  echo "timestamp=$(date -Iseconds)"
  echo "milestone=${MILESTONE}"
  echo "host_tag=${HOST_TAG}"
  echo "mode=one-shot"
} > "${LOG_DIR}/one-shot-summary.log"

scripts/refactor/collect_env.sh "${MILESTONE}" "${HOST_TAG}"
scripts/refactor/windows_msys2_configure.sh "${MILESTONE}" "${HOST_TAG}"

{
  echo "result=success"
  echo "required_logs="
  echo "- ${LOG_DIR}/env.log"
  echo "- ${LOG_DIR}/configure-default.log"
  echo "- ${LOG_DIR}/configure-static-lto.log"
} >> "${LOG_DIR}/one-shot-summary.log"

echo "One-shot checks completed. See ${LOG_DIR}/one-shot-summary.log"
