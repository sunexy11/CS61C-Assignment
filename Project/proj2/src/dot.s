.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    addi t0, x0, 1
    blt a2, t0, error_75
    blt a3, t0, error_76
    blt a4, t0, error_76

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)

    addi s0, x0, 0
    mv s1, a0
    mv s2, a1
    slli a3, a3, 2
    slli a4, a4, 2
    addi s3, x0, 0

loop_start:
    bge s0, a2, loop_end
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    add s3, s3, t0
    add s1, s1, a3
    add s2, s2, a4
    addi s0, s0, 1
    j loop_start 

loop_end:
    mv a0, s3
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    
    ret

error_75:
    li a0, 75
    ret

error_76:
    li a0, 76
    ret
