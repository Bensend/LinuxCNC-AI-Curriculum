# R01 — LinuxCNC Realtime Model

Status: RESEARCH / SOURCE

Prerequisite: A01 graduated.

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Learning objective

A fresh AI engineer must be able to distinguish LinuxCNC's realtime API abstraction, realtime-capable versus simulated/non-realtime uspace execution, HAL periodic threads, host-kernel scheduling capability, and actual measured latency. It must be able to locate the implementation path that creates/starts periodic realtime tasks and explain why “LinuxCNC ran successfully” is not proof of deterministic realtime performance.

## Initial questions

1. What does LinuxCNC mean by `uspace`, and when can uspace be realtime-capable versus simulated/non-realtime?
2. Which RTAPI calls create and start periodic execution, and how does the uspace backend implement them?
3. How does HAL create its named periodic threads and assign periods/priorities?
4. What checks determine `hal_get_realtime_type()` / realtime capability?
5. What observable evidence distinguishes successful software execution from a qualified realtime host?
6. Which latency/jitter measurements are necessary before making hardware timing claims?

## Official documentation pass — initial findings

Current LinuxCNC developer documentation makes several boundaries explicit:

- `hal_create_thread(name, period, uses_fp)` establishes a periodic HAL realtime thread. Periods are rounded to integer multiples of the hardware timer period, the first-created thread determines that timer period, and later-created threads receive decreasing priorities; documentation therefore requires creating threads fastest-to-slowest for rate-monotonic priority ordering.
- `rtapi_is_kernelspace()` distinguishes kernelspace realtime implementations such as RTAI from userspace implementations such as uspace.
- `rtapi_is_realtime()` is not simply “LinuxCNC is running.” For uspace it reports realtime capability only when the running kernel indicates realtime capability and `rtapi_app` has the required privilege/capabilities. Current documentation recommends `hal_get_realtime_type()` instead.
- `hal_get_realtime_type()` reports the current LinuxCNC instance's realtime type; in uspace, userspace HAL components can exist even when `rtapi_app` has not yet started.
- HAL's user documentation states that `loadrt` loads a realtime component and that its functions must be added to a realtime thread to execute periodically.
- The current `halcmd` documentation explicitly says that on userspace-based realtime systems (for example PREEMPT_RT) **and on systems without realtime support**, `halcmd` uses `rtapi_app`; on a non-realtime host this can create a simulated realtime environment. This directly preserves the Phase-0/A01 warning that executing LinuxCNC's realtime code path is not equivalent to realtime qualification.

Official references inspected 2026-09-06:

- https://linuxcnc.org/docs/devel/html/en/man/man3/hal_create_thread.3.html
- https://linuxcnc.org/docs/devel/html/en/man/man3/rtapi_is.3.html
- https://linuxcnc.org/docs/devel/html/en/man/man3/hal_get_realtime_type.3.html
- https://linuxcnc.org/docs/devel/html/en/hal/basic-hal.html
- https://linuxcnc.org/docs/devel/html/en/man/man1/halcmd.1.html

Classification: `DOC-CONFIRMED`; source tracing below determines exact behavior at the pinned revision.

## Community pass — investigation leads, not authority

LinuxCNC forum reports reinforce two practical cautions worth testing rather than accepting as architecture facts:

- PREEMPT_RT kernel presence alone does not guarantee acceptable latency. Users report substantial machine-, driver-, desktop-, and kernel-configuration sensitivity.
- A machine may run LinuxCNC/simulation on a non-realtime kernel while producing unusable latency; successful startup therefore has much weaker evidentiary value than measured scheduling behavior.

Representative leads:

- https://forum.linuxcnc.org/27-driver-boards/51247-yet-another-error-finishing-read-with-mesa-7i76e
- https://forum.linuxcnc.org/18-computer/57219-linuxcnc-latency-and-jitter-improvements-with-preempt-rt-kernel-parameter-tuning
- https://forum.linuxcnc.org/9-installing-linuxcnc/49288-lcnc-on-beagleboard-ai64

