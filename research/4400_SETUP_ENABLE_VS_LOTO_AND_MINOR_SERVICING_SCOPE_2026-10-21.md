# 4400 safety — setup-mode enabling devices are not maintenance energy isolation (2026-10-21)

**Course:** LinuxCNC/OpenPressBrake safety implementation, 4000 series. **Status:** documentary/source analysis; no installed-machine qualification, simulation, bench test, or machine operation. **Evidence:** DOC-CONFIRMED for manufacturer and OSHA statements, INFERENCE for proposed design pattern, UNKNOWN for ERMAK as-built implementation. **Scope:** setup, die change, adjustment, inspection, and reduced-guard manual operation. Do not transfer a rule between jurisdictions or machine classes without an applicability check.

## Question and decisive evidence

Can a three-position enabling switch, reduced-speed mode, or an ordinary LinuxCNC/HAL/FPGA setup enable replace the lockable isolation and gravity/hydraulic restraint needed for exposed die-setting work? **No general equivalence exists.** A mode-dependent safeguarding solution may support specifically justified energized adjustment, but its permission is not maintenance isolation.

1. **OSHA 29 CFR 1910.147(a)(2)(i–ii), (b):** servicing includes setting up, adjusting, inspecting, changing tools and maintenance where hazardous energy exposure exists. The note to (a)(2)(ii) permits a *narrow* minor-servicing exception only when the task occurs during normal production, is routine/repetitive/integral, **and** effective alternative protection is provided. This is not a blanket "tool change" exemption. Official text: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 .
2. **OSHA interpretation, 2005-04-22 (corrected 2008-02-20):** die-setting that prepares a hydraulic/mechanical power press for production generally is *not* within the minor-servicing exception because it does not take place during normal production. This is a power-press interpretation, not a categorical machine-specific ruling for the selected press brake; use the statutory task/exposure analysis for the actual machine. https://www.osha.gov/laws-regs/standardinterpretations/2005-04-22 .
3. **OSHA interpretation, 2008-01-25:** a PLC protective system is not generally a substitute for LOTO. OSHA describes a case-specific path only for qualifying minor servicing with effective alternative protection demonstrated by system hazard analysis and good engineering practice. That is not approval of a generic FPGA or PLC interlock. https://www.osha.gov/laws-regs/standardinterpretations/2008-01-25 .
4. **Pilz PITenable manufacturer description:** three positions OFF–ON–OFF; the middle position permits a defined operation while a movable guard's protection is suspended, while release or full squeeze removes enable. This is product-family evidence, not proof that any specific press brake implements it correctly. https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch .
5. **EUCHNER ZSA manufacturer product example:** the enabling function exists only at stage 2, is removed on release or stage 3, and is dependent on wiring. Selected switch suffix, contacts, evaluation, fault monitoring and restart behavior must be verified. https://www.euchner.com/en-us/products/enabling-switch/enabling-switch-zsa-zsr/zsa2b4g10cc1830/ .
6. **OSHA press-brake eTool:** foot-pedal accidental cycling and the rising-sheet/slide-face secondary pinch hazard are separate from the die-line point of operation. A setup-mode enable does not remove those hazards. https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes .

## Four boundaries that cannot be collapsed

| Boundary | What the signal/action may establish | What it does not establish |
|---|---|---|
| Ordinary LinuxCNC/FPGA setup mode or reduced-speed command | A requested normal motion profile or HMI state, subject to actual implementation | Personnel-safe limited speed, independently monitored motion, hydraulic stop, or lockout |
| Safety-related mode selector + three-position enabling device | A conditional permission for a separately specified safeguarded manual task, **if** selected/evaluated/validated | A start command by itself, empty danger zone, proof of safe stop, maintenance isolation |
| Independent safety output and valve/drive monitoring | A defined final-element command and narrow feedback proposition | No trapped pressure, no gravity descent, physical ram restraint, or safe access for hands |
| Lockable energy-isolating devices + stored-energy control + physical restraint/verification | The task-specific maintenance energy-control proposition when fully implemented and verified | Automatic permission for production restart; safeguards still require restoration and release checks |

**Proposed engineering invariant (INFERENCE):** in a qualified energized setup mode, require independent safety-mode authority, a deliberate and separately evaluated motion command, the selected enabling device in its valid stage, and mode-specific independently justified motion limits/protection. Withdrawal, full squeeze, disagreement, loss of supply, or mode transition must demand the specified safety response. Returning to stage 2, releasing E-stop, closing a guard, restoring power, or resetting the safety controller must not replay a retained motion request. This is a requirements sketch, not a complete validated SRS.

For work involving hands under a ram, die installation/removal, or access to trapped-pressure/gravity hazards, **do not assume energized setup is an acceptable substitute for isolation and engineered mechanical support**. Determine the actual exposure and applicable energy-control procedure. Even with pump off, pressure may be trapped and gravity may move the beam. A mere output-inhibit bit or valve-position indication is insufficient.

