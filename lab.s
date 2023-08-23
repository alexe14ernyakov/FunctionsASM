bits	64
; arcshinus (ss)
section	.data
msg1:	db	"Input x: ", 0
msg2:	db	"%f", 0
msg3:	db	"asinh(%.2g)=%.2g", 10, 0
section	.text
x	equ	4
y	equ	x+4
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
	movss	xmm0, [rbp-x]
	call	asinhf
	movss	dword[rbp-y], xmm0
	mov 	edi, msg3
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-y]
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	mov 	eax, 2
	call	printf
	leave
	xor		eax, eax
	ret
