# 4400 BLACKOUT-01 — power loss, mechanical escape and visible egress: scoped original-source audit (2026-10-26)

**Status:** documentary engineering study, not a selected-machine design, legal compliance determination, physical escape test or external evaluation. Distinct from existing guard-lock escape/restart studies: **the person must be able to FIND and REACH the escape path after a common lighting/control power failure**.

## Original authority and limits

1. **OSHA 29 CFR 1910.37(a)(2)–(4), (b)(1)–(4), (d), official current regulation:** https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.37 . **DOC-CONFIRMED:** covered workplace exit routes must avoid travel toward high hazards unless shielded, remain unobstructed, keep emergency safeguards (including exit lighting) operational, and be adequately lighted and visibly marked; repairs/alterations must preserve exit routes or equivalent protection. **Scope warning:** this regulates workplace **exit routes**; it does not, by itself, define the exact luminaire placement, lux, battery duration or escape handle geometry *inside* an individual machine enclosure. Do not misapply its exit-sign luminance rule as a machine-interior illuminance design value.
2. **EUCHNER exact product TZ1RE024M-C1684 (order 083171), official catalog:** https://www.euchner.com/en-us/a/083171/ . **DOC-CONFIRMED:** spring-applied `power to unlock` guard locking; separate inside tool-free escape release and front auxiliary release for faults such as power loss (tool/key). These are **different** functions; a failed power supply does not by itself open a spring-locked guard.
3. **EUCHNER original CTS-C2-BP/BR-FLX operating instructions, MAN20001531-05-11/24, §7.2:** https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Transponder-Coded-S%E2%80%A6_EN_3487641_MAN20001531.pdf . **DOC-CONFIRMED exact product family:** tool-free inside escape release must not be reachable from outside, must be physically operable, and function must be checked after mounting and at intervals. The manual notes that actuator tensile loading can defeat release and distinguishes behavior depending on guard-lock monitoring configuration. **Do not transfer** that switch's contact or reset semantics to TZ1RE024M or another device.
4. **Pilz PSENmlock official product family:** https://www.pilz.com/en-IN/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices . Manufacturer describes a red inside escape handle and lockout insert for up to five locks; **product-family capability**, not proof of any selected installation.

## Concrete failure-path model (INFERENCE, not TEST-CONFIRMED)

| Single initiating event | Coupled hazards | Minimum design question |
|---|---|---|
| common mains blackout | CNC/HMI dark, machine lighting dark, spring-locked door remains locked, ram/workpiece gravity energy persists | can an occupant locate and actuate mechanical inside escape and safely reach an unobstructed path without ordinary power? |
| coolant/swarf blocks a walkway | guard can be released but egress is obstructed or slippery | is the *complete path*, not only the handle, maintained and physically inspected? |
| blackout while multiple people service a cell | one person cannot see another, outside operator resets on restoration | whole-body occupancy control, multi-person lockout, independent fresh-start/rearm inhibition |
| emergency lighting and safety controller share one supply | both fail in same fault, but one status indicator may be stale | supply dependency/CCF analysis; emergency egress visibility must not depend solely on ordinary HMI |
| actuator is mechanically loaded | catalog promises escape release but installed door binds | selected mounting geometry, load cases, tool-free physical proof under a qualified nonhazardous setup |
| re-energization | lighting returns, old foot pedal or remote command persists | independent deliberate reset then fresh start; illumination is not rearm authority |

## Safe architectural boundary

- **Ordinary:** LinuxCNC/FPGA/remote HMI may display occupancy/lighting/guard diagnostics, but blackout can remove all of them.
- **Safety-related:** qualified independent safety logic/guard-lock integration and restart inhibit must be proven for the actual installed product.
- **Mechanical:** inside escape mechanism, unobstructed physical door/path, and gravity/pressure restraint are separate proof obligations.
- **Egress lighting:** workplace exit-route requirements apply in their own scope; any additional cell-interior lighting/wayfinding should be risk-assessed for the actual geometry and power-loss duration. No numerical battery or lux specification invented here.
- **Human factors:** inside handle visible/reachable even when HMI dark, tactile/obvious red control, protected low-effort clear path, inspection after changes, no temptation to prop open guard or defeat interlock.

## Evidence classification

**DOC-CONFIRMED:** scoped OSHA exit-route text; EUCHNER exact spring lock, inside escape vs auxiliary release; EUCHNER CTS manual installation/function caveats; Pilz product-family handle. **INFERENCE:** blackout/common-cause and occupancy/visibility failure paths. **UNKNOWN:** selected OpenPressBrake enclosed cell, lighting supply, escape device, path, hydraulic gravity hold, exact PL/SIL, installed safety truth table and physical validation. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied on.**

**Information-gain stop:** documentary sources establish that guard unlocking, path visibility and physical energy retention are independent propositions. Further exact proof requires selected machine and safe qualified inspection. No lab, energized power-failure test or personnel-in-cell experiment is justified. G0/G1 HOLD; no personnel-exposed hazardous operation.
