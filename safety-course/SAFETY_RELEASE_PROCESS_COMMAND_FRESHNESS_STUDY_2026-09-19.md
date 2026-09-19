# Safety Release vs Process-Command Freshness Study — 2026-09-19

## Scope

Independent Lane-B study of a control-boundary failure that is especially relevant to LinuxCNC retrofits: a safety function clears and ordinary control still contains a previously asserted motion/start request.

This study does **not** choose OpenPressBrake reset hardware, stopping performance, hydraulic truth tables, pressure values, PL/SIL/category/DC, or machine-specific automatic/manual restart policy.

## Why this matters

A safe control architecture has at least two different state machines:

1. the safety system decides whether safety-related output authority may exist;
2. ordinary machine control decides whether a production/manual motion command presently exists.

If the second state machine simply remains TRUE while the first removes and later restores permission, a safety release can accidentally become the event that restarts hazardous motion. That is an interface defect even when the safety function itself behaved correctly.

## Evidence classification

### SOURCE-CONFIRMED — Siemens safety-programming guidance

Siemens, *Programming Guideline Safety for SIMATIC S7-1200/1500*, V1.6 (07/2024), section 3.9, states that resetting a safety function must not trigger machine restart. Where safe actuators are also used for operational switching, Siemens recommends interlocking process control with the safety-program enable so a safety shutdown also resets process control and a **new switch-on signal** is required.

Source: https://support.industry.siemens.com/cs/attachments/109750255/109750255_Programming-Guideline-Safety_DOC_V1_6_en.pdf

### SOURCE-CONFIRMED — Siemens Safety Integrated E-stop boundary

The SINAMICS S120 Safety Integrated function manual states that automatic motor restart after Emergency Stop is not permissible. It also makes the useful distinction that automatic restart after deactivation of some other safety functions can be permissible depending on the risk analysis; its example mentions protective-door closure.

Source: https://cache.industry.siemens.com/dl/files/292/109763292/att_971633/v1/S120_safety_fct_man_1218_en-US.pdf

This prevents an overbroad curriculum rule: **not every safety-function recovery universally requires the same manual restart architecture**, but E-stop release must not automatically restart hazardous motor motion, and ordinary command persistence must be explicitly analyzed for every safety function.

### SOURCE-CONFIRMED — Rockwell reset semantics

Rockwell's *Guardmaster Safety Relays User Manual*, publication 440R-UM013I-EN-P (07/2024), distinguishes automatic and manual reset. Automatic reset can energize safety outputs as soon as safety inputs are closed; manual reset requires the safety inputs closed and then an off-on-off reset-input cycle. External-device N.C. feedback contacts can be placed in the reset/monitoring path.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um013_-en-p.pdf

Rockwell's Guardmaster SI installation instructions further document monitored manual reset as a required reset-circuit signal change, with reset faults for invalid sequencing.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440r-in042_-mu-p.pdf

### SOURCE-CONFIRMED — Pilz reset/start modes

Pilz documents three distinct PNOZ behaviors: automatic start energizes when the input circuit closes; manual start expects a rising edge; monitored start expects a falling edge.

Source: https://www.pilz.com/en-INT/support/faq/products-solutions/articles/180991

## Architecture freeze

`SAFETY INPUT HEALTHY != SAFETY RESET VALID != SAFETY OUTPUT AUTHORITY != ORDINARY PROCESS COMMAND PRESENT != FRESH PROCESS COMMAND != HAZARDOUS MOTION AUTHORIZED.`

`E-STOP DEVICE RELEASED != E-STOP SAFETY FUNCTION RESET != FRESH START/JOG/CYCLE INTENT.`

`AUTOMATIC SAFETY RESET PERMITTED BY AN APPLICATION != PERMISSION TO RETAIN A STALE ORDINARY MOTION COMMAND.`

`SAFETY RELEASE EDGE MUST NOT BE USED AS A SUBSTITUTE FOR A FRESH ORDINARY MOTION COMMAND.`

## LinuxCNC/OpenPressBrake boundary

