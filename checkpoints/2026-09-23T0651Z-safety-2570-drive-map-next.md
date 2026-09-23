# Safety curriculum checkpoint — 2570 drive safety map next

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED; 4000 safety remains primary.
- 2520–2560 information-separated external evaluation gates remain OPEN and uncontaminated.
- 2560 completed the syllabus-required dual-method PL/SIL comparison, adversarial assessment, coverage audit, canonical learner route and no-solution evaluator handoff. It is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.
- 2570 source preparation has begun from current Rockwell and Siemens drive-safety documentation.

## 2570 source state

Current durable evidence distinguishes:

- STO torque-removal function from physical standstill;
- STO from electrical isolation;
- torque removal from gravity/external-force restraint;
- STO from SS1, SS2 and SOS;
- safe brake command from proof of physical load restraint;
- normal LinuxCNC drive enable/stop behavior from independent personnel-safety authority.

## Exact next work

1. Select one current servo/VFD family with sufficiently detailed safety documentation and map STO, SS1, SS2, SOS and brake-related functions to the exact physical proposition each establishes and does not establish.
2. Trace a spindle/coasting hazard and a vertical/gravity-axis hazard through that map.
3. Build the syllabus-required low-cost ordinary-drive fallback architecture for a drive without certified STO. Treat it as an engineering teaching pattern, not a certified design.
4. Explicitly analyze contactor location, stored DC-bus energy, welded contacts/feedback, restart behavior, switching duty and the difference between torque removal and isolation.
5. Keep stopping time, brake capacity, brake timing, coast time, safe distance, load behavior and any integrity claim UNKNOWN unless the selected manufacturer evidence actually supplies an applicable value.
6. Prefer authoritative manufacturer evidence; no compute is currently justified.

## Compute

No executable compute was justified or consumed. No GitHub-hosted runner was used. Any later justified compute must target only `[self-hosted, openpressbrake]`.
