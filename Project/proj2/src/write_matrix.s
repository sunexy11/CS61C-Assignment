.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a0
    mv s1, a1
    mul s3, a2, a3
    addi sp, sp, -8
    sw a2, 0(sp)
    sw a3, 4(sp)

    mv a1, a0
    addi a2, x0, 1
    jal fopen
    addi t0, x0, -1
    bne a0, t0, 12
    li a1, 93
    jal exit2

    mv s2, a0
    mv a1, s2
    mv a2, sp
    addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    addi t0, x0, 2
    beq a0, t0, 12
    li a1, 94
    jal exit2

    mv a1, s2
    mv a2, s1
    mv a3, s3
    addi a4, x0, 4
    jal fwrite
    beq a0, s3, 12
    li a1, 94
    jal exit2

    mv a1, s2
    jal fclose
    beq a0, x0, 12
    li a1, 95
    jal exit2

    # Epilogue
    addi sp, sp, 8
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    ret
