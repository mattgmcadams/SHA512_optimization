.arch rhody			;use rhody.cfg
.outfmt hex			;output format is hex
.memsize 2048			;specify 2K words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define part to be included in user's program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define tx	0x0900	;text video X (0 - 79)
.define ty	0x0901	;text video Y (0 - 59)
.define taddr	0x0902	;text video address
.define tascii	0x0903	;text video ASCII code
.define cursor	0x0904	;ASCII for text cursor
.define prompt	0x0905	;prompt length for BS left limit
.define tnum	0x0906	;text video number to be printed
.define format	0x0907	;number output format
.define gx	0x0908	;graphic video X (0 - 799)
.define gy	0x0909	;graphic video Y (0 - 479)
.define gaddr	0x090A	;graphic video address
.define color	0x090B	;color for graphic
.define x1	0x090C	;x1 for line/circle
.define y1	0x090D	;y1
.define x2	0x090E	;x2 for line
.define y2	0x090F	;y2
.define rad	0x0910	;radius for circle
.define	string	0x0911	;string pointer
;I/O Address;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define kcntrl	0xf0000	;keyboard control register
.define kascii	0xf0001	;keyboard ASCII code
.define vcntrl	0xf0002	;video control register
.define time0	0xf0003	;Timer 0
.define time1	0xf0004	;Timer 1
.define inport 	0xf0005	;GPIO read address
.define outport	0xf0005	;GPIO write address
.define rand	0xf0006	;random number
.define msx	0xf0007	;mouse X
.define msy	0xf0008	;mouse Y
.define msrb	0xf0009	;mouse right button
.define mslb	0xf000A	;mouse left button
.define trdy	0xf0010	;touch ready
.define tcnt	0xf0011	;touch count
.define gesture	0xf0012	;touch gesture
.define tx1	0xf0013	;touch X1
.define ty1	0xf0014	;touch Y1
.define tx2	0xf0015	;touch X2
.define ty2	0xf0016	;touch Y2
.define tx3	0xf0017	;touch X3
.define ty3	0xf0018	;touch Y3
.define tx4	0xf0019	;touch X4
.define ty4	0xf001A	;touch Y4
.define tx5	0xf001B	;touch X5
.define ty5	0xf001C	;touch Y5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SHA512 Program variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define m1024	0x0800	;32 words M 0x800-0x81F
.define w80		0x0820	;160 words W 0x820-0x8BF 
.define wva		0x08C0	;working variable a H
.define wval	0x08C1	;working variable a L
.define wvb		0x08C2	;working variable b H
.define wvbl	0x08C3	;working variable b L
.define wvc		0x08C4	;working variable c H
.define wvcl	0x08C5	;working variable c L
.define wvd		0x08C6	;working variable d H
.define wvdl	0x08C7	;working variable d L
.define wve		0x08C8	;working variable e H
.define wvel	0x08C9	;working variable e L
.define wvf 	0x08CA	;working variable f H
.define wvfl	0x08CB	;working variable f L
.define wvg 	0x08CC	;working variable g H
.define wvgl	0x08CD	;working variable g L
.define wvh 	0x08CE	;working variable h H
.define wvhl	0x08CF	;working variable h L
.define h0		0x08D0	;hash value 0 H
.define count	0x08E0	;hash count

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;User defined SHA512 Program variables
;The unused data memory spaces are:
; 0x08E1 -- 0x08FF
; 0x0912 -- 0x09FF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define T1		0x08E1		;temp1
.define T1l		0x08E2		;temp1 lower
.define T2		0x08E3		;temp2
.define t2l		0x08e4
.define T3		0x08E5		;temp3
.define T3l 	0x08E6		;temp3 lower
.define increment 0x08e7

