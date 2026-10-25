# 4400-ACCESS-01 — Sixteen open technician transfer scenarios
**2026-10-25 | PAPER ONLY | 16 public scenarios UNSCORED | not a blind challenge, not a machine test**

For each case: (1) name the OEM mode and exact claim; (2) state the physical hazard that could remain; (3) identify which independent safety authority and final element must act; (4) name one missing selected-machine witness; (5) propose a guard-friendly remedy without inventing PL, stop time, pressure or thresholds. Do not infer that the referenced equipment is installed on OpenPressBrake.

1. Kinetix 6200 Safe Torque Off **without standstill checking** has a copied stop delay; a large saw blade is still spinning when the timer expires. Is door release gated by observed speed in this mode?
2. A safety-rated encoder confirms standstill at a motor shaft, but a sheared belt coupling lets a dangerous output roller rotate. What is the monitor's narrow supported proposition?
3. A technician configures the 2013 Kinetix option for **SLS Status Only** and connects SLS_Out only to a LinuxCNC HAL status pin. The axis exceeds the speed limit. Which reaction is missing?
4. SLS status reaches a safety PLC, but the PLC output is mapped only to a yellow beacon. What is not allocated?
5. A Kinetix guard uses **Power to Lock**; an internal output fault deenergizes DC_Out. What does the manual say OFF means for the door?
6. A team assumes a power-to-release lock is universally safer than power-to-lock. Identify trapped-person escape and emergency rescue counterarguments without prescribing an unevaluated polarity.
7. A guard is already unlocked when a fault occurs. A technician assumes any fault forces it locked. Which manual warning contradicts that?
8. A standstill-checked safe stop detects low speed, but the encoder resolution and threshold imply long verification latency. What information is needed before choosing a bypass or timer?
9. A vertical axis uses this specific Kinetix **SS1**; the guard gate output goes off below standstill speed. What product-specific warning applies and what holding proposition remains open?
10. A vertical load uses this specific Kinetix **SS2** and maintains torque. The maintainer calls it a lockable hydraulic/mechanical restraint. Why is that unsafe inference?
11. A Rockwell safety status-only output is safe-rated; the ordinary controller is frozen in a fault. What independently owned response must be traced?
12. An operator requests access to a two-spindle cell; one axis is stationary, the other coasts. Can a single axis' safe speed prove zone safety?
13. A CNC mill's LinuxCNC position DRO stops updating because of a software stall; an independent sensor still sees motion. Which source is permitted to control the personnel access decision?
14. A service engineer needs access inside a locked cell and can be trapped when power is lost. Separate outside access delay, inside escape and restart prevention.
15. A user bypasses a slow guard interlock because waiting for coast-down wastes time. Give an engineering redesign that reduces incentive without weakening the physical safe-state condition.
16. A press-brake ram's Y1/Y2 position readouts show zero speed; trapped pressure and gravity can still move the beam. Which independent physical witnesses are required before personnel access?

**Scoring boundary:** these are open practice cases, not sealed keys; no solutions are included. External fresh-AI competency scoring remains OPEN. No simulation or fault injection should be initiated merely to answer the cases.
