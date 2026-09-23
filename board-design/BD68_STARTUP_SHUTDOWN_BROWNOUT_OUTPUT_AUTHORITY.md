# BD68 — Startup/Shutdown Sequencing, Brownout, and Output-Authority Reconciliation

Status: student-ready method lesson with audited bounded OpenPressBrake examples  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `83f07de87e300f0fb87bbaf81f79e72e5275ea8b`

## Purpose

BD67 closed the static whole-board power/return method. BD68 asks the harder temporal question: **what is electrically authoritative while rails are appearing, disappearing, drooping, resetting, faulting, or recovering?**

The flow is:

`accepted power/return graph -> source ramp/order -> reset/enable dependencies -> brownout behavior -> output default/inhibit states -> watchdog/power-fault interactions -> shutdown energy paths -> sequence fault-injection plan -> integration acceptance`

Central rule: **A SAFE STEADY STATE DOES NOT PROVE A SAFE TRANSITION.** Every externally consequential output needs a deterministic authority chain for power-up, reset, brownout, watchdog loss, partial-power states and shutdown.

This is ordinary controller engineering. It does not grant LinuxCNC, FPGA logic, watchdogs, output inhibits, or power-fault monitoring personnel-safety authority.

## Learning objectives

The student can:

1. turn a rail tree into a temporal startup/shutdown dependency graph;
2. identify circular enables and partially powered interface paths;
3. distinguish an electrical default state from a software-commanded state;
4. trace who has final OFF authority when FPGA logic is absent or invalid;
5. reconcile brownout/reset thresholds with output-stage behavior rather than assuming reset means outputs are harmless;
6. distinguish fault indication from fault containment;
7. trace stored-energy discharge and back-power paths during shutdown;
8. design a question-driven sequence fault-injection matrix without inventing machine timing values;
9. preserve the independent personnel-safety boundary.

## Student-facing source audit

Every file named below was opened in its CURRENT form during this run.

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON | status truthfulness, integration/qualification distinction, maintenance rule |
| `hardware/blocks/machine_power/REFERENCE_REBASE.md` | VERIFIED_FOR_LESSON | current machine-power source/control authority through Rev23, TPS26633 static modes, fault output, source hierarchy and open startup gates |
| `hardware/blocks/machine_power/STATUS_CHECKLIST.md` | ENGINEERING_REVIEW_NEEDED as a complete current status/evidence index; VERIFIED_FOR_LESSON only for bounded open-gate statements still consistent with current authority | unresolved ILIM/dVdT, startup/inrush, FPGA-core power and release work |
| `hardware/blocks/digital_output_24v/design/REV1_ISOLATED_INTERFACE_CONTRACT.md` | VERIFIED_FOR_LESSON for the frozen Rev1 isolated output topology/default-state authority; not a claim of schematic-ready or production-qualified hardware | deterministic OFF chain, isolation-domain power relationship, field-side output authority |
| `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` | VERIFIED_FOR_LESSON for current maturity/open gates and safety boundary | confirms isolated Rev1 path is not yet schematic-ready and identifies remaining structural/fault/thermal qualification |
| `board-design/BD67_WHOLE_BOARD_POWER_RETURN_FAULT_CONTAINMENT.md` | VERIFIED_FOR_LESSON | prerequisite power/return graph and fault-containment method |

The machine-power checklist still identifies a Rev17 partial freeze while current reference authority is Rev23. Under the repository maintenance rule it remains `ENGINEERING_REVIEW_NEEDED` as a complete current evidence index. Do not infer missing Rev18–Rev23 status from checked boxes.

## 1. Build a temporal dependency graph

For every rail, reset, enable and externally consequential output, record:

- source rail and parent source;
- valid operating envelope;
- enable/default state with the controller absent;
- reset/brownout dependency if known;
- upstream and downstream dependencies;
- output state before firmware/gateware becomes authoritative;
- behavior when the controlling domain disappears first;
- behavior when the field domain disappears first;
- stored energy that can keep the node alive;
- possible back-power path through I/O/protection structures;
- fault indication path and the power needed for that indication;
- recovery/latch/retry policy;
- evidence class and unresolved facts.

Do not invent ramp times or thresholds merely to complete the graph. Unknown physical timing stays `VERIFY_AT_MACHINE/TBD` unless established by component authority or measurement.

## 2. Separate four kinds of authority

For an output, identify four different authorities instead of writing only `FPGA controls output`:

1. **command authority** — who requests ON/OFF in normal operation;
2. **electrical default authority** — what forces the node when command logic is absent/unpowered/reset;
3. **power authority** — what source must exist for the field stage to energize;
4. **independent safety authority** — if any, the separate safety-rated chain that may remove permission/energy.

These can be different circuits. Ordinary FPGA command authority must not be mistaken for independent safety authority.

## 3. Audited OpenPressBrake output example