.define m1025	0x0921
.define m1026	0x0922
.define m1027	0x0923
.define m1028	0x0924
.define m1029	0x0925
.define m1030	0x0926
.define m1031	0x0927
.define m1032	0x0928
.define m1033	0x0929
.define m1034	0x092A
.define m1035	0x092B
.define m1036	0x092C
.define m1037	0x092D
.define m1038	0x092E
.define m1039	0x092F
.define m1040	0x0930
.define m1041	0x0931
.define m1042	0x0932
.define m1043	0x0933
.define m1044	0x0934
.define m1045	0x0935
.define m1046	0x0936
.define m1047	0x0937
.define m1048	0x0938
.define m1049	0x0939
.define m1050	0x093A
.define m1051	0x093B
.define m1052	0x093C
.define m1053	0x093D
.define m1054	0x093E
.define m1055   0x093F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SHA512_time_trial:
;The HASH subroutine is checked first with
;pre-defined message and answer.
;Then, use randomly generated message for SHA-512
;count how many hashes per seconds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHA512_time_trial:
	ldi r0, 1
	stm	format, r0
	stm tx, r0
	stm ty, r0
	sys	clear
	ldi	r0, m1024
	ldi	r1, test_message
	ldi	r2, 32
test1:	
	ldr	r3, r1		;copy test message to buffer
	str	r0, r3
	adi	r0, 1
	adi	r1, 1
	adi	r2, 0xffff
	jnz	test1
	call	HASH		;produce hash for the test message
	ldi	r0, h0
	ldi	r1, answer
	ldi	r2, 16
test2:	
	ldr	r3, r0
	ldr	r4, r1
	cmp	r3, r4
	jnz	wrong		;subroutine HASH is wrong
	adi	r0, 1
	adi	r1, 1
	adi	r2, 0xffff
	jnz	test2
;prepare hash count and timer
	ldi	r0, 0
	stm	count, r0
	ldi	r0, 1
	stm	time0, r0	;turn on 1-second timer
;Prepare the random inputs;;;;;;;;;;;;;;;;;;;;;;;;
sha1:	ldi	r5, m1024	;pointer to message buffer
	ldi	r2, 16
sha2:	ldm	r0, rand	;get random number
	str	r5, r0	
	adi	r5, 1
	adi	r2, 0xFFFF
	jnz	sha2
	ldh	r0, 0x8000
	ldl	r0, 0x0000
	str	r5, r0		;stop byte in 17th word
	ldi	r0, 0
	adi	r5, 1
	ldi	r2, 14		;fill in '0' to 14 words
sha3:	str	r5, r0	
	adi	r5, 1
	adi	r2, 0xFFFF
	jnz	sha3
	ldi	r0, 0x0200	;length=512
	str	r5, r0
	call	HASH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, count
	adi	r0, 1
	stm	count, r0	;inc hash count
	ldm	r0, time0
	ldm	r1, timeup
	cmp	r0, r1		;>= time up?
	js	sha1
	ldi	r0, 0
	stm	tx, r0
	stm	ty, r0
	ldm	r0, count
	stm	tnum, r0
	sys	printn
	ldi	r0, hashps
	stm	string, r0
	sys	prints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
halt:	jmp	halt		;print count and stop
timeup:	word	1000000		;1sec = 1000000us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HASH subroutine produced wrong hash
;print "dead" on 7-segment displays and stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wrong:
	ldi	r0, 0xdead
	stm	outport, r0
wrong_stop:
	jmp	wrong_stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pre-defined test message: this is a test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_message:
	word	0x74686973	;this
	word	0x20697320	; is 
	word	0x61207465	;a te
	word	0x73748000	;st
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000000
	word	0x00000070	;message length in bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hash for pre-define test message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
