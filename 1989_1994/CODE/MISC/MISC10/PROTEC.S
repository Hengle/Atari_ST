	OPT	O+,P+,A+
	
	PEA	0.W
	MOVE	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
;************************************************
	
	LEA	$FFFF8000.W,a0
	MOVE	(a0),d1
	MOVE	d2,(a0)	ON SUPPOSE D2=0000
	MOVE	d1,(a0)

;	LIST

	BRA.S	ICI
	MOVE	d2,(a0)	ON SUPPOSE D2=0000
	MOVE	d1,(a0)

	DC	$237C
	MOVE	d2,(a0)	ON SUPPOSE D2=0000
	LEA	ADR,A2
	MOVE	#$0000,(A2)
	MOVE	d1,(a0)
	RESET
ADR	DC	$237C
	BRA.S	SUITE
ICI	;FAIRE ICI UN APPEL BIDON...
	NOP
SUITE	
	PEA	0.W
	TRAP	#1

;	MOVE.L	(A7)+,A0	=RTS
;	JMP	(A0)


