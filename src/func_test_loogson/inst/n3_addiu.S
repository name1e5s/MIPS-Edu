#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n3_addiu_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_ADDIU(0xfb263d10, 0x0000ec96, 0xfb2629a6)
    TEST_ADDIU(0x7ec10538, 0x00000996, 0x7ec10ece)
    TEST_ADDIU(0x0e505a00, 0x0000b718, 0x0e501118)
    TEST_ADDIU(0xa522b9d7, 0x0000c784, 0xa522815b)
    TEST_ADDIU(0xfa5cb710, 0x00000000, 0xfa5cb710)
    TEST_ADDIU(0x394e5640, 0x00000000, 0x394e5640)
    TEST_ADDIU(0x49ceac94, 0x00000000, 0x49ceac94)
    TEST_ADDIU(0x23ae136b, 0x00000000, 0x23ae136b)
    TEST_ADDIU(0xf650e782, 0x00000000, 0xf650e782)
    TEST_ADDIU(0x00000000, 0x000004a0, 0x000004a0)
    TEST_ADDIU(0x00000000, 0x0000d6d9, 0xffffd6d9)
    TEST_ADDIU(0x00000000, 0x0000cdc8, 0xffffcdc8)
    TEST_ADDIU(0x00000000, 0x00000000, 0x00000000)
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
END(n3_addiu_test)
