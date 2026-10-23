# 4400 source trace — maintenance lockout is a different state machine from E-stop recovery

**Status:** DOC-CONFIRMED regulatory text and engineering INFERENCE, not a legal determination for a particular machine. **Study date:** 2026-10-23 UTC. **Application:** LinuxCNC/OpenPressBrake press brakes and transferable mill/lathe/plasma/robot maintenance scenarios. No tests or personnel-exposed operation.

## Authoritative source and exact propositions

OSHA 29 CFR 1910.147 (current official regulatory text): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

- **DOC-CONFIRMED — 1910.147(b):** An energy-isolating device physically prevents transmission/release of energy. Control-circuit pushbuttons and selector switches do **not** qualify. A latched E-stop, LinuxCNC `machine-off` state, FPGA watchdog and safety-relay diagnostic tag do not become maintenance isolation because they are lockable or green.
- **DOC-CONFIRMED — (c)(2)(iii):** The rule addresses lockout-capable isolating devices on new installations and major repairs/renovations/modifications after the specified effective date. Applicability to any particular retrofit requires fact-specific assessment; this is not permission to retain a defective isolation arrangement.
- **DOC-CONFIRMED — (d)(3–6):** Locate and operate necessary energy-isolating devices; apply authorized worker protection; relieve/disconnect/restrain hazardous stored energy; continue verifying credible reaccumulation; verify isolation and de-energization before servicing.
- **DOC-CONFIRMED — (f)(1):** Temporary energization for testing/positioning is a bounded transition: clear tools/materials; remove employees from the area; remove lockout/tagout under the procedure; energize and perform the test; de-energize and reapply energy-control measures before continuing service. Do not treat the earlier isolation proof as still current.
- **DOC-CONFIRMED — (f)(3–4):** Group servicing and shift/personnel changes need continuity of individual worker protection. A group leader's indicator is not evidence that each exposed worker remains protected.
- **DOC-CONFIRMED — (e):** Restoration involves inspecting the work area, accounting for affected people, proper removal of devices, and notification. It is not equivalent to an HMI fault reset or a permissive ordinary cycle-start.

## Four separate state domains (INFERENCE)

| Domain | Typical input | What must be proved | What it cannot prove alone |
|---|---|---|---|
| Ordinary LinuxCNC / FPGA motion | stop, disable, fault, reset | Requested normal behavior | Hazardous energy physically isolated |
| Production safety-related controller | E-stop, interlock, protective field | Defined safety demand and safety output response | Every trapped pressure zone exhausted or gravity load restrained |
| Physical energy control | isolator, lock, bleed, blocking, personal lock | Task-specific isolation and stored-energy disposition | Future reaccumulation absent without continued verification |
| Restoration/rearm | deliberate safety reset, separate normal start | Safeguard readiness, people clear, no retained start, physical conditions valid | Previous maintenance proof automatically survives a powered test |

**INFERENCE:** Model a maintenance job as `PREPARE -> ISOLATE -> SECURE STORED ENERGY -> VERIFY -> SERVICE`. A necessary powered positioning test transitions through `CLEAR AREA -> CONTROLLED UNLOCK/RE-ENERGIZE -> TEST -> DE-ENERGIZE -> RE-ISOLATE -> RE-VERIFY -> SERVICE`. A `RESET` button is not a shortcut edge from `TEST` back to `SERVICE`.

## Press-brake failure-path analysis

A pump contactor drops out and a hydraulic gauge reads zero, but a gravity-loaded ram is not independently supported. Neither condition establishes the ram is restrained. If the system includes accumulators, pilot circuits or isolated cylinder chambers, record their **actual** energy boundaries; do not infer hydraulic safe-state truth tables from generic catalog diagrams. A worker who must remove a heavy awkward guard to reach the isolator has a predictable bypass incentive. The architecture should provide an accessible lockable isolation point, clear identification, safe and easy restraint/verification access, and a repeatable reinstallation path.

**Adversarial sequence:** Worker A locks out and verifies; worker B joins after lunch; a technician temporarily powers the pump to position the ram; worker A's earlier verified state is no longer sufficient. Document who is exposed, each personal protection mechanism, tools/people cleared for the temporary test, re-isolation, pressure/reaccumulation witness, ram restraint and shift handoff. Do not execute this scenario on an unqualified machine.

## Cumulative traceability and evidence gate

Record `BND/ENE/HAZ` for each electrical, hydraulic, gravity and auxiliary energy source; `SF/PHY/SRS` for production stopping and separately for maintenance isolation; `AUTH/ARC` for independent safety control versus physical isolators; `DEP` for pilot-pressure, shared supply and reaccumulation paths; `HF` for foreseeable lockout/guard shortcuts; `VAL/PT` for **task-specific physical witnesses**; `CHG` whenever configuration/isolator/maintenance procedure changes; `UNK/RR` for missing evidence and restrictions.

**UNKNOWN / NOT RUN:** actual installed isolation devices, selected pressure ports, cylinder/accumulator topology, residual-energy measurements, ram-restraint capacity, regulatory applicability to a specific owner/machine, and validation results. No PL/SIL, stop time, pressure threshold or proof interval is asserted. Do not operate with people exposed until basic minimum safe-to-operate protection is demonstrated. Experimental work must be isolated/remote with people outside the danger zone and residual risks controlled.

**Related learner exercise:** `safety-course/4400_LOCKABLE_ISOLATOR_TAGOUT_RETROFIT_TECHNICIAN_CARD_2026-10-22.md`. This note is not an external blind evaluation key.
