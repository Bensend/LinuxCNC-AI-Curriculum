# 4000 Safety Course — Proof-Test Restoration and Test-Tool Defeat Resistance

Date: 2026-09-16
Status: DURABLE SAFETY LESSON — Lane B

## Learning objective

Prevent a valid proof/commissioning activity from leaving the machine in a less-safe production state. Temporary forces, jumpers, test plugs, simulated inputs, diagnostic overrides, maintenance credentials and validation fixtures are controlled test artifacts; their existence, use and removal must be part of the validation claim.

## Core boundary

`test complete` is not `production restoration complete`.

A defensible return-to-production chain is:

`test authorized -> bounded test state entered -> test artifact identified -> stimulus applied -> expected response independently observed -> artifact removed -> removal independently checked -> safety configuration/state restored -> affected safety function challenged in restored state -> reset/rearm rules satisfied -> production release`

Skipping the restoration half turns a diagnostic aid into a latent defeat mechanism.

## Evidence ledger

### DOC-CONFIRMED — safety forces are intentionally incompatible with a finalized GuardLogix safety application
Rockwell GuardLogix documentation states that safety I/O/produced/consumed safety data may be forced only while the project is safety-unlocked and no safety signature exists. Forces must be **removed, not merely disabled**, before the project can be safety-locked or a safety signature generated. A safety signature also prevents forcing safety I/O and certain inhibit/configuration actions.

Engineering consequence: `force disabled` and `force removed` are different restoration claims. A production-release checklist must test for residual configured forces/test edits, not only whether they are currently active.

### DOC-CONFIRMED — configuration identity does not replace functional validation
Rockwell documents that a safety signature/configuration signature identifies the safety application or safety-device configuration, and that changes require revalidation. Device configuration signatures become verified only after user testing. Downloads without the expected safety signature require application testing/revalidation.

Engineering consequence: a matching checksum/signature is useful configuration-binding evidence but cannot prove that a jumper was removed, a test plug is correct, field wiring is restored, a guard is aligned, a valve/contactor acts physically, or a test fixture has been disconnected.

### DOC-CONFIRMED — mode selection does not itself initiate machine operation
Pilz states for operating-mode selection that each selector position should enable only one operating mode and that operation of the selector alone may not initiate machine operation. It also argues that a standard controller cannot safely evaluate the operating-mode selector where safety-related mode selection is required.

Engineering consequence: selecting `TEST`, `SETUP` or `VALIDATION` is permission/state selection, not a motion command. LinuxCNC/HAL or an ordinary FPGA may request or display the mode but must not silently become the personnel-safety authority for a safety-related mode boundary.

### DOC-CONFIRMED — validation includes actual safety-function testing and installation checks
Pilz validation guidance includes safety-function tests, confirmation that safety functions/components are correctly installed, and at deeper scope fault simulation.

Engineering consequence: restoration must reach the physical safety function. Merely returning software variables to their nominal values is insufficient where the test artifact touched physical wiring, sensing, final elements or protective geometry.

## Test-artifact register

Every temporary test mechanism should have a small durable record:

| Field | Required question |
|---|---|
| artifact identity | Exactly what force, jumper, plug, simulator, fixture, override, credential or edit exists? |
| purpose | Which unresolved claim requires it? |
| authority | Who/what may install or enable it? |
| scope | Which safety function/channel/device is affected? |
| configuration binding | Which machine/configuration/revision is the test for? |
| visible state | How can personnel locally tell the machine is in a non-production test condition? |
| hazardous capability | What hazard becomes possible while it exists? |
| alternate protection | What prevents exposure during the bounded test? |
| reboot/power-loss behavior | Does the artifact/state persist, disappear, or become UNKNOWN? |
| mode-change behavior | Can a transition toward production occur while it remains? |
| removal action | What physically/logically removes it? |
| independent removal witness | What evidence does not merely echo the enable command? |
| restored-function challenge | What post-removal test proves the affected safety function again? |
| production-release gate | What blocks ordinary rearm/start until restoration evidence is complete? |

## Defeat-resistance patterns

1. **Prefer removable, uniquely identified test hardware over anonymous loose jumpers.** A keyed/labeled fixture with a defined storage location is easier to account for than a scrap wire hidden in a terminal strip.
2. **Make test state locally obvious.** Remote HMI indication is useful diagnostics but should not be the only indication when personnel at the machine can encounter altered safeguarding.
3. **Production state must reject residual test artifacts.** Where the platform exposes configured forces, test edits, inhibited safety devices or an unsigned/unvalidated safety state, treat that as a production-release blocker rather than a warning to click through.
4. **Do not rely on memory.** Restoration is a checked transition, not the technician remembering every temporary modification made during troubleshooting.
5. **Separate authorization from safety proof.** A maintenance password can authorize an action; it does not prove the protected space is clear, the fixture is removed, or the safety function works.
6. **Use independent witnesses where practical.** If the same software bit both requests a bypass and reports `bypass removed`, the evidence has a common-cause blind spot.
7. **Fail closed on ambiguous restart.** After reboot, power loss, controller replacement, project download or uncertain state recovery, do not infer that a temporary defeat disappeared safely. Re-establish configuration identity and the required physical restoration evidence.
8. **Design out nuisance-driven defeat.** If validation requires repeated awkward rewiring or hidden jumpers, improve the test point/fixture architecture. Inconvenience that predictably encourages leaving a bypass installed is an engineering defect.

