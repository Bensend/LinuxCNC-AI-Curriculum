# 25C0 adversarial exercise — persistent maintenance state after reboot

## Scenario
A machine was serviced during second shift. The technician:

- acquired Maintenance ownership of a process output;
- bypassed one bypassable ordinary process interlock;
- temporarily selected virtual/simulated device operation;
- performed the repair;
- issued the command that restores interlock checking;
- power-cycled the controller because the HMI was behaving strangely.

After reboot:

- the controller is in RUN;
- the independent safety controller reports its normal ready state;
- the guard is closed;
- no I/O force values are installed;
- the process-interlock faceplate says `Not bypassed`;
- the device does not show an active fault;
- the technician says, "the reboot put everything back to normal."

The production supervisor asks whether the operator may press Cycle Start.

## Learner tasks

1. Identify every fact above that is useful evidence and every conclusion it does **not** prove.
2. State whether reboot is evidence that Maintenance ownership cleared.
3. Determine what must be positively checked/dispositioned before ordinary production release.
4. Explain why a healthy independent safety controller does not answer the ordinary production-configuration question.
5. Explain why ordinary configuration cleanup must not itself become motion authority.
6. State what evidence would be required before claiming the physical/virtual device mode is restored.
7. Propose an HMI/control pattern that makes this failure difficult to carry across shift handoff.

## Source-grounded answer constraints

A correct answer must use these boundaries:

- Rockwell documents PlantPAx Maintenance acquired/released state as persisting through controller powerup and PROG-to-RUN for relevant process instructions.
- PlantPAx exposes explicit Maintenance acquire/release commands.
- PlantPAx exposes explicit bypass/check commands; clearing bypass is distinct from releasing Maintenance ownership.
- Some PlantPAx device instructions expose explicit Physical/Virtual selection, so device simulation state must not be collapsed into bypass or ownership.
- The generic documentation inspected does **not** authorize inventing the exact restart sequence for this hypothetical machine.

## Expected reasoning

The learner should reject the supervisor's proposed inference. RUN, safety-ready, guard-closed, no forces, and no active bypass are all useful but heterogeneous evidence. None proves Maintenance ownership was released, none proves physical device operation was restored, and none proves temporary physical test aids are absent.

Before ordinary production release, the design should positively establish applicable exceptional-state classes are clean: Maintenance ownership released, intended normal command source restored, physical device mode selected/verified, force state clean, accepted baseline disposition complete, and inspection-only temporary aids removed. Machine-specific validation may add further requirements.

A fresh Cycle Start should be a separate event after cleanup. Cleanup commands must not be treated as an implicit start request. This is an engineering design rule; do not mislabel it as a universal PlantPAx guarantee.

The independent safety system remains authoritative for its engineered personnel-safety functions. Its ready state does not certify ordinary controller cleanliness. Likewise, an ordinary `production_config_clean` status must never be presented as proof of personnel clear or safety validation.

## Adversarial variant

Suppose Maintenance ownership is explicitly released, but the virtual/physical selection cannot be read by the running application on this machine. The correct response is **not** to assume physical mode. Production handoff requires a positive inspection or another authoritative witness. If the machine cannot establish that distinction reliably, the interface/design needs improvement before the handoff mechanism is considered robust.
