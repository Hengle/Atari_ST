	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.B	#$12,$FFFFFC02.W
	ANDI.B	#%11111000,$484.W

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,SAUV_PAL
	MOVEM.L	SPR+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	MOVEQ	#6,D0
	JSR	MUZAXX
	
	BSR	PR_EQUA

	JSR	MUZAXX+8
	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W
		
BOUCLE	JMP	BOUCLE

FIN	MOVE.L	ANC_VBL,$70.W

	MOVE.B	#8,$FFFFFC02.W
	
	MOVEM.L	SAUV_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	BSET	#2,$484.W
	BSET	#1,$484.W
	BSET	#0,$484.W
	
	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
	*******   V B L  &  P R O C E D U R E S   *******
VBLR	
	MOVE.W	#$700,$FFFF8240.W
	BSR	EQUA
	MOVE.W	SPR+2,$FFFF8240.W
	JSR	MUZAXX+8
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
	
EQUA	
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	LEA	CORES_SPR,A0
	LEA	CORES_SPR,A1
	LEA	CORES_SPR,A2
	MOVE.B	#8,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D0
	MOVE.B	#9,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D1
	MOVE.B	#$A,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D2
	LSL.W	#2,D0
	LSL.W	#2,D1
	LSL.W	#2,D2
	ADDA.L	D0,A0
	ADDA.L	D1,A1
	ADDA.L	D2,A2
	MOVE.L	(A0),A4
	MOVE.L	(A1),A5
	MOVE.L	(A2),A6
	MOVE.L	$44E.W,A3	
N	SET	0
	REPT	61
	MOVEM.L	N(A4),D0-D5
	MOVEM.L	D0-D5,N+8+(9*160)(A3)
	MOVEM.L	N(A5),D0-D5
	MOVEM.L	D0-D5,N+64+(9*160)(A3)
	MOVEM.L	N(A6),D0-D5
	MOVEM.L	D0-D5,N+120+(9*160)(A3)
N	SET	N+160
	ENDR
	RTS
	
PR_EQUA	MOVE.L	#SPR+34+112+(160*127),A0
	MOVE.L	$44E.W,A1
	BSR	PR_AFF
	MOVE.L	#SPR+34+112+(160*127),A0
	MOVE.L	$44E.W,A1
	ADDA.L	#56,A1
	BSR	PR_AFF
	MOVE.L	#SPR+34+112+(160*127),A0
	MOVE.L	$44E.W,A1
	ADDA.L	#112,A1
	BSR	PR_AFF
	RTS
	
PR_AFF
INC	SET	0
	REPT	72
	MOVEM.L	INC(A0),D0-D7/A2-A5
	MOVEM.L	D0-D7/A2-A5,INC(A1)
INC	SET	INC+160
	ENDR
	RTS	

	SECTION	DATA
MUZAXX	INCBIN	MANY.MUS
SPR	INCBIN	SPRITES2.PI1

CORES_SPR	DC.L	SPR+34+160,SPR+34+160+24,SPR+34+48+160,SPR+34+72+160,SPR+34+96+160,SPR+34+120+160
	DC.L	SPR+34+(160*63),SPR+34+(160*63)+24,SPR+34+(160*63)+48,SPR+34+(160*63)+72,SPR+34+(160*63)+96,SPR+34+(160*63)+120
	DC.L	SPR+34+(160*125),SPR+34+(160*125)+24,SPR+34+(160*125)+48,SPR+34+(160*125)+48
	
	SECTION	BSS
SAUV_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1