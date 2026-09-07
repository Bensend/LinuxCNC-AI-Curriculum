# S03-013 — Second-run harness correction

Status: **HARNESS INVALID / corrected and rerun**  
Second failed workflow: `34100737637`  
Second source commit: `c754f19ffce37b01dbec8f9aeb71c8c4e576c90b`  
Third source commit: `0d6264c3b2e172d7e515baeec48e224078f901ce`  
Third workflow: `34101023503`

## What the second run established

The second run compiled the pinned tree with the new HAL u32 test pins, but exited before printing any Gate A runtime state. The source audit found the harness defect before treating the red workflow as S03 evidence.

`hm2_register()` performs initialization-time module force-writes, including `hm2_ioport_force_write()`. The test LLIO write callback in the second harness dereferenced `s03_write_count` and related pin-storage pointers whenever test pattern 15 was active, but those test pins were allocated only *after* `hm2_register()` returned. Therefore an initialization-time LLIO write could dereference NULL test storage before Gate A.

This is a harness lifecycle/ordering error, not a failure of the stale-state hypothesis. The run remains **HARNESS INVALID**.

## Correction

The third harness allocates all test-only HAL pin storage after the LLIO name/callback setup but **before** calling `hm2_register()`. Thus both registration-time reads/writes and later realtime LLIO callbacks see valid storage.

The experiment contract remains unchanged:

- successful HostMot2 registration and fresh baseline read/write are mandatory Gate A;
- only then may persistent `io_error` be injected;
- stale publication and zero LLIO-write advancement remain Gates B/C;
- clearing `io_error` must restore fresh publication and LLIO write activity for Gate D;
- no Ethernet, FPGA, drive, actuator, or safety claim is inferred.

## Next checkpoint

Inspect workflow `34101023503` and its own artifact/exit code. A red workflow is not enough to classify the hypothesis; locate the exact gate or harness failure. Only a valid Gate A allows interpretation of B-D.