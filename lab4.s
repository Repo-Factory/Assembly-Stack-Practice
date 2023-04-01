#                                           CS 240, Lab #4
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################################
#                           Data Section
.data

# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Conner Sommerfield"
student_id: .asciiz "824769654"

new_line: .asciiz "\n"
space: .asciiz " "


t1_str: .asciiz "Testing GCD: \n"
t2_str: .asciiz "Testing LCM: \n"
t3_str: .asciiz "Testing RANDOM SUM: \n"

po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "

GCD_test_data_A:	.word 1, 36, 360, 108, 28300
GCD_test_data_B:	.word 12,54, 210, 144, 74000

GCD_output:           .word 1, 18, 30, 36, 100

LCM_test_data_A:	.word 1, 36, 360, 108, 28300
LCM_test_data_B:	.word 12,54, 210, 144, 74000
LCM_output:           .word 12, 108, 2520, 432, 20942000

RANDOM_test_data_A:	.word 1, 144, 42, 260, 74000
RANDOM_test_data_B:	.word 12, 108, 54, 210, 44000
RANDOM_test_data_C:	.word 4, 109, 36, 360, 28300

RANDOM_output:           .word 26, 720, 216, 3120, 21044400

###############################################################################
#                           Text Section
.text
# Utility function to print an array
print_array:
li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################################
###############################################################################
#                           PART 1 (GCD)
#a0: input number
#a1: input number
.globl gcd
gcd:
############################### Part 1: your code begins here ################

# Implement this C function in assembly
# int euclidGCD(int x, int y) {
# if (y == 0) {
#	return x;
# }
# else {
#	return euclidGCD(y, x % y);
# }
#}


euclidGCD:
beq $a1, $zero return_a0 # return answer a0 when a1 == 0

# ** If remainder != 0 #
#Calculate Mod - Store in $t0
div $a0, $a1
mfhi $t0 #hi will store remainder after division between a0 and a1
#Set New Arguments Before Recursive Call
move  $a0, $a1
move $a1, $t0
j euclidGCD # recursive call

return_a0: # a1 == 0 when division by factor a0 has no remainder
move $v0, $a0 
jr $ra

############################### Part 1: your code ends here  ##################
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (LCM)

# Find the least common multiplier of two numbers given
# Make a call to the GCD function to compute the LCM
# LCM = a1*a2 / GCD

# preserve the $ra register value in stack before making the call!!!

#a0: input number
#a1: input number

.globl lcm
lcm:
############################### Part 2: your code begins here ################

# ** preserve arguments which will be changed during subroutine ** #
# place a0 and a1 onto stack
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $a1, 4($sp)
# place $ra onto stack
addi $sp, $sp, -4
sw $ra 0($sp)

# -------------- stack vizualization --------------- #
		# -12: stack pointer -> ra 
		# -8:  sp + 4 --------> a0
		# -4:  sp + 8 --------> a1
# -------------- stack vizualization --------------- #

jal euclidGCD #subroutine will return GCD in $v0

# ** place return value in $t3 and reset arguments ** #
move $t3, $v0 # GCD -> $t3
lw $a0, 4($sp) # refer to above stack diagram
lw $a1, 8($sp)

# LCM = a1 * a2 / GCD
mul $t1, $a0, $a1 # a1 * a2
div $v0, $t1, $t3 # /GCD 

# recover $ra from the stack before jr
lw $ra, 0($sp)
addi $sp, $sp, 12 # bring stack pointer back to original state

############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest 
# one and the largest one.
# 
# Then find the GCD and LCM of the two numbers. 
#
# Return the sum of Smallest, largest, GCD and LCM
#
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.
# Use stacks to store the smallest and largest values before making the function call. 


.globl random_sum
random_sum:
############################### Part 3: your code begins here ################

# ** Determine Largest / Smallest Number ** #

#Logic:
# t0: min t1: mid t2: max
# if t0 > t1 swap
# if t1 > t2 swap
# if t0 > t1 swap

# implement swap logic
bgt $a0, $a1 swap1
check2:
bgt $a1, $a2 swap2
check3:
bgt $a0, $a1 swap3
j done

# swap t0 and t1, jump to check2
swap1:
move $t5, $a0 #t5 will be used as temp variable
move $a0, $a1
move $a1, $t5
j check2

# swap t1 and t2, jump to check3
swap2:
move $t5, $a1
move $a1, $a2
move $a2, $t5
j check3

# swap t0 and t1, done with checks
swap3:
move $t5, $a0
move $a0, $a1
move $a1, $t5

done:
# move min and max into t8 and t9
move $t8, $a0 # min
move $t9, $a2 # max

# **Place Min And Max As Well As $ra Onto The Stack** #
addi $sp, $sp, -8
sw $t8, 0($sp)
sw $t9, 4($sp)
addi $sp, $sp, -4
sw $ra 0($sp)
# -------------- stack vizualization --------------- #
		# -12: stack pointer -> ra 
		# -8:  sp + 4 --------> minValue
		# -4:  sp + 8 --------> maxValue
# -------------- stack vizualization --------------- #

# ** Fetch GCD and LCM Values ** #
#GCD call
move $a0, $t8 # set arguments before each function call (min and max)
move $a1, $t9
jal euclidGCD
move $t6, $v0 # store answer into temp register from $v0
#LCM call
lw $a0, 4($sp) # In case function sunbroutine manipulates t registers, grab t8 and t9 from the stack
lw $a1, 8($sp)
jal lcm
move $t7, $v0 # store answer into temp register from $v0

# ** Recover Values From the Stack ** #
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, 0($sp)
addi $sp, $sp, 4
lw $t2, 0($sp)
addi $sp, $sp, 4

# ** Add GCD, LCM, Smallest (t0), And Largest (t2) Number ** #
add $t0, $t0, $t2 # min + max
add $t1, $t6, $t7 # GCD + LCM
add $v0, $t0, $t1 # final sum

############################### Part 3: your code ends here  ##################
jr $ra
###############################################################################

#                          Main Function 
main:
li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
###############################################################################
#                          TESTING PART 1 - GCD
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t1_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, GCD_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, GCD_test_data_A
la $s3, GCD_test_data_B
#j skip_line
##############################################
test_gcd:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal gcd

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_gcd

###############################################################################

#                          TESTING PART 2 - LCM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t2_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, LCM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, LCM_test_data_A
la $s3, LCM_test_data_B
#j skip_line
##############################################
test_lcm:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 0($s5)
jal lcm

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_lcm

###############################################################################
#                          TESTING PART 3 - RANDOM SUM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t3_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, RANDOM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
#j skip_line
##############################################
test_random:
#li $v0, 4
#la $a0, new_line
#syscall
#skip_line:
add $s5, $s2, $s1
add $s6, $s3, $s1
add $s7, $s4, $s1
# Pass input parameter
lw $a0, 0($s5)
lw $a1, 0($s6)
lw $a2, 0($s7)
jal random_sum

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_random

###############################################################################

_end:
# new line
li $v0, 4
la $a0, new_line
syscall

# end program
li $v0, 10
syscall
###############################################################################


