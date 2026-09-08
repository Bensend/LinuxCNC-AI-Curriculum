# C05-029 single-row realtime observation redesign

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: SOURCE-CONFIRMED observation-harness redesign after retirement of the split-FIFO family.

## Why one FIFO is sufficient

Pinned `src/hal/components/sampler.c` stores one `hal_refs_u pins[HAL_STREAM_MAX_PINS]` array per sampler and, inside the realtime `sample()` function, reads every configured pin into one local `data[]` array before one `hal_stream_write()` call. Therefore the configured fields in one sampler record are captured by one invocation of `sampler.0` in the servo thread and transported as one FIFO element.

Pinned `src/hal/hal.h` defines `HAL_STREAM_MAX_PINS` as **21**. `halsampler -t` prints `sampler.N.sample-num` as an additional output column; the sample number is not one of the configured data pins. Current LinuxCNC sampler documentation independently describes one configured pin per `cfg` character and one FIFO/function per sampler.

## Frozen-gate field inventory

The C05-029 behavioral gates need the following primitive or directly observed quantities in the same servo-cycle row. The three arithmetic residuals do not require separate realtime pins because each is a deterministic function of primitives already present in that exact row.

| Data pin | Type | Field | Gate use |
|---:|---|---|---|
| 0 | float | shared/base command | provenance/context |
| 1 | float | true A | G disagreement arithmetic |
| 2 | float | true B | D/E/F and candidate equations |
| 3 | float | normal-B candidate | C transform integrity |
| 4 | float | scaled-B candidate | C/E transform integrity |
| 5 | float | jumped-B candidate | C/F transform integrity |
| 6 | float | measured B | D/E/F/G |
| 7 | float | measured disagreement | G |
| 8 | float | cross correction | G |
| 9 | float | command A | context/controller state |
| 10 | float | command B | G PID-B arithmetic |
| 11 | float | PID-A output | context/controller state |
| 12 | float | PID-B output | context/controller state |
| 13 | float | PID-B error | G |
| 14 | float | phase | B/C phase qualification |
| 15 | float | plant-A gain | C |
| 16 | float | plant-B gain | C |
| 17 | float | Kc | C/G |
| 18 | bit | mux sel0 | C/F actual selector edge |
| 19 | bit | mux sel1 | C/F actual selector edge |

This uses **20 configured pins**, leaving one pin of headroom under the pinned limit. Sample number is supplied by `halsampler -t`.

## Residual derivation from the atomic row

The frozen Gate-G residual thresholds remain `1e-9`. The analyzer calculates, from fields in the same single FIFO record:

```text
residual_D = disagreement - (measured_B - true_A)
residual_C = correction - Kc * disagreement
residual_E = pidB_error - (command_B - measured_B)
```

Sampling those three residual-helper outputs separately would consume three additional pins but add no independent timing information: the operands are already atomically captured in the row and the residual equations are exactly the frozen Gate-G equations. Computing them offline therefore removes redundant transport fields without changing a gate, threshold, control parameter, phase, transform, or behavioral prediction.

The existing realtime residual helper components may remain in the HAL graph, but their outputs are not required in the transport. Their presence or absence cannot alter the sampled primitive signals because they are downstream check-only calculations.

## Source/call-flow consequence

For the decisive observation path:

```text
... plant -> transforms -> mux -> disagreement/correction -> PID -> sampler.0
                                                        |
                                                        v
                    one sample() invocation reads pins 0..19
                                                        |
                                                        v
                          one hal_stream_write() FIFO record
                                                        |
                                                        v
                              one concurrent halsampler reader
```

This removes the previous cross-FIFO equality requirement entirely. There is no second realtime FIFO, no second userspace reader, no exact cross-stream join, and no terminal-set synchronization problem.

## Evidence and safety boundary

This redesign improves measurement integrity only. It does not make the toy plant physical metrology, does not prove a physical sensor fault mechanism, and does not make ordinary HAL/PID logic safety-rated.

## Implementation constraints

- Preserve frozen C05-029 Gates A-H and every behavioral value unchanged.
- Keep all selector transitions and transition rows; do not relabel phases.
- Preserve the complete single raw trace before analyzer failure can terminate the wrapper.
- Require zero sampler overruns and strictly increasing sample numbers.
- Do not interpolate, delete rows, or perform nearest-neighbor matching.
