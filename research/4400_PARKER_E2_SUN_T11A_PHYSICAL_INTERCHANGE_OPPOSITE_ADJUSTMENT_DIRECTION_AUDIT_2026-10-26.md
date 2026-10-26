# 4400-HYD-SWAP-01 — Same cartridge cavity does not mean same adjustment semantics or safe substitution
**Manufacturer-source audit | 2026-10-26 | DOCUMENTARY ONLY / NON-GRADUATED.**

## Original evidence
Parker Hannifin, *E2*1 Series Counterbalance Valve*, official product page https://discover.parker.com/e2-series-counterbalance-valve (read 2026-10-26), especially “How It Works,” “Features & Benefits,” and “How is this valve differentiated from the marketplace?” The page explicitly describes **physical interchangeability in T-11A** and says **clockwise increases the Parker E2*1 setting, opposite the Sun Hydraulics counterbalance series**. This is a **DOC-CONFIRMED Parker manufacturer comparison**, not an independent Sun part-number verification or permission to adjust either product.

Cross-check: Parker *Hybrid Actuation System Cylinders*, Catalog HY08-4005-M11 printed pp.32, 35–36, 61–65, https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf, warns load-holding valves trap pressure and documents several load-holding versus no-load-holding model codes. Parker *Load and Motor Control Valves*, HY15-3502/US, pp.LM1–LM2, https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Cartridge-Systems-Division---Europe/HCSE-Websphere-literature/HCSE_LoadControlValves/Parker_HCSE_LoadControlValve_datasheets_HY15-3502-US-EU_English.pdf, distinguishes modulating counterbalance from simple holding.

## The dangerous assumption
A maintenance technician sees an E2*1 cartridge that fits an existing T-11A cavity, installs it, and assumes the old adjustment convention applies. Even if threads and envelope match, the actual setpoint, pilot ratio, cracking/relief behavior, backpressure sensitivity, fluid/temperature envelope, leakage, monitoring and protective function are **not** established by the cavity. The Parker source expressly documents opposite adjustment direction for the compared series. Incorrect adjustment could reduce retention margin or cause unexpected motion; no actual failure or pressure is inferred.

## Five documentary change-control gates
1. Confirm original and replacement **complete part numbers**, variant suffixes, cavity, body, seals and datasheet revision.
2. Compare original/replacement **functional hydraulic symbols** and verified circuit application, not physical fit alone.
3. Have a qualified hydraulic designer independently review **pilot ratio, relief behavior, load/thermal pressure, backpressure and trapped zones** without assuming a generic setting.
4. Preserve **tamper evidence, independent mechanical support, isolation and restoration records** before any controlled commissioning.
5. Require qualified validation of **independent Y1/Y2 holding, fault response and fresh deliberate start**; never infer PL/SIL from manufacturer marketing.

## Human-factors design
Prefer keyed, noninterchangeable cavities where feasible, durable labels with exact cartridge family and revision, documented replacement kits, captive/tamper-evident adjustment protection and a concise two-person replacement verification. Avoid procedures that rely on remembering which brand turns which way. Do **not** publish field adjustment instructions or authorize a live tuning trial under a suspended load.

## Evidence classification
**DOC-CONFIRMED:** Parker E2*1 physical interchange and Parker-reported opposite adjustment direction; Parker HAS order-code/trapped-pressure warnings. **INFERENCE:** substitution failure path and low-friction anti-error design. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none. UNKNOWN:** any actual replacement on OpenPressBrake, Sun-specific exact revision, valve setting, load/pressure, safety performance and physical validation. No compute/test. **G0/G1 HOLD.**