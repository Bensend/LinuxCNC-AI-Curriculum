# Press-brake 3600 — pressure, tonnage and crowning ownership

Date: 2026-09-12
Status: DOC/COMMUNITY-SYNTHESIZED OWNERSHIP CONTRACT

## Purpose

Separate three press-brake concepts that are often presented together in commercial controls but are not interchangeable:

- hydraulic pressure / pressure-valve command and feedback;
- estimated or measured force/tonnage;
- crowning/deflection compensation.

The curriculum deliberately does not invent numeric limits, hydraulic formulas or machine capacities.

## Commercial-controller evidence

### Cybelec CybTouch

Official CybTouch documentation exposes pressure and crowning as calculated/programmed bend functions and keeps crowning correction separate. The manual states that crowning can be automatically calculated from material, material thickness, material sigma and bending length, and can also be manually corrected. If those calculation inputs change, the calculated crowning value is recalculated.

The manual also warns that disabling the crowning function does not necessarily physically return the crowning system to zero; the hardware can remain at its last position. That is a strong state-ownership lesson: **disabled calculation/command generation does not prove neutral physical actuator state**.

### Cybelec valve-interface architecture

Cybelec's public CybMVA description explicitly separates channels for Y1/Y2 valves, one pressure valve and one crowning valve. Depending on machine configuration, it can drive proportional valves with feedback, open-loop proportional valves, valves with integrated amplifiers, servo valves, or hybrid systems.

This supports a generic interface boundary in which Y motion, pressure control and crowning are separate actuator/control channels even when one controller coordinates them.

## Public LinuxCNC press-brake field evidence

The public Accurpress configuration/evolution already audited in this curriculum shows pressure acquisition being added and later integrated into ordinary control while the architecture continued to evolve. The field implementation demonstrates that pressure can be an ordinary process witness/control input, but it does not provide universal pressure limits or a generic pressure-to-tonnage formula.

The same evidence base reinforces that final hydraulic behavior remains machine-specific.

## Ownership layers

A generic model is:

```text
Bend recipe / product intent
    |
    +--> requested bend/ram trajectory
    |
    +--> requested pressure/force policy
    |
    `--> requested crowning policy
             |
             v
machine-specific calculations / limits / calibration
             |
             +--> Y1/Y2 command allocation
             +--> pressure-valve command
             `--> crowning actuator command
                       |
                       v
               physical plant + sensors
                       |
                       +--> Y1/Y2 feedback
                       +--> pressure feedback
                       `--> crowning position/state feedback (if available)
```

A controller may calculate several of these from common product inputs, but the outputs and physical witnesses remain distinct.

## Pressure versus tonnage

Pressure is a measured or commanded hydraulic variable. Tonnage/force is a mechanical quantity that may be estimated from pressure and effective hydraulic/mechanical geometry or measured by another sensing method.

Therefore:

- do not label raw pressure as tonnage without a justified machine model/calibration;
- preserve the pressure sensor's scale/calibration provenance;
- preserve any pressure-to-force model revision separately;
- if force is independently measured, distinguish measured force from calculated force;
- a pressure threshold and a structural/tooling tonnage limit are not automatically the same limit.

No generic conversion constant belongs in this public curriculum.

## Crowning ownership

Crowning compensates for load-dependent machine/tool deflection to improve bend result. Commercial documentation shows it can depend on material/process inputs and can have its own correction layer.

The generic data path should therefore distinguish:

```text
nominal crowning calculation
    + empirical/program correction
    = effective crowning request
    -> crowning actuator command
    -> physical crowning state (where observed)
```

The crowning request belongs in the same provenance discipline as other TargetSet-like values: method revision, machine/tool/material dependencies and correction revision should be retained.

## Critical disabled-state lesson

The CybTouch manual's warning that deactivating crowning can leave the physical crowning system at its last position means the HMI/control logic must distinguish at least:

- calculation enabled/disabled;
- current requested crowning value;
- last commanded value;
- physical crowning position/state when available;
- whether the next bend recipe assumes neutral or retained crowning.

This is analogous to the broader curriculum rule that software state is not automatically physical state.

## Fault and recovery implications

### Pressure signal invalid

If pressure is required for the current process state's ordinary completion/fault logic, invalid pressure evidence must invalidate that decision path rather than being silently replaced with the last value. Whether motion must stop, hold or reconcile is machine/process-specific.

### Crowning state unknown after restart/disable

Do not assume zero merely because the feature is disabled or software restarted. Require the machine-specific initialization/reference/reconciliation behavior appropriate to the actuator before a bend that depends on known crowning state.

### Pressure command recovers after fault

Recovered command/communication does not prove pressure physically reached the request, and neither proves a valid tonnage calculation. Keep command, sensor and derived-force validity separate.

## HMI requirements

At minimum, when relevant to the machine, display separately:

- pressure request and measured pressure;
- pressure sensor validity/calibration revision;
- calculated force/tonnage and its model validity if used;
- crowning nominal request, correction and effective request;
- crowning actuator/physical state if observed;
- stale/unknown state after restart or invalidation;
- source of any limit that is active (machine protection, tooling/process configuration, ordinary recipe policy, external safety/protection system).

Avoid one generic `PRESS OK` lamp that hides these distinctions.

## Boundary with external protection/safety

Ordinary LinuxCNC/CNC pressure and crowning control does not establish a safety-rated overpressure function, tooling protection function, safe stopping function or structural protection level. If the machine has independently engineered hydraulic relief, safety valves, monitored pressure protection or external control, preserve that boundary explicitly.

## What remains machine-specific

- hydraulic cylinder areas and mechanical leverage;
- pressure-to-force/tonnage conversion;
- maximum machine/tooling pressure and force limits;
- decompression pressures/rates;
- crowning actuator type, zero/reference and range;
- crowning calculation coefficients;
- legal valve combinations and pressure-control topology;
- dynamic response, tolerances and commissioning criteria.

These are not gaps to fill by copying values from commercial examples.

## Evidence sufficiency decision

The generic ownership question is sufficiently resolved without a synthetic physics experiment: independent commercial documentation shows distinct pressure/crowning functions and actuator channels, while public LinuxCNC field evidence shows pressure being integrated as machine-specific ordinary control. A useful future experiment requires either executable machine-specific decoder logic or an inspectable generic implementation whose behavior is genuinely ambiguous.

## Next work

Re-check F02 first. If still externally blocked and no new tandem/hydraulic source appears, the current 3600 generic evidence pass has reached a natural checkpoint: backgauge/operator modes, DXF/program ownership, correction/calibration, commissioning/recovery, HMI provenance, and pressure/crowning ownership all have durable contracts. The next step should be a structured 3600 integration/playbook outline or a new real implementation source, not another isolated synthetic contract.
