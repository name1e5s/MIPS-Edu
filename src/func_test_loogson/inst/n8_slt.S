#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n8_slt_test)
    .set noreorder
    addiu s0, s0 ,1
    lui  s2, 0x0
###test inst
    TEST_SLT(0x7245316a, 0x783506f0, 0x00000001)
    TEST_SLT(0xf93a207e, 0x912ed208, 0x00000000)
    TEST_SLT(0x47974516, 0xb8fd4d1c, 0x00000000)
    TEST_SLT(0x3892fe20, 0xc03d15f0, 0x00000000)
    TEST_SLT(0x00000000, 0xef17ce60, 0x00000000)
    TEST_SLT(0x00000000, 0x36d43eb0, 0x00000001)
    TEST_SLT(0x00000000, 0x1eaac5e3, 0x00000001)
    TEST_SLT(0x00000000, 0xb566662b, 0x00000000)
    TEST_SLT(0x00000000, 0x00000000, 0x00000000)
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
END(n8_slt_test)
