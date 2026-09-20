# Trapped-key personnel-key multi-person restart-inhibit authority study

Date: 2026-09-20
Course: 4000 safety / personnel access and restart authority
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane is currently advancing hydraulic residual-energy and commissioning-baseline evidence. This independent pass therefore avoids hydraulic final-element files and studies a different open architecture problem: how a machine can preserve positive restart inhibition while one or more people are physically inside a safeguarded space, especially where visibility is poor or several access points exist.

This is not a claim that OpenPressBrake requires trapped-key hardware. It is a reusable professional pattern for understanding personnel-clear authority and unexpected-restart prevention.

## Manufacturer evidence — Fortress Safety trapped-key systems

**DOC-CONFIRMED.** Fortress describes trapped-key systems as enforcing a predetermined sequence. An energy-control device releases a key only after the relevant energy-control step; while that key is removed, the energy source is prevented from being accidentally turned on. A key exchange can require all upstream keys before releasing downstream access keys.

**DOC-CONFIRMED.** At an access lock, Fortress describes an optional personnel-key/proactive-inhibit function. The personnel key is released before access; the person can carry it into the safeguarded space. Until that personnel key is returned, the access key remains trapped and the access lock cannot be reset.

Source: Fortress Safety, “Understanding Trapped Key Systems,” https://fortress-safety.com/news/understanding-trapped-key-systems/

**DOC-CONFIRMED.** Fortress's current RFID Safety Keys brochure describes whole-body access where operators remove personnel keys so safety contacts remain open and unexpected restart is prevented until the keys are returned. In its integrated example, a request-to-enter action begins a forced run-down cycle; only after run-down are safety keys released and the door can open. Manual reset is not possible until the keys are returned.

Source: Fortress Safety, “RFID Safety Keys,” 2025 brochure, https://fortressinterlocks.com/app/uploads/2025/04/RFID-Safety-Keys-Brochure-RSK.pdf

**DOC-CONFIRMED.** Fortress's automotive production-cell example uses a key-operated control, key exchange and multiple access locks. It states that hazardous energy is controlled before access, access keys are released for operators, and restart is possible only when the sequence is reversed. It also identifies a personnel key as an optional proactive-inhibit layer for multiperson access.

Source: Fortress Safety, “Trapped Key Interlocking for Automotive Production Cells,” https://fortress-safety.com/de/application/controlled-access-in-an-automotive-production-cell-with-multiple-entry-points/

## Curriculum result

A closed guard, a returned access key, and a controller-ready bit are not enough to establish that all people have left a whole-body-access space. A personnel-key architecture creates a physical retained-person token whose absence deliberately blocks completion of the restart sequence.

Freeze:

**ACCESS REQUESTED != HAZARD SAFE FOR ENTRY.**

**CONTROLLED STOP COMPLETE != HAZARDOUS ENERGY ISOLATED/CONTROLLED FOR THE INTENDED TASK.**

**GUARD OPEN != PERSONNEL KEY ACCOUNTED FOR.**

**GUARD CLOSED != ALL PERSONNEL OUTSIDE.**

**ACCESS KEY RETURNED != ALL PERSONNEL KEYS RETURNED.**

**ALL PERSONNEL KEYS RETURNED != SAFETY RESET ACCEPTED != FRESH ORDINARY START.**

The final separation is partly **INFERENCE**: Fortress documents sequence reversal and reset inhibition, but this source set does not establish the exact ordinary START logic for OpenPressBrake. The curriculum must therefore preserve a separate fresh-start requirement rather than infer one from key return.

## Multi-person access architecture

For a whole-body-access area, a useful conceptual sequence is:

1. Ordinary production motion is stopped through the machine's defined access-request process.
2. The safety architecture establishes whatever safe-access state the actual risk assessment requires.
3. Access authority is released.
4. Each exposed person obtains an individually accountable personnel key/token before entering where that architecture is used.
5. Possession/removal of any personnel key keeps the restart path inhibited independently of LinuxCNC/HAL/FPGA production commands.
6. On exit, each person returns their key through the defined physical sequence.
7. Guards/access devices are restored.
8. The safety system performs the required reset/requalification only after personnel-key accounting and other prerequisites are satisfied.
9. Production still requires a separate fresh ordinary START/CYCLE action where the machine design requires one.

This is a teaching model, not an OpenPressBrake implementation specification.

## Failure-path / commissioning worksheet

A professional acceptance plan for an architecture claiming personnel-key restart inhibition should challenge at least these questions:

- Can access be obtained before the required safe-access condition is established?
- With one personnel key deliberately retained inside, can another person close the guard or return other keys and accidentally complete the restart sequence?
- With two or more people inside, does each claimed personnel token independently preserve restart inhibition?
- Does returning an access key while a personnel key is absent leave the restart path inhibited?
- Can a duplicate, wrong, bypassed or administratively substituted key defeat the intended physical accounting model? The applicable hardware/manual must define what is actually prevented; do not assume uniqueness from appearance alone.
- If ordinary LinuxCNC START/CYCLE/JOG remains asserted during entry and exit, does personnel-key return merely restore safety readiness rather than immediately produce hazardous motion?
- After all personnel keys are returned, is any required area-clear/reset/rearm step still distinct from ordinary production start?
- What happens after control-power loss/restoration while a personnel key remains removed?
- If a guard or access-lock device is replaced, what physical sequence proves correct key/access mapping before return to service?

## Safety-authority boundary

LinuxCNC, HAL, FPGA logic or an HMI may display access/key status, request a stop, or participate in ordinary sequencing, but a normal-control boolean such as `personnel_clear=true` is not equivalent to the claimed safety-rated physical personnel-key state.

Freeze:

**HMI PERSONNEL COUNT == 0 != PHYSICAL PERSONNEL-KEY ACCOUNTING COMPLETE.**

**LINUXCNC IDLE != WHOLE-BODY ACCESS SAFE.**

**SAFETY READY != ORDINARY MOTION COMMAND AUTHORIZED.**

## OpenPressBrake boundary

No OpenPressBrake access-cell geometry, trapped-key requirement, number of personnel, energy-isolation topology, guard-locking principle, run-down time, hydraulic safe state, PL/SIL/category/DC/CCF, or key hardware is inferred here. Those remain **UNKNOWN** until the actual machine hazard analysis and safety architecture justify them.

The lesson is architectural: where whole-body access and blind-area/retained-person hazards exist, personnel-clear authority should not be reduced to guard closure or a software acknowledgement.

## Evidence provenance

- SOURCE-CONFIRMED: manufacturer pages/brochure are public Fortress sources.
- DOC-CONFIRMED: sequence, personnel-key inhibition, multiperson/access examples and reset inhibition described above.
- TEST-CONFIRMED: none in this pass.
- COMMUNITY-REPORTED: none relied upon.
- INFERENCE: OpenPressBrake should preserve fresh ordinary-start separation if a personnel-key architecture is ever used; exact implementation is not established here.
- UNKNOWN: OpenPressBrake-specific need, topology, key count, safe-access state, performance level and acceptance criteria.

## Next-work checkpoint

Highest-value follow-on is an authoritative manufacturer/OEM commissioning or validation procedure that physically challenges **multiple-person entry -> one personnel key intentionally retained -> all other guards/keys restored -> restart remains inhibited -> retained key returned -> required area-clear/reset/rearm -> stale START challenge -> separate fresh production START**, preferably with a deliberate wrong-key/duplicate-key or access-device fault case.

If that evidence is unavailable, mark this branch source-limited and rotate rather than accumulating more trapped-key product catalog material.

No executable verification was justified; no GitHub-hosted or self-hosted compute was consumed.