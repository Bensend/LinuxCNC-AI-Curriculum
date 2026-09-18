# Dual-Contactor Mirror/EDM Welded-Pole Restart-Inhibit Trace — 2026-09-18

## Purpose

Advance the independent electrical final-element lane without overlapping the primary HAWE hydraulic/fall-protection work. This study closes the next evidence gap after the mirror-contact proof-boundary study: what a certified mirror contact can actually prove, how that evidence is used in a feedback/EDM loop, what a welded main contact does to restart permission, and what still remains physically UNKNOWN.

## Evidence labels

- **SOURCE-CONFIRMED** — directly stated in an authoritative manufacturer source identified below.
- **DOC-CONFIRMED** — directly stated in a manufacturer application/technical document identified below.
- **TEST-CONFIRMED** — not used in this study; no executable or physical test was justified.
- **COMMUNITY-REPORTED** — not used in this study.
- **INFERENCE** — bounded engineering conclusion derived from cited manufacturer behavior.
- **UNKNOWN** — not established for OpenPressBrake or not established by the source package.

## Evidence package

### Siemens: mirror contact and feedback-circuit contract

**DOC-CONFIRMED:** Siemens, *Contactors in safety applications*, Entry-ID 109807687 V1.1 (07/2023), states that correct feedback-circuit monitoring of power contactors requires mirror contacts. It defines the IEC 60947-4-1 Annex F mirror contact as an auxiliary NC contact that cannot be closed at the same time as an NO main contact. Siemens states that this antivalent relationship permits reliable feedback-circuit monitoring.

**DOC-CONFIRMED:** The same Siemens document states that feedback-circuit monitoring can detect a contactor fault no later than the next switch-on attempt; the diagnostic claim is therefore tied to the feedback circuit and restart sequence, not to an assumption that the commanded OFF bit proves physical isolation.

**DOC-CONFIRMED:** Siemens separately distinguishes power-contactor **mirror contacts** from the **positive guidance** terminology used for auxiliary contactors/coupling relays under IEC 60947-5-1 Annex L. These terms must not be collapsed into generic `auxiliary contact = safety feedback` language.

### Siemens: welded-NO failure behavior

**DOC-CONFIRMED:** Siemens, *Positively driven contact elements / mirror contacts*, Entry-ID 109758261 V3.0 (03/2020), gives a fault sequence in which an NO/main contact cannot open. With a contactor having mirror contacts, the associated NC mirror contacts remain open rather than falsely returning to the normal OFF indication. Siemens identifies that feedback as usable to detect the fault.

This is the key physical diagnostic relationship:

**MAIN NO WELDED/CANNOT OPEN -> MIRROR NC MUST NOT FALSELY CLOSE -> FEEDBACK LOOP DOES NOT RETURN HEALTHY -> RESTART CAN BE INHIBITED BY THE SAFETY LOGIC.**

The mirror contact is therefore a witness to a bounded mechanical/contact relationship. It is not a sensor for every downstream conductor, stored-energy source, drive state, hydraulic state, or alternate feed.

### ABB: dedicated safety contactor implementation

**SOURCE-CONFIRMED:** ABB AFS safety contactors are supplied with permanently fixed auxiliary contact blocks and manufacturer-identified mechanically linked/mirror contacts for feedback circuits. ABB states that this arrangement prevents unexpected auxiliary-state changes when main contacts are welded or stuck and is intended to depict contactor status for the safety system.

**SOURCE-CONFIRMED:** ABB's current AFS catalog entries identify these devices as intended for machine safety applications and explicitly identify mirror/mechanically linked contact functionality. This is useful implementation evidence that the feedback witness is a defined product feature, not merely a drawing convention applied to an arbitrary spare auxiliary contact.

## Proof chain

Freeze the electrical final-element chain as separate claims:

**SAFETY DEMAND -> SAFETY OUTPUT(S) OFF -> CONTACTOR COIL(S) DE-ENERGIZED -> MAIN POWER CONTACT(S) PHYSICALLY OPEN -> MIRROR CONTACT(S) IN EXPECTED STATE -> EDM/FEEDBACK ACCEPTED -> RESTART PERMISSION -> NEW ORDINARY START COMMAND -> HAZARDOUS OUTPUT.**

Do not collapse adjacent stages.

A mirror/EDM loop supports a claim about the monitored contactor's contact relationship. It does not by itself prove:

- every pole in every hazardous-energy path is open unless the selected device/documented architecture establishes that relationship;
- an alternate or backfeed power path is absent;
- stored electrical, pneumatic, hydraulic, gravitational, or mechanical energy is absent;
- a drive STO channel is healthy;
- the load has stopped;
- the safety function's required stopping performance was achieved;
- maintenance isolation has been achieved.

## Dual-contactor failure-path matrix

