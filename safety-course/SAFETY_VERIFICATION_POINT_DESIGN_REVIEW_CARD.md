# Safety Verification-Point Design Review Card

Use this compact card during machine design, retrofit review and commissioning so verification does not become an afterthought.

## Five questions before accepting a verification point

1. **What physical hazard state does this point actually observe?**
   - Name the electrical node, hydraulic/pneumatic volume, mechanical restraint/load path, final element, or motion state.
   - Do not answer with only a PLC/HAL/FPGA variable name.

2. **Can the witness silently lose connection to that state?**
   - valve, fuse, broken reference, blocked sensing line, software freeze, failed supply, wrong auxiliary contact, stale network value, replaced sensor.

3. **Can it be checked before entering the unproved hazard?**
   - If not, redesign access where practicable or define a different safe verification sequence.

4. **Will a maintainer still know what it is years later?**
   - durable label, drawing/procedure cross-reference, option/configuration applicability, instrument requirement, status/calibration requirement where applicable.

5. **What must be restored after using it?**
   - caps, covers, isolation valves, test hoses, adapters, temporary supplies, forced states, guards, blocks, diagnostic configuration.

## Reject these shortcuts

- `HMI says zero` -> therefore physical energy is absent.
- `EDM says open` -> therefore all hazardous energy is absent.
- `gauge says zero` without proving the gauge observes the relevant trapped volume.
- `meter says zero` without proving correct point/path/instrument capability.
- `block is visible` without proving it is correctly engaged/rated for the actual task.
- inaccessible physical verification point -> substitute software indication.

## Human-factors gate

If correct verification is awkward enough that a competent maintainer is predictably tempted to skip it, treat that as a design defect. Prefer protected, clearly identified, safely accessible verification points over procedures that depend on heroic discipline.

## Evidence disposition

- `CLEARED`: complete observation path and applicability supported by evidence.
- `LIMITED`: evidence supports a narrower claim; write exactly what it proves.
- `UNKNOWN — NOT CLEARED`: safety-critical observation path/capability/applicability is unresolved.

This card does not assign machine-specific voltage, pressure, force, timing, stopping-distance, PL/SIL/DC, instrument-category or calibration requirements. Obtain those from the installed design and applicable authoritative documentation.
