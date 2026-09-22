# 25E0 — Fresh Demand and Partial Power-Domain Recovery

Date: 2026-09-22
Status: learner-facing 4000 safety-course method

## Learning objective

After an interruption, prove that restored device readiness is not silently converted into machine start authority. Separate safety-controller state, durable safety obligations, ordinary LinuxCNC/FPGA/HMI readiness, reset/rearm, and a fresh production demand.

## Evidence ledger

### DOC-CONFIRMED — unexpected restart must be prevented

Pilz, **Movable guards / EN ISO 14120**, states that after a safeguard has triggered a machine may not automatically restart merely because the protected field has cleared; restart is via a reset control outside the danger zone with visual contact. The same page explicitly identifies restoration of energy after interruption as an unexpected-start case and points to EN ISO 14118.

Source: https://www.pilz.com/en-IE/support/law-standards-norms/iso-standards/choosing-guards/movable

### DOC-CONFIRMED — automatic circuit reset is not machine-level start permission

Rockwell Automation's GuardLogix ESTOP instruction documentation warns that when Automatic Circuit Reset is used, other measures are required to prevent unexpected/unintended startup in the system or application.

Source: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/emergency-stop--estop-.html

Rockwell's DCST/DCSTL documentation likewise separates valid safety inputs from the required reset actions before the safety output can energize.

Sources:
- https://www.rockwellautomation.com/en-nl/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/dcst.html
- https://www.rockwellautomation.com/en-pl/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/dcstl.html

### DOC-CONFIRMED — drive restart inhibition is narrower than machine start authority

Siemens SINAMICS documentation describes a drive-level **Switching On Inhibited** condition following STO deselection and says this prevents automatic restart of the electrically driven machine component. It also warns that STO does not brake a rotating motor; coast-down must be accounted for in the machine's protective-door logic.

Source: Siemens SINAMICS Micro-Drive System Manual, Safety Integrated section, current web result dated 2025/2026 family documentation.

This proves a useful boundary: a drive's restart inhibition can be part of the safety chain, but clearing it does not by itself constitute a fresh machine production command.

### DOC-CONFIRMED — manual restart can be an explicit transition

Rockwell SS2 documentation distinguishes manual and automatic restart. In manual restart, after the request is removed the Reset input must make an OFF-to-ON transition before subsequent operation. This is evidence for transition freshness at the safety-function layer, not a universal prescription for every machine.

Source: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/drive-safety-instructions/ss2.html

### DOC-CONFIRMED — replacement/reconnection readiness still requires system authorization

Rockwell's safety-I/O replacement procedure allows automatic configuration only under explicit conditions and still requires company-prescribed functional testing of the replaced device/system and authorization for use.

Source: https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-um543/controllogix-5580-and-guardlogix-5580-controllers-/safety-i-o-devices/safety-i-o-replacement-options/always-allow-automatic-configuration.html

## Core distinction

Do not collapse these events:

1. power is present;
2. a safety controller/I/O is booted and diagnostically valid;
3. field safety inputs are valid;
4. durable `FIND-*` / stale `PROP-*` / pending `VAL-*` obligations are resolved;
5. reset is eligible;
6. reset/rearm is intentionally completed;
7. ordinary machine control is ready;
8. a **fresh post-recovery production demand** is issued.

A pre-interruption held start bit, stale GUI command, retained PLC/CNC request, queued cycle-start, or reconstructed ordinary demand must not silently become item 8 merely because items 1–7 later become true.

## Learner-facing recovery state table

| State | Required meaning | May safety outputs/permissions recover? | May ordinary production motion start? |
|---|---|---:|---:|
| `BOOTING` | Authority identity/health not yet established | No assumption | No |
| `SAFE-INHIBITED` | Safe/inhibited condition established; startup still incomplete | Only as defined by validated safety architecture | No |
| `DIAGNOSTIC-VALID` | Safety controller/I/O diagnostics and required field witnesses are valid | Possibly, subject to safety-function design | No automatic production authority |
| `OBLIGATION-BLOCKED` | Open/stale/UNKNOWN safety evidence prevents return to service | No return-to-service permission | No |
| `RESET-ELIGIBLE` | Required safety conditions and obligations permit reset | Reset may be accepted if architecture requires it | No; reset is not start |
| `REARMED` | Safety chain has completed required reset/rearm | Safety permission may exist | No inherited production demand |
| `PRODUCTION-DEMAND-REQUIRED` | Ordinary control is ready but no fresh post-recovery production demand has occurred | Yes, if all independent safety conditions remain satisfied | Only after a fresh valid demand |

`LinuxCNC ready`, `machine-on`, GUI-ready, HAL communications healthy, FPGA communications restored, or a drive-ready bit are informational/ordinary-control facts unless a separately validated safety architecture assigns a narrower safety role. They do not erase `OBLIGATION-BLOCKED` and do not create a production demand.

## Partial power-domain recovery stress test A

### Safety controller remains powered; LinuxCNC/HMI/ordinary FPGA cycles

Assumptions:
- independent safety authority remains continuously powered and its validated state is not lost;
- no evidence indicates its field inputs/final elements changed state;
- ordinary CNC/HMI state is lost and rebuilt.

