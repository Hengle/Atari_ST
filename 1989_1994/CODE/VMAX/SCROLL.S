	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAUV_SP
	
	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	MOVE.L	#FIN,$008
	MOVE.L	#FIN,$00C
	MOVE.L	#FIN,$010
	MOVE.L	#FIN,$014
	MOVE.L	#FIN,$018
	MOVE.L	#FIN,$01C
	MOVE.L	#FIN,$020
	MOVE.L	#FIN,$024
	
	ANDI.B	#%11111000,$484.W
	
	MOVE.B	$FFFF8201.W,SAUVEC
	MOVE.B	$FFFF8203.W,SAUVEC+1
	
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	MOVEM.L	FONT1+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	BSR	PREP_ECR
	MOVE.L	#FONT1+34+(160*64)+96,SOV_LET
	CLR.L	POS_LET
	CLR.B	SCRP1

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W
	
LOOP	JMP	LOOP

FIN	MOVE.L	ANC_VBL,$70.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	MOVE.B	SAUVEC,$FFFF8201.W
	MOVE.B	SAUVEC+1,$FFFF8203.W
	
	ORI.B	#%00000111,$484.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
	*******	V B L  &  P R O C E D U R E S   *******
VBLR	;MOVE.W	#$700,$FFFF8240.W
	MOVE.L	SCREEN2,A0
	ADDA.L	#168*160,A0
	BSR	DECAL
	CMPI.B	#1,SCRP1
	BLO	PART1
	BEQ	PART2
	CMPI.B	#3,SCRP1
	BLO	PART3
	BEQ	PART4
SUITV0	BSR	SWAPEC
	MOVE.W	#$000,$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE
	
DECAL	
N	SET	0
	REPT	32
	MOVEM.L	N+8(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N(A0)
	MOVEM.L	N+60(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N+52(A0)
	MOVEM.L	N+112(A0),D0-D7/A2-A5
	MOVEM.L	D0-D7/A2-A5,N+104(A0)
N	SET	N+160
	ENDR
	RTS

PART1	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(168*160),A1
N	SET	0
	REPT	32
	MOVE.B	N+9(A0),N(A1)
	MOVE.B	N+11(A0),N+2(A1)
	MOVE.B	N+13(A0),N+4(A1)
	MOVE.B	N+15(A0),N+6(A1)
N	SET	N+160
	ENDR
	BSR	NEW_LET1
	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#153+(168*160),A1
N	SET	0
	REPT	32
	MOVE.B	N(A0),N(A1)
	MOVE.B	N+2(A0),N+2(A1)
	MOVE.B	N+4(A0),N+4(A1)
	MOVE.B	N+6(A0),N+6(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0

PART2	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(168*160),A1
N	SET	0
	REPT	32
	MOVE.L	N(A0),N(A1)
	MOVE.L	N+4(A0),N+4(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0

PART3	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(168*160),A1
N	SET	0
	REPT	32
	MOVE.B	N+1(A0),N(A1)
	MOVE.B	N+8(A0),N+1(A1)
	MOVE.B	N+3(A0),N+2(A1)
	MOVE.B	N+10(A0),N+3(A1)
	MOVE.B	N+5(A0),N+4(A1)
	MOVE.B	N+12(A0),N+5(A1)
	MOVE.B	N+7(A0),N+6(A1)
	MOVE.B	N+14(A0),N+7(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	SUITV0
	
PART4	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(168*160),A1
N	SET	0
	REPT	32
	MOVE.L	N+8(A0),N(A1)
	MOVE.L	N+12(A0),N+4(A1)
N	SET	N+160
	ENDR
	CLR.B	SCRP1
	BRA	SUITV0
	
NEW_LET1	LEA	TEXT1,A0
	ADDA.L	POS_LET,A0
	CMPI.B	#$FF,(A0)
	BNE	SUITNL1
	CLR.L	POS_LET
	LEA	TEXT1,A0
SUITNL1	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	LSL.W	#2,D0
	LEA	CORES1,A1
	ADDA.L	D0,A1
	MOVE.L	(A1),SOV_LET
	ADDQ.L	#1,POS_LET
	RTS
	
SWAPEC	MOVE.L	SCREEN2,D0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
	
PREP_ECR	MOVE.L	#BUFFER,D0
	ANDI.B	#0,D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS
	
	SECTION	DATA
FONT1	INCBIN	Fontes2.PI1

TEXT1	DC.B	" A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	DC.B	" ! . ? ' 0 1 2 3 4 5 6 7 8 9 ( ) - , : "
	DC.B	$FF
	EVEN

CORES1	
	DC.L	FONT1+34+(160*132)	*ESP
	DC.L	FONT1+34+(160*66)+96	*!
	DC.L	FONT1+34+(160*132)	*"
	DC.L	FONT1+34+(160*132)	*#
	DC.L	FONT1+34+(160*132)	*$
	DC.L	FONT1+34+(160*132)	*%
	DC.L	FONT1+34+(160*132)	*&
	DC.L	FONT1+34+(160*66)+144	*'
	DC.L	FONT1+34+(160*132)+16	*(
	DC.L	FONT1+34+(160*132)+32	*)
	DC.L	FONT1+34+(160*132)	**
	DC.L	FONT1+34+(160*132)	*+
	DC.L	FONT1+34+(160*132)+64	*,
	DC.L	FONT1+34+(160*132)+48	*-
	DC.L	FONT1+34+(160*66)+112	*.
	DC.L	FONT1+34+(160*132)	*/
	DC.L	FONT1+34+(160*99)	*0
	DC.L	FONT1+34+(160*99)+16	*1
	DC.L	FONT1+34+(160*99)+32	*2
	DC.L	FONT1+34+(160*99)+48	*3
	DC.L	FONT1+34+(160*99)+64	*4
	DC.L	FONT1+34+(160*99)+80	*5
	DC.L	FONT1+34+(160*99)+96	*6
	DC.L	FONT1+34+(160*99)+112	*7
	DC.L	FONT1+34+(160*99)+128	*8
	DC.L	FONT1+34+(160*99)+144	*9
	DC.L	FONT1+34+(160*132)+80	*:
	DC.L	FONT1+34+(160*132)	*;
	DC.L	FONT1+34+(160*132)	*
	DC.L	FONT1+34+(160*132)	*=
	DC.L	FONT1+34+(160*132)	*
	DC.L	FONT1+34+(160*66)+128	*?
	DC.L	FONT1+34+(160*132)	*@
	
	DC.L	FONT1+34,FONT1+34+16,FONT1+34+32,FONT1+34+48,FONT1+34+64,FONT1+34+80,FONT1+34+96,FONT1+34+112,FONT1+34+128,FONT1+34+144
	DC.L	FONT1+34+(160*33),FONT1+34+(160*33)+16,FONT1+34+(160*33)+32,FONT1+34+(160*33)+48,FONT1+34+(160*33)+64,FONT1+34+(160*33)+80,FONT1+34+(160*33)+96,FONT1+34+(160*33)+112,FONT1+34+(160*33)+128,FONT1+34+(160*33)+144
	DC.L	FONT1+34+(160*66),FONT1+34+(160*66)+16,FONT1+34+(160*66)+32,FONT1+34+(160*66)+48,FONT1+34+(160*66)+64,FONT1+34+(160*66)+80
	
	SECTION	BSS
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
POS_LET	DS.L	1
SOV_LET	DS.L	1
SCRP1	DS.B	1
	EVEN
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.L	16000
	DS.B	256
SAUVEC	DS.W	1	