	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.W	#6,SP

	MOVE.L	#0,$FFFF8240.W
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEA.L	D7,A0
	MOVEA.L	D7,A1
	MOVEA.L	D7,A2
	MOVEA.L	D7,A3
	MOVEA.L	D7,A4
	MOVEA.L	D7,A5
	MOVEA.L	D7,A6
	LEA	$FFFF8205.W,A5
	MOVEQ	#-1,D1
	MOVE.B	(A5),D0
	MOVE.B	D1,(A5)
	CMP.B	(A5),D0
	BEQ.S	L8006A
	MOVE.B	D0,(A5)
	MOVEA.L	$44E.W,A0
	MOVE.L	A0,D0
	CMP.L	#$78000,D0
	BEQ.S	L8006A
	MOVEA.L	#$4000,A0
	LEA	$70000,A1
	LEA	$71000,A2
	MOVE.L	#$2F4,(A2)
	MOVE.L	#$89E4,(A1)
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEA.L	D0,A5
	BRA.S	L8008E
L8006A	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEA.L	D0,A5
	MOVEA.L	#$60000,A0
	LEA	$70000,A1
	LEA	$71000,A2
	MOVE.L	#$339,(A2)
	MOVE.L	#$89E4,(A1)
L8008E	MOVEM.L	D0-D7/A0-A6,-(A7)
	LSL.W	#2,D0
	LEA	0(A2,D0.W),A2
	LEA	0(A1,D0.W),A1
	MOVE.W	2(A2),D7
	LEA	L8017C(PC),A2
	MOVE.L	(A1),D4
	JSR	L800B0(PC)
	MOVEM.L	(A7)+,D0-D7/A0-A6
	JMP	(A0)
L800B0	MOVEM.L	D0-D7/A0-A6,-(A7)
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	LEA	$FFFF8604.W,A4
	LEA	$FFFF8606.W,A5
	LEA	(A0),A3
	ADDA.L	D4,A3
	MOVE.W	#$A,$A(A2)
L800CC	MOVE.L	D7,D1
	MOVE.L	A0,D0
	BSR.S	L800E8
	LEA	$200(A0),A0
	CMPA.L	A0,A3
	BLS.S	L800E0
	MOVE.L	D1,D7
	ADDQ.W	#1,D7
	BRA.S	L800CC
L800E0	MOVEA.L	(A2),A0
	MOVEM.L	(A7)+,D0-D7/A0-A6
	RTS
L800E8	MOVEQ	#0,D5
	DIVU.W	$A(A2),D7
	MOVE.W	D7,D6
	SWAP	D7
	ADDQ.W	#1,D7
	LSR.W	#1,D6
	ROXL.W	#1,D5
	MOVE.B	#2,D4
	EOR.B	D5,D4
	EORI.B	#7,D4
	MOVE	SR,-(A7)
	MOVE.W	#$2700,SR
	MOVE.B	#$E,$FFFF8800.W
	MOVE.B	$FFFF8800.W,D5
	ANDI.B	#$F8,D5
	OR.B	D5,D4
	MOVE.B	D4,$FFFF8802.W
	MOVE.W	(A7)+,SR
	MOVE.W	#$80,D4
	MOVE.W	#$86,(A5)
	MOVE.W	D6,(A4)
	MOVE.W	D4,(A5)
	MOVE.W	#$13,(A4)
	BSR.S	L8015E
	MOVE.W	#$90,(A5)
	MOVE.W	#$190,(A5)
	MOVE.W	#$90,(A5)
	MOVE.W	#1,(A4)
	MOVE.B	D0,7(A5)
	LSR.L	#8,D0
	MOVE.B	D0,5(A5)
	LSR.L	#8,D0
	MOVE.B	D0,3(A5)
	MOVE.W	#$84,(A5)
	MOVE.W	D7,(A4)
	MOVE.W	D4,(A5)
	MOVE.W	D4,(A4)
	BSR.S	L8015E
	RTS
L8015E	BTST	#5,$FFFFFA01.W
	BNE.S	L8015E
	RTS
	DC.L	0
	DC.L	0
	DC.L	0
	DC.L	0
	DC.L	0
L8017C	DC.L	0
