# ECAT-EL7041-150 — Minimal source repair and executable fake-SDO contract

**2026-11-02 | 4000 LinuxCNC implementation; 3100 mill / 3400 router transfer | NON-GRADUATED.**

## Why this increment is substantive
This is a **repair artifact**, not a new discovery: [ECAT-EL7041-146](../research/4400_LINUXCNC_ECAT_EL7041_146_MODPARAM_SDO_FALLTHROUGH_SOURCE_AUDIT_2026-11-02.md) already proved five missing switch breaks; [ECAT-EL7041-147](../research/4400_LINUXCNC_ECAT_EL7041_147_ENCODER_OVERFLOW_UNDERFLOW_BIT_SWAP_SOURCE_AUDIT_2026-11-02.md) already identified crossed PDO bit-position pointers. This increment supplies a reviewable **seven-line change** and a compiler-backed fake-SDO oracle that extracts the **actual function** from the pinned upstream C file instead of reimplementing its logic.

Upstream: [linuxcnc-ethercat](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat) release commit [56515f4aac313551346289d9c227193f50e9602a](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a), published 2026-10-29T03:20:29Z; `src/devices/lcec_el7041.c` blob **75d5428695085be053837c27220b81a6740ec835**, also independently observed on current `master` this session. The curriculum patch is [el7041_sdo_pdo_minimal.patch](../examples/4000_el7041_150/el7041_sdo_pdo_minimal.patch); the source-function test is [test_el7041_modparams.py](../examples/4000_el7041_150/test_el7041_modparams.py). **Neither has been executed or applied upstream.**

## Change boundaries and causality

1. Add a `break;` after each of `MODPARAM_MOTOR_EMF`, `MODPARAM_MOTOR_FULLSTEPS`, `MODPARAM_ENCODER_INCREMENTS`, `MODPARAM_START_VELOCITY`, `MODPARAM_DRIVE_ON_DELAY`. Preserve every existing SDO index, conversion and failure return. This prevents unrelated `0x8010` writes from the same modParam.
2. Correct the two `lcec_pdo_init` `0x6000:04/:05` **bit-position pointers** to match their underflow/overflow offset pointers. Preserve the PDO definitions and `EC_READ_BIT` read path.
3. Do **not** alter `srv-fault`, `srv-error`, `srv-reset`, retry timing or enable behavior. Those are separate [ECAT-EL7041-148](../research/4400_LINUXCNC_ECAT_EL7041_148_FAULT_RESET_GATE_AND_STICKY_RESET_SOURCE_AUDIT_2026-11-02.md) state-machine questions needing explicit reset-policy decisions.

## Disconnected reproducible acceptance (NOT RUN)

On a positively qualified, physically disconnected `[self-hosted, openpressbrake]` host only, with a **separate local checkout** of the pinned upstream release and a C compiler:

```sh
# From the root of the pinned linuxcnc-ethercat checkout.
git rev-parse HEAD   # must equal 56515f4aac313551346289d9c227193f50e9602a
git hash-object src/devices/lcec_el7041.c  # must equal 75d5428695085be053837c27220b81a6740ec835
python3 /path/to/curriculum/examples/4000_el7041_150/test_el7041_modparams.py --source src/devices/lcec_el7041.c --expect original
git apply --check /path/to/curriculum/examples/4000_el7041_150/el7041_sdo_pdo_minimal.patch
git apply /path/to/curriculum/examples/4000_el7041_150/el7041_sdo_pdo_minimal.patch
python3 /path/to/curriculum/examples/4000_el7041_150/test_el7041_modparams.py --source src/devices/lcec_el7041.c --expect patched
git diff --check
```

The harness extracts `handle_modparams` with balanced braces, supplies fake `lcec_write_sdo16/8`, and compares ordered writes for six integer/current cases, the patched motor-EMF case, and immediate SDO failure. It separately checks the exact PDO-registration expressions. It compiles **only that extracted C function**; it does **not** compile or load LinuxCNC, EtherCAT, the IgH master, or the full driver. These tests are discriminating for the identified source mistakes, not proof of physical encoder status or motor behavior.

Frozen expected delta: `motorFullsteps=200` attempts five writes before the repair (`:06/:07/:09/:10/:11`) and one afterward (`:06`); `driveOnDelay=100` changes from two (`:10/:11`) to one (`:10`). The one-hot PDO bit mapping changes from crossed to matching labels. The source-only review also checked five exact case insertion anchors and both pointer expressions; **no actual `git apply`, compiler, test or bus execution occurred here**.

## Review gates before upstream proposal or machine use

- Independently run the two-mode harness and inspect **raw output** and compiler diagnostics. A failed harness is a test failure, not an opportunity to change the oracle after seeing results.
- Review the complete patched driver with compiler warnings, upstream integration tests, and supported terminal variants (`EL7041`, `EL7041-1000`, `EP7041`; do not conflate `EL7041-0052` and its separate driver).
- Inject a failure on the second SDO write in the **original** implementation if testing original abort chronology; the included harness instead tests first-write failure for both versions. Record any added test as a new frozen oracle.
- Review full PDO registration against the actual IgH mapping and Beckhoff device revision. A source-expression test does not establish a live process-image layout.
- Keep drive fault-reset semantics and independent personnel-safety authority separate. Do not apply this experimental patch to an operating machine based on source inspection alone.

## Transfer question / evidence debt
If a configured motor EMF of 1.0 writes a nonsensical `motorFullsteps`, is the defect a floating-point conversion problem? **No**: the switch falls through and reads the same union as `u32`. The minimal fix is a case terminator, not an ad-hoc reinterpretation. Whether terminal firmware accepts any such write is **UNKNOWN**.

**Evidence:** SOURCE-CONFIRMED pinned old source and patch target; STATIC REVIEW of textual seven-line change; TEST-CONFIRMED **none**; physical effects **UNKNOWN**. No Actions, HAL, LinuxCNC, EtherCAT or physical machine execution. Graduated levels and independent safety gates unchanged.
