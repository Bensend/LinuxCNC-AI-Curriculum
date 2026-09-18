# Trapped-key wrong-key common-cause and escape-release study — 2026-09-18

Session start UTC: 2026-09-18T09:37:49Z

## Purpose

Continue the safety-course personnel-retention branch without overlapping the primary gravity-axis retaining-proof branch. This study attacks two failure assumptions left open by the prior trapped-key sequence study: (1) that any physically fitting key can be trusted as evidence of the intended upstream state, and (2) that restart prevention automatically provides escape from an entered hazard zone.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly supported by cited manufacturer material.
- **DOC-CONFIRMED** — behavior directly stated by an authoritative document.
- **TEST-CONFIRMED** — demonstrated by controlled test. None here.
- **COMMUNITY-REPORTED** — community observation not independently verified. None relied upon.
- **INFERENCE** — engineering conclusion derived from evidence, not a machine-specific fact.
- **UNKNOWN** — requires installed-machine design, validation, or measurement.

## Authoritative evidence

### Fortress key differ / duplicate-key warning

**SOURCE-CONFIRMED:** Fortress Safety's *Key Information When Designing Fortress Trapped Key* gives an explicit adjacent-system example: systems installed at different times can accidentally receive duplicate keys. Fortress states that repeated engraving/code across adjoining systems creates a very high risk that the keys are identical. This is direct manufacturer evidence that key identity management is part of the safety architecture rather than mere labeling convenience.

Source: Fortress Safety, *Key Information When Designing Fortress Trapped Key*: https://fortress-safety.com/wp-content/uploads/2021/08/Key-Information-When-Designing-Fortress-Trapped-Key.pdf

### Fortress personnel key + escape release hardware

**SOURCE-CONFIRMED:** Fortress product EI4-A6-EKR2-SR411 combines an escape-release handle, extracted personnel-key adaptor, power-to-unlock interlock, trapped-key function, positive-break monitored safety circuits and an automatically resetting escape-release head when the actuator returns. The product therefore demonstrates that personnel retention and escape release can coexist as distinct mechanisms in one professional guard-locking assembly.

Source: Fortress Safety, *EI4-A6-EKR2-SR411*: https://fortress-safety.com/fr/products/ei4-a6-ekr2-sr411/

### EUCHNER trapped-person boundary

**SOURCE-CONFIRMED:** EUCHNER's STP guidance explicitly treats accidental enclosure inside an accessible danger zone as a separate design problem. Its STP-BI description states that machinery must prevent enclosure or provide a means of summoning help, and explains a guard-locking behavior intended to prevent accidental locking-in after power-state changes.

Source: EUCHNER, *Safety switch STP*: https://www.euchner.de/en-us/products/electromechanical-safety-switches-with-guard-locking/safety-switch-stp/

### Independent electronic retained-person comparison

**SOURCE-CONFIRMED:** Pilz's key-in-pocket system prevents machine restart while authenticated persons remain registered in the danger zone; restart is possible only after everyone signs out and the safe list is cleared. This independently supports retained-person restart inhibition, but does not by itself establish physical egress.

Source: Pilz, *Maintenance safeguarding key in pocket system* (2022-10-04): https://www.pilz.com/en-SG/company/press/messages/articles/235088

## Frozen distinctions

**INFERENCE:**

`KEY PHYSICALLY FITS != KEY BELONGS TO THIS SAFETY SEQUENCE != UPSTREAM HAZARD STATE IS VALID != ACCESS IS SAFE.`

`PERSONNEL KEY RETAINED != PERSON CAN ESCAPE != GUARD CAN BE RELEASED FROM INSIDE != HAZARD ENERGY IS CONTROLLED.`

`ESCAPE RELEASE OPERATED != PERSONNEL RETENTION CLEARED != SAFETY RESET COMPLETE != ORDINARY START AUTHORITY.`

A trapped-key sequence is only as trustworthy as the identity/configuration discipline that prevents a key from satisfying the wrong lock. Escape is a separate safety objective from restart prevention: a system can successfully inhibit restart yet still be unacceptable if an entered person can be trapped by the guarding arrangement.