## Human-factors design: make the safe setup path the shortest path

- Give the operator an unambiguous mode indicator and a physical, easy-to-reach enabling device with the correct selected product and independent safety evaluation; never present an ordinary HMI button as a safety-rated hold-to-run.
- Provide dedicated, reachable die-handling supports and rated mechanical blocking/restraint selected for the machine. A guard that must be removed with difficult tools every tool change encourages defeat; redesign accessibility without silently relaxing the protection.
- Separate three visibly different tasks: **production bend**, **energized observation/adjustment under an engineered alternative protective method**, and **isolated die service**. Each needs its own entry/exit criteria; do not let an operator infer equivalence from a shared "SETUP" label.
- Design a conspicuous return-to-production sequence: exit reduced-guard mode, restore protection, remove service tools/blocks using the approved method, verify safeguarded space, deliberate reset/rearm, then a fresh separate cycle start. Avoid an automatic restart from a held pedal or stale CNC command.
- An operator who cannot perform required setup without bypassing the enabling device or exposing hands to an uncontrolled gravity load has identified a design defect, not an acceptable routine shortcut.

## Adversarial commissioning questions — all NOT RUN

| ID | Challenge | Required answer/evidence |
|---|---|---|
| SET-01 | Operator selects setup mode in LinuxCNC; safety controller still sees production mode. | Mode mismatch must not silently permit hazardous motion; trace independent selector authority and disagreement behavior. |
| SET-02 | Enabling switch is held in stage 2 and a prior foot-pedal command remains active after safety reset. | No motion without a new independently authorized motion request; verify retained-command handling and actual stop path. |
| SET-03 | Operator panics and squeezes to stage 3; controller continues a queued move. | Safety response independent of ordinary queued trajectory; require physical stopping witness. |
| SET-04 | Switch is replaced by a nominally similar model with different contact map. | Requalify exact suffix, contact function, wiring, safety input diagnostics and reset sequence; no assumed equivalence. |
| SET-05 | Safety outputs indicate disabled, but ram drifts while dies are being changed. | Physical safe state not established; block personnel exposure, isolate and restrain under machine-specific verified procedure. |
| SET-06 | Supervisor calls die-setting a "minor tool change" to avoid lockout. | Determine whether it occurs during normal production and meets *all* exception conditions, including effective alternative protection; do not presume an exception. |
| SET-07 | Helper stands in rising-sheet sweep while operator holds enabling switch. | Die-line and sweep hazards require separate protection; enabling permission is not a whole-area occupancy witness. |
| SET-08 | Stage 3 is released back to stage 2 and a motion resumes without fresh deliberate command. | Reject auto-resume; trace selected device/evaluation and safety controller restart semantics, not just contact continuity. |
| SET-09 | A technician uses ordinary proportional X7/X8 position feedback as proof that independent Pilz hydraulic safety valves are safe. | Distinguish normal valve position from safety-valve proving and from beam physical restraint; preserve UNKNOWN. |
| SET-10 | Panel PC reboots with an HMI setup flag preserved. | Require fresh safety-mode authorization; ordinary saved settings must never authorize personnel-exposed hazardous motion. |

These are *design review cases*, not performed tests. Do not assign PASS, PL/SIL, stopping distance, speed, pressure threshold, or proof-test interval without exact product/application and physical evidence.

## Selected ERMAK / OpenPressBrake evidence gate

Public OpenPressBrake Rev1 source at commit `92cf5424be90f45f664ba2652dc725b38e1895f9` separates ordinary proportional X7/X8 analog feedback, retained Pilz hydraulic valve proving 30/31/32, and the absent physical ram stop/hold witness. It does **not** establish that a three-position enabling device is installed, nor any safety-rated setup mode. The installed Pilz program, pedal model/contact map, AKAS optical modes, safety output modules, hydraulic schematic, mechanical ram blocking, and actual restart behavior remain **UNKNOWN**.

To qualify an actual setup procedure, obtain read-only hardware identity and safety program; map all modes, selectors, guard/AKAS requests, pedals and final elements; inventory electrical, hydraulic and gravity energy; define independent safety-function SRS and maintenance energy control separately; document manufacturer-approved restraint; then validate physical motion/holding and rearm. If minimum protection cannot be established, **no personnel-exposed operation**; any necessary experimental motion is isolated/remote with people outside the danger zone and residual risk documented.

## Package handoff and change control

Instantiate `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/HF/VAL/PT/RR/UNK` records in `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md`. A changed enabling switch, safety program, mode selector, pedal, die, guard or hydraulic element creates `CHG` and makes dependent validation `STALE` until reviewed. Preserve 2520–25F0 external blind-evaluation gates. This lesson does not authorize any physical operation.
