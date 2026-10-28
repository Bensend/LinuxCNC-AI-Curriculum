# HYD-REGEN-01 — Fast approach is not safety-limited speed or proof of load holding
**4400 technician review | 2026-10-28 | documentary, NOT RUN.**

**Look at the oil path, not just the controller's speed label.** A regenerative cylinder route returns rod-side oil to the cap side. This can make the cylinder move faster while providing less available force. Parker's D111VWZ example has selectable **high-speed regenerative** and **high-force standard** modes; HAWE D 7770 printed p.17 explicitly forbids certain LHDV symbols (-21/-25 and rod-side -11/-15) in specified differential-circuit arrangements. These are **product-specific examples**, not installed OpenPressBrake hardware.

**Three false-green situations:** (1) LinuxCNC requests slow travel but the actual regenerative path remains selected; (2) pump stops while a cross-port path and gravity load remain; (3) an apparently equivalent replacement valve has the wrong load-hold symbol or pilot/T port. None is proved safe by a green HMI bit.

**Easy-to-follow service practice:** keep a one-page signed as-built port/path diagram showing each valve's exact SKU, fast/slow path, load-holding final element, pilot/drain, pressure zones, permitted replacements and required independent stop/hold witness. Do not guess from catalog pictures, hand-fit valves or use a bypass to diagnose. A qualified designer decides safe isolated/remote test prerequisites.

**Ask the reviewer:** Which exact selected valve physically stops and holds the gravity load if regeneration does not leave fast mode? Which chamber/port would show pressure? Which maintenance changes make prior evidence stale? If the answer is unavailable: **HOLD, no personnel exposure.**

Sources: [HAWE D 7770 08/2024 p.17](https://productfinder.hawe.com/downloads/D7770-en.pdf), [Parker MSG14-2500/US A259](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Valve-Division/hydraulicvalve/Catalog-sections-for-websphere/Industrial-Directional-Control/Catalog---Static-Files/D111VW.pdf), [original audit](../research/4400_HYD_REGEN_01_HAWE_PARKER_DIFFERENTIAL_REGEN_LOAD_HOLD_COMPATIBILITY_SOURCE_AUDIT_2026-10-28.md). **DOC-CONFIRMED OEM only; OpenPressBrake UNKNOWN; G0/G1 HOLD.**