The current Rev1 isolated digital-output contract gives a useful bounded example.

Normal command path:

`FPGA OUTPUT_COMMAND_L -> STISO621 -> OUTPUT_COMMAND_P -> IPS1025H input network -> field output`

The field stage uses `SWITCHED_IO_24V` / L7 and `L07_SWITCHED_IO_RETURN`. Its isolation electronics use the shared field-side `SWITCHED_IO_5V` derived from the same switched field-domain family. The contract explicitly forbids an L07-to-L06/LOGIC_GND copper bridge.

The important startup/default rule is not `the FPGA will command zero`. The frozen contract says the output must be OFF if FPGA command, logic-side 3.3 V, field-side isolation supply, or switched L7 field power is absent. The **IPS1025H field-side input pull-down is the final deterministic OFF authority**. The additional isolator-side pull-down supports that state but does not replace the primitive's stronger OFF authority.

That is reusable engineering knowledge: put a hardware default at the actuator-facing stage so loss of upstream logic does not depend on software executing a cleanup path.

This is still ordinary machine-control behavior. The contract explicitly denies personnel-safety credit and retains the independent Pilz/AKAS/SICK safety system.

## 4. Power-up reconciliation

For each output/interface walk these phases:

### A. No board power

What physical bias fixes the output? If the answer is only `software defaults to zero`, the design is not closed.

### B. Field power present, logic absent

Can an input float, leakage energize a stage, or an isolator/translator receive power on only one side? Does the actuator-facing pull-down/pull-up still own the inactive state?

### C. Logic power present, FPGA reset/unconfigured

Are FPGA pins high impedance? Does an external bias establish the required state? Do not assume a configured gateware default exists before configuration.

### D. Gateware valid, host/LinuxCNC absent

What watchdog/global-enable policy prevents stale commands from becoming indefinite authority? The existence of a watchdog concept is not evidence of its exact timeout or complete board implementation.

### E. Host and machine control valid

Only now is normal command authority established. The transition into this state should be explicit and monotonic: prerequisites become valid before output permission is granted.

## 5. Brownout is a partial-power problem

A brownout can violate assumptions without making every rail exactly zero. Analyze at least:

- source below one device's valid range while another still operates;
- FPGA/core reset while field supply remains valid;
- field-side isolator supply decaying before/after field output power;
- logic-side supply decaying while a field-side device remains powered;
- fault/open-drain pull-up rail disappearing before the fault source;
- converters entering UVLO/current limit while downstream capacitance sustains logic;
- external signals back-powering an unpowered domain.

Current OpenPressBrake machine-power authority freezes TPS26633 UVLO to the manufacturer's factory mode and MODE open for latch-off behavior, with SHDN open so normal enable does not depend on software. `LOGIC_POWER_FAULT_N` is an open-drain fault indication pulled to `3V3_CORE` and received by the FPGA.

That signal is **diagnostic evidence, not containment authority**. If `3V3_CORE` is absent, the FPGA cannot be credited with observing it. If the TPS26633 has already removed/latched its protected branch, that hardware behavior exists independently of whether software logs the fault.

## 6. Startup/inrush remains an open OpenPressBrake gate

Do not convert the known 134.56-mA populated continuous 5-V subtotal into a startup proof. Current authority explicitly leaves remaining direct 5-V consumers and startup/inrush open. TPS26633 ILIM and dVdT programming are therefore not frozen.

The sequence review must wait for the actual downstream capacitance/startup boundary, including the analog branch and TPS65131 contribution, before claiming that the CORE branch can ramp without nuisance limiting, oscillatory restart, excessive delay, or an unsupported current-limit interaction.

This is a useful catalog stress test: a block that publishes only steady-state current is insufficient for board-level startup planning. Shared-resource contracts need startup/inrush/effective-capacitance information or an explicit unresolved field.

## 7. Shutdown reconciliation

Walk shutdown in both intended and fault orders. For each relevant domain ask:

- which source is removed first;
- which output bias remains authoritative;
- whether stored charge can sustain an enable or command;
- where capacitors discharge;
- whether an external field signal can back-power logic;
- whether inductive field energy is locally demagnetized or can feed another rail;
- whether a fault latch requires a power cycle and what actually resets it;
- whether a later re-energization can restore an old command without a fresh permission transition.

A design that powers up safely but can pulse an output while rails collapse is not transition-closed.

## 8. Watchdog and global-enable reconciliation

For every watchdog/global-enable path define:

- heartbeat source;
- monitor clock/power domain;
- output/inhibit destination;
- hardware state when heartbeat is absent;
- startup state before first valid heartbeat;
- timeout authority and provenance;
- recovery policy: automatic, latched, or fresh-command required;
- behavior if monitor power fails;
- relationship to field-stage electrical default;
- relationship to independent safety permission.

