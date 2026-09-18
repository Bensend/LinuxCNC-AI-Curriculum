# Hydraulic Final-Element Disagreement / Fail-Safe Trace — 2026-09-18

Session start: **2026-09-18T23:36:42Z UTC**

## Question

What can authoritative hydraulic safety evidence establish about the path from a safety demand through redundant/monitored hydraulic final elements when one element disagrees with the commanded safe state, and what must remain unclaimed for a hydraulic press brake?

## Evidence

### HAWE press-brake system evidence

**DOC-CONFIRMED.** HAWE's current press-brake application material states that reliable holding of the press beam, minimum switching time/short overtravel, and safe monitoring of individual functions are press-brake requirements. HAWE defines switching-position monitoring as monitoring the position of a valve switching element, typically by proximity sensor or displacement transducer, with a press safety valve as a typical application.

Sources:
- https://www.hawe.com/applications/manufacturing-efficiency/press-brakes/
- https://www.hawe.com/nl-nl/fluid-lexicon/detail/switching-position-monitoring/

**DOC-CONFIRMED — stronger same-system evidence.** Current HAWE product documentation D 6335 for SAKB exposes a monitored press-brake variant directly. Type `S` is the valve-monitoring version. The current document states that the **two proportional directional valves, two holding valves, and the 4/2-way directional valve are equipped with position monitoring**. This materially strengthens the earlier generic product-page evidence because it identifies multiple monitored hydraulic final elements inside the actual press-brake control system.

Source: https://productfinder.hawe.com/downloads/D6335-en.pdf

**DOC-CONFIRMED.** The SAKB press-brake hydraulic drive consists of a central control block plus two separate suction valves and is presented as DIN 12622-certified. The public D 6335 material exposes the monitored elements but still does not provide a complete machine-level single-fault/recovery truth table.

Source: https://www.hawe.com/en-us/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/sakb%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/

**DOC-CONFIRMED.** HAWE's EV2D press-brake amplifier implements a safety-related shutdown path for press-brake valves. This supports separating ordinary command generation from the safety shutdown path; it does not by itself prove spool position, beam retention, pressure state, or ram stop.

Source: https://www.hawe.com/company/news/press/detail/digital-amplifier-ev2d-ready-for-safety-relevant-processes-in-the-press-brakes/

### HYDAC monitored-valve disagreement evidence — transferable architecture, not a press-brake truth table

**DOC-CONFIRMED.** HYDAC's PSV 10/16 press safety valve documentation describes a monitored hydraulic safety architecture that shuts the machine down safely if one switch-position-monitored valve fails. The product is for hydraulic clutch/brake units on mechanical presses and braking devices on servo presses, not for a hydraulic press-brake ram circuit. Therefore its failure-reaction principle is useful evidence for monitored final-element disagreement, while its hydraulic topology and performance claims must **not** be copied into OpenPressBrake.

Source: https://salesportal.hydac.com/shop/media/catalog/crossbase/PRD_DOC_BPR/PRD_DOC_BPR_5139-00001__SEN__AIN__V1.pdf

## Claim ledger

- **DOC-CONFIRMED:** Valve switching-position monitoring can provide evidence about the physical switching element rather than merely the electrical command.
- **DOC-CONFIRMED:** HAWE D 6335 exposes a real press-brake hydraulic control variant with position monitoring on two proportional directional valves, two holding valves, and a 4/2-way directional valve.
- **DOC-CONFIRMED:** A professional monitored hydraulic safety architecture can treat failure of one monitored valve as a condition requiring safe shutdown (HYDAC PSV; different press class).
- **DOC-CONFIRMED:** Press-brake hydraulic architectures can contain multiple physically separate hydraulic elements; HAWE SAKB exposes a central block plus two separate suction valves.
- **INFERENCE:** A disagreement between commanded-safe state and monitored valve position should be represented as a safety fault/inhibit until the relevant safety function is restored and validated. This is a conservative architecture rule consistent with the professional evidence, but the exact latch/reset/re-proof sequence remains machine/design-specific.
- **UNKNOWN:** D 6335 does not establish the complete SAKB machine-level response to one monitored element disagreeing, diagnostic timing, pressure threshold, allowable degraded mode, repair sequence, or required post-repair re-proof.
- **UNKNOWN:** Valve-position feedback alone does not establish that a press-brake beam is physically retained, that pressure/stored energy is safe, or that measured stopping performance remains acceptable.

## Frozen teaching boundary

**SAFE COMMAND ISSUED != VALVE COIL DE-ENERGIZED != VALVE SWITCHING ELEMENT IN SAFE POSITION != ALL REQUIRED MONITORED HYDRAULIC ELEMENTS PROVED != RAM/LOAD PHYSICALLY RETAINED != STORED PRESSURE/ENERGY SAFE != STOP PERFORMANCE VALID != PERSONNEL ACCESS SAFE.**

And:

**ONE MONITORED FINAL ELEMENT DISAGREES -> DO NOT MASK IT WITH THE COMPANION ELEMENT OR ORDINARY CONTROLLER STATE.**

A healthy companion element may prevent immediate motion, but that is not evidence that the required redundant safety function remains valid for continued production. No degraded-production permission is inferred.

## OpenPressBrake curriculum application

Keep four layers distinct:

1. **Ordinary control:** LinuxCNC/FPGA requests motion, speed, pressure/current or valve state.
2. **Safety-related control:** independent safety logic removes hazardous-motion authority and evaluates required safety feedback.
3. **Final-element proof:** monitored valve/spool/switching-element feedback establishes the proposition it actually measures.
4. **Physical hazard proof:** ram motion/position, load retention, pressure/stored-energy state and maintained stop performance require appropriate independent evidence for the actual machine design.

LinuxCNC/HAL may display these states and refuse normal commands, but it must not become the sole personnel-safety authority merely because the diagnostics are convenient to integrate.

## Adversarial commissioning cases

1. Safe shutdown is commanded; valve coils are off; one monitored spool remains in the non-safe position. Expected disposition: safety function remains invalid; no production rearm from ordinary reset.
2. All monitored valve positions report safe, but the ram continues moving. Expected disposition: valve proof does not overrule contradictory physical-motion evidence; access remains prohibited.
3. Ram is stationary but stored hydraulic energy remains capable of hazardous movement after a component is disturbed. Expected disposition: stationary is not equivalent to service-safe energy state.
4. One monitored holding/directional element is repaired after a disagreement while companions remained healthy. Expected disposition: do not assume earlier companion proofs plus repair reconstruct complete proof; determine the manufacturer's required post-service validation for the actual architecture.
5. LinuxCNC retains START/JOG/DOWN intent across fault repair. Expected disposition: restoring safety authority must not convert stale ordinary intent into fresh hazardous-motion initiation.

## Information-gain stop / exact next evidence

The same-machine evidence gap is now narrower: D 6335 proves that the SAKB can monitor multiple specific hydraulic final elements. Next seek OEM/manufacturer evidence exposing **single monitored-element disagreement -> machine-level safe reaction/load disposition -> fault retention -> repair -> required re-proof/stop validation -> safety rearm -> separate fresh production initiation**. Also seek whether the two holding-valve proofs can mask one another and how each is challenged after service. Do not infer the missing sequence from HYDAC's mechanical/servo-press PSV.

No simulation or build is justified by this evidence question; authoritative physical-system documentation has higher information value. No GitHub-hosted or self-hosted compute was used.
