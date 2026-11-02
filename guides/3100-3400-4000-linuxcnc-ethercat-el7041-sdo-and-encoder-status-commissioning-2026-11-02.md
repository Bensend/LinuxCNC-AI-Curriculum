# 3100/3400/4000 — EL7041 SDO and encoder-status commissioning walkthrough

**2026-11-02; disconnected implementation exercise; NOT a physical-machine commissioning release.** Read [ECAT-EL7041-146](../research/4400_LINUXCNC_ECAT_EL7041_146_MODPARAM_SDO_FALLTHROUGH_SOURCE_AUDIT_2026-11-02.md) and [ECAT-EL7041-147](../research/4400_LINUXCNC_ECAT_EL7041_147_ENCODER_OVERFLOW_UNDERFLOW_BIT_SWAP_SOURCE_AUDIT_2026-11-02.md).

## Correct hardware/driver identity first

The upstream [EL7041 XML guide](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/el7041.md) uses a sample `<master idx="0" appTimePeriod="1000000" refClockSyncCycles="1000"><slave idx="5" type="EL7041" name="X"/></master>`; indices/period are **examples, not installed-machine values**. `EL7041` and `EL7041-1000` share the velocity-mode `lcec_el7041.c` implementation with differing SDO support; `EL7041-0052` uses separate `lcec_el70x1.c` position-mode PDOs. Do not treat these aliases as interchangeable. Device YAML TestingStatus is blank.

## Frozen test A: configuration SDO recorder (fake I/O only)

Feed one typed modParam at a time into `handle_modparams` with a stub `lcec_write_sdo16`. Capture ordered `(0x8010,subindex,value)` calls. Required source-derived pre-correction oracles:

- `maxCurrent=2.5` → `:01=2500` only (control).
- `motorFullsteps=200` → `:06=200, :07=200, :09=200, :10=200, :11=200`.
- `encoderIncrements=4000` → `:07=4000, :09=4000, :10=4000, :11=4000`.
- `startVelocity=50` → `:09=50, :10=50, :11=50`.
- `driveOnDelay=100` → `:10=100, :11=100`; `driveOffDelay=150` → `:11=150`.
- Inject SDO failure on second `motorFullsteps` write: error must stop subsequent writes and initialization.
- After adding missing `break` statements, **each** parameter should issue its intended one write, while errors remain visible. Keep XML-order and unsupported-SDO tests distinct.

## Frozen test B: one-hot PDO truth (fake bus image only)

The compact encoder TxPDO [source](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el7041.c) defines `0x6000:04` underflow and `:05` overflow. With raw underflow-only, the existing code predicts HAL **overflow=1, underflow=0**; with overflow-only, HAL **underflow=1, overflow=0**. Both-high/both-low are non-discriminating controls. Verify both registered bit-position pointers and published HAL pins. After swapping the two wrong `bp` arguments, one-hot raw status must map to its own name.

## LinuxCNC HAL and machine-level interpretation

The driver exports `lcec.0.X.srv-enable`, `srv-cmd`, `srv-fault`, `srv-error`, `srv-ready`, `enc-count`, `enc-pos`, `enc-count-overflow`, `enc-count-underflow` and `enc-sync-error` (prefix depends on actual master/slave names). Capture commanded position, command enable, raw drive PDO, WKC and slave-operational state separately in any later qualified disconnected simulation. A HAL command or published status is not physical actuator confirmation. `srv-fault` is temporarily masked during the driver's fault-reset retry (lines 683–702); investigate that separately before trusting it as an amp-fault source. Do not energize a motor for this exercise.

## Frozen test C: drive error versus synthetic fault and reset

[ECAT-EL7041-148](../research/4400_LINUXCNC_ECAT_EL7041_148_FAULT_RESET_GATE_AND_STICKY_RESET_SOURCE_AUDIT_2026-11-02.md) adds a **separate** fake-PDO/driver-state exercise. With persistent raw `0x6010:04=1` and rising `srv-enable`, the source predicts four operational read callbacks with `srv-fault=0` while `srv-error=1`; `srv-reset` remains asserted even when the internal reset-state flag toggles FALSE, until retry ends. With retry=0, a manual `srv-fault-reset` request while enabled is cleared in the same write before PDO publication; while disabled the reset PDO can remain TRUE after the request self-clears. Capture raw and synthetic signals independently; no physical-drive claim. **NOT RUN.**

## Acceptance and evidence

Accept only reproducible pinned fake-SDO traces, one-hot PDO tests, error-injection results, and exact driver variant scope. Record source SHA, compiler/harness, raw output, pass/fail, job timestamps and compute. No test was run this session; every predicted result is **NOT RUN**, not hardware-confirmed. Independent personnel safety and OpenPressBrake G0/G1 restrictions remain unchanged.

## Fresh implementer questions

1. Why does one `motorFullsteps` modParam attempt five SDOs? Trace the same `p` through missing breaks.
2. Why can `enc-count` appear plausible while overflow/underflow HAL labels are swapped? Separate delta accumulation from bit extraction.
3. Why must `EL7041-0052` be tested separately from `EL7041-1000`? Identify different source files and PDO operating modes.

[Checkpoint](../checkpoints/20261102T0440Z-4000-linuxcnc-el7041-next.md).
