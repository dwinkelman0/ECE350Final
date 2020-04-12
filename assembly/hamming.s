.text

# Set stack pointer
addi $r29, $r0, 4095
j    main

# https://en.wikipedia.org/wiki/Xorshift
# $r4: memory location
# $r5: number of numbers to generate
# $r6: seed
populate_data:
		addi $r9, $r0, 0
		add  $r10, $r10, $r4
		addi $r11, $r0, 1
		sll  $r11, $r11, 26
		addi $r11, $r11, -1

	populate_data_loop:
		sll  $r8, $r6, 13
		xor  $r6, $r6, $r8
		sra  $r8, $r6, 17
		xor  $r6, $r6, $r8
		sll  $r8, $r6, 5
		xor  $r6, $r6, $r8
		and  $r12, $r6, $r11
		sw   $r12, 0($r10)

		addi $r9, $r9, 1
		addi $r10, $r10, 1
		blt  $r9, $r5, populate_data_loop

	populate_data_return:
		jr   $r31

# $r4 (const): word to test
# $r5 (const): memory location of output
# $r2: end location of output
test_sequence:
		sw   $r31, 0($r29)
		sw   $r16, -1($r29)
		addi $r29, $r29, -2

		addi $r16, $r5, 0
		sw   $r4, 0($r16)
		sw   $r0, 1($r16)
		addi $r16, $r16, 2

		addi $r13, $r0, 204
		sll  $r13, $r13, 24
		addi $r14, $r0, 136
		sll  $r14, $r14, 24
		j    test_sequence_0n

	# $r7: test code
	test_sequence_check_success:
			bex  test_sequence_check_success_2e
			bne  $r9, $r4, test_sequence_check_success_1e
			sw   $r7, 0($r16)
			sw   $r14, 1($r16)
			addi $r16, $r16, 2
			jr   $r31

		test_sequence_check_success_1e:
			sw   $r7, 0($r16)
			sw   $r13, 1($r16)
			addi $r16, $r16, 2
			jr   $r31

		test_sequence_check_success_2e:
			sw   $r7, 0($r16)
			sw   $r9, 1($r16)
			addi $r16, $r16, 2
			jr   $r31

	test_sequence_0n:
		addi $r7, $r0, 1
		sll  $r7, $r7, 28
		addi $r31, $r0, test_sequence_1n
		henc $r8, $r4
		hdec $r9, $r8
		j    test_sequence_check_success

	test_sequence_1n:
		sll  $r11, $r7, 1
		addi $r12, $r0, 1
		addi $r15, $r0, 1
		addi $r31, $r0, test_sequence_1n_loop_return_point

	test_sequence_1n_loop:
		or   $r7, $r11, $r15
		henc $r8, $r4
		xor  $r8, $r8, $r12
		hdec $r9, $r8
		j    test_sequence_check_success

	test_sequence_1n_loop_return_point:
		sll  $r12, $r12, 1
		addi $r15, $r15, 1
		bne  $r12, $r0, test_sequence_1n_loop

	test_sequence_return:
		addi $r2, $r16, 0
		addi $r29, $r29, 2
		lw   $r31, 0($r29)
		lw   $r16, -1($r29)
		jr   $r31

main:
	addi $r20, $r0, 8

	addi $r4, $r0, 0
	addi $r5, $r20, 0
	addi $r6, $r0, 40
	jal  populate_data

	addi $r21, $r0, 0
	addi $r5, $r20, 8
main_loop:
	lw   $r4, 0($r21)
	jal  test_sequence
	addi $r5, $r2, 8
	addi $r21, $r21, 1
	blt  $r21, $r20, main_loop