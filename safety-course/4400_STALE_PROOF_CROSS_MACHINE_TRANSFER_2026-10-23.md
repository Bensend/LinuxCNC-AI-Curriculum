# 4400 cross-machine transfer — a PASS is not timeless proof

**Educational adversarial exercise.** The Fiessler AKAS-5M manufacturer source demonstrates an explicit *triggered* automatic overrun check, but the examples below are **analogy and engineering inference**, not claims that the same device, standard interval, or safety category applies to other machines. No hardware was tested.

## Reusable three-layer method

For every machine, name (1) the selected protection configuration and its actual scope, (2) the time/trigger and safety authority of a current diagnostic or proof test, and (3) an independent physical witness for the hazard. Record stale evidence and change impacts. Never promote a LinuxCNC HAL bit, an ordinary FPGA state, or a convenient dashboard PASS into independent personnel-safety authority.

| Machine | Configuration identity | Freshness trigger to investigate | Physical proposition the diagnostic does not establish | Adversarial change |
|---|---|---|---|---|
| Press brake | Optical variant, tool/laser geometry, safety PLC, configured overrun limit | Initial/first-stroke/power reset and manufacturer-defined periodic test | Actual ram stop, load holding, workpiece/helper sweep and residual pressure | Receiver replaced or box-mode blanking enabled |
| Mill/VMC | Guard/access boundary, selected spindle drive and safety chain | Guard or drive replacement, loss/restoration of safety supply, applicable proof-test plan | Spindle standstill, ejection containment, maintenance isolation | Guard actuator changed while old green status remains |
| Lathe | Chuck/spindle access, guarding, drive stop path | Brake/drive work, changed chuck/inertia, validation trigger | Chuck stop and workpiece retention | New high-inertia chuck but prior stop test reused |
| Plasma/laser table | Enclosure/extraction, process energy, access interlocks | Consumable/service or process change, extraction fault/restart | Arc/laser energy absence, fumes, fire and stored power | Plasma controller disabled while process power remains energized |
| Robot/automated cell | Zone mapping, gate/safety-network topology, selected safe-motion function | Added gate/node, safety logic change, tool/payload change | Zone occupancy, robot standstill, gravity/tool load restraint | Added gate is physically present but absent from active safety topology |

## Information-separated evaluation prompts (learner-facing only)

1. For a lathe with a newly installed heavy chuck, classify an old brake test as `PASS`, `STALE`, or `UNKNOWN` and name the exact change-impact evidence needed. Do not invent a stopping time.
2. A robot cell displays the first guard trip address. Can it prove all other guards are closed or that the cell is unoccupied? Explain the limited proposition.
3. A press brake has a current automatic overrun PASS but has not independently verified post-setup optical-field restoration. What two transactions remain separate?
4. A mill reports STO active and drive healthy. What physical propositions about spindle standstill and electrical isolation are still unproved?
5. An operator repeatedly defeats an awkward safeguard to clear material. Propose an accessible, low-complexity guard/diagnostic redesign without moving the safety decision into ordinary LinuxCNC.

No hidden answer key is provided; preserve the repository's blind-evaluation information separation. If a machine cannot meet a minimum safe-to-operate threshold, do not operate with people exposed. Isolated remote experimental operation still requires explicit residual-risk controls.