answer:
	word	0x7d0a8468
	word	0xed220400
	word	0xc0b8e6f3
	word	0x35baa7e0
	word	0x70ce880a
	word	0x37e2ac59
	word	0x95b9a97b
	word	0x809026de
	word	0x626da636
	word	0xac736524
	word	0x9bb974c7
	word	0x19edf543
	word	0xb52ed286
	word	0x646f437d
	word	0xc7f810cc
	word	0x2068375c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hash per second
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hashps:
	byte	0x20
	byte	0x68		;h
	byte	0x61		;a
	byte	0x73		;s
	byte	0x68		;h
	byte	0x2F		;/
	byte	0x73		;s
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Carraige return (for bug testing)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cr:
	byte	0x0D	
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The 80 64-bit K constants in 160 32-bit words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
K512:	word	0x428a2f98	;k0	K Constant
	word	0xd728ae22
	word	0x71374491	;k1
	word	0x23ef65cd 
	word	0xb5c0fbcf	;k2
	word	0xec4d3b2f 
	word	0xe9b5dba5	;k3
	word	0x8189dbbc 
	word	0x3956c25b	;k4
	word	0xf348b538 
	word	0x59f111f1	;k5
	word	0xb605d019 
	word	0x923f82a4	;k6
	word	0xaf194f9b 
	word	0xab1c5ed5	;k7
	word	0xda6d8118 
	word	0xd807aa98	;k8
	word	0xa3030242 
	word	0x12835b01	;k9
	word	0x45706fbe 
	word	0x243185be	;k10
	word	0x4ee4b28c 
	word	0x550c7dc3	;k11
	word	0xd5ffb4e2 
	word	0x72be5d74	;k12
	word	0xf27b896f 
	word	0x80deb1fe	;k13
	word	0x3b1696b1 
	word	0x9bdc06a7	;k14
	word	0x25c71235 
	word	0xc19bf174	;k15
	word	0xcf692694 
	word	0xe49b69c1	;k16
	word	0x9ef14ad2 
	word	0xefbe4786	;k17
	word	0x384f25e3 
	word	0x0fc19dc6	;k18
	word	0x8b8cd5b5 
	word	0x240ca1cc	;k19
	word	0x77ac9c65 
	word	0x2de92c6f	;k20
	word	0x592b0275 
	word	0x4a7484aa	;k21
	word	0x6ea6e483 
	word	0x5cb0a9dc	;k22
	word	0xbd41fbd4 
	word	0x76f988da	;k23
	word	0x831153b5 
	word	0x983e5152	;k24
	word	0xee66dfab 
	word	0xa831c66d	;k25
	word	0x2db43210 
	word	0xb00327c8	;k26
	word	0x98fb213f 
	word	0xbf597fc7	;k27
	word	0xbeef0ee4 
	word	0xc6e00bf3	;k28
	word	0x3da88fc2 
	word	0xd5a79147	;k29
	word	0x930aa725 
	word	0x06ca6351	;k30
	word	0xe003826f 
	word	0x14292967	;k31
	word	0x0a0e6e70 
	word	0x27b70a85	;k32
	word	0x46d22ffc 
	word	0x2e1b2138	;k33
	word	0x5c26c926 
	word	0x4d2c6dfc	;k34
	word	0x5ac42aed 
	word	0x53380d13	;k35
	word	0x9d95b3df 
	word	0x650a7354	;k36
	word	0x8baf63de 
	word	0x766a0abb	;k37
	word	0x3c77b2a8 
	word	0x81c2c92e	;k38
	word	0x47edaee6 
	word	0x92722c85	;k39
	word	0x1482353b 
	word	0xa2bfe8a1	;k40
	word	0x4cf10364 
	word	0xa81a664b	;k41
	word	0xbc423001 
	word	0xc24b8b70	;k42
	word	0xd0f89791 
	word	0xc76c51a3	;k43
	word	0x0654be30 
	word	0xd192e819	;k44
	word	0xd6ef5218 
	word	0xd6990624	;k45
	word	0x5565a910 
	word	0xf40e3585	;k46
	word	0x5771202a 
	word	0x106aa070	;k47
	word	0x32bbd1b8 
	word	0x19a4c116	;k48
	word	0xb8d2d0c8 
	word	0x1e376c08	;k49
	word	0x5141ab53 
	word	0x2748774c	;k50
	word	0xdf8eeb99 
	word	0x34b0bcb5	;k51
	word	0xe19b48a8 
	word	0x391c0cb3	;k52
	word	0xc5c95a63 
	word	0x4ed8aa4a	;k53
	word	0xe3418acb 
	word	0x5b9cca4f	;k54
	word	0x7763e373 
	word	0x682e6ff3	;k55
	word	0xd6b2b8a3 
	word	0x748f82ee	;k56
	word	0x5defb2fc 
	word	0x78a5636f	;k57
	word	0x43172f60 
	word	0x84c87814	;k58
	word	0xa1f0ab72 
	word	0x8cc70208	;k59
	word	0x1a6439ec 
	word	0x90befffa	;k60
	word	0x23631e28 
	word	0xa4506ceb	;k61
	word	0xde82bde9 
	word	0xbef9a3f7	;k62
	word	0xb2c67915 
	word	0xc67178f2	;k63
	word	0xe372532b 
	word	0xca273ece	;k64
	word	0xea26619c 
	word	0xd186b8c7	;k65
	word	0x21c0c207 
	word	0xeada7dd6	;k66
	word	0xcde0eb1e 
	word	0xf57d4f7f	;k67
	word	0xee6ed178 
	word	0x06f067aa	;k68
	word	0x72176fba 
	word	0x0a637dc5	;k69
	word	0xa2c898a6 
	word	0x113f9804	;k70
	word	0xbef90dae 
	word	0x1b710b35	;k71
	word	0x131c471b 
	word	0x28db77f5	;k72
	word	0x23047d84 
	word	0x32caab7b	;k73
	word	0x40c72493 
	word	0x3c9ebe0a	;k74
	word	0x15c9bebc 
	word	0x431d67c4	;k75
	word	0x9c100d4c 
	word	0x4cc5d4be	;k76
	word	0xcb3e42b6 
	word	0x597f299c	;k77
	word	0xfc657e2a 
	word	0x5fcb6fab	;k78
	word	0x3ad6faec 
	word	0x6c44198c	;k79
	word	0x4a475817 
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The 8 64-bit initial H in 16 32-bit words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Hinit:
	word	0x6a09e667	;H0	initial Hash
	word	0xf3bcc908
	word	0xbb67ae85	;H1
	word	0x84caa73b
	word	0x3c6ef372	;H2
	word	0xfe94f82b
	word	0xa54ff53a	;H3
	word	0x5f1d36f1
	word	0x510e527f	;H4
	word	0xade682d1
	word	0x9b05688c	;H5
	word	0x2b3e6c1f
	word	0x1f83d9ab	;H6
	word	0xfb41bd6b
	word	0x5be0cd19	;H7
	word	0x137e2179
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HASH subroutine to generate the 512-bit message digest
;inputs: 
;  M = m1024 is the 16-words (64-bit word) input buffer
;		This is emulated using 32 32-bit words
;  W = w80 is the 80-word (64-bit word) message schedule
;		This is emulated using 160 32-bit words 
;  wva, wvb, ..., wvh = working variables a to h
;  K = K512 the 80 64-bit words constant array
;  Hinit is the 8 64-bit words initial H
;outputs:
;  h0 to h7 = hash values (each takes two 32-bit words)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

