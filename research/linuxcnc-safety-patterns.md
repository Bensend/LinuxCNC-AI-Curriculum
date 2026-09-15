# R-SAFE-01 — LinuxCNC Safety Practice: Authority, E-stop, Watchdog, Reset

Date: 2026-09-15

LinuxCNC source revision inspected: `d1a9d7d04cc274bfb5082caee6accc2489607418` (master, 2026-09-15).

Purpose: establish the first evidence-backed safety-course contract for what LinuxCNC software and HostMot2 watchdogs can legitimately do, and where independent machine-safety authority must begin. This is a public generic curriculum artifact, not a machine-specific safety design.

## Executive contract

The key separation is:

`operator/process request -> ordinary LinuxCNC control -> FPGA/field I/O fault containment -> independent safety-related control -> physical hazardous-energy control`

LinuxCNC may request motion, request a stop, latch ordinary faults, expose safety-system state to the HMI, and inhibit its own commands. HostMot2 can provide fast output fault containment when host servicing stops. None of those facts establishes a safety rating. Personnel-safety authority must therefore remain in an independently justified safety chain appropriate to the hazard.

A useful design test is: **if the LinuxCNC PC freezes, the HAL graph is wrong, Ethernet traffic is stale, or an ordinary FPGA output is wrong, what independent mechanism still prevents or removes hazardous motion/energy?** If the answer is "the same LinuxCNC/FPGA path," the architecture has not established an independent safety boundary.

## 1. `estop_latch` is explicitly software E-stop logic

### Evidence

**SOURCE-CONFIRMED** at `src/hal/components/estop_latch.comp` on the pinned revision:

- the component describes itself as a `Software ESTOP latch` and as part of a *simple software ESTOP chain*;
- it initializes faulted: `ok_out=false`, `fault_out=true`;
- it can enter OK only when `ok_in` is true, `fault_in` is false, and `reset` has a rising edge;
- either `fault_in=true` or `ok_in=false` trips it back to the faulted state;
- its watchdog output toggles only while `ok_out` is true;
- the source's typical connection is external fault/E-stop -> `fault_in`, `iocontrol.0.user-request-enable` -> `reset`, and `ok_out` -> `iocontrol.0.emc-enable-in`.

The implementation is a small HAL state latch. It stores only the previous reset state for edge detection. There is no redundant processor, safety-I/O test-pulse mechanism, forced-guided contact feedback mechanism, or claim of PL/SIL behavior in this component.

### Safety-course interpretation

**INFERENCE, strongly bounded by source:** `estop_latch` is useful for LinuxCNC's *ordinary control-side acknowledgement and restart inhibition*, but the source does not justify treating it as the final personnel-safety authority.

A practical architecture can feed the status of an external safety chain into LinuxCNC and use `estop_latch`/`iocontrol` to keep software state coherent. Opening the external safety chain should independently remove/inhibit hazardous actuation; LinuxCNC seeing the event is additional coordination and diagnostics, not the only protective action.

## 2. Reset is an acknowledgement, not proof that the hazard is safe

**SOURCE-CONFIRMED:** `estop_latch` requires a false-to-true reset edge while its fault inputs indicate no fault. A reset held high before the fault clears cannot produce the required new rising edge after the fault clears.

**DOC-CONFIRMED, independent industrial comparison:** current Rockwell GuardLogix E-stop documentation similarly distinguishes manual reset and requires a reset transition after both input channels are active; it also detects a reset held on in manual-reset mode and channel inconsistency. Rockwell's safe-stop documentation warns that automatic restart is appropriate only where its use cannot create an unsafe condition.

### Design rule

Reset must not be taught as "make the machine safe." It is a deliberate acknowledgement that the safety function's preconditions have already been restored. The safety-course default for attended hazardous machinery should be deliberate restart/rearm after a protective trip unless the hazard analysis specifically supports automatic restart.

Reset placement is part of the safety function. Where a person could remain inside a hazard zone, the reset/restart arrangement must not allow a person outside the zone to unknowingly re-enable hazardous operation merely because the electrical inputs have returned to normal.

## 3. HostMot2 watchdog is strong fault containment, not a safety certificate

### Evidence

**DOC-CONFIRMED** by current LinuxCNC HostMot2 documentation and man page:

- HostMot2's watchdog is serviced by the LinuxCNC HostMot2 write path;
- current documented default timeout is 5 ms;
- on watchdog bite, board I/O pins are disconnected from their module instances and become high-impedance inputs (pulled high);
- internal encoder, PWM and step-generator module state is not generally erased; generated signals are no longer relayed to the pins because those pins have been disconnected;
- clearing the watchdog restores communication and resets I/O pins to their load-time configuration.

