	
	OPT	O+,A+,P+
	St	$FFFF8240.W
	BSR.S	INIT
	MOVE	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.B	#$2,$FFFF820A.W
	MOVE.B	#$2,$FFFF8260.W
	MOVE.L	#$5A617021,$24.W
	MOVE.L	#$2A34322A,$C.W
	OPT	P-,A-,O-
	LEA	$40074,A0
	OPT	P+,A+,O+
	LEA	PRG,A1
	MOVE	#511,D1
LOCK	MOVE.B	(A1)+,(A0)+
	DBF	D1,LOCK
	OPT	P-,A-,O-
	MOVE.L	#$40074,$70.W
	JMP	$40076
	OPT	P+,A+,O+
INIT	
	MOVE	SR,D6
	MOVE.B	$FFFFFC02.W,D0
	MOVE.B	#$13,$FFFFFC02.W
	ADD.B	#42,D2
	RTS
TRUC_A_CODER
	INCBIN	CODED.COD
PRG	RTE
PRG2	MOVEQ	#(308/4)-1,D1
	OPT	A-,P-
	LEA	$175A.W,A0
	LEA	$50600,A1
	OPT	A+,P+
AICI	ADD.L	$24.W,D5
;	ADD.L	$70.W,D5
	ADD.L	$C.W,D5
	ADD	D6,D5
	ADD.B	D2,D5
	ADD.B	D0,D5
	ADD.L	D5,(A0)
	MOVE.L	(A0)+,(A1)+
	DBF	D1,AICI
	CLR.B	$FFFF8260.W
	MOVE.L	(A0)+,(A1)+
	opt	o-,p-,a-
	JMP	$50600
