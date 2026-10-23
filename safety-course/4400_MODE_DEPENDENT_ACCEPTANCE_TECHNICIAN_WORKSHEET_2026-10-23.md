# Technician worksheet — mode-dependent safeguard acceptance (4400 / 2590 / 25F0)

**Status:** learner-facing exercise, **NOT RUN**, not an installation instruction or a machine release certificate. Reference: Fiessler AKAS-5M doc 1581, 2024-02-15, printed pp.11,24–26,43; `research/4400_AKAS_DEVICE_INSPECTION_VS_MACHINE_SAFETY_ACCEPTANCE_2026-10-23.md`.

## Scenario

A press-brake laser unit passes its manufacturer's test-rod/device inspection. A new deep box tool needs a different mode. The HMI reports `LASER OK`, the ordinary controller commands slow motion, the valve-position switch indicates its expected state, and the operator says the previous tool worked fine. The measured ram speed, stop/overrun, trapped-pressure state, reach geometry and exact safety-controller configuration have **not** been supplied.

### Evidence separation exercise

| Proposition to prove | Legitimate witness | Current evidence classification | Release consequence |
|---|---|---|---|
| Device can detect intended test interruption | Manufacturer-prescribed device check and product identity | UNKNOWN (scenario claims pass but no trace) | Device-level evidence only |
| New tool's accessible zone remains protected in each mode | Selected receiver-element/guard/tool geometry and exposure analysis | UNKNOWN | No credit for altered protection |
| Actual speed/position is safety-qualified during muting | Independent selected safety-related sensing/control and machine validation | UNKNOWN | Do not equate normal NC slow command with safe speed |
| Safety demand reaches physical final elements | Selected controller, output, final-element and narrow feedback evidence | UNKNOWN | HMI/OSSD status is insufficient |
| Beam/ram has achieved required physical safe state | Independent physical stopping/holding and residual-energy evidence | UNKNOWN | No personnel-exposed hazardous operation |
| Restart cannot occur solely on guard/field restoration | Independent reset/rearm and separate ordinary start evidence | UNKNOWN | Do not release on status restoration |

**Student task:** For each row create `SRS`, `PHY`, `AUTH`, `DEP`, `ARC`, `VAL` and `UNK` links in the cumulative Safety Design Package. State what would falsify the claim, which evidence could close it, and which old `VAL/PT` entries must become `STALE` following the tool/mode change. Do not assign numerical acceptance thresholds without a justified selected-machine basis.

### Six adversarial questions

1. Why does a passed manufacturer device checklist not certify the entire machine safety function?
2. Which portion of the physical protection disappears during the exact documented box/blanking transition? What remains protected, and what is unknown for this tool?
3. What independent evidence is required if LinuxCNC requests slow speed but actual ram motion disagrees?
4. If a guard is already open when the laser is interrupted, why is a continued stop not a causal proof of laser protection?
5. How can a plausible valve-position signal coexist with unsafe ram movement or stored pressure?
6. Which low-cost redesign makes correct box-mode operation and guard restoration easier than bypassing safeguards?

### Grading / review boundary

An acceptable response keeps the four evidence layers distinct, preserves `UNKNOWN` for selected-machine physical facts, refuses to infer a PL/SIL or safe speed from a product label, and blocks machine release when a physical witness contradicts a healthy diagnostic. No hidden external evaluation key is embedded; this is a development exercise, not a 2520–25F0 information-separated graduation test.
