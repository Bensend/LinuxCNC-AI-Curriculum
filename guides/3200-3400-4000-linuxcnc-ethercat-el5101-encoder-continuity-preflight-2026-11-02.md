# 3200 / 3400 / 4000 — LinuxCNC EtherCAT EL5101 encoder continuity and scaling commissioning

**2026-11-02 | NON-GRADUATED | disconnected / source-grounded | ALL runtime cases NOT RUN.**

This guide translates [ECAT-ENC-143](../research/4400_LINUXCNC_ECAT_ENCODER_143_EL5101_RECONNECT_WRAP_FREQUENCY_SOURCE_AUDIT_2026-11-02.md) into a small, inspectable diagnostic workflow for a lathe spindle, mill/router axis, or custom mechanism. It concerns the **out-of-tree** LinuxCNC-EtherCAT driver, not a LinuxCNC core feature or a generic EtherCAT guarantee.

## Pin and signal contract

Pinned driver [EL5101 source](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el5101.c) exports these HAL pins under `lcec.<master-name>.<slave-name>`:

| Pin suffix | Direction | Source meaning | Must not be mistaken for |
| --- | --- | --- | --- |
| `enc-raw-count` | OUT s32 | Last accepted signed 16-bit PDO count sign-extended | Continuous absolute count |
| `enc-count` | OUT s32 | Software sum of signed 16-bit deltas, reset/rebased by control paths | Position valid after disconnect |
| `enc-pos` | OUT float | `enc-count / enc-pos-scale` | Independent physical measurement |
| `enc-pos-scale` | IO float | Counts per engineering unit (negative permitted; near-zero reset to 1) | Machine kinematics calibration |
| `enc-raw-freq` | OUT u32 | Raw PDO frequency field | Calibrated Hz |
| `enc-frequency-scale` | IO float | Default 0.05; source comment admits historically wrong value | Authoritative device calibration |
| `enc-frequency` | OUT float | Raw frequency × frequency-scale | Tachometer truth |
| `enc-index-c-enable`, `enc-index-ext-pos-enable`, `enc-index-ext-neg-enable` | IO bit | One-shot latch controls; driver clears on validity | G38 probe handshake |
| `enc-latch-c-valid`, `enc-latch-ext-valid`, `enc-raw-latch` | OUT | Terminal latch validity and captured raw count | Time-stamped motion position |
| `enc-reset`, `enc-set-raw-count`, `enc-set-raw-count-val` | IN / IO / IN | Origin-altering operations | Harmless observation controls |

The master additionally publishes `lcec.<master>.<slave>.slave-oper` and master WKC pins; a threaded Sync Unit exposes `fresh`, `wkc-state`, and `stale-count`. See the [pinned master code](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c) and [ECAT-12](../research/4400_LINUXCNC_ETHERCAT_12_SYNC_UNIT_FRESHNESS_LATE_OUTPUTS_SOURCE_AUDIT_2026-10-30.md). Pin names and availability must be confirmed against the installed driver/XML before use.

## Minimum isolated bring-up (documentation, not a dispatched test)

Do not connect to an operational machine or drive outputs as part of this exercise. With a physically isolated bench, qualified local EtherCAT master, EL5101, and read-only instrumentation, a *candidate* XML (slave position **must be checked**, not assumed) is:

```xml
<masters>
  <master idx="0" appTimePeriod="1000000" refClockSyncCycles="-1">
    <slave idx="0" type="EL5101" name="enc"/>
  </master>
</masters>
```

The maintained driver's [README](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/README.md) documents the standalone `halrun` flow. On a qualifying LinuxCNC 2.10+ bench, the conceptual command order is:

```halrun
loadusr -W lcec_conf ethercat.xml
loadrt lcec
loadrt threads name1=servo-thread period1=1000000
addf lcec.read-all servo-thread
addf lcec.write-all servo-thread
initf lcec.activate servo-thread
start
show pin lcec
```

On LinuxCNC **2.9**, omit `initf` (not supported); the driver uses a different activation path. These commands are a documented template **NOT RUN** here. They are not appropriate for an unknown installed controller, and no XML/device compatibility is implied. Do not wire the encoder to `joint.N.motor-pos-fb` until the following diagnostics and physical calibration are complete.

## Eight discriminating acceptance cases

