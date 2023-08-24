bits	64
; arcshinus (ss)
section	.data
msg1:	db	"Input x: ", 0
msg2:	db	"%f", 0
msg3:	db	"Input accuracy: ", 0
msg4:	db	"%f", 0
msg5:	db	"asinhf(%.2g)=%.5g", 10, 0
msg6:	db	"my_asinhf(%.2g)=%.5g", 10, 0
section	.text
one		dd	1.0
negone	dd	-1.0
four	dd	4.0
x	equ	4
y	equ	x+4
a 	equ	y+4
y2	equ	a+4
extern	printf
extern	scanf
extern	asinhf
global	main
main:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 16
	
	mov		edi, msg1
	xor		eax, eax
	call	printf
	
	mov		edi, msg2
	lea		rsi, [rbp-x]
	xor		eax, eax
	call	scanf

	mov 	edi, msg3
	xor		eax, eax
	call	printf

	mov 	edi, msg4
	lea 	rsi, [rbp-a]
	xor		eax, eax
	call	scanf
	
	movss	xmm0, [rbp-x]
	call	asinhf
	
	movss	dword[rbp-y], xmm0
	mov 	edi, msg5
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-y]
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	mov 	eax, 2
	call	printf

	movss	xmm0, [rbp-x]            ; возможно не надо
	movss	xmm2, [rbp-a]
	call	my_asinhf
	
	movss	[rbp-y2], xmm0
	mov 	edi, msg6
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-y2]
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	mov 	eax, 2
	call	printf
	
	leave
	xor		eax, eax
	ret

my_asinhf:
	movss	xmm1, xmm0
	
	movss	xmm3, [one]
	movss	xmm4, [one]
	movss	xmm5, [one]
	movss	xmm6, xmm0
	
	next_element:
	mulss	xmm1, [negone]
	divss	xmm1, [four]
	mulss	xmm1, xmm3
	addss	xmm3, [one]
	mulss	xmm1, xmm3
	divss	xmm1, xmm4
	divss	xmm1, xmm4
	addss	xmm4, [one]
	mulss	xmm1, xmm5
	addss	xmm5, [one]
	addss	xmm5, [one]
	divss	xmm1, xmm5
	mulss	xmm1, xmm6
	mulss	xmm1, xmm6
	
	ucomiss	xmm1, xmm2
	jae		addition

	mulss	xmm2, [negone]
	ucomiss	xmm1, xmm2
	jbe		negative_term

	ret
	
	negative_term:
	mulss	xmm2, [negone]

	addition:
	addss	xmm0, xmm1
	jmp		next_element
