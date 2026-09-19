# Press-brake valve disagreement -> next-cycle inhibit trace

Date: 2026-09-19

## Purpose

Close a specific hydraulic press-brake safety evidence gap without inventing a machine-specific hydraulic truth table: what can be asserted when commanded solenoid state and monitored valve state disagree, and what authority remains afterward?

## Evidence

### Lazer Safe PCSS-A valve-monitoring implementation

**DOC-CONFIRMED.** Lazer Safe PCSS-A Additions Technical Manual rev. 1.18 (released 2024-09-12) exposes press-brake valve-monitoring options that compare solenoid/output states with normally-closed monitor contacts. Option 36 covers safety, prefill and proportional valves. Its fault table marks both a switch-off disagreement (command/off pattern but monitor contacts do not show the expected off state) and a switch-on disagreement as `Valve Fault` for all or any monitored valves. Option 37 similarly monitors safety and proportional valves individually.

Source: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/LS-CS-M-047-PCSS-A-Additions-Options-Manual-1.18.pdf, pp. 55-57 / tables 7-6 and 7-8.

**DOC-CONFIRMED.** The PCSS-F/L technical manual gives the machine-level disposition missing from the compact tables: each monitored solenoid state is checked against the associated down-enable output; if the states differ from expected for a prolonged period, a turn-off or turn-on fault is flagged and an emergency-stop condition occurs. The auxiliary-axis or emergency-stop output is switched off, preventing further press-brake operation until the problem has been resolved.

Source: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/ls-cs-m-007-pcss-f-and-l-series-technical-manual-1-66.pdf, valve-monitoring chapter 14.

### EN 12622 behavior captured in PLCopen press extension

**DOC-CONFIRMED, secondary standards quotation.** PLCopen TC5 Safety Part 4 reproduces the EN 12622 press-brake failure behavior: the redundant/monitored press control uses two separate functioning systems, either independently capable of stopping hazardous movement; failure of either is detected and another closing stroke prevented. Its reproduced 5.2.5.2 failure behavior says the next production cycle is prevented until the fault is eliminated.

Source: PLCopen TC5 Safety Part 4 — Extension for Presses, official release 2013-12-16, p. 42, quoting EN 12622:2009 / DIN EN 12622:2010-04.

## Engineering conclusion

The combined evidence supports this safety-course freeze:

**VALVE COMMAND EXPECTED STATE != VALVE MONITOR EXPECTED STATE -> SAFETY FAULT / EMERGENCY-STOP REACTION -> FURTHER PRESS OPERATION INHIBITED.**

And separately:

**FAULT DETECTED != FAULT ELIMINATED != REQUIRED PHYSICAL FUNCTION RE-PROVED != SAFETY REARM != FRESH PRODUCTION INITIATION.**

The first chain is documentation-confirmed. The second chain intentionally separates authorities; the public Lazer Safe evidence establishes inhibit-until-resolved, but it does not by itself define the complete repair/revalidation/rearm sequence for every OEM press brake.

## Why companion valves may not mask proof

The PCSS option tables expose monitor inputs for the individual relevant valve groups/axes rather than accepting only a single aggregate `hydraulics OK` bit. A disagreement on *any* monitored valve is classified as a valve fault. Therefore a healthy companion valve does not make an explicitly monitored failed valve's electrical/position witness valid.

**DOC-CONFIRMED:** individual monitor disagreement is detected as a fault.

**INFERENCE:** this is the correct architectural reason not to treat continued physical retention by another valve as proof that the failed monitored element is healthy. It does not establish the exact hydraulic load disposition for every press-brake circuit.

## Physical-hazard boundary

Valve-monitor feedback is final-element switching-state evidence, not complete physical-hazard evidence. It does not alone prove:

- ram velocity is zero;
- the ram/load is mechanically or hydraulically retained;
- pressure has decayed to a task-safe value;
- stored hydraulic energy is absent;
- stopping distance/time remains valid;
- personnel access is safe.

Those propositions require their own witnesses/validation. Existing course evidence from BAYKAL/HAWE already keeps measured stop performance, beam holding and stored hydraulic energy separate from the electrical command chain.

## LinuxCNC/OpenPressBrake boundary

For a LinuxCNC retrofit, ordinary LinuxCNC/HAL or the normal FPGA may display the valve fault, inhibit ordinary commands redundantly, and require a fresh operator command after safety authority returns. They must not be the sole authority that decides a monitored hydraulic safety-valve disagreement has been repaired or that the safety function may be rearmed.

A practical safe architecture makes the inconvenient shortcut impossible: a failed monitor does not become an HMI warning that the operator can dismiss to continue bending. If the required safety proof cannot be restored, do not operate with personnel exposed; any diagnostic movement must be under a separately justified safe setup/service mode or isolated/remote conditions appropriate to the residual hazard.

## What remains UNKNOWN

Public evidence reviewed here does **not** establish a universal press-brake sequence for:

1. exact physical ram/load disposition after each possible individual valve failure;
2. whether hydraulic pressure must be dumped or retained for a particular failure;
3. exact OEM repair steps;
4. which individual valve/restraint proofs must be repeated after replacement;
5. whether stop-time/overrun measurement must be repeated after every valve-related repair;
6. exact reset/rearm sequence after repair.

Do not invent these. Seek an OEM/service or safety-system manual that exposes the post-repair commissioning sequence.

## Commissioning/adversarial tests to preserve

Without assigning invented timing or pressure thresholds, a professional validation plan should challenge at least:

- command ON / monitor remains OFF;
- command OFF / monitor remains ON;
- one Y-axis/valve monitor fails while its companion appears healthy;
- monitor wiring stuck in the expected state;
- valve electrical/monitor state appears correct but measured ram stopping performance is unacceptable;
- fault is acknowledged without physical repair;
- repair is completed but required re-proof is skipped;
- stale ordinary START/foot-pedal state exists when safety authority returns.

Expected curriculum result: disagreement removes further production authority; acknowledgement is not repair; companion success does not erase an individual monitor fault; physical stop/load safety needs independent evidence; return of safety authority must not convert stale ordinary intent into a new cycle.

## Next evidence target

Find an OEM or professional safety implementation that explicitly joins:

`individual monitored hydraulic valve disagreement -> physical ram/load-safe disposition -> fault retention -> repair/replacement -> required valve/restraint/stop-performance re-proof -> safety reset/rearm -> separate fresh production initiation`.

Prefer a hydraulic press brake and direct manufacturer/service documentation. Do not transfer a pneumatic/mechanical-press truth table into hydraulics.