## Common-cause failure analysis

| Failure | Why it can defeat apparently redundant sequencing | Required design/validation response |
|---|---|---|
| Duplicate key code on adjacent machines | One key may satisfy a lock without the intended upstream isolator having released it | Site-wide key-differ/code inventory; verify adjacent and replacement systems; control spare/replacement keys |
| Uncontrolled spare/master/override key | Bypasses the physical causality encoded by trapped-key transfer | Define custody, authorization, storage, audit and out-of-service procedure; never treat convenience override as normal production path |
| Lock cylinder replaced with wrong code | Maintenance can silently alter sequence identity | Replacement configuration verification before return to service |
| Engraving/label trusted instead of mechanical identity | Correct-looking marking does not prove key differs | Functional wrong-key challenge plus controlled configuration records |
| Two access points unintentionally share key identity | A key may be moved between branches and create an invalid sequence state | Validate every permitted and forbidden key/lock pairing |
| Personnel key returned while another person remains inside | Key return alone can be administratively misused | Multi-person retention method plus area-clear/restart procedure appropriate to blind spots and entry pattern |
| Escape release unavailable/blocked | Restart may remain inhibited but person can still be trapped | Inside-accessible escape/emergency-egress validation where bodily entry creates entrapment risk |
| Escape release used during abnormal condition | Door/guard state changes without proving hazards controlled | Escape must prioritize egress; safety logic must treat resulting guard state as non-production-ready and require validated restoration/reset |
| Power cycle with personnel inside | Ordinary controller state can reboot while physical occupancy persists | Retention/restart-inhibit authority must survive independently of LinuxCNC/HAL/ordinary FPGA startup |

## Commissioning card

1. Build an installed key/lock map: machine, safety function, key code/differ, source isolator, exchange, access lock, personnel key, spare/override custody.
2. Challenge every credible wrong-key pairing, especially adjacent machines and historically replaced components. A forbidden key must not satisfy the safety sequence.
3. Trace each released key backward to the physical state that causes its release. A label, HMI bit, or key presence is not enough when the actual isolator/discharge/retaining state is not proven.
4. With a personnel key retained, challenge guard closure, power cycling and ordinary-controller reboot. Production authority must remain unavailable.
5. From every bodily-entry position where enclosure is credible, validate the intended escape/emergency-egress path without relying on an outside operator or LinuxCNC/HMI availability.
6. Operate the escape release under the validated test condition and verify that egress does not silently recreate restart authority. Guard/safety restoration, personnel-clear state, safety reset/rearm and fresh ordinary START remain distinct.
7. Challenge loss of control power while the guard is open and while it is closed; verify that the guard-locking/escape behavior matches the installed device's documented principle.
8. After replacing a lock, key, guard interlock or exchange unit, repeat the identity/sequence challenges before return to service.

## Human-factors rule

**INFERENCE:** Key management that is so awkward that maintainers routinely borrow, duplicate, hide, tape-in or bypass keys is a safety-design defect, not merely a training problem. Provide enough legitimate personnel keys/access points, clear physical coding, controlled replacement, usable escape provisions and a restoration sequence that is easier to follow than defeat.

An emergency escape device must remain intuitive and physically reachable from the hazard side. It must not require remembering a software procedure, obtaining a network connection, or waiting for LinuxCNC/PLC/HMI cooperation.

## OpenPressBrake UNKNOWNs

No claim is made about whether OpenPressBrake will use trapped keys, the number of access points/personnel, any key coding scheme, the correct guard-locking principle, escape hardware, hydraulic isolation, mechanical ram support, safe pressure, discharge time, stopping distance, PL/SIL/category/DC or a validated maintenance procedure. These remain **UNKNOWN** pending actual machine architecture and validation.

## Compute decision

No compute is justified. The unresolved questions are physical identity/configuration, egress and installed-machine validation questions. No GitHub-hosted or self-hosted workflow was run.

## Next evidence target

Find a professional full-machine implementation or commissioning manual that explicitly tests **wrong key / spare key / escape release / retained-person state / guard restoration / reset / separate restart** together. If public evidence stops, rotate to the highest-value open safety module rather than inventing behavior.