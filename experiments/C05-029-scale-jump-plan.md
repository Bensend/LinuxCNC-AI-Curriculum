# C05-029 — wrong-scale and jump/offset B-feedback faults

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite accepted result: `results/C05-028-attempt-2-accepted.md`

## Objective

Reuse C05-028's verified toy-plant/measurement observation contract to demonstrate two additional sensor-path faults without changing the physical/toy plant:

1. **wrong scale:** measured B continuously tracks true B with an incorrect multiplicative gain;
2. **jump/offset:** measured B changes by a deliberate additive offset while true B does not undergo the same discontinuity.

This experiment tests measurement/control semantics. It does not choose final fault/stop policy.

## Source-grounded transform model

Pinned `scale.comp` computes exactly:

```text
out = in * gain + offset
```

and performs no plausibility diagnosis. The fixture will continuously calculate three B-measurement candidates:

```text
normal_B = true_B
scaled_B = 1.20 * true_B
jumped_B = true_B + 0.50 in
```

A `mux4` selects the presented B measurement. Selection is fault injection, not fault diagnosis.

## Frozen prediction

With the toy plants and control law otherwise unchanged:

- normal mode will preserve `measured_B == true_B`;
- scale mode will preserve `measured_B == 1.20*true_B`, causing measurement error that varies with true B;
- jump mode will preserve `measured_B == true_B + 0.50 in`;
- at the actual realtime selector edge into jump mode, the measurement delta relative to the preceding sample will contain an approximately `+0.50 in` discontinuity that is absent from the independently sampled true-B delta;
- disagreement/correction/PID-B arithmetic will remain functions of the **presented measured B**, not hidden toy true B;
- returning to normal selection will restore exact fixture identity.

## Frozen realtime order

```text
motion-command-handler
motion-controller
plant-A integ
plant-B integ
normal/scale/jump B transforms
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

As in C05-028, plant updates use prior-cycle PID effort; the current row contains the newly updated toy state, its transformed/selected measurement, and controller arithmetic calculated from that selected measurement.

## Frozen configuration

- inherited generic `XYZY` motion fixture;
- servo period `1 ms`;
- PID A/B: `Pgain=4`, `Igain=0`, `Dgain=0`, `error-previous-target=false`, enabled;
- toy plant A/B gains: `1.0` throughout all scored phases;
- `Kc=0.5` throughout all scored phases;
- normal candidate: gain `1.0`, offset `0.0`;
- scaled candidate: gain `1.20`, offset `0.0`;
- jumped candidate: gain `1.0`, offset `+0.50 in`;
- selector and transform configuration are sampled in realtime.

No behavioral gate, threshold, gain, offset, or phase duration may be retuned after observing the first result. A genuine harness correction must retain this plan and the invalid attempt.

## Frozen phases

Selector/configuration changes are published only while `phase=0` (transition/unscored), with scored phase publication delayed until multiple servo cycles after configuration settles.

- **phase 1 — normal baseline:** select normal candidate.
- **phase 2 — wrong scale:** select `1.20*true_B` candidate.
- **phase 3 — normal recovery after scale:** select normal candidate.
- **phase 4 — jump/offset:** select `true_B+0.50` candidate.
- **phase 5 — final normal recovery:** select normal candidate.

The raw trace must retain transition rows so the actual selector edge into jump mode can be analyzed without pretending a userspace phase publication is atomic.

## Required same-cycle sample fields

At minimum:

- sample number;
- shared/base command;
- true A;
- true B;
- normal-B candidate;
- scaled-B candidate;
- jumped-B candidate;
- measured B;
- mux selector bits / decoded mode;
- measured disagreement;
- cross-correction;
- command A;
- command B;
- PID-A output;
- PID-B output;
- PID-B error;
- phase;
- plant A/B gains;
- `Kc`;
- scale gain and jump offset or equivalent fixed configuration evidence;
- disagreement residual `disagreement-(measured_B-true_A)`;
- correction residual `correction-Kc*disagreement`;
- PID-B error residual `pidB_error-(command_B-measured_B)`.

## Gates A–H

### Gate A — provenance and topology

PASS only if the run proves the pinned LinuxCNC tree and prints the generated realtime function order showing plant -> transforms -> mux -> controller -> sampler staging.

### Gate B — evidence validity

PASS only if:

- complete raw realtime trace is durably retained even if analysis fails;
- at least `4500` parseable rows exist;
- sample numbers are strictly increasing;
- sampler overruns are zero;
- each scored phase has at least `500` rows;
- transition rows surrounding the actual jump-selector edge are retained.

### Gate C — scored configuration integrity

For every scored phase row used by behavioral gates:

- `Kc == 0.5`;
- plant A gain == `1.0`;
- plant B gain == `1.0`;
- normal candidate configuration is gain `1.0`, offset `0.0`;
- scaled candidate configuration is gain `1.20`, offset `0.0`;
- jumped candidate configuration is gain `1.0`, offset `+0.50`;
- phase 1/3/5 select normal;
- phase 2 selects scaled;
- phase 4 selects jumped.

Any scored configuration drift is **HARNESS INVALID**, not behavioral evidence.

### Gate D — normal-path identity

In the final 500 rows of phases 1, 3, and 5 independently:

`max(abs(measured_B - true_B)) <= 1e-9`.

### Gate E — deterministic wrong-scale measurement

Across at least 500 phase-2 rows:

- `max(abs(measured_B - 1.20*true_B)) <= 1e-9`;
- true-B span `>= 0.10 in`;
- maximum `abs(measured_B-true_B) >= 0.10 in`.

The second and third requirements prevent a trivial near-zero-state pass.

### Gate F — deterministic jump/offset and actual selector-edge discontinuity

Across at least 500 phase-4 rows:

`max(abs((measured_B - true_B) - 0.50)) <= 1e-9`.

Additionally, find the first raw realtime row whose decoded mux mode changes from non-jump to jump during the phase-0 transition immediately preceding phase 4. With `prev` as the immediately preceding sample and `edge` as that first jump-selected sample, require:

```text
abs(((edge.measured_B - prev.measured_B)
   - (edge.true_B - prev.true_B)) - 0.50) <= 1e-9
```

and require the two sample numbers to be consecutive. This proves the extra measurement discontinuity belongs to the selected sensor transform, not to the independently sampled toy-state increment.

### Gate G — controller arithmetic follows measured feedback

Across at least 500 rows in each fault phase (2 and 4):

- disagreement residual magnitude `<= 1e-9`;
- correction residual magnitude `<= 1e-9`;
- PID-B error residual magnitude `<= 1e-9`.

This establishes arithmetic dependence on measured B only; it does not establish that the correction is physically appropriate.

### Gate H — interpretation boundary and cleanup

PASS only if retained result text explicitly states:

```text
wrong measured scale != proven physical scale change
measurement jump != proven physical position jump
controller reaction to corrupted measurement != proof plant needed correction
fixture true state != physical metrology truth
ordinary HAL/PID logic != safety-rated sensor-fault handling
```

and bounded LinuxCNC/halsampler cleanup is performed.

## Acceptance rule

Workflow success alone is insufficient. Reconcile inner exit, raw trace, process logs, selector edge, and every unchanged frozen gate. A HARNESS VALID behavioral failure must be preserved rather than retuned after observation.

## Expected C05 use

If C05-029 is accepted, the module will have deterministic freeze, wrong-scale, and jump/offset evidence under one source-grounded observation model. Remaining graduation work will then be the already-frozen adversarial exam, fresh-AI novel-scenario handoff, and promotion/counterfactual audit unless those checks expose a blocking gap.
