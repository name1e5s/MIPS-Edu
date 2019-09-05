#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n25_sltu_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_SLTU(0x158f2b29, 0x421c0a42, 0x00000001)
    TEST_SLTU(0x60343bf8, 0xdd17b30a, 0x00000001)
    TEST_SLTU(0x2d5c3180, 0x14df4718, 0x00000000)
    TEST_SLTU(0x05ad2174, 0xf14dce78, 0x00000001)
    TEST_SLTU(0xe1bbfc33, 0x2f2086a0, 0x00000000)
    TEST_SLTU(0x4fe214d0, 0x2265b254, 0x00000000)
    TEST_SLTU(0xcea056ac, 0x13f6c0c0, 0x00000000)
    TEST_SLTU(0xd545aa5e, 0x5eb4fc1a, 0x00000000)
    TEST_SLTU(0xb80f0f3a, 0x5af242ba, 0x00000000)
    TEST_SLTU(0x076fc4db, 0x4fc59e2a, 0x00000001)
    TEST_SLTU(0x6271cbac, 0xe9406d5e, 0x00000001)
    TEST_SLTU(0xd7331578, 0x9d39d4f0, 0x00000000)
    TEST_SLTU(0x6689f1e8, 0x830549ec, 0x00000001)
    TEST_SLTU(0xdd0db690, 0xa4122620, 0x00000000)
    TEST_SLTU(0xebe83100, 0x48d9c13d, 0x00000000)
    TEST_SLTU(0x00000000, 0x52ef4485, 0x00000001)
    TEST_SLTU(0x00000000, 0xad19dd1c, 0x00000001)
    TEST_SLTU(0x00000000, 0xdc03b4c0, 0x00000001)
    TEST_SLTU(0x00000000, 0x2fa8986c, 0x00000001)
    TEST_SLTU(0x00000000, 0xed08ea47, 0x00000001)
    TEST_SLTU(0x00000000, 0x306392cc, 0x00000001)
    TEST_SLTU(0x00000000, 0xba46c85d, 0x00000001)
    TEST_SLTU(0x00000000, 0x059e2da8, 0x00000001)
    TEST_SLTU(0x00000000, 0x32f27784, 0x00000001)
    TEST_SLTU(0x00000000, 0x00000000, 0x00000000)
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
END(n25_sltu_test)
