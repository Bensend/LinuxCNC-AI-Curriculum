# Safety Function Fault / Diagnostic Worksheet

Use after hazard/safety-function derivation and composition, before component selection or PL/SIL arithmetic.

## Function header

- `HZ-*` hazardous event:
- `PROP-*` required physical safe-state proposition:
- `SF-*` safety function:
- initiating condition/demand:
- allocated input(s):
- independent safety logic authority:
- final physical element(s):
- shared `DEP-*` dependencies:
- ordinary LinuxCNC/FPGA role (monitoring/normal control only):

## Fault rows

| FLT ID | Element / DEP | Fault hypothesis | Single / common-cause / latent | Effect on PROP | Detection / witness | Detection timing requirement | Reaction | Residual PROP | EVID ID | VAL obligation | Evidence class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| FLT- | | | | | | | | | | | |

## Mandatory adversarial questions

- Can both channels agree and still be wrong because they share a physical dependency?
- Can the diagnostic remain healthy while the final element/process fails?
- Can a fault remain latent until a second fault or demand?
- Does loss of a witness mean the proposition failed, or only that evidence is unavailable?
- Does maintenance/change make previously accepted evidence stale?
- Does the diagnostic depend on the same supply, mount, cable, network, process, or final element as the thing it diagnoses?
- What must happen before reset/rearm? What must be physically re-proved? Is a fresh ordinary demand required?
- Would nuisance behavior predictably encourage defeat? If yes, correct the architecture/installation/mode rather than weaken safety handling.

## Reverse dependency check

For every `DEP-*`, list every `SF-*`, `PROP-*`, `EVID-*`, and `VAL-*` that uses it. A fault in one dependency can enlarge acceptance/revalidation scope beyond the first function that reports it.

## Stop rule

If an unresolved fault can defeat a required personnel-safety proposition and no adequate detection/independent protective measure is established, do not infer safety from a component rating or green diagnostic. Keep the condition `UNKNOWN`/blocked. Do not operate with people exposed to the hazard; any necessary experimental operation must be isolated/remote with people outside the danger zone and residual risk stated.
