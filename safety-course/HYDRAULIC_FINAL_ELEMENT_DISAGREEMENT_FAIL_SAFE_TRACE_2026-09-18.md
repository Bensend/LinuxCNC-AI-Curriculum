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

**DOC-CONFIRMED.** HAWE's SAKB press-brake hydraulic drive consists of a central control block plus two separate suction valves and is presented as DIN 12622-certified. This is useful physical architecture evidence, but the public product page does not expose a complete fault truth table for a single failed suction/safety valve.

Source: https://www.hawe.com/en-us/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/sakb%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/

**DOC-CONFIRMED.** HAWE's EV2D press-brake amplifier implements a safety-related shutdown path for press-brake valves. This supports separating ordinary command generation from the safety shutdown path; it does not by itself prove spool position, beam retention, pressure state, or ram stop.

Source: https://www.hawe.com/company/news/press/detail/digital-amplifier-ev2d-ready-for-safety-relevant-processes-in-the-press-brakes/

### HYDAC monitored-valve disagreement evidence — transferable architecture, not a press-brake truth table

**DOC-CONFIRMED.** HYDAC's PSV 10/16 press safety valve documentation describes a monitored hydraulic safety architecture that shuts the machine down safely if one switch-position-monitored valve fails. The product is for hydraulic clutch/brake units on mechanical presses and braking devices on servo presses, not for a hydraulic press-brake ram circuit. Therefore its failure-reaction principle is useful evidence for monitored final-element disagreement, while its hydraulic topology and performance claims must **not** be copied into OpenPressBrake.

Source: https://salesportal.hydac.com/shop/media/catalog/crossbase/PRD_DOC_BPR/PRD_DOC_BPR_5139-00001__SEN__AIN__V1.pdf

## Claim ledger

- **DOC-CONFIRMED:** Valve switching-position monitoring can provide evidence about the physical switching element rather than merely the electrical command.
- **DOC-CONFIRMED:** A professional monitored hydraulic safety architecture can treat failure of one monitored valve as a condition requiring safe shutdown.
- **DOC-CONFIRMED:** Press-brake hydraulic architectures can contain multiple physically separate hydraulic elements; HAWE SAKB exposes a central block plus two separate suction valves.
- **INFERENCE:** A disagreement between commanded-safe state and monitored valve position should be represented as a latched safety fault/inhibit until the relevant safety function is restored and validated. This is a conservative architecture rule consistent with the professional evidence, but the exact reset/re-proof sequence remains machine/design-specific.
- **UNKNOWN:** The public HAWE evidence inspected here does not establish the exact SAKB/ePRAX single-valve-failure hydraulic state, diagnostic timing, pressure threshold, allowable degraded mode, repair sequence, or required post-repair re-proof.
- **UNKNOWN:** Valve-position feedback alone does not establish that a press-brake beam is physically retained, that pressure/stored energy is safe, or that measured stopping performance remains acceptable.

## Frozen teaching boundary

**SAFE COMMAND ISSUED != VALVE COIL DE-ENERGIZED != VALVE SWITCHING ELEMENT IN SAFE POSITION != ALL REQUIRED REDUNDANT HYDRAULIC ELEMENTS PROVED != RAM/LOAD PHYSICALLY RETAINED != STORED PRESSURE/ENERGY SAFE != STOP PERFORMANCE VALID != PERSONNEL ACCESS SAFE.**

And:

**ONE MONITORED FINAL ELEMENT DISAGREES -> DO NOT MASK IT WITH THE COMPANION ELEMENT OR ORDINARY CONTROLLER STATE.**

A healthy companion valve may keep the machine from immediately moving, but that is not evidence that the required redundant safety function remains valid for continued production. No degraded-production permission is inferred.

## OpenPressBrake curriculum application

Keep four layers distinct:

1. **Ordinary control:** LinuxCNC/FPGA requests motion, speed, pressure/current or valve state.
2. **Safety-related control:** independent safety logic removes hazardous-motion authority and evaluates required safety feedback.
3. **Final-element proof:** monitored valve/spool/switching-element feedback establishes the proposition it actually measures.
4. **Physical hazard proof:** ram motion/position, load retention, pressure/stored-energy state and maintained stop performance require appropriate independent evidence for the actual machine design.

LinuxCNC/HAL may display these states and refuse normal commands, but it must not become the sole personnel-safety authority merely because the diagnostics are convenient to integrate.

## Adversarial commissioning cases

1. Safe shutdown is commanded; both valve coils are off; one monitored spool remains in the non-safe position. Expected disposition: safety function remains invalid; no production rearm from ordinary reset.
2. Both monitored valve positions report safe, but the ram continues moving. Expected disposition: valve proof does not overrule contradictory physical-motion evidence; access remains prohibited.
3. Ram is stationary but stored hydraulic energy remains capable of hazardous movement after a component is disturbed. Expected disposition: stationary is not equivalent to service-safe energy state.
4. Valve B is repaired after a disagreement while valve A remained healthy. Expected disposition: do not assume A's earlier proof plus B repair reconstructs complete proof; determine the manufacturer's required post-service validation for the actual architecture.
5. LinuxCNC retains START/JOG/DOWN intent across fault repair. Expected disposition: restoring safety authority must not convert stale ordinary intent into fresh hazardous-motion initiation.

## Information-gain stop / exact next evidence

Seek an OEM or hydraulic manufacturer press-brake document that explicitly exposes **two required retaining/safety elements, each element's monitored feedback, a single-element disagreement/failure reaction, physical ram/load-safe disposition, and post-repair validation/re-proof before production rearm**. Do not infer the missing sequence from HYDAC's mechanical/servo-press PSV or from HAWE product-page architecture alone.

No simulation or build is justified by this evidence question; authoritative physical-system documentation has higher information value. No GitHub-hosted compute was used.
