# 4400 MAT-LOGIC-01 — Do not reverse a safety mat into a hazardous-motion start input

**Status:** independent manufacturer-source cross-check, 2026-10-26. **Exact scope:** Banner Engineering SC22-3/-3E Safety Controller Instruction Manual, 133487 Rev D, 28 October 2015, §§10.6–10.6.3, PDF pp.98–101. https://info.bannerengineering.com/cs/groups/public/documents/literature/133487.pdf

## Direct manufacturer findings
- §10.6 states SC22 monitors **four-wire** pressure mats, can monitor multiple mats in series, and is not designed for two-wire mat/edge devices. **DOC-CONFIRMED.**
- §10.6 says detected contact/wiring faults prevent machine restart, and auto-reset requires a separate machine-control reset to prevent restart when the mat clears. **DOC-CONFIRMED.**
- Its explicit warning prohibits using the mat as a device to **initiate hazardous machine motion** when stepped on. Reverse/negative logic may yield a false enable on certain failures, including module power loss. **DOC-CONFIRMED.**
- §10.6.2 states open wire, short to 0 V or short to another source of power enters Lockout on the documented four-wire input; no universal claim is made for other controllers or for an intentionally disabled channel. **DOC-CONFIRMED.**
- §10.6.3 warns dirt, swarf, liquids, cable damage and material migration under joints can degrade sensing; secured, non-trip mounting and reach-over/under/around geometry matter. **DOC-CONFIRMED.**

## Why this is a different fault from Rockwell DIP selection
Banner's **detected fault** in an enabled four-wire channel is not equivalent to Rockwell's **intentional configured deactivation** of an input. A safe input-monitoring algorithm cannot detect a person in a zone that was removed from the safety function's physical/configuration boundary. This is an **INFERENCE** across distinct manufacturer architectures, not a tested equivalence.

## Practical prohibition and alternative
Do not use "person steps on mat" as the production start command or a reverse-logic permissive. Use the mat only for its correctly engineered protective/presence role; place normal production commands in the normal control layer; implement protective-stop/restart in an independent validated safety-related architecture. A sensor state must never alone authorize hazardous motion.

## Evidence limitations and standards scope
The Banner manual summarizes ISO 13856-1 and related standards, but this work **did not inspect a licensed complete current standards text**. The manual's historical example numbers and installation distances are not universal requirements and are not transferred to OpenPressBrake. Neither a Banner controller nor a Rockwell mat is known to be installed. **TEST-CONFIRMED none; SOURCE-CONFIRMED LinuxCNC none; COMMUNITY-REPORTED none; UNKNOWN selected machine physical behavior/PL/SIL.** G0/G1 HOLD.

## Transfer questions
Can an enabled channel with a broken conductor fault out while a separate intentionally disabled input fails to detect occupancy? Yes in the documentary/hypothetical model, but this must not be treated as a selected-machine measured outcome. What changes when a latched ordinary LinuxCNC start request persists after a mat reset? The machine-specific restart hazard requires independent analysis and safety-related prevention, not reliance on ordinary HAL state.
