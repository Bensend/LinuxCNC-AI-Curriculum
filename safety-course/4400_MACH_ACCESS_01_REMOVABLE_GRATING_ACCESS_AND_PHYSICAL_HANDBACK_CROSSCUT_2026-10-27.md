# 4400 MACH-ACCESS-01 — adversarial physical handback and temporary access void

**Status:** NON-GRADUATED paper architecture; [source audit](../research/4400_MACH_ACCESS_01_ISO14122_OSHA_INTEGRAL_LADDER_HSE_MAINTENANCE_ACCESS_SCOPE_AUDIT_2026-10-27.md), [eight-case field module](4400_MACH_ACCESS_01_INTEGRAL_LADDER_PLATFORM_AND_MAINTENANCE_OPENING_FIELD_MODULE_2026-10-27.md). No extra scored case.

| State | Physical access condition | Machine energy and permission |
|---|---|---|
| Normal production | Grating/rails installed and inspected | Independent machine safety validated; normal command separate |
| Service preparation | Alternate route and physical barricade installed before panel removal | Qualified isolation and gravity support verified; production inhibited |
| Open service | Opening protected, panel custody maintained | No hazardous motion or route reopening |
| Physical restoration | All panels/fasteners/guards reinstalled and independently inspected | Separate machine-energy recheck and fresh rearm |
| Changed access design | Structure/guard/reach modified; evidence potentially STALE | CHG review and affected revalidation before release |

**Adversarial failure paths:** (1) contractor removes grate while another worker enters; (2) fasteners omitted because removal is inconvenient; (3) LinuxCNC reboot shows READY while opening remains; (4) oil spill degrades footing while motion status stays green; (5) a new platform changes reach behind an existing guard. Each needs a physical access witness and clear handback; neither an ordinary HMI status nor a guard switch proves the floor is restored. Human-factor redesign (hinge/captive hardware, ground-level service, cleanable steps) is preferable to a bypass-prone procedure.

**Proposed traceability IDs (templates only):** BND-MAC-01 service-access boundary; HAZ-MAC-01 fall during climb, HAZ-MAC-02 temporary floor void, HAZ-MAC-03 concurrent ram exposure; PHY-MAC-01 access structure, PHY-MAC-02 opening covered or excluded, PHY-MAC-03 independent ram/energy state; DEP-MAC-01 grating custody, DEP-MAC-02 safety authority, HF-MAC-01 fastener shortcut, CHG-MAC-01 access/guard geometry change, UNK-MAC-01 installed machine. These are not claims that such hardware exists on OpenPressBrake.

**Evidence:** eCFR §1910.23 machine-integral ladder exception and §1910.22 general walking surfaces, HSE documented removed-grating fall **DOC-CONFIRMED**. State model and anti-defeat measures **INFERENCE**. Machine configuration and physical validation **UNKNOWN**. Eight public paper cases UNSCORED; ten desk gates NOT RUN; no independent evaluator, lab or physical tests. **G0/G1 HOLD; no personnel-exposed operation.**
