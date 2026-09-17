# Safety Test-Point and Witness Maintainability Audit

## Purpose

A verification method can be sound on commissioning day and become misleading later because its test point, sensing path, label, isolation valve, adapter, calibration state, physical access, or restoration state changed.

Frozen rule:

> **A safety verification witness is not durable merely because it once worked. Its complete physical observation path must remain accessible, identifiable, capable, protected from silent isolation, and restorable over machine life.**

This worksheet extends `SAFETY_VERIFICATION_INSTRUMENT_TRUST_CHAIN_WORKSHEET.md`. It does not assign machine-specific voltage/pressure thresholds, meter categories, calibration intervals, hydraulic test-port ratings, or acceptable stopping values without installed evidence.

## Evidence labels

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A missing safety-critical fact remains `UNKNOWN — NOT CLEARED` for the affected exposed task.

## Authoritative source basis

### OSHA hazardous-energy verification

`SOURCE-CONFIRMED` — 29 CFR 1910.147 requires effective isolation/deenergization to be verified before servicing and requires continued verification where stored energy can reaccumulate. OSHA guidance states that verification may require a combination of methods and can include monitoring instruments; hydraulic/pneumatic systems may require bleed valves.

Engineering consequence (`INFERENCE`): a machine whose intended verification point is inaccessible, unlabeled, silently valved-off, blocked, or otherwise incapable of observing the relevant hazard has lost part of the practical verification architecture even if the safety controller still reports healthy.

### OSHA LED interpretation

`SOURCE-CONFIRMED` — OSHA's 2012 interpretation states that a safe-looking LED indication alone does not satisfy the affirmative isolation-verification requirement.

Engineering consequence (`INFERENCE`): an HMI/PLC/FPGA indication is useful diagnostic evidence but must not become the only practical witness merely because physical test access was omitted or became inconvenient.

### OSHA mechanical-energy verification examples

`SOURCE-CONFIRMED` — OSHA interpretation guidance recognizes visual verification such as checking installed safety blocks or a sight glass and appropriate instruments for different energy types.

Engineering consequence (`INFERENCE`): physical inspection points for restraints, pressure state, motion state, and other hazard witnesses deserve lifecycle treatment comparable to electrical test points.

## Audit inventory

Create one row for every witness that may be relied upon to clear exposure or diagnose a safety function.

| ID | Hazard / claim | Witness or test point | Physical location | Observation path | Can it be isolated from hazard? | Access requires defeating safeguard? | Label / drawing ID | Capability/status evidence | Restoration requirement | Current status |
|---|---|---|---|---|---|---|---|---|---|---|
| TP-__ |  |  |  |  |  |  |  |  |  | `UNKNOWN` |

Examples to inventory, without assuming any machine has them:

- electrical line/load-side verification points;
- DC-bus or stored-charge witness points;
- hydraulic pressure test ports, bleed points and accumulator witnesses;
- pneumatic dump/downstream pressure witnesses;
- mechanical block/restraint engagement inspection points;
- brake engagement/release witnesses;
- contactor/valve final-element auxiliary or EDM feedback;
- guard-lock position and locking-force/status evidence where applicable;
- independent motion/position observations;
- service test connectors and keyed test fixtures;
- safety-controller diagnostics used only as supporting evidence.

## Failure-path challenge

For each witness, challenge at least these paths.

### 1. Correct point, wrong accessibility

- Can a qualified/authorized maintainer reach the intended point without entering the hazard before verification is complete?
- Does reaching it require removing a guard that creates a new hazard?
- Has enclosure growth, replacement equipment, cable duct, plumbing or a retrofit made it inaccessible?
- Does poor access predictably drive technicians toward an HMI-only shortcut?

If yes, classify the access design as an engineering/human-factors defect rather than normalizing the shortcut.

### 2. Correct instrument, disconnected hazard

Challenge:

- gauge/test port behind a closed isolation valve;
- plugged/capped sensing line;
- clogged snubber/orifice;
- disconnected pressure tube;
- open fuse in a voltage-sensing branch;
- broken common/reference conductor;
- replaced sensor wired to a different physical volume/node;
- auxiliary contact no longer mechanically representative of the claimed final element.

A plausible zero/healthy reading is not proof if the witness can silently lose connection to the hazard.

### 3. Correct point, stale identity

Check whether the physical label still agrees with:

