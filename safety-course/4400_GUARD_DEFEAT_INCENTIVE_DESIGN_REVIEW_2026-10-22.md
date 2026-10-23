# 4400 — Guard-defeat incentive: redesign the work, not just the warning label

**Learner-facing field exercise; NOT BLIND / NOT RUN.** Applies to 2510, 2590, 25C0 and 4400. Based on IFA/DGUV research and its MaSeM method; no site-specific assessment has been performed.

## Source-first engineering basis

The German Social Accident Insurance's IFA describes a task-based method, **MaSeM**, that evaluates the benefit a person obtains by bypassing a protective device. The required inputs include operating mode, guard, task performed in the safeguarded space, and the expected advantage of defeat (for example faster throughput or better view). The official English explanation is at https://www.dguv.de/ifa%3B/praxishilfen/practical-solutions-machine-safety/defeating-protective-devices/web-app-masem/index.jsp . A separate IFA research summary at https://www.dguv.de/ifa/forschung/projektverzeichnis/bgia_5089-2.jsp reports recurring ergonomic and workflow drivers including setup, fault remediation, retooling and inadequate process visibility. These are `DOC-CONFIRMED` reports about the study/method, not measured behavior at a particular machine.

## Field review: four work transactions

For each transaction, observe the **correctly safeguarded workflow** before changing hardware. No guard bypass is necessary or permitted to perform this assessment. Ask operators and maintainers what would make the legitimate task faster and more reliable.

| Task | Safe workflow steps/time and visibility | Predictable defeat incentive | Safer architecture/usability correction | Physical/safety proof that must remain |
|---|---|---|---|---|
| Load/unload a workpiece | | | | |
| Recover from a nuisance guard trip | | | | |
| Adjust tooling or clean a jam | | | | |
| Service/replace a switch or guard | | | | |

Do **not** fill in fictional task times. Observe and record real workflow friction, or mark it `UNKNOWN`. A time-saving measure that reduces independent protective coverage is not automatically an improvement.

## Design patterns worth evaluating

1. **Diagnostic locality:** Identify the specific open/misaligned guard without repeatedly opening unrelated doors. Ordinary HMI status may aid maintenance, but is not a substitute for independent safety-related sensing.
2. **Mechanical repeatability:** Hinges, alignment stops, captive hardware and cable routing should make correct reinstallation straightforward and resistant to vibration/sag. Verify installed strength and exact actuator relation.
3. **Planned access:** Provide a clearly labeled approved setup/recovery path with protection suited to that mode, instead of rewarding improvised bypasses. Never assume that “maintenance mode” authorizes exposed dangerous motion.
4. **Safe reset and escape:** Reset should be deliberate and appropriately located; a closed gate or clear field is not proof that the zone is unoccupied. Provide the machine-specific inside escape and rescue capability where necessary.
5. **Preserve fault evidence:** Avoid a series wiring arrangement in which routine opening of a different door can erase a fault indication. Check selected receiver's diagnostic memory and sequence before accepting the design.

## Measurable acceptance propositions

- `HF-*`: At least three frequent access tasks have observed time/friction and user feedback, with concrete mitigation of the strongest bypass incentive.
- `DEP-*`: Fault masking and shared supply/cable/diagnostic resources are accounted for.
- `SRS-/PHY-*`: Independent safety-related detection and the machine's physical stop/hold state remain proved after convenience changes.
- `VAL-*`: Reinstallation, fault diagnosis, power loss/restoration and restart are validated with machine-appropriate independent witnesses.
- `CHG-*`: Every mechanical, wiring, software or workflow modification marks affected evidence `STALE` until revalidated.

**Release decision:** If the actual machine cannot demonstrate minimum safe-to-operate protection, do not run it with people exposed. Any justified experimental operation must be isolated/remote with people outside the danger zone and residual risk documented. A positive MaSeM result or usability score alone cannot certify a machine.