debug:
	stm tnum, r0
	sys printn
	stm tnum, r1
	sys printn
	ret
	
debug2:
	stm tnum, r4
	sys printn
	stm tnum, r5
	sys printn
	ret

HASH:	
	ldi	r5, 0	;pointer to Upper
	ldi	r7, 0
;copy M to W(0..31)
sch1:	
	ldix 	r0, r5, m1024	;m1024[i] (upper)
	inc 	r5 	;m1024[i+1] (lower)
	ldix 	r1, r5, m1024
	stix	r7, r0, w80
	inc 	r7
	stix 	r7, r1, w80
	inc2	r5, r7
	cmpi 	r5, 32
	sys dump
	jnz	sch1

	
;Process the next 62 entrances
;R7 is currently the pointer to buffer (W)
;80 - 64 = 14, 48 + 14 = 62 (48 originally, 160 words so 80 entries)
;64 words -> 160 words; 64 entries -> 80 entries
	;ldi	r2, 64		;loop count
	;ldi r7, w80
	;adi r7, 32
sch2:
	adi		r7, 0xFFFC		;t-2 (-4)
	ldix	r0, r7, w80			;r0=W(t-2) upper
	inc 	r7
	ldix 	r1, r7, w80			;r1=W(t-2) lower
	sig1    r0, r1				;r0 & r1 = sig1(W(t-2))
	adi		r7, 0xFFF5		;t-7 (-14)
	ldix	r4, r7, w80			;r4=W(t-7) upper
	inc 	r7	
	ldix 	r5, r7, w80			;r5=W(t-7) lower
	add64   r0, r1, r4, r5		 	;r0 & r1 =sig1(W(t-2))+W(t-7)
	adi		r7, 0xFFEF		;t-15 (-30)
	ldix	r3, r7, w80			;r0=W(t-15) upper
	inc 	r7
	ldix 	r6, r7, w80			;r1=W(t-15) lower
	sig0	r3, r6   			;r0 & r1 = sig0(W(t-15))
	add64   r0, r1, r3, r6			;r0 & r1 = sig1(W(t-2))+W(t-7)+sig0(W(t-15))
	adi		r7, 0xFFFD		;t-16 (-32)
	ldix	r4, r7, w80			;r4=W(t-16) upper
	inc 	r7
	ldix 	r5, r7, w80			;r5=W(t-16) lower
	add64   r0, r1, r4, r5			;r0 & r1 = sig1(W(t-2))+W(t-7)+sig1(W(t-15))+W(t-16)
	adi		r7, 31
	stix	r7, r0, w80
	inc	r7
	stix 	r7, r1, w80
	inc r7
	sys dump
	cmpi r7, 160
	jnz	sch2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;At this point, we have prepared the 80 64-bit 
