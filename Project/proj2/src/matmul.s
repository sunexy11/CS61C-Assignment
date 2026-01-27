.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1
    blt a1, t0, error_72
    blt a2, t0, error_72
    blt a4, t0, error_73
    blt a5, t0, error_73
    bne a2, a4, error_74
    
    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    mv s0, a0
    mv s1, a3
    mv s2, a1
    mv s3, a2
    mv s4, a5
    mv s5, a6
    addi s6, x0, 0
    addi s7, x0, 0
    mv s8, s0
    mv s9, s1
    mv s10, s5
    slli s11, s3, 2

outer_loop_start:
    beq s6, s2, outer_loop_end
    mv s9, s1
    addi s7, x0, 0

inner_loop_start:
    beq s7, s4, inner_loop_end
    mv a0, s8
    mv a1, s9
    mv a2, s3
    addi a3, x0, 1
    mv a4, s4
    jal dot
    sw a0, 0(s10)
    addi s7, s7, 1
    addi s10, s10, 4
    addi s9, s9, 4
    j inner_loop_start

inner_loop_end:
    add s8, s8, s11
    addi s6, s6, 1
    j outer_loop_start

outer_loop_end:
    mv a0, s5

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    
    ret

error_72:
    li a0, 72
    ret

error_73:
    li a0, 73
    ret

error_74:
    li a0, 74
    ret
