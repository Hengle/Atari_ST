	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP

	CLR	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP
	
	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W
	LEA	BUF,A0
	LEA	P1+34,A1
	LEA	P2+34,A2
	MOVE	#7999,D0
COP	MOVE.L	(A1)+,(A0)+
	DBF	D0,COP
	LEA	-160(A0),A0
	MOVE	#7999,D0
COPY	MOVE.L	(A2)+,(A0)+
	DBF	D0,COPY

	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#32000,D0
	MOVE.L	D0,SCREEN2

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.L	#TB0_IR,$120.W
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	MOVE.L	#VBL,$70.W
J	BRA.S	J
FIN	MOVE.L	4.W,A0
	JMP	(A0)

VBL	MOVEM.L	P1+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	CLR.B	$FFFFFA1B.W
MOD2	EQU	*+3
	MOVE.B	#230,$FFFFFA21.W
	MOVE.B	#8,$FFFFFA1B.W

	MOVE.L	SCREEN1,A1
	LEA	BUF,A0
MOD	EQU	*+2
	ADDA.L	#0,A0
N	SET	0
	REPT	200
	MOVEM.L	N(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N(A1)
	MOVEM.L	N+13*4(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N+13*4(A1)
	MOVEM.L	N+13*4*2(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N+13*4*2(A1)
	MOVE.L	N+13*4*3(A0),N+13*4*3(A1)
N	SET	N+160
	ENDR
	
	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	NO_F1
	ADD.L	#160*2,MOD
	SUBQ.B	#2,MOD2
NO_F1	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	NO_F2
	SUB.L	#160*2,MOD
	ADDQ.B	#2,MOD2
NO_F2
JJ3	move.l	SCREEN1,d0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)

	RTE


TB0_IR	
	CLR.B	$FFFFFA1B.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
;	MOVE.L	#TB0_IR,$120
	MOVEM.L	D0-D7,-(SP)
	MOVEM.L	P2+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
;	CLR	$FFFF8240.W
	MOVEM.L	(SP)+,D0-D7
	BCLR	#0,$FFFFFA0F.W
	RTE			

	DATA
P1	INCBIN	GOKU1.PI1
P2	INCBIN	GOKU2.PI1
	BSS
	DS.B	256
BUFFER	DS.B	64000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
BUF	DS.B	64000