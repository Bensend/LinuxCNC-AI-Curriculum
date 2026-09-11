# Ursviken Pullmax — bounded final-config source search

Date: 2026-09-11
Status: **BOUNDED NEGATIVE SOURCE-AVAILABILITY RESULT**

## Question

After the July 22, 2026 successful-bend report and promise to share the configuration after remaining loose ends, is a later public final Y1/Y2 configuration currently available for source-level audit?

## Search performed

1. Re-opened the LinuxCNC build diary's current last page on 2026-09-11. The forum page was freshly indexed/crawled on the day of this audit and still ends with NWE's **2026-07-22** post stating that the working configuration would be shared after more loose ends were resolved. There are no later posts on page 4 and the forum pagination shows page 4 as the end of the thread.
2. Searched the web for `Ursviken Pullmax Optima LinuxCNC config HAL Y1 Y2`, `pullmax-optima LinuxCNC HAL comp config`, `pullmax_optima linuxcnc`, and related exact terms. Results led back to the forum diary, not to a released configuration repository.
3. Performed a bounded GitHub code search for `pullmax_optima`; no public code result was returned in the accessible GitHub search.

## Result

**FINAL WORKING Y1/Y2 SOURCE NOT LOCATED in this bounded search.**

This is not a universal proof of nonexistence. It is sufficient to stop repeatedly searching the same surface in subsequent hourly lessons unless new evidence appears.

The strongest currently available evidence remains the builder's field report:

- left and right Y servo valves are independently controlled;
- the hydraulic flow-divider behavior is electronically emulated in LinuxCNC/HAL;
- the working arrangement uses two position PIDs plus a sync PID with command zero and Y1−Y2 feedback;
- the sync action slows the side that is ahead;
- the builder reported a successful 90-degree test bend on 2026-07-22.

The exact final correction insertion point, limiting, saturation handling, realtime function order and per-side following-error ownership remain **UNKNOWN** until the promised configuration or equivalent source becomes public.

## Process decision

Apply the curriculum's investigation-control principle here: further same-surface searching now has low information gain. Preserve the Ursviken case as **COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE** and move the next 4600 tandem search to a second independent implementation.

Do not invent the missing HAL from the prose, and do not use the field report to relabel any PB-PREP-001 A/B/C architecture as validated.

## Next checkpoint

Locate a second independent public tandem press-brake implementation or source/config set. Prefer actual HAL/COMP/repository artifacts with two independent Y scales. If only forum prose is available, explicitly classify it as community evidence and compare failure/ownership lessons without copying unverified gains or valve sequencing.
