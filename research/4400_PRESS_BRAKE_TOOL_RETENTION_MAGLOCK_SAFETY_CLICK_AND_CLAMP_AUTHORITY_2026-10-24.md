# 4400 — Press-brake tool retention is not clamping, load holding or protection against tool breakage

**Original manufacturer-source comparison, 2026-10-24 UTC.** Status: documentary safety engineering / no selected tool holder, machine inspection, physical test, achieved PL/SIL or safety release.

## Why this matters

A press brake has at least three distinct falling/flying hazards: **(1)** an upper punch drops while unclamped during tool change; **(2)** a tool or clamp shifts/releases under bending loads; **(3)** a die/tool fractures and ejects a fragment during bending. A magnetic aid, mechanical anti-drop button, hydraulic/pneumatic clamp, and toughened die may address different subsets. **A tool retained during setup is not necessarily clamped for bending; a clamped tool is not necessarily protected against fracture; neither proves a gravity-loaded ram safe.**

## Direct manufacturer evidence

| Source / exact edition | DOC-CONFIRMED manufacturer statement | What it does NOT prove |
|---|---|---|
| **WILA**, original [Fast and safe tool set-ups](https://www.wilatooling.com/en-us/knowledge-innovation/our-innovations/fast-and-safe-tool-set-ups/), inspected 2026-10-24 | Safety-Click is a mechanical feature of New Standard **top tools** enabling vertical click-in/out; WILA specifies suitability for tools **up to and including 12.5 kg**. WILA separately describes hydraulic or pneumatic clamping, self-seating and its Easy to Move bearing system. | That a heavier tool can safely hang from Safety-Click; that every WILA holder/tool includes it; that the click is the operational bending clamp; or that tool holding qualifies ram support. |
| **Mate Precision Technologies**, [Maglock press release](https://www.mate.com/news/mate-precision-tooling-introduces-new-american-precision-style-press-brake-tooling-featuring-maglock-magnetic-safety-system-easier-safer-punch-front-loading/), **2017-11-06** | American Precision Style Maglock uses rare-earth magnets to seat/temporarily retain punches at the holder. Mate explicitly says **the holder clamping system must be engaged** after seating and Maglock **is not intended as a substitute** for the clamp. Mate advertises additional retention if electrical/hydraulic/pneumatic power is lost. | That Maglock alone is qualified for bending, has a universal tool-weight limit, or that magnet holding equals independent safety-rated clamping/ram restraint. |
| **AMADA**, [Press Brake Safety Guide](https://www.amada.co.jp/english/products/pdf/saftyguide_bend_e.pdf), seventh edition **February 2016**, printed p.9 (PDF p.10, zero-index 9) | AMADA presents **fly-off prevention dies** as a distinct measure that combines toughness and hardness to reduce the risk of flying fragments if a die breaks. The guide separately addresses workpiece support and operator exposure. | That anti-drop punch retention prevents die fracture/ejection, or that AMADA's product-specific die concept establishes any selected OpenPressBrake tooling performance. |
| **WILA**, [New Standard Tool Holders](https://www.wilatooling.com/en-us/products/press-brake-tool-holders/new-standard-tool-holders/), current original page inspected 2026-10-24 | Distinct holder variants include hydraulic, pneumatic and manual clamping, plus tool change, guards and compatibility choices. | Interchangeability of an arbitrary punch tang, Safety-Click, Maglock, adaptor and selected holder without exact manufacturer approval. |

**Evidence discipline:** the 12.5 kg figure belongs only to WILA's described Safety-Click mechanism; it is **not** an OpenPressBrake tool mass allowance, a general clamp rating, or a requirement for Mate's different Maglock system. The Maglock marketing statement about power loss does not establish an achieved machine safety function or a physical test of the installed clamp.

## Independent physical propositions

| Proposition | Candidate witness | Invalid shortcut |
|---|---|---|
| `PHY-TOOL-SETUP-RETENTION` — tool cannot fall during a controlled, isolated tool-change operation | Exact installed anti-drop device/tool/holder, condition and OEM-approved handling, qualified non-exposed inspection | 'Safety-Click' or 'Maglock' printed in an unrelated catalogue |
| `PHY-TOOL-BEND-CLAMP` — tool remains correctly secured under selected bending operation | Actual holder/actuation/lock state and OEM application envelope, tool compatibility, validated setup | Magnet seated / click heard / HMI clamp indicator |
| `PHY-FRAGMENT-CONTAINMENT` — credible tool fracture/ejection does not expose people | Tool material/condition, tooling limits, guards/physical containment and validated operating boundary | A punch anti-drop feature or an optical die-gap guard |
| `PHY-RAM-HOLD` — gravity-loaded press ram safely supported | Separately selected and validated ram mechanical/hydraulic restraint | Any upper punch retention feature |
| `PHY-SERVICE-ENERGY` — maintenance tooling access without hazardous energy | Independent mechanical support, lockout, pressure/energy verification and approved tool handling | CNC disable, pump off or clamp-status light |

## Fault and human-factor review

- **INFERENCE — mistaken substitution:** a worker trusts Maglock to hold during a bend despite Mate's explicit instruction to engage the holder clamp. Safeguard: visible clamp state and a mechanical/operational arrangement that makes bending with unclamped tools difficult, with safety-related detection/stop only if independently justified.
- **INFERENCE — overweight or mixed tooling:** a WILA Safety-Click-equipped top tool exceeds its exact mechanism's documented 12.5 kg suitability, or a different tang/adaptor is assumed compatible. Safeguard: per-segment tool identity, mass, retention design, approved holder and accessible lifting aid; **do not guess** a universal limit.
- **INFERENCE — damaged anti-drop mechanism:** a missing or jammed button/catch, contaminated magnet face, misseated shoulder or altered holder can defeat intended temporary retention. Safeguard: condition check, no body beneath an unsecured tool, simple replaceable parts, easy visual access and mechanical support during changes.
- **INFERENCE — wrong physical hazard:** a toughened die helps fragment risk, but not a falling punch or sheet whip-up. Safeguard: hazard-specific protection, not one 'safe tooling' indicator.
- **INFERENCE — maintenance shortcut:** tool change is so awkward that operators bypass guards or reach into the die gap with the ram unrestrained. Safeguard: safe vertical loading, positive supports, ergonomic lifting, quick correctly keyed clamps and guard restoration as the easiest workflow.

## Required selected-machine intake and release gates

Record conditional `IN-04f`: exact upper/lower tool IDs, masses and segments; WILA/Mate/other product and edition; holder/clamp/adaptor model and actuation; anti-drop/temporary-retention mechanism; tool/holder compatibility; physical clamp witness; pressure/power loss behavior; condition/inspection; die fracture/ejection hazard and containment; tool-change service supports and LOTO; and operator reach/guard geometry. If none of these brands is installed, do **not** assume them. Actual selected OpenPressBrake tooling **UNKNOWN**.

Before any physical validation: qualified design review, no exposed operator, controlled energy and tool support, manufacturer-approved handling, separate ram restraint and pressure isolation. No live unclamp/drop test or destructive die-break test is authorized by this curriculum. Machine-specific safe tool mass, clamp force, tool strength, stopping time, PL/SIL, proof interval and acceptable residual risk remain **UNKNOWN**.

## Cross-machine transfer

The same proposition separation applies to mill tool changers, robot grippers, lathe chuck retention and automation pallet locks: **temporary capture != process-force clamping != independent hazardous-energy control**. A software 'tool present' signal may be useful normal control/diagnostics but cannot independently prove mechanical retention under load.

**Evidence:** `DOC-CONFIRMED` for four manufacturer pages and AMADA 2016 original PDF; `INFERENCE` for failure paths and proposed architecture; `UNKNOWN` for actual selected hardware; no new `SOURCE-CONFIRMED` LinuxCNC code trace, no `TEST-CONFIRMED` physical result, no community evidence. External safety evaluations remain open; no hazardous operation authorized.
