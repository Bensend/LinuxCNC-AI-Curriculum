# 25A0 — Programmable safety end-to-end trace, field fault matrix, and black-channel boundary

## Purpose

This artifact extends the initial 25A0 source preparation by tracing a programmable safety function across controller layers rather than treating a safety PLC as one opaque certified box. It also makes input-fault detection and black-channel communication explicit.

Evidence labels follow repository policy. No machine-specific PL/SIL, response time, diagnostic coverage, or physical safe state is inferred here.

## 1. End-to-end trace: Siemens fail-safe controller family

Reference family: Siemens S7-1200 fail-safe CPU with SM 1226 F-DI/F-DQ. The point is the evidence boundary, not endorsement of a product.

### Layer A — fail-safe CPU / internal diagnostics

**DOC-CONFIRMED:** Siemens' functional-safety documentation treats the fail-safe CPU and F-I/O as safety subsystems with internal diagnostics and defined fault reactions. Internal integrity supports the proposition that specified internal faults are detected/reacted to within the device's documented safety model.

It does **not** establish that the field sensor changed state, that wiring is independent, that a contactor opened, that a valve shifted, or that hazardous energy disappeared.

### Layer B — safe input diagnostics

**DOC-CONFIRMED:** SM 1226 F-DI supports 1oo1/1oo2 evaluation, discrepancy analysis and configurable short-circuit testing. In 1oo2, paired channels are evaluated by the module and the result is supplied to the safety program. Configured discrepancy time affects fault recognition and response time. Short-circuit-test duration and input filtering also enter the timing model.

Narrow proposition: for the documented topology/configuration, the module can detect a bounded set of electrical/channel-agreement faults and provide a safety-process value or passivated state.

It does not prove sensor mechanics, channel independence, absence of common cause, or the machine safe state.

### Layer C — safety application

**INFERENCE grounded in documented F-CPU/F-I/O architecture:** the safety application consumes safety-process values and executes the specified safety logic. A logically correct program can establish that its output command follows the specified Boolean/state/timing relationship among the values it receives.

It cannot make a false field assumption true. If both input channels are defeated by one common mechanical cause, an OSSD interface is wired incompatibly, or the configured timing exceeds the physical safety budget, correct logic can still produce an invalid machine safety function.

### Layer D — safe output diagnostics

**DOC-CONFIRMED:** Siemens F-DQ semiconductor outputs use diagnostic test pulses and require actuator compatibility with those pulses. Output-stage diagnostics support a bounded proposition about the F-DQ's electrical switching path.

They do not prove that an external contactor opened, a drive entered STO, a hydraulic valve reached a safe position, or a load stopped. Those propositions require final-element evidence and machine validation.

### Layer E — external final element and physical safe state

**ENGINEERING INFERENCE:** an external contactor, drive safety input, safety valve or other final element must be treated as another subsystem with its own failure modes, feedback/diagnostics, switching/use assumptions and physical effect. A monitored auxiliary contact can be evidence about contact state only to the extent the contact architecture and feedback are suitable; it is not automatically proof of zero hazardous energy.

**Freeze:** `CORRECT SAFETY-PLC LOGIC != CORRECT FIELD ASSUMPTIONS`.

**Freeze:** `SAFE OUTPUT OFF != FINAL ELEMENT PHYSICALLY SAFE`.

## 2. Input topology / fault-detection matrix

This matrix intentionally says `topology-dependent` where a universal claim would be unsafe. Exact behavior must be checked against the selected device and wiring diagram.

