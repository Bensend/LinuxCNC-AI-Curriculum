# IO01 initial research — quadrature encoder register-to-HAL path

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Status: **RESEARCH**

## Objective

Trace a HostMot2 quadrature encoder from FPGA/module discovery and register sampling through generic HostMot2 processing to HAL count/position/velocity state. Keep FPGA edge capture, host sampling, scaling/estimation and physical encoder integrity as separate layers.

## Documentation baseline

Official HostMot2 documentation exposes per-channel `count`, `rawcounts`, `position`, `velocity`, `reset`, and bidirectional `index-enable`, plus configuration including `scale`, `counter-mode`, `filter`, index polarity/masking and `vel-timeout`. Current/development documentation also describes filtered A/B/Index state and quadrature-error reporting. `scale` converts count units to position units; normal quadrature typically yields four counts per pulse. At low speed, velocity estimation may span multiple HostMot2 reads until `vel-timeout` expires.

The HostMot2 DPLL documentation is an important timing lead: quadrature encoders can be assigned to a DPLL timer to reduce position-sampling jitter, especially on Ethernet boards. This is not evidence that the DPLL changes the FPGA's fundamental quadrature counting semantics; it changes sampling timing.

## First pinned source map

- `src/hal/drivers/mesa-hostmot2/hostmot2.c`: module-descriptor dispatch routes both `HM2_GTAG_ENCODER` and `HM2_GTAG_MUXED_ENCODER` to `hm2_encoder_parse_md()`.
- `src/hal/drivers/mesa-hostmot2/encoder.c`: primary implementation; entry points include `hm2_encoder_parse_md()`, `hm2_encoder_tram_init()`, `hm2_encoder_process_tram_read()`, and `hm2_encoder_write()`.
- `src/hal/drivers/mesa-hostmot2/hostmot2.h`: declares the encoder entry points and encoder state structures.

## Evidence boundaries to preserve

- FPGA quadrature logic can count transitions between host reads; host `hm2_read()` sampling is not equivalent to software edge counting.
- HAL `position` is a scaled software publication derived from encoder count state; it is not an analog measurement.
- HAL `velocity` is an estimate with timestamp/timeout behavior, not simply `delta_position / servo_period` in all regimes.
- Index reset/latch behavior needs source tracing before making assumptions about exactly which count state is zeroed and when the bidirectional HAL handshake changes.
- Electrical noise, differential receiver behavior, cable integrity and missed/false physical edges are hardware concerns and cannot be validated by the cloud lab.

## Community/adversarial leads

Field reports about wrong counts, index problems or velocity instability should be treated as diagnostic leads. Candidate causes include scale/PPR misunderstanding, filter/sample-frequency choices, wiring/noise, index polarity/mask configuration, quadrature errors, sampling jitter and transport/realtime problems. Do not assign a cause from symptoms alone.

## Exact next checkpoint

Read pinned `encoder.c` completely enough to inventory module descriptor validation, register addresses/strides, TRAM registration, per-instance state, HAL exports, 32/64-bit count extension, timestamp/velocity estimation, reset/index/latch paths, quadrature error, filter/counter-mode writes and DPLL/timer behavior. Then write `call-flows/IO01-encoder-read-path.md` from generic `hm2_read()` through TRAM completion and `hm2_encoder_process_tram_read()` to HAL publication. Only after that decide whether an existing fake-LLIO fixture can exercise production encoder processing without simulating physical edge capture.
