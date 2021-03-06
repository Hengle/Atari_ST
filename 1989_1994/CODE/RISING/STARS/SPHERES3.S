	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	MOVE	#$001,$FFFF8240.W
	
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#32000,D0
	MOVE.L	D0,SCREEN2
	
	BRA.S	DEBUT

DECALE	MOVEM.L	D0/A0,-(SP)
	LEA	DISK+34,A0
	MOVE	#199,D0
RO
N	SET	0
	REPT	20
	ROXR	N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D0,RO
	MOVEM.L	(SP)+,D0/A0
	RTS


DEBUT
	LEA	BUF_COD,A0
	LEA	TABLE,A4
	MOVE	#8-1,D4
ICI
	LEA	LITTLE_TABLE,A6
	MOVEQ	#0,D5
FINI	MOVE.L	A0,(A4)+
	MOVE.L	(A6)+,D6
	CMPI.L	#-1,D6
	BEQ.S	TERMIN�
;	LEA	VALEURS,A1
	LEA	DISK+34,A2

	LEA	-160(A2),A2
	MOVE	#-160,D7

CONT	;ADDQ	#8,A2
	;ADDQ	#8,D7

	LEA	160(A2),A2
	ADD	#160,D7
	CMPI	#160*200,D7
	BNE.S	OK
	MOVEQ	#0,D7
	ADDQ	#8,D5
	CMPI	#160,D5
	BNE.S	NOT_END
	MOVEQ	#0,D5
	MOVE	#$4E75,(A0)+
	BRA.S	FINI
NOT_END
	MOVE.L	A0,(A4)+
	LEA	DISK+34,A2
OK
;	CMPI	#32000,D7
;	BEQ.S	FINI
	MOVE.L	D6,A1
	MOVE	(A2,D5.W),D0
	BEQ.S	CONT
	MOVEQ	#0,D2
SEARCH	MOVE	(A1)+,D1
	CMPI	#$9999,D1
	BEQ.S	CONT
	CMP	D0,D1
	BNE.S	NOT_THIS_ONE
	MOVE	#$3140,(A0)
	ADD	D2,(A0)+
	MOVE	D7,(A0)
	ADD	D5,(A0)+
	BRA.S	CONT
NOT_THIS_ONE	ADDQ	#1,D2
	BRA.S	SEARCH
TERMIN�	NOP
	JSR	DECALE
	JSR	DECALE
	ADDQ	#1,$FFFF8240.W
	DBF	D4,ICI

	SF	$FFFF8240.W

	MOVE.L	#VBL,$70.W
L	BRA.S	L
FIN	MOVE.L	4.W,A0
	JMP	(A0)
FLAG_CLIP	DC	0
VBL
	CLR	FLAG_CLIP
;	MOVE	#5000,D0
;I	DBF	D0,I
	SF	$FFFF8240.W
	
	BRA	NOS
	LEA	DEP,A0
MOD_DEP_X	EQU	*+2
	LEA	0(A0),A0
	CMPI	#$9999,(A0)
	BNE.S	.PAFIN
	CLR	MOD_DEP_X
	LEA	DEP,A0
.PAFIN	ADDQ	#2,MOD_DEP_X
	MOVE	(A0),D0
	SUB	#160,D0
NOS
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NOF1
	ADDQ	#1,X_
NOF1	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NOF2
	SUBQ	#1,X_
NOF2
	
	
X_	EQU	*+2
	MOVE	#0,D0
	MOVE	D0,D1
	ADD	D0,D0
	ADD	D0,D0
	LEA	TABLO_X,A0
	MOVE	(A0,D0.W),MOD_DEP
	MOVE	2(A0,D0.W),MOD_OFFSET
	
	CMPI	#120,D1
	BLT.S	.CA_ROOL
	MOVE	#1,FLAG_CLIP
	SUBI	#120,D1
	LSR	#4,D1	D1=NB COL A AFFICHER-1
	LEA	TABLE,A2
	ADD	MOD_DEP,A2
	LEA	SAVE_ADR,A6
	LEA	SAVE,A5
	ADDQ	#1,D1
	MOVE	#14,D2
	SUB	D1,D2
	MOVE	D2,D1
	ADD	D1,D1
	ADD	D1,D1
	ADD	D1,A2
	REPT	4
	MOVE.L	(A2),A3
	MOVE	(A3),(A5)+
	MOVE.L	A3,(A6)+
	MOVE	#$4E75,(A3)
	LEA	20*4(A2),A2
	ENDR
.CA_ROOL
	
	MOVE.L	SCREEN2,A0
	MOVEQ	#0,D0
	MOVE	#199,D1
EF	
N	SET	0
	REPT	20
	MOVE	D0,N(A0)
N	SET	N+8
	ENDR
	LEA	160(A0),A0
	DBF	D1,EF
	
POPO	MOVE.L	SCREEN2,A0
MOD_OFFSET	EQU	*+2
	LEA	0(A0),A0
	LEA	TABLE,A2
MOD_DEP	EQU	*+2
	LEA	0(A2),A2
	LEA	PART_1,A1
	REPT	4
	MOVEM	(A1)+,D0-D7
	MOVE.L	(A2),A3
	JSR	(A3)
	ADDQ	#2,A1
	LEA	20*4(A2),A2
	ENDR
	
	TST	FLAG_CLIP
	BEQ.S	Z
	LEA	SAVE_ADR,A6
	LEA	SAVE,A5
	REPT	4
	MOVE.L	(A6)+,A4
	MOVE	(A5)+,(A4)
	ENDR
Z	MOVE.B	SCREEN2+1,$FFFF8201.W
	MOVE.B	SCREEN2+2,$FFFF8203.W
	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	AZ
	ST	$FFFF8240.W
