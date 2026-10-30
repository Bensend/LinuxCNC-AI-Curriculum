# 4400-PI500-FREQ-04 — frequency input validity and RUN-command independence
**2026-10-30 | source-only, NON-GRADUATED | no drive test | no personnel-safety credit**

## Exact question and novelty
Can the ordinary LinuxCNC PI500 driver issue RUN when its commanded frequency is zero, negative, invalid or unrepresentable? This is **not** a repetition of PI500-VFD-01 (disabled remote-trip discrepancy), PI500-OEM-COMM-02 (host/drive watchdog mismatch), or PI500-MULTI-03 (one process delays multiple slaves). A direct synonym search of the canonical safety index found those three predecessors but no `commanded_frequency` / `F001` / nonfinite-input review. This adds **normal-command validation and stale setpoint** to the same upstream maintainer handoff, not a new scored safety module.

## Pinned sources
- **SOURCE-CONFIRMED:** [LinuxCNC `pi500_vfd.comp`, development commit e1c6a557](https://github.com/LinuxCNC/linuxcnc/blob/e1c6a557c0e1c61961f17ee35a1ba188e7db275f/src/hal/user_comps/pi500_vfd/pi500_vfd.comp), Git blob `92cc57bdf5214bbb3fb92103837539e42a76d452`. Relevant symbols: `pi500_setFrequency`, `pi500_getStatus`, `user_mainloop`, `calculated_frequency`, `pi500_run`.
- **SOURCE-CONFIRMED corroboration:** [stable v2.9.10 PI500 source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/user_comps/pi500_vfd/pi500_vfd.comp), Git blob `b77f6e0241d3bf9db44edd97ddbb229af184dd18`, retains the same conversion and RUN predicate.
- **DOC-CONFIRMED, narrow:** [LinuxCNC current generated PI500 manual](https://linuxcnc.org/docs/devel/html/en/man/man1/pi500_vfd.1.html) labels `commanded-frequency` as a real input and `run` as a separate Boolean; it specifies no validated input range, zero-frequency RUN policy, finite-value guard or restart contract.
- **LANGUAGE REFERENCE (not runtime proof):** [C floating-to-integer conversion rules](https://en.cppreference.com/c/language/conversion): truncation for representable finite values; undefined behavior if the truncated value cannot be represented in the integer destination. NaN/Infinity must not be cast and assumed to map to a safe register value.
- **DOC-CONFIRMED for the 2018 OEM edition, not installed firmware:** [Powtran PI500 March 2018 manual Appendix I](https://www.manualslib.com/manual/1658524/Powtran-Pi500-Series.html), command register `0x2000` includes RUN `1`, deceleration STOP `6`, fault reset `7`. Driver writes frequency to `0xF001`. Exact selected model, F0.03 source selection, frequency resolution and drive behavior remain UNKNOWN. The manufacturer's newer V5.1 edition was not independently retrieved.

## Direct code path and failure propositions
```c
calculated_frequency = (uint16_t)(
    fabs(commanded_frequency) * 10 * (status.freq_two_digits ? 10 : 1));
if (commanded_frequency > 0
    && calculated_frequency != status.frequency
    && !pi500_setFrequency(ctx, calculated_frequency)) { /* ... */ }
if (status.running ^ run && !pi500_run(ctx, run)) { /* ... */ }
```
`pi500_setFrequency` writes `0xF001`; `pi500_run(ctx,true)` writes `1` to `0x2000`. The RUN branch does **not** require `commanded_frequency > 0`, a successful frequency write, or an explicitly fresh start edge. For the following **conditional source-state examples**, assume a successful status poll, `enable=true`, `status.alarm=false`, `status.running=false`, and `run=true`:

| Input / source state | Exact source consequence | What is **not** established |
|---|---|---|
| `commanded_frequency=0` | `calculated_frequency=0`; frequency-write guard false; RUN register write attempted. | Drive rotation, accepted command, prior setpoint, selected frequency source. |
| `commanded_frequency=-10` | `fabs` produces 10 for the intermediate calculation, but `commanded_frequency>0` is false; no frequency write; RUN write attempted. | Negative value does not prove a reverse command or a stopped motor. |
| Positive but below one raw count, e.g. `0.05` when `freq_two_digits=false` | Conversion truncates `0.5` to 0; if polled `status.frequency!=0`, a **zero** frequency write may be attempted before RUN. | What the selected drive does with a zero register write. |
| Finite positive value whose scaled magnitude is outside `uint16_t` | Floating-to-`uint16_t` cast lacks bounds check; behavior is not defined by the C language for out-of-range conversion. | Do **not** claim a deterministic wraparound, frequency, or safe failure. |
| NaN / ±Infinity | No `isfinite` check before the cast. Comparisons with NaN do not make conversion safe. | No deterministic register output or physical response can be asserted. |
| `status.running=true, run=true`, invalid/zero frequency | No new RUN write is required, and zero/negative input does not itself issue STOP. | A retained motor state is not independently verified. |

**SOURCE-CONFIRMED:** the code can attempt RUN with zero/negative input and no fresh frequency write. **INFERENCE:** where the selected drive retains a previously set frequency and permits remote RUN, the new RUN may act on that retained value. That implication is configuration-dependent and is **not** TEST-CONFIRMED.

A separate nuance: `pi500_getStatus` reads `0xF001` into `speed_setting` but does not use that variable; `status.frequency` comes from `status_params[1]` in the `0x1000` block. The code therefore compares its command with a polled status value rather than proving that a newly written `0xF001` setting was accepted. The exact meaning of that status register on each supported firmware must be reconciled with its OEM table.

## Review-only acceptance design (NOT IMPLEMENTED OR TESTED)
1. **Define an ordinary-control contract:** `run=true` with zero, negative, nonfinite, out-of-range, or sub-resolution frequency must have an explicit documented response. A reasonable proposed default is *no RUN write* until a valid, model-bounded positive frequency has been accepted; compatibility and zero-speed operation must be decided by maintainers.
2. **Validate before conversion:** check `isfinite`, nonnegative/positive policy, supported model/firmware frequency limits, scale and representable `uint16_t` range *before* casting; report rejected inputs and leave the drive in a defined ordinary-control state. Never assume `fabs` makes a negative command legitimate.
3. **Do not silently reuse a previous frequency:** define what is allowed on startup, fault recovery, serial reconnection, HAL reset, or a held `run`. Separate reset, normal start, and new setpoint authorization.
4. **Make freshness explicit:** distinguish a successful register write, the next polled drive status, and physical shaft speed. Avoid asserting `is_at_speed` merely from a matching register or stale state.
5. **Freeze only a justified test:** if maintainers choose a candidate contract, test a pure software Modbus mock first (zero/negative/nonfinite/boundary/retained-setpoint/fault cases), using only the qualified local self-hosted runner when access and isolation are established. No hosted runner, no live spindle or personnel-exposed test. A mock does not establish physical safety.

## Adversarial paper scenarios — PUBLIC / UNSCORED
A. A UI sets `run=1` but leaves frequency at 0 after reconnect. Which Modbus write does this source attempt, and which OEM condition determines actual motion?
B. A signed spindle command becomes `-10`. Does `fabs` imply reverse direction, or can RUN use a retained setpoint?
C. A fieldbus input briefly becomes NaN. Why is casting to `uint16_t` not a reliable fail-safe?
D. A technician changes F0.02 resolution. Which assumptions about quantization, status matching and allowed upper bound must be revisited?
E. The drive reports running frequency matching the request. Does that prove fresh setpoint acceptance, actual standstill, or an independent protective stop? (No.)

## Machine-safety boundary and status
Ordinary LinuxCNC/HAL/Modbus is **normal control and diagnostics only**. A corrected RUN/setpoint implementation is not STO, guard locking, personnel protection, hydraulic holding or maintenance energy isolation. The selected independent safety logic and physical final elements must prove the hazard-specific safe state. **TEST-CONFIRMED: none.** Selected OpenPressBrake PI500 use, drive configuration, physical stopping and independent evaluator: **UNKNOWN/NOT RUN**. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation.

No workflow, build, simulator, test, hardware operation or compute used for this source audit. No upstream issue/PR or code patch submitted.
