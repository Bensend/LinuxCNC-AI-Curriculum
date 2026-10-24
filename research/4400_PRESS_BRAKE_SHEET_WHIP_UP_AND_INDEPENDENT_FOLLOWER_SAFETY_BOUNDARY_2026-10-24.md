# 4400 — Press-brake workpiece whip-up and independent sheet-follower safety boundary

**Original source audit, 2026-10-24 UTC. Status: documentary engineering research / selected-machine UNKNOWN / no physical validation.** This is a new hazard branch, not a 3000 specialization restart or an exact historical-archive restoration.

## Engineering question

Can a press brake have a correctly functioning ram/laser protection chain while a workpiece or added powered sheet follower creates a separate operator hazard? **Yes as a credible hazard class; no particular OpenPressBrake installation is established.** A complete machine safety boundary must include the *workpiece trajectory* and *auxiliary material-support actuator*, not only the Y1/Y2 ram and die-closing gap.

## Original sources and exact claims

1. **Oregon OSHA**, *Machine safeguarding at the point of operation*, public PDF https://osha.oregon.gov/OSHAPubs/2980.pdf , printed pp. 33–34 (PDF pp. 33–34; indexed p.32–33). Original PDF text and p.33 illustration inspected 2026-10-24. **DOC-CONFIRMED:** a press-brake workpiece can whip upward, pinching against the slide face or striking the operator; tooling change is another distinct exposure. The diagram explicitly distinguishes **A: part-to-slide pinch** and **B: rising-sheet strike**. This is a general Oregon OSHA educational guide, not a design-specific stopping-time or machine acceptance standard.
2. **AMADA**, *Press Brake Safety Guide*, seventh edition **February 2016**, original manufacturer PDF https://www.amada.co.jp/english/products/pdf/saftyguide_bend_e.pdf , printed p.7 (PDF p.8, zero-index 7). **DOC-CONFIRMED:** an optional sheet follower supports sheets during bending, reducing fatigue and the risk of face injury from unexpected sheet whip-up; stepped stopper fingers reduce the need to reach between punch and die. Its p.6 three-position foot pedal and p.8 two-operator controls are **different safeguarding concepts**, not substitute proofs of follower stopping. The guide is an English translation based on Japanese requirements and directs users outside Japan to applicable local law.
3. **Fab Supply**, original product page https://press-brake-products.fabsupplyinc.com/item/all-categories/sheet-follower/sheet-follower , inspected 2026-10-24. **DOC-CONFIRMED for the manufacturer's advertised product architecture:** servo-powered followers; optional suction/air-table attachments; independent operation from press controls; usual two-unit configuration; actual load capacity depends on sheet center of gravity and chosen actuators; remote troubleshooting is offered. **UNKNOWN:** whether a particular installation has independent safety-rated interlocks, safety stop coupling, guarding, or local restart. The statement 'independent from press controls' must **not** be expanded into 'no safety connection exists'.
4. **ENUTRON**, original EnuLIFT EnuA/1 product page https://enutron.com/press-brake-sheet-followers-enulift-enua1/ , inspected 2026-10-24. **DOC-CONFIRMED as vendor product description:** portable, stand-alone follower can be disconnected and moved between press brakes; vendor promotes material handling/ergonomic benefit. **UNKNOWN:** selected connection, safety wiring, stored energy, movement envelope and replacement/configuration effects.
5. **OSHA**, *Guidelines for Point of Operation Guarding of Power Press Brakes*, CPL 02-01-025, https://www.osha.gov/enforcement/directives/cpl-02-01-025 . **DOC-CONFIRMED for historical directive scope:** piece-specific operator training must address whipping and tooling. This directive is **historical** and does not by itself define current modern normative acceptance or override machine-specific safeguards.
6. **Cincinnati** BASEFORM original manufacturer manual search-indexed at https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-558-n-07-14-90-175-baseform-series-press-brake-operation-safety-and-maintenance-manual.pdf . Search excerpt states forming speed too high can cause whip-up. **SOURCE NOT FULLY INSPECTED**: the 31 MB original was rejected by the web PDF fetch; retain as corroboration lead only, **not** DOC-CONFIRMED from inspected PDF. No Cincinnati-specific speed figure transferred.