| Fault / condition | Dual dry contacts with appropriate test-pulse supplies | OSSD device into compatible F-DI | PNP/test-pulse variant | Evidence boundary |
|---|---|---|---|---|
| one channel open | normally detectable as channel state change/discrepancy; exact reaction depends on evaluation | normally represented by OSSD low/fault behavior if device detects it; receiver behavior device-dependent | usually detectable as channel low/discrepancy | does not prove why channel opened |
| both channels open | safe-state input value is generally observable | OSSD pair normally low in protective/fault state | generally low | safe input state is not proof of machine stop |
| channel short to 0 V | generally appears low; discrepancy if peer remains high | receiver sees low; device diagnostics may add fault information | generally low | distinguish safe demand from wiring fault where required |
| channel short to +24 V | may defeat a passive contact unless test-pulse topology detects failure to follow pulse | detection depends on OSSD receiver/device architecture; do not inject incompatible external pulses | test-pulse scheme may detect stuck-high if documented | `24 V fault detected` is not universal |
| cross-short between channels | distinguishable test pulses can detect some cross-shorts when separately sourced/wired | OSSD devices often use their own pulse pattern; receiver compatibility matters | topology-dependent | common routing can also create CCF beyond electrical diagnostics |
| one channel changes late | 1oo2 discrepancy monitoring can detect if beyond configured window | receiver/device timing model dependent | discrepancy monitoring may detect | discrepancy window contributes to response time |
| both channels forced together by one mechanical defeat | electrical diagnostics may see two valid agreeing states | OSSD electronics may also see a valid clear state if the physical protective function is defeated | may see two valid states | electrical agreement does not prove independent physical actuation |
| incompatible diagnostic pulses | passive contacts usually tolerate supply pulses when wired per manual | can cause nuisance trips or invalid behavior if external test pulses conflict with OSSD electronics | device-specific | interface compatibility must be documented |

**Freeze:** `TWO VALID INPUT BITS != TWO INDEPENDENT PHYSICAL SAFETY CHANNELS`.

**Freeze:** `ELECTRICAL FAULT DETECTION != COMMON-CAUSE CONTROL`.

## 3. Timing is part of the safety function

**DOC-CONFIRMED:** Siemens' S7-1200 functional-safety manual defines F-DI worst-case and one-fault delay terms. Discrepancy time, short-circuit-test duration, filtering and internal cycle time contribute to relevant delay calculations. The manual explicitly states that configured discrepancy time contributes to fault delay and that short-circuit-test timing can affect detection.

Engineering consequence: commissioning cannot treat discrepancy/filter/test-pulse timing as merely nuisance-trip tuning. A parameter change can alter the response-time evidence used by safeguarding-distance or stop-time reasoning.

**Freeze:** `LOGIC UNCHANGED != SAFETY FUNCTION UNCHANGED WHEN TIMING PARAMETERS CHANGE`.

## 4. PROFIsafe black-channel example

**DOC-CONFIRMED — PROFIBUS & PROFINET International (PI) PROFIsafe system description:** PROFIsafe carries safety messages over an underlying black channel. Safety measures include a monitoring/consecutive number concept, watchdog/time expectation, sender/receiver identity (F-address), and CRC integrity protection. The PROFIsafe layer is intentionally separated from ordinary PROFINET/transport behavior.

The black-channel principle is important because it prevents a common conceptual error: safety does not come from assuming Ethernet is lossless, deterministic, or itself safety-rated. The safety layer is designed to detect bounded communication faults while the underlying channel remains ordinary transport.

### What these mechanisms support

- sequence/monitoring information: detection of repetition, loss, insertion or wrong sequencing within the protocol model;
- watchdog/time expectation: detection of excessive age/delay or missing safety communication within the configured monitoring model;
- F-address/identity: protection against misrouting/wrong endpoint association within the protocol model;
- CRC/signature: integrity protection against corrupted/masqueraded safety data to the protocol's quantified assumptions.

### What they do not support alone

They do not prove network availability, zero packet loss, switch health, sensor correctness, actuator action, safe stopping, or maintenance isolation. A safe communication timeout may correctly force a safe command while the final element still fails physically.

**Freeze:** `BLACK-CHANNEL SAFETY != SAFETY-RATED ETHERNET`.

