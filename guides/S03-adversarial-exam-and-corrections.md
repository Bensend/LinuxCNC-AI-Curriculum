# S03 — Adversarial Exam and Corrections

Status: **source exam passed; runtime graduation gate still separate**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Competency being tested

A competent AI must distinguish:

- a value that is numerically plausible from a value known to be fresh;
- transient hm2_eth packet-error handling from permanent HostMot2 low-level `io_error`;
- HAL publication state from the underlying FPGA/remote/physical state;
- permission to attempt host communication again from evidence that the machine has resynchronized;
- host-side experiment evidence from transport, FPGA, drive, actuator, and functional-safety evidence.

## Adversarial scenario 1 — plausible but stale encoder value

A machine was at 125.000 mm when communication failed. The displayed encoder feedback remains exactly 125.000 mm. The mechanical axis is subsequently disturbed externally. An engineer argues that because the displayed value is in range and does not jump, the encoder has confirmed that the axis did not move.

### Required answer

Reject the claim. A generic HostMot2 read cycle that exits before per-module TRAM publication can leave the previous HAL value visible. The number can remain perfectly plausible while no fresh device data was published. The hm2_eth documentation itself discusses stale feedback during packet loss. Therefore the value alone cannot establish freshness or physical position after the communication failure.

### Correction rule

Treat communication-health/freshness evidence as a separate diagnostic dimension. Never infer freshness merely from plausibility, continuity, or lack of a following error.

## Adversarial scenario 2 — transient packet loss versus permanent io_error

One servo cycle has a packet error, after which several cycles communicate normally. A second machine accumulates errors until `packet-error-level` reaches its configured limit and the board's low-level `io_error` becomes true. An engineer treats these as identical because both involved a lost packet.

### Required answer

Reject the equivalence. In hm2_eth, transient errors contribute to an error-level policy and successful cycles can decrement that level. Reaching the limit escalates to permanent low-level I/O error requiring explicit reset. At the generic HostMot2 boundary both a temporary incomplete read path and persistent `io_error` can prevent fresh module publication in a cycle, but the persistence, recovery mechanism, and diagnostic state differ.

### Correction rule

Use separate terms: **transient packet/read error**, **error-level accumulation**, and **persistent low-level `io_error`**. Do not collapse them into a single 'Ethernet failed' state.

## Adversarial scenario 3 — clearing io_error means synchronized

After a persistent error, an operator clears the writable `io_error` parameter. New LLIO callbacks occur and fresh HAL values begin changing again. An engineer immediately authorizes automatic motion because communication has 'recovered.'

### Required answer

Reject the automatic-motion conclusion. Clearing `io_error` permits HostMot2 to call the low-level driver again; resumed traffic/publication is evidence of host-path re-entry, not proof that FPGA state, Smart Serial remotes, encoder index state, drive state, actuator state, or machine-control assumptions are mutually synchronized. Current hm2_eth documentation also warns that not all HostMot2 special functions recover properly from packet loss.

### Correction rule

Separate **communication re-entry** from **state reconciliation** and **safe restart**. The latter belongs to S07/commissioning and may require module-specific or machine-specific checks before motion is re-enabled.

## Adversarial scenario 4 — stale command delivery assumption

During persistent `io_error`, a HAL output command changes from TRUE to FALSE. The GUI shows the requested FALSE state. An engineer concludes that the physical FPGA output must now be FALSE.

### Required answer

Reject the claim. The generic HostMot2 write path returns early on persistent `io_error`, before normal command preparation/transmission. A host-side command object changing is not evidence that LLIO, FPGA, connector, drive, or actuator state changed. The correct diagnostic statement is that the desired host command changed while transport/delivery evidence was unavailable or suppressed.

### Correction rule

Keep **requested command**, **host write attempted**, **transport accepted**, **remote/FPGA state**, and **physical output** as separate claim layers.

## Adversarial scenario 5 — watchdog inference

A communication failure causes a HostMot2 board's hardware watchdog to bite. An engineer reasons that because watchdog behavior normally drives I/O pins toward the board/firmware's watchdog state, every attached actuator is now guaranteed safe.

### Required answer

Reject the universal safety claim. HostMot2 watchdog behavior and board pin state do not by themselves establish the downstream circuit's physical fail state, actuator torque state, brake state, STO status, or functional-safety performance. Electrical interfaces can invert, float, retain energy, or fail independently. Those claims require hardware-specific evidence and safety validation.

## Adversarial scenario 6 — packet-error masking

A PID-stepper configuration substitutes command position for stale feedback during a transient packet-error cycle, reducing following-error nuisance trips. An engineer says this proves the axis physically followed the command through the lost packet.

### Required answer

Reject the claim. Substituting command for feedback is a control/diagnostic policy that deliberately avoids using stale feedback during the transient. It does not create physical position evidence. The hm2_eth documentation describes this technique as a way to improve behavior/tuning under packet loss, not as a position measurement.

### Correction rule

Any deliberate feedback substitution must remain visibly classified as **substituted/estimated**, never upgraded to measured physical feedback.

## Counterfactual promotion test

The following claims remain outside S03 1000-level evidence even if Lab 013 passes:

- exact Ethernet packet-loss probability or immunity;
- NIC, switch, cable, IRQ or firewall timing behavior on a real machine;
- FPGA watchdog bite time under a specific failure;
- Smart Serial remote recovery ordering;
- drive fault/STO behavior;
- actuator torque/braking after communication loss;
- safe restart or functional-safety validation.

Those remain promotion candidates for E03/E05/E06/E07/E08, HM08/HM10, S06/S07, 2000-level work, or commissioning/safety validation.

## Exam result

**PASS at source-reasoning scope.** The answers preserve evidence-layer boundaries and resist the stale-plausible-data, command-versus-delivery, and recovery-equals-resynchronization traps.

This exam does **not** waive the independent Lab 013 runtime gate. S03 may graduate only after the mutable-LLIO harness passes its predeclared Gate A and then the stale-publication/write-suppression/re-entry Gates B-D.