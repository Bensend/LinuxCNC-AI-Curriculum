# 4400 safety source audit — three-position press-brake foot pedals and restart authority (2026-10-23)

**Evidence state:** manufacturer catalogue = `DOC-CONFIRMED` for the listed contact diagrams; application fault paths = `INFERENCE`; exact selected pedal/controller behavior, machine safe state and measured stopping = `UNKNOWN`. No machine test was performed. This is a learner-visible source study, not a hidden evaluation key.

## Exact manufacturer source and page witnesses

Fiessler Elektronik, *Foot-pedals / Safety foot-pedals*, PDF `prd-fe-fs-engl-doc1908.pdf`, manufacturer URL: https://www.fiessler.de/default-wAssets/docs/download/FE-FS/prd-fe-fs-engl-doc1908.pdf . The PDF is 24 pages. **PDF page index 9 / printed page 10** describes `FE-FS1-SU1ASDO2-U-XX`; **PDF index 17 / printed page 18** describes `FE-FS2-SU1ASDO2/SU1ASDO2-U-XX`. Both switching diagrams were visually inspected on 2026-10-23. This is a *catalogue family*, not the selected-machine installation manual. The manufacturer lists numerous other pedal models with different contact arrangements; do not transfer the following terminals to them.

For the **single-pedal FE-FS1-SU1ASDO2-U-XX** printed switching diagram:

| Contact pair | Released/free | Working pressure point | Fully depressed beyond pressure point | Function shown |
|---|---|---|---|---|
| 13–14 | open | closed | open | ordinary working NO |
| 21–22 | closed | open | closed | ordinary working NC |
| 11–12 | closed | closed | open | positively opening safety NC |
| 31–32 | closed | closed | open | second positively opening safety NC |

The **double-pedal FE-FS2-SU1ASDO2/SU1ASDO2-U-XX** drawing depicts a corresponding three-state pattern for *each* pedal, with its two safety NC contact pairs labeled **31–32 and 41–42**. The catalogue explicitly warns that left/right contact identity must be made clear during circuit-diagram creation. A two-pedal *housing* is not automatically a validated two-operator control scheme; that requires the actual architecture and task allocation.

The manufacturer states that a new machine start is possible only after pedal release. **This is a product/application description, not proof of a particular safety controller's anti-repeat implementation.** A safe machine requires evidence that the relevant independent safety-related controller sees and acts on the correct overtravel safety channels and that any separate ordinary start/hold command cannot bypass that response.

## Documentation contradiction — do not implement prose literally

The same catalogue repeatedly says that crossing the pressure point activates the safety contact to *initiate* hazardous movement. That wording contradicts its own statements that the safety contacts are for stopping, the working contacts return to their initial states on overtravel, and the printed safety NC contacts **open** at full depression. Treat the wording as a **manufacturer-document inconsistency**, not a command to energize motion. Obtain the exact selected-product safety instructions and wiring/receiver confirmation before any physical installation. The switching diagram is a stronger depiction of the published contact state, but still not a measured physical-machine response.

An indexed extract of a separate Fiessler AKAS-3PF operating manual (document 1379, 2017-01-27; a historical manufacturer-hosted PDF path currently redirects, so the complete original was **not independently inspected in this session**) reports a potentially important architecture-dependent monitoring difference: in modes without an additional safety PLC, it describes AKAS foot-pedal monitoring using the opposite `FUS` and `FUO` input states; in a mode with an additional safety PLC, the foot-pedal monitoring in AKAS may be disabled and that safety-control responsibility belongs elsewhere. Treat that report as **UNKNOWN pending full selected-manual verification**, not as a verified implementation contract or evidence that any current OpenPressBrake installation has this wiring. Do not rely on an AKAS input indicator to establish pedal fault detection if the selected mode delegates that function.

## Independent manufacturer cross-check resolves the prose conflict

Fiessler's current official English **Safety foot pedals FE-FS** product page explicitly says that passing the pressure point initiates a **machine stop**, and restart requires full pedal release: https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php (retrieved 2026-10-23). This agrees with the catalogue's *contact diagrams* and contradicts its repeated sentence about *initiating hazardous movement*. **DOC-CONFIRMED:** the sources disagree; the current product page supports the stop interpretation. This improves the documentary conclusion but does not qualify an actual safety-related input chain, stop time or physical response. Keep the original contradiction visible as a provenance lesson.

