# 4400-ENABLE-01 — Three-position enabling grip is not an automatic start or a generic foot-pedal substitute
**2026-10-25 | original 2026 manufacturer source | cross-machine 4400 safety research | NON-GRADUATED**

## Question
For guarded robot/mill/press-brake setup, does a three-position **hand enabling switch** make guard-open motion safe simply because it is held in the middle? What happens when an operator panics and squeezes through, then releases; what if another person enters; and who controls speed, guard suspension and deliberate motion start?

## Direct original manufacturer evidence
**Rockwell Automation, *Emergency Stop Devices Technical Data*, publication 440-TD001D-EN-P, February 2026**, 40 PDF pages, original OEM: https://literature.rockwellautomation.com/idc/groups/literature/documents/td/440-td001_-en-p.pdf . Directly inspected printed pp.29–31 and 33, including contact diagrams and application text (PDF pp.28–30, 32).

- **DOC-CONFIRMED, printed p.29:** a three-position enabling switch is a **manually operated device used with a start control**. Continuous mid-position actuation allows an operation; unactuated demands a stop. The 440J grip has two three-position switches; contacts are **open at rest**, **closed at middle**, **open fully squeezed**, and **remain open on transition from fully squeezed back to released**. The OEM cites IEC 60947-5-8:2006 for this product's enabling-switch design.
- **DOC-CONFIRMED, printed p.29:** 440J variants have no extra button, an additional NO jog/reset button, or a dual-channel E-stop. The safety design must permit the jog/reset function **only when the grip trigger is in mid-position**. An additional jog button is not proof that a movement is independently safe.
- **DOC-CONFIRMED, printed p.31:** before entering the hazard, select a **reduced-performance mode**; the machine must not revert to normal performance during the enabling task. Manufacturer recommends independent feedback for the reduced characteristic (for example actual speed), with a stop when a selected limit is exceeded. This is not a numerical speed guarantee for another machine.
- **DOC-CONFIRMED, printed p.31:** partial-body and full-body access require different architecture; enabling one protective-device bypass must not silently disable multiple safeguards. For full-body access, occupancy/second-person entry must be considered. When **multiple personnel** require access, the OEM says **each person must use their own enabling device** and all must be active for hazardous operation. This is a manufacturer application recommendation, not evidence that any selected robot cell implements it.
- **DOC-CONFIRMED, printed p.31:** manufacturer discusses interlock contacts, safety relays and safety PLC architectures for temporarily suspending a protective device. **This is not authorization to bridge a real guard**, bypass OSSD channels, or treat ordinary LinuxCNC/FPGA logic as a safety PLC. Exact compatible products and safety logic require selected risk assessment, engineering design and validation.
- **DOC-CONFIRMED, printed p.33:** standard 440J includes two independent three-position switches, with optional jog or E-stop; the manufacturer lists the relevant 60947-5-8 and other standards. These are **component specifications**, not a selected machine PL/SIL or validated safe speed.
- **SOURCE-CONFIRMED:** no new LinuxCNC source trace; prior curriculum already establishes ordinary motion/HAL boundary. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** installed grip device, selected machine modes, actual reduced speed/force, safe stop/hold, guard geometry, second-person occupancy and reset.

## Compare against the new PEDAL-01 source branch
| Question | Schmersal UEDR three-position FOOT pedal | Rockwell 440J three-position HAND enabling grip |
|---|---|---|
| Primary task | Press-brake motion input with protective overtravel function | Permissive during qualified guarded-area setup with separate start/jog control |
| Transition after panic/full press | UEDR mechanically latches; blue manual unlock may create an OEM-warned switch-on impulse | 440J contacts stay open on **full-press -> released** return |
| Return/rearm | Selected controller must suppress unlock impulse and require fresh deliberate start | Selected controller must still enforce separate start, mode, monitored performance and no unintended reactivation |
| Person exposure | Foot control does not automatically protect hands, helper or backgauge | Enabling device is **one condition** for selected reduced-performance task, not a license for unguarded full-speed motion |
| Multi-person | Two foot pedals != two-hand safeguard | Each exposed person may require an independent enabling device; manufacturer specifically calls for this for multiple entrants |
| Physical proof | Y1/Y2 stop/hold, guard, stored energy remain open | Selected speed, actual stop/hold, egress, occupancy and restart remain open |

The shared phrase **"three-position"** describes neither a universal safety function nor interchangeable contact transitions.

## Three adversarial failure paths
**E1 — panic return:** an engineer designs a simple middle-contact AND and assumes it is true during full-press-to-release return. The Rockwell original explicitly contradicts that contact behavior; still, a retained start command and reset logic can create a separate unsafe rearm. Design the whole mode/start/stop path, not merely the contact.

**E2 — mode escalation:** operator is inside the guard with enabling switch held; ordinary HMI changes from reduced mode to production mode. A green grip input is not independent evidence of reduced speed/force. A qualified independent mode/performance safety function must prevent unsafe escalation; actual selected safe motion requires physical verification.

**E3 — second entrant:** first person holds enabling grip and jogs; a second worker enters through another access point. First person's device does not prove safeguarded space clear. The manufacturer requires addressing multiple-person access and each person's enabling authority; actual occupancy, escape, reset and other hazard-zone guards remain separately engineered.

## Human factors and boundaries
Grip should be reachable and comfortable throughout intended task, with clear tactile mid-position and panic squeeze/release; no taping, clamping or wedging. Task design must minimize time in guarded area and make reinstallation/relocking easier than bypass. Selected reduced-mode operation must account for gravity, stored hydraulic energy, unexpected axis movement, tooling and other exposed people. An enabling switch is **not maintenance LOTO** and does not prove a gravity-loaded ram held.

**Do not operate with people exposed** if the selected independent safety function, performance monitoring, stop/hold, egress and restart cannot be proven. Experimental motion requires a separately qualified isolated/remote exclusion plan; this source audit authorizes none.

## Next evidence
Exact selected device and guard/mode map, safety-controller configuration and independent actual reduced-performance/stop witnesses, multiple-person occupancy policy and separate start/reset interlocks. Information-separated fresh learner transfer can compare a foot pedal, a grip switch and a two-hand device. No generic lab justified: original OEM resolves the contact transition and application boundaries; selected physical truth is unavailable.
