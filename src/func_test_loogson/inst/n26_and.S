#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n26_and_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_AND(0x5c95951a, 0xca00c414, 0x48008410)
    TEST_AND(0x9ba8ba70, 0xe99fce38, 0x89888a30)
    TEST_AND(0xd30319e0, 0x0ba4cff6, 0x030009e0)
    TEST_AND(0xce6912e8, 0x6676b20e, 0x46601208)
    TEST_AND(0xdcc2f196, 0x8e552cd2, 0x8c402092)
    TEST_AND(0xdd99d4f8, 0xb7642ec7, 0x950004c0)
    TEST_AND(0x4715c100, 0x317d5cb6, 0x01154000)
    TEST_AND(0x1de7fe00, 0x2aafb760, 0x08a7b600)
    TEST_AND(0x41f65000, 0xea64e6e0, 0x40644000)
    TEST_AND(0x9f194d46, 0xd6654fb0, 0x96014d00)
    TEST_AND(0x6fcc3b81, 0x9463a0fa, 0x04402080)
    TEST_AND(0x388c01d8, 0xf9ca64ce, 0x388800c8)
    TEST_AND(0x72051d89, 0xfeda32e1, 0x72001081)
    TEST_AND(0x8487a910, 0x17c32ee7, 0x04832800)
    TEST_AND(0xeaa6b3d0, 0x00000000, 0x00000000)
    TEST_AND(0x0859169c, 0x00000000, 0x00000000)
    TEST_AND(0x05b77720, 0x00000000, 0x00000000)
    TEST_AND(0xcfee3094, 0x00000000, 0x00000000)
    TEST_AND(0xb2ee69a4, 0x00000000, 0x00000000)
    TEST_AND(0x9f73ccec, 0x00000000, 0x00000000)
    TEST_AND(0x8709e13e, 0x00000000, 0x00000000)
    TEST_AND(0x00000000, 0x78d0a5d8, 0x00000000)
    TEST_AND(0x00000000, 0xcb841e1e, 0x00000000)
    TEST_AND(0x00000000, 0x5c256710, 0x00000000)
    TEST_AND(0x00000000, 0xdc48ef02, 0x00000000)
    TEST_AND(0x00000000, 0x23b45e2c, 0x00000000)
    TEST_AND(0x00000000, 0x14b92b6c, 0x00000000)
    TEST_AND(0x00000000, 0x00000000, 0x00000000)
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
END(n26_and_test)
