#include <asm.h>
#include <regdef.h>
#include <inst_test.h>

LEAF(n58_jalr_ds_test)
    .set noreorder
    addiu s0, s0 ,1
    li  s2, 0x00

###score ++
###output (s0<<24)|s3
inst_error:
    addiu s3, s3, 1
    sll t1, s0, 24
    or t0, t1, s3 
    sw t0, 0(s1)
    jr ra
    nop
END(n58_jalr_ds_test)
