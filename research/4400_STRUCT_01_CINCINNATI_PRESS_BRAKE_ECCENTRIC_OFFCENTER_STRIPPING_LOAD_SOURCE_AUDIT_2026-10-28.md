# 4400-STRUCT-01 — Press-brake rated tonnage does not bound eccentric, off-center, or reverse stripping loads
**2026-10-28 | Original manufacturer source-depth | 4400 safety | NON-GRADUATED / documentary only**

## Concrete question and predecessor check

Can a correctly synchronized Y1/Y2 press brake with a valid global tonnage setpoint still break a bed/die-clamp/ram attachment because the job is offset, or because the force acts upward rather than downward? **Yes, as a manufacturer-documented failure mechanism on the cited Cincinnati PROFORM family; not a demonstrated OpenPressBrake failure.** The existing [TOOL-LOAD-03](4400_TOOL_LOAD_03_WILA_LOCAL_TOOL_LOAD_DISTRIBUTION_AND_VERTICAL_HANDLING_SOURCE_AUDIT_2026-10-26.md) establishes **local punch/holder force per engaged length** and already names off-center loading as a check. TOOL-RET-01/02 establish tooling capture, FORM-HAZ-04 covers fracture/workpiece motion, HYD-01 covers ram hold. This investigation adds **three independent machine-structure load capacities and a new physical witness**, not a new generic tool-load lesson: (1) lateral off-center location, (2) front-to-back eccentric moment, and (3) **reverse-direction stripping on the UP stroke**. An OEM warning ties excessive moment to fractured attachment bolts and a loosened bed.

## Original evidence, edition, inspection method

