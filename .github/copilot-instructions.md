# Copilot instructions for SVT-HEVC

## Build, test, and lint

### Build (Linux/macOS)
- Preferred script (from repo root):
  - `cd Build/linux && ./build.sh release`
  - `cd Build/linux && ./build.sh debug`
  - `cd Build/linux && ./build.sh release static`
  - `cd Build/linux && ./build.sh release install`
- Direct CMake/Ninja flow (matches CI pattern):
  - `cmake -GNinja -S . -B Build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF`
  - `cmake --build Build --parallel 4 --target install`

Build artifacts are written to `Bin/<BuildType>/` (for example `Bin/Release/SvtHevcEncApp` and the `SvtHevcEnc` library).

### Tests
- Functional test harness:
  - Full class run: `python Tests/SVT-HEVC_FunctionalTests.py Fast -type all`
  - Single suite run: `python Tests/SVT-HEVC_FunctionalTests.py Fast -type vbv_test`
- Minimal encode smoke command (similar to CI bit-depth tests):
  - `./Bin/Release/SvtHevcEncApp -encMode 0 -i akiyo_cif.y4m -n 3 -b smoke.hevc`

### Lint
There is no dedicated lint target/tooling configured in this repository or CI workflow. Follow `STYLE.md` for formatting and style rules.

## High-level architecture

- **Public API boundary**: `Source/API/EbApi.h` defines the encoder API and lifecycle (`EbInitHandle` → `EbH265EncSetParameter` → `EbInitEncoder` → `EbH265EncSendPicture` / `EbH265GetPacket` → teardown).
- **Application wrapper**: `Source/App/` provides `SvtHevcEncApp`, which parses CLI/config files, maps config values into `EB_H265_ENC_CONFIGURATION`, pushes frames, and drains output packets/recon frames.
- **Encoder core pipeline**: `Source/Lib/Codec/` implements the multi-stage threaded pipeline. In `EbEncHandle.c`, contexts/threads are created for stages such as:
  - ResourceCoordination
  - PictureAnalysis
  - PictureDecision
  - MotionEstimation
  - InitialRateControl
  - SourceBasedOperations
  - ModeDecisionConfiguration
  - EncDec
  - EntropyCoding
  - Packetization
  These stages communicate through `EbSystemResourceManager` FIFOs and result/task objects.
- **SIMD layering model**: `Source/Lib/C_DEFAULT` contains scalar C kernels; `Source/Lib/ASM_*` provides ISA-specific kernels (SSE2/SSSE3/SSE4.1/AVX2, some AVX512 codepaths). `SvtHevcEnc` links all object libraries and dispatches based on CPU capability / `AsmType`.

## Key repository conventions

- **Configuration precedence**: command-line arguments override config-file values (`-c Config/Sample.cfg` + explicit flags). Keep this behavior when adding parameters.
- **Thread count behavior**: app-side config mapping rounds `ThreadCount` to encoder expectations and enforces minimums (see `EbAppContext.c` + `EB_THREAD_COUNT_*` in `EbApi.h`).
- **10-bit input handling**: both packed and unpacked 10-bit flows are supported. For unpacked mode, `EB_H265_ENC_INPUT` uses `luma/cb/cr` plus extension planes `lumaExt/cbExt/crExt`; do not assume a single-plane-per-component model.
- **Coding style is strict and project-specific**: no tabs, 4-space indentation, 80-char preference, and specific brace/if/switch patterns from `STYLE.md`.
- **CMake knobs used by maintainers/CI**: `BUILD_SHARED_LIBS`, `BUILD_APP`, `NATIVE`, and scaffold options `SVT_ENABLE_LTO`, `SVT_ENABLE_FULL_STATIC`, `SVT_ENABLE_PORTABLE_RPATH`, `SVT_ENABLE_INSTALL_RPATH`.