## Safety authority / causal map

| Layer | Legitimate role | Does **not** prove |
|---|---|---|
| LinuxCNC/normal CNC | Bend sequence, Y1/Y2 commanded speed, follower trajectory/synchronization, alarms and ordinary operator UI | Independent protective stop, actual physical sheet restraint, safe standstill, follower brake, or cleared hazard zone |
| Workpiece/tool geometry | Part length/width, overhang, bend axis, tool opening, support location, changing part center of gravity | That the part will remain within the ram laser's sensing field |
| Press safety system | Independently allocated guard/laser/E-stop safety demand and final-element action on the press | That a **stand-alone follower** receives the same demand or has ceased motion |
| Follower safety system (if installed) | Selected independent safety-rated stop/hold function and monitored final elements, where justified by risk assessment | That follower load remains supported after torque/pressure removal, or that part cannot fall |
| Physical safe-state witness | Separate observable stopped ram, follower stopped/held, part trajectory controlled, pinch/strike zone inaccessible, stored energy isolated for service | An achieved machine-level PL/SIL or certification without validated architecture and evidence |

**Failure path A (INFERENCE):** part rises during bending → sheet strikes operator outside punch-tip optical protection or traps a hand against slide → 'laser healthy' status does not detect that different geometry. This hazard is directly supported as a class by Oregon OSHA/AMADA, but its occurrence in a selected machine is **UNKNOWN**.

**Failure path B (INFERENCE):** stand-alone powered follower is omitted from press safety-demand path → press ram stops on protective interruption → follower may continue commanded motion or retain force → new nip/strike/lift hazard. This is a **question to verify**, not a finding that Fab Supply/ENUTRON products lack safeguards.

**Failure path C (INFERENCE):** follower torque is removed without a justified load-holding/part-retention concept → supported heavy sheet drops or shifts → residual injury despite stopped motor. No physical weight, torque, center-of-gravity, deceleration, load-hold or stopping time is inferred.

**Failure path D (INFERENCE):** portable follower reinstalled or remotely configured → changed geometry/axes/stop authority/guard coverage → previous validation becomes stale; a saved program or 'ready' LED is not proof of the changed installation.

## What must be captured before any selected-machine design or test

- **BND/ENE/HAZ:** workpiece size, overhang, orientation and full bending trajectory, operator/helper locations, front-face pinch and upward strike envelope, and follower motion/pinch/entrapment/maintenance zones.
- **IN-04e (conditional):** does OpenPressBrake actually have powered sheet followers or sheet lifters? Record exact manufacturer, model, firmware, installation/revision, number of supports, power supplies, independent/press-coupled command channels, local/remote configuration and disconnect behavior. If absent, record **NOT APPLICABLE**, not an invented device.
- **SF/SRS/AUTH/ARC:** separately assign press stopping, follower stopping, part holding/containment and restart authority. Trace protective-device input → **qualified independent safety logic** → each actual press/follower final element. A CNC synchronization signal is not a safety channel.
- **DEP/CCF:** common supplies, drive enables, remote setup, brake/holding hardware, disconnect/reconnect, guarding changes, power restoration and stored gravity/elastic energy.
- **HF:** make material support and correct guard installation quick, accessible and ergonomically preferable; avoid a support device that must be removed to perform normal bends or service. Treat predictable bypass incentives as design failures.
- **PHY/VAL/PT:** establish distinct physical witnesses for ram stopped, follower stopped, workpiece held/contained, guarded access and servicing energy isolation. Paper-only adversarial cases can be prepared now; no live testing until a qualified isolated plan exists.

## Adversarial design questions

