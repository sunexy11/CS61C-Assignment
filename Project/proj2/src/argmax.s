.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    
    addi s0, x0, 0
    addi s1, x0, 77
    li s2, 0x80000000

loop_start:
    beq s0, a1, loop_end

loop_continue:
    slli t0, s0, 2
    add t0, t0, a0
    lw t1, 0(t0)
    bge s2, t1, 12
    mv s1, s0
    mv s2, t1
    addi s0, s0, 1
    j loop_start

loop_end:
    
    mv a0, s1

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret
