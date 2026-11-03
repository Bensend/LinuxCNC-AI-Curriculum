#!/usr/bin/env python3
"""Source-derived MODEL ONLY for LinuxCNC hm2_modbus error paths.

NOT a LinuxCNC test; NOT run in this research session.
The source parser's bad_byte_count path returns 0 after set_error
in v2.9.10 and pinned development; the proposed review patch returns -1.
"""
from dataclasses import dataclass

MAX_ERRORS = 5
EBADE = 52
ERANGE = 34

@dataclass
class Command:
    private_errors: int = 0
    hal_errors: int = 0
    disabled: bool = False
    error_code: int = 0
    instance_fault: bool = False

    def set_error(self, code: int) -> None:
        self.private_errors += 1
        self.hal_errors = self.private_errors
        if self.private_errors >= MAX_ERRORS or self.disabled:
            self.disabled = True
            self.error_code = code

    def handle_reply(self, kind: str, patched: bool = False) -> None:
        """One handled response for a normal command, excluding init commands."""
        if kind == "valid":
            parser_return = 0
        elif kind == "bad_crc":
            self.set_error(EBADE)
            parser_return = -1
        elif kind == "bad_byte_count":
            self.set_error(ERANGE)
            # The old code breaks from switch and returns 0.
            parser_return = -1 if patched else 0
        else:
            raise ValueError(kind)

        if parser_return >= 0:
            self.private_errors = 0
            if patched:
                self.hal_errors = 0
        # STATE_HANDLE_DATA clears instance fault after a handled frame.
        self.instance_fault = False


def check() -> None:
    old = Command()
    new = Command()
    for state, patched in ((old, False), (new, True)):
        state.handle_reply("bad_crc", patched)
        state.handle_reply("bad_crc", patched)
        assert (state.private_errors, state.hal_errors) == (2, 2)
        state.handle_reply("valid", patched)
        assert state.private_errors == 0
        assert state.hal_errors == (0 if patched else 2)

    for kind in ("bad_crc", "bad_byte_count"):
        old, new = Command(), Command()
        for _ in range(5):
            old.handle_reply(kind, False)
            new.handle_reply(kind, True)
        assert new.disabled and new.private_errors == 5
        if kind == "bad_crc":
            assert old.disabled and old.private_errors == 5
            assert old.error_code == EBADE
        else:
            assert not old.disabled
            assert (old.private_errors, old.hal_errors) == (0, 1)
            assert new.error_code == ERANGE
        assert old.instance_fault is False
    print("MODEL assertions only: A-D expected transitions satisfied")


if __name__ == "__main__":
    check()