;message schedule: W
;Use R3 as the loop count since R2 will be use by functions
;initialize the working variables with initial H
;The working variables are defined in sequence and 
;work like a table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r5, 0  				;r5=pointer to init H
	ldi	r6, 0  				;r6=pointer to working variables
	ldi	r7, 0  				;r7=pointer to hash values
sch3:	
	ldix	r0, r5, Hinit
	inc 	r5
	ldix 	r1, r5, Hinit
	stix	r6, r0, wva
	stix 	r7, r0, h0
	inc2 	r6,	r7
	stix 	r6, r1, wva
	stix 	r7, r1, h0
	inc3	r5, r6, r7
	sys dump
	cmpi 	r7, 16
	jnz	sch3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin the big loop of 0 to 80
;From this point on:
;	R6 is reserved as pointer to K
;	R7 is reserved as pointer to W
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r3, 0		;the loop count
	ldi	r7, 0  ;w80		;r7=pointer to W
	ldi	r6, 0  ;k512	;r6=pointer to K
sch4:
	;ldi		r3, 0	        		; 8			
	stm			increment, r3
	ldm 	r0, wve						;r0 & r1 = e
	ldm 	r1, wvel
	;ldix	r0, r3, wve			;r0=e higher
	;ldix 	r1, r3, wvel			;r1=e lower
	
	ldm 	r2, wvf						;r2 & r3 = f
	ldm 	r3, wvfl
	
	ldm 	r4, wvg						;r4 & r5 = g
	ldm 	r5, wvgl		
	
	ldm		r6, wvh						;r4=h
	ldm 	r7, wvhl						;r5=h lower
	
	
	
	
	t1a	r0, r1, r2, r3, r4, r5, r6, r7    ; Ch(e,f,g) and wve saved as sigs, for t1b
	
	
	
	ldm		r7, increment
	ldix	r2, r7, k512					;r4 & r5 = K[i]
	adi 	r7, 1
	ldix 	r3, r7, k512
	adi		r7, 0xffff
	
	ldix	r4, r7, w80						;r4 & r5 = W
	adi 	r7, 1
	ldix 	r5, r7, w80

	ldm 	r6, wve						;r0 & r1 = e
	ldm 	r7, wvel
	
	t1b		r0, r1, r2, r3, r4, r5, r6, r7			; r0&r1 = h + sum1(e) + Ch(e,f,g) + K + W
	
	sys dump
