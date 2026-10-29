# 4400-SCANNER-SPEED-01 — A speed-limit safety function and an encoder-discrepancy diagnostic are different propositions

**2026-10-29 | 4400 safety | second, distinct source branch after SCANNER-CASE-01 | DOCUMENTARY ONLY.** This does not establish a speed-safety function on OpenPressBrake or authorize any operation.

## Question

If a safety laser scanner is configured to monitor a speed range using two encoders, does a 60-second allowance for encoder disagreement mean that it ignores *overspeed* for 60 seconds? **Not established, and the original manufacturer text distinguishes these checks.** Confusing a discrepancy timer with the speed-limit cut-off could produce both an unjustified safety claim and an unjustified claim of a product defect.

## Exact manufacturer source and retrieval limit

**SICK AG, nanoScan3 I/O, operating instructions 8024596/1ROF/2025-03-18**, original manufacturer English PDF indexed at
https://cdn.sickcn.com/media/docs/7/37/137/operating_instructions_nanoscan3_i_o_en_im0087137.pdf .
Inspected indexed manufacturer text for **§7.14.2–7.14.4 (printed p.89)** and the **§7 CONFIGURATION / Speed** subsection, retrieved 2026-10-29. The full PDF was not downloaded/hashed, so only the cited indexed passages are **DOC-CONFIRMED**; exact page of the separate Speed subsection and full product/firmware applicability require confirmation against a stable manufacturer file. This is a **different product family and mode** from [microScan3 Core I/O case-switch timing](4400_SCANNER_CASE_01_SICK_MICROSCAN3_2025_SWITCH_TIMING_COVERAGE_GAP_AND_INPUT_DELAY_AUDIT_2026-10-29.md). Do not merge their constants or assume either is installed.

## Documentary findings with careful boundaries

| ID | OEM statement in indexed text | Supported proposition | Not supported |
|---|---|---|---|
| NS-01 | §7.14.4 `Range`: monitoring case activates if measured speed is inside configured range; static inputs can also select it. | **DOC-CONFIRMED** mode-dependent *case selection*. | No automatic independent speed-limit stop in every Range use. |
| NS-02 | §7.14.4 `Limit`: static inputs select case; scanner monitors speed; **outside configured range, safety outputs switch OFF**. | **DOC-CONFIRMED** a specific speed-range cut-off path in Limit mode. | No measured physical stopping, field geometry or machine PL/SIL. |
| NS-03 | Same `Limit` passage: scanner **ignores the two incremental encoders' different speeds for 60 seconds**, even when the difference exceeds configured tolerance. | **DOC-CONFIRMED** exact OEM caveat for the *encoder discrepancy* check in this mode. | It does **not** say overspeed is ignored for 60 seconds. |
| NS-04 | §7 CONFIGURATION / Speed: for dynamic inputs, configure pulses per distance for each encoder and tolerance as % of higher absolute speed; when they differ, the **higher speed is used**. | **DOC-CONFIRMED** calculation/parameter provenance. | Does not establish fault behavior of a disconnected or stuck encoder on a selected installation. |
| NS-05 | Same Speed subsection: discrepancy tolerance may be exceeded for time dependent on speed: at **−10 to +10 cm/s** no shutdown due to magnitude of speed disagreement; at **10–30 cm/s magnitude** up to **60 s**; at **≥30 cm/s magnitude** up to **20 s**. Opposite encoder directions above stated threshold are tolerated at most **0.4 s**. | **DOC-CONFIRMED** listed speed-dependent *discrepancy-diagnostic* behavior. | No claim that protective-field intrusion, general overspeed or all other safety faults are suppressed. |
| NS-06 | §7.14.2: on variants with multiple case tables, one case per table must be active; missing active case after startup keeps outputs OFF / waiting, and missing during operation drives outputs OFF / error. | **DOC-CONFIRMED** specific case-table state behavior. | Cannot transfer to every SICK scanner or other products. |
| NS-07 | Selected OpenPressBrake: actual scanner, encoder layout, speed thresholds, brake and safety-PLC logic are not documented by this source. | **UNKNOWN** installed behavior; TEST-CONFIRMED none. | No G0/G1 release. |

**Edition/threshold caution:** The speed bands are printed with boundary overlap in the indexed text (e.g. `+10` appears in adjacent bands, and `30` appears in both 10–30 and ≥30). Do **not** invent which timer wins exactly at 10 or 30 cm/s. That boundary requires exact full manual and/or qualified manufacturer clarification. Likewise, `Limit`'s 60-second disagreement allowance and the general speed-dependent discrepancy schedule must not be silently collapsed into one universal algorithm: the excerpts may refer to different configuration paths. Mark exact precedence **UNKNOWN** pending full source.

## Three different safety propositions

1. **Selected case:** which protective field/cut-off path is active given input and speed conditions?
2. **Speed-range response:** does the selected qualified safety function demand its outputs OFF when speed is outside the configured limit?
3. **Encoder agreement diagnostic:** when do two independently measured speed signals disagree enough, and for long enough, to demand a fault?

A scanner may implement all three with different state and timing rules. A green speed/field display does not prove (1)–(3) are configured for the intended hazard, and none proves physical machine stop/hold.

## Failure-path review (INFERENCE; no test)

- **Wrong speed mode:** an integrator assumes `Range` and `Limit` mean the same thing. The OEM text assigns different case-selection and speed-limit behavior; verify the exact configured mode and cut-off path.
- **One encoder drifts:** an integrator expects an immediate discrepancy trip. The documented mode-dependent grace may allow a temporary mismatch. Ask what independent safety function limits motion during that interval, what speed source is selected, and whether a dangerous common-cause failure exists. Do not assert a dangerous event occurred.
- **Vehicle creeps slowly:** a discrepancy-only trip may be suppressed in the documented low-speed band. A qualified risk assessment must determine whether other protective measures cover low-speed crushing/entrapment, without assuming low speed equals safe.
- **Boundary case:** an evaluator tests exactly 10 or 30 cm/s and treats a guess about which band applies as fact. Correct response is to seek exact product/firmware manual and qualified test oracle before setting acceptance.
- **Physical stop:** a speed-limit output goes OFF but gravity, hydraulic load or drivetrain coast continues. Independent final elements and actual stopping/holding witness remain necessary.
- **Human factors:** unexplained encoder-mismatch faults tempt operators to defeat a sensor. Give specific diagnostic reasons, repair access and a safe, bounded recovery workflow; do not change grace thresholds solely to suppress alarms.

## Verification and promotion

A qualified reviewer needs exact product/firmware, full manual/edition, chosen `Range`/`Limit` mode, encoder types and mounting, pulses-per-distance, tolerance and timing, selected field/cut-off mapping, safety-controller/final-element logic, and independently established physical response. Any source/runtime experiment should be **frozen only** to resolve the narrow boundary/precedence ambiguity on an isolated setup; no lab is justified here without installed or selected hardware, and a panel PC with unverified physical isolation must not be used. No source inspection of firmware, no bench test, no simulation and no independent evaluator occurred.

**Cross-machine transfer:** mobile robots/AGVs, automated cells and conveyors may use scanner speed inputs. A press brake's ram/backgauge needs its own physical safe-state and independent speed/stop design; a mobile scanner's 60-second diagnostic allowance must **never** be transplanted as a press-brake safety parameter.

**Evidence:** DOC-CONFIRMED exact OEM indexed excerpts; INFERENCE failure-path and mode-discriminator reasoning; UNKNOWN full-file revision hash, exact threshold precedence, installed hardware, stop/hold; SOURCE-CONFIRMED none for proprietary firmware; TEST-CONFIRMED none. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Independent 2520–25F0 evaluation OPEN. GitHub-hosted/local lab compute **0 minutes**.
