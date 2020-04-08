.text

# Test 1: Do nothing
test_1:
	addi $r1, $r0, 1
	bex  test_1_fail
	sw   $r1, 0($r0)
	j    test_2

test_1_fail:
	addi $r20, $r0, -1
	sw   $r20, 0($r0)

# Test 2: Generate an exception using the ALU
test_2:
	addi $r2, $r0, 15
	sll  $r2, $r2, 27
	add  $r3, $r2, $r2
	bex  test_2_pass
	sw   $r20, 1($r0)
	j    test_3

test_2_pass:
	addi $r1, $r1, 1
	sw   $r1, 1($r0)

# Test 3: Clear an exception using setx
test_3:
	setx 0
	bex  test_3_fail
	addi $r1, $r1, 1
	sw   $r1, 2($r0)
	j    test_4

test_3_fail:
	sw   $r20, 2($r0)

# Test 4: Set an exception using setx
test_4:
	setx 6
	bex  test_4_pass
	sw   $r20, 3($r0)
	j    test_5

test_4_pass:
	addi $r1, $r1, 1
	sw   $r1, 3($r0)

test_5:
	addi $r0, $r0, 0