dbg: jmp dbg
	
	stm		t1, r0
	stm		t1l, r1
	
	ldm		r0, wva					;r0=a
	ldm 	r1, wval						;r1=a lower
	
	ldm 	r2, wvb						;r2=b
	ldm 	r3, wvbl						;r3=b lower
	
	ldm 	r4, wvc						;r4=c
	ldm 	r5, wvcl						;r5=c lower
	
	t2		r0, r1, r2, r3, r4, r5			; r0&r1 = sum0(a) + maj(a,b,c)
	
	stm 	T2, r0							;T2 = sum0(a)+Maj(a,b,c)
	stm		T2L, r1	
	
	ldm		r0, wvg					;h <= g
	ldm 	r1, wvgl
	
	stm 	wvh, r0
	stm 	wvhl, r1
	
	ldm		r0, wvf					;g <= f
	ldm 	r1, wvfl
	
	stm		wvg, r0		
	stm 	wvgl, r1;
	
	ldm		r0, wve						;f <= e
	ldm 	r1, wvel
	
	stm		wvf, r0
	stm 	wvfl, r1
	
	ldm		r0, wvd
	ldm 	r1, wvdl
	
	ldm		r4, t1
	ldm 	r5, T1l
	
	add64   r0, r1, r4, r5					;e <= d + T1
	
	stm		wve, r0
	stm 	wvel, r1
	
	ldm		r0, wvc						;d <= c
	ldm 	r1, wvcl
	
	stm	wvd, r0
	stm 	wvdl, r1
	
	ldm 	r0, wvb						;c <= b
	ldm  	r1, wvbl
	
	stm	wvc, r0
	stm 	wvcl, r1
	
	ldm 	r0, wva						;b <= a
	ldm  	r1, wval
	
	stm	wvb, r0	
	stm 	wvbl, r1
	
	ldm   	r0, t1
	ldm  	r1, T1l
	
	ldm 	r4, t3
	ldm  	r5, T3l
	
	add64  r0, r1, r4, r5					;a <= T1 + T3
	
	stm	wva, r0
	stm 	wval, r1
	;
	
	ldm		r3, increment
	
	adi	r3, 2	
	
	cmpi 	r3, 160
	jnz	sch4

	

