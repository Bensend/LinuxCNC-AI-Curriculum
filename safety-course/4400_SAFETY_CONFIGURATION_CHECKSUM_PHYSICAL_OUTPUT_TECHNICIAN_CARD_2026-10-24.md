# 4400-CFG-01 — Safety configuration, readback and physical-output technician card
**18 PAPER scenarios | 2026-10-24 | NOT physical tests, NOT a scored blind evaluation**

For each case identify (1) which evidence layer A/B/C/D is present, (2) the unproven physical or configuration property, (3) an independent discriminating check, (4) whether any personnel-exposed operation is permissible (default NO while essential evidence missing), and (5) a human-factor improvement that avoids habitual bypass.

| ID | Case |
|---|---|
| CFG-01 | A SICK gateway reports verified checksum and CV yellow, but the safety cabinet was rewired during the LinuxCNC retrofit. |
| CFG-02 | A network diagnostic bit says the safety logic output is ON while an overload fault inhibits the physical output terminal. |
| CFG-03 | A raw module-status word is all 1s; the installer assumes every safety module is present and healthy. |
| CFG-04 | A legacy Flexi Soft Designer checksum matches, but a connected EFI laser scanner's protective-field map was changed. |
| CFG-05 | The safety program backup matches, but a CPU was replaced with a newer firmware revision. |
| CFG-06 | A GuardLogix safety signature matches after a standard PLC-only download that changed a motion-ready handshake. |
| CFG-07 | A safety application is unlocked and a mismatch is reported during download; a technician proposes to proceed without revalidation. |
| CFG-08 | The safety program is signed, but a contactor's auxiliary feedback is disconnected. |
| CFG-09 | The safety controller requests a stop, but a downstream relay is wired in parallel with the isolation contactor. |
| CFG-10 | The dashboard shows SAFE after an E-stop, but stored hydraulic pressure still permits gravity-assisted movement. |
| CFG-11 | The safety logic status changes correctly during a guard opening, but the actual output valve is unidentified. |
| CFG-12 | A field technician temporarily bridges an interlock because removing the guard for lubrication is cumbersome. |
| CFG-13 | A project has a four-byte checksum and is described as cryptographically tamper-proof. |
| CFG-14 | A scanner's configuration is restored from backup after an optical front-screen replacement. |
| CFG-15 | The operator resets a safety controller after a guard closes and the normal CNC resumes a previously queued move. |
| CFG-16 | An EtherNet/IP status image is green but the safety network endpoint identity and firmware are undocumented. |
| CFG-17 | A replacement controller reports RUN and no diagnostic faults, but no as-built wiring or safety-function test records exist. |
| CFG-18 | A vendor's approved replacement procedure and checksum match are available, but the independent Y1/Y2 stop/hold witness is still blank. |

## Scoring use (not a hidden key)
A correct engineering answer distinguishes the scope of each indication, keeps physical safety authority independent, proposes a non-exposed qualified check and refuses to invent missing hardware or numeric parameters. This card is **learner-readable**, so a later independent evaluator must use **novel cases**, not rephrase these eighteen examples. No score has been assigned.

## Workshop-friendly correction pattern
Provide a controller-model/revision label, signed-off diagram, secure backup, readback procedure, a simple 'CONFIG MATCH / PHYSICAL PROOF PENDING' distinction, guarded maintenance access and a separate deliberate rearm control. Do not make unsafe jumpers the easiest repair.

**Status:** 18 scenarios prepared, not executed; selected OpenPressBrake controller and Y1/Y2 physical evidence UNKNOWN; G3/G4 NOT AUTHORIZED.
