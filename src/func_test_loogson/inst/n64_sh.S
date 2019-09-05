#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n64_sh_test)
    .set noreorder
    addiu s0, s0, 1
    li  s2, 0x0
###test inst
    TEST_SH(0xe15f8848, 0x0e1a3600, 0x800d52a4, 0x00003ade, 0x00003adc, 0x36008848)
    TEST_SH(0xd187bd18, 0xa1cf708e, 0x800db7a0, 0x00000bf4, 0x00000bf4, 0xd187708e)
    TEST_SH(0xb5abcbf4, 0xee02bbc2, 0x800d6188, 0x00002e44, 0x00002e44, 0xb5abbbc2)
    TEST_SH(0x6b04bf60, 0x306960f0, 0x800d8d40, 0x00006580, 0x00006580, 0x6b0460f0)
    TEST_SH(0x02075c00, 0x3cabc304, 0x800d0000, 0x00000000, 0x00000000, 0x0207c304)
    TEST_SH(0x896c92c0, 0xf81c4fea, 0x800d0000, 0x00000000, 0x00000000, 0x896c4fea)
    TEST_SH(0xabc03313, 0x68403610, 0x800d0000, 0x00000002, 0x00000000, 0x36103313)
    TEST_SH(0x00000000, 0x00000000, 0x800d0000, 0x00000000, 0x00000000, 0x00000000)
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
END(n64_sh_test)
