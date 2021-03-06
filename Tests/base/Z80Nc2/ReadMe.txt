Z80N instructions tests - core 2.00.xx
======================================

(this test is similar to Z80N test, but it exercises six new instructions introduced
in core 2.00.22+ updates)

Quick tests for new Z80N instructions - *NOT* checking full state of CPU after
instruction execution, but mostly trying at least to use all possible values and
check the main result of instruction.

Press "2" to switch on 14MHz turbo mode (if your emulator already supports it,
NextRegs 6 and 7 are required for turbo enabling+speed setting) (you may also
want to apply your own emulator "run as fast as possible" setting maybe).

Press "3" to select levels of "fullness" of tests (WIP - at this moment all tests
are only "full" - to be removed or finished).

To run particular test, hit the highlighted letter, or use "5" to run all tests.

At the end of line there will be status of finished tests, "ERR" marks some error
happened during test, "OK" means the instruction passed the test. (WIP - if levels
will be added, then "OK1" and "OK2" mean that test did pass, but there are 1 or 2
more levels of "fuller" tests available).

For tests with "ERR" result, by hitting the highlighted key, you can see "error log"
from particular test. Tests usually abort upon finding first problem, so log will
usually contain only that. All values in log are always hexadecimal, two digits
are used for 8 bit values, four digits for 16 bit values. The error logs are by
no means supposed to provide full debug info, it's expected you will inspect the
test code itself and investigate there (the log is just hint about detected issue).

For more details about how instructions are supposed to work you may want to also check:
http://devnext.referata.com/wiki/Extended_Z80_instruction_set

Details of possible errors (explaining the error log) per instruction:

 BRLC DE,B      ED  2C              DE = DE<<(B&15) | DE>>(16-B&15)
  - three values: B (8b), expected DE (16b), obtained DE (16b); The expected value may
  be "wrong" by -1 if BRLC did set CF=1 (BRLC should not affect flags).

 BSLA DE,B      ED  28              DE = DE<<(B&31)
  - three values: B (8b), expected DE (16b), obtained DE (16b); The expected value may
  be "wrong" by -1 if BSLA did set CF=1 (BSLA should not affect flags).

 BSRA DE,B      ED  29              DE = signed(DE)>>(B&31)
  - three values: B (8b), expected DE (16b), obtained DE (16b); The expected value may
  be "wrong" by -1 if BSRA did set CF=1 (BSRA should not affect flags).

 BSRF DE,B      ED  2B              DE = ~(unsigned(~DE)>>(B&31))
  - three values: B (8b), expected DE (16b), obtained DE (16b); The expected value may
  be "wrong" by -1 if BSRF did set CF=1 (BSRF should not affect flags).

 BSRL DE,B      ED  2A              DE = unsigned(DE)>>(B&31)
  - three values: B (8b), expected DE (16b), obtained DE (16b); The expected value may
  be "wrong" by -1 if BSRL did set CF=1 (BSRL should not affect flags).

 JP (C)         ED  98              PC = PC&$C000 + IN(C)<<6, PC is "next-instruction" aka "$+2"
  - four values (2x 8b + 2x 16b): expected IN (C) value (8b), value in A (should be equal
  to IN (C) if everything works as expected, or it may be complement of expected value if
  the CPU jumped into unexpected address, but reached some RET without changing A) (8b),
  expected target address of jump (16b), and I/O port used for test (should be $243B).
  The "JP (C)" in this 0..255 loop test is positioned at address $FFFD, jump targets are
  expected to be $C000 .. $FFC0 (growing by $40 = 1<<6), i.e. $C000 + $40*A.
  - message about area failure with 8b value as expected IN (C), and two 16b values for
  area start/end address (the "JP (C)" is positioned at area_start+2).
  - message only about PC not being advanced - when "JP (C)" at address $BFFF failed to
  jump to $C000 with "IN (C)" expected to produce 0. This jump should happen, because
  when target address is being combined from "current" PC and IN (C) value, the PC is
  already advanced by instruction fetcher, and points at address $C001.