| Injected/observed condition | Expected diagnostic meaning | What remains unproven |
|---|---|---|
| K1 and K2 commanded OFF; both mirror contacts return expected OFF state | monitored contact relationships are consistent with OFF | downstream energy absent; alternate feeds absent; load stopped |
| K1 main NO welded/cannot open; K1 mirror NC remains open | K1 cannot truthfully report released; EDM should not accept healthy feedback | K2 condition unless separately monitored; physical load result |
| K1 welded, K2 opens | one independent interruption path may still remove the bounded electrical feed | achieved safety performance; common-cause independence; all energy paths |
| K1 and K2 share a fault that keeps both power paths closed | redundant-looking architecture may have lost both interruption paths | detection depends on actual feedback/wiring architecture |
| Ordinary auxiliary contact changes state but is not documented as mirror/positively guided for the application | indication only | welded-main-contact diagnostic relationship |
| Mirror loop is shorted/bypassed closed in field wiring | feedback can be falsely satisfied despite physical contactor fault | field-wiring integrity unless separately diagnosed |
| Coil node is backfed despite safety output OFF | commanded OFF is not physical de-energization | actual coil voltage/current and main-contact state |
| Main contactors open but DC bus/capacitor remains charged | bounded feed interruption may be true | stored electrical energy absent |
| Main contactors open but gravity/hydraulic load can still move | electrical feed interruption may be true | mechanical/hydraulic hazard controlled |

## Restart-inhibit architecture rule

**INFERENCE:** A useful safety architecture does not treat EDM as a passive HMI status bit. When a demanded OFF transition is followed by feedback inconsistent with the documented contactor state, the independent safety authority should prevent ordinary restart until the fault is corrected and the required recovery/reset sequence is satisfied.

This inference is consistent with manufacturer feedback-circuit use, but the exact reset timing, discrepancy interval, manual-reset behavior, and fault-latch semantics must come from the selected safety controller/contactors and machine risk design.

Freeze:

**COMMAND OFF != COIL OFF != MAIN CONTACTS OPEN != MIRROR FEEDBACK HEALTHY != EDM ACCEPTED != ALL HAZARDOUS ENERGY ABSENT.**

And:

**EDM HEALTHY != PERMISSION TO REPLAY A STALE LINUXCNC/HAL/FPGA COMMAND.**

LinuxCNC/HAL/ordinary FPGA may display K1/K2/EDM diagnostics and may be required to generate a fresh ordinary command after safety rearm. They must not become the sole authority deciding that a welded contactor or failed feedback path is safe enough to restart.

## Commissioning questions

A real derived design should answer with product- and machine-specific evidence:

1. Which exact main poles interrupt each hazardous electrical feed?
2. Which exact NC contacts are manufacturer-certified mirror contacts for those main poles?
3. Are K1 and K2 each independently witnessed, or can one feedback state mask the other?
4. Can a short across the feedback loop create a false healthy state, and what detects it?
5. Can a short/backfeed energize either coil after the safety output turns OFF?
6. What happens on a single welded main pole rather than a fully welded contactor?
7. Does a detected feedback mismatch latch restart inhibit, and what deliberate recovery is required?
8. What hazardous energy remains after K1/K2 open: drive DC bus, stored electrical energy, gravity, pressure, accumulators, brakes, or other feeds?
9. Does the selected architecture require a fresh ordinary START after safety reset/rearm?
10. Which observations are available only for diagnostics, and which are actually part of the independent safety function?

## OpenPressBrake boundary

**UNKNOWN:** selected contactors/relays; exact interrupted feeds and poles; mirror-contact certification; K1/K2 wiring; EDM implementation; feedback-loop short detection; coil backfeed exposure; suppressors; drive/STO interaction; stored electrical energy; reset/restart timing; achieved category/PL/SIL/DC; and actual hazardous-energy result.

No OpenPressBrake contactor topology, performance level, timing, stopping distance, hydraulic truth table, pressure threshold, or physical machine response is invented here.

## Sources

- Siemens AG, *Contactors in safety applications*, Entry-ID 109807687, V1.1, 07/2023 — mirror contacts, feedback-circuit monitoring, terminology and diagnostic use.
- Siemens AG, *Positively driven contact elements / mirror contacts*, Entry-ID 109758261, V3.0, 03/2020 — welded NO/main-contact fault sequence and mirror-contact feedback behavior.
- ABB, *AFS Contactors Dedicated for Safety Applications*, 1SBC100206B0203 / AFS catalog — permanently fixed safety auxiliary block, mechanically linked/mirror contacts, welded/stuck main-contact feedback intent.

## Compute

No simulation, synthesis, benchmark, or executable verification was needed. No GitHub-hosted runner and no self-hosted runner compute was used.

## Precise next independent work

Prefer a complete professional wiring/application package that exposes **dual safety outputs -> K1/K2 coils -> main power poles -> separate mirror contacts -> EDM/feedback -> welded-pole fault -> restart inhibition -> downstream hazardous-energy interruption** in one trace. If the primary lane reaches that evidence package first, rotate Lane B to **feedback-loop short/bypass and coil-backfeed common-cause fault injection** or **stored electrical energy after contactor opening**, not to the primary hydraulic branch.