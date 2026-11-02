#!/usr/bin/env python3
"""Review-only truth-table for LinuxCNC tooldata_db_getall FINI predicate.

This models *only* the C string condition. It does not execute LinuxCNC,
read_reply, a DB_PROGRAM, or any hardware. Not an upstream runtime oracle.
Pinned source: LinuxCNC development 67437d8865e431a9a33f74cee912dbf891d3b4c5.
"""
import unittest


def original_strstr(reply: str) -> bool:
    return "FINI" in reply


def naive_strcmp(reply: str) -> bool:
    return reply == "FINI"


def proposed_token(reply: str) -> bool:
    return reply.startswith("FINI") and (
        len(reply) == 4 or reply[4] in (" ", "\t", "\r")
    )


class FiniTokenReview(unittest.TestCase):
    def test_protocol_controls(self):
        # Bare sentinel is documented, annotated sentinel is sent by
        # LinuxCNC's own lib/python/tooldb.py::get_cmd.
        for reply in ("FINI", "FINI (get_cmd)", "FINI\t(get_cmd)"):
            with self.subTest(reply=reply):
                self.assertTrue(proposed_token(reply))
        self.assertFalse(naive_strcmp("FINI (get_cmd)"))

    def test_tool_comments_and_false_sentinels(self):
        for reply in (
            "T1 P1 Z0 ; FINISHED_SETUP",
            "T2 P2 Z1 ; FINI",
            "XFINI",
            "FINISH",
            "FINIsh",
        ):
            with self.subTest(reply=reply):
                self.assertFalse(proposed_token(reply))
        self.assertTrue(original_strstr("T1 P1 Z0 ; FINISHED_SETUP"))

    def test_not_a_framing_or_transaction_test(self):
        # Multiple protocol records in one read() remain unresolved.
        # This test intentionally does not assert a parser outcome.
        self.assertTrue(proposed_token("FINI (get_cmd)"))


if __name__ == "__main__":
    unittest.main()
