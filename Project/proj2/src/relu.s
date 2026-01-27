.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 1
    bge a1, t0, loop_start
    li a0, 78
    ret

loop_start:
    addi t0, x0, 0
    addi t1, a0, 0

loop_check:
    beq t0, a1, loop_end    

loop_continue:
    lw t2, 0(t1)
    bge t2, x0, 12
    addi t2, x0, 0
    sw t2, 0(t1)
    addi t1, t1, 4
    addi t0, t0, 1 
    j loop_check

loop_end:
    addi a0, x0, 0
    # Epilogue

    
	ret
