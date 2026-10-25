# 4400-TEACH-01 — A successful blanking teach-in can restore OSSDs without a separate reset; blanking can change response time
**2026-10-25 | direct original manufacturer manuals | DOC-CONFIRMED within exact editions | NOT selected-machine proof**

## Research question
When a technician teaches a new obstruction into a safety curtain, is the successful teach-in itself equivalent to deliberate machine restart authorization? Does changing blanking merely alter detection geometry, or can it also change the time available to stop? Both distinctions matter even if the normal HMI remains unchanged.

## Original manufacturer evidence — exact editions
1. **SICK AG, deTec4 HG Operating Instructions, document 8023856/1SWC/2026-02-05**, original manufacturer PDF https://www.sick.com/media/docs/5/75/275/operating_instructions_detec4_hg_en_im0082275.pdf . Direct text inspection of printed pp.72–81 (PDF pp.71–80), particularly §§4.3.8, 4.3.8.1 and 4.3.8.5. **DOC-CONFIRMED** for the deTec4 HG and described DCM4/DMM4 configurations, not every deTec4 or other curtain.
2. **Rockwell Automation, GuardShield Micro 400 Safety Light Curtains Installation Instructions, 445L-IN005C-EN-P, January 2024**, original manufacturer PDF https://literature.rockwellautomation.com/idc/groups/literature/documents/in/445l-in005_-en-p.pdf . Directly inspected printed pp.1–6 (PDF pp.0–5), including p.5 response-time and configuration warnings. **DOC-CONFIRMED** for the Micro 400 + compatible controller; not transferable to the SICK device.
3. **Rockwell SafeShield Safety Light Curtain Hardware User Manual, 442L-IN002-EN-P**, original manufacturer PDF https://literature.rockwellautomation.com/idc/groups/literature/documents/in/442l-in002_-en-p.pdf , printed pp.14–17 (PDF pp.13–16). Confirms that a blanked region is an unprotected hole needing a separate risk analysis and alternative protection, not a license to rely on a green OSSD.
4. OSHA's official powered press brake eTool https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes and 29 CFR 1910.217(a)(5) https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217 . OSHA 1910.217 excludes press brakes; do not transfer mechanical-power-press PSDI clauses as binding press-brake requirements. Machine-specific applicable safeguarding still requires independent review.

## Finding A — teach-in may reactivate the protective output (SICK §4.3.8.1, printed p.77)
**DOC-CONFIRMED:** SICK says the OSSDs are OFF during the teach-in procedure. After successful teach-in the system **automatically starts with the new configuration**, which is permanently stored. **If no restart interlock is configured, the OSSDs switch ON.** A failed teach-in retains the prior configuration; starting teach-in with no object can deactivate fixed blanking. The manufacturer requires an access-controlled manipulation-protected switch (e.g. key-operated) and a post-teach-in test-rod check. This is a *protective-output state*, not proof that a downstream safety PLC re-enables motion or that a press brake automatically strokes. It is a new failure discriminator: **configuration acceptance, protective output ON, safety-chain rearm, and fresh motion request are four different events.**

## Finding B — blanking can change both resolution and response time (Rockwell 2024 p.5)
**DOC-CONFIRMED:** Rockwell states that enabling blanking on the Micro 400/MSR42 changes effective resolution **and system response time**; it instructs using the new longer response time and larger resolution in safety-distance calculations and updating receiver labels/configuration records. The total response time of cascaded Micro 400 systems includes individual segment delays and controller/other safety device time; the OEM also warns controller configuration can delay response. The published example is **not** a universal machine stopping time. A field may pass a test rod yet be mounted too close to a moving hazard after reconfiguration. SICK's 2026 instructions separately require using the lowest effective resolution over configured modes/tolerances for separation review; do not assert SICK's response-time change equals Rockwell's without checking its exact configuration.

