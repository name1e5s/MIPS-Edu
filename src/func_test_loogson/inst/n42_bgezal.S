#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n42_bgezal_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x0
###test inst
    TEST_BGEZAL(0x9ec9db66, 0x029aaf84, 0xb5a8cca0, 0x00000000, 0x00000000)
    TEST_BGEZAL(0x48f555d0, 0x288dbddc, 0xabcf87b8, 0x288dbddc, 0xabcf87b8)
    TEST_BGEZAL(0xe47b2aa0, 0xc6bf36e0, 0x1eb3e3a0, 0x00000000, 0x00000000)
    TEST_BGEZAL(0x5955ebd6, 0xa44467a3, 0xdbe004f7, 0xa44467a3, 0xdbe004f7)
    TEST_BGEZAL(0x3baa4ab0, 0x7998f600, 0xf047d898, 0x7998f600, 0xf047d898)
    TEST_BGEZAL(0xbff7aa00, 0x82bf9c2c, 0x68d44fa0, 0x00000000, 0x00000000)
    TEST_BGEZAL(0x68f6e51f, 0x629967a0, 0xa5936df4, 0x629967a0, 0xa5936df4)
    TEST_BGEZAL(0xf624bdb0, 0xaaa3de30, 0x7e6ddd50, 0x00000000, 0x00000000)
    TEST_BGEZAL(0x82f5a6f0, 0xb188d600, 0x206fa380, 0x00000000, 0x00000000)
    TEST_BGEZAL(0x00000000, 0x36a36650, 0x44fa7d50, 0x36a36650, 0x44fa7d50)
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
END(n42_bgezal_test)