Never write `watchdog makes it safe` without tracing the physical output authority. A watchdog that merely sets an FPGA register cannot be credited after the FPGA itself has lost valid operation. Conversely, a hardware field-stage pull-down can establish ordinary OFF behavior even when host/FPGA logic is unavailable.

## 9. Sequence fault-injection matrix

Before integration acceptance, create question-driven cases. At minimum:

| Injection | Required observation/question |
|---|---|
| apply field power with logic absent | does every consequential ordinary output remain at its declared electrical default? |
| apply logic before field power | is any interface back-powered or falsely diagnosed? |
| hold FPGA in reset/configuration | do actuator-facing defaults remain authoritative? |
| remove host heartbeat | does ordinary watchdog/inhibit reach the intended physical stage, and what evidence proves it? |
| brown out CORE source slowly | which device loses validity first; can another domain drive it? |
| remove `3V3_CORE` while field power remains | do outputs remain OFF/default; what happens to returned diagnostics? |
| remove switched field power while logic remains | can logic or isolator power unintentionally source the field stage? |
| restore power after TPS26633 latch-off | what resets the latch, and can stale command state reassert? |
| power-cycle one side of an isolated interface | are inactive levels deterministic in both directions? |
| emergency/safety permission removed | ordinary controller may observe status, but does not claim safety authority |

Use calculation/datasheet reasoning first. Use executable or bench testing only for a named unresolved question. Any executable verification for OpenPressBrake must run only on `[self-hosted, openpressbrake]`.

## 10. Integration acceptance gate

Startup/shutdown/output authority may advance only when:

- every consequential output has an explicit actuator-facing electrical default;
- command, default, power and safety authorities are distinguished;
- rail/reset/enable dependencies are acyclic or intentionally sequenced;
- partial-power states have been reviewed for floating inputs and back-power;
- brownout behavior is bounded by component authority or explicitly unresolved;
- watchdog/global-enable behavior reaches a physical inhibit/default path rather than existing only as prose;
- fault indications are not mistaken for fault containment;
- startup/inrush evidence is separate from continuous-current evidence;
- shutdown/stored-energy paths are explicit;
- recovery cannot silently restore stale authority where a fresh permission is required;
- unresolved physical timing/loads remain `VERIFY_AT_MACHINE/TBD`;
- independent personnel-safety authority remains outside the ordinary controller.

This means **transition behavior accepted for board integration**, not production qualification and not machine-safety validation.

## Negative cases

Reject these arguments:

- `The FPGA initializes outputs low, so power-up is safe.`
- `The fault pin is connected, so the fault is contained.`
- `The continuous power budget fits, so startup will fit.`
- `The watchdog is in the FPGA, so it still protects against invalid FPGA operation.`
- `The isolator prevents all back-power automatically.`
- `Both sides are nominally off, so rail order does not matter.`
- `The output turns off in normal shutdown, so brownout is covered.`
- `LinuxCNC sees the safety status, so LinuxCNC is the safety authority.`

## Catalog stress-test result

BD68 exposes a reusable-catalog requirement that should become machine-readable: each output/interface resource should publish a **transition contract** containing default bias authority, power dependencies, partial-power assumptions, startup/inrush/effective capacitance where relevant, reset/enable dependencies, watchdog/inhibit semantics, fault-indication dependency, shutdown/stored-energy behavior and unresolved machine facts.

The current digital-output contract is unusually strong on deterministic field-side OFF authority and domain separation, but its status correctly leaves exact board connectivity, structural enforcement, fault/abnormal qualification and thermal/simultaneous-channel corners open. Do not promote it beyond that evidence.

The machine-power status checklist remains stale relative to Rev23 and is `ENGINEERING_REVIEW_NEEDED` as a complete current evidence index. Because OpenPressBrake main is actively advancing resource contracts, this curriculum run leaves OpenPressBrake read-only rather than racing the engineering lane.

No simulation, synthesis, place-and-route or other executable verification is required for this authority-reconciliation lesson.

## Transfer exercise

Apply the transition-contract method to a mill spindle enable, lathe coolant/solenoid output, plasma torch-enable path, router VFD interface, robot peripheral output, or custom automation channel. Trace no-power, partial-power, reset, host-loss, brownout, normal shutdown and fault shutdown. Separate ordinary controller OFF behavior from independent safety authority.

## Checkpoint

BD68 is complete. Next develop **BD69 — FPGA/Host Watchdog, Global-Enable, and Stale-Command Containment**:

`transition-closed output paths -> watchdog authority chain -> host/FPGA failure classes -> stale-command containment -> global-enable fanout -> LinuxCNC/HAL state mapping -> fault/recovery semantics -> verification matrix -> integration acceptance`.

Re-open every student-facing source on current main. Do not invent watchdog timeout values, FPGA reset behavior, machine timing, or safety integrity claims. Preserve `VERIFY_AT_MACHINE/TBD` facts and do not treat the current OpenPressBrake board as production-proven.