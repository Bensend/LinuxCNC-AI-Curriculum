# Common-cause / latent-failure analysis and minimum-safe-to-operate gate — 2026-09-17

## Purpose

Extend the commissioning package beyond obvious single faults. Redundancy is not enough when two channels can be defeated by the same cause, and diagnostics are not enough when a dangerous fault can remain latent until the next demand.

This is generic curriculum guidance, not a machine-specific PL/SIL calculation or validation certificate.

## Evidence basis

### DOC-CONFIRMED — common cause can defeat redundant channels

SICK's current *Guide for Safe Machinery* (8007988/2026-05-11) treats common-cause failure as a distinct contributor even in fault-tolerant structures and includes common-cause factor, diagnostic coverage, mission time, test interval and component failure rates in quantitative subsystem treatment. It also distinguishes HFT 0 from HFT 1. Source: https://www.sick.com/media/docs/8/78/678/Special_information_Guide_for_Safe_Machinery_en_IM0014678.PDF

An earlier SICK machinery-safety guide gives practical CCF examples/measures: simultaneous channel failure from interference, with measures including isolated cable routing, suppressors and component diversity. Source: https://www.sick.com/media/docs/6/06/606/Special_information_Safety_Guide_For_The_Americas_en_IM0032606.PDF

### DOC-CONFIRMED — architecture assumptions matter

SICK UE440/UE470 application documentation explicitly conditions claimed safety characteristics on implementation details such as dual-channel cables in separate sheathing/protection, cross-circuit monitoring, and EDM/contactors wired within the control cabinet. Source: https://www.sick.com/media/docs/3/53/153/operating_instructions_ue440_ue470_compact_safety_controller_en_im0014153.pdf

Pilz's 2026 PSENop4S/PSS application note identifies common-cause failure as an implementation prerequisite that must be tested in the implementation; its example safety function traces sensor -> input -> logic -> output -> paired contactors. Source: https://www.pilz.com/download/open/AN_PSEN_op4S_PSS_DI2O_T_1002252-EN-01.pdf

These examples do not transfer their SIL/PL/PFH numbers to another machine.

## Failure-path worksheet

For every claimed redundant safety function, ask all four questions:

1. **Independent channel fault:** can one input/output/final element fail while protection remains or the fault is detected as specified?
2. **Common-cause fault:** what single physical cause can impair both channels at once?
3. **Latent fault:** what failure can sit undetected during normal production and only matter at the next safety demand?
4. **Feedback defeat:** can the diagnostic/EDM path fail in a way that falsely reports the final elements healthy?

### Common-cause families to inspect

- shared 24-V supply, fuse, return, connector or terminal;
- shared cable/sheath exposed to one crush, cut, heat or fluid event;
- two channels routed together so one short bridges both;
- common transient/EMI source or missing suppression;
- shared reference/ground whose failure biases both measurements;
- paired contactors/valves exposed to the same contamination, overvoltage, thermal or mechanical cause;
- one software/configuration/mode-selection error feeding both nominally redundant paths;
- one bypass/jumper that defeats both channels;
- one feedback connector/common wire that makes two EDM signals agree falsely;
- one hydraulic contamination or pressure-source failure affecting nominally redundant valves;
- one mechanical linkage defeating multiple guards/interlocks;
- environmental ingress, vibration or temperature outside the assumptions of both channels.

Do not assume diversity automatically eliminates CCF; prove the relevant separation and independence.

## Latent-fault review

A fault is especially dangerous when normal operation does not demand the affected safety function. Examples include a welded second contactor hidden because the first still switches, a failed second input channel hidden until discrepancy testing, a stuck hydraulic safety element masked by another valve, or a broken EDM wire that fails into an apparently healthy state.

For each latent-fault candidate record:

- how it becomes detectable;
- whether detection is automatic, demand-based or proof-test/inspection based;
- maximum interval before detection established by the actual design requirements;
- whether restart is inhibited after detection;
- whether maintenance can accidentally clear the indication without repairing the cause.

If the detection interval or required proof test is unknown, mark `UNKNOWN`; do not invent one.

## Minimum-safe-to-operate pre-energization gate

This gate is intentionally qualitative. Passing it does not establish PL/SIL or certify a machine. Failing a personnel-exposure item means the machine should not be operated with people exposed to that hazard. Experimental energized work, if justified at all, must be isolated/remote with people outside the danger zone and residual risk explicitly controlled.

Before allowing personnel-exposed powered operation, all applicable items must be YES or have an independently justified equivalent:

