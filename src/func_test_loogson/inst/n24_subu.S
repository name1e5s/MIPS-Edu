#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n24_subu_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00
###test inst
    TEST_SUBU(0xd6fc0584, 0x5f9765a8, 0x77649fdc)
    TEST_SUBU(0xbf9c95c2, 0x3368890e, 0x8c340cb4)
    TEST_SUBU(0xda67a888, 0xa727b830, 0x333ff058)
    TEST_SUBU(0x23858808, 0x657a98bc, 0xbe0aef4c)
    TEST_SUBU(0xc690f86f, 0x820c54b9, 0x4484a3b6)
    TEST_SUBU(0xc1e0ac00, 0xcc9a2edb, 0xf5467d25)
    TEST_SUBU(0xf1b1b086, 0x1724c0ca, 0xda8cefbc)
    TEST_SUBU(0xbfe467d8, 0x90e60dcf, 0x2efe5a09)
    TEST_SUBU(0x88afa220, 0x884e3c40, 0x006165e0)
    TEST_SUBU(0xee2b3d28, 0x8b26d1e7, 0x63046b41)
    TEST_SUBU(0xb4ad54be, 0x44a2c3c2, 0x700a90fc)
    TEST_SUBU(0xc4f4a100, 0xe32f2978, 0xe1c57788)
    TEST_SUBU(0x9c7e895a, 0x327b164c, 0x6a03730e)
    TEST_SUBU(0x88b98036, 0xa0c09c10, 0xe7f8e426)
    TEST_SUBU(0x78b54804, 0x2de3d8b4, 0x4ad16f50)
    TEST_SUBU(0xe404ea90, 0x493a8a98, 0x9aca5ff8)
    TEST_SUBU(0x00000000, 0x1d344e02, 0xe2cbb1fe)
    TEST_SUBU(0x00000000, 0x4cc33600, 0xb33cca00)
    TEST_SUBU(0x00000000, 0x05174cf8, 0xfae8b308)
    TEST_SUBU(0x00000000, 0x68c6ea90, 0x97391570)
    TEST_SUBU(0x00000000, 0xad4237d0, 0x52bdc830)
    TEST_SUBU(0x00000000, 0x5e60f5d4, 0xa19f0a2c)
    TEST_SUBU(0x00000000, 0x02ab610e, 0xfd549ef2)
    TEST_SUBU(0x00000000, 0x95d92f0a, 0x6a26d0f6)
    TEST_SUBU(0x00000000, 0x60d51e10, 0x9f2ae1f0)
    TEST_SUBU(0x00000000, 0xdae9ff00, 0x25160100)
    TEST_SUBU(0x00000000, 0x87cd34c0, 0x7832cb40)
    TEST_SUBU(0x00000000, 0x62dfd480, 0x9d202b80)
    TEST_SUBU(0x00000000, 0x7970a300, 0x868f5d00)
    TEST_SUBU(0x00000000, 0xc41ac2fa, 0x3be53d06)
    TEST_SUBU(0x00000000, 0x1b425f40, 0xe4bda0c0)
    TEST_SUBU(0x00000000, 0xb4073a78, 0x4bf8c588)
    TEST_SUBU(0x00000000, 0x00000000, 0x00000000)
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
END(n24_subu_test)
