#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n34_srav_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_SRAV(0x3e594300, 0x00000003, 0x07cb2860)
    TEST_SRAV(0x171e0116, 0x00000004, 0x0171e011)
    TEST_SRAV(0x6926a1a0, 0x00000000, 0x6926a1a0)
    TEST_SRAV(0x6f4ecb50, 0x00000000, 0x6f4ecb50)
    TEST_SRAV(0xe15c3cca, 0x00000000, 0xe15c3cca)
    TEST_SRAV(0x5f7c33a2, 0x00000000, 0x5f7c33a2)
    TEST_SRAV(0xa267ac08, 0x00000000, 0xa267ac08)
    TEST_SRAV(0x8b001228, 0x00000000, 0x8b001228)
    TEST_SRAV(0x53f7d6b8, 0x00000000, 0x53f7d6b8)
    TEST_SRAV(0xe85d5600, 0x00000000, 0xe85d5600)
    TEST_SRAV(0xf1ecfb76, 0x00000000, 0xf1ecfb76)
    TEST_SRAV(0x0fc9ea7e, 0x00000000, 0x0fc9ea7e)
    TEST_SRAV(0xcee83180, 0x00000000, 0xcee83180)
    TEST_SRAV(0x00000000, 0x00000019, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000010, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000012, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000011, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000014, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000012, 0x00000000)
    TEST_SRAV(0x00000000, 0x00000000, 0x00000000)
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
END(n34_srav_test)
