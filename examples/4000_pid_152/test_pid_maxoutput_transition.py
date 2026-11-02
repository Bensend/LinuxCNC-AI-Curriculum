#!/usr/bin/env python3
"""PID-152: extract/compile real v2.9.10 calc_pid with fake HAL pins.

NOT RUN in the curriculum; execute only on qualified disconnected
[self-hosted, openpressbrake] compute. No LinuxCNC process or hardware.
"""
import argparse
import hashlib
from pathlib import Path
import subprocess
import tempfile

PINNED_BLOB = "2dc0b776be315b7c5cd71b980c3540dcaf1dd051"
FLOATS = ("command feedback error maxerror deadband error_i maxerror_i "
          "commandvds feedbackvds commandv feedbackv error_d maxerror_d "
          "cmd_d maxcmd_d cmd_dd maxcmd_dd cmd_ddd maxcmd_ddd bias pgain "
          "igain dgain ff0gain ff1gain ff2gain ff3gain maxoutput output "
          "saturated_s").split()
BITS = ("enable index_enable error_previous_target saturated saturated_count").split()


def extract(source):
    marker = "static void calc_pid(void *arg, long period)"
    start = source.index(marker)
    opening = source.index("{", start)
    depth = 0
    for index in range(opening, len(source)):
        if source[index] == "{":
            depth += 1
        elif source[index] == "}":
            depth -= 1
            if depth == 0:
                return source[start:index + 1]
    raise ValueError("Unbalanced calc_pid function")


def patched(body):
    before = ("\\t}\\n    } else {\\n"
              "\\t/* not enabled, force output to zero */")
    after = ("\\t} else {\\n"
             "\\t    pid->limit_state = 0.0;\\n"
             "\\t}\\n    } else {\\n"
             "\\t/* not enabled, force output to zero */")
    # Interpret escaped tabs/newlines so this is readable as a Python fixture.
    before = before.replace("\\t", "\t").replace("\\n", "\n")
    after = after.replace("\\t", "\t").replace("\\n", "\n")
    if body.count(before) != 1:
        raise ValueError("Candidate patch anchor is missing or ambiguous")
    return body.replace(before, after)


def source_file(body, expect_stale):
    fields = ("typedef struct {\n" +
              "  double *" + ", *".join(FLOATS) + ";\n" +
              "  int *" + ", *".join(BITS) + ";\n" +
              "  double prev_cmd, prev_fb, prev_error, limit_state;\n" +
              "  int prev_ie;\n} hal_pid_t;\n")
    declarations = "\n".join(
        "double v_%s = %s;" % (name, {"command": "1", "pgain": "2",
                                     "maxoutput": "1"}.get(name, "0"))
        for name in FLOATS)
    declarations += "\n" + "\n".join(
        "int v_%s = %s;" % (name, "1" if name == "enable" else "0")
        for name in BITS)
    assigns = ",\n".join("    .%s = &v_%s" % (name, name)
                            for name in FLOATS + BITS)
    main = """
static void near(const char *name, double actual, double expected) {
    if (fabs(actual - expected) > 1e-8) {
        fprintf(stderr, "%%s: got %%.12g, expected %%.12g\\n",
                name, actual, expected);
        exit(3);
    }
}
int main(void) {
%s
    hal_pid_t p = {
%s
    };
    calc_pid(&p, 1000000);
    near("A output", v_output, 1);
    near("A saturated", v_saturated, 1);
    v_maxoutput = 0;
    calc_pid(&p, 1000000);
    near("B unlimited output", v_output, 2);
    near("B stale saturated", v_saturated, %d);
    v_maxoutput = 3;
    calc_pid(&p, 1000000);
    near("C output", v_output, 2);
    near("C clear saturated", v_saturated, 0);
    v_maxoutput = 0;
    calc_pid(&p, 1000000);
    near("D zero-limit clean history", v_saturated, 0);

    v_enable = 0;
    calc_pid(&p, 1000000);
    near("G disabled output", v_output, 0);
    near("G disabled saturation", v_saturated, 0);
    v_enable = 1;
    v_igain = 1;
    v_maxoutput = 1;
    calc_pid(&p, 1000000);
    near("E finite-limit saturation", v_saturated, 1);
    double before = v_error_i;
    v_maxoutput = 0;
    calc_pid(&p, 1000000);
    near("E first zero-limit integral gated", v_error_i, before);
    calc_pid(&p, 1000000);
    near("F second zero-limit integral", v_error_i,
         before + (%d ? 0.0 : 0.001));
    near("F saturation", v_saturated, %d);
    puts("PID-152 extracted calc_pid oracle PASS");
    return 0;
}
""" % (declarations, assigns, expect_stale, expect_stale, expect_stale)
    return ("#include <stdio.h>\n#include <stdlib.h>\n"
            "#include <math.h>\n" + fields + "\n" + body +
            "\n" + main)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--cc", default="cc")
    args = parser.parse_args()
    raw = args.source.read_bytes()
    blob = hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()
    if blob != PINNED_BLOB:
        raise SystemExit("Refusing unpinned source blob: " + blob)
    original = extract(raw.decode("utf-8"))
    corrected = patched(original)
    with tempfile.TemporaryDirectory(prefix="pid152-") as directory:
        for name, body, stale in (("original", original, 1),
                                  ("corrected", corrected, 0)):
            src = Path(directory) / (name + ".c")
            exe = Path(directory) / name
            src.write_text(source_file(body, stale))
            subprocess.run([args.cc, "-std=c11", "-O0", "-Wall", "-Wextra",
                            str(src), "-lm", "-o", str(exe)], check=True)
            subprocess.run([str(exe)], check=True)
    print("PID-152 original and candidate: all frozen cases passed")


if __name__ == "__main__":
    main()
