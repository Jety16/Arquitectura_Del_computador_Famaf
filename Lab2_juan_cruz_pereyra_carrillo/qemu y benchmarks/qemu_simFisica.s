	.data
	N:       .dword 5 		// Asumimos que N != 0
	n_iter:  .dword 10		// Asumimos que n_iter != 0
	t_amb:   .dword 25   
	y:		 .dword 2  
	z:		 .dword 3
	fc_temp: .dword 413

	.bss 
	x: .zero  32784        
	x_temp: .zero  32784 
	
	.text
	ldr     x0, N
    ldr     x1, =x 
    ldr     x2, =x_temp
    ldr     x3, n_iter
	ldr     x4, t_amb
	ldr     x5, y
	ldr 	x6, z
	ldr     x7, fc_temp

    mrs x9, CPACR_EL1           
    movz x12, 0x0030, lsl #16   
    orr x9, x9,x12
    msr CPACR_EL1, x9           
	add x9, xzr, xzr
	add x12, xzr, xzr

//---------------------- CODE HERE ------------------------------------
	scvtf d4, x4 			// pasado a float t_amb
	scvtf d7, x7     		// pasado a float fc_temp
	mul x18, x0, x0 		// N*N
	mov x19, x1      		// copia de la direccion de x
	add x20, xzr, xzr		// l = 0
	
	mul x11, x5, x0  		// y*N 
	add x11, x11, x6 		// y*N + z
	lsl x12, x11, #3		// (y*N + z)*8
	add x12, x12, x1 		// direccion del pixel en llamas

init_array: 				// inicializar arreglo
	str d4, [x19, #0]		// x[l] = t_amb 
	add x19, x19, #8
	add x20, x20, #1		// l++
	cmp x18, x20
	b.ne init_array			// si l != N, saltar
	str d7, [x12, #0]		// pixel en llamas

	add x8, xzr, xzr 		// k = 0

ext_loop:
	add x9, xzr, xzr 		// i = 0

row_loop:
	add x10, xzr, xzr		// j = 0

column_loop:
	fsub d14, d14, d14 		// sum = 0
	mul x13, x9, x0  		// i*N
	add x13, x13, x10		// i*N + j
	cmp x11, x13
	b.eq finish_sum			// si i*N + j == y*N + z, saltar
	add x15, x9, #1			// i+1 
	cmp x15, x0
	b.eq lower_pixel_out    // si i+1 == N, saltar
	mul x15, x15, x0		// (i+1)*N
	add x15, x15, x10		// (i+1)*N + j
	lsl x15, x15, #3 		// ((i+1)*N + j)*8
	add x15, x15, x1            
	ldr d16, [x15, #0] 		// x[(i+1)*N + j]
	fadd d14, d14, d16      // sum = sum + x[(i+1)*N + j]
	b end_lower_pixel

lower_pixel_out: 
	fadd d14, d14, d4		// sum = sum + t_amb

end_lower_pixel:
	cbz x9, upper_pixel_out // si i == 0, saltar
	sub x15, x9, #1			// i-1
	mul x15, x15, x0		// (i-1)*N
	add x15, x15, x10		// (i-1)*N + j
	lsl x15, x15, #3 		// ((i-1)*N + j)*8
	add x15, x15, x1            
	ldr d16, [x15, #0] 		// x[(i-1)*N + j]
	fadd d14, d14, d16      // sum = sum + x[(i-1)*N + j]
	b end_upper_pixel

upper_pixel_out:
	fadd d14, d14, d4		// sum = sum + t_amb

end_upper_pixel:
	add x15, x10, #1		// j+1
	cmp x15, x0
	b.eq right_pixel_out        // si j+1 == N, saltar
	mul x17, x9, x0			// i*N
	add x17, x17, x15		// i*N + (j+1)
	lsl x17, x17, #3 		// (i*N + (j+1))*8
	add x17, x17, x1            
	ldr d16, [x17, #0] 		// x[i*N + (j+1)]
	fadd d14, d14, d16          // sum = sum + x[i*N + (j+1)]
	b end_right_pixel

right_pixel_out:
	fadd d14, d14, d4		// sum = sum + t_amb

end_right_pixel:
	cbz x10, left_pixel_out // si j == 0, saltar
	sub x15, x10, #1 		// j-1
	mul x17, x9, x0			// i*N
	add x17, x17, x15		// i*N + (j-1)
	lsl x17, x17, #3 		// (i*N + (j-1))*8
	add x17, x17, x1            
	ldr d16, [x17, #0] 		// x[i*N + (j-1)]
	fadd d14, d14, d16      // sum = sum + x[i*N + (j-1)]
	b end_left_pixel

left_pixel_out:
	fadd d14, d14, d4		// sum = sum + t_amb

end_left_pixel:
	add x16, xzr, xzr
	add x16, x16, #4
	scvtf d16, x16
	fdiv d14, d14, d16		// sum = sum / 4
	lsl x13, x13, #3 		// (i*N + j)*8
	add x13, x13, x2
	str d14, [x13, #0]		// x_temp[(i*N + j)] = sum

finish_sum:
	add x10, x10, #1 		// j++
	cmp x10, x0
	b.ne column_loop		// si j != N, saltar
	add x9, x9, #1   		// i++
	cmp x9, x0
	b.ne row_loop			// si i != N, saltar

	mov x19, x1      		// copia de la direccion de x
	mov x20, x2 			// copia de la direccion de x_temp
	add x21, xzr, xzr		// l = 0

store_array:
	cmp x19, x12
	b.eq no_store			// si l == y*N + z, saltar
	ldr d21, [x20, #0]
	str d21, [x19, #0]		// x[l] = x_temp[l]

no_store:
	add x19, x19, #8
	add x20, x20, #8
	add x21, x21, #1
	cmp x21, x18
	b.ne store_array		// si l != N*N, saltar
	add x8, x8, #1			// k++
	cmp x8, x3
	b.ne ext_loop   		// si k != n_iter, saltar

end:
infloop: B infloop