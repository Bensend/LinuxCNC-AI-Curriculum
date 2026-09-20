# Safety-input test-pulse, cross-short, and diagnostic-authority study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Why this lane

Current main was re-read immediately before this write. The primary safety lane is advancing CINCINNATI AUTOFORM energized hydraulic commissioning and post-service hydraulic evidence, and a separate recent lane has advanced guard-interlock defeat/human factors. This study deliberately uses different files and a different evidence family: electrical safety-input diagnostics, test pulses, cross-shorts, OSSD compatibility, and commissioning proof.

No executable lab is justified for this source/documentation question. No GitHub-hosted or self-hosted compute is used.

## Core architecture lesson

A dual-channel wire pair is not automatically a diagnosed dual-channel safety input.

Freeze these distinctions:

`TWO WIRES PRESENT != TWO INDEPENDENT CHANNELS VALID`.

`BOTH INPUT BITS ON != FIELD CIRCUITS HEALTHY`.

`DUAL-CHANNEL LOGIC AGREES != SHORT BETWEEN CHANNELS EXCLUDED`.

`TEST OUTPUT CONFIGURED != CORRECT TEST SOURCE WIRED != TEST PULSE OBSERVED != REQUIRED FAULT DETECTION PROVED`.

`OSSD OUTPUT PULSES != SAFETY-CONTROLLER TEST PULSES`.

`INPUT FILTER ACCEPTS OSSD TEST PULSES != REACTION-TIME EFFECT ACCOUNTED FOR`.

`FAULT CLEARED != SAFETY REQUALIFIED != FRESH ORDINARY START`.

## Source-grounded behavior

### Pilz test-pulse principle

Pilz defines a test-pulse output as a source that applies specific pulses to appropriately wired inputs so shorts across contacts can be detected.

Source: https://www.pilz.com/en-US/support/lexicon/articles/072903
Evidence: **DOC-CONFIRMED** manufacturer documentation.

This supports the architectural distinction that the safety evaluator needs an intentional diagnostic relationship between source and input; merely having two static 24 V signals does not create cross-short diagnostics.

### Rockwell Guard I/O input configuration

Rockwell Guard I/O documentation states that Safety Pulse Test mode can detect shorts to 24 V and channel-to-channel shorts to other inputs. It also requires selection of the actual test source feeding a pulse-tested input; selecting the wrong source produces pulse-test failures. The same documentation distinguishes this from Safety mode for a device such as a light curtain that performs its own output pulse tests.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1791es-um001_-en-p.pdf
Evidence: **DOC-CONFIRMED** manufacturer manual.

This is a strong commissioning lesson:

`INPUT MARKED SAFETY != INPUT DIAGNOSTIC MODE CORRECT FOR THE FIELD DEVICE`.

The input configuration must match whether the field circuit is passive contacts driven by controller test outputs or an active OSSD device performing its own diagnostics.

### OSSD pulse compatibility and filtering

Rockwell's GuardLogix Light Curtain documentation notes that many light curtains pulse-test OSSD1/OSSD2. A safety controller input can interpret the brief low diagnostic pulse as a protective demand unless the interface or safety-controller filtering is designed for it.

Source: https://www.rockwellautomation.com/en-id/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/light-curtain--lc-.html
Evidence: **DOC-CONFIRMED** manufacturer documentation.

Rockwell's current safety-I/O reference additionally states that configured input delay can filter OSSD low test pulses/noise, but any configured delay must be included in system reaction time.

Source: https://www.rockwellautomation.com/en-il/docs/technical/logix5000/_online/1756-rm015/logix-sis-safety-reference-manual-ditamap/safety-i-o.html
Evidence: **DOC-CONFIRMED** manufacturer documentation.

Therefore:

`FILTER REMOVES NUISANCE TRIP != FILTER IS FREE`.

A delay that changes the safety input's response belongs in the validated response-time chain. This study does not assign a permissible OpenPressBrake filter or response time.

### SICK OSSD self-test example

SICK TGS documentation gives a concrete OSSD behavior: the active OSSD is cyclically tested with a brief LOW pulse for cross-circuit monitoring, and downstream control elements must be chosen so the diagnostic pulse does not cause unintended switching-off.

Source: https://www.sick.com/media/docs/5/15/615/operating_instructions_tgs_testable_safety_light_curtain_en_im0014615.pdf
Evidence: **DOC-CONFIRMED** manufacturer manual.

This reinforces that a waveform which briefly goes low may be a deliberate diagnostic rather than a protective demand; the validated receiver/interface must distinguish those cases without masking a real demand.

### Diagnostics do not eliminate restart design

Rockwell GuardLogix system-status documentation states that safety I/O can use pulse-test/monitoring diagnostics and set affected data to the safe state when faults are detected. It also explicitly assigns application responsibility for latching I/O failures and verifying proper restart behavior.

Source: https://www.rockwellautomation.com/en-pl/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/monitor-safety-status-and-handle-faults/monitor-system-status.html
Evidence: **DOC-CONFIRMED** manufacturer documentation.

Thus:

`FAULT DETECTED != FAULT DISPOSITION COMPLETE`.

`WIRE REPAIRED != AUTOMATIC MOTION AUTHORIZED`.