The same current manufacturer page describes an optional **FMSC-FP** interface with selectable **pedal 1 only, pedal 2 only, pedal 1 OR pedal 2, and pedal 1 AND pedal 2** modes, and diagnostic outputs for selector hardware, foot-pedal hardware and relay monitoring. This is **DOC-CONFIRMED existence of configurable mode semantics**, not evidence of the installed circuit's selected mode, diagnostic coverage, exact timing or achieved PL/SIL. The physical two-pedal housing in the catalogue and two *separate* operator pedals connected through FMSC-FP are different configurations. An OR/AND change can materially change who can initiate motion and which person must maintain a hold-to-run input; it is a safety-requirements and change-validation event, not a convenience HMI setting. Record exact physical pedal/zone/worker mapping, selector key/authority, diagnostic handling, and retained-start/rearm behavior in `BND/HAZ/SRS/AUTH/DEP/HF/ARC/VAL/CHG` before granting safety-function credit.

**FMSC-FP source-level interface refinement:** Fiessler, *FMSC switching device* brochure, printed p. 5 / PDF page index 5, dated **2025-10-15**, manufacturer PDF: https://www.fiessler.de/default-wAssets/docs/download/FMSC-Schaltgeraete/prd-fmsc-switching-device-engl-doc1872-comp.pdf . The original page and its example connection diagram were visually inspected. It depicts selector `S0`, restart button `S1`, pedal devices `S2`/`S3`, monitored relays `K1`/`K2`/`K3`, safe outputs `SO1`–`SO4` and message outputs `O1`–`O5`. It explicitly assigns separate diagnostic messages to selector-mode error (`P1`), pedal-contact errors (`P2`, `P4`) and **restart-button request** (`P3`). **DOC-CONFIRMED:** a restart *request indication* is not a safety reset acceptance, and an example diagram is not proof that an actual retrofitted machine implements these mappings. The same brochure's mode list mistakenly says "only foot pedal 3" while the paragraph, other modes and current manufacturer product page identify pedals 1 and 2; record that as another document inconsistency, not a third installed pedal. The brochure claims a SIL 3/PL e *device hardware design* on its printed technical-data page; that claim must not be transferred to the complete machine safety function. Its general electrical data reports no galvanic isolation for its inputs/outputs, reinforcing the need to analyze shared reference and supply paths for the actual selected design. Exact hardware revision, firmware/configuration, selector behavior, output load, diagnostics, stop time and restart state remain UNKNOWN.

**Mode-switch adversarial case:** the HMI displays TWO OPERATORS, but a hardware selector or FMSC-FP mode is actually `pedal 1 OR pedal 2`. A single pedal can satisfy an ordinary request despite the operator believing both are required. Whether this produces hazardous motion depends on the selected machine's independent safety logic and other safeguards; do **not** invent that behavior. The safe design requires unambiguous mode indication, controlled mode selection, independent confirmation of the selected safety function, and verification that each expected pedal can individually demand the required protective stop. A stale HMI label or ordinary LinuxCNC status is not a mode-authority witness.

### Boolean policy counterexample (reasoning, not a device simulation)

If the selected safety requirements demand **both** operators maintain an enabling input, but the selector is in an **either**-pedal policy, the mismatch is visible before any physical experiment:

| Pedal 1 active | Pedal 2 active | Abstract OR request | Abstract AND request |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 1 | 1 | 1 |

This truth table is an **INFERENCE** about ordinary Boolean OR/AND policy, **not** a claimed FMSC-FP internal implementation or validation result. It proves that a mode label or switch selection can materially change who is permitted to initiate a cycle. It does not prove what happens on either pedal's overtravel, whether the other operator is protected, whether a physical stop occurs, or what diagnostic coverage is achieved. Those require the selected controller safety application and actual machine evidence. A two-pedal assembly used by one person is not equivalent to two separate operators with independent controls.

## Authority and failure-path analysis

Separate these functions:

