; ********************************************
; * ROUTINE BOOTSECTEUR DU JEU KARATE KID II *
; ********************************************

TEXT:
	LEA	$5FFF0,A7
	MOVE.W	#$2700,SR		; IPL 7

	CLR.W	$FF8240		; COULEUR 0 = NOIR

	LEA	$FF8606,A6		; DMAMODE DANS A6

	LEA	$60000,A4		; ADRESSE D'UNE ROUTINE

	MOVEQ	#5,D0

	MOVE	SR,-(A7)		; SAUVER LE SR
	ORI.W	#$700,SR
	MOVE.B	#$E,$FFFF8800.W	; SELECTION DU PORT PARALLELE
	MOVE.B	$FFFF8800.W,D1	; LECTURE
	MOVE.B	D1,D2		; SAUVE D1 DANS D2
	ANDI.B	#$F8,D1		; CLEAR BIT 0,1,2 (LECTEUR DE DISK)
	OR.B	D1,D0		; SELECTION DRIVE 0 / FACE 0
	MOVE.B	D0,$FFFF8802.W	; ECRITURE
	MOVE.W	(A7)+,SR		; RESTAURER LE SR

	MOVE.W	#$80,(A6)		; SELECTION DU COMMAND
				; REGISTER DU FDC
	BSR	READ_STATUS

	MOVE.L	#$60000,D7

	MOVE.W	#$86,(A6)		; SELECTION DU DATA REGISTER
	MOVEQ	#8,D0		; ENVOIE PISTE 8
	BSR	WD_WRITE		; EXECUTER LA COMMANDE

	MOVE.W	#$80,(A6)
	MOVE.W	#$13,D0
	BSR	WD_WRITE
	BSR	WAIT_DONE
	MOVEQ	#1,D6

SUITE:	MOVE.W	#$84,(A6)		; SELECTION DU SECTOR REGISTER
	MOVE.W	D6,D0		; SECTEUR DANS D0
	BSR	WD_WRITE

	MOVE.L	A4,D0		; SET_DMA
	MOVE.B	D0,$FFFF860D.W	; LOW-DMA
	LSR.L	#8,D0
	MOVE.B	D0,$FFFF860B.W	; MID-DMA
	LSR.L	#8,D0
	MOVE.B	D0,$FFFF8609.W	; HIGH-DMA

	MOVE.W	#$80,(A6)		; SELECTION DU COMMAND REGISTER
	BSR	READ_STATUS
	MOVE.L	#$60000,D7

	MOVE.W	#$90,(A6)		; DMA_IN
	MOVE.W	#$190,(A6)
	MOVE.W	#$90,(A6)
	MOVE.W	#1,D0		; 1 SECTEUR A LIRE
	BSR.S	WD_WRITE

	MOVE.W	#$80,(A6)
	MOVE.W	#$80,D0
	BSR.S	WD_WRITE		; READ SECTOR

	BSR	WAIT_DONE
	ANDI.B	#$1C,D0
	BNE.S	L27582

	MOVE.W	#$90,(A6)		; SELECTION DU DMA SECTOR COUNT
	MOVE.W	(A6),D0		; REGISTER
	BTST	#0,D0
	BNE.S	L27584

L27582:	BRA.S	SUITE

L27584:	MOVE.W	#$222,$FF8240
	ADDA.L	#$200,A4		; + 512 OCTETS : 1 SECTEUR LU
	ADDQ.W	#1,D6
	CMPI.W	#6,D6
	BNE.S	SUITE
	MOVE.W	#$660,$FF8240
	JMP	$60000

WD_WRITE:	BSR.S	ATTEND
	MOVE.W	D0,$FFFF8604.W
	BRA.S	ATTEND

READ_STATUS:
	BSR.S	ATTEND
	MOVE.W	$FFFF8604.W,D0

ATTEND:	MOVE	SR,-(A7)
	MOVE.W	D7,-(A7)
	MOVEQ	#$20,D7
ATTEND1:	DBF	D7,ATTEND1
	MOVE.W	(A7)+,D7
	MOVE.W	(A7)+,SR
	RTS

FDC_RESET:	MOVE.W	#$80,(A6)
	MOVE.W	#$D0,D0
	BSR.S	WD_WRITE
	BSR.S	ATTEND
	BSR.S	ATTEND
	BSR.S	ATTEND
	BSR.S	ATTEND
	BSR.S	READ_STATUS
	RTS

	MOVE.W	#$80,(A6)
	BSR.S	READ_STATUS
	MOVE.W	#3,D0
	BSR.S	WD_WRITE
	RTS

WAIT_DONE:	SUBQ.L	#1,D7
	BEQ.S	ERREUR
	BTST	#5,$FFFA01		; COMMANDE TERMINEE ?
	BNE.S	WAIT_DONE		; NON
	BRA.S	READ_STATUS

ERREUR:	BSR.S	FDC_RESET
	MOVEQ	#-1,D0
	RTS