- current drawing revision;
- current wire/hose number;
- current machine option;
- current sensor/transducer identity;
- current safety validation record;
- current service procedure.

A label inherited from a previous circuit or plumbing revision is an evidence defect.

### 4. Temporary test hardware becomes permanent architecture

Inventory:

- temporary hoses;
- adapters;
- breakout plugs;
- jumper harnesses;
- external supplies;
- clip leads;
- temporary gauges/transducers;
- forced diagnostic states.

Require an explicit install -> test -> account -> remove -> restore -> reverify lifecycle. If temporary hardware is repeatedly required, consider designing a protected permanent test point rather than institutionalizing improvisation.

### 5. Capability and status uncertainty

Do not infer a universal calibration interval or meter category. Instead record the actual requirement from the applicable instrument/manufacturer/procedure.

Challenge:

- unknown calibration/status;
- damaged leads/probes;
- wrong measurement range/function;
- blocked gauge needle;
- failed sensor supply;
- damaged sight glass;
- dirty/obscured mechanical witness;
- diagnostic value frozen by software/network failure.

If witness capability is uncertain, the claim it supports is not cleared by that witness alone.

### 6. Reaccumulation blind spot

If energy can reaccumulate, ask whether the witness remains observable for the required period. A single zero reading may establish only one instant.

Examples: accumulator recharge, gravity-driven pressure generation, thermal pressure rise, backfeed, capacitor recharge, pneumatic cross-feed.

Exact monitoring duration/threshold remains machine-specific `UNKNOWN` until evidence establishes it.

## Design-for-maintainability rules

1. Put verification access on the safe side of the exposure boundary where practicable.
2. Make the intended physical witness easier to use than a software shortcut.
3. Label test points to the current drawing/procedure identity, not only with a generic `TP1`.
4. Where a witness can be isolated from the hazard by a valve/fuse/switch/sensing element, make that dependency explicit in the verification procedure.
5. Protect test points against accidental shorts, contamination, hose damage, misconnection and defeat.
6. Do not add a test point whose presence creates a larger unmitigated hazard.
7. Treat replaced sensors/gauges/aux contacts as change-control items when their failure behavior or observation path matters to verification.
8. Include test-point/witness restoration in return-to-service reconciliation.
9. Preserve an independent physical witness when a software indication can fail plausibly in the same fault that is being diagnosed.
10. If maintainers routinely bypass a safeguard solely to access a verification point, redesign the access/verification architecture where practicable.

## OpenPressBrake application boundary

For OpenPressBrake, ordinary LinuxCNC/HAL values, FPGA registers, watchdog status, proportional-current telemetry and HMI indications may support diagnosis but are not automatically independent proof of hazardous-energy isolation.

Before any installed OpenPressBrake point is promoted from `UNKNOWN`, capture at minimum:

- actual schematic/plumbing/mechanical location;
- what hazard state it can and cannot prove;
- whether it can be silently disconnected from that hazard;
- access path relative to the hazard zone;
- instrument/witness capability requirement;
- physical label/drawing identity;
- restoration requirement after use;
- evidence that the point still observes the intended installed node.

## Cross-machine transfer prompts

### Press brake

Can ram restraint and relevant hydraulic state be verified without placing the technician beneath an unproved gravity load? Does the gauge/test port observe the trapped volume that matters to the task, or only pump discharge?

### Plasma table

Can torch/drive hazardous-energy states be verified without relying only on LinuxCNC enable bits? Are high-voltage/ignition-related test points physically controlled and appropriately bounded by the actual equipment documentation?

### Mill / lathe

Can spindle/drive isolation, stored bus energy, pneumatic/hydraulic workholding and gravity axes be independently observed where the maintenance task requires it?

### Robot / automated cell

Can final-element/safe-motion status and retained pneumatic/gravity/tool energy be checked from a position that does not require premature entry into the safeguarded space?

## Acceptance gate

A verification witness is **maintainability-cleared** only when evidence establishes:

- correct hazard/node;
- usable and safe access;
- durable identification;
- witness/instrument capability;
- no unaccounted silent-disconnection path, or that path is itself checked;
- applicable reaccumulation observation;
- restoration after testing;
- current configuration/document applicability.

Otherwise retain `UNKNOWN` or the narrower supported claim. Never upgrade a diagnostic indication into physical-isolation proof simply because the proper physical test point is inconvenient.