The independent safety system owns the personnel-safety decision. LinuxCNC/HAL/ordinary FPGA may receive a diagnostic/permissive indicating that safety authority exists, but that permissive is not itself a START, JOG, cycle-resume, valve-command, or motion request.

For an implementation in which a safety trip must invalidate ordinary motion intent, the ordinary control state must be designed so that loss of the safety enable clears or otherwise invalidates the relevant latched command. When safety permission returns, a new valid ordinary command must be established according to the machine's validated operating mode and risk analysis.

This is an architectural requirement, not a claim that every guard closure, every protective-device clear, or every safety-function reset universally requires a human pushbutton. The actual restart policy is application-specific except where a stronger requirement applies, such as the SOURCE-CONFIRMED E-stop no-automatic-restart boundary above.

## Failure-path worksheet

| Challenge | Safety-side question | Ordinary-control question | Required evidence |
|---|---|---|---|
| E-stop pressed while cycle START remains logically latched | Did safety authority drop? | Was stale START invalidated? | safety state + process-command state + physical motion witness |
| E-stop actuator manually released | Is reset/rearm still required as designed? | Does release itself cause motion? | no motion caused by actuator release |
| Safety reset accepted | Are final elements/feedback valid? | Is fresh ordinary command still absent where required? | separate safety-ready and command states |
| Guard/protective function clears in a mode allowing automatic safety reset | Is automatic safety reset actually validated for this application? | Can a pre-existing JOG/CYCLE bit resurrect motion? | mode-specific restart trace |
| Power restored with safety input healthy and ordinary START stuck TRUE | What does safety startup permit? | Is startup treated as fresh intent? | startup state trace; no assumption |
| LinuxCNC/HAL reconnects after safety system is already ready | Is safety authority independent of LinuxCNC? | Are old userspace/HAL commands rejected or regenerated correctly? | command-generation/freshness witness |
| Safety trip occurs during hold-to-run/manual command | What removes safety authority? | Must the hold-to-run control be released/re-actuated? | device/mode-specific evidence |
| EDM/final-element feedback recovers | Does feedback recovery merely satisfy a safety precondition? | Can feedback recovery become START? | separate EDM, reset, command, motion states |

## Commissioning questions

1. Force each relevant safety demand while START/JOG/CYCLE/manual-motion requests are active.
2. Record whether ordinary command state is cleared, invalidated, generation-tagged, or otherwise prevented from becoming fresh intent later.
3. Restore the safety input without issuing a new ordinary command and verify the expected machine-specific restart behavior.
4. Exercise safety reset separately from ordinary START.
5. Exercise power loss/recovery and LinuxCNC/controller reconnect with a physical command held or a software command previously latched.
6. Verify that diagnostics distinguish at least `SAFETY NOT READY`, `SAFETY READY`, `RESET REQUIRED/FAULT` where applicable, and `NO FRESH PROCESS COMMAND` rather than collapsing them into one READY bit.
7. Trace the command all the way to the actual final element and physical motion witness; software state alone is not proof of safe physical behavior.

## Provenance labels

- SOURCE-CONFIRMED: manufacturer statements summarized above.
- DOC-CONFIRMED: none added beyond the source-confirmed manufacturer documentation.
- TEST-CONFIRMED: none; no executable or physical test was needed for this source study.
- COMMUNITY-REPORTED: none used.
- INFERENCE: the LinuxCNC command-freshness architecture is an engineering application of the source-confirmed separation between safety release/reset and operational switching; exact implementation remains machine-specific.
- UNKNOWN: OpenPressBrake's final reset/restart policy by mode, exact command-latching implementation, final-element response, and physical restart validation remain to be established on the real machine design.

## Compute

No simulation, synthesis, benchmark, or executable verification was justified. No GitHub-hosted runner was used.

## Exact next Lane-B work

Find a complete professional implementation exposing:

`active ordinary motion request -> safety demand -> safety output/final element safe reaction -> ordinary process request invalidated -> safety condition restored -> reset/rearm according to the validated function/mode -> no unintended resurrection of stale command -> fresh ordinary command -> physical motion`.

Prefer a machine-tool, press, drive/STO, or safety-PLC example that shows both the safety program and standard-control interlock so the curriculum can trace the interface rather than only one side.