**CONFIG-CONFIRMED:** the upstream `configs/by_interface/mesa/hm2-stepper/hm2-stepper.hal` example feeds `hm2_...watchdog.has_bit` into `estop-latch.0.fault-in`, while `estop-latch.0.ok-out` feeds `iocontrol.0.emc-enable-in`. The config itself calls this "a basic estop loop that only includes the hostmot watchdog."

### Important consequence

A watchdog bite is not equivalent to "all machine outputs are electrically OFF." The documented pin state is **high impedance with pull-up behavior**. The machine-facing interface must therefore be engineered so this state removes normal output authority. A field circuit for which a floating/high pin commands ON would defeat the intended containment behavior.

This directly supports the 4000-series rule that machine-facing output stages need deterministic inactive defaults and watchdog gating, but it does **not** turn the watchdog into a safety-rated stop channel.

## 4. Watchdog recovery and safety recovery are different operations

**DOC-CONFIRMED:** HostMot2 permits recovery by clearing `watchdog.has_bit`; doing so resumes communication and restores configured I/O ownership.

**INFERENCE / curriculum rule:** a low-level communication/watchdog recovery must not automatically re-authorize hazardous machine outputs after a safety event. Separate at least these concepts:

1. communication restored;
2. FPGA/field-I/O healthy;
3. LinuxCNC ordinary-control enable acknowledged;
4. independent safety chain healthy and reset according to its design;
5. hazardous operation deliberately restarted.

Collapsing these into one "reset everything" button creates a foreseeable unexpected-restart path.

## 5. Safety relay comparison establishes what ordinary HAL lacks

**DOC-CONFIRMED:** Pilz describes its PNOZ safety relay architecture as redundant with built-in self-monitoring and automatic checking of correct relay opening/closing each on-off cycle. Pilz explicitly uses contact welding as an example of why an ordinary electromechanical relay can fail dangerously.

**DOC-CONFIRMED:** Rockwell's dual-channel E-stop safety instruction includes channel consistency checking, reset behavior, and fault state that prevents the safety output from becoming active. These features are implemented inside a safety-rated control ecosystem with application constraints; copying the Boolean logic into ordinary HAL does not copy the safety claim.

### Design rule

When teaching "two channels," do not reduce the lesson to two copies of the same wire feeding an `and2`. The value comes from the complete fault model: independent signal paths where required, short/cross-fault behavior, discrepancy detection, output fault tolerance, feedback/EDM where required, restart behavior, component reliability assumptions, common-cause controls, and validation.

## 6. STO is not a universal stopped-state guarantee

**DOC-CONFIRMED:** Rockwell's PowerFlex 755 safety documentation states that STO disables motor torque, but external/mechanical forces such as suspended loads or back pressure can still rotate the motor. It also says not to use the STO option itself as the normal start/stop control.

### Design rule

Teach the question "what physical hazard remains after torque is removed?" before choosing STO as the safety response. Gravity axes, stored hydraulic/pneumatic energy, flywheels, coasting spindles, pressure-driven loads and externally driven mechanisms may need braking, blocking, monitored stopping, pressure isolation/dumping, or other measures beyond STO.

This is particularly important for presses: electrical torque removal is not a substitute for analyzing gravity and stored hydraulic energy.

## 7. Authority matrix for future course modules

| Function | LinuxCNC/HAL | HostMot2 / ordinary FPGA | Independent safety system | Physical energy hardware |
|---|---|---|---|---|
| Normal motion/process command | primary | executes/contains | normally observes or permits as required | actuates |
| Normal stop/feed hold | primary | executes | not necessarily invoked | responds normally |
| Detect stale host command | may diagnose | strong role | may independently monitor where required | must fail toward non-hazardous state |
| E-stop request/status display | coordinate/display | may report | **primary safety authority where design requires** | removes/inhibits hazardous energy as designed |
| Guard/light-curtain/two-hand safety function | may observe | may observe | **primary evaluated logic** | safety outputs/valves/STO/contactors |
| Reset/restart request | may request/coordinate | must not self-authorize safety | validates safety reset/restart conditions | remains inhibited until authorized |
| Contactor/valve feedback diagnostics | useful secondary diagnostics | useful acquisition | EDM/feedback belongs here when part of safety function | force-guided/monitored physical devices |
| Personnel-safety rating claim | no claim inferred | no claim inferred | only when evidence supports it | only as part of evaluated system |