## Failure-path matrix for the curriculum

For every proposed dual-channel safety input, trace at least these cases and record which are actually detectable by the selected architecture:

| Challenge | Question to prove |
|---|---|
| channel A open | Does the evaluator reach/inhibit the safe state as intended? |
| channel B open | Same, independently. |
| A shorted to +24 V | Is the fault detected, or can the channel be falsely held active? |
| B shorted to +24 V | Same. |
| A shorted to B | Can both channels appear healthy from one electrical source? Is cross-short detection actually configured? |
| channel short to 0 V | What safe/fault state results? |
| wrong test source assigned | Does commissioning expose the configuration error? |
| test output failed/stuck | What diagnostic/fault path exists? |
| active OSSD connected as passive-contact circuit | Are competing pulse schemes compatible? |
| OSSD test pulse interpreted as demand | Is nuisance tripping caused by an invalid interface/filter choice? |
| excessive input filter | Has the resulting reaction-time contribution been included in validation? |
| discrepancy fault corrected | Is deliberate fault reset/requalification required before hazardous motion? |
| power restored with fault still present | Does the safety function remain inhibited? |
| power restored after wiring repair | Can stale LinuxCNC/HAL/FPGA START/JOG/CYCLE state become motion authority? It must not be assumed safe. |

Exact required diagnostics depend on the risk assessment, device architecture, claimed PL/SIL/category, diagnostic coverage, and manufacturer instructions. Those are **UNKNOWN** for OpenPressBrake until designed and validated.

## Commissioning proof worksheet

For a real machine implementation, preserve evidence for:

1. field device identity and output type: dry contact, semiconductor OSSD, coded safety device, etc.;
2. safety-input module/evaluator identity and firmware/configuration where relevant;
3. channel wiring and physical cable routing;
4. selected input mode;
5. selected test source for each pulse-tested channel;
6. manufacturer-supported compatibility of OSSD/test-pulse waveforms with the receiver;
7. discrepancy timing/filter settings and their validated reaction-time contribution;
8. deliberate channel-open challenge;
9. deliberate short-to-supply challenge where the manufacturer's validation procedure permits it;
10. deliberate channel-to-channel cross-short challenge where the manufacturer's validation procedure permits it;
11. observed diagnostic code/status and safe output response;
12. correction of the fault without silently restoring production authority;
13. safety reset/requalification behavior;
14. stale ordinary-command challenge;
15. fresh deliberate ordinary START after safety readiness is restored.

Do not perform destructive fault injection on an actual machine merely because it appears in this worksheet. Use manufacturer-prescribed commissioning methods, safe test fixtures, or controlled simulation where appropriate.

## LinuxCNC / FPGA boundary

LinuxCNC/HAL/FPGA may expose useful diagnostic information such as `channel_A`, `channel_B`, discrepancy status, device fault, or reason-for-inhibit. It can make troubleshooting easier.

But freeze:

`HAL INPUT_A = TRUE AND INPUT_B = TRUE != CROSS-SHORT EXCLUDED`.

`FPGA SAW TWO HIGH BITS != INDEPENDENT SAFETY DIAGNOSTICS PROVED`.

`LINUXCNC CLEARED FAULT MESSAGE != SAFETY FAULT RESET/REQUALIFIED`.

Personnel-safety authority remains in the independently validated safety architecture unless and until a particular FPGA/hardware implementation is itself deliberately designed, assessed, and validated for that safety role. Ordinary machine-control logic must not infer safety merely from two static GPIO states.

## Evidence provenance

- Pilz test-pulse behavior: **DOC-CONFIRMED**.
- Rockwell Guard I/O pulse-test, cross-short, test-source and OSSD-mode distinctions: **DOC-CONFIRMED**.
- Rockwell OSSD filtering and reaction-time accounting: **DOC-CONFIRMED**.
- SICK OSSD cyclic LOW test-pulse example: **DOC-CONFIRMED**.
- Failure-path matrix and LinuxCNC/OpenPressBrake architectural application: **INFERENCE**, grounded in those manufacturer behaviors.
- Any claim that OpenPressBrake currently uses a particular safety-input device, pulse scheme, discrepancy time, filter, PL/SIL/category/DC, or cable architecture: **UNKNOWN**.
- No **TEST-CONFIRMED** OpenPressBrake result is claimed here.
- No **COMMUNITY-REPORTED** claim is promoted to design fact.

## Next independent work

Find a complete professional safety-input commissioning example that exposes the whole chain:

`FIELD DEVICE -> TWO CHANNELS/OSSDs -> TEST SOURCE OR DEVICE SELF-TEST -> SAFETY INPUT CONFIGURATION -> DELIBERATE OPEN/CROSS-SHORT/SHORT-TO-SUPPLY CHALLENGE -> DIAGNOSTIC -> SAFE OUTPUT RESPONSE -> FAULT LATCH/RESET -> SAFETY REQUALIFICATION -> FRESH ORDINARY START`.

Prefer a manufacturer commissioning/validation procedure with an actual wiring diagram and explicit fault-insertion table. Keep this lane separate from the primary hydraulic commissioning package and the guard-defeat/human-factors file family.