1. **Hazards identified:** electrical, hydraulic/pneumatic, gravity/stored mechanical, tooling/workpiece/ejection, thermal and motion hazards relevant to the machine are identified.
2. **Energy boundary known:** the actual physical element(s) that prevent each hazardous motion/effect are identified from drawings/inspection rather than inferred from software commands.
3. **Independent safety authority exists:** ordinary LinuxCNC/HAL/normal FPGA logic is not the sole personnel-protection layer.
4. **Emergency stop/protective devices reach final elements:** safety demands are traced through safety logic to the physical contactor/STO/valve/brake/other final element as applicable.
5. **Final-element failure is addressed:** required redundancy/monitoring/EDM or other architecture is present according to the machine's safety requirements; commanded OFF alone is not accepted as proof.
6. **Unexpected restart is prevented:** clearing a demand, restoring mains/24 V, rebooting LinuxCNC/FPGA or reconnecting communications cannot silently create hazardous motion; reset/restart and normal START behavior are defined.
7. **Guards/access protection are usable:** normal work does not predictably require defeating the safeguard. If access during setup is necessary, an engineered constrained setup mode or isolation procedure exists rather than an informal bypass.
8. **Gravity/stored energy is controlled:** removal of drive/pump power does not create an uncontrolled fall/release; blocking/holding/restraint requirements are known.
9. **Single/common-cause review completed:** obvious shared supply, wiring, feedback, environmental and bypass paths capable of defeating redundant protection have been reviewed and unresolved material paths are not hand-waved away.
10. **Known faults/bypasses absent:** temporary jumpers, forced I/O, diagnostic firmware, lifted wires, defeated interlocks and service tooling have been reconciled; unresolved unsafe state is unmistakably OUT OF SERVICE.
11. **Basic functional validation completed:** protective demands, final-element state, feedback/EDM, reset/restart and applicable operating modes have been tested at the least hazardous practical energy level before personnel exposure.
12. **Machine-specific unknowns do not control the decision:** if stopping distance, pressure, safe speed, response time or another physical criterion is necessary to know whether exposure is safe, it has been established from justified design/measurement evidence. Otherwise the exposed operating state remains NOT CLEARED.

### Remote/isolation fallback

If this gate cannot be met but an engineering test still has legitimate information value:

- keep people outside the danger zone;
- use physical barriers/distance appropriate to the credible failure/ejection envelope;
- minimize energy and duration to what the question requires;
- provide a means to remove hazardous energy without entering the zone;
- do not rely on the unvalidated control system as the only means of protecting observers;
- return the machine to isolated/tagged OUT OF SERVICE state after the test until the missing gate item is closed.

If those conditions cannot be established, do not energize the hazardous function.

## OpenPressBrake/LinuxCNC boundary

A watchdog, stale-command inhibit, current-loop trip, HAL E-stop chain or LinuxCNC machine-off state can be valuable normal-control fault containment. None is promoted here into independent personnel-safety authority. The safety architecture must remain able to deny hazardous actuator authority when ordinary LinuxCNC/FPGA behavior is wrong, stale, rebooting or maliciously/mistakenly commanded.

## Adversarial checks

- If both safety channels share one connector, what happens when conductive contamination bridges adjacent pins?
- If both contactors report through one common return, what does an open/short in that return look like?
- If two hydraulic safety valves share contaminated oil, is 'two valves' actually two independent protections against that cause?
- If a mode selector or configuration bit disables two protective functions at once, what independent mechanism prevents an accidental/unauthorized mode from becoming a common-cause bypass?
- What dangerous fault can remain hidden for months because production never exercises the diagnostic path?
- Can maintenance restore production by bypassing the symptom while leaving the underlying fault latent?

## Evidence classification

- `DOC-CONFIRMED`: redundant structures remain vulnerable to common-cause failures; implementation measures such as routing/separation, suppression, diagnostics and EDM are material to the achieved safety architecture.
- `INFERENCE`: the failure-family checklist and minimum-operate gate are engineering synthesis from the cited safety principles and the preceding curriculum evidence; they are not a quoted universal standard checklist.
- `UNKNOWN`: machine-specific required PL/SIL/DC, CCF score/factor, proof-test intervals, stopping criteria, hydraulic independence and achieved performance until a specific design and its requirements are evaluated.

## Compute decision

No compute is justified. The open questions are architecture, physical independence and machine-specific validation questions; synthetic software tests cannot establish them. No GitHub-hosted or self-hosted runner used.
