.text

addi $r10, $r0, 1
j    test_1

# Test 1: jal-jr with 0 intermediate instructions
func_1:
	jr   $r31

test_1:
	jal  func_1
	sw   $r10, 0($r0)
	j    test_2

# Test 2: jal-jr with 1 intermediate instruction
func_2:
	addi $r10, $r10, 1
	jr   $r31

test_2:
	jal  func_2
	sw   $r10, 1($r0)
	j    test_3

# Test 3: jal-jr with 2 intermediate instructions
func_3:
	addi $r10, $r10, 2
	addi $r10, $r10, -1
	jr   $r31

test_3:
	jal  func_3
	sw   $r10, 2($r0)
	j    test_4

# Test 4: jal-jr with 3 intermediate instructions
func_4:
	addi $r10, $r10, 3
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	jr   $r31

test_4:
	jal  func_4
	sw   $r10, 3($r0)
	j    test_5

# Test 5: jal-jr with 4 intermediate instructions
func_5:
	addi $r10, $r10, 4
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	jr   $r31

test_5:
	jal  func_5
	sw   $r10, 4($r0)
	j    test_6

# Test 6: jal-jr with 5 intermediate instructions
func_6:
	addi $r10, $r10, 5
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	addi $r10, $r10, -1
	jr   $r31

test_6:
	jal  func_6
	sw   $r10, 5($r0)
	j    test_7

# Test 7: jal, increment $r31, jr
func_7:
	addi $r31, $r31, 1
	jr   $r31

test_7:
	jal  func_7
	addi $r10, $r0, 1
	addi $r10, $r10, 1
	sw   $r10, 6($r0)
	j    test_8

# Test 8: jal, increment $r31, 1 intermediate instruction, jr
func_8:
	addi $r31, $r31, 1
	addi $r10, $r10, 1
	jr   $r31

test_8:
	jal  func_8
	addi $r10, $r0, 1
	sw   $r10, 7($r0)
	j    test_9

# Test 9: jal, increment $r31, 2 intermediate instructions, jr
func_9:
	addi $r31, $r31, 1
	addi $r10, $r10, 2
	addi $r10, $r10, -1
	jr   $r31

test_9:
	jal  func_9
	addi $r10, $r0, 1
	sw   $r10, 8($r0)
	j    test_10

# Test 10: jal, increment $r31 by value from lw, jr
func_10:
	lw   $r4, 100($r0)
	add  $r31, $r31, $r4
	jr   $r31

test_10:
	addi $r20, $r0, 1
	sw   $r20, 100($r0)
	jal  func_10
	addi $r10, $r0, 1
	addi $r10, $r10, 1
	sw   $r10, 9($r0)
	j    test_11

# Test 11: jal, increment $r31 by value from lw, 1 intermediate instruction, jr
func_11:
	lw   $r4, 100($r0)
	add  $r31, $r31, $r4
	addi $r10, $r10, 1
	jr   $r31

test_11:
	addi $r20, $r0, 1
	sw   $r20, 100($r0)
	jal  func_11
	addi $r10, $r0, 1
	sw   $r10, 10($r0)
	j    test_12

# Test 12: jal, lw, 1 intermediate instruction, increment $r31, jr
func_12:
	lw   $r4, 100($r0)
	addi $r10, $r10, 1
	add  $r31, $r31, $r4
	jr   $r31

test_12:
	addi $r20, $r0, 1
	sw   $r20, 100($r0)
	jal  func_12
	addi $r10, $r0, 1
	sw   $r10, 11($r0)
	j    test_13

# Test 13: jal, sw $31, lw $31, jr
func_13:
	sw   $r31, 200($r0)
	lw   $r31, 200($r0)
	jr   $r31

test_13:
	addi $r20, $r0, 1
	sw   $r20, 100($r0)
	jal  func_13
	addi $r10, $r10, 1
	sw   $r10, 12($r0)
	j    test_14

# Test 14: jal, intermediate instructions, sw $31, lw $31, jr
func_14:
	addi $r10, $r10, 5
	addi $r10, $r10, -5
	addi $r10, $r10, 5
	addi $r10, $r10, -5
	sw   $r31, 300($r0)
	lw   $r31, 300($r0)
	jr   $r31

test_14:
	addi $r20, $r0, 1
	sw   $r20, 100($r0)
	jal  func_14
	addi $r10, $r10, 1
	sw   $r10, 13($r0)
