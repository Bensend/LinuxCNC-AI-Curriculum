# Press-Brake Valve Fault to Stopping Re-Proof Authority Trace — 2026-09-19

## Purpose

Close part of the current primary safety evidence gap without inventing a machine-specific hydraulic truth table: connect individual monitored-valve disagreement to the independent safety system's production inhibit, then connect return to normal press-brake operation to a physical stopping-performance proof that measures actual beam motion.

This is a same-product-family trace from Lazer Safe PCSS-A documentation. It does **not** claim that the public manual exposes the internal hydraulic load-retention consequence of every possible failed valve.

## Authoritative source

Lazer Safe, *PCSS-A Series Technical Manual*, LS-CS-M-046, Version 1.25, released 2024-09-12:

- https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/LS-CS-M-046-PCSS-A-Series-Technical-Manual-1.25.pdf
- Valve Monitoring Safety Function Options: manual pp. 197–200 (PDF pages 216–219).
- Example individual valve-monitor option tables: manual pp. 201 onward.
- Start-Up / Stopping Tests: manual pp. 253–256 (PDF pages 272–275).

## Evidence trace

### 1. Individual final-element monitor disagreement is a safety fault, not an ordinary CNC diagnostic

**DOC-CONFIRMED.** The PCSS valve-monitor function compares each monitored solenoid-valve feedback state against the associated valve-control output. A prolonged unexpected state produces a turn-on or turn-off fault. The PCSS then creates an emergency-stop condition and switches off the auxiliary-axis or emergency-stop output, preventing further press-brake operation until the problem is resolved.

The manual's valve-monitor tables explicitly classify switch-on/switch-off disagreement for **any monitored valve** as a valve fault. Depending on configured option, monitored elements include safety, holding, high-speed, prefill, proportional, low-speed, and down valves.

This supports:

`individual monitored valve disagreement -> valve fault -> PCSS emergency-stop condition -> relevant safety output off -> further press operation inhibited until problem resolved`

It does **not** support:

`monitor contact expected -> hydraulic load physically safe`

or:

`one healthy companion valve -> failed monitored valve may be ignored`.

### 2. Valve-zero is a defined switching-state witness, not a complete hazard-state witness

**DOC-CONFIRMED.** PCSS defines `Valve Zero` when all monitored valves are in their standby/idle feedback states and associated control outputs are off. The manual describes this as the state where no movement should be occurring.

**INFERENCE, bounded:** Valve Zero is useful evidence that the monitored switching elements agree with the commanded idle state. It is not, by itself, evidence that ram velocity is zero, a suspended load is mechanically/hydraulically retained, pressure is relieved, stored hydraulic energy is absent, or access is safe. Those require separate physical witnesses or machine-specific validation.

### 3. Normal-operation authority can depend on measured physical stopping performance

**DOC-CONFIRMED.** PCSS start-up testing performs two deliberately induced stops during high-speed down travel. It records actual stopping distance and stopping time from beam movement. A failed first or second start-up test triggers PCSS emergency-stop action; normal operation cannot continue and the test is repeated until it passes. Only after the required start-up tests have completed successfully may normal machine operation begin.

The manual explicitly warns that, before these tests pass, stopping performance and therefore press-brake safety have not yet been verified and precautions are required.

This establishes a physical re-proof boundary stronger than valve feedback alone:

`outputs/valve feedback plausible != stopping performance proved`

and:

`failed stopping proof -> emergency-stop reaction + normal operation blocked -> successful repeated proof required before normal operation`.

### 4. Physical proof is maintained, not one-time commissioning evidence

**DOC-CONFIRMED.** The PCSS can retrigger start-up/stopping tests when relevant operating conditions change, when stopping-test limits are exceeded in normal operation, after the configured repetition interval or 24 hours of continuous operation, and on certain mode transitions. It also performs a stopping test when operating speed increases sufficiently relative to the speed established by the start-up test.

Therefore a previously valid stopping proof is not permanent authority after meaningful changes in the machine's stopping behavior.

## What this closes

The course may now teach, with same-family manufacturer evidence:

**MONITORED VALVE DISAGREEMENT -> SAFETY FAULT / E-STOP REACTION -> FURTHER PRESS OPERATION INHIBITED.**

and separately:

**VALVE MONITOR AGREEMENT / VALVE ZERO != PHYSICAL STOPPING-PERFORMANCE PROOF.**

**FAILED REQUIRED STOPPING PROOF -> NORMAL OPERATION BLOCKED -> PROOF REPEATED UNTIL PASS -> NORMAL OPERATION MAY BEGIN.**

This is important because it prevents a weak recovery design where a technician replaces or frees a valve, sees the monitor contact change correctly, clears a fault, and treats that alone as sufficient proof that the machine is safe for production.

## What remains UNKNOWN

The public evidence reviewed here does **not** establish all of the following as one explicit causal sequence:

- exactly which hydraulic flow paths and retaining elements place the ram/load in a safe physical state for every individual monitored-valve disagreement;
- whether replacement of a specific safety/holding/prefill/proportional valve automatically forces the PCSS start-up tests, or whether OEM/service procedure must deliberately invoke/recommission them;
- the exact repair-versus-reset requirements for every valve fault code;
- whether a repaired holding/safety valve has a separate static load-retention proof in addition to dynamic stopping proof;
- whether a companion retaining element must be deliberately defeated or isolated during post-repair proof so it cannot mask the serviced element;
- press-brake-OEM-specific production initiation after successful safety re-proof.

Do not fill these gaps from analogy.

## Curriculum freeze

Use the following authority chain:

**VALVE COMMAND EXPECTED STATE != VALVE MONITOR EXPECTED STATE -> SAFETY FAULT / E-STOP REACTION -> FURTHER PRESS OPERATION INHIBITED.**

**FAULT MESSAGE CLEARED != VALVE REPAIRED != VALVE SWITCHING STATE RE-PROVED != RAM/LOAD PHYSICALLY SAFE != STOPPING PERFORMANCE RE-PROVED != PRODUCTION AUTHORITY.**

**VALVE ZERO != RAM STOPPED/RETAINED != PRESSURE SAFE != STORED ENERGY ABSENT != ACCESS SAFE.**

**FAILED REQUIRED STOPPING TEST -> NORMAL OPERATION BLOCKED; REQUIRED TEST MUST PASS BEFORE NORMAL OPERATION.**

## Practical OpenPressBrake teaching implication

The independent safety architecture should make it difficult to take the shortcut from `fault disappeared` to `run production`. Diagnostics from LinuxCNC or the normal FPGA may explain which element disagreed, but personnel-safety authority remains outside ordinary control. Where the machine's risk assessment depends on stopping performance, commissioning and post-service procedures need a physical motion/stopping witness, not only electrical command/feedback agreement.

No machine-specific stop distance, stop time, pressure, PL/SIL/DC value, or hydraulic truth table is inferred here.

## Next evidence target

Prefer a press-brake OEM/service source that explicitly joins:

`individual monitored holding/safety valve fault -> ram/load physical safe disposition -> isolate/support/depressurize -> valve repair/replacement -> individual retaining-function proof that cannot be masked by companion element -> dynamic stop-performance re-proof -> safety rearm -> press-brake-specific fresh production initiation`.

If that exact chain remains unavailable, continue the two-retaining-element branch and seek authoritative post-service proof requirements for one serviced element while the companion element is present.
