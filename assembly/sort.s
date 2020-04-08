.text

# Set stack pointer
addi $r29, $r0, 4095
j    main

# $r4: start address
# $r5: number to generate
populate_data:
		addi $r8, $r0, 11
		add  $r9, $r8, $r0
		addi $r10, $r4, 0
		add  $r11, $r4, $r5

	populate_data_loop:
		sw   $r9, 0($r10)
		addi $r8, $r8, 3
		add  $r9, $r9, $r8
		sll  $r9, $r9, 27
		sra  $r9, $r9, 27
		addi $r10, $r10, 1
		blt  $r10, $r11, populate_data_loop

	populate_data_exit:
		jr   $r31

# $r4: start address
# $r5: number to sort
# $r6: swap space address
sort: # 0x0e
		addi $r16, $r0, 1
		bne  $r5, $r16, sort_two

	sort_one:
		# There is only one item to sort
		jr   $r31

	sort_two:
		addi $r16, $r0, 2
		bne  $r5, $r16, sort_more

		# There are only two items to sort
		lw   $r17, 0($r4)
		lw   $r18, 1($r4)
		blt  $r17, $r18, sort_two_done

		# Swap
		sw   $r18, 0($r4)
		sw   $r17, 1($r4)

	sort_two_done:
		jr   $r31

	sort_more: # 0x19
		# Recursion, so store $ra and arguments on the stack
		sw   $r31, 0($r29)
		sw   $r4, -1($r29)
		sw   $r5, -2($r29)
		addi $r29, $r29, -3

		# Sort the first sub-list
		sra  $r5, $r5, 1
		jal  sort

		# Sort the second sub-list
		add  $r4, $r4, $r5
		lw   $r16, 1($r29)
		sub  $r5, $r16, $r5
		jal  sort

		# Restore $ra and arguments from the stack
		addi $r29, $r29, 3
		lw   $r31, 0($r29)
		lw   $r4, -1($r29)
		lw   $r5, -2($r29)

		# Merge the two sub-lists
		addi $r16, $r4, 0
		addi $r17, $r5, 0
		sra  $r17, $r17, 1
		add  $r17, $r4, $r17
		addi $r18, $r17, 0
		add  $r19, $r4, $r5
		lw   $r20, 0($r16)
		lw   $r21, 0($r17)
		addi $r23, $r6, 0

	sort_more_merge_loop: # 0x30
		blt  $r20, $r21, sort_more_merge_left

	sort_more_merge_right:
		sw   $r21, 0($r23)
		addi $r23, $r23, 1
		addi $r17, $r17, 1
		lw   $r21, 0($r17)
		blt  $r17, $r19, sort_more_merge_loop

	sort_more_merge_copy_left_loop:
		sw   $r20, 0($r23)
		addi $r23, $r23, 1
		addi $r16, $r16, 1
		lw   $r20, 0($r16)
		blt  $r16, $r18, sort_more_merge_copy_left_loop
		j    sort_more_merge_copy_back

	sort_more_merge_left: #0x3c
		sw   $r20, 0($r23)
		addi $r23, $r23, 1
		addi $r16, $r16, 1
		lw   $r20, 0($r16)
		blt  $r16, $r18, sort_more_merge_loop

	sort_more_merge_copy_right_loop:
		sw   $r21, 0($r23)
		addi $r23, $r23, 1
		addi $r17, $r17, 1
		lw   $r21, 0($r17)
		blt  $r17, $r19, sort_more_merge_copy_right_loop
		j    sort_more_merge_copy_back

	sort_more_merge_copy_back:
		addi $r16, $r4, 0
		addi $r17, $r6, 0
		add  $r18, $r4, $r5

	sort_more_merge_copy_back_loop:
		lw   $r20, 0($r17)
		sw   $r20, 0($r16)
		addi $r16, $r16, 1
		addi $r17, $r17, 1
		blt  $r16, $r18, sort_more_merge_copy_back_loop

	sort_more_done:
		jr   $r31

main:
	addi $r4, $r0, 0
	addi $r5, $r0, 16
	jal  populate_data

main_sort: # 0x53
	addi $r4, $r0, 0
	addi $r5, $r0, 16
	add  $r6, $r4, $r5
	jal sort