## 8. Failure-path exercises to embed in 2510–2530 / 4400

These are analysis exercises, not claims about a specific machine:

1. **PC freeze:** LinuxCNC stops servicing HostMot2. Trace watchdog bite, actual FPGA pin state, field-interface inactive default, independent safety-chain state, and whether hazardous stored energy remains.
2. **HAL logic error:** LinuxCNC falsely says "enabled." Identify which independent protective function still prevents access-triggered hazardous motion.
3. **Watchdog recovery:** communication returns. Verify that clearing the watchdog alone cannot restart hazardous operation.
4. **Reset held on:** fault clears while reset remains asserted. Verify that the chosen safety architecture requires the intended deliberate acknowledgement rather than treating a static reset as a restart command.
5. **Welded output contact:** E-stop input changes correctly but one energy-isolation contact cannot open. Determine whether redundancy and EDM detect/contain the fault before the next hazardous cycle.
6. **STO with gravity load:** torque is removed but the axis can move from gravity. Identify the additional mechanical/braking/holding safety function.
7. **Floating FPGA output:** force the controller pin to high impedance. Verify by circuit reasoning or bench test that the machine-facing command becomes inactive, not active.

## 9. Human-factors requirements already justified by this pass

- A safety trip should produce a diagnostic that tells the operator *which prerequisite is missing* without encouraging bypass.
- Recovery should be easy but deliberate: clear fault -> restore safeguard -> visible/appropriate reset -> normal restart. Requiring obscure software gymnastics makes bypass more attractive.
- Do not make the E-stop the routine cycle-stop control. Normal stop controls should be convenient enough that operators do not abuse or defeat protective devices.
- A safety-system reset should not silently launch motion; ordinary cycle start remains a distinct action unless a risk assessment justifies otherwise.

## 10. Evidence ledger and open questions

### Frozen conclusions

- **SOURCE-CONFIRMED:** `estop_latch` is explicitly software E-stop logic with faulted startup and reset-edge acknowledgement.
- **DOC-CONFIRMED:** HostMot2 watchdog bite disconnects I/O pins to high-impedance/pulled-high states; internal generator state is not the safety mechanism.
- **CONFIG-CONFIRMED:** upstream example HAL uses HostMot2 watchdog as an input to the software E-stop latch.
- **DOC-CONFIRMED:** commercial safety ecosystems add redundancy, self-monitoring/channel diagnostics/reset semantics beyond a simple Boolean latch.
- **DOC-CONFIRMED:** STO removes torque-producing capability but does not guarantee a mechanically stationary load.
- **INFERENCE:** ordinary LinuxCNC/HAL and HostMot2 are appropriate for control coordination and fault containment but must not be assigned personnel-safety authority without separate evidence.

### Open research

1. Source-trace `iocontrol.0.user-request-enable` and `emc-enable-in` end-to-end so the course can distinguish GUI/user request, task state and machine enable precisely.
2. Inspect at least three real LinuxCNC machine integrations that use external safety relays/STO/contactors, preserving hardware authority and reset chronology.
3. Build R-SAFE-02's safety-relay comparison from exact manuals rather than product-family marketing pages.
4. Trace EDM/force-guided contact behavior from manufacturer application manuals and connect it to welded-contact fault exercises.
5. Build the first generic SRS example before drawing any low-cost reference safety circuit.
6. Do not assign PL/SIL/Category to a reference architecture until the corresponding reliability/diagnostic/common-cause/validation evidence has been studied.

## Sources

Primary LinuxCNC source:
- LinuxCNC `src/hal/components/estop_latch.comp`, pinned commit `d1a9d7d04cc274bfb5082caee6accc2489607418`.
- LinuxCNC `configs/by_interface/mesa/hm2-stepper/hm2-stepper.hal`, same pinned commit.

Documentation:
- LinuxCNC HostMot2 driver/man-page watchdog documentation, current master/stable documentation inspected 2026-09-15.
- Pilz, "Function of safety relay" and PNOZsigma product documentation, inspected 2026-09-15.
- Rockwell Automation GuardLogix Emergency Stop / dual-channel stop documentation, inspected 2026-09-15.
- Rockwell Automation PowerFlex 755 safe-stop functional-safety documentation, inspected 2026-09-15.

No laboratory compute was used in this pass. The unresolved items above are source/document/config research questions; a simulation would add little information at this stage.
