#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n63_sb_test)
    .set noreorder
    addiu s0, s0, 1
    li  s2, 0x0
###test inst
    TEST_SB(0x194331ca, 0x47657e06, 0x800d5068, 0x00006868, 0x00006868, 0x19433106)
    TEST_SB(0x9efafca8, 0x25474bf0, 0x800d9f20, 0x00003662, 0x00003660, 0x9ef0fca8)
    TEST_SB(0x9648ec44, 0x25165c46, 0x800d94a4, 0x000001fc, 0x000001fc, 0x9648ec46)
    TEST_SB(0x5ff78063, 0xb3be48f8, 0x800d8000, 0x00000003, 0x00000000, 0xf8f78063)
    TEST_SB(0x857c8744, 0xbd046514, 0x800d8000, 0x00000000, 0x00000000, 0x857c8714)
    TEST_SB(0x387fdade, 0x542f67c0, 0x800d8000, 0x00000001, 0x00000000, 0x387fc0de)
    TEST_SB(0xf96b1db0, 0xc78fac20, 0x800d8000, 0x00000001, 0x00000000, 0xf96b20b0)
    TEST_SB(0xda28716c, 0x6e6d40e0, 0x800d8000, 0x00000000, 0x00000000, 0xda2871e0)
    TEST_SB(0x00000000, 0x00000000, 0x800d8000, 0x00000000, 0x00000000, 0x00000000)
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
END(n63_sb_test)
