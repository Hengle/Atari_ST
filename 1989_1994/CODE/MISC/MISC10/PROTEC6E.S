;	LEA	$A0500,A0
;	LEA	BOOT,A1
;	MOVE	#(512/4)-1,D0
;LOCK	MOVE.L	(A1)+,(A0)+
;	DBF	D0,LOCK
;	JMP	$A0500


;***********************************************
	OPT	O+,A+,P+

BOOT	;adr supposee de depart=$500
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,D7
	moveq	#0,d3
	OPT	P-,A-
;	MOVE.L	#ADRE,$8.W
	MOVE.L	#$5E2,$8.W
	OPT	P+,A+
	LEA	$70.W,A0
	LEA	VBL,A1
	MOVE.L	A1,(A0)
	MOVE	#$2300,SR
B	JMP	B
YOUPI	JSR	GATO
	jmp	ICI

VBL
  MOVE.B  #$18,D0 
  MOVE    #$2700,SR 
L0004:TST.B   $FFFF8209.W
  BEQ.S     L0004 
  SUB.B   $FFFF8209.W,D0 
  LSR.L   D0,D0 
	MOVE.B	$FFFF8209.W,D1
	NOP
	MOVE.B	$FFFF8209.W,D3
COOL	
	SUB	D1,D3
	LSR	#1,D3
	LSR	#1,D3
	MOVE	D3,D4
	SWAP	D3
	MOVE	D4,D3

	LEA	BUFFER,A0
	ADDQ	#4,2(A0)
	MOVE	#5,D0
CODEa	SUB.L	D3,(A0)+
	DBF	D0,CODEa

BUFFER	INCBIN	CODED.BIN
	DC	$0000
GOGO	MOVE	(a0),D0
	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)

;	LIST

	BRA.S	ICI
	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)

	DC	$2F7C
	LEA	ADR,A2
	MOVE	#$6002,(A2)
	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)

	RESET
	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)

ADR	DC	$2F7C
	BRA.S	SUITE
ICI	;FAIRE ICI UN APPEL BIDON...
	NOP
	MOVE	#0,-(SP)
	MOVE	#789,-(SP)
	MOVE	#1,-(SP)
	LEA	SUITE,A0
	MOVE.L	A0,-(SP)
	MOVE	#2,-(SP)
	MOVE	#4,-(SP)
	TRAP	#13
	ADDA.L	#14,SP
	
SUITE	;D1 CONTIENT LE CODE...
	MOVE	#$10,D4
	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)
	RESET
	DBF	D4,FG
	BRA.S	ICI
FG	JSR	COOLIE
	BRA.S	ICI
ADRE	
	LEA	LECT,A0
	MOVE	#33,D0
COD	SUB.B	D1,(A0)+
	DBF	D0,COD

LECT	
	INCBIN	LECT.COD
	DC.B	1
COOLIE	
	MOVE.L	6(A7),(A7)
	MOVE.L	(A7),A1
	ADD	D3,A1
	ADD	D3,A1
	MOVE.L	A1,(A7)
	RTS
GATO	MOVE	D7,(a0)	ON SUPPOSE D7=0000
	MOVE	D0,(a0)
	RTS
	CLR.L	$0.W
