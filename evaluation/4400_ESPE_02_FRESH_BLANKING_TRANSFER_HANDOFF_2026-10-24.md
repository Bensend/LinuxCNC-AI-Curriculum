# 4400-ESPE-02 — Information-separated fresh-AI optical protection transfer handoff
**2026-10-24 | PREPARED / NOT ADMINISTERED / NOT SCORED / NO HIDDEN ANSWER IN THIS FILE**

## Objective
Test whether a fresh learner can transfer the distinctions among object monitoring, blanking/reduced-resolution, physical field holes, mechanical press vs press brake OSHA scope, physical stopping and restart to **an unfamiliar OEM/configuration** without copying SICK C4000 examples.

## Evaluator-only setup (not to be performed by the learner)
Select a **different** manufacturer or a substantially different product/version from the now learner-readable **SICK C4000 2016 and Rockwell 450L 2022/2024 examples**. Do not use either published source case as a blind oracle; choose a genuinely novel OEM/configuration or materially different previously unseen configuration with a sealed independent oracle. Obtain its original safety manual/configuration documentation, identify a documented blanking or reduced-resolution behavior and a nontrivial reach/fixture geometry. Keep exact oracle/source excerpts and the scoring key outside learner-readable repository artifacts. Check that the learner has not seen the source resolution. If no genuinely independent oracle exists, mark the gate BLOCKED; do not invent one.

## Learner-visible challenge template
“An industrial machine has a configured protective optical device, a removable process fixture, a moving workpiece and a safety controller. The operator reports green/ready after a fixture change. An OEM drawing/configuration excerpt is supplied. Identify what is and is not protected, the object-monitoring and effective-resolution implications, whether detection can occur before hazardous motion reaches a hand, who owns restart, what physical evidence is missing, and what change would make safe routine production easier than bypass. If the machine is a press brake, identify the correct regulatory scope. No machine-specific numerical stop data are supplied.”

Supply only an excerpt that does not expose the answer; evaluator retains oracle.

## Immutable precommit before oracle
Record learner: (1) primary diagnosis/predicted status; (2) causal mechanism; (3) expected observable behavior; (4) minimum discriminating OEM/source/config and physical checks; (5) alternatives; (6) falsifier; (7) confidence 0–100%; (8) solve time; (9) resources used. Timestamp and hash the committed answer. No post-hoc rewriting.

## External scoring and retest
Independent evaluator scores prediction, mechanism, diagnostic efficiency, uncertainty/safety, confidence calibration (0–2 each, total /10). Mark contaminated/invalid if the oracle was seen or ambiguity prevents scoring. On a miss, correct only the transferable reasoning weakness and administer a **different** novel transfer, then delayed retention per `evaluation/BLIND_FEEDBACK_PROTOCOL.md`. Do not award graduation for this prepared assignment.

## Safety
This is a **document-only** assessment. No live machine, simulated safety certification, person-in-field test, physical stop/hold evidence or permission for exposed operation. Normal LinuxCNC/FPGA has no personnel-safety authority.

**Status:** External evaluator UNKNOWN / not run; score NONE; physical `PHY/VAL/PT` NOT RUN; module NOT GRADUATED.
