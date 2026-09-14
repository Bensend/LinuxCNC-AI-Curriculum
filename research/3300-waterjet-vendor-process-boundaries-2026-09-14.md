# 3300-W1 — waterjet vendor process boundaries for LinuxCNC source hunting

Date: 2026-09-14
Status: VENDOR-DOC-CONFIRMED physical/process semantics; **not** LinuxCNC implementation evidence

## Purpose

The first LinuxCNC W1 implementation hunt exposed nozzle, abrasive, manual/program authority and Z-correction surfaces but did not expose pump/high-pressure or pierce sequencing. This companion pass uses current primary vendor documentation only to sharpen the physical states that future LinuxCNC configs must account for. It does not invent HAL pins, timing values or recovery rules.

## Pressure is a commanded process state, not simply pump ON/OFF

Flow's current MotoJet and HyperJet product documentation describes electronically controlled dual-pressure operation specifically because a **low-pressure pierce may be required before a higher-pressure cutting operation**. HyperJet documentation also describes automatic high-pressure bleed-down to 0 psi within one second of pump shutdown.

Engineering consequence for W1 source hunting:

A production state model may need to distinguish at least:

`pump running / pressure source available -> commanded pressure mode/setpoint -> pressure achieved/qualified -> cutting-head valve state`

rather than one `pump_on` Boolean.

Exact readiness feedback, tolerance, transition time and ownership remain UNKNOWN until a real LinuxCNC implementation or pump interface is inspected.

## Piercing is process-specific and can alter water/abrasive ordering

Flow's current UltraPierce documentation explains a vacuum-assisted brittle-material pierce where abrasive is pulled into the head a split second **before** the waterjet starts, specifically to avoid a water-hammer effect and ensure abrasive is entrained immediately.

OMAX's current Z-axis/accessory documentation independently describes vacuum assist as eliminating delay between water and garnet feed for consistent automatic piercing. It also documents low-pressure stationary piercing for small-hole quality and automatic dynamic pressure adjustments.

Engineering consequence:

Do not freeze a universal rule such as `water on -> wait -> abrasive on` or `abrasive on -> wait -> water on`. Real waterjet equipment supports materially different pierce recipes according to material, head/accessories and quality strategy.

The LinuxCNC process contract therefore needs a **recipe-qualified pierce episode** with explicitly sourced ordering/timing rather than hardcoded generic lead/lag assumptions.

## Abrasive availability and metering are their own authority/feedback layer

KMT's current product information describes:

- a bulk abrasive hopper that monitors whether sufficient abrasive is available during cutting and pneumatically transfers it to an onboard metering device;
- a FEEDLINE V abrasive feeder whose flow can be controlled by a central CNC controller or potentiometer to supply optimized abrasive flow.

This supports a stronger distinction than the initial LinuxCNC forum evidence alone:

`abrasive bulk availability -> transfer/feed subsystem -> metering command -> nozzle abrasive delivery`

The real 2014 LinuxCNC retrofit already established separate abrasive-sender commands. Vendor evidence now shows why a future playbook should not equate `abrasive output requested` with `abrasive available/flowing`.

Actual LinuxCNC abrasive-flow feedback remains UNKNOWN.

## Nozzle-clog recovery is a real process fault/recovery domain

OMAX current accessory documentation describes an automated Air Sweep that reacts to nozzle clog by diverting water away from the abrasive hopper and purging the nozzle/abrasive feed line with air and water under software control.

This establishes that nozzle/abrasive faults can require a recovery sequence that changes fluid routing and purges process lines; a simple `abort -> all outputs off` model may be operationally incomplete even if it is the safe first response.

For LinuxCNC W1, do not invent this sequence. Instead search real configs for:

- clog or abrasive fault inputs;
- diverter/purge outputs;
- recovery-state ownership;
- whether recovery is operator-triggered or automatic;
- how motion/process restart is reconciled afterward.

## Pump physical behavior differs by pump architecture

KMT documentation distinguishes intensifier/constant-pressure and direct-drive/constant-flow pump behavior. KMT explains that intensifier pumps can maintain commanded pressure while the cutting-head flow is closed during traverses/end-of-cut, whereas direct-drive pumps require careful idle control to avoid overpressure.

Engineering consequence:

The safe/valid relationship among `pump running`, head valve closed, pressure state and idle time may depend on pump architecture. A LinuxCNC playbook must carry pump-type provenance before declaring how pump control participates in cut transitions or pauses.

## Revised evidence-target model

The next real LinuxCNC implementation should be inspected for these separate surfaces:

1. `pump command` / pump enable;
2. pressure mode or pressure setpoint;
3. pressure-ready / pump-ready / fault feedback;
4. cutting-head high-pressure valve command;
5. abrasive bulk-availability indication if present;
6. abrasive transfer/metering command and possible feedback;
7. recipe-selected pierce mode (normal, low-pressure, vacuum-assist, water-only, etc.);
8. water/abrasive ordering and timers attached to that recipe;
9. nominal Z and standoff correction;
10. clog/diverter/purge recovery if the machine implements it;
11. feed-hold/abort behavior for each of the above.

This is a **search schema**, not a claim that every waterjet has all eleven surfaces.

## Cross-check against current LinuxCNC evidence

The 2014 two-nozzle/two-abrasive retrofit is consistent with vendor evidence that abrasive delivery is independently commanded and may be manually overridden. The dual plasma/waterjet retrofit proves LinuxCNC can host the machine class but exposes no pump/process details. The manual-Z thread proves cutting-time Z correction can be separate from nominal Z. None of those sources establish pressure-ready, pump architecture, pierce recipe or clog recovery.

Therefore the vendor documentation narrows the next questions without closing them.

## Adversarial review — 8/8

1. Does Flow dual-pressure documentation prove a LinuxCNC machine has a pressure-setpoint pin? **No.** It proves pressure mode/setpoint is a real process concept worth tracing.
2. Is low-pressure pierce universally required? **No.** Vendor language says it is application-dependent.
3. Is abrasive always started after water? **No.** Flow UltraPierce explicitly documents a process that entrains abrasive before water starts.
4. Is abrasive command equivalent to abrasive flow? **No.** Availability, transfer and metering are distinct physical layers.
5. Can pump/head-valve behavior be universalized across intensifier and direct-drive pumps? **No.** Their idle/pressure behavior differs.
6. Does a clog imply LinuxCNC should automatically run a purge sequence? **No.** That is a machine-specific recovery architecture requiring evidence and safeguarding analysis.
7. Does vendor software behavior establish LinuxCNC recovery semantics? **No.**
8. Can these vendor facts be used to fill missing LinuxCNC timing values? **No.** Timing/order remains recipe/config evidence work.

## Promotion decision

W1 is better constrained but **not ready for a production state-machine promotion**. Continue searching public LinuxCNC configs/build diaries using the refined terms: pump/intensifier READY, dual pressure, high-pressure valve, abrasive feeder/metering, low-pressure pierce, vacuum assist, clog purge, Flow/KMT/OMAX retrofit.