AZ	RTE

	MOVE	#7,-(SP)
	TRAP	#1
	ADDQ	#2,SP
	MOVE.L	$44E.W,A0
	MOVE	#7999,D0
EFF	CLR.L	(A0)+
	DBF	D0,EFF
	ADD	#4*20*4+4,MOD_DEP
	BRA	POPO
J	BRA.S	J

DISK	INCBIN	DISK.PI1

LITTLE_TABLE
	DC.L	PART_1
	DC.L	PART_2
	DC.L	PART_3
	DC.L	PART_4
	DC.L	-1
VALEURS
PART_1	DC	%1111111111111111
	DC	%1111111111111110
	DC	%1111111111111100
	DC	%1111111111111000
	DC	%1111111111110000
	DC	%1111111111100000
	DC	%1111111111000000
	DC	%1111111110000000
	DC	$9999

PART_2	DC	%1111111100000000
	DC	%1111111000000000
	DC	%1111110000000000
	DC	%1111100000000000
	DC	%1111000000000000
	DC	%1110000000000000
	DC	%1100000000000000
	DC	%1000000000000000
	DC	$9999

PART_3	DC	%0000000000000000
	DC	%0111111111111111
	DC	%0011111111111111
	DC	%0001111111111111
	DC	%0000111111111111
	DC	%0000011111111111
	DC	%0000001111111111
	DC	%0000000111111111
	DC	$9999

PART_4	DC	%0000000011111111
	DC	%0000000001111111
	DC	%0000000000111111
	DC	%0000000000011111
	DC	%0000000000001111
	DC	%0000000000000111
	DC	%0000000000000011
	DC	%0000000000000001
	DC	$9999

DEP
 DC 460
 DC 459
 DC 458
 DC 457
 DC 455
 DC 453
 DC 450
 DC 447
 DC 443
 DC 438
 DC 434
 DC 428
 DC 422
 DC 416
 DC 409
 DC 402
 DC 395
 DC 387
 DC 378
 DC 369
 DC 360
 DC 351
 DC 341
 DC 331
 DC 320
 DC 310
 DC 298
 DC 287
 DC 276
 DC 264
 DC 252
 DC 240
 DC 228
 DC 216
 DC 203
 DC 191
 DC 178
 DC 166
 DC 153
 DC 141
 DC 128
 DC 116
 DC 103
 DC 91
 DC 79
 DC 67
 DC 55
 DC 43
 DC 32
 DC 21
 DC 10
 DC -1
 DC -12
 DC -22
 DC -32
 DC -41
 DC -50
 DC -59
 DC -68
 DC -76
 DC -83
 DC -90
 DC -97
 DC -103
 DC -109
 DC -115
 DC -119
 DC -124
 DC -128
 DC -131
 DC -134
 DC -136
 DC -138
 DC -139
 DC -140
 DC -140
 DC -140
 DC -139
 DC -138
 DC -136
 DC -134
 DC -131
 DC -128
 DC -124
 DC -119
 DC -115
 DC -109
 DC -103
 DC -97
 DC -90
 DC -83
 DC -76
 DC -68
 DC -59
 DC -50
 DC -41
 DC -32
 DC -22
 DC -12
 DC -1
 DC 9
 DC 21
 DC 32
 DC 43
 DC 55
 DC 67
 DC 79
 DC 91
 DC 103
 DC 116
 DC 128
 DC 141
 DC 153
 DC 166
 DC 178
 DC 191
 DC 203
 DC 216
 DC 228
 DC 240
 DC 252
 DC 264
 DC 276
 DC 287
 DC 298
 DC 310
 DC 320
 DC 331
 DC 341
 DC 351
 DC 360
 DC 369
 DC 378
 DC 387
 DC 395
 DC 402
 DC 409
 DC 416
 DC 422
 DC 428
 DC 434
 DC 438
 DC 443
 DC 447
 DC 450
 DC 453
 DC 455
 DC 457
 DC 458
 DC 459
 DC $9999

N	SET	20*4
N2	SET	-20*8
 REPT 20
 DC 0+N,N2
 DC 0+N,N2
 DC 20*4*4+4+N,N2
 DC 20*4*4+4+N,N2
 DC (20*4*4+4)*2+N,N2
 DC (20*4*4+4)*2+N,N2
 DC (20*4*4+4)*3+N,N2
 DC (20*4*4+4)*3+N,N2
 DC (20*4*4+4)*4+N,N2
 DC (20*4*4+4)*4+N,N2
 DC (20*4*4+4)*5+N,N2
 DC (20*4*4+4)*5+N,N2
 DC (20*4*4+4)*6+N,N2
 DC (20*4*4+4)*6+N,N2
 DC (20*4*4+4)*7+N,N2
 DC (20*4*4+4)*7+N,N2
N SET N-4
N2 SET N2+8
 ENDR
TABLO_X

N	SET	0
 REPT	20
 DC 0,N
 DC 0,N
 DC 20*4*4+4,N
 DC 20*4*4+4,N
 DC (20*4*4+4)*2,N
 DC (20*4*4+4)*2,N
 DC (20*4*4+4)*3,N
 DC (20*4*4+4)*3,N
 DC (20*4*4+4)*4,N
 DC (20*4*4+4)*4,N
 DC (20*4*4+4)*5,N
 DC (20*4*4+4)*5,N
 DC (20*4*4+4)*6,N
 DC (20*4*4+4)*6,N
 DC (20*4*4+4)*7,N
 DC (20*4*4+4)*7,N
N	SET	N+8
	ENDR

	BSS
SAVE_ADR	DS.L	4
SAVE	DS	4
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000
TABLE	DS.L	20*4*16
	ds.l	50
BUF_COD	DS.B	100000