**Cincinnati Incorporated, EM-519 (N-08-19), _400–2000 PROFORM Hydraulic Press Brake Operation, Safety, and Maintenance Manual_**, ©2019, title page states **machines built after 2018-01-01**, [manufacturer-hosted original PDF](https://wwwassets.e-ci.com/PDF/Manuals/em-519_n-08-19_proform__400-2000_hydraulic_press_brake_osmm.pdf). Inspected searchable original PDF and rendered printed pp. **4-7 and 4-8** (PDF pages 39 and 40, zero-based 38 and 39), with adjacent capacity context printed p. 4-6. **DOC-CONFIRMED for this specific OEM family/edition**, not a selected OpenPressBrake rating, not a licensed ISO 6909 requirement.

1. **Upstroke/reverse stripping:** Printed p. 4-7 defines stripping force as occurring on the ram **UP stroke**, down on ram and up on bed, opposite the forming/punching load. The 400 PF example has a separate **27 US ton** stripping limit while the machine has a **400 US ton** nominal bending rating. The same page states **machines with bolt-on noses are NOT rated for stripping capacity**. Do not generalize the 27-ton value or infer that all other machines have a permissible stripping mode.
2. **Front-to-back eccentric moment:** Printed p. 4-7 Figure 4-6 defines offset distance `d` between load and machine centerlines and force `L` (in tons), requiring `d × L` not to exceed the **machine-model-specific eccentric capacity**. The figure gives a 400 PF example of **230 inch-tons**. For machines with bolt-on ram noses, the manual says allowable eccentric load also depends on **length of load/part** and to consult the factory. This is a **moment limit**, not the tool's kN/m rating.
3. **Left-to-right off-center derating:** Printed p. 4-8 Figure 4-7 gives a separate **location-dependent machine force envelope**. In the 400 PF example, full nominal 400 US tons is at the centerline, but at either housing the manual gives **50% / 200 US tons**. At 0.3 of the housing span from center, its example is **62% / 248 US tons**. These are **Cincinnati model-specific**, not a universal 50%-at-the-end rule, and not a verified envelope for OpenPressBrake.
4. **Consequences are physical:** The red DANGER warning on printed p. 4-8 says exceeding eccentric capacity can overload bed, die-clamp and ram-nose bolts, leading to fracture and serious injury; slides/guides and bed connection can also be damaged. **An encoder reporting synchronized Y1/Y2 is not a witness that those structural load paths remain within their limits.**
5. **Notation/units ambiguity:** Figure 4-6 uses `L` for **load force**; Figure 4-7 uses `L` for **housing span**. The metric parenthetical for the 230 inch-ton entry is printed `(51,973)` under a header resembling `m-kN`, not an unambiguous SI conversion. **Do not transfer the printed metric column into a calculation without manufacturer clarification**. The original inch-ton figure is recorded as printed, not applied.
6. **Different physical failure path from TOOL-LOAD-03:** A tool may satisfy its **uniform per-length** rating while the **frame moment** is exceeded; conversely a frame may be within its envelope while a short punch/holder is overloaded. The upstroke stripping condition cannot be certified by a downstroke force rating. All limits must be checked for the actual job and exact machine.

The earlier Cincinnati [EM-506 (R-02-13)](https://wwwassets.e-ci.com/PDF/Manuals/EM-506.pdf) and [EM-444](https://wwwassets.e-ci.com/PDF/Manuals/EM-444.pdf) manufacturer PDFs also contain off-center/eccentric warnings in search-indexed excerpts; their full originals were **not** inspected here (EM-506 fetch exceeded tool size), so they are corroborative **DOC-CONFIRMED (INDEXED-ONLY)** and their numeric charts are **not** imported.

## Hazard-to-physical-witness matrix (not an operator procedure)

| Proposition | Unsafe proxy | Independent documentary/physical evidence needed | State |
|---|---|---|---|
| Job force is within **left-right location-dependent machine envelope** | Nameplate tonnage; CNC global force setpoint; Y1/Y2 level display | Exact as-built press model/manual/ram/bed/guide/bolt variant; qualified load-center and OEM location-derating assessment; inspected structure/attachments | UNKNOWN selected machine |
| Job is within **front-back eccentric moment** | Correct die length or punch kN/m label | Exact load line, machine centerline, part length and model-specific moment limit; OEM confirmation for bolt-on nose variants | UNKNOWN |
| Upstroke/tool release is within **reverse stripping capacity** | Downstroke forming rating; `motion complete` bit | Whether the job actually produces reverse stripping, exact nose construction and OEM stripping rating/permission; no unapproved upstroke extraction | UNKNOWN |
| Tool/holder remain safe | Machine structural ratings alone | Existing TOOL-LOAD-03 exact tool/holder/adapter engaged length and load distribution | UNKNOWN |
| Personnel are protected from breakage/ejection | Controller in position; guard-closed input | Actual fracture/ejection exposure geometry, properly retained physical guards, independent Y1/Y2 stop/hold and no auto-restart | G0/G1 HOLD |
| After damage or setup change, previous validation remains valid | No alarm, recipe unchanged, encoder zero | `CHG` review of altered tool, bed/nose, loading position, load direction, foundation/fasteners, qualified inspection and safe restart | UNKNOWN |

## Architecture and human-factors implications

- **Normal control:** LinuxCNC/FPGA can track programmed force, part location, selected tool and estimated bending loads, warn/block ordinary jobs, and retain change history. **Do not claim an ordinary software limit is a personnel-safety-rated force limiter**. Its value is practical error prevention and easier correct setup.
- **Independent safety-related control:** Continue to require actual independent stop/hold/guard/restart functions from selected safety equipment. A safety-rated stop **cannot retroactively prevent** a structural overload that occurred before stop; mechanical capacity/guard design is a separate prerequisite.
- **Physical mechanism:** Ram/bed/bolts/tooling/part geometry and actual reaction forces determine breakage risk. A safe stop command, synchronized axes, or low pressure readback does not independently prove those structures are intact.
- **Foreseeable shortcut:** A technician uses a short die far left, reads only total machine tonnage, and sees green Y1/Y2 alignment. Make correct load-center/force-direction checks part of a short, legible, job-setup tool with model-specific data and a clear **unsupported/unknown** state, rather than burying an inaccessible manual. Do not let operators substitute a made-up generic curve.
- **No-person-exposure rule:** If the exact machine structure, tool and guard capacities are unknown, do not use this OEM chart as authorization to run the selected press brake with people exposed. Any justified experimental operation requires separate qualified isolation/remote planning, restraint, exclusion and residual-risk review.

## Provenance and validation status

- **DOC-CONFIRMED:** Cincinnati EM-519 2019, pp. 4-7/4-8, distinct structural moment, off-center, reverse stripping and bolt-on nose conditions; original PDF text and page renders inspected.
- **DOC-CONFIRMED (INDEXED-ONLY):** EM-506 and EM-444 excerpts only; no full-document claim.
- **INFERENCE:** global-force/encoder proxy failure; multi-limit selected-job acceptance and human-factors integration.
- **UNKNOWN:** actual OpenPressBrake press/ram/bed/nose model, centerline, structure, any rated curves, tool load, stripping operation, physical condition, applicable legal edition, actual independent safety controller and validation.
- **TEST-CONFIRMED:** none. No experiment, machine operation, simulation, build, benchmark or evaluator. Hosted compute **0 min**; self-hosted **0 min**. No laboratory ledger update.
- **Graduation:** **NON-GRADUATED**, external 2520–25F0 evaluator still NOT RUN, **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**.

## Incremental next witness and work-selection decision

Use **existing Stage A A/B/D/E/F/G** (machine identity, structural/hazard geometry, actual load and tooling, physical guarding, qualified SRS, isolated proof logistics), with the existing Stage B tooling request only if applicable. Do **not** add another owner questionnaire. The **incremental physical witness** is machine-specific **three-direction structural load suitability and actual bed/ram/nose/fastener condition**, separate from Y1/Y2 motion and tool segment capacity. If absent, this branch reaches an information-gain stop and returns to selected Pilz/AKAS, independent physical stop/hold and evaluator gates. Never infer a numerical OpenPressBrake rating from Cincinnati.


## Dimensional cross-check of the OEM metric-column label (INFERENCE, not a replacement rating)
For the printed **400 PF 230 inch-ton** entry, using the standard US short-ton-force conversion (approximately 8.89644 kN per ton-force) and 25.4 mm/in gives `230 × 8.89644 × 25.4 ≈ 51,973 kN·mm`. This agrees numerically with the manual's parenthetical **51,973**, while `51,973 kN·m` would differ by a factor of 1,000. The rendered header appears `(m-kN)`, not a clear `(mm-kN)`; therefore the *plausible intended unit* is **kN·mm** (**INFERENCE from dimensional consistency**), but **do not silently relabel the original**, derive an OpenPressBrake limit, or use the metric column for safety decisions without an OEM-verified revision. This is an example of a source-critical-reading discriminator rather than a numerical machine calculation.
