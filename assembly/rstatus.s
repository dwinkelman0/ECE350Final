.text

# Expect:
#  0x000 = 3000
#  0x001 = -1000
#  0x002 = 1024000
#  0x003 = 1048576
#  0x004 = 0
#  0x005 = 1
#  0x006 = 0
#  0x007 = 2
#  0x008 = 0
#  0x009 = 3
#  0x00a = 10
#  0x00b = 1000
#  0x00c = 1024000

# Test 1: Basic add (expect no overflow)
addi $r1, $r0, 1000
addi $r2, $r1, 1000
add  $r3, $r1, $r2
sw   $r3, 0($r0)

# Test 2: Basic sub (expect no overflow)
sub  $r3, $r1, $r2
sw   $r3, 1($r0)

# Test 3: Basic shift (expect no overflow)
sll  $r3, $r1, 10
sw   $r3, 2($r0)

# Test 4: sw with overflow address (expect no overflow)
addi $r4, $r0, 1
sll  $r4, $r4, 20
sw   $r4, 3($r4)

# Test 5: Overflow add
addi $r5, $r0, 15
sll  $r5, $r5, 27
add  $r6, $r5, $r5
sw   $r6, 4($r0)
sw   $r30, 5($r0)

# Test 6: Subtraction overflow
addi $r7, $r0, 0
sub  $r6, $r0, $r5
sub  $r7, $r6, $r5
sw   $r7, 6($r0)
sw   $r30, 7($r0)

# Test 7: Addi overflow
addi $r6, $r0, 1
sll  $r6, $r6, 31
addi $r7, $r6, -167
sw   $r7, 8($r0)
sw   $r30, 9($r0)

# Test 8: $rstatus arithmetic
addi $r7, $r6, -167
addi $r8, $r30, 7
sw   $r8, 10($r0)
sw   $r1, 8($r30)
addi $r8, $r30, 7
lw   $r9, -1($r30)
sw   $r9, 9($r30)