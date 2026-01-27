.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    addi t0, x0, 5
    beq a0, t0, 12
    li a1, 89
    jal exit2

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    mv s0, a1
    mv s6, a2
    lw a0, 4(s0)
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    mv s1, a0

    lw a0, 8(s0)
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    mv s2, a0

    lw a0, 12(s0)
    addi sp, sp, -8
    addi a1, sp, 0
    addi a2, sp, 4
    jal read_matrix
    mv s3, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    lw t0, 16(sp)
    lw t1, 4(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    bne a0, x0, 12
    li a1, 88
    jal exit2
    
    mv s4, a0
    mv a6, s4
    mv a0, s1
    lw a1, 16(sp)
    lw a2, 20(sp)
    mv a3, s3
    lw a4, 0(sp)
    lw a5, 4(sp)
    jal matmul

    lw t0, 16(sp)
    lw t1, 4(sp)
    mul a1, t0, t1
    mv a0, s4
    jal relu

    lw t0, 8(sp)
    lw t1, 4(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    bne a0, x0, 12
    li a1, 88
    jal exit2

    mv s5, a0
    mv a0, s2
    lw a1, 8(sp)
    lw a2, 12(sp)
    mv a3, s4
    lw a4, 16(sp)
    lw a5, 4(sp)
    mv a6, s5
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s0)
    mv a1, s5
    lw a2, 8(sp)
    lw a3, 4(sp)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    bne s6, x0, end
    lw t0, 8(sp)
    lw t1, 4(sp)
    mul a1, t0, t1
    mv a0, s5
    jal argmax

    # Print classification
    
    mv a1, a0
    jal print_int

    # Print newline afterwards for clarity

    li a1, 10
    jal print_char

end:
    addi sp, sp, 24
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free

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
