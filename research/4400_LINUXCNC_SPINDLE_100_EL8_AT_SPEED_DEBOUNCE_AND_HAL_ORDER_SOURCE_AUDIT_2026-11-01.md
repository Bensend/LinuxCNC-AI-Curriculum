# 4000-LC-SPINDLE-100 — Real EL8 EtherCAT spindle: at-speed integrator and servo-thread ordering

**2026-11-01 | 3100 mill / 3200 spindle transfer | NON-GRADUATED.** SOURCE-CONFIRMED conditional implementation; field behavior UNKNOWN; TEST-CONFIRMED none. This is a *different* question from [ETHERCAT-51](4400_LINUXCNC_ETHERCAT_51_CNC3_VS_2026_CSP_CONFIG_HOMING_DC_SOURCE_AUDIT_2026-10-31.md), which established generic PDO/motion ordering, and [ETHERCAT-52](4400_LINUXCNC_ETHERCAT_52_CIA402_FAULT_HOMED_FEEDBACK_SOURCE_AUDIT_2026-10-31.md), which established CiA402 fault and homing status semantics.

## Immutable provenance

- Public example **marcoreps/linuxcnc_leadshine_EL8** at commit [1540a7131c1d512997ba2824c88dcd24d4177538](https://github.com/marcoreps/linuxcnc_leadshine_EL8/commit/1540a7131c1d512997ba2824c88dcd24d4177538), 2024-10-04: [EL8_machine.hal](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.hal) blob `32e880852f61820796071b3e219bda0bde42dac1`; [EL8_machine.ini](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.ini) blob `494778fd8dea2638cf3e94c35cfe408fafc5fc19`; [ethercat-conf.xml](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/ethercat-conf.xml) blob `047bf8c035a54449ba6baf22b5bc9bdd82dc69d6`. Public source is **not proof of an installed, commissioned machine**.
- LinuxCNC stable v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`: [dbounce.comp](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/dbounce.comp) blob `e765fb3aa2056da4eefd78015a6272da00f651e0`; [near.comp](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/near.comp) blob `531c21b0c71c35163ba275da83f0a87c97dc5544`. The public HAL is from 2024; these pinned 2026 component implementations are a *conditional comparator*, not evidence of the installed 2024 binary.
- [CiA402 maintained documentation](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/cia402.md), revision `56515f4aac313551346289d9c227193f50e9602a` (2026-10-29), describes `velocity-fb` as scaled 0x606C and explicitly cautions that this C port only ships with linuxcnc-ethercat since 1.47.0. **Do not assume this 2026 component was installed in 2024.**

## Full HAL call flow and data authority

The HAL's `[EMCMOT] SERVO_PERIOD = 1000000` requests a nominal **1 ms** servo thread. Its actual `addf` sequence is:

```text
servospindle.0 → mult2.0 → mult2.1 → mult2.2
→ dbounce.0 → near.0 → conv-s32-float.5/.6
→ lcec.read-all → cia402.0..4.read-all
→ motion-command-handler → motion-controller
→ cia402.0..4.write-all → lcec.write-all
```

For spindle speed, `spindle.0.speed-out → mult2.1 (×100) → cia402.4.velocity-cmd`; drive 0x606C → `lcec.0.7.actual-velocity → cia402.4.drv-actual-velocity`; `cia402.4.velocity-fb → mult2.2 (×0.01) → spindle.0.speed-in`. `near.0` compares command and scaled feedback; `dbounce.0.out → spindle.0.at-speed`.

**Ordering consequence:** `mult2.2` executes *before* this cycle's `lcec.read-all` and `cia402.4.read-all`, so it uses the previous published `cia402.4.velocity-fb`; `near.0` executes after `mult2.2` but before the new bus read, so it cannot see the new cycle's feedback. `dbounce.0` executes **before** `near.0`, consuming the previously published `near.0.out`. The feedback comparison and debounce therefore include at least one-cycle staged state; actual wall-clock delay depends on thread scheduling, EtherCAT exchange and installed component behavior. Do not call this a measured latency.

## `near` is a tolerance comparison, not drive-ready confirmation

The HAL sets `near.0.scale=1.02`, leaving default `difference=0`. Stable `near.comp` returns true if (for positive command) `command/1.02 <= feedback <= command*1.02`, or if exact equality satisfies `abs(command-feedback)<=0`. Thus positive 1000 RPM command nominally accepts approximately **980.392–1020 RPM**; negative commands are sign-normalized by the component. This is a computed source example, not a tachometer or physical-speed observation.

**Zero-command case:** when both speed command and reported speed are zero, `near.0.out=1`. The HAL does not additionally require `spindle.0.on`, `cia402.4.stat-op-enabled`, a fresh EtherCAT WKC or actual nonzero motion before allowing `at-speed` to rise. Therefore a zero/zero *reported* state can eventually produce `spindle.0.at-speed=1` even while stopped. The actual G-code/Task use of `at-speed` is a separate consumer contract; no claim that motion starts or a physical spindle spins follows from this alone.

## `dbounce` is a bidirectional saturating integrator, not a consecutive-true timer

The HAL sets `dbounce.0.delay=10000`. Stable `dbounce.comp::FUNCTION(_)` increments `state` once per true input call until `state>=delay`, then sets output true. False input decrements `state` until zero, then clears output. **It does not reset the counter when the input toggles.**

At nominal 1 ms, from state 0 with a continuously true near input, the first 10,000 calls charge the state and the **10,001st true call** sets `at-speed=1`: approximately **10 seconds**, not 10 milliseconds. After saturation, continuously false input requires 10,000 calls to discharge and the **10,001st false call** to clear output: approximately another **10 seconds**. Alternating true/false samples can preserve the state indefinitely, and intermittent good samples can accumulate toward the threshold. One stale `near` cycle is negligible compared with this deliberately large configured integrator, but the latter must be understood before using this signal as a spindle-ready gate.

**Counterexample:** at nominal t=0, speed command and feedback both 0. If they remain 0 for >10 s, `at-speed` can assert. After it asserts, an abrupt speed mismatch need not clear `at-speed` for ~10 s of continuously bad comparisons. This is a **source-derived conditional** behavior of the public HAL and stable components; it is not a field incident or a functional-safety assertion.

## Reproduction boundary / engineering implications

In an isolated HAL-only environment, record the `near` output, `dbounce.state` (internal; expose only in a test clone), `dbounce.out`, command, feedback, `spindle.0.on`, `lcec.0.wkc-state`, and `cia402.4.stat-op-enabled` on the same servo-tick timeline. Compare a clean 10000+1 true/false sequence and an alternating sequence. Keep the actual 2024 installed component and drive firmware **UNKNOWN** until independently established. A proposed design should distinguish **speed agreement**, **spindle enable/ready**, **bus freshness**, and **independent personnel safety** rather than equating any one signal with the others.

**No runtime:** no LinuxCNC/HAL build, simulation, physical machine, evaluator or Actions job. All numeric cases are source arithmetic, NOT RUN.
