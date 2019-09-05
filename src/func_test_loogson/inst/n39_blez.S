#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n39_blez_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_BLEZ(0x95b9206f, 0x6ad0a0b8, 0x8f08db03, 0x6ad0a0b8, 0x8f08db03)
    TEST_BLEZ(0x2c09b044, 0xc7826200, 0x13ea2762, 0x00000000, 0x00000000)
    TEST_BLEZ(0x095b7ae8, 0xa07a4a41, 0x56ac95c0, 0x00000000, 0x00000000)
    TEST_BLEZ(0xce67bc51, 0x2f1cd2c0, 0x00ba8e99, 0x2f1cd2c0, 0x00ba8e99)
    TEST_BLEZ(0x2a69b9f8, 0x50fdd280, 0x81eb6d5e, 0x00000000, 0x00000000)
    TEST_BLEZ(0x4a89b5b0, 0xd9579e00, 0x59631c54, 0x00000000, 0x00000000)
    TEST_BLEZ(0xb65d8ec0, 0x8c562016, 0xe0277158, 0x8c562016, 0xe0277158)
    TEST_BLEZ(0x24873e20, 0x404b79a8, 0x074de3ca, 0x00000000, 0x00000000)
    TEST_BLEZ(0x00000000, 0xbb9734a0, 0xff0af084, 0xbb9734a0, 0xff0af084)
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
END(n39_blez_test)
