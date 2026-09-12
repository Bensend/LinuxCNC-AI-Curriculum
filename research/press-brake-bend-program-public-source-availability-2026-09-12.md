# Press-brake bend-program / backgauge sequencer — bounded public-source availability audit

Date: 2026-09-12
Purpose: satisfy the bounded source check required by `press-brake-backgauge-program-sequencing-ownership-2026-09-12.md` before inventing any bend-program UI behavior.

## Search scope

This pass looked specifically for a **public, inspectable LinuxCNC press-brake implementation** containing a bend-step or recipe sequencer that emits backgauge target positions. The goal was not to find generic QtVCP examples or commercial descriptions; it was to locate code/configuration that can establish actual ownership and step-advance behavior.

Searches included:

- GitHub repository search for `linuxcnc press brake` and `press brake linuxcnc qtvcp`;
- GitHub code search for combinations of press-brake, backgauge, bend and program terminology;
- current LinuxCNC forum/web search around press-brake bend-program/backgauge UI wording;
- the known Ursviken/Pullmax build diary and known `hardwork-machines/Linuxcnc-Press-Brake` repository.

## Results

### `hardwork-machines/Linuxcnc-Press-Brake`

The repository root contains only `CAD/`, `renders/`, and `README.md`. It does not contain LinuxCNC runtime configuration, HAL, Python/QtVCP UI, bend-program recipe code, or a backgauge sequencer. The similarly named `NMinhThanh/Linuxcnc-Press-Brake` repository is a same-sized derivative surfaced by repository search and does not provide a new mature sequencer source lead.

Classification: **SOURCE UNAVAILABLE for sequencer analysis**.

### Ursviken/Pullmax Optima diary

The public diary provides useful architecture prose: the builder describes a UI sending a requested position to `limit3.in`, `limit3.out` driving `joint.N.posthome-cmd`, and post-home control being enabled after the joint is homed. This establishes a plausible field ownership surface for individual gauge positioning.

However, the bounded search did not locate a final public downloadable UI/config repository exposing:

- bend recipe data structure;
- current-step index ownership;
- multi-axis target-set transaction semantics;
- step-advance predicate;
- interrupted-step/reconcile behavior;
- same-target consecutive-step handling.

Classification: **COMMUNITY-REPORTED UI/program-control architecture; FINAL SEQUENCER SOURCE UNAVAILABLE**.

### General LinuxCNC/UI repositories

Generic QtVCP/QtPyVCP and LinuxCNC UI repositories are useful for GUI mechanics, but the bounded search did not identify a public press-brake-specific bend recipe implementation that would answer the ownership question directly. They are therefore not substitutes for missing press-brake source.

## Durable negative result

The absence of inspectable final sequencer source is itself an evidence-quality result. Do not fill this gap by assuming commercial-controller behavior or by converting the Ursviken prose into nonexistent code semantics.

What can be taught now is bounded:

1. LinuxCNC extra-joint semantics are source/documentation-grounded.
2. The Ursviken field report supports UI-owned post-home position requests through an independent planner.
3. PB-BG-003 demonstrates a generic application episode-identity requirement against stale completion.
4. Exact press-brake bend-step data structures and final step-advance implementation remain **SOURCE UNAVAILABLE** in the inspected public material.

## Consequence for next experiment

A future multi-mechanism target-set experiment may test **generic software ownership semantics** only. It must not be presented as reproducing an existing LinuxCNC press-brake sequencer.

The experiment would be justified if framed around information that is already established independently:

- parent target-set generation;
- multiple independently controlled gauge mechanisms;
- one mechanism late while others are complete;
- partial target repetition between recipe steps;
- invalidation of one mechanism after aggregate readiness;
- explicit reconciliation/new generation before re-readiness.

No machine speeds, tolerances, mechanical collision logic, bend-angle logic, hydraulic sequencing or safeguarding behavior should be invented merely to make the simulation larger.

## Revisit rule

Revisit SOURCE UNAVAILABLE only when a new attachment, repository, or clearly identified implementation appears. Do not repeatedly search the same Ursviken thread each lesson.
