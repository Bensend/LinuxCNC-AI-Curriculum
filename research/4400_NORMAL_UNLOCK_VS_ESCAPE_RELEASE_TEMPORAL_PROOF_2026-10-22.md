# 4400 — Normal guard unlocking versus emergency escape: different temporal proof obligations

**2026-10-22 | Status: DOC-CONFIRMED manufacturer semantics + INFERENCE architecture analysis; NOT TEST-CONFIRMED.** This is a generic safety-design lesson, not a validated machine or a circuit diagram. Applies where a guard locks during a hazardous state and a person may be inside a protected space.

## Precise source boundary

EUCHNER *Operating Instructions, Transponder-Coded Safety Switch CTP-AP*, document **2124217-08-06/21**, §3 (safety function), §6.8 (switching states), §7.3 (escape release), §10 (connection), §11.3 (functional check):

- **DOC-CONFIRMED:** CTP-L FO1A/FO1B are ON when closed and locked and OFF when closed but unlocked or open. The door-position monitoring output OD can remain ON when closed but unlocked; OL indicates lock state in the documented normal table.
- **DOC-CONFIRMED:** operating the optional inside escape release releases the lock and switches the safety outputs OFF; the manual instructs using those outputs to generate a stop command. OL turns OFF and OD may be undefined during release. The release is to be manually accessible inside without tools, inaccessible from outside, and the actuator must not be under tensile stress during manual release.
- **DOC-CONFIRMED:** the safety characteristics for the *control of guard locking* depend on the external control. The device's lock monitoring is not proof that the external decision to unlock is safety-rated.
- **DOC-CONFIRMED:** both safety outputs must be evaluated and downstream receivers must tolerate the device's own output test pulses; the manual does not itself establish cross-product compatibility or a machine's complete stopping function.

Source: [EUCHNER CTP-AP operating instructions 2124217-08-06/21](https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf), especially printed pp.6,9,11,15 and 23. The facts apply to the specified device/manual, not every guard switch.

## Three separate transactions, not one generic `GUARD_OK` bit

### A. Normal production access request (outside entry)

Design obligation, **INFERENCE from physical-proposition reasoning**: the independently allocated safety function must establish the selected `PHY-*` safe-access proposition *before* normal unlocking can permit hazardous exposure. A typical sequence is `access requested -> independent protective response demanded -> final-element response and machine-level witness assessed -> release permitted -> access possible`. This is not a universal time recipe: the actual hazard may include spindle coast, gravity, pressure, thermal/process energy or stored mechanical energy. The acceptance criterion and any required separation/delay are machine-specific `SRS/VAL` facts, currently `UNKNOWN`.

Do **not** equate a motor standstill indication with beam restraint or an OSSD OFF state with completed physical stopping. If a stop-monitoring function is used, its sensor targets, diagnostics and dependencies must be justified independently of the guard-lock output.

### B. Inside emergency escape (egress, not ordinary access authorization)

A person may need to leave a protected space even after a loss of control power or with an uncompleted protective stop. The documented manual escape release physically unlocks and **then/at the same actuation** creates an electrical stop demand. **INFERENCE:** there is no documented guarantee that the external hazardous-motion stop completes *before* the person can open the gate. Treating FO OFF as already-safe would reverse cause and effect.

Therefore preserve **both** propositions: `(i) person can operate release and physically escape under credible load/geometry` and `(ii) the machine responds to the protective demand, with exposure controlled while hazardous energy/motion persists`. The second may require machine-specific guarding, separation, energy control, independent holding or other protective measures; it cannot be proved by the release switch alone. An escape mechanism that becomes impossible under expected door force or a guard that traps an occupant during power loss is a human-factors/design defect requiring redesign, not merely a warning label.

### C. Maintenance access (person exposed to stored energy)

An emergency escape release, normal guard unlock, stopped spindle, E-stop and ordinary LinuxCNC inhibit are **not** substitutes for energy isolation. Record physical isolation points, stored-energy discharge or secure restraint, each exposed worker's applicable personal control, reaccumulation risk, and independent verification before servicing. A press brake may retain accumulator gas/fluid pressure, trapped cylinder chambers and a gravity-loaded beam after pump stop. Whether a particular isolator/discharge/holding arrangement controls those hazards is **UNKNOWN** without the actual circuit and physical evidence. See [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) for covered servicing requirements.

