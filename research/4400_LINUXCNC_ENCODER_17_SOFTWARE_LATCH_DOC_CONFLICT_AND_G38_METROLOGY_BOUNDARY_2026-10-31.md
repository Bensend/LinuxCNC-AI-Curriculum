# 4000-LC-ENCODER-17 — Software encoder latch is implemented despite stale HAL documentation

**2026-10-31 | LinuxCNC-first 4000 source continuation | NON-GRADUATED.** Direct follow-through from [PROBE-16](4400_LINUXCNC_PROBE_16_TASK_VERDICT_BARRIER_PREVIEW_AND_POSITION_SOURCE_VERSION_AUDIT_2026-10-31.md). No lab, hardware or motion.

## Exact question
The shipped [`servo_sim.hal`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/lib/hallib/servo_sim.hal#L270-L285) routes `sphereprobe.probe-out` to `motion.probe-input` and `encoder_px/py/pz.latch-input`. Is `encoder.position-latched` actually functional, and is it an FPGA hardware-timestamped event or a software sample? Does G38 automatically use it?

## Pinned source and conflicting documentation
- Development [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), [`src/hal/components/encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/components/encoder.c#L315-L455), blob `79027a83f74f5576e1ab02c8a5d466e0c5266e11`; also lines 528–534 and 588–645. Stable **v2.9.10** encoder source blob `36b2e91a733a333b4342b4983bd1356693b89338` has the same latch input/edge/count/output path around lines 386–393, 432–434, 528–531, 587–640.
- [`docs/src/hal/rtcomps.adoc` lines 326–349](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/hal/rtcomps.adoc#L326-L349), blob `b8aa03117af5e028cb1d247bd0788a0434bc68c3`, explicitly calls `counts-latched`, `latch-falling`, `latch-input`, `latch-rising` and `position-latched` **“Not used at this time.”**
- [`docs/src/man/man9/encoder.9.adoc` lines 120–135](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/encoder.9.adoc#L120-L135), blob `2a4226cf1e573c26f4aa7eb475f1535bdb26233a`, says rising/falling `latch-input` edges update `counts-latched` and `position-latched`. **DOC/DOC-CONFLICT; source resolves implementation existence.** Do not infer that either documentation page describes a different hardware driver.

## Source-confirmed event and publication chain

1. **Configuration:** `encoder.c` initializes `latch_rising=1` and `latch_falling=1` (development lines 260–272), exports `encoder.update-counters` and `encoder.capture-position`. The pinned `servo_sim.hal` places `update-counters` in the **base thread** and `capture-position` in the **servo thread** (lines 19–32). This is the **software HAL encoder component**, not a Mesa/HostMot2 hardware timestamp feature.
2. **Edge sample:** `update()` lines 383–394 reads `latch_in`, compares with `old_latch`, gates the rising/falling edges and writes the **current software raw count** to `buf->latch_count` with `latch_detected=1`. It does not capture a physical edge timestamp in this latch branch. The count reflects the software sampler's observed state and timing.
3. **Thread handoff:** `capture()` lines 410–434 switches the active buffer and, if `latch_detected`, copies `buf->latch_count` into `cntr->latch_count`. Lines 528–534 publish `counts-latched = latch_count - index_count` and `position-latched = counts-latched * scale`. A value may remain unchanged until another qualifying edge; the output has **no per-event validity or timestamp pin in this path**.
4. **Overwritten edges:** if two enabled latch edges occur on the same active buffer before `capture()` consumes it, the later `buf->latch_count` assignment overwrites the earlier count. **SOURCE-CONFIRMED conditional overwrite mechanism**, but actual loss rate, sample rate and event order are **UNKNOWN** without the real thread schedule/input waveform.
5. **Separate G38 path:** `src/emc/motion/control.c::process_probe_inputs` writes `probedPos=carte_pos_fb` at a servo probe verdict; Task/interpreter `#5061–#5069` read that path (PROBE-16), **not** `encoder.*.position-latched`. Routing the same probe signal to both consumers does not merge their capture semantics. It is incorrect to claim the software encoder latch is automatically a more precise physical timestamp or a hardware latched Mesa counter.

## Practical inspection contract

For an actual installation, retain the exact HAL/INI, `loadrt encoder` versus `hm2` encoder driver, `addf` order, base/servo periods, `latch-rising/falling`, index-enable, scale, input polarity, any debounce and the source of the quadrature counts. Compare `encoder.*.counts-latched`, `position-latched`, `motion.probe-input`, `#5070` and `#506x` only with time-aligned observation. A software latch count may be a useful separate measurement, **but it is not a hardware timestamped metrology guarantee**. A physical probe/encoder interface may have entirely different capabilities; verify its exact driver and OEM documentation.

## Adversarial paper cases (unscored)
- Two latch edges between captures: the later active-buffer count may replace the earlier; **not** proof both events were retained.
- No new latch edge: a prior `position-latched` may remain visible; **not** proof current contact.
- G38.3 no-contact failure while `position-latched` is nonzero: the two observations can disagree without either proving contact; check `#5070` and initial state.
- `rtcomps.adoc` says “Not used”: source and man9 contradict it for the pinned revisions; do not delete a working net solely on the stale page.
- A HostMot2 FPGA encoder is configured instead of `loadrt encoder`: this specific `encoder.c` trace does **not** establish HostMot2 latch semantics.

**Evidence:** SOURCE-CONFIRMED software edge, buffer and output behavior in both inspected revisions; DOC-CONFIRMED contradictory page statements; INFERENCE potential lost intermediate edges; TEST-CONFIRMED none; UNKNOWN physical timing, actual installed driver, numerical error and hardware timestamp capability. No workflows, hosted/local compute or machine operation. Independent personnel safety and OpenPressBrake G0/G1 HOLD unchanged.

**Next:** if useful, inspect the exact HostMot2 encoder/index-latch driver and a real HAL+INI with a probe input to determine whether there is a true FPGA event-capture mechanism, without assuming it from pin names; otherwise rotate to a distinct core LinuxCNC subsystem.