**Freeze:** `SAFETY TELEGRAM ACCEPTED != PHYSICAL SAFE STATE PROVED`.

**Freeze:** `COMMUNICATION TIMEOUT TO SAFE COMMAND != FINAL ELEMENT SUCCESS`.

## 5. Inspectable functional-safety tooling/project example

An inspectable project can improve evidence practice without being a certified safety component.

**DOC-CONFIRMED from project documentation — Assurance Forge:** the open-source project exposes a safety/assurance-case model, capability/conformance matrices, tests and explicit limitations. Its documentation states that it is alpha software, is not certified/qualified for a functional-safety process, and cannot judge whether a safety case is adequate. Supported capability claims are intended to be backed by tests.

Why this is useful for 25A0: it demonstrates desirable engineering habits — explicit claims, evidence links, limitations, challenge/defeater handling and machine-readable assurance structure — while also demonstrating the boundary `inspectable + tested != certified or sufficient for a machine safety function`.

**Freeze:** `OPEN SOURCE + TESTS != FUNCTIONAL-SAFETY CERTIFICATION`.

## 6. Adversarial case — perfect logic, unsafe machine

### Scenario

A guarded automated cell uses a safety PLC. Two guard contacts feed a 1oo2 F-DI pair. The safety program is reviewed and logically correct: opening the guard de-energizes a safe output controlling two contactors; reset requires the guard closed and a manual reset edge. The HMI reports every expected safety state correctly.

During commissioning, nuisance discrepancy faults occur because one guard contact switches later than the other. A technician increases discrepancy time substantially. Both contacts and their cable also share one poorly protected connector. The two contactors use ordinary non-mirror auxiliary contacts as feedback, and the machine's hazardous spindle has significant coast time. Guard unlocking is tied to `safety output = OFF` rather than independently established cessation of dangerous motion.

### Why the program can be correct while the safety function is wrong

1. The larger discrepancy setting changes worst-case reaction timing even though the application logic source is unchanged.
2. Shared physical routing/connector damage can defeat both nominal channels; input agreement is not independence.
3. Unsuitable auxiliary feedback may not establish the dangerous state of the main power contacts.
4. `F-DQ OFF` proves a command/electrical subsystem state, not contactor opening or spindle standstill.
5. Guard release based on output command can expose a person while stored kinetic energy remains hazardous.

### Required repair path

Repair the evidence chain rather than adding PLC code: establish justified discrepancy timing from sensor/install behavior and the total response-time budget; address common-cause routing/connector assumptions; use appropriate final-element architecture/feedback; establish the actual dangerous-motion cessation proposition needed for guard release; validate reset/restart separately from motion start. Keep ordinary LinuxCNC/HMI status downstream of the safety authority.

**Freeze:** `SAFETY PROGRAM REVIEW PASS != MACHINE SAFETY VALIDATION PASS`.

## 7. Evidence ledger summary

- `DOC-CONFIRMED`: Siemens F-DI 1oo2/discrepancy/short-circuit-test behavior and response-time terms.
- `DOC-CONFIRMED`: Siemens F-DQ diagnostic-pulse/actuator-compatibility boundary (from existing 25A0 source prep).
- `DOC-CONFIRMED`: PI PROFIsafe black-channel safety mechanisms.
- `DOC-CONFIRMED`: Assurance Forge published capability/test/limitation claims.
- `INFERENCE`: layer-by-layer physical proposition boundaries and adversarial integration consequences.
- `UNKNOWN`: actual machine sensor skew, total response time, wiring CCF adequacy, final-element diagnostic coverage, coast time, stopping distance, achieved PL/SIL, and suitability of any particular architecture for a real machine until application evidence exists.

## 8. Compute decision

No executable lab is justified by the questions resolved here. These are documentation/architecture/evidence-boundary questions. No GitHub-hosted compute should be consumed. A future lab should be frozen only for a concrete unresolved executable proposition and must target `[self-hosted, openpressbrake]`.
