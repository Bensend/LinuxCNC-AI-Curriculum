# IO04 — experiment sufficiency and promotion decision

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

Can the stock upstream no-hardware HostMot2 fixture provide a discriminating production-path experiment for PWM command encoding and writes without inventing a fake FPGA or falsely implying physical-output verification?

## Fixture inspection

Pinned `src/hal/drivers/mesa-hostmot2/hm2_test.c` is explicitly a no-hardware low-level I/O test driver. Its read callback copies bytes from a compiled-in pretend register file. Its write callback discards address, buffer and size and returns success.

The existing test-pattern switch is oriented toward registration/IDROM validation. The inspected patterns construct progressively valid/invalid IDROM and pin-descriptor states; the stock fixture does not expose a reusable PWMGen write-capture oracle.

## Consequence

A runtime IO04 host-path experiment would need at least two deliberate fixture extensions:

1. provide a valid fake board descriptor/pin map containing a PWMGen module so production `hm2_pwmgen_parse_md()` exports and registers the PWM instance;
2. replace or instrument `hm2_test_write()` so direct LLIO and/or TRAM writes are captured with address and payload for assertions.

That can be a legitimate **synthetic host-path** experiment because the production HostMot2 `hm2_write()` and `pwmgen.c` functions would execute. It would not test the actual FPGA PWM generator, waveform timing, daughtercard transfer function, network transport, watchdog electrical state or amplifier response.

## 1000-level decision

**PROMOTE.** Do not make IO04 graduation depend on building a mutable fake FPGA/write-capture model.

Reasoning:

- the 1000-level objective is the architectural HAL-command → host register/LLIO path;
- that path is directly source-confirmed and reconciles with current public documentation;
- the most safety-relevant ambiguity—zero command versus 50% centered duty versus physical zero output—is explicitly bounded and supported by source plus field evidence;
- creating the missing mutable descriptor/write-capture fixture is valuable advanced verification work but does not materially change the basic architecture;
- any such fixture must be labeled synthetic host verification, never hardware or safety evidence.

## Promoted experiment

Destination: **2000 / HIGH**.

Design requirements for the later experiment:

- pin exact LinuxCNC revision;
- add exactly one valid fake PWMGen instance through the normal descriptor parser;
- capture the production LLIO/TRAM write addresses/payloads;
- drive HAL state through normal component pins/params, not by calling private helpers directly;
- assert at minimum:
  - scale and ±1 clipping;
  - positive/negative command sign encoding;
  - `enable=false` normal-mode zero command;
  - `enable=false` offset-mode midpoint encoding;
  - PDM fixed-width versus PWM resolution behavior;
  - `output-type` mode encoding;
  - changed enable/frequency causing slow-path writes;
  - unchanged configuration not causing duplicate slow-path writes;
  - invalid output type repair;
  - `io_error` preventing cache promotion/requiring retry;
- keep scale=0/NaN/Inf as a separate adversarial case so undefined/implementation-sensitive numeric behavior cannot contaminate ordinary acceptance gates.

## Graduation impact

This promoted experiment does **not** block IO04 at 1000 level. A fresh AI can already trace and debug the host-side command path without inventing physical behavior, and the guide explicitly marks the points where stronger evidence is required.