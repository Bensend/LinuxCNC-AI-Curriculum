#!/usr/bin/env python3
"""Extract and test the real upstream EL7041 handle_modparams() using fake SDOs.

No EtherCAT or LinuxCNC runtime is loaded. Execute only on a qualified,
physically disconnected [self-hosted, openpressbrake] test host.
"""
import argparse
import pathlib
import re
import subprocess
import tempfile

def extract_function(source):
    needle = "static int handle_modparams("
    start = source.find(needle)
    if start < 0:
        raise ValueError("handle_modparams not found")
    opening = source.find("{", start)
    if opening < 0:
        raise ValueError("function opening brace not found")
    depth = 0
    for index in range(opening, len(source)):
        if source[index] == "{":
            depth += 1
        elif source[index] == "}":
            depth -= 1
            if depth == 0:
                return source[start:index + 1]
    raise ValueError("unterminated function")

def build_fixture(function):
    names = sorted(set(re.findall(r"case (MODPARAM_[A-Z_]+):", function)))
    enums = ",\n".join(f"  {name} = {i+1}" for i, name in enumerate(names))
    header = r"""
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
typedef struct { const char *name; } lcec_master_t;
typedef union { uint32_t u32; double flt; unsigned char bit; } mod_value_t;
typedef struct { int id; mod_value_t value; } lcec_slave_modparam_t;
typedef struct {
    lcec_master_t *master;
    lcec_slave_modparam_t *modparams;
    const char *name;
} lcec_slave_t;
#define RTAPI_MSG_ERR 1
#define LCEC_MSG_PFX ""
#define rtapi_print_msg(...) ((void)0)
static int calls = 0;
static int fail_at = 0;
static int lcec_write_sdo16(lcec_slave_t *s, uint16_t index, uint8_t sub, uint16_t value) {
    (void)s;
    printf("W,%04x,%02x,%u\n", (unsigned)index, (unsigned)sub, (unsigned)value);
    return (++calls == fail_at) ? -1 : 0;
}
static int lcec_write_sdo8(lcec_slave_t *s, uint16_t index, uint8_t sub, uint8_t value) {
    (void)s;
    printf("W,%04x,%02x,%u\n", (unsigned)index, (unsigned)sub, (unsigned)value);
    return (++calls == fail_at) ? -1 : 0;
}
"""
    footer = r"""
int main(int argc, char **argv) {
    if (argc != 5) return 2;
    lcec_master_t master = {"fake"};
    lcec_slave_modparam_t params[2] = {{0}, {0}};
    params[0].id = atoi(argv[1]);
    params[1].id = -1;
    if (argv[2][0] == 'f') params[0].value.flt = strtod(argv[3], NULL);
    else params[0].value.u32 = (uint32_t)strtoul(argv[3], NULL, 10);
    fail_at = atoi(argv[4]);
    lcec_slave_t slave = {&master, params, "fake"};
    printf("R,%d\n", handle_modparams(&slave));
    return 0;
}
"""
    return header + "\nenum {\n" + enums + "\n};\n" + function + "\n" + footer, dict((n, i+1) for i, n in enumerate(names))

def check_pdo_registration(source, patched):
    expected = {
        "underflow": ("count_underflow_pdo_os", "count_underflow_pdo_bp" if patched else "count_overflow_pdo_bp"),
        "overflow": ("count_overflow_pdo_os", "count_overflow_pdo_bp" if patched else "count_underflow_pdo_bp"),
    }
    for label, (os, bp) in expected.items():
        sub = "0x04" if label == "underflow" else "0x05"
        pattern = rf"lcec_pdo_init\(s,\s*0x6000,\s*{sub},\s*&hd->{os},\s*&hd->{bp}\);"
        if not re.search(pattern, source):
            raise AssertionError(f"{label} registration differs from expected source expression")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, type=pathlib.Path)
    parser.add_argument("--expect", choices=("original", "patched"), required=True)
    args = parser.parse_args()
    source = args.source.read_text(encoding="utf-8")
    patched = args.expect == "patched"
    check_pdo_registration(source, patched)
    function = extract_function(source)
    code, ids = build_fixture(function)
    cases = [
        ("MODPARAM_MAX_CURRENT", "f", "2.5", [("8010", "01", 2500)]),
        ("MODPARAM_MOTOR_FULLSTEPS", "u", "200", [("8010", x, 200) for x in (["06"] if patched else ["06", "07", "09", "10", "11"])]),
        ("MODPARAM_ENCODER_INCREMENTS", "u", "4000", [("8010", x, 4000) for x in (["07"] if patched else ["07", "09", "10", "11"])]),
        ("MODPARAM_START_VELOCITY", "u", "50", [("8010", x, 50) for x in (["09"] if patched else ["09", "10", "11"])]),
        ("MODPARAM_DRIVE_ON_DELAY", "u", "100", [("8010", x, 100) for x in (["10"] if patched else ["10", "11"])]),
        ("MODPARAM_DRIVE_OFF_DELAY", "u", "150", [("8010", "11", 150)]),
    ]
    if patched:
        cases.append(("MODPARAM_MOTOR_EMF", "f", "1.0", [("8010", "05", 1000)]))
    with tempfile.TemporaryDirectory(prefix="el7041-fake-sdo-") as tmp:
        cfile = pathlib.Path(tmp) / "fixture.c"
        exe = pathlib.Path(tmp) / "fixture"
        cfile.write_text(code, encoding="utf-8")
        subprocess.run(["cc", "-std=c99", "-Wall", "-Wextra", "-Wno-unused-variable",
                        str(cfile), "-o", str(exe)], check=True)
        for name, kind, value, expected in cases:
            run = subprocess.run([str(exe), str(ids[name]), kind, value, "0"],
                                 check=True, text=True, capture_output=True)
            rows = run.stdout.splitlines()
            writes = [tuple((x.split(",")[1], x.split(",")[2], int(x.split(",")[3])))
                      for x in rows if x.startswith("W,")]
            assert writes == expected, (name, writes, expected)
            assert rows[-1] == "R,0", (name, rows)
            print(f"PASS {name}: {len(writes)} write(s)")
        # The first SDO failure must terminate the original function immediately.
        run = subprocess.run([str(exe), str(ids["MODPARAM_MOTOR_FULLSTEPS"]), "u", "200", "1"],
                             check=True, text=True, capture_output=True)
        assert run.stdout.splitlines() == ["W,8010,06,200", "R,-1"], run.stdout
        print("PASS first-write error propagation")
    print("PASS PDO registration expression for", args.expect)
    print("All fake-SDO source-function cases passed; NOT a hardware/driver integration test.")

if __name__ == "__main__":
    main()
