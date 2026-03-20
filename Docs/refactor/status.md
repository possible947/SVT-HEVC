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

Status: IN_PROGRESS

Preconditions:
- M0 completed.

Current required conditions for completion:
- Linux v3: run collect_env and configure_matrix scripts and attach logs.
- Windows v4 (MSYS2): run collect_env and windows_msys2_configure scripts and attach logs (default and static-lto).
- Keep default build behavior unchanged.

Progress notes:
- Linux v3 evidence collected using autonomous scripts.
- M1 scaffold options configured successfully on Linux v3:
  - SVT_ENABLE_LTO
  - SVT_ENABLE_FULL_STATIC
  - SVT_ENABLE_PORTABLE_RPATH
  - SVT_ENABLE_INSTALL_RPATH
- Remaining mandatory synchronization step: Windows v4 (MSYS2) logs.

Done criteria:
- Feature flags scaffolded (LTO/static/RPATH policy toggles).
- No behavior change in default build mode.
- Linux configure/build smoke with logs.

Evidence:
- logs/refactor/M1/linux-v3/*.log
- logs/refactor/M1/windows-v4-msys2/*.log

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
