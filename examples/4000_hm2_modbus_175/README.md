# HM2-MODBUS-175 — disconnected error-accounting controls (review only)

This directory is **not** a machine config, a runtime regression result, or an authorization to transmit commands to a Modbus device. It holds a development-source-context-checked review patch and a pure-Python state model of the audited branches. Neither was executed in this session.

## Exact source

LinuxCNC development 67437d8865e431a9a33f74cee912dbf891d3b4c5, src/hal/drivers/mesa-hostmot2/hm2_modbus.c. The patch targets that revision only. Stable v2.9.10 has the same relevant mechanism but different HAL-access syntax; **do not apply the development patch to stable without porting and checking**.

## Controls

A. CRC invalid x2 then valid: old private count resets on valid but HAL errors remains 2. Review patch publishes 0.
B. CRC invalid x5: old and patched private count reach 5 and command disables; instance fault need not be true after a handled frame.
C. CRC valid + wrong register byte count x5: old parser returns 0 and resets private count after each error, so disabled never asserts. Patch returns -1 and permits accumulation to 5.
D. CRC valid + wrong coil/input byte count x5: same mismatch and repair as C.
E. Timeout then successful reply: inspect instance fault independently from per-command errors and command disable; not modeled by this minimal Python model.
F. Suspend=true then scale initialization and suspend=false: inspect the official 7i96S HAL/INI/MBCCS before any disconnected runtime experiment.

## Model only

    python3 model_oracle.py

This command is a future **pure-Python illustrative state-machine model**, not a LinuxCNC test. It asserts predicted current-vs-patched states for A–D. It does not link LinuxCNC, build hm2_modbus, send PktUART traffic, or validate actual HAL pin timing. If executed later, record command, environment, output and status separately; do not promote its pass to TEST-CONFIRMED LinuxCNC.

## Real runtime oracle (future, isolated)

Use a mock PktUART implementation or an independently verified physically disconnected self-hosted runner, after a frozen plan. Supply deterministic Modbus RTU frames with correct slave/function and recomputed CRC for wrong-byte-count cases; capture per-servo-cycle state. A CRC mismatch and a CRC-valid byte-count mismatch **must not be conflated**. Test original and patched builds separately and compare error-count/disabled/instance-fault transitions. Do not use an actual machine spindle, press-brake hydraulic valve, torch, router, or lathe for injection.

The existing MOTION-144 isolation prerequisite remains the first executable priority; this is a subsequent optional test once qualified. No GitHub-hosted Actions runners.

G. Timeout: source queues reset/enters RESET_WAIT but immediately switches to START; measure the next send cycle rather than assuming 25 ms.
H. RX framing/parity flag with in-range size versus oversize frame: source overwrites RESET_WAIT with HANDLE_DATA in the former path but preserves it with break in the latter. Both remain NOT RUN and require a disconnected PktUART oracle.
