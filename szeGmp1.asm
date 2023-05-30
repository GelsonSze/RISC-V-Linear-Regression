#Sze, Gelson S14
.globl main
.macro ret0
	li a7, 10
	ecall
.end_macro 
.macro newline
	li a7, 11
	li a0, 10
	ecall
.end_macro
.macro printIntResult(%x, %y)
	la t0, %y
	lw t1, (t0)
	
	li a7 4
	la a0, %x
	ecall
	li a7, 1
	mv a0, t1
	ecall
.end_macro
.macro printFloatResult(%x, %y)
	la t0, %y
	flw f1, (t0)
	
	li a7, 4
	la a0, %x
	ecall
	li a7, 2
	fmv.s fa0, f1
	ecall
.end_macro
.data
x_vals: .word 1,2,3,4,5,6,7
y_vals: .word 10,15,30,40,50,60,70
n_elements: .word 7
x_sum: .word 0
y_sum: .word 0
x_sum2: .word 0
y_sum2: .word 0
xy_sum: .word 0
m: .float 0.0
b_val: .float 0.0
x_sum_message: .asciz "x_sum:"
y_sum_message: .asciz "y_sum:"
x_sum2_message: .asciz "x_sum2:"
y_sum2_message: .asciz "y_sum2:"
xy_sum_message: .asciz "xy_sum:"
m_message: .asciz "m:"
b_message: .asciz "b:"
output_title_message: .asciz "Linear regression solver"
error_input_message: .asciz "Error: 3 or more inputs required"
error_nonlinear_message: .asciz "Error: Input is not linear. Input values should be increasing"
.text
main:
	#summation of x and y
	la t0, n_elements #Sze, Gelson S14
	la t1, x_vals
	la t2, y_vals
	lw t3, (t0) #load value of n_elements
	li t4, 0 #t4 = checker for 3 or more elements
	li t5, 3 #t5 = 3
	li t6, 0 #t6 = get previous y value to check for increasing values
	li s7, 0 #s7 = sum of x*y values
	li s8, 0 #s8 = sum of x^2 values
	li s9, 0 #s9 = sum of y^2 values
	li s10, 0 #s10 = sum of x values
	li s11, 0 #s11 = sum of y values
	
	blt t3, t5, error_input

sum_loop:
	blez t3, sum_loop_end #check if looped through n times
	
	lw s0, (t1) #get next element of x values
	lw s1, (t2) #get next element of y values

	blt s1, t6, error_nonlinear
	mv t6, s1 #t6 gets previous element

	add s10, s10, s0 #add s10 with element of x
	add s11, s11, s1 #add s11 with element of y
	
	mul s2, s0, s1 #x*y
	add s7, s7, s2 #add s7 with the product of x and y
	
	mul s0, s0, s0 #x^2
	mul s1, s1, s1 #y^2
	
	add s8, s8, s0 #add s8 with the square of the element x
	add s9, s9, s1 #add s9 with the square of the element y

	addi t1, t1, 4 #increment pointers
	addi t2, t2, 4
	addi t3, t3, -1  #decrement counter 
	addi t4, t4, 1 #increment counter for checking

	j sum_loop

error_input:
	li a7, 4
	la a0, output_title_message
	ecall
	newline
	li a7, 4
	la a0, error_input_message
	ecall
	ret0

error_nonlinear:
	li a7, 4
	la a0, output_title_message
	ecall
	newline
	li a7, 4
	la a0, error_nonlinear_message
	ecall
	ret0

sum_loop_end:
	la t0, x_sum
	sw s10, (t0)
	la t1, y_sum
	sw s11, (t1)
	la t2, x_sum2 
	sw s8, (t2)
	la t3, y_sum2
	sw s9, (t3)
	la t4, xy_sum
	sw s7, (t4)

	lw s0, (t0) #s0 = x_sum
	lw s1, (t1) #s1 = y_sum
	lw s2, (t2) #s2 = x_sum2
	lw s3, (t3) #s3 = y_sum2
	lw s4, (t4) #s4 = xy_sum
	la t5, n_elements
	lw s5, (t5) #s5 = number of elements
		
	mul s11, s5, s4
	mul s10, s0, s1
	sub s11, s11, s10
	fcvt.s.w f1, s11
	
	mul s11, s5, s2
	mul s10, s0, s0
	sub s11, s11, s10
	fcvt.s.w f2, s11
	
	fdiv.s f1, f1, f2
	la t6, m
	fsw f1, (t6) #f1 = m

	fcvt.s.w f3, s1 # f3 = float y_sum
	fcvt.s.w f4, s0 # f4 = float x_sum
	fcvt.s.w f5, s5 # f5 = float num of elements
	
	fmul.s f2, f1, f4 #f2 = m * x_sum
	fsub.s f2, f3, f2 #f2 = y_sum - m * x_sum
	fdiv.s f2, f2, f5 #f2 = b
	
	la t6, b_val
	fsw f2, (t6) #f2 = b
	call printOutput
	ret0

printOutput:
	li a7, 4
	la a0, output_title_message
	ecall
	newline
 	printIntResult(x_sum_message,x_sum)
	newline
	printIntResult(y_sum_message,y_sum)
	newline
	printIntResult(x_sum2_message,x_sum2)
	newline
	printIntResult(y_sum2_message,y_sum2)
	newline
	printIntResult(xy_sum_message,xy_sum)
	newline
	printFloatResult(m_message, m)
	newline
	printFloatResult(b_message, b_val)
	ret




