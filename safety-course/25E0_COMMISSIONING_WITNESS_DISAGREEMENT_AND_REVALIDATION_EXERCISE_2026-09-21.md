# 25E0 Adversarial Exercise — Witness Disagreement and Revalidation

## Scenario

A vertical machine axis has the following observations available during commissioning:

- independent safety logic has demanded the hazardous drive/energy path safe;
- a monitored valve-position signal reports the expected shutoff position;
- a pressure switch is located upstream of the cylinder/load-holding section and reports below its configured threshold;
- an encoder reports zero speed;
- an electrical brake-status switch reports brake applied;
- the last approved active brake proof test passed before a brake replacement;
- the ordinary LinuxCNC `cycle-start` input has remained physically asserted throughout maintenance;
- the safety controller has been reset after the guard was restored;
- the ordinary FPGA/controller reports all normal diagnostics healthy.

During maintenance, the brake was replaced with the same catalog family, a hose and fitting downstream of the pressure-switch measurement point were changed, and a temporary commissioning jumper was used to simulate one non-safety diagnostic input.

## Questions

1. Which observations are evidence of final-element state, process state, retaining capability, ordinary-control health, and historical proof-test evidence?
2. Does upstream low pressure prove that pressure/trapped energy is safe at the cylinder/load-holding volume? Explain the witness-location problem.
3. Does zero speed prove that the vertical load is securely retained? Why or why not?
4. May the pre-maintenance brake proof result be treated as proof of the replacement brake's holding capability?
5. Does safety reset make the continuously asserted `cycle-start` fresh?
6. What must be done with the temporary commissioning jumper before production acceptance, and what evidence is needed after removal?
7. Construct a proposition-to-witness matrix for the minimum claims that must be established before personnel exposure is allowed. Mark machine-specific thresholds/requirements `UNKNOWN` where the scenario does not provide authority.
8. Propose safe disagreement tests that distinguish valve-position evidence from downstream pressure/energy evidence and brake-status evidence from brake-capability evidence. Do not propose hazardous energized fault injection with people exposed.
9. Which maintenance changes trigger revalidation and why? Do not answer merely 'all changes'; connect each change to the safety claim it can invalidate.
10. Identify which decisions belong to independent safety authority and which may legitimately be implemented as additional ordinary LinuxCNC/FPGA inhibits or diagnostics.

## Expected reasoning boundaries

A strong answer must preserve these distinctions without inventing missing machine data:

- valve-position evidence is not downstream pressure/energy evidence;
- a pressure witness has authority only at/through the physical measurement architecture actually justified;
- zero speed is instantaneous motion evidence, not retaining capability;
- a brake switch is not a torque proof;
- replacement of a challenged mechanical retaining element invalidates reliance on an earlier proof result unless the applicable validation procedure establishes otherwise;
- safety reset is not ordinary demand freshness;
- a temporary physical/electrical aid requires removal/inspection, not merely a clean software manifest;
- revalidation is impact-based and must include the affected physical witness/final-element chain;
- ordinary LinuxCNC/FPGA logic may add conservative inhibits and freshness checks, but it does not inherit personnel-safety authority merely because it observes the same signals.

## Safety stop condition

If the actual machine lacks authoritative acceptance criteria or adequate physical witnesses for the required safe state, the correct commissioning result is not to guess a threshold. The machine is not operated with personnel exposed; any necessary experimental operation is isolated/remote with residual risk documented.