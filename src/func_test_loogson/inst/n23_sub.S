#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n23_sub_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_SUB(0x14ffb0e6, 0x088cb248, 0x0c72fe9e)
    TEST_SUB(0x5c685e22, 0x5deb1abc, 0xfe7d4366)
    TEST_SUB(0xb2a289a4, 0xfa6908da, 0xb83980ca)
    TEST_SUB(0xb112c8b8, 0x0767b30a, 0xa9ab15ae)
    TEST_SUB(0x51b2a7a0, 0x2e6f8c10, 0x23431b90)
    TEST_SUB(0x1e993bf0, 0x6a934e28, 0xb405edc8)
    TEST_SUB(0xe72eb946, 0xc6869c05, 0x20a81d41)
    TEST_SUB(0x0c868772, 0x1e06ed58, 0xee7f9a1a)
    TEST_SUB(0xb350d720, 0x32ca1a2b, 0x8086bcf5)
    TEST_SUB(0x84596270, 0xeff92398, 0x94603ed8)
    TEST_SUB(0xf2fe5bbc, 0x46277938, 0xacd6e284)
    TEST_SUB(0x6ab17b4b, 0x1a7adbf8, 0x50369f53)
    TEST_SUB(0x00000000, 0x827bd480, 0x7d842b80)
    TEST_SUB(0x00000000, 0xcea726f0, 0x3158d910)
    TEST_SUB(0x00000000, 0xca0fd400, 0x35f02c00)
    TEST_SUB(0x00000000, 0xd2e54c39, 0x2d1ab3c7)
    TEST_SUB(0x00000000, 0x00000000, 0x00000000)
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
END(n23_sub_test)
