	RSRESET
BUF_ROTATE	RS.B	68*256
ADR_FONTES	RS.W	(1+16)*26
BUF_FONTES	RS.B	100000
LONG_BSS	RS.B	1

	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.W	#6,SP

	CLR.W	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	BSR	PREPARE_ROTATE
	BSR	PREP_ECR

	LEA	ADR_FONTES(A6),A0
	MOVE.L	SCREEN1,A1
	MOVE.W	(A0)+,D0
	MOVE.L	(A0)+,A2
	BSR	AFF_FONT

J	JMP	J

AFF_FONT	MOVE.W	D0,D1
	ADDQ.W	#1,D1
	LSL.W	#3,D1
	MOVE.W	#160,D2
	SUB.W	D1,D2
	MOVE.W	D2,CHG_1
	MOVEQ	#7,D2
.AFF_Y	MOVE.W	D0,D1
.AFF_X	MOVE.W	(A2)+,(A1)
	ADDQ.W	#8,A1
	DBRA	D1,.AFF_X
CHG_1 = *+2
	LEA	$1234(A1),A1
	DBRA	D2,.AFF_Y
	RTS

PREPARE_ROTATE	LEA	BUF_BSS,A6
	LEA	Y_AND_Z(PC),A3
	LEA	BUF_ROTATE(A6),A1
	LEA	COEFF_3D(PC),A2
.NEXT_Y_Z	MOVE.W	(A3)+,D0	;Y
	MOVE.W	(A3)+,D1	;Z
	ADD.W	D1,D1
	MOVE.W	(A2,D1.W),D1	;D1=COEFF 3D * 2^15
	MULU.W	#160,D0
	MOVE.W	D0,(A1)+	;ON POSE LE Y*160
	MOVEQ	#0,D0
	MOVE.W	#512*2,D0	;LONGUEUR EN X DE 16 LETTRES
	MULS.W	D1,D0
	ASR.L	#7,D0
	DIVS.W	#16,D0	;LONGUEUR EN X DE CHAQUE LETTRE*256
	MOVE.W	D0,(A1)+	;LONGUEUR DE CHAQUE LETTRE

	MOVE.L	#-512,D3
	MOVEQ	#15,D7
._16_X_DEPART	MOVE.L	D3,D2
	MULS.W	D1,D2
	ASR.L	#7,D2	;X_ECRAN DE DEPART*256
	MOVE.L	D2,(A1)+
	SUBQ.L	#4,D3
	DBRA	D7,._16_X_DEPART

	CMPI.W	#$1234,(A3)
	BNE.S	.NEXT_Y_Z

	LEA	FONTES(PC),A0
	LEA	BUF_FONTES(A6),A1
	LEA	ADR_FONTES(A6),A3
	MOVE.W	(A0)+,D7	;D7=NB DE BLOCS DE 16 -1
	MOVE.W	D7,(A3)+
	MOVE.L	A0,(A3)+
	MOVEQ	#6,D3
.DEC_GEN	MOVE.L	A1,(A3)+
	MOVE.L	A1,A4
	MOVEQ	#7,D4
.DEC_Y	MOVE.W	D7,D6
	MOVEQ	#0,D5
.DEC_X	MOVEQ	#0,D0
	MOVE.W	(A0)+,D0
	ROR.L	#1,D0
	OR.W	D5,D0
	MOVE.W	D0,(A1)+
	SWAP	D0
	MOVE.W	D0,D5
	DBRA	D6,.DEC_X
	MOVE.W	D5,(A1)+
	DBRA	D4,.DEC_Y
	MOVE.L	A4,A0
	DBRA	D3,.DEC_GEN
	RTS

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREP_ECR	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

Y_AND_Z	INCBIN	ROTATE.DAT
	DC.W	$1234

COEFF_3D	INCBIN	COEFF.DAT

HAUTEURS	INCBIN	HAUTEURS.DAT

FONTES	INCBIN	ROTATE.FNT

	SECTION	BSS
	DS.B	256
BUFFER	DS.B	64000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
BUF_BSS	DS.B	LONG_BSS