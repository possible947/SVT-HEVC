# Refactor Status Tracker

This file is the single source of truth for refactor execution progress.

## Environment Matrix

- macOS host A: x86_64-v2
- macOS host B: x86_64-v3
- Linux host A: x86_64-v3
- Linux host B: x86_64-v3 + NUMA
- Windows host A (MSYS2): x86_64-v4

## Guardrails

- Do not change public ABI in Source/API without explicit version decision.
- Prefer build-system and architecture scaffolding first.
- No broad functional test sweeps unless a change requires validation.
- Every milestone must record:
  - preconditions
  - done criteria
  - evidence link/log path

## Milestones and Status

### M0 Baseline and Coordination

Status: DONE

Preconditions:
- Fork created and local repository linked to origin and upstream.
- Master and execution plans added to Docs.
- Shared synchronization protocol available for all machines.

Done criteria:
- Status tracker and platform runbook committed.
- Initial coordination checkpoints defined.

Completion notes:
- Refactor status tracker created.
- Platform synchronization runbook created.
- Autonomous logging/configure scripts created under scripts/refactor.
- README documentation links updated.

Evidence:
- Docs/refactor/status.md
- Docs/refactor/platform_sync_runbook.md
- scripts/refactor/collect_env.sh
- scripts/refactor/configure_matrix.sh
- scripts/refactor/windows_msys2_configure.sh

### M1 Build-System Foundation

Status: DONE

Preconditions:
- M0 completed.

Current required conditions for completion:
- Completed.

Progress notes:
- Windows v4 (MSYS2) synchronization completed on Intel x86_64-v4 host.
- Windows v4 (MSYS2) evidence collected on Intel x86_64-v4 host:
  - logs/refactor/M1/windows-v4-msys2/env.log
  - logs/refactor/M1/windows-v4-msys2/configure-default.log
  - logs/refactor/M1/windows-v4-msys2/configure-static-lto.log
- Windows native supplemental smoke evidence collected:
  - logs/refactor/M1/windows-native/env.log
  - logs/refactor/M1/windows-native/smoke-help.log
  - logs/refactor/M1/windows-native/smoke-status.log
  - logs/refactor/M1/windows-native/ctest-status.log
- Linux v3 required configure evidence collected:
  - logs/refactor/M1/linux-v3/env.log
  - logs/refactor/M1/linux-v3/configure-default.log
  - logs/refactor/M1/linux-v3/configure-static-lto.log
- Linux v3 + NUMA supplemental evidence collected:
  - logs/refactor/M1/linux-v3-numa/env.log
  - logs/refactor/M1/linux-v3-numa/configure-default.log
  - logs/refactor/M1/linux-v3-numa/configure-static-lto.log

Done criteria:
- Feature flags scaffolded (LTO/static/RPATH policy toggles).
- No behavior change in default build mode.
- Linux and Windows required host checks completed with logs.

Evidence:
- logs/refactor/M1/linux-v3/*.log
- logs/refactor/M1/linux-v3-numa/*.log
- logs/refactor/M1/windows-v4-msys2/*.log
- logs/refactor/M1/windows-native/*.log

### M2 CPU Profiles v2/v3/v4 Scaffolding

Status: TODO

Preconditions:
- M1 completed.

Done criteria:
- Explicit CPU baseline options defined.
- Backend selection scaffolding prepared without ABI changes.
- Platform check logs recorded where applicable.

Evidence:
- logs/refactor/M2/*

### M3 NUMA Policy Layer Scaffolding

Status: TODO

Preconditions:
- M2 completed.

Done criteria:
- NUMA policy abstraction placeholders integrated.
- Linux NUMA host synchronization run completed.

Evidence:
- logs/refactor/M3/linux-v3-numa/*

## Change Log

- 2026-03-20: Tracker created. M0 started.
- 2026-03-20: M0 completed. M1 started with cross-host log conditions.
- 2026-03-20: M1 Linux-v3 logs captured; awaiting Windows-v4-MSYS2 synchronization logs.
- 2026-03-21: Added Linux-v3-NUMA configure/build/runtime smoke evidence for M1.
- 2026-03-22: Added Windows-v4-MSYS2 configure evidence and Windows-native supplemental smoke logs for M1.
- 2026-03-22: M1 reverted to IN_PROGRESS after artifact audit showed missing required Linux-v3 logs in current workspace.
- 2026-03-23: Added Linux-v3 required logs, imported Windows logs from windows/SVT-HEVC, and marked M1 DONE.
