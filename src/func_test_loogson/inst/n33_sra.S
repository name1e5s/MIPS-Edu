#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n33_sra_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_SRA(0x7e0083f0, 0x00000009, 0x003f0041)
    TEST_SRA(0x13e680c0, 0x00000018, 0x00000013)
    TEST_SRA(0x6d7388ec, 0x00000010, 0x00006d73)
    TEST_SRA(0xc04efccc, 0x00000010, 0xffffc04e)
    TEST_SRA(0xd6c67200, 0x00000014, 0xfffffd6c)
    TEST_SRA(0x587d38e8, 0x00000014, 0x00000587)
    TEST_SRA(0xd7b1ed92, 0x00000004, 0xfd7b1ed9)
    TEST_SRA(0xab4b5c70, 0x0000001f, 0xffffffff)
    TEST_SRA(0x04d6db90, 0x00000002, 0x0135b6e4)
    TEST_SRA(0x683361dc, 0x00000010, 0x00006833)
    TEST_SRA(0x8c65a380, 0x00000001, 0xc632d1c0)
    TEST_SRA(0x4e8dbfa8, 0x00000012, 0x000013a3)
    TEST_SRA(0x55090962, 0x00000003, 0x0aa1212c)
    TEST_SRA(0x9bf8d806, 0x00000014, 0xfffff9bf)
    TEST_SRA(0x00000000, 0x0000001a, 0x00000000)
    TEST_SRA(0x00000000, 0x00000001, 0x00000000)
    TEST_SRA(0x00000000, 0x00000009, 0x00000000)
    TEST_SRA(0x00000000, 0x00000016, 0x00000000)
    TEST_SRA(0x00000000, 0x00000000, 0x00000000)
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
END(n33_sra_test)