1. A light curtain correctly stops the ram. Does it cover the entire *rising sheet* path, including the slide-front pinch and face-strike envelope?
2. Can the follower move on a separate control/drive after the press stop request? Is its stop function safety-rated and independently evidenced?
3. If the follower loses electrical/hydraulic power, does the part fall, slide or rotate? What physical retention remains?
4. Can the press restart from a held pedal/remote command after follower reconnection or protective reset? Who owns deliberate local rearm?
5. Can a worker restore the follower and guard easily without defeating interlocks? Are maintenance access and lifting support designed for realistic jobs?
6. Does a machine-specific part/tooling change invalidate prior safe workpiece path assumptions?

## Source classification and stop decision

- **DOC-CONFIRMED:** Oregon OSHA p.33 whip-up pinch/strike illustration; AMADA 2016 sheet-follower risk-reduction description; Fab Supply independent servo-follower product description; ENUTRON portable stand-alone product description; OSHA directive historical training scope.
- **INFERENCE:** four candidate causal failure paths and proposed independent safety architecture/validation gate.
- **UNKNOWN:** selected OpenPressBrake part trajectory, any installed follower, actual press/follower safety interface, force/holding behavior, physical stop/guard/restart proof and achieved integrity.
- **SOURCE-CONFIRMED:** no new LinuxCNC source path traced this session; previous pinned v2.9.10 ordinary-control boundary remains applicable only as prior evidence.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used.
- **Laboratory disposition:** no simulation is justified before exact machine geometry and independent safety wiring; no physical tests authorized. **No personnel-exposed hazardous operation** if basic safeguards are unverified; isolated/remote research requires people outside the danger zone and residual risk assessment.

## Transfer beyond press brakes

A sheet follower resembles a robot end effector, material feeder, mill pallet lifter or lathe bar feeder in one crucial way: **adding an auxiliary actuator adds its own hazardous-energy and exposure boundary**. Do not automatically assume the parent machine's E-stop, interlock or guard protects the added device. The actual integration must be traced and physically validated.

**Next:** paper technician scenarios in the linked field card; conditional selected-machine intake; manufacturer application-specific safety interface drawings before schematic capture or validation. Do not claim 4400-HY-01 or 2520–25F0 graduation.


## Additional inspectable retrofit architecture: follower with its own encoder and learning mode

**SHENCHONG**, original manufacturer installation article dated **2022-11-24**, https://www.shenchong.com/bending-follower-installation-instruction-servo-motor-delta-plc.html , inspected 2026-10-24. **DOC-CONFIRMED for this specific product's published setup procedure:** a single-servo/Delta-PLC follower adds a separate magnetic scale mounted by the press ram scale, with differential A+/A−, B+/B−, Z+/Z− channels, its own powered controller and E-stop switch, follower origin calibration, tooling/plate parameters, speed-ratio learning, and a distinct Start Follow control. It directs users to repeat learning when the magnetic-scale origin changes. This is a **concrete implementation** of auxiliary motion whose calibration can become stale independently of the press CNC.

**High-consequence boundary:** the article's demonstration includes energizing the press, bending a sheet and manually moving the follower during setup. It is **not** a curriculum commissioning or safe live-test recipe. Its stated placement distances, forming-speed number, offsets and learning increments are **product-specific setup values, not generic safety acceptance values**. A follower-local E-stop mentioned in the article does **not** prove that press and follower E-stop paths are mutually integrated, that the stop removes hazardous force, or that independent physical holding exists. Actual circuit diagrams, safe-state reactions, cross-channel diagnostics and load retention remain **UNKNOWN**.

**INFERENCE/validation questions:** incorrect origin after tool change → follower phase error → sheet lift or collision; separate magnetic-scale fault or loss → stale follower trajectory despite normal press scale; follower-local E-stop versus press E-stop asymmetry; power restoration/Start Follow retention; and service recalibration requiring exposed access. Add these to `DEP/CHG/HF/VAL` as selected-machine questions, not proven failures of the OEM product. No simulation is necessary to establish the documentary independence of these interfaces; physical behavior needs exact hardware and a qualified isolated plan.
