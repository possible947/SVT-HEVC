# SVT-HEVC Refactor Execution Plan

This document turns the master plan into actionable implementation steps.

## Sprint 0: Branching and Baseline (2-3 days)

Tasks:
- Create long-running refactor branch.
- Capture baseline metrics for representative presets.
- Capture current exported ABI report.

Deliverables:
- Baseline benchmark report.
- Baseline ABI dump.

Exit criteria:
- Baseline artifacts are reproducible by another developer.

## Sprint 1: Build-System Foundation (4-6 days)

Tasks:
- Replace global mutable compile flags with per-target options.
- Add build options:
  - `SVT_ENABLE_LTO`
  - `SVT_ENABLE_FULL_STATIC`
  - `SVT_ENABLE_PORTABLE_RPATH`
- Add initial CMakePresets for Linux/macOS/MSYS2.
- Normalize install dirs and runtime path behavior.

Validation:
- Build succeeds in:
  - shared release
  - static release
  - static+LTO release

Exit criteria:
- No regressions in default build mode.
- Artifact runtime lookup is deterministic.

## Sprint 2: ISA Profiles v2/v3/v4 and Runtime Dispatch (5-8 days)

Tasks:
- Add `SVT_CPU_BASELINE` option (`v2|v3|v4`).
- Add `SVT_RUNTIME_DISPATCH` option and detection layer.
- Build backend registration table for scalar/SSE/AVX2/AVX-512 paths.
- Ensure safe fallback when unavailable ISA is detected at runtime.

Validation:
- Run smoke tests with forced backend selection where available.
- Verify no illegal instruction on v2-only hosts.

Exit criteria:
- v2/v3/v4 paths compile and dispatch as designed.
- Public ABI unchanged.

## Sprint 3: NUMA Layer and Policy Controls (5-8 days)

Tasks:
- Implement policy abstraction: off/compact/scatter/per-socket/custom-map.
- Linux backend via libnuma + affinity controls.
- Windows MSYS2 backend via WinAPI wrapper.
- macOS fallback policy without strict NUMA dependency.
- Expose diagnostics/logging for selected topology and policy.

Validation:
- Policy smoke tests on supported hosts.
- Thread placement and memory-locality sanity checks.

Exit criteria:
- NUMA policy behavior is deterministic and documented.

## Sprint 4: Test Harness Modernization (3-5 days)

Tasks:
- Fix Python 3 test script issues (indentation, argument parsing robustness).
- Add per-platform smoke test entry points.
- Add ABI check stage in CI.

Validation:
- Functional script runs under modern Python.
- ABI check passes against baseline.

Exit criteria:
- CI catches ABI drift and basic runtime regressions.

## Sprint 5: Platform Closure and Docs (3-5 days)

Tasks:
- Linux native hardening and package-friendly install behavior.
- macOS native linker/runtime validation and fixes.
- Windows MSYS2 packaging and runtime path validation.
- Update docs with modern requirements and exact commands.

Validation:
- Platform matrix green.
- Documentation verified against fresh environment setup.

Exit criteria:
- Release candidate artifacts and docs are consistent.

## Suggested Task Ownership

- Build/Toolchain lead: Sprint 1, CI presets.
- ISA/Kernel lead: Sprint 2.
- Runtime/Platform lead: Sprint 3 and Sprint 5.
- QA/Validation lead: Sprint 4 and regression reporting.

## Suggested Milestones

- M1: Build foundation complete.
- M2: ISA profile + dispatch complete.
- M3: NUMA policy complete.
- M4: CI/test modernization complete.
- M5: Cross-platform release candidate.

## Fast Rollback Strategy

If regressions appear late:
- Keep `SVT_RUNTIME_DISPATCH=OFF` fallback mode available.
- Keep `SVT_CPU_BASELINE=v3` compatibility profile for previous behavior.
- Keep `SVT_ENABLE_LTO=OFF` as release fallback switch.

## Acceptance Checklist

- [ ] Public ABI unchanged for release line.
- [ ] Linux/macOS/MSYS2 builds pass in CI.
- [ ] static+LTO build validated.
- [ ] v2/v3/v4 selection and fallback documented.
- [ ] NUMA policy tested and logged.
- [ ] README and user guide aligned with actual build/runtime behavior.
