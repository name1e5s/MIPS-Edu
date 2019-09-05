#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n41_bltzal_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_BLTZAL(0xc564aaee, 0xf1026890, 0x39dd5800, 0xf1026890, 0x39dd5800)
    TEST_BLTZAL(0x655e408b, 0x6c41162c, 0x8d5cd86f, 0x00000000, 0x00000000)
    TEST_BLTZAL(0xd941dbc8, 0xe6b2af00, 0x4c80b4b6, 0xe6b2af00, 0x4c80b4b6)
    TEST_BLTZAL(0x18c1552a, 0x35163822, 0x34ffade0, 0x00000000, 0x00000000)
    TEST_BLTZAL(0xa80025a1, 0xe079deb3, 0x774bba9e, 0xe079deb3, 0x774bba9e)
    TEST_BLTZAL(0x8ff9842b, 0x978af84a, 0xd770ef60, 0x978af84a, 0xd770ef60)
    TEST_BLTZAL(0x663da924, 0xf95f2930, 0x4654a65c, 0x00000000, 0x00000000)
    TEST_BLTZAL(0xd97064ee, 0xb95ffbe8, 0x619a80f4, 0xb95ffbe8, 0x619a80f4)
    TEST_BLTZAL(0xa199561e, 0x92b64a0c, 0xe8669a08, 0x92b64a0c, 0xe8669a08)
    TEST_BLTZAL(0x73ee8202, 0xd7a56490, 0x79518f38, 0x00000000, 0x00000000)
    TEST_BLTZAL(0x00000000, 0xafbac4d4, 0xf06fb6ae, 0x00000000, 0x00000000)
###detect exception
    bne s2, zero, inst_error
    nop
###score ++
    addiu s3, s3, 1
###output (s0<<24)|s3
inst_error:  
    sll t1, s0, 24
    or t0, t1, s3 
    sw t0, 0(s1)
    jr ra
    nop
END(n41_bltzal_test)
