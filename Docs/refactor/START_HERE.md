# START HERE

## 1) Open Branch

Checkout:
`refactor/m2-v2-v3-v4-scaffold`

## 2) Read Context (2 files)

- Docs/refactor/session_snapshot.md
- Docs/refactor/status.md

## 3) Windows One-Shot (MSYS2)

From repo root run:

```bash
scripts/refactor/windows_msys2_one_shot.sh M1 windows-v4-msys2
```

## 4) Verify Required Logs

- logs/refactor/M1/windows-v4-msys2/env.log
- logs/refactor/M1/windows-v4-msys2/configure-default.log
- logs/refactor/M1/windows-v4-msys2/configure-static-lto.log
- logs/refactor/M1/windows-v4-msys2/one-shot-summary.log

## 5) Commit Logs and Continue

Commit generated logs, then proceed to M2 (CPU profile scaffolding v2/v3/v4).
