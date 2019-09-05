#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n43_jalr_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_JALR(0x6e6b362a, 0x240baf26, 0x6e6b362a, 0x240baf26)
    TEST_JALR(0x5d0fcbc0, 0xdba3ac64, 0x5d0fcbc0, 0xdba3ac64)
    TEST_JALR(0xa832bb00, 0xf43fa620, 0xa832bb00, 0xf43fa620)
    TEST_JALR(0x1e2aa5ca, 0x4782fd22, 0x1e2aa5ca, 0x4782fd22)
    TEST_JALR(0x188e3538, 0x278b5208, 0x188e3538, 0x278b5208)
    TEST_JALR(0xe03fef90, 0xd294c6c0, 0xe03fef90, 0xd294c6c0)
    TEST_JALR(0xaa6a2f86, 0x574ea69d, 0xaa6a2f86, 0x574ea69d)
    TEST_JALR(0x6fe20051, 0xe6d286d2, 0x6fe20051, 0xe6d286d2)
    TEST_JALR(0xfb9cfd6d, 0x39ae4860, 0xfb9cfd6d, 0x39ae4860)
    TEST_JALR(0x138b8d70, 0xedd582e5, 0x138b8d70, 0xedd582e5)
    TEST_JALR(0xf1c91b75, 0xc4783b2e, 0xf1c91b75, 0xc4783b2e)
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
END(n43_jalr_test)
