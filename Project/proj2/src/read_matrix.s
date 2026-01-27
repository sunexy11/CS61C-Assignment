.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
	
    mv s0, a1
    mv s1, a2
    mv a1, a0
    addi a2, x0, 0
    jal fopen
    addi t1, x0, -1
    bne a0, t1, 12
    li a1, 90
    jal exit2

    mv s5, a0
    addi sp, sp, -8
    mv a2, sp
    mv a1, s5
    li a3, 8
    jal fread
    addi t1, x0, 8
    beq a0, t1, 12
    li a1, 91
    jal exit2

    lw s2, 0(sp)
    lw s3, 4(sp)
    sw s2, 0(s0)
    sw s3, 0(s1)
    addi sp, sp, 8
    mul s4, s2, s3
    mv a0, s4
    slli a0, a0, 2
    jal malloc
    bne a0, x0, 12
    li a1, 88
    jal exit2
    
    mv a1, s5
    mv a2, a0
    mv s6, a2
    slli s4, s4, 2
    mv a3, s4
    jal fread
    beq a0, s4, 12
    li a1, 91
    jal exit2

    jal fclose
    addi t1, x0, -1
    bne a0, t1, 12
    li a1, 92
    jal exit2

    mv a0, s6
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret
