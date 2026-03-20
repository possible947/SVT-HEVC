# SVT-HEVC Refactor Master Plan

## 1. Scope and Goals

This document defines a staged refactor plan for maintainable cross-platform evolution of SVT-HEVC while preserving public ABI compatibility.

Primary goals:
- Preserve binary compatibility of the public encoder API in Source/API.
- Improve build/runtime portability across Linux, macOS (native), and Windows (MSYS2/MinGW).
- Add explicit CPU profile support for Intel x86-64-v3 and x86-64-v4.
- Re-introduce explicit NUMA-aware execution policies.
- Enable static and LTO-oriented build modes in a supported way.

Non-goals:
- Redesigning encoder bitstream logic.
- Changing public API contracts unless versioned and explicitly approved.

## 2. Compatibility Rules

### 2.1 ABI Safety Rules
- Do not modify exported symbol names/signatures from public headers without versioning.
- Do not change binary layout of publicly exposed structs unless gated by major-version bump.
- Keep SONAME policy explicit and stable per release line.

### 2.2 Behavior Rules
- Different ISA backends may produce minor output differences in non-bit-exact modes.
- HEVC compliance must remain valid regardless of selected backend path.

## 3. Architecture Strategy

### 3.1 CPU Baseline and Profiles
Introduce explicit profile options:
- `SVT_CPU_BASELINE=v2|v3|v4` (default: `v2` for broad compatibility)
- `SVT_RUNTIME_DISPATCH=ON|OFF` (default: `ON`)

Profile intent:
- v2: safe baseline path for broader x86_64 support.
- v3: AVX2/FMA/BMI2 class optimization profile.
- v4: AVX-512 class optimization profile.

Important note:
- Lowering baseline from AVX2 to v2 must not change ABI. It changes internal backend selection and performance profile only.

### 3.2 Backend Organization
- Keep scalar/C_DEFAULT as always-available fallback.
- Keep SSE/AVX2/AVX-512 paths as internal backend targets.
- Build dispatch tables to select kernels at runtime based on detected features.
- Avoid global `CMAKE_C_FLAGS` mutations in subdirectories; use per-target compile options.

## 4. NUMA Strategy

Introduce a dedicated NUMA policy layer with platform adapters.

Policies:
- off
- compact
- scatter
- per-socket
- custom-map

Platform backends:
- Linux: libnuma + pthread affinity.
- Windows (MSYS2): WinAPI affinity/group wrappers through a portability shim.
- macOS: topology-aware fallback (no strict NUMA APIs), graceful degradation.

Requirements:
- Keep CLI compatibility for thread/socket controls where possible.
- Add runtime diagnostics reporting selected topology and policy.

## 5. Cross-Platform Build Strategy

### 5.1 Build Features
Add explicit options:
- `SVT_ENABLE_LTO=ON|OFF`
- `SVT_ENABLE_FULL_STATIC=ON|OFF`
- `SVT_ENABLE_PORTABLE_RPATH=ON|OFF`

Guidelines:
- LTO via CMake IPO (`CMAKE_INTERPROCEDURAL_OPTIMIZATION`) with compiler checks.
- Static library mode and fully static app mode tested separately.
- RPATH/RUNPATH policy should support both install-layout and portable side-by-side binaries.

### 5.2 Preset Model
Create CMake presets for:
- linux-gcc-release
- linux-clang-release
- linux-gcc-static-lto
- macos-clang-release
- windows-msys2-mingw-release

## 6. Platform-Specific Workstreams

### Linux (native)
- Reference platform for performance and NUMA validation.
- Validate shared, static, and static+LTO builds.
- Validate runtime search path behavior for installed and portable layouts.

### macOS (native)
- Ensure linker flags are macOS-safe (no Linux-only flags leakage).
- Validate install_name/rpath behavior.
- Validate fallback scheduling policies where NUMA features are unavailable.

### Windows (MSYS2/MinGW)
- Standardize toolchain assumptions (yasm/nasm, pkg-config, paths).
- Validate DLL lookup behavior and packaging model.
- Validate affinity policies through portability shim.

## 7. Test and Validation Strategy

### 7.1 Functional and Stability
- Fix Python3 compatibility in current test harness.
- Add smoke tests per platform profile.
- Add ISA dispatch tests (forced backend where possible).

### 7.2 ABI Validation
- Integrate ABI checks between baseline and refactor branch (abi-dumper/abi-compliance-checker).
- Gate merges if exported ABI changes unexpectedly.

### 7.3 Performance Regression Gates
- Track throughput and memory for representative presets.
- Define acceptable regression thresholds per mode.

## 8. Delivery Phases

Phase 1: Build-system hardening
- Per-target flags, presets, RPATH policy, LTO/static feature toggles.

Phase 2: ISA profile and dispatch
- v2/v3/v4 profiles, runtime detection, backend registration.

Phase 3: NUMA layer
- Policy abstraction + platform adapters + diagnostics.

Phase 4: Cross-platform closure
- Linux/macOS/MSYS2 CI matrix and platform-specific fixes.

Phase 5: Documentation and release hardening
- Update README/user guide and migration notes.

## 9. Risks and Mitigations

- Risk: performance drop on old CPUs after dispatch changes.
  - Mitigation: profile-specific perf baselines and forced-backend benchmarking.

- Risk: accidental ABI drift.
  - Mitigation: automated ABI report in CI.

- Risk: platform-specific linker/runtime breakage.
  - Mitigation: per-platform smoke tests and artifact validation (ldd/otool/dumpbin equivalents).

## 10. Definition of Done

- Public ABI compatibility preserved for the release line.
- Linux/macOS/MSYS2 builds pass in shared and static modes.
- static+LTO path validated.
- v2/v3/v4 profile selection implemented and documented.
- NUMA policy layer integrated with platform-specific behavior and diagnostics.
- Documentation updated with exact build/run instructions.
