.text

# Test 1
setx 6
sw   $r30, 0($r0)

# Test 2
addi $r1, $r0, 99
setx 1
add  $r2, $r1, $r30
add  $r3, $r30, $r1
add  $r2, $r2, $r3
sw   $r2, 1($r0)
sw   $r30, 1($r30)
