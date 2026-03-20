# Platform Synchronization Runbook

This runbook defines when and how to synchronize refactor checkpoints across available machines.

## Available Hosts

- macOS x86_64-v2
- macOS x86_64-v3
- Linux x86_64-v3
- Linux x86_64-v3 + NUMA
- Windows x86_64-v4 via MSYS2

## Synchronization Rules

1. Each milestone has required host checks.
2. A host check can be:
   - interactive debug run on that host, or
   - autonomous script execution with captured logs.
3. Logs are stored in repository under logs/refactor/<milestone>/<host>/.
4. If a host is unavailable, milestone cannot be marked DONE.
5. Windows host is treated as non-primary: required checks should be executed in one-shot batches.

## Required Checks by Milestone

### M0 Baseline and Coordination

Required hosts:
- none (documentation-only checkpoint)

Required artifacts:
- Docs/refactor/status.md
- Docs/refactor/platform_sync_runbook.md

### M1 Build-System Foundation

Required hosts:
- Linux x86_64-v3
- Windows x86_64-v4 (MSYS2)

Optional hosts:
- macOS x86_64-v2
- macOS x86_64-v3

Required commands (minimum):
- Configure build with default options.
- Configure build with static+LTO options.

Required logs:
- logs/refactor/M1/linux-v3/configure-default.log
- logs/refactor/M1/linux-v3/configure-static-lto.log
- logs/refactor/M1/windows-v4-msys2/configure-default.log
- logs/refactor/M1/windows-v4-msys2/configure-static-lto.log
- logs/refactor/M1/windows-v4-msys2/one-shot-summary.log

Recommended Windows one-shot command:
- scripts/refactor/windows_msys2_one_shot.sh M1 windows-v4-msys2

### M2 CPU Profiles v2/v3/v4

Required hosts:
- macOS x86_64-v2
- Linux x86_64-v3
- Windows x86_64-v4 (MSYS2)

Required logs:
- per-host configure summary for selected profile
- dispatcher selection diagnostics log

### M3 NUMA Layer

Required hosts:
- Linux x86_64-v3 + NUMA

Required logs:
- numa topology summary
- policy selection and thread placement diagnostics

## Autonomous Logging Scripts

The recommended script locations are:
- scripts/refactor/collect_env.sh
- scripts/refactor/configure_matrix.sh
- scripts/refactor/windows_msys2_configure.sh
- scripts/refactor/windows_msys2_one_shot.sh

Script outputs should include:
- OS and compiler versions
- cmake version
- selected options
- success/failure exit code

## Status Update Template

Use this template when updating Docs/refactor/status.md:

- Milestone:
- Host:
- Preconditions met:
- Commands executed:
- Result:
- Log path:
- Next condition:
