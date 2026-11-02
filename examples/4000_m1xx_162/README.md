# M1XX-162 — no-motion external M-code fixture

**Evidence:** SOURCE-PREDICTED / NOT RUN. Companion [audit](../../research/4400_LINUXCNC_M1XX_162_USER_MCODE_TASK_ARGV_PRECISION_ABORT_SOURCE_AUDIT_2026-11-02.md) and [commissioning guide](../../guides/3100-3400-3600-4000-linuxcnc-m1xx-task-dispatch-commissioning-2026-11-02.md).

`M150` is a Python executable with **no HAL, motor, GPIO, network or machine-control calls**. It prints PID and the raw command-line P/Q strings before converting them to numbers.

- `Q0`: exit 0 immediately.
- `Q2`: bounded 3-second sleep then exit 0 (Task wait ordering).
- `Q7`: exit 7 deliberately (Task error).
- `Q9`: bounded 8-second sleep for a controlled manual abort; a SIGINT handler reports receipt and exits 130.

Copy the executable to a no-whitespace directory referenced by `[RS274NGC]USER_M_PATH` in an **isolated** LinuxCNC simulation INI; `chmod +x M150` and restart Task. No real machine should be attached. `test_m150.ngc` contains only M150 and M2, no motion. For error and abort tests use individual MDI commands so an expected error does not contaminate the baseline.

All expected observations are source predictions. Neither fixture has been run. Avoid using this fixture as a physical-device acknowledgment or personnel-safety test.
