# C05 call flow — true toy plant state to faulted measured feedback

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **SOURCE-CONFIRMED design basis for C05-028**

## Purpose

C05 needs a deterministic separation between a simulated plant state and the feedback value presented to the controller. The fixture must make a sensor fault observable without silently treating the controller's feedback pin as physical truth.

## Realtime function order selected for C05-028

The first C05 lab will deliberately change the inherited C03/C04 ordering to:

```text
motion-command-handler
motion-controller
plant-A integ
plant-B integ
sensor-B mux4
measured disagreement
cross-coupling scale
command-A sum
command-B sum
PID-A
PID-B
sampler
```

Arithmetic residual helpers may run next to the arithmetic they verify, but they must execute before `sampler`.

## Why this order is source-grounded

Pinned `integ.comp` executes a discrete update when its realtime function is invoked:

```text
out <- out + gain * in * fperiod
```

subject to reset and limits. Therefore, when the plant functions run before PID in servo cycle `k`, they advance true plant state using the PID output retained from cycle `k-1`.

Pinned `mux4.comp` copies exactly one selected float input to its output when its function runs. It performs no plausibility check, diagnosis, latching, filtering or safety decision.

The HAL thread executes functions in the explicit `addf` order already established by the graduated HAL execution-model modules. Thus C05 can define an auditable discrete-time staging contract without inventing hidden scheduler semantics.

## Cycle-level state transition

Let:

- `uA[k-1]`, `uB[k-1]` be PID outputs retained from the prior servo cycle;
- `xA[k]`, `xB[k]` be updated toy plant states;
- `zB[k]` be the selected measured B feedback;
- `d[k] = zB[k] - xA[k]` be measured disagreement under the existing sign convention;
- `c[k] = Kc * d[k]` be cross-correction;
- `rA[k]`, `rB[k]` be corrected commands;
- `uA[k]`, `uB[k]` be newly calculated PID outputs.

Then one C05 servo cycle is intentionally:

```text
xA[k] = integA(xA[k-1], uA[k-1])
xB[k] = integB(xB[k-1], uB[k-1])

zB[k] = mux(sensor_mode,
             normal=xB[k],
             frozen=freeze_value,
             scaled=..., 
             jumped=...)

d[k] = zB[k] - xA[k]
c[k] = Kc * d[k]
rA[k], rB[k] = shared_motion_command adjusted by c[k]
uA[k] = PID_A(rA[k], xA[k])
uB[k] = PID_B(rB[k], zB[k])

sampler row k = {xA[k], xB[k], zB[k], d[k], c[k], rA[k], rB[k], uA[k], uB[k], mode, phase, ...}
```

The newly computed `uA[k]` and `uB[k]` affect plant state on the **next** cycle because the plant functions have already executed this cycle.

## Freeze-mode publication discipline

C05-028 will use a userspace capture only during **phase 0**, which is explicitly unscored:

1. publish phase 0;
2. read the current true-B signal;
3. write that value to a dedicated float `freeze_value` signal;
4. select the frozen mux input;
5. wait for the realtime chain to settle across multiple servo cycles;
6. only then publish decisive freeze phase 2.

The experiment does **not** claim that the userspace read/write itself was atomic or same-cycle. The decisive oracle is instead the subsequent realtime record showing simultaneously that:

- selected measured B equals the already-published `freeze_value`;
- measured B remains effectively constant across many realtime samples;
- independently sampled true B continues changing;
- the PID/cross-coupler respond to measured B, not to hidden true B.

This avoids the sequential-userspace-observation mistake exposed by C01.

## What `true_B` means here

`true_B` is **fixture truth**, not physical truth. It is the state variable of the deterministic `integ` toy plant and is independently sampled before the sensor transformation.

Therefore:

```text
toy true_B != real secondary encoder
            != metrology reference
            != proof of hydraulic/mechanical position
```

The fixture proves that a controller can be driven by a false measurement while another known simulation state differs. It does not establish how a real machine should obtain independent truth.

## Failure branch represented by C05-028

The selected sensor path can hold `zB` constant while `xB` continues moving. Because PID-B and the cross-coupler consume `zB`, their behavior can become increasingly inconsistent with the hidden toy plant state. The controller has no automatic knowledge that the mux-selected value is false unless separate diagnostic logic is added.

C05-028 intentionally stops there. Final fault thresholds, stop sequencing, redundant-sensor architecture and safety-rated anti-racking policy belong to later modules.

## Evidence classifications

- `integ` discrete update semantics: **SOURCE-CONFIRMED** at pinned revision.
- `mux4` selected-input copy semantics: **SOURCE-CONFIRMED** at pinned revision.
- explicit C05 `addf` order: will be **TEST-CONFIRMED** when the generated fixture and realtime trace are preserved.
- physical interpretation of a real failed encoder: **UNKNOWN / outside this software fixture** until hardware-specific evidence exists.
