.text

# Set stack pointer
addi $r29, $r0, 4095
j    main

# https://en.wikipedia.org/wiki/Xorshift
# $r4 (const): memory location
# $r5 (const): number of numbers to generate
# $r6: seed
# $r2: new seed
random_data:
		add  $r9, $r4, $r5
		addi $r10, $r4, 0

	random_data_loop:
		sll  $r8, $r6, 13
		xor  $r6, $r6, $r8
		sra  $r8, $r6, 17
		xor  $r6, $r6, $r8
		sll  $r8, $r6, 5
		xor  $r6, $r6, $r8
		sw   $r6, 0($r10)

		addi $r10, $r10, 1
		blt  $r10, $r9, random_data_loop

	random_data_return:
		addi $r2, $r6, 0
		jr   $r31

# $r5 (const): concentration of flipped bits (2^-n)
# $r6: seed
# $r2: noise word
# $r3: number of noise bits
#
# Probability of noise bits (n = 5)
# Calculated using a Poisson distribution
#  0: 36.8%
#  1: 36.8%
#  2: 18.4%
# >2:  8.0%
random_noise:
		sw   $r31, 0($r29)
		addi $r29, $r29, -1
		sub  $r29, $r29, $r5
		addi $r4, $r29, 1
		jal  random_data

		lw   $r2, 0($r4)
		add  $r10, $r4, $r5

	random_noise_loop:
		lw   $r11, 0($r4)
		and  $r2, $r2, $r11
		addi $r4, $r4, 1
		blt  $r4, $r10, random_noise_loop

	random_noise_return:
		pcnt $r3, $r2
		add  $r29, $r29, $r5
		addi $r29, $r29, 1
		lw   $r31, 0($r29)
		jr   $r31

# Write a series of squares to memory
# $r4: memory location
# $r5: number of numbers to generate
generate_message:
		addi $r9, $r4, 0
		add  $r10, $r4, $r5
		addi $r11, $r0, 1
		addi $r12, $r0, 20

	generate_message_loop:
		sw   $r11, 0($r9)
		add  $r11, $r11, $r12
		addi $r11, $r11, 100
		addi $r12, $r12, 200
		addi $r9, $r9, 1
		blt  $r9, $r10, generate_message_loop

	generate_message_return:
		jr   $r31

# Transmit the message over a noisy channel
# $r4: source memory location
# $r5: number of words
# $r6: random seed
# $r7: destination memory location
transmit_message:
		sw   $r31, 0($r29)
		sw   $r4, -1($r29)
		sw   $r5, -2($r29)
		sw   $r6, -3($r29)
		sw   $r7, -4($r29)
		addi $r29, $r29, -5

		addi $r17, $r4, 0
		add  $r18, $r4, $r5
		addi $r19, $r7, 0

		addi $r5, $r0, 5

	transmit_message_loop:
		jal  random_noise
		sw   $r2, 3($r19)
		lw   $r20, 0($r17)
		sw   $r20, 0($r19)
		henc $r20, $r20
		xor  $r20, $r20, $r2
		sw   $r20, 1($r19)

		addi $r17, $r17, 1
		addi $r19, $r19, 4
		blt  $r17, $r18, transmit_message_loop

	transmit_message_return:
		addi $r29, $r29, 5
		lw   $r31, 0($r29)
		lw   $r4, -1($r29)
		lw   $r5, -2($r29)
		lw   $r6, -3($r29)
		lw   $r7, -4($r29)
		jr   $r31

# $r4: source memory location
# $r5: number of words
# $r7: destination memory location
decode_message:
		sw   $r31, 0($r29)
		sw   $r4, -1($r29)
		sw   $r5, -2($r29)
		sw   $r7, -3($r29)
		addi $r29, $r29, -4

		addi $r17, $r4, 0
		addi $r18, $r7, 0
		add  $r19, $r7, $r5

	decode_message_loop:
		lw   $r9, 1($r17)
		hdec $r9, $r9
		bex  decode_message_loop_retransmit
		sw   $r9, 2($r17)
		sw   $r9, 0($r18)

	decode_message_loop_next:
		addi $r17, $r17, 4
		addi $r18, $r18, 1
		blt  $r18, $r19, decode_message_loop

	decode_message_loop_retransmit:
		setx 0
		sw   $r17, 0($r29)
		sw   $r18, -1($r29)
		sw   $r19, -2($r29)
		addi $r29, $r29, -3

		addi $r4, $r17, 0
		addi $r5, $r0, 1
		addi $r7, $r17, 0
		jal  transmit_message

		addi $r29, $r29, 3
		lw   $r17, 0($r29)
		lw   $r18, -1($r29)
		lw   $r19, -2($r29)
		j    decode_message_loop

	decode_message_return:
		addi $r29, $r29, 4
		lw   $r31, 0($r29)
		lw   $r4, -1($r29)
		lw   $r5, -2($r29)
		lw   $r7, -3($r29)
		jr   $r31

main:
	addi $r4, $r0, 0
	addi $r5, $r0, 8
	jal  generate_message

	addi $r4, $r0, 0
	addi $r5, $r0, 8
	addi $r6, $r0, 400
	addi $r7, $r0, 8
	jal  transmit_message

	addi $r4, $r0, 8
	addi $r5, $r0, 8
	addi $r7, $r0, 160
	jal  decode_message