;oldsch4:::
	;ldi	r3, 0		                ; 8
	;ldix	r0, r3, wve			;r0=e higher
	;ldix 	r1, r3, wvel			;r1=e lower
	
	;sum1	r0, r1				;r0 & r1=sum1(e)
	;ldix	r4, r3, wvh			;r4=h
	;ldix 	r5, r3, wvhl			;r5=h lower
	;add64   r0, r1, r4, r5			;r0 & r1 = h+sum1(e)
	;stm 	T1, r0				;T1 = h+sum1(e)
	;stm 	T1l, r1
	;ldm 	r0, wve				;r0 & r1 = e
	;ldm 	r1, wvel
	;ldm 	r2, wvf				;r2 & r3 = f
	;ldm 	r3, wvfl
	;ldm 	r4, wvg				;r4 & r5 = g
	;ldm 	r5, wvgl
	;ch   	r0, r1, r2, r3, r4, r5		;r0 & r1 = ch(e,f,g)
	;ldm 	r4, T1				;r4 & r5 = h+sum1(e)
	;ldm 	r5, T1l
	;add64   r0, r1, r4, r5			;r0 & r1 = ch(e,f,g) + h+sum1(e)
	;ldix	r4, r6, k512			;r4 & r5 = K[i]
	;inc 	r6
	;ldix 	r5, r6, k512
	;add64   r0, r1, r4, r5			;r0 & r1 =h+sum1(e)+Ch(e,f,g)+K
	;ldix	r4, r7, w80					;r4 & r5 = W
	;inc 	r7
	;ldix 	r5, r7, w80
	;add64   r0, r1, r4, r5			;r0 & r1 =h+sum1(e)+Ch(e,f,g)+K+W
	;stm 	T1, r0				;T1=h+sum1(e)+Ch(e,f,g)+K+W
	;stm 	T1l, r1
	;ldm		r0, wva			;r0=a
	;ldm 	r1, wval			;r1=a lower
	;sum0    r0, r1				;r0 & r1 = sum(a)
	;stm 	T3, r0				;T3 = sum0(a)
	;stm 	T3l, r1
	;ldm	r0, wva				;r0=a
	;ldm 	r1, wval			;r1=a lower
	;ldm 	r2, wvb				;r2=b
	;ldm 	r3, wvbl			;r3=b lower
	;ldm 	r4, wvc				;r4=c
	;ldm 	r5, wvcl			;r5=c lower
	;maj 	r0, r1, r2, r3, r4, r5		;r0 & r1=Maj(a,b,c)
	;ldm 	r4, T3				;r4 & r5 = sum(a)
	;ldm 	r5, T3l
	;add64   r0, r1, r4, r5			;r0 & r1 =sum0(a)+Maj(a,b,c)
	;ldi	r3, 0
	;stm 	T3, r0				;T3 = sum0(a)+Maj(a,b,c)
	;stm	T3l, r1
	;ldix	r0, r3, wvg			;h <= g
	;ldix 	r1, r3, wvgl
	;stm 	wvh, r0
	;stm 	wvhl, r1
	;ldix	r0, r3, wvf			;g <= f
	;ldix 	r1, r3, wvfl
	;stm		wvg, r0		
	;stm 	wvgl, r1;
	;ldix	r0, r3, wve			;f <= e
	;ldix 	r1, r3, wvel
	;stm		wvf, r0
	;stm 	wvfl, r1
	;ldix	r0, r3, wvd
	;ldix 	r1, r3, wvdl
	;ldix	r4, r3, T1
	;ldix 	r5, r3, T1l
	;add64   r0, r1, r4, r5			;e <= d + T1
	;stm		wve, r0
	;stm 	wvel, r1
	;ldix	r0, r3, wvc			;d <= c
	;ldix 	r1, r3, wvcl
	;stm		wvd, r0
	;stm 	wvdl, r1
	;ldix	r0, r3, wvb			;c <= b
	;ldix 	r1, r3, wvbl
	;stm		wvc, r0
	;stm 	wvcl, r1
	;ldix	r0, r3, wva			;b <= a
	;ldix 	r1, r3, wval
	;stm		wvb, r0	
	;stm 	wvbl, r1
	;ldix  	r0, r3, T1
	;ldix 	r1, r3, T1l
	;ldix 	r4, r3, T3
	;ldix 	r5, r3, T3l
	;add64   r0, r1, r4, r5			;a <= T1 + T3
	;stm		wva, r0
	;stm 	wval, r1
	;inc2	r6, r7			;inc pointer to K & W
	;cmpi 	r7, 160
	;jnz	sch4
;calculate the hash values
	ldi	r2, 0  				;r2=pointer to working variables
	ldi	r3, 0  				;r3=pointer to hash values
sch5:
	ldix	r0, r2, wva			;r0 & r1 = wv
	inc 	r2
	ldix 	r1, r2, wva
	ldix	r4, r3, h0			;r4 & r5 = hash values
	inc 	r3
	ldix 	r5, r3, h0
	add64   r0, r1, r4, r5			;r0 & r1 = wv[i] + h[i]
	adi 	r3, 0xFFFF 			;reset r3
	stix	r3, r0, h0			;r3 (h[i]) = w[i] + h[i]
	inc 	r3
	stix 	r3, r1, h0
	inc2	r2, r3			;wv pointer++  &  hash pointer++
	cmpi 	r3, 16
	jnz	sch5
	ret


exit: jmp exit	

sys dump
dbg: jmp dbg
