# 4400 — ROSS H L-O-X manual hydraulic isolation versus physical ram proof

**2026-10-22 | Evidence:** DOC-CONFIRMED manufacturer public pages for product-family claims; INFERENCE for missing-proof analysis; UNKNOWN selected model, actual circuit and physical performance. **No physical test, schematic freeze, hydraulic truth table or pressure threshold.**

## Discriminating question

If a padlockable manual hydraulic lockout valve is OFF and its optional pressure indicator reads zero, is a hydraulic press brake's suspended ram safe for maintenance? **Not established.** The lockout device may isolate a defined supply/port region. It does not establish every downstream trapped volume, cross-connected actuator line, load-holding mechanism, or gravity load path. The physical safe-state proposition must be specified and verified independently.

## Primary-source product evidence

1. **DOC-CONFIRMED:** ROSS H L-O-X manufacturer operating-instruction landing page describes a manually operated X-bore hydraulic lockout valve, a padlockable closed position, optional pressure gauge and optional OFF-position limit switch. It explicitly distinguishes the manual isolator from an emergency-stop device. Source: https://www.rosscontrols.com/en/documents/6760/hydraulic-lockout-valve (RC-HLOX-OI landing page).
2. **DOC-CONFIRMED:** ROSS series page describes separate T1 downstream-bleed and T2 pump-bypass tank connections and an optional pressure sensing port on A. Source: https://www.rosscontrols.com/en/series/3133-hydraulic-lockout-valve . These are product-family descriptions, not a selected machine's plumbing or acceptance test.
3. **DOC-CONFIRMED:** The manufacturer calls the valve a maintenance energy-isolation device, **not** a dynamic emergency-stop final element. This is the critical allocation distinction. The ordinary LinuxCNC/FPGA command path and a safety relay must not be replaced by a manually padlocked valve for runtime personnel protection.
4. **INFERENCE:** A gauge on a single port can only address pressure communicated to that sensing point under the actual circuit conditions. A check valve, closed directional valve, blocked branch, external pressure source or gravity load can defeat a blanket 'all energy absent' conclusion. The precise mechanism must be established from actual drawings and physical evidence, not presumed.
5. **UNKNOWN:** The manufacturer's actual downloadable PDF/schematic was not independently inspected in this session; the vendor landing pages do not establish a full port truth table. The selected model/suffix, return routing, cross-port paths, gauge location, internal leakage, pump state, accumulator boundaries, ram restraint, and required test points remain unknown. Do not infer these from a marketing sentence that broadly implies safe servicing after locking.

## Witness allocation

| Claim | Candidate witness | Why it is not enough alone |
|---|---|---|
| Manual valve is padlocked OFF | Physical padlock/handle observation; optional limit switch for indication | OFF indication does not prove internal seal state, every pressure path, or ram restraint. |
| Selected supply path isolated | Verified selected isolator and circuit boundary | Parallel feeds, accumulator and trapped downstream pockets may remain. |
| A-port pressure below justified limit | Appropriate calibrated gauge/test point and procedure | One point may not communicate with other volumes; zero does not establish gravity restraint. |
| Ram cannot descend during exposed maintenance | Rated mechanical restraint and independent physical proof appropriate to the machine | Valve status, pump OFF, pressure at one point and ordinary LinuxCNC state cannot substitute. |

## Adversarial review — no energized experiments authorized

- Padlock is present, but optional OFF-limit signal is stuck high: treat electrical feedback as untrusted and verify physical isolator state under safe conditions.
- Port-A gauge is zero, but an isolated cylinder chamber is still charged: reject the global 'pressure safe' claim; identify and verify each relevant pocket.
- Pump is isolated, but beam creeps under gravity: physical motion contradicts the supposed safe state; do not authorize personnel exposure.
- Maintenance crew must remove a guard to reach the padlock hole: change access/placement; repeated defeat incentive is an engineering failure.
- Valve is used as an automatic stop device: reject unsupported substitution; allocate runtime safety stopping to the separately designed safety-related control and final elements.

**Safety package:** `ENE/PHY/SRS/AUTH/DEP/ARC/VAL/PT/HF/UNK`. A specific circuit drawing and qualified physical verification would be required to promote any selected-machine claim. **No personnel-exposed hazardous operation** is authorized by this product research.
