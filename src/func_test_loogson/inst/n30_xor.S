#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n30_xor_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_XOR(0x1773df80, 0xb5af51d2, 0xa2dc8e52)
    TEST_XOR(0xe6223550, 0x909c98da, 0x76bead8a)
    TEST_XOR(0xf5c8a598, 0x25fd0240, 0xd035a7d8)
    TEST_XOR(0x24b53f20, 0x14d3aae8, 0x306695c8)
    TEST_XOR(0x59451f38, 0xe8aaf42b, 0xb1efeb13)
    TEST_XOR(0xca5b17a0, 0xcec70d58, 0x049c1af8)
    TEST_XOR(0x00000000, 0x0c2acef6, 0x0c2acef6)
    TEST_XOR(0x00000000, 0xfced35ce, 0xfced35ce)
    TEST_XOR(0x00000000, 0xa3288960, 0xa3288960)
    TEST_XOR(0x00000000, 0xc67e946c, 0xc67e946c)
    TEST_XOR(0x00000000, 0xb6a8c6f0, 0xb6a8c6f0)
    TEST_XOR(0x00000000, 0x00000000, 0x00000000)
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
END(n30_xor_test)