1. **Ordinary cycle request / hold-to-run** — LinuxCNC or the machine controller may consume working contact signals and request normal motion. This is not, by itself, personnel-safety authority.
2. **Safety-related overtravel / stop demand** — selected safety contacts, monitored by the independently justified safety-related system, should demand the specified protective response. The contact diagram does not prove controller diagnostics or final-element response.
3. **Deliberate reset/rearm** — return of the pedal to free state, clearing of an input, acknowledgement/reset, and issuance of a *new* ordinary cycle start are different events. The controller's reset/anti-repeat requirements must be documented and verified.
4. **Physical final element / safe state** — actual valve, drive, brake, restraint and beam stopping/holding must be evidenced separately; electrical contact opening is not a measured stop.
5. **Maintenance isolation** — an overtravel pedal is not a lockable isolation or stored-energy discharge mechanism.

| Adversarial path | What an observer might falsely infer | Evidence needed / safe handling |
|---|---|---|
| Working NO 13–14 stuck closed | A new intentional pedal press occurred | Independent pedal state/transition, release-required start logic and fault response; do not accept retained start after safety reset. |
| One safety NC channel welded or shorted | Two safety channels are independent because two terminals exist | Actual separate channel routing, cross-fault diagnostics and final-element response for the selected controller. |
| Pedal jammed between operating and overtravel points | Pedal is released because an HMI shows no start | Actual mechanical return, each contact state and receiver diagnostics; keep motion inhibited while unresolved. |
| Pedal pushed past pressure point | Overtravel itself mechanically stops the ram | Witness the independent safety demand, final element and actual ram response; catalogue contacts do not prove stopping. |
| Left/right contacts swapped in double housing | Both operators/devices are correctly identified | Physical mapping, per-device demand and application-specific simultaneous/individual participation. |
| AKAS mode delegates pedal monitoring to external safety PLC | AKAS indicator proves pedal monitoring is active | Exact mode/firmware, configured safety PLC input allocation and validated fault response. |
| Reset with pedal still held / ordinary start retained | Reset accepted means a fresh start is authorized | Separate release/rearm/new-start events, deliberate reset and physical safe-state qualification. |
| Foot pedal nuisance trips / hard-to-reach pedal | Bypassing is the only way to maintain production | Relocate/reconfigure with proper guard/foot ergonomics, clear diagnostics, easy cleaning and guarded, captive wiring; never reduce protection silently. |

## Practical human-factors and verification requirements

The catalogue lists a **model-specific minimum 200 N force at the pressure point** for the selected model; this is not a universal force criterion. Verify actual ergonomics, protective hood geometry, mounting, cable strain relief, access for cleaning, and whether a reasonable operator can distinguish working travel from overtravel without repeated nuisance stops. A device whose normal use makes defeat attractive is a design problem. Do not remove the protective hood or bridge contacts to make operation easier.

Paper/isolated-low-energy validation first: record exact part number, contact arrangement and physical terminal identity; verify released / working / overtravel transition with the selected controller safely disconnected from hazardous final elements. Machine commissioning requires a qualified plan, personnel outside the danger zone until protective functions are proven, and actual independently witnessed final-element and physical stopping/holding behavior. Do not assign a stopping distance, diagnostic coverage, PL/SIL, response time or anti-repeat integrity from a catalogue diagram.

## Cumulative Safety Design Package links

- `BND/HAZ`: operating mode, operator(s), pedal placement and workpiece/helper exposure.
- `SRS/PHY`: separate ordinary hold-to-run, overtravel stop, deliberate rearm/new start and actual machine stopping/holding.
- `AUTH/ARC`: ordinary LinuxCNC command vs independent safety input/logic vs physical final element.
- `DEP`: shared wiring, mechanical switch assembly, common 24 V/0 V, receiver input resources, mode configuration, pedal identity.
- `HF`: nuisance-trip pressure, accidental activation, difficult guard/hood reinstall, cleaning/diagnostics.
- `VAL/PT`: contact-state observation is only one layer; include held start, overtravel, stuck channel, wrong pedal mapping, power restoration, final-element and physical witness.
- `CHG/UNK`: any pedal variant, switch replacement, rewiring, monitoring-mode or controller change invalidates affected evidence until reviewed.

**No machine-safe-to-operate conclusion.** If the minimum physical safety function has not been established, no personnel-exposed hazardous operation; any experimental work isolated/remote with people outside the danger zone and residual risk stated explicitly.
