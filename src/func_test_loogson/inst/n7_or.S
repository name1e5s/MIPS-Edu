#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n7_or_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_OR(0x50e41484, 0xad35ea94, 0xfdf5fe94)
    TEST_OR(0xbbbfafe4, 0xc8e94400, 0xfbffefe4)
    TEST_OR(0xf293f134, 0xa7cc798a, 0xf7dff9be)
    TEST_OR(0xfb4eee5e, 0x66968a90, 0xffdeeede)
    TEST_OR(0x3f9d07d8, 0x00000000, 0x3f9d07d8)
    TEST_OR(0xdc25bfc0, 0x00000000, 0xdc25bfc0)
    TEST_OR(0xe3cf2eac, 0x00000000, 0xe3cf2eac)
    TEST_OR(0x00000000, 0x9ba86780, 0x9ba86780)
    TEST_OR(0x00000000, 0x3b31cb30, 0x3b31cb30)
    TEST_OR(0x00000000, 0x0d072a80, 0x0d072a80)
    TEST_OR(0x00000000, 0xf561aaf4, 0xf561aaf4)
    TEST_OR(0x00000000, 0xd11246d0, 0xd11246d0)
    TEST_OR(0x00000000, 0xcd5a89a0, 0xcd5a89a0)
    TEST_OR(0x00000000, 0x040b7cd3, 0x040b7cd3)
    TEST_OR(0x00000000, 0xe6c3a3a0, 0xe6c3a3a0)
    TEST_OR(0x00000000, 0xa4cfec40, 0xa4cfec40)
    TEST_OR(0x00000000, 0x70b955fc, 0x70b955fc)
    TEST_OR(0x00000000, 0x9548afc8, 0x9548afc8)
    TEST_OR(0x00000000, 0x8ad8c75c, 0x8ad8c75c)
    TEST_OR(0x00000000, 0xc82df286, 0xc82df286)
    TEST_OR(0x00000000, 0x00000000, 0x00000000)
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
END(n7_or_test)
