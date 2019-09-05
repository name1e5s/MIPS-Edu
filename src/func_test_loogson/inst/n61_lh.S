#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n61_lh_test)
    .set noreorder
    addiu s0, s0, 1
    li  s2, 0x0
###test inst
    TEST_LH(0x4932330c, 0x800d3810, 0x00008526, 0x00008524, 0x00004932)
    TEST_LH(0xbe4d9ac8, 0x800dac60, 0x00000092, 0x00000090, 0xffffbe4d)
    TEST_LH(0xbfa5bc80, 0x800d9ca0, 0x00002950, 0x00002950, 0xffffbc80)
    TEST_LH(0xb8008adc, 0x800d8000, 0x00000002, 0x00000000, 0xffffb800)
    TEST_LH(0x9368c576, 0x800d8000, 0x00000000, 0x00000000, 0xffffc576)
    TEST_LH(0xfba1ce40, 0x800d8000, 0x00000000, 0x00000000, 0xffffce40)
    TEST_LH(0x585c5e30, 0x800d8000, 0x00000000, 0x00000000, 0x00005e30)
    TEST_LH(0x9915f89c, 0x800d8000, 0x00000000, 0x00000000, 0xfffff89c)
    TEST_LH(0x8aefa220, 0x800d8000, 0x00000002, 0x00000000, 0xffff8aef)
    TEST_LH(0x42ccca62, 0x800d8000, 0x00000000, 0x00000000, 0xffffca62)
    TEST_LH(0x00000000, 0x800d8000, 0x00000000, 0x00000000, 0x00000000)
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
END(n61_lh_test)