## Finding C — monitoring an object does not close a reach-through aperture
**DOC-CONFIRMED:** SICK 2026 pp.72–73: blanked area is not protective field; blanked objects must remain as expected; unexpected absence turns OSSDs OFF for the specified monitored blanking. It calls for mechanical protection of access gaps or consideration in minimum-distance assessment and test-rod verification after each change. SICK pp.79–80 distinguishes fixed blanking **without** size tolerance (effective resolution unchanged in remaining field) from configured size tolerance (effective resolution at edges may degrade). An unchanged number for effective resolution does **not** mean the physical aperture has disappeared. Rockwell SafeShield pp.14–17 independently reinforces the hole/guard requirement.

## Failure-path and authority ledger
| Scenario | Evidence | Safety-relevant consequence / remaining uncertainty |
|---|---|---|
| Teach-in succeeds, no restart interlock | SICK 2026 p.77 **DOC-CONFIRMED** | OSSD can go ON without a new reset. Downstream motion is **UNKNOWN** and must be independently inhibited until a fresh command. |
| Teach-in with empty field | SICK 2026 p.77 **DOC-CONFIRMED** | Fixed blanking can be deactivated; changes coverage/availability, requires controlled verification. |
| Fixture absent during monitored fixed blanking | SICK 2026 pp.72–74 **DOC-CONFIRMED** | OSSD OFF is expected for this variant; does not prove ram stopped or held. |
| Fixture remains but reachable side slot exists | SICK 2026 p.72 and Rockwell SafeShield p.14 **DOC-CONFIRMED** | A green field can coexist with an unprotected reach aperture; independent barrier/geometry assessment needed. |
| Micro 400 blanking enabled without remounting/recalculating | Rockwell 2024 p.5 **DOC-CONFIRMED** | Response time and resolution may both worsen; old protective distance becomes stale. |
| Two cascaded curtain segments share OSSD | Rockwell 2024 pp.2,5 **DOC-CONFIRMED** | Segment/controller response contributions require full chain review, not sensor label alone. |
| HMI records accepted teach-in and issues start | **INFERENCE** | Normal LinuxCNC/FPGA indication is not personnel-safety authority; fresh-start interlock must be independent. |

**SOURCE-CONFIRMED new LinuxCNC:** none claimed. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** installed OpenPressBrake sensor, exact blanking/teach-in wiring, output-to-final-element chain, Y1/Y2 independent stopping and gravity holding, stored hydraulic pressure, guard/side access, measured stop time, PL/SIL and fresh evaluator outcome.

## Safe-by-default integration and human factors
- Prefer fixed hard barriers with captive/easy-reinstall retainers at fixture slots, rather than allowing operators to repeatedly re-teach a curtain just to complete normal work.
- Put any authorized teach-in control in a deliberately controlled setup mode, visibly identify affected protection zones, and make test-rod/physical-gap review a simple mandatory change step. A key alone is not a complete safety design.
- Keep a separate safety-rated restart interlock where required, and a **fresh ordinary motion command** after rearm. Neither is satisfied by a successful teach-in or OSSD ON.
- Show the active mode, effective resolution, protection holes and configuration revision to technicians; diagnostics inform but cannot authorize safety.
- Reassess total sensor + logic + final element + measured machine stopping behavior when blanking, cascade, firmware, controller settings or guard geometry changes.
- Never use a person's hand to probe a moving press. Any selected-machine acceptance requires qualified isolated methods, appropriate test objects, and independent physical stopping/holding proof.

## Information-gain / experiment decision
Original manufacturer documents resolve the narrow device-state and configuration questions. A synthetic lab cannot prove actual press-brake Y1/Y2 stopping, hydraulic load holding or field geometry. **No simulation or GitHub Actions compute justified.** A future lab may be frozen only for a new unresolved exact control-interface question and must target `[self-hosted, openpressbrake]` exclusively. Selected machine G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed operation authorized.

## Transfer limits
The 2016 SICK C4000 and older Rockwell SafeShield studies in the course remain preserved; do not assume their floating-object semantics, 2026 deTec4 teach-in behavior and 2024 Micro 400 timing changes are interchangeable. Reopen only for exact installed variant/firmware, qualified measurements, or independent external evaluation. This research is **NON-GRADUATED** and not a selected-machine safety release.