Disposition:
- **INFERENCE:** continuously maintained safety-controller evidence is not made stale merely because LinuxCNC rebooted.
- ordinary CNC/HMI command state is stale by definition; pre-cycle ordinary demands must not be inherited as fresh demands.
- durable safety-ledger obligations remain exactly as they were before the CNC cycle; a LinuxCNC reboot cannot clear them.
- field/process propositions remain current only if their evidence contract does not depend on the cycled ordinary-control domain and no contrary event occurred.
- machine-specific behavior that might cause motion from retained/queued ordinary commands is `UNKNOWN` until traced for that implementation.

Required safe pattern:

`ordinary-control restart -> re-establish communications/readiness -> reconcile durable safety state -> require fresh ordinary demand`

## Partial power-domain recovery stress test B

### LinuxCNC/HMI remains powered; independent safety controller/I/O cycles

Assumptions:
- ordinary control can retain requests and GUI state;
- safety authority loses runtime state and later boots.

Disposition:
- retained LinuxCNC/HMI readiness is **not** evidence that safety authority survived the interruption.
- safety identity/configuration/diagnostics and required field witnesses must be re-established according to the safety design.
- durable open obligations remain blocking.
- any ordinary demand that existed before or during the safety outage is not a fresh post-recovery demand.
- safety rearm must not make a continuously held ordinary command suddenly effective unless the machine's validated architecture explicitly provides an equivalent anti-unexpected-start mechanism.

Required safe pattern:

`safety power loss -> ordinary motion authority inhibited -> safety startup/diagnostics -> recover durable obligations -> reacquire required witnesses -> reset/rearm if eligible -> discard/neutralize stale ordinary demand -> require fresh ordinary demand`

## Adversarial exercise

A LinuxCNC machine has Cycle Start held true from an external pendant. Safety power is interrupted while LinuxCNC remains alive. The independent safety controller returns healthy, its inputs are valid, and its manual reset is completed. The pendant input never transitioned low during the event.

Bad conclusion: "The operator is still asking for Cycle Start, so motion may resume."

Required reasoning: the held request predates restoration of safety authority. Treating it as a new production demand converts recovery/rearm into unexpected restart. The ordinary-control layer must require whatever fresh-demand semantics the machine design establishes (for example a release-and-reassert transition), while personnel-safety authority remains independent. The exact implementation is machine-specific; the principle is not.

Second trap: a safety device offers an **automatic reset** option. That device feature does not prove that automatic machine restart is permissible. Rockwell explicitly requires other measures against unintended startup when automatic circuit reset is used.

## Failure-path review

- **Held start across safety outage:** stale ordinary demand; do not execute after rearm.
- **GUI reconstructs last command after reboot:** reconstructed state is not fresh operator intent.
- **Safety remains powered while CNC reboots:** do not unnecessarily invalidate independent evidence, but do invalidate/reacquire ordinary command freshness.
- **CNC remains powered while safety reboots:** ordinary readiness cannot bridge the safety-authority gap.
- **Open `FIND-*` exists before either outage:** it remains open after both outage types unless positively dispositioned.
- **Safety diagnostics return healthy but physical evidence was already stale:** diagnostics do not refresh the physical proposition.
- **Drive says restart inhibition cleared:** this is not machine-level production demand.

## Human-factors design rule

Make the fresh-demand path obvious and low-friction: clearly indicate `SAFE TO RESET`, `RESET COMPLETE`, and `READY — NEW CYCLE START REQUIRED` as distinct concepts where appropriate. Avoid an interface where operators learn to hold a start control through faults, tape it down, or repeatedly hammer reset because the state model is opaque. If normal recovery predictably trains bypass behavior, the recovery UX needs redesign.

## New freezes

- **POWER RESTORED != START AUTHORITY.**
- **AUTOMATIC SAFETY-CIRCUIT RESET != AUTOMATIC MACHINE RESTART PERMISSION.**
- **DRIVE RESTART INHIBITION CLEARED != FRESH PRODUCTION DEMAND.**
- **RESET/REARM COMPLETE != START COMMAND.**
- **HELD PRE-OUTAGE DEMAND != FRESH POST-RECOVERY DEMAND.**
- **LINUXCNC/HMI STATE SURVIVED != SAFETY AUTHORITY SURVIVED.**
- **SAFETY AUTHORITY SURVIVED != ORDINARY COMMAND FRESHNESS SURVIVED.**
- **PARTIAL POWER-DOMAIN RECOVERY != WHOLE-MACHINE STATE CONTINUITY.**

## Evidence boundary / UNKNOWN

This lesson does not specify a universal reset circuit, edge detector, PLC implementation, hydraulic sequence, safe speed, stopping distance, proof interval, PL/SIL target, or power-domain topology. Whether a particular machine requires release-and-reassert, a separate start pushbutton, guarded reset, presence sensing, mode-dependent start semantics, or another anti-restart mechanism must be established by its risk assessment and validated architecture.

No simulation is justified for the generic proposition above: authoritative manufacturer evidence resolves the conceptual question. A future executable lab is justified only for a concrete implementation whose retained-command behavior is unresolved.