Each case requires a source-pinned build and either a pure fake-PDO driver harness or an appropriately disconnected, instrumented EL5101. Preserve test version, XML, HAL, compiler, observed values, WKC, timing and raw logs. Do not score source-derived predictions as runtime PASS.

| Case | Stimulus | Predicted HAL behavior from pinned source | What would falsify or limit the prediction |
| --- | --- | --- | --- |
| A | Normal raw samples 1000→1010, no control bits | `enc-count` +10, `enc-pos` +10/`enc-pos-scale` | Unexpected reset/latch/scale or different binary |
| B | Raw 32760→−32760 with true +16 and no lost samples | Narrowed delta +16 on usual two's-complement compiler | Different signed narrowing or device count representation |
| C | True +33000 between accepted raw samples 0→−32536 | Ambiguous sign; driver likely accumulates −32536, **not** +33000 | A different driver version or extra turn/overflow reconciliation |
| D | Operational FALSE for a cycle after valid sample | `enc-pos` and `enc-count` remain previously published; `last_operational=0` | Runtime that explicitly clears pins outside this driver |
| E | Offline motion +500 counts, first restored raw sample 1500 after prior 1000 | First restored delta 0; cumulative count remains 1000 | Explicit reset/latch/set-count, different source, or physical rehome |
| F | Valid index latch at raw 1015, current raw 1020 | Accumulated count rebased to +5, not necessarily zero | Terminal latch-valid timing, double-valid-bit precedence |
| G | Raw frequency 1000 at default scale 0.05 | Published frequency 50; changing scale to 0.01 yields 10 | Device units/scale may not equal physical Hz |
| H | Domain WKC becomes incomplete while `slave-oper` last sampled TRUE | `slave-oper` can lag; master WKC changes sooner; no freshness guarantee from position pin | Master revision/state update cadence or external gating |

Cases D/E require *controlled fault simulation or a disconnected bench*, not an interruption of a machine's feedback loop. Cases B/C are **arithmetic models**, not permission to exceed encoder count-rate limits. For C, even if the measured raw endpoints match, the true path is unknowable from two modulo-16-bit values alone.

## Diagnostic trace to capture

Record at least: monotonic cycle/sample sequence, raw count, accumulated count, position, `slave-oper`, master/per-unit `wkc-state`, `fresh` if available, reset/latch/set-count pins, frequency raw/scaled, `pos-scale`, and the application-level trusted-position flag. `slave-oper` is polled at the driver's periodic state cadence (nominal 1 s after startup); WKC and Sync Unit generation have different update semantics. Treat the three as separate evidence.

A useful analysis table for a disconnected fault-injection run is:

```cycle  slave-oper  wkc-state  fresh  raw  enc-count  trusted  note
100    1           COMPLETE   1      1000 1000       1        baseline
101    1           INCOMPLETE 0      1000 1000       0        bus anomaly; state may lag
...    0           ZERO       0      1000 1000       0        operational loss
120    1           COMPLETE   1      1500 1000       0        first recovery; +500 not reconstructed
```

This table is **illustrative source-derived data, not observed output**. `trusted=0` is a recommended application policy, not an automatically exported LinuxCNC HAL pin.

## Integration boundaries

For **3200 lathes**, do not assume `enc-frequency` is calibrated spindle RPM or that a reconnected spindle phase/count is continuous; compare with the actual spindle-index/synchronization configuration before G33/G76 use. For **3100 mills / 3400 routers**, do not automatically clear a lost-position flag merely because `slave-oper` returns TRUE; require a justified home/reference recovery. For **3500 robotics**, distinguish incremental axis position from absolute joint reference. For all, an independent personnel-safety controller remains authoritative; EtherCAT status is ordinary control/diagnostic evidence, not a protective channel.

## Exact next work

On a positively qualified, physically disconnected **`[self-hosted, openpressbrake]`** runner, a fake-PDO harness can first test A–G without EtherCAT hardware. If no qualified compute exists, inspect a distinct LinuxCNC implementation question rather than making a mandatory new product or generating additional unrun fixtures. Capture actual job timestamps and runtime only after execution. No GitHub-hosted Actions runners.

**Evidence now:** SOURCE-CONFIRMED conditional and numeric inference; **runtime NOT RUN**, physical machine UNKNOWN, independent evaluation unchanged. Graduated levels closed, OpenPressBrake G0/G1 HOLD unchanged. [Checkpoint](../checkpoints/20261102T0236Z-4000-linuxcnc-ethercat-encoder-next.md).