Classification: `COMMUNITY-REPORTED`. These examples do not establish universal thresholds or causality.

## Pinned source inventory — first pass

| Path | Symbols / role | Depth | Why it matters |
|---|---|---|---|
| `src/rtapi/rtapi.h` | `rtapi_task_new`, task/thread API declarations, priorities, timing API | deep | backend-independent realtime contract |
| `src/rtapi/uspace_rtapi_main.cc` | uspace `rtapi_task_new()` wrapper into the uspace application/backend | deep | entry into current userspace implementation |
| `src/rtapi/rtai_rtapi.c` | RTAI implementation of `rtapi_task_new()` | comparison | prevents uspace behavior from being generalized to all backends |
| `src/hal/hal_lib.c` and related HAL thread implementation | `hal_create_thread`, exported function/thread bookkeeping | deep next | connects RTAPI periodic tasks to HAL execution ordering |
| `src/rtapi/rtapi_app_main.cc` / uspace application sources | userspace realtime environment lifecycle | deep next | capability/setup boundary behind `rtapi_app` |
| `docs/src/man/man3/rtapi_task_new.3.adoc` | documented task creation contract | normal | docs/source reconciliation |
| `docs/src/man/man3/rtapi_task_start.3.adoc` | documented periodic task start contract | normal | period/start semantics |

Pinned source search confirms `src/rtapi/rtapi.h` declares `rtapi_task_new()` for init/cleanup context, while `src/rtapi/uspace_rtapi_main.cc` implements the public symbol as a wrapper into `App().task_new(...)`. R01 must now trace that backend call through task creation, scheduling policy/priority, periodic wait/start behavior, and capability detection instead of stopping at the wrapper.

## Initial claims ledger

| Claim | Classification | Evidence | Confidence | Verification needed |
|---|---|---|---|---|
| A LinuxCNC uspace build is necessarily running with realtime guarantees | `CONTRADICTED` | current `rtapi_is`/`halcmd` docs explicitly allow uspace simulated/non-realtime execution | high | trace pinned capability/backend source |
| A passing GitHub Actions A01 topology run proves realtime suitability | `CONTRADICTED` | A01 experiment boundary + current docs | high | none; never promote |
| HAL periodic functions execute because they are loaded | `CONTRADICTED / incomplete` | HAL docs require functions to be added to a realtime thread | high | trace `hal_create_thread` + `addf` execution path |
| HAL thread creation order affects priority ordering | `DOC-CONFIRMED` | `hal_create_thread(3)` | high | confirm pinned source implementation |
| PREEMPT_RT label alone guarantees acceptable machine latency | `UNSUPPORTED` | community reports show large variability; no universal guarantee in reviewed docs | high | later measured-latency lesson/experiment |
| `rtapi_task_new()` is backend-independent API with backend-specific implementation | `SOURCE-CONFIRMED` | `rtapi.h`, uspace and RTAI implementations | high | trace uspace call flow next |

## Evidence boundary

R01 must keep four statements separate:

1. **code path exists** — source evidence;
2. **realtime environment reports a type/capability** — runtime configuration evidence;
3. **scheduler/task actually receives requested realtime policy/priority** — process/thread observation evidence;
4. **host meets latency/jitter needs under realistic load** — measurement evidence.

None implies the next automatically.

## Exact next checkpoint

Continue R01 at pinned commit `8bf4605...` by tracing the complete uspace call flow from `rtapi_task_new()` / `rtapi_task_start()` through `App().task_new` and the periodic task body/wait mechanism. Record scheduling policy, priority conversion, memory locking/capability requirements, failure behavior, and how non-realtime fallback is represented. Then trace `hal_create_thread()` into RTAPI task creation far enough to explain period rounding and priority assignment. Design a small lab only after the source trace identifies a runtime observation that distinguishes simulated uspace from realtime-capable uspace without pretending GitHub's host is realtime-qualified.