## Adversarial ordering analysis

| Challenge | Tempting but invalid conclusion | Required distinction / physical evidence |
|---|---|---|
| Escape release operated; FO goes OFF | "The machine was already stopped before the guard opened" | FO OFF initiates/indicates a demand in the documented release case; independent hazard stopping/holding is a different `PHY/VAL` proposition. |
| Guard remains closed, OD ON, OL OFF | "Locked and protected" | Door closed is not guard locked; normal CTP-L FO is OFF. Manual release may make OD undefined. |
| Normal controller issues stop; safety controller unlocks immediately | "Software requested stop, so entry is safe" | Normal command is not independent proof of physical safe access; require SRS-appropriate machine witness. |
| Safety-rated standstill monitor reports standstill | "Gravity-loaded beam cannot drift" | Sensor target may be a motor shaft, not actual load restraint; separate `PHY/DEP/VAL`. |
| Power failure traps an occupant behind spring locking | "Fail-safe means keep locked forever" | Inside escape must remain possible for the documented application; separate energy/hazard exposure design is required. |
| Power-to-lock variant loses power and releases | "Unlocked implies safe" | Opening may precede hazardous-motion cessation; select architecture/guard distance for the actual stop and exposure proposition. |
| Guard mechanically jams while FO/OL are plausible | "Status proves escape" | Validate mechanical opening, alignment, actuator tensile load, access/handle reach and maintenance. |
| Escape release reset, guard reclosed, retained cycle-start still HIGH | "Reset permits production restart" | Deliberate independent safety reset, space clear/occupancy evidence and separate ordinary start are distinct. |

No timing, pressure, holding-force, stopping-distance or achieved PL/SIL number is assigned. Do not infer that any manufacturer's component category is the complete machine safety-function category.

## Traceability insertion and human-factors design test

For each machine record `BND/HAZ` exposure route; `ENE` residual energy; `SF/PHY` normal-access, escape and maintenance propositions; `SRS` accepted stop/release/restart sequence; `AUTH` independent safety owner; `DEP` power, sensor and mechanical dependencies; `ARC` chosen guard/release/final element; `HF` foreseeable bypass/trapping; `VAL/PT` actual machine proof; and `UNK/RR/CHG` residual restrictions/change. An observation that a release knob can be operated while the gate is unloaded is not proof it will work under the installed worst credible alignment/force case.

Prefer visible, labeled, accessible release hardware, simple removable/hinged guard hardware that reliably reassembles, and diagnostics that name the actual state (`DOOR CLOSED`, `LOCK ENGAGED`, `STOP REQUESTED`, `MOTION STOPPED`, `BEAM HELD`) rather than a misleading aggregate green light. A guard that is cumbersome to restore invites defeat; revise the mechanical design before blaming the operator.

**Minimum threshold:** where a required safe-access/egress or safe-stop proposition is unproved, no operation with people exposed. Experimental work must be isolated/remote, with people outside the danger zone and residual risk stated. No live release/fault test is authorized by this lesson.

## Evidence and unresolved questions

- **DOC-CONFIRMED:** EUCHNER specified CTP-L states, escape release behavior, external lock-control allocation and installation constraints; OSHA covered energy-control requirements.
- **INFERENCE:** separate temporal proof obligations and the failure-path analysis above.
- **SOURCE-CONFIRMED:** no new LinuxCNC code claim; ordinary LinuxCNC/FPGA remains outside independent personnel-safety authority.
- **TEST-CONFIRMED:** none; no physical guard/stop/hydraulic test performed.
- **UNKNOWN:** actual selected guard switch/order, receiver pulse compatibility, emergency release geometry, power-loss behavior of the installed mechanism, physical stop/hold, trapped-person escape, pressure zones, reset/rearm implementation, machine-level safety integrity.

**Information-gain decision:** no simulation justified merely to replay a manufacturer state table. The next useful evidence is exact installed product/configuration and a safely planned independent physical stop/egress/energy-control validation, or further unblocked documentary safety curriculum work.
