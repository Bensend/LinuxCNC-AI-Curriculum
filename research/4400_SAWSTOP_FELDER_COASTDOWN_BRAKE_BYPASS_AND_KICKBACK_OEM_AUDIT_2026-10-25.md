# 4400-SAW-01 — Blade coast-down, contact-brake power and bypass are different safety states
**2026-10-25 | Cross-machine 4400 safety source audit | no physical saw tested**

## Question
After the operator switches off a saw motor, is the moving blade safe? Is a skin-contact brake still active during coast-down? Can a manufacturer-provided bypass or key disable that function? Do any of those systems eliminate kickback?

## Official primary sources
1. **SawStop Professional Cabinet Saw (PCS) official manufacturer FAQ**, inspected 2026-10-25, https://www.sawstop.com/product/professional-cabinet-saw-pcs31230-atgp36/ . The manufacturer distinguishes the **red motor paddle** from the **yellow main power switch**: after a red-paddle stop, skin-contact detection remains active during coast-down **while the yellow switch continues powering the cartridge**. Manufacturer describes **Bypass Mode** as disabling braking for certain conductive material processing. The same page warns that nonstandard blade shapes/kerfs, tooth shoulders and some coated teeth can alter detection or stopping behavior. **DOC-CONFIRMED exact PCS product/FAQ only**; no machine-specific stopping-time proof or broader model transfer. An original Feb 2024 PCS manual is linked on the product page but its 24.7 MB PDF could not be fetched by the available reader; do not claim direct manual inspection.
2. **Felder Group PCS manufacturer documentation**, https://www.felder-group.com/en-us/pcs , inspected 2026-10-25. The company describes an electromagnetic near-field tissue detection system with rapid blade retraction and a **key-switch deactivation mode** for special materials. This is an OEM product statement, **not** an independently verified claim that all body parts, configurations and faults are protected. Marketing phrases such as 'absolute safety' are not accepted as engineering guarantees.
3. **OSHA table saw machine-guarding eTool**, https://www.osha.gov/etools/machine-guarding/saws/table , inspected indexed original guidance 2026-10-25. Separately describes point-of-operation contact, under-table transmission hazards, kickback and flying particles; advocates guard/push-stick, spreader/anti-kickback protection, and warns of **coasting blades after power removal**. **DOC-CONFIRMED guidance**, not a substitute for selected machine design/inspection.

## Claims ledger
| Claim | Class | Boundary |
|---|---|---|
| SawStop PCS brake monitors coast-down after red paddle stop while yellow power stays ON | DOC-CONFIRMED | exact product FAQ, no independently measured stop |
| SawStop Bypass Mode deactivates skin-contact braking | DOC-CONFIRMED | OEM product FAQ, not a safe generic setup instruction |
| Felder PCS permits key-switch deactivation for some processing | DOC-CONFIRMED | OEM product page, actual configuration unknown |
| Motor OFF or E-stop necessarily means blade stopped | REJECTED inference | inertia/coast-down independent physical state |
| Contact-brake/retraction removes kickback and ejecta hazards | REJECTED inference | different hazard and guard functions |
| A healthy LED proves blade contact protection active during all power transitions | REJECTED inference | power, bypass, selected fault states and physical validation separate |
| LinuxCNC/FPGA spindle OFF can guarantee skin-contact stopping | REJECTED inference | normal motion control cannot replace qualified protection |
| Actual PCS/Felder safety performance, stop distance/time, selected bypass authority, residual rotation | UNKNOWN | no as-built or test evidence |
| TEST-CONFIRMED physical stop or independent evaluation | none | source-only |

## Failure paths and human factors
**S1 — coast-down state confusion:** motor request OFF but blade still rotating; touching blade or removing a guard based on an HMI 'OFF' is unsafe. Selected physical standstill or guarded wait required.

**S2 — supply-power change:** the documented SawStop PCS coast-down detection depends on cartridge power remaining present; do not assume identical protection after main power loss. This is **not** an instruction to leave power on for service; maintenance requires separate isolation and verified standstill.

**S3 — bypass left enabled:** material change to conductive stock prompts bypass; later operator resumes wood cutting with bypass still active. Require explicit mode indication, authorized scope, convenient return to protected mode, and revalidation; no shortcut that treats bypass as permanent.

**S4 — blade mismatch:** a replacement blade alters mass, teeth or detection properties; manufacturer warns stopping behavior may differ. Treat blade/guard/brake variant changes as a safety-impacting change, not a pure cutting-quality swap.

**S5 — kickback despite brake:** material jams and ejects before any skin contact; point-of-operation and anti-kickback geometry still matter. An advanced contact-protection feature is complementary, not a replacement for guard, splitter/riving knife and correct feed support.

**S6 — optimistic marketing:** OEM says very fast retraction or high protection; no universal 100% safety, no machine-level PL/SIL or guaranteed injury outcome is inferred.

## Cross-machine transfer
A press brake or robot cell can likewise be in a **normal control OFF** state while gravity or inertia remains hazardous; a safety function may depend on an energized monitoring supply even when the motor is stopped. Qualified architecture must separately define emergency stop, coast-down/hold, guard access, maintenance energy isolation, deliberate reset/restart and mode-specific bypass. This is an analogy, not a claim that OpenPressBrake contains SawStop/Felder equipment.

**No saw run, no bypass enabled, no test or compute, no independent evaluation.** Do not infer numerical blade stop times, PL/SIL or an allowed safe reach interval.
