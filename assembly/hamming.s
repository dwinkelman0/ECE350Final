.text

j   test_1

# $r4: word to encode
# $r5: noise
# $r6: expect double error
# $r2: result (0: success, 1: decode failure, 2: detected double error)
test_hamming:
		setx 0
		henc $r8, $r4
		xor  $r8, $r8, $r5
		hdec $r9, $r8
		bex  test_hamming_double

	test_hamming_check:
		bne  $r9, $r4, test_hamming_failure
		j    test_hamming_success

	test_hamming_double:
		bne  $r6, $r0, test_hamming_success

	test_hamming_failure:
		addi $r2, $r0, 1
		j    test_hamming_return

	test_hamming_success:
		addi $r2, $r0, 0

	test_hamming_return:
		jr   $r31

main:
test_1:
	addi $r4, $r0, 10000
	addi $r5, $r0, 0
	addi $r6, $r0, 0
	jal  test_hamming
	sw   $r2, 0($r0)

test_2:
	addi $r4, $r0, 10000
	addi $r5, $r0, 256
	addi $r6, $r0, 0
	jal  test_hamming
	sw   $r2, 1($r0)

test_3:
	addi $r4, $r0, 10000
	addi $r5, $r0, 257
	addi $r6, $r0, 1
	jal  test_hamming
	sw   $r2, 2($r0)