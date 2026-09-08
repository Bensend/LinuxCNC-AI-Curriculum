# C05-028 — frozen B-feedback versus independently sampled toy plant state

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Demonstrate, in one deterministic realtime fixture, that a feedback value presented to PID/cross-coupling logic can freeze while an independently sampled toy plant state continues changing, and prove that the controller reacts to the frozen **measurement** rather than possessing hidden knowledge of the toy plant state.

This experiment isolates measurement semantics. It does not decide final fault/stop policy.

## Frozen prediction

With A/B toy plants symmetric and `Kc=0.5`, normal B measurement should initially equal true B. After transition-only capture of the current true-B value and selection of that constant as B measured feedback, realtime samples should show:

1. measured B remains equal to the published freeze value;
2. true B continues changing;
3. true-B versus measured-B separation becomes material;
4. disagreement/correction/PID-B error arithmetic remains consistent with **measured** B;
5. restoring the normal sensor path makes measured B equal true B again.

## Frozen realtime order

```text
motion-command-handler
motion-controller
plant-A integ
plant-B integ
sensor-B mux4
disagreement sum2
cross-correction scale
command-A sum2
command-B sum2
PID-A
PID-B
residual helpers
sampler
```

Plant updates therefore use the prior-cycle PID output; sensor/controller/sample state in one row belongs to the newly updated plant state of the current cycle.

## Frozen phases

- **phase 0 — transition/unscored:** configuration changes and userspace freeze capture only. No behavioral gate may use phase-0 rows.
- **phase 1 — normal sensor:** B mux selects true B directly; plants symmetric; `Kc=0.5`.
- **phase 2 — frozen B measurement:** B mux selects constant `freeze_value` captured during preceding phase 0; all plant/control gains unchanged.
- **phase 3 — measurement recovery:** B mux returns to true B; all plant/control gains unchanged.

The freeze capture read/write is explicitly not an atomic same-cycle oracle. Publication of phase 2 occurs only after the constant has been written, mux selection changed, and multiple servo periods have elapsed.

## Frozen configuration

- motion kinematics: inherited generic `XYZY` fixture;
- servo period: `1 ms`;
- shared Y motion command drives both local loop commands;
- PID A/B: `Pgain=4`, `Igain=0`, `Dgain=0`, `error-previous-target=false`, enabled;
- plant A/B `integ.gain=1.0` throughout scored phases;
- `Kc=0.5` throughout scored phases;
- sensor B mux input 0 = true B;
- sensor B mux input 1 = `freeze_value`;
- phase 1/3 selector = normal input 0;
- phase 2 selector = frozen input 1.

No gate or threshold may be retuned after observing the first result. A harness defect may be corrected only if the frozen behavioral requirements remain unchanged and the invalid attempt is retained.

## Required realtime sample fields

At minimum preserve in the same realtime record:

- sample number;
- shared base command;
- true A;
- true B;
- measured B;
- freeze value;
- sensor selector/mode;
- measured disagreement;
- correction;
- command A;
- command B;
- PID-A output;
- PID-B output;
- PID-B error;
- phase;
- plant A gain;
- plant B gain;
- `Kc`;
- arithmetic residual proving disagreement is derived from measured B;
- arithmetic residual proving correction is `Kc * disagreement`.

## Gates A–H

### Gate A — provenance and topology

PASS only if the lab proves it is executing the pinned LinuxCNC tree and prints the generated realtime function order showing plant -> sensor -> controller -> sampler staging.

### Gate B — evidence validity

PASS only if:

- raw realtime trace is retained even if analysis fails;
- at least 2500 parseable rows exist;
- sample numbers are strictly increasing;
- sampler overruns are zero;
- each decisive phase has at least 500 rows.

### Gate C — scored configuration integrity

For every phase-1/2/3 row used by behavioral gates:

- `Kc == 0.5`;
- plant A gain == `1.0`;
- plant B gain == `1.0`;
- phase 1 and 3 select normal true-B input;
- phase 2 selects frozen input;
- phase-2 `freeze_value` is constant to `1e-12` across scored rows.

Any drift is HARNESS INVALID, not behavioral evidence.

### Gate D — normal measurement truth within the fixture

In the final 500 phase-1 rows:

`max(abs(measured_B - true_B)) <= 1e-9`.

This establishes fixture behavior only; it is not a physical truth claim.

### Gate E — frozen measurement while toy plant continues moving

Across phase 2:

- `max(abs(measured_B - freeze_value)) <= 1e-9`;
- measured-B span `<= 1e-9`;
- true-B span `>= 0.10 in`;
- maximum `abs(true_B - measured_B) >= 0.10 in`.

### Gate F — controller arithmetic uses measured feedback

Across at least 500 phase-2 rows:

- disagreement residual for `disagreement - (measured_B - true_A)` has magnitude `<= 1e-9`;
- correction residual for `correction - Kc*disagreement` has magnitude `<= 1e-9`;
- PID-B `error` matches `command_B - measured_B` within `1e-9` under frozen `error-previous-target=false` configuration.

The gate does not require or imply that the resulting correction is physically appropriate.

### Gate G — measurement-path recovery

In the final 500 phase-3 rows:

`max(abs(measured_B - true_B)) <= 1e-9`.

No requirement is placed on physical/plant convergence beyond this sensor-path identity.

### Gate H — interpretation boundary and cleanup

PASS only if retained result text explicitly states:

```text
fixture true state != physical metrology truth
frozen measured feedback != proven frozen actuator
controller reaction to bad measurement != proof plant needed correction
ordinary HAL/PID logic != safety-rated sensor fault handling
```

and the lab performs bounded LinuxCNC/halsampler cleanup.

## Acceptance rule

Workflow success alone is not acceptance. Reconcile raw trace, stdout/stderr, inner exit and each frozen gate. If a valid run fails Gate E because true B does not move enough, that is behavioral evidence under this frozen design; do not silently increase gains or thresholds after seeing it.

## Follow-on scope

After C05-028 is validly reconciled, C05 still needs scale and jump/offset transformations before graduation. Those should reuse the same true-state/measurement separation rather than adding final stop policy prematurely.
