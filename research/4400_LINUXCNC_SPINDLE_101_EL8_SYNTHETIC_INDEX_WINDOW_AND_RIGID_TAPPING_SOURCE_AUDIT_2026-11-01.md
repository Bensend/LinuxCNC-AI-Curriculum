# 4000-LC-SPINDLE-101 — Real EL8 configuration: software-synthesized spindle index can be missed by sampling

**2026-11-01 | 3200 lathe/mill rigid-tapping transfer | NON-GRADUATED.** SOURCE-CONFIRMED conditional modulo/index arithmetic, TEST-CONFIRMED none. Extends [SPINDLE-100](4400_LINUXCNC_SPINDLE_100_EL8_AT_SPEED_DEBOUNCE_AND_HAL_ORDER_SOURCE_AUDIT_2026-11-01.md) with a separate synchronization mechanism; does not repeat [ETHERCAT-52](4400_LINUXCNC_ETHERCAT_52_CIA402_FAULT_HOMED_FEEDBACK_SOURCE_AUDIT_2026-10-31.md) homing and fault state analysis.

## Immutable primary sources

- Public [marcoreps/linuxcnc_leadshine_EL8 `servospindle.comp`](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/servospindle.comp), revision `1540a7131c1d512997ba2824c88dcd24d4177538` (2024-10-04), blob `b3bc230929d6b2af2410326bb0859c75a80a9b4f`. Read `FUNCTION(_)` in full.
- Same revision [`EL8_machine.hal`](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.hal), blob `32e880852f61820796071b3e219bda0bde42dac1`; [`EL8_machine.ini`](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.ini), blob `494778fd8dea2638cf3e94c35cfe408fafc5fc19`; [EtherCAT XML](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/ethercat-conf.xml), blob `047bf8c035a54449ba6baf22b5bc9bdd82dc69d6`.
- The 2024 HAL uses a component called `cia402`. The inspected current maintained [2026 C port](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/cia402.c) is **not assumed** to have been installed in the 2024 machine.

## Position source and synthesized index

The EtherCAT spindle's 0x6064 actual position enters `lcec.0.7.actual-position → conv-s32-float.6 → mult2.0` (factor 1) → `servospindle.0.pos-input`. Its `pos-output` goes to `spindle.0.revs`. The `spindle.0.index-enable` pin is bidirectionally connected to `servospindle.0.index-enable`. The component's own `index` pin is **not** connected to an independent hardware index signal in the inspected HAL.

The component's exact core logic is equivalent to:

```c
new_counts = pos_input;                   // uint32_t, from float
index = (new_counts % 100000 <= 1000);   // 1001 integer count values
if (index_enable && index) {
    offset = pos_input;
    index_enable = 0;
}
pos_output = (pos_input - offset) / 100000;
```

It is a **software-generated 1%-revolution-wide window**, not a physical index latch. With the assumed 100,000 increments/revolution, the inclusive window is 0..1000, 1001 possible integer counts, not a one-tick index event. Its correctness depends on the actual encoder scale and drive 0x6064 convention, both unverified for an installed unit. The code also casts a float to unsigned integer; negative or out-of-range values need independent C-semantics scrutiny before relying on the modulo result.

## Deterministic missed-window counterexample

The HAL's requested servo period is 1 ms. With 100,000 increments/rev and a nominal spindle speed of **6,000 RPM = 100 rev/s**, the sampled count advances by **10,000 counts per 1 ms**. If the sample phase begins at 5,000 counts modulo 100,000, observed phases are:

```text
5000, 15000, 25000, 35000, 45000,
55000, 65000, 75000, 85000, 95000,
5000, ...
```

**None** lies in the inclusive 0..1000 window, so the component never sees `index=1` and cannot clear an asserted `index-enable` through this path. This is a **mathematical counterexample**, not an observed hang on the physical machine. A different speed/phase may occasionally hit the window; an actual motor is not guaranteed to hold exactly 6,000 RPM or perfect sample phase, so do not infer permanent failure in the field.

At 1,000 RPM, nominal advance is ~1,666.67 counts/cycle, already wider than the 1,001-count acceptance window; individual revolutions can be missed even without an exact persistent phase lock. At slower speed, repeated samples inside the window may keep `index=1` for several servo cycles. No hardware capture or interpolation is implemented in this component.

## Scheduling makes the observed sample older

The public HAL schedules `servospindle.0` **before** `mult2.0`, `conv-s32-float.6`, and `lcec.read-all`, so the index decision uses the previous published spindle-position signal rather than a fresh bus sample from the same cycle. That extra age does not remove the missed-window counterexample; it changes phase/latency. The exact runtime pipeline depends on installed HAL components and bus exchange.

The component's `derived-rpm` output is computed as `(pos_input - previous_pos) * 1` without converting from increments-per-servo-cycle to RPM. It is **not wired** in the inspected HAL and should not be interpreted as measured RPM. The actual spindle speed-in path instead uses 0x606C via CiA402, as traced in SPINDLE-100.

## Rigid-tapping integration and falsifiers

The same HAL connects `servospindle.0.pos-output → spindle.0.revs` and the bidirectional `index-enable` handshake. Those signals matter to spindle-synchronized LinuxCNC motion, but this inspection **does not establish** that the sample window produces an actual G33/G76/G84 failure, that LinuxCNC lacks an alternative timeout, or that the drive encoder is correctly calibrated. Do not call a virtual modulo index an independent reference or a safety device.

A useful **disconnected** reproducer must feed the component a sequence of synthetic `pos-input` values with fixed 10,000-count steps and 5,000-count phase; assert `index-enable`; log `index`, `index-enable`, `offset`, `pos-output` for at least 20 cycles. Repeat with phase 0 and with a low-speed 200-count step to distinguish no index, one index, and multi-cycle high windows. The expected source-derived outcomes are predeclared here; **all remain NOT RUN**. Only positively qualified `[self-hosted, openpressbrake]` disconnected compute is authorized; never use hosted Actions or an operating machine for this investigation.

## Distinct engineering decision

For a production synchronized-spindle design, prefer an actual drive/encoder index capture or a verified crossing detector that cannot skip the phase boundary under the configured maximum sample increment. An index crossing algorithm must also explicitly handle wrap, reversal, direction, startup phase, and sample freshness. This is a **design recommendation**, not a claim that any particular replacement has been implemented or validated.

**Evidence:** SOURCE-CONFIRMED modulo/window/ordering; computed missed-window INFERENCE directly from code; physical installed encoder, firmware, behavior and safety authority UNKNOWN. No builds, tests, hardware, evaluator, or Actions compute.
