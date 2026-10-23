# 4400 — ISO 14119:2024 edition bridge and an input-level proof of series-guard fault masking

**Status:** learner-facing documentary/source-reasoning supplement, prepared 2026-10-23 UTC. **NOT** a selected-machine design, diagnostic-coverage calculation, simulation result, certified safety function, or operating authorization. Companion to staged `research/4400_SERIES_GUARD_INTERLOCK_FAULT_MASKING_AND_SELF_MONITORING_2026-10-22.md` (not yet on main). Courses: 2590, 2550/2560, 4400.

## The evidence change since the older technical report

1. **DOC-CONFIRMED, ISO edition:** ISO identifies ISO 14119:2024, edition 3, published September 2024, as the current interlocking-device design/selection standard, with reasonably foreseeable defeat among its subjects. Its public abstract does not specify a machine's diagnostic coverage, achieved PL/SIL, or required stop time. [ISO catalog](https://www.iso.org/standard/75942.html).
2. **DOC-CONFIRMED, older scope:** ISO/TR 24119:2015 concerns *potential-free-contact* interlocking devices whose **two channels are physically series connected** to a diagnostic logic unit. It provides a method to estimate fault-masking probability and maximum diagnostic coverage, not a universal numeric DC value for all chains. [ISO technical-report catalog](https://www.iso.org/standard/63160.html).
3. **DOC-CONFIRMED, manufacturer interpretation:** Schmersal's *Design of Safety Guards under Observation of ISO 14119* (2025 guide, PDF p. 2 and p. 8; publication revision must be retained) states that ISO/TR 24119 was incorporated as **Annex J** in ISO 14119:2024, and that series-connected potential-free contacts require a fault-masking/DC analysis. It distinguishes self-monitoring electronic devices. [Schmersal 2025 guide](https://www.schmersalusa.com/fileadmin/content/usa/downloads/Literature/ISO_14119_Guide_2025.pdf).
4. **DOC-CONFIRMED from publicly indexed standard table of contents, with scope limit:** the accessible ISO 14119:2024 contents preview identifies Annex J as *normative*. This is stronger edition-context evidence than the earlier ISO abstract alone, but a licensed current-edition text must still be consulted before making a formal clause-by-clause conformity claim. [Published edition preview](https://standards.iteh.ai/catalog/standards/iso/621c3424-b22a-43c4-9263-35e9cec2ee3a/iso-14119-2024).

**Edition decision:** retain ISO/TR 24119:2015 as a useful historical explanation, but cite **ISO 14119:2024 Annex J** as the newer route for current-design review where applicable. Do not declare the 2015 report globally withdrawn solely because its content was incorporated into the 2024 standard; the ISO catalog still lists it. Do not transpose any manufacturer's simplified DC/PL ceiling to an unselected chain. Record jurisdiction, exact edition, device type, topology, logic-unit diagnostics and selected-machine integrity requirement as separate inputs.

## A complete input-level counterexample — no relay-specific assumption

Take two movable guards A and B. Each has two normally-closed contact channels. The two channels are separately series wired to one receiver. Boolean `1` means a contact is electrically conducting; `0` means open. The **observed** receiver inputs are:

`R1 = A1 AND B1`; `R2 = A2 AND B2`.

Now suppose `A1` is faulted **permanently conducting** (`A1=1`) even when guard A is open. `A2` still follows A. Both contacts in B are healthy. The following idealized **settled-state** sequence gives the receiver **no sustained channel discrepancy in the shown states**:

| Step | Physical guards | A1 (fault) | A2 | B1 | B2 | R1 | R2 | What the shared receiver sees |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 0 | A closed, B closed | 1 | 1 | 1 | 1 | 1 | 1 | Both inputs conducting |
| 1 | B opened first | 1 | 1 | 0 | 0 | 0 | 0 | Both inputs open |
| 2 | A opened while B open | 1 | 0 | 0 | 0 | 0 | 0 | Both inputs still open |
| 3 | A closed while B open | 1 | 1 | 0 | 0 | 0 | 0 | Both inputs still open |
| 4 | B closed last | 1 | 1 | 1 | 1 | 1 | 1 | Both inputs conducting again |

**SOURCE REASONING / INFERENCE, not TEST-CONFIRMED:** this follows directly from the explicitly declared series Boolean topology. No claim about a particular safety relay's internal latch or timing is needed: the settled aggregate states do not expose the asymmetric contact fault to a simple static discrepancy diagnostic. **Real contact transitions are not perfectly simultaneous:** a receiver might detect brief mismatch/bounce or use test pulses, per-device diagnostics, timing logic or different wiring. Whether any such mechanism detects the fault is `UNKNOWN` until the exact selected receiver/device manuals and relevant timing evidence are inspected.

**Discriminating counter-sequence:** if A opens **first** while B remains closed, then `R1=1` and `R2=0`. A receiver with an appropriate diagnostic might detect and latch that discrepancy. This does **not** prove that every receiver will, or that its fault memory can never be reset. The order of legitimate guard use can change diagnostic observability.

The fault is **latent degradation of the protective system**, not automatically proof that the machine moves unsafely in the example: opening B still drives both aggregate channels open in the idealized model, so a properly configured receiver may issue the normal protective demand. The concern is undetected fault accumulation and reduced confidence in later protective demands. Whether a later independent fault can defeat the required safety function is a separate architecture/fault-tolerance question. Never assign a DCavg or PL from this table alone.

## What the logic proves — and what it does not

- **INFERENCE (deductive):** one pair of shared receiver inputs cannot reconstruct each guard's individual contact state in the masked sequence. `R1=R2=1` does not establish that every contact/guard is healthy.
- **UNKNOWN for selected machine:** fault-exclusion assumptions, additional diagnostic channels, receiver discrepancy windows, restart inhibition, guard frequency/overlap, maintenance modes, wiring faults, and actual integrity calculation.
- **DOC-CONFIRMED, manufacturer-level:** the Schmersal guide explicitly warns of DC reduction in series electromechanical guard arrangements. Its suggested architecture preferences are product/design guidance, not machine validation.
- **Not inferred:** that an electronic cascade always achieves PL e, that a specific passive chain is categorically prohibited, or that any exact DC/PL limit applies without evaluating the actual application.

## Design alternatives and practical usability

| Option | Benefit | Required evidence before selection |
|---|---|---|
| Individually evaluated guard channels | Clearer per-guard fault localization; easier maintenance diagnostics | Exact input safety resources, test pulses, common power/reference, cable faults, logic/output/final-element chain |
| Documented manufacturer-compatible self-monitoring cascade | Reduced cabling and potentially detailed per-device diagnostics | Exact part/firmware, permitted cascade topology, safety output vs diagnostic interface, receiver compatibility, common dependencies, full safety-function integrity |
| Shared passive contact series chain | Simple and inexpensive wiring | Fault-masking evaluation for selected topology/use pattern, receiver diagnostics/fault memory, required integrity, maintenance/human factors |

A six-gate cell with poor fault localization can tempt a technician to tape an actuator or leave a guard defeated. Address that foreseeable behavior in the design: alignment, individual fault indication where available, captive hardware, easy restoration, and a clearly defined independent rearm procedure. A convenient **HMI diagnostic** may reduce troubleshooting time but never becomes the independent safety controller.

## Cross-machine transfer and physical boundary

A robot cell can have a person remaining inside after gates reclose; gate-input recovery is not occupancy proof. A press brake can have a gravity-loaded ram and stored hydraulic pressure even when the rear-gate safety output is off. A lathe can coast after its door demands a stop. A saw can retain blade inertia after an interlock opens. For each, distinguish guard-state observation, safety demand, actual final-element action, physical stop/hold, and maintenance isolation.

**Minimum restriction:** until the selected safety function's physical safe-state proposition is established, do not operate with people exposed to the hazard. Isolated/remote experimental work must keep people outside the danger zone and state residual risk.

## Revalidation triggers and checkpoint

Treat a guard added/removed, NC-to-electronic substitution, altered chain order, changed access frequency, new maintenance door, new safety receiver, firmware update, altered fault-reset procedure, or changed HMI status meaning as a `CHG-*` candidate. Trace `BND/HAZ -> SF/PHY -> SRS -> AUTH/DEP/ARC/HF -> VAL/PT -> CHG/UNK/RR`. Mark dependent evidence STALE until the relevant review is complete.

No lab frozen: the present Boolean observability question is resolved by standard engineering reasoning and manufacturer/standard documentary evidence. A bench observation becomes justified only for an exact selected receiver's unresolved discrepancy/fault-memory behavior after reading its authoritative manual. If justified, use only `[self-hosted, openpressbrake]` and an isolated low-energy setup; do not run a physical machine to prove a logic identity.
