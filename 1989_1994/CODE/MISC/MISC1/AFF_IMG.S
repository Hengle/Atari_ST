	CLR.L	-(SP)
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W
	MOVE.L	#FIN,$014.W


	CLR	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE	#5,-(SP)
	TRAP	#14
	ADDA.L	#12,SP
	

	LEA	$F8000,A0
	LEA	DATA+34,A1
	MOVE.L	#7999,D0
ICI	MOVE.L	(A1)+,(A0)+
	DBF	D0,ICI


	
	
	MOVE.L	$70.W,SAVEVBL
	MOVE.L	#VBL,$70.W
	
LOOP	JMP	LOOP


VBL	

	CLR	$FFFF825C.W

	MOVEM.L	DATA+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$FFFF8209,A3	
	MOVE.L	#$FFFF8260,A1	
	MOVE.L	#$FFFF820A,A0	
	MOVE	#9,D0		* NB DE LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6
	MOVE	#$2700,SR
	
	LEA	PALETTE,A6	*3

SYNCHRO	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	97
	NOP	
	ENDR
	
	
	REPT	199
	MOVE	(A6)+,$FFFF825C.W
	DCB	124,$4E71
	ENDR





	CLR	$FFFF8240.W
	CMPI.B	#$39,$FFFFFC02.W
	BEQ.S	FIN
	RTE
	
	
	
FIN	MOVE.L	SAVEVBL,$70.W
	move	#$777,$ffff8240.w
	clr	$ffff8242.w
	CLR.L	-(SP)
	TRAP	#1	


	SECTION	DATA

DATA	INCBIN	OVERSCA2.PI1
	
	
PALETTE	

	DC	$000,$100,$200,$300,$400,$500,$600,$700
	DC	$710,$720,$730,$740,$750,$760
	DC	$761,$762


	DCB	200,$763
	
	SECTION	BSS
SAVEVBL	DS.L	1