## Adversarial cases

### A — disabled force remains configured
A safety input was forced during commissioning. The technician disables forces and sees normal live values.

**Reject production release.** Disabled is not removed. The residual force remains a latent mechanism that can later be enabled or misread. Require removal and restored-function validation.

### B — jumper removed according to the work order
The work order says `remove J17`, but no one inspects the terminal and the HMI shows `guard healthy`.

**Insufficient evidence.** The HMI may derive from the same bypassed path. Obtain an independent physical/removal witness and challenge the actual guard function.

### C — matching safety signature after fixture use
The controller safety signature matches the approved record after an external test plug was used.

**Configuration identity only.** The signature does not prove the external plug/wiring/mechanical installation is restored.

### D — reboot during test
A controller or HMI reboots while a physical jumper remains installed. Software test-state memory resets to `NORMAL`.

**Unsafe state reconstruction.** Production release must not be based solely on volatile software state. Physical artifact accounting and restoration evidence survive/restart independently of that assumption.

### E — test password known by operators
Operators learn a maintenance password used to suppress nuisance trips.

**Authorization architecture failed.** More importantly, password possession still cannot create a safety proof. Remove the nuisance cause and make the engineered safe path easier than the defeat path.

### F — fixture intentionally simulates safe sensor state
A validation fixture drives the controller-side input but bypasses the field sensor and wiring.

The test can prove the downstream controller reaction to that simulated value. It **cannot** prove the sensor, cable, connector or physical actuation path. Bound the conclusion accordingly and perform a physical end-to-end challenge when that claim is required.

### G — ordinary FPGA reports override removed
The normal motion FPGA sets and reads back its own override register.

That can be useful diagnostics but is not independent personnel-safety evidence. Keep safety-related authority and final production release in the appropriate independent safety architecture.

## Cross-machine examples

- **Press brake:** a temporary valve-command simulator must not be mistaken for proof of ram restraint, hydraulic isolation, guard response or safe stored-energy condition.
- **Mill/lathe:** a spindle-enable test jumper cannot remain as an undocumented shortcut after door-interlock testing.
- **Plasma:** simulated torch/arc signals prove only the simulated interface path unless actual energy-control and protective functions are separately challenged.
- **Robot:** setup-mode test tooling must not silently permit automatic production motion after mode transition.
- **Automated cell:** one machine's maintenance override cannot be allowed to survive a cell restart or make neighboring equipment's personnel-clear assumptions true.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC may display test state, suppress ordinary cycle start, discard stale commands, record diagnostic events and require ordinary rearm. The ordinary FPGA may expose test-point telemetry or ordinary control state. Neither becomes safety-rated because it participates in the workflow. Personnel-safety permission, engineered safety mode, protective-device handling and physical energy-removal claims remain in the independently justified safety architecture.

## Verification worksheet

Before production release answer all of these with evidence:

- Are all temporary forces **removed**, not merely disabled?
- Are temporary edits/inhibits/overrides absent or returned to the validated state?
- Are physical jumpers/plugs/fixtures accounted for and independently checked?
- Does the approved configuration/signature match where applicable?
- Did reboot/power-loss/mode changes occur that invalidate test-state assumptions?
- Was the affected physical safety function challenged after restoration?
- Were alternate protections removed only after normal safeguarding was restored?
- Does reset/rearm require fresh post-restoration evidence rather than a stale request?
- Are unresolved physical or machine-specific claims explicitly `UNKNOWN`?

## UNKNOWN — do not invent

This lesson does not establish machine-specific PL/SIL/category, proof-test intervals, diagnostic coverage, hydraulic truth tables, safe pressures, forces, speeds, stopping times/distances, fixture electrical ratings, or required test-point locations. Establish those from the actual risk assessment, safety-function design, device documentation and physical validation.

## Source provenance

- Rockwell Automation, GuardLogix 5580 / Compact GuardLogix 5580 Safety Reference Manual and online documentation: safety forces, safety signatures, downloads and revalidation.
- Rockwell Automation, safety I/O configuration/signature documentation: configuration signature and user-testing boundary.
- Pilz, operating-mode selector safety FAQ: exclusive mode selection, selector alone does not initiate operation, standard-control boundary.
- Pilz, machinery safety validation service description: functional testing, installation checks and fault simulation.

Evidence classification above is intentionally claim-local. No physical machine test was performed for this lesson.
