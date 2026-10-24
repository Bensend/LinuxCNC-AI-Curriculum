# 4400 technician card — Lost 0 V, false-high safety input, common-cause encoder and brownout

**Status:** learner-visible open-book paper exercise; **NOT** a blind evaluator key, live lab or machine qualification. Read the [SICK original-source audit](../research/4400_SICK_FLEXISOFT_LOST_0V_REVERSE_CURRENT_COMMON_CAUSE_SOURCE_AUDIT_2026-10-24.md) first. All examples are hypothetical; no OpenPressBrake SICK installation is claimed.

## Practical objective

A builder replacing a CNC, adding a 24 V PSU, or changing a safety I/O cable must distinguish: (a) safety **logic** supply, (b) safe-output **load** supply, (c) actuator return, (d) sensor return, (e) FE/PE/shield, (f) ordinary FPGA/LinuxCNC status, (g) final-element physical response, and (h) maintenance isolation. A valid safety PLC program cannot compensate for an unreviewed common-return topology.

**Stop rule:** If the selected as-built safety output/return wiring, hydraulic or mechanical stop/hold, and reset/start behavior cannot be demonstrated, **no personnel-exposed hazardous operation**. Only separately designed qualified isolated/remote experiments with people outside the hazard envelope may be considered; none is specified or authorized here.

## Source-backed anchors (product-specific)

- SICK Flexi Soft hardware operating instructions, 8012478, extracted 2026-05-05 edition, §6.1 printed pp.52–53: shared actuator GND interruption can cause unintended switching; parallel safety inputs can appear high through reverse current; manufacturer calls for star-form actuator returns. Original URL: https://www.sick.com/media/docs/0/60/660/operating_instructions_flexi_soft_modular_safety_controller_hardware_en_im0031660.pdf . Verify saved PDF footer/revision at implementation; manufacturer URL may serve updated versions.
- Same OEM §11.3 pp.123–124: voltage-dip diagnostic 0x002D4006 and FLEXBUS+ restart class 0x003E4006; load switching and shared supply wiring are diagnostic leads, not physical stop witnesses.
- SICK Safe Linear Positioning 8020941/1FB9/2022-07-19 §13.2 p.80: XTIO reverse-current maximum depends on hardware revision (<V1.10.0: 20 mA; ≥V1.10.0: 2 mA). Original: https://www.sick.com/media/docs/0/30/030/operating_instructions_safe_linear_positioning_en_im0081030.pdf . **Not a universal receiver trip current.**
- OSHA 1910.147(b), (d)(5)–(6): a control circuit is not a maintenance energy-isolating device; residual/reaccumulating energy and verified isolation are separate obligations.

## Twelve adversarial paper scenarios

For **each** scenario, write (1) physical hazardous proposition, (2) what the observed bit *actually* proves, (3) missing circuit/part/firmware evidence, (4) safest low-friction design correction, (5) whether physical `VAL/PT` may proceed, and (6) whether a separate maintenance isolation step is required.

