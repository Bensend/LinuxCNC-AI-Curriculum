# S02 call flow — feedback transport and observability boundaries

Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`.

## Current-board-read path

`hm2_eth` builds a queued read transaction, increments `read_cnt`, asks the board to echo/confirm transaction counters, receives the aggregate response, then copies queued fields into their destination buffers. `hm2_eth_receive_queued_reads()` rejects short/missing responses and records soft communication errors. `record_soft_error()` drives `packet-error`, cumulative/error-level state and eventually low-level `io_error`; a successful checked transaction decrements the soft-error level.

The important S02 boundary is that this authenticates a checked **transport transaction**, not the physical origin of an encoder value transported in it.

## Encoder publication path

```text
physical motion
 -> encoder/mechanics/wiring
 -> HostMot2 encoder FPGA state
 -> hm2_eth current board transaction
 -> HostMot2 encoder driver position/count/velocity/quad-error HAL surfaces
 -> motion/controller feedback
```

A successful lower arrow cannot prove all arrows above it. In particular:

- current packet != new encoder edge;
- no packet error != encoder mechanically coupled;
- no quadrature error != universally valid encoder;
- two equal feedback values != independent sensors;
- following error within threshold != physical geometry authenticated.

## Watchdog distinction

The HostMot2 watchdog protects a different boundary. Official documentation states that after a bite the I/O pins are disconnected from module instances while internal modules such as encoders continue operating. Consequently internal feedback/module state may remain coherent even when physical output authority has changed. Watchdog, transport and sensor-integrity evidence must remain separate in later compound-fault work.

## S02 design consequence

The frozen experiment must retain both a deliberately synthetic physical-truth oracle and the reported feedback channels. The oracle is permitted only to prove observability limits in the laboratory. A production LinuxCNC design cannot silently assume that oracle exists; any equivalent physical-truth claim requires justified independent sensing/commissioning evidence.
