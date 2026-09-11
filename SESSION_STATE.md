# Active Curriculum Session State

Session start UTC: `2026-09-11T13:11:03Z`
Session end UTC: `2026-09-11T13:12:28Z`
Actual elapsed: **1.4 minutes**
Status: **CLOSED — bounded Ursviken final-source search completed; second independent 2018 press-brake implementation and failure-driven valve-actuator feedback evolution documented.**

Results: the Ursviken/Pullmax thread still ends at the 22 Jul 2026 success report and no promised final downloadable Y1/Y2 config/repository was located in the bounded post-success search. Preserve `FINAL SOURCE UNAVAILABLE` and do not repeat the search without new evidence. The independent 2018 project progressed beyond its initial source skeleton to actual machine motion; its builder reported jumpy motion, nonlinear synchronization compensation, and then a pressure-relief event that mechanically kicked the stepper-driven hydraulic valve and caused lost valve position. This provides field evidence for separating outer ram synchronization from inner stateful-actuator observability/control rather than treating emitted command as physical actuator truth.

Next checkpoint: find executable public state-to-hydraulic-decoder evidence with a nontrivial mode such as decompression and explicit mid-state ordinary-enable/fault handling. Trace `semantic press state -> abstract process/hydraulic mode -> machine-specific decoder -> final ordinary actuator authorization`, and inventory every stateful intermediate actuator for command-vs-actual divergence and its earliest witness. If mature press-brake source remains unavailable, use a bounded adjacent hydraulic LinuxCNC implementation only as clearly labeled non-press-brake architecture evidence. Preserve S02/E20/X01/X02 fresh-AI separation, F02 block, and PB-PREP-001 INCONCLUSIVE.

Overlap: **No overlap.** Previous canonical lesson ended `2026-09-11T12:26:21Z`, **44m42s** before this session began. No laboratory job was launched.