| ID | Given (hypothetical) | Key engineering discriminator to investigate |
|---|---|---|
| **LG-01** | Two Q outputs drive different relay coils. One is high, one low; a common actuator 0 V is loose. HMI reports 'Q2 OFF'. | SICK's **conditional unintended relay switching** warning; OFF command is not a coil-current/physical-contact witness. |
| **LG-02** | A guard and E-stop feed two parallel input branches. Both status LEDs are green after a shared return breaks. | Manufacturer's **reverse-current false-high** warning; map return and input threshold before trusting high. |
| **LG-03** | A new FPGA board shares the safety PLC's 0 V at an unlabeled terminal. Installer adds another jumper to eliminate a serial-port ground loop. | OEM A2/RS-232 internal common and correct FE/PE/0 V routing; do not assume more jumpers always safer. |
| **LG-04** | Safety CPU RUN is green but a Q output supply fuse has opened. | Logic supply versus output-module A1/A2; green CPU does not prove output path or load safe state. |
| **LG-05** | Two 'independent' safe-speed encoders share a power supply and common return in the same cable. | Common-cause reference/supply loss; two encoders are not two independent energy paths. |
| **LG-06** | A hydraulic pump motor start briefly dims a 24 V rail; controller error history includes 0x002D4006. | OEM voltage-dip troubleshooting, cable drop and load switching; **no invented dip amplitude at this machine**. |
| **LG-07** | A controller reboots after a bus/EMC error and ordinary LinuxCNC retains an AUTO-cycle request. | OEM FLEXBUS+ restart class versus separate independent rearm, reset and fresh start; HMI READY insufficient. |
| **LG-08** | Replacement XTIO module has a different hardware version; someone copies '2 mA' into a generic false-high calculation. | 2022 OEM version-specific **maximum reverse current**, not an actual input threshold or current observation. |
| **LG-09** | A technician proposes an energized 'pull 0 V wire' test on a press brake to prove the fault is detected. | **Reject live hazardous fault injection.** Qualified design review and only later separately authorized isolated/remote test. |
| **LG-10** | E-stop logic works in a bench drawing, but the connected hydraulic valve may retain trapped pressure and the ram is elevated. | Electrical safety input/output does not establish `PHY-HOLD`, `PHY-ENERGY` or safe maintenance. |
| **LG-11** | A replacement safety I/O harness routes sensor return, relay return, and Ethernet shield together to reduce wiring labor. | Exact OEM FE/shield/0 V topology, strain relief, segregation and common-cause fault review; ergonomics of durable labeling. |
| **LG-12** | Guard is closed, controller fault cleared, local reset pressed; normal CNC starts the previous queued move. | Reset is not a motion command; safety authorization and deliberate new ordinary start must remain distinct. |

## Worked reasoning example — LG-01

**DOC-CONFIRMED narrow claim:** SICK warns that a broken common actuator GND in a particular mixed-high/low output condition *can* produce unintended actuator switching. It does **not** state that every relay will energize or that any given press-brake hydraulic valve changes state.

**Engineering response:** Place the machine in documentary HOLD. Identify the actual safety-output module, Q channel role, separate load supply, coil circuit and return junctions. Identify the physical final element and feedback scope. Check the as-built against the OEM's specified star-return installation with a qualified isolated electrical review. Require independent stop/hold/occupancy evidence before any release. **Do not** treat a LinuxCNC status pin, a controller output LED, or a feedback auxiliary contact as a physical ram witness.

**Human-factors improvement:** a labelled, serviceable, mechanically secure terminal arrangement is cheaper and easier to maintain than an unlabeled shared splice. Put return ownership and exact wire IDs on the cabinet door schematic. If a safeguard causes frequent nuisance trips, diagnose the return/supply design rather than teaching operators to jumper around it.

## Machine-neutral evidence intake: fill only from selected drawings

| Field | Required selected evidence | Initial status |
|---|---|---|
| Controller/module/firmware and exact original OEM manual edition | Product ID, module suffix, hardware rev, firmware, PDF version/hash | **UNKNOWN** |
| Logic supply and Q-output supply | A1/A2 path, fuse, PSU, protection, return | **UNKNOWN** |
| Each sensor/actuator return and shared junction | Wire ID, terminals, route, FE/PE/shield distinction | **UNKNOWN** |
| High/low state and reverse-current compatibility | OEM source/receiver data and actual selected wiring; no generic 2/20 mA transfer | **UNKNOWN** |
| Safety demand to independent final element | Actual terminal and relay/valve/drive input, EDM scope | **UNKNOWN** |
| Physical stop, gravity hold, energy, occupancy, restart | Independent qualified witness IDs, mode/task coverage | **NOT RUN** |
| Qualified change-control and practical service access | Versioned before/after wiring, user/maintainer review | **UNKNOWN** |

## Assessment and progression

A learner passes this **practice** card only when they correctly reject both 'OFF bit = no coil current' and 'two high inputs = two healthy sensors', identify the conditional OEM mechanisms without claiming an observed machine fault, and preserve independent safety authority plus physical energy removal. This is **not an external competency score**.

**Open:** fresh independent evaluator for 2520–25F0 and 4400 source modules; actual OpenPressBrake safety circuit and physical evidence; hardware-version verification. **No** simulated, powered, physical or GitHub-hosted/self-hosted compute was required to create this card.
