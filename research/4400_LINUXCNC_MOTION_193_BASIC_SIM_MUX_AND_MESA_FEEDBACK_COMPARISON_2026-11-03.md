# MOTION-193 — two simulation feedback models and Mesa stepgen comparison (2026-11-03)

## Scope / pinned provenance
LinuxCNC upstream **v2.9.10**: [core_sim.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/core_sim.hal), [basic_sim.tcl](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/basic_sim.tcl), [sim_lib.tcl](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/sim_lib.tcl), [Mesa hm2-stepper-eth.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_interface/mesa/hm2-stepper/hm2-stepper-eth.hal). Cross-check prior [MOTION-192](4400_LINUXCNC_MOTION_192_AXIS_SIM_HAL_FEEDBACK_PROVENANCE_2026-11-03.md) and [MESA-177](4400_LINUXCNC_MESA_177_7I96S_UPSTREAM_HAL_INI_ORDER_AUDIT_2026-11-03.md). SOURCE-CONFIRMED for file contents/call graph; no runtime experiment or hardware.

## Material new distinction: basic_sim is NOT the same as core_sim.hal
MOTION-192's AXIS `core_sim.hal` wires `joint.N.motor-pos-cmd` directly to `joint.N.motor-pos-fb`. The **alternate** `basic_sim.tcl` sources `sim_lib.tcl`, calls `core_sim(axes, joints, servo_period, base_period, emcmot)`, and optionally adds joint differentiators, simulated home switches, manual tool change, and spindle simulation. It does **not** load the literal `core_sim.hal` file.

The Tcl `core_sim` procedure creates one `pid` and one `mux2` per joint, scheduled **after** motion-command-handler and motion-controller. PID is explicitly configured as pass-through (`FF0=1`, `Pgain=Igain=Dgain=FF1=FF2=0`). `joint.N.motor-pos-cmd -> JN_pid.command -> JN_pid.output -> JN_mux.in1`; `JN_mux.out -> joint.N.motor-pos-fb`, and the same mux output is fed back into `JN_mux.in0`. `motion.motion-enabled` selects the mux. This emulates a held feedback position when motion is disabled; it is still **synthetic**, with no independent motor, load, encoder or disturbance model. The source comment calls it a sample-hold to emulate encoder position when power is not applied. This is a different feedback *topology* from direct loopback, not a physical encoder.

**Scheduling caveat:** the motion controller runs before PID and mux in the same servo thread. Its sampled feedback is therefore produced by the prior pass through these later functions, not necessarily the newest command in that same iteration. The precise numeric one-cycle phase relation and behavior at enable transitions require an executable trace. Do not infer physical following error or accuracy from either simulated topology.

`make_ddts` differentiates `JN:pos-fb` (mux output), unlike MOTION-192's `core_sim.hal` derivatives of the directly looped commanded position. `simulated_home` derives home switch state from the same synthetic `JN:pos-fb`. `sim_spindle` uses `limit2`, `lowpass`, `near` and `sim_spindle` for a separate modeled spindle path, not measured spindle hardware.

## Mesa step-generator third case
The pinned bundled `hm2-stepper-eth.hal` config wires `joint.N.motor-pos-cmd -> hm2_*.stepgen.N.position-cmd` and `hm2_*.stepgen.N.position-fb -> joint.N.motor-pos-fb`. In its 7i96S INI example the board config sets `num_encoders=0`: **step-generator feedback is not an external shaft encoder**. Thread order: hm2.read -> motion-command-handler -> motion-controller -> hm2.write -> estop-latch. Unlike Tcl simulation, this path involves a hardware-facing HostMot2 driver; unlike encoder feedback, it does not independently observe load position. The upstream file is an example, not verified PNCconf output.

## Comparison and implementation consequence
| Configuration | Feedback origin | Independent plant observation? | What can be learned |
|---|---|---|---|
| AXIS core_sim.hal | Command directly wired to feedback | No | Interpreter/planner commanded geometry, not machine following |
| Tcl basic_sim / sim_lib core_sim | PID FF0 pass-through, motion-enabled mux sample/hold | No | Thread order, enable/hold transitions, synthetic feedback phase |
| Mesa hm2 stepgen example | HostMot2 stepgen position-fb | No external encoder in cited INI | Stepgen state / HAL timing, not lost steps or mechanics |
| Proposed encoder-backed machine | Physical encoder sampled via appropriate driver | Potentially yes, if sensor mounted appropriately | Measured encoder motion; still not independent proof of tool/workpiece geometry |

A `joint.N.f-error` comparison is meaningful only relative to the actual feedback source. A low following-error value with synthetic feedback or stepgen-internal feedback cannot validate mechanical trajectory fidelity.

## Reproducible disconnected verification contract (NOT RUN)
1. Pin LinuxCNC v2.9.10 and record commit SHA/build, INI, HAL expansion and `halcmd show thread` ordering. Do not use a live machine.
2. In separate simulation configs, run identical short G61, G64 P-only, G64 P/Q0 and G64 bare geometry; capture canonical `EMC_TRAJ_LINEAR_MOVE` message count separately from servo `joint.N.motor-pos-cmd` traces. A count difference is **not** automatically a feedback error.
3. For direct loopback, record `motor-pos-cmd`, `motor-pos-fb`, `f-error`, motion enable and servo cycle counter.
4. For Tcl basic_sim, record `JN_pid.output`, `JN_mux.sel/in0/in1/out` and motion enable in the same realtime sampler. Freeze prediction: disabled mux selects held `in0`; enabled selects PID pass-through `in1`; command-to-feedback may be phase-shifted due to addf order. Verify numeric timing rather than assuming it.
5. Toggle simulated enable without machine outputs. Determine whether the feedback holds the last value and whether the controller rejects a following-error transition. Preserve both success and failure traces.
6. Do **not** substitute stepgen feedback for an encoder in a fault-injection exercise. A meaningful physical-position divergence oracle needs a separate plant state and sensor channel, with a documented model and no energized hardware.
7. Capture raw HAL thread order, timestamps, units, source revision, NGC and observed status; distinguish source prediction from TEST-CONFIRMED evidence. Compare G64 canonical joining with upstream interpreter fixture only after verifying its actual scope.

## Evidence/gates and next research
This source audit resolves the alternate simulation implementation and exposes a practical one-cycle observation issue. It does **not** demonstrate actual execution, quantified servo lag, or independent plant tracking. No new compute; MOTION-144 remains blocked pending independently verified isolation on permitted `[self-hosted, openpressbrake]`; never use GitHub-hosted Actions. Independent personnel safety, closed graduated levels and blind evaluation separation remain unchanged.

Next: locate a real **encoder-backed** Mesa servo HAL/INI pair and trace encoder.read -> PID -> output write, including how following-error limits depend on the feedback channel; alternatively rotate to practical DXF/plasma/press-brake CAM if the source path is exhausted.
