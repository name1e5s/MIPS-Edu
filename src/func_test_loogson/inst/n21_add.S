#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n21_add_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_ADD(0x0480ff04, 0x40933204, 0x45143108)
    TEST_ADD(0x2a19dd40, 0xa87971e0, 0xd2934f20)
    TEST_ADD(0x80613360, 0x42adf91d, 0xc30f2c7d)
    TEST_ADD(0xe86dce88, 0xeef51a30, 0xd762e8b8)
    TEST_ADD(0x1a92a5a0, 0xd1eac31b, 0xec7d68bb)
    TEST_ADD(0xdec0f040, 0x59bc3412, 0x387d2452)
    TEST_ADD(0xe4b62124, 0x6f1772b8, 0x53cd93dc)
    TEST_ADD(0x8e768b29, 0x4edde040, 0xdd546b69)
    TEST_ADD(0xbae5f8ae, 0x690a1ae4, 0x23f01392)
    TEST_ADD(0x31964010, 0xae2c7275, 0xdfc2b285)
    TEST_ADD(0x195cf434, 0x8061cc2c, 0x99bec060)
    TEST_ADD(0xa6c1a140, 0x33fa4568, 0xdabbe6a8)
    TEST_ADD(0x08d7e000, 0x2b221251, 0x33f9f251)
    TEST_ADD(0xc48f1392, 0x2d9d31b9, 0xf22c454b)
    TEST_ADD(0xbccd54c8, 0x0a2c3b14, 0xc6f98fdc)
    TEST_ADD(0x95f0c7b0, 0x00000000, 0x95f0c7b0)
    TEST_ADD(0x00000000, 0x1fc60cf8, 0x1fc60cf8)
    TEST_ADD(0x00000000, 0x0f1b4000, 0x0f1b4000)
    TEST_ADD(0x00000000, 0x201cdee8, 0x201cdee8)
    TEST_ADD(0x00000000, 0x31c14954, 0x31c14954)
    TEST_ADD(0x00000000, 0x6e701f70, 0x6e701f70)
    TEST_ADD(0x00000000, 0x00000000, 0x00000000)
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
END(n21_add_test)
