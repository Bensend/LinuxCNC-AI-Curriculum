# 4400-CHIP-02 — Pinned LinuxCNC M31/M33 allocation versus Haas conveyor command semantics
**2026-10-25 | pinned 2.9 + development documentation source | NO RUNTIME TEST**

## Why this matters
The Haas OEM chip conveyor source uses **M31** to initiate intermittent conveyor operation and **M33** to stop its ordinary automatic operation. A LinuxCNC engineer reading the same G-code must **not** assume these are stock LinuxCNC conveyor controls. Incorrect transfer could silently omit an auxiliary hazard from the design review, or encourage a custom remap with no independent safety authority.

## Direct pinned repository inspection
- LinuxCNC **2.9** commit `a33293f`, file `docs/src/remap/remap.adoc`, section `[[remap:unallocated-m-codes]]`, Git blob `a5b7db8d24a172d8cca9aed8f4df521fde063ab1`. https://github.com/LinuxCNC/linuxcnc/blob/a33293f/docs/src/remap/remap.adoc
- LinuxCNC **development** commit `062dc7c097693bb68e76192516cd92878dd5ecdf`, same file and section, blob `75e2a0980fab0e24662cd9f4a70fde28db80425b`. https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/docs/src/remap/remap.adoc
- Both pinned documentation sources list **M31 and M33** in the `30-39` row of **currently unallocated M-codes**, and explain that such codes may be assigned by custom remapping. **DOC-CONFIRMED from pinned repository docs**, not a direct runtime parser execution.
- LinuxCNC official M-code reference (stable documentation, accessed 2026-10-25) lists M62–M65 ordinary digital output control and M100–M199 user-defined codes, not Haas conveyor behavior. https://linuxcnc.org/docs/html/gcode/m-code.html
- Haas original *Chip Conveyor* technical page documents its **vendor-specific** M31/M33 and Settings 114/115 periodic restart. https://haascnc.com/reference-container/Technical-Details/Options/Chip-and-Coolant_Management/conveyor.html

## Compatibility decision table
| Question | Evidence-supported answer |
|---|---|
| Is Haas M31 a stock LinuxCNC conveyor-start command? | **No such stock meaning in either inspected LinuxCNC pinned remap reference**; M31 is documented as unallocated. |
| Is Haas M33 a stock LinuxCNC safety stop? | **No**. Haas describes it as an ordinary conveyor-operation stop, while LinuxCNC pinned docs list M33 unallocated. |
| Can a LinuxCNC integrator define custom behavior for these numbers? | Pinned remap documentation says currently unallocated codes may be remapped. Actual configured machine remaps must be inspected. |
| Does a custom remap make a conveyor safety-rated? | **No**. Ordinary interpreter, Task, HAL, PLC and FPGA commands do not by themselves establish personnel-safety authority. |
| Can the 2015/2026 Haas automatic restart timing be assumed on LinuxCNC? | **No**. A specific LinuxCNC controller or external PLC might implement different logic; as-built implementation is UNKNOWN. |

## Failure-path exercise (non-executable)
A technician ports a Haas postprocessor that emits M31/M33 into a LinuxCNC machine. The machine uses an independent conveyor PLC and a custom M-code remap. The technician assumes M33 guarantees a service-safe chute. The correct review separates (1) what the interpreter/remap requests, (2) what the conveyor PLC actually does, (3) what the selected independent protective system prevents, and (4) how drive isolation and no-restart are physically verified. Do not test this with hands or tools near a moving conveyor.

## Evidence classes and unresolved question
**DOC-CONFIRMED:** pinned LinuxCNC remap tables and exact Haas vendor behavior. **SOURCE-CONFIRMED:** no parser implementation path traced here; repository documentation was directly inspected but is classified DOC-CONFIRMED, not TEST-CONFIRMED. **INFERENCE:** transfer and safety review. **UNKNOWN:** custom remap, LinuxCNC version-specific runtime parser error/acceptance, physical conveyor wiring, safety integrity. No need to run a lab to establish that documented stock meanings differ; a future selected custom-remap behavior question can be resolved from its source/config before any bounded nonhazardous self-hosted test.

**Preserve graduated 3000 track:** this is 4400 safety transfer, not reopening 3100/3200/3800 or 3300.
