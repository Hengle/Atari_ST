DEBUT:	MOVEA.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
	MOVE.L 	A5,-(SP)
	MOVE 	#0,-(SP)
	MOVE 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP

	PEA	0.W
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	move.l	#1,d0
	jsr	ZIK

	CLR.W	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	MOVE.L	#7,PNT_BUF
DEC_DIST	LEA	LOGO+34,A0
	LEA	BUF1DEC,A1
	LEA	TAB1DEC,A6
	MOVE.L	A1,(A6)+
	MOVE.W	#155,D6
RECOP2	MOVE.W	#15,D7
RECOP1	MOVE.L	(A0)+,(A1)+
	DBRA	D7,RECOP1
	LEA	96(A0),A0
	CLR.L	(A1)+
	CLR.L	(A1)+
	DBRA	D6,RECOP2
	
	MOVE.W	#6,D4
	LEA	BUF1DEC,A0
DECGEN	LEA	(72*156)(A0),A1
	MOVE.L	A1,(A6)+
	MOVE.W	#(18*156)-1,D7
RECOP3	MOVE.L	(A0)+,(A1)+
	DBRA	D7,RECOP3	
	MOVE.W	#155,D5
DEC3	MOVE.W	#3,D6
DEC2	
	MOVE.W	#8,D7
DEC1	ROXR	(A0)
	ADDQ.L	#8,A0
	DBRA	D7,DEC1
	
	LEA	-8*9(A0),A0
	MOVE.W	#8,D7
DEC1B	ROXR	(A0)
	ADDQ.L	#8,A0
	DBRA	D7,DEC1B

	
	LEA	-70(A0),A0
	DBRA	D6,DEC2
	LEA	64(A0),A0
	DBRA	D5,DEC3
	LEA	-(72*156)(A0),A0
	DBRA	D4,DECGEN


	
	CLR.L	PNT
	CLR.L	PNT2
	MOVE.L	#-8,VALUE2
	MOVE.L	#-8,VALUE


	MOVE.L	#DATA,DATAPNT

	MOVE.L	#FIN,$008.W
	MOVE.L	#FIN,$00C.W
	MOVE.L	#FIN,$010.W

	MOVE.L	#BUFFERSCR,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	MOVE.L	D0,SCREEN
	ADD.L	#345*256,D0
	MOVE.L	D0,SCREEN2
	MOVE.L	D0,SCREENA
	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	MOVE.B	$FFFFFA15.W,MFP7
	MOVE.B	$FFFFFA17.W,MFP8
	MOVE.B	$FFFFFA19.W,MFP9
	MOVE.B	$FFFFFA1F.W,MFP10

	MOVE.L	$68.W,SAUVE_HBL
	MOVE.L	$134.W,SAUVE_TMA
	MOVE.L	#INTER_RTE,$68.W

	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W

	MOVE.B	#$12,$FFFFFC02.W
	DC.W	$A00A

	ANDI.B	#%11111000,$484.W

	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL

	LEA	TEXTE,A0
	MOVE.L	A0,MEM_LET
	MOVE	#1,PART_AFF

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#VBLR,$70.W

	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

BOUCLE	JMP	BOUCLE

VBLR
	CLR.B	$FFFFFA1B.W
	CLR	$FFFF8240.W
;	MOVE.B	#1,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVE.B	#0,$FFFFFA19.W		; PREPARATION DU MFP POUR LE
	MOVE.B	#99,$FFFFFA1F.W		; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W

	
	CLR.L	PLUS3
	ADD.L	#8,VALUE
	MOVE.L	VALUE,D0
	CMPI.L	#29440,D0
	BNE.S	MLML
	CLR.L	VALUE
	MOVE.L	#-29440,PLUS3
MLML

	MOVE.L	DATAPNT,A6	*5
	CMPI.L	#-1,(A6)	*5
	BNE.S	OK2		*3 AVEC D   SINON 2
	MOVE.L	#DATA,DATAPNT	*7
	MOVE.L	DATAPNT,A6	*5
OK2
	MOVE.L	(A6)+,PLUS
	MOVE.L	(A6)+,A5	*3


	MOVE.L	PLUS,D0
	ADD.L	D0,SCREEN1
	MOVE.L	PLUS3,D0
	ADD.L	D0,SCREEN1

	MOVE.B  SCREEN2+1,$FFFF8201.W
	MOVE.B  SCREEN2+2,$FFFF8203.W

	JSR	AFF_FNT


	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	PAS_F1
	SUBQ.L	#1,PNT_BUF
	CMPI.L	#-1,PNT_BUF
	BGT.S	PAS_F1
	MOVE.L	#7,PNT_BUF
	SUBQ.L	#8,X_DEP
PAS_F1
	LEA	TAB1DEC,A0
	MOVE.L	PNT_BUF,D0
	LSL	#2,D0
	ADDA.L	D0,A0
	MOVE.L	(A0),A0
	MOVE.L	ADR_DAR,A1
	LEA	160*7+230*(90-7)(A1),A1
	ADDA.L	X_DEP,A1
	MOVEM.L	A0-A1,PRP_REG

	MOVEM.L	PALETTE,D0-D7
	MOVEM.L	D1-D7,$FFFF8244.W
	SWAP	D0
	MOVE	D0,$FFFF8242.W
	MOVE.L	A6,USP
INTER_RTE	RTE


INTER_TMA:	CLR.B	$FFFFFA07.W		; ARRET DU MFP POUR NE PAS
	CLR.B	$FFFFFA09.W		; ETRE GENE
	MOVE	#$2100,SR		; ON AUTORISE LA HBL
	
full
	LEA	$FFFF8209,A3
	LEA	$FFFF8260,A1
	LEA	$FFFF820A,A0

	MOVEQ	#0,D0
	MOVEQ	#2,D1

	STOP	#$2100		; ATTENTE DE LA PROCHAINE HBL
				; (FIXE A 16 CYCLES PRES ENVIRONS)
	MOVE	#$2700,SR		; ON COUPE TOUTE LES ITs
	MOVE	#$2300,(SP)		; AU RETOUR LE VBL SERA AUTORISEE

	MOVEQ	#29,D2		; ON ATTEND LE BON MOMENT
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D0,(A0)		; ET HOP! PLUS DE BORDER HAUT
	REPT	6
	NOP
	ENDR
	MOVE.B	D1,(A0)

*******
	MOVE.L	USP,A6

	LEA	COLORS,A4
	MOVE	#155,D0  NB LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6

SYNCHR	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHR
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	97-4-4
	NOP	
	ENDR
	CLR	$FFFF8240.W
	JSR	(A5)		*4	T=128
	MOVE.L	(A6)+,A5	*3
	JSR	(A5)
	MOVE.L	(A6)+,A5
	JSR	(A5)
	MOVE.L	(A6)+,A5
	JSR	(A5)
	MOVE.L	(A6)+,A5
	JSR	(A5)
	MOVE.L	(A6)+,A5
	JSR	(A5)

	DCB	7,$4E71


	REPT	13
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	MOVE	(A4)+,$FFFF8240.W
	DCB	89-4,$4E71
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	MOVE	(A4)+,$FFFF8240.W
	DCB	89-4,$4E71
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12-9,$4E71
	MOVEM.L	PRP_REG,A4-A5

ZAPPY	REPT	81-14+1
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	3,$4E71
	MOVE.L	D4,(A5)+	
	MOVE.L	D4,(A5)+	
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13-10-2,$4E71
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	LEA	80+70(A5),A5
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR
;	DBF	D0,ZAPPY

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	89-6*8,$4E71
	MOVE.L	#$00000500,$FFFF8240.W
	MOVE.L	#$01100100,$FFFF8244.W
	MOVE.L	#$02100310,$FFFF8248.W
	MOVE.L	#$04200531,$FFFF824C.W
	MOVE.L	#$06420753,$FFFF8250.W
	MOVE.L	#$07640776,$FFFF8254.W
	MOVE.L	#$05540443,$FFFF8258.W
	MOVE.L	#$03320221,$FFFF825C.W
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71



	REPT	156-(81-14+1)
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	3,$4E71
	MOVE.L	D4,(A5)+	
	MOVE.L	D4,(A5)+	
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13-10-2,$4E71
	MOVE.L	(A4)+,(A5)+
	MOVE.L	(A4)+,(A5)+
	LEA	80+70(A5),A5
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR




	REPT	50
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	89,$4E71
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR

**
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	DCB	89,$4E71

	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	;	ICI=116	NOPS

	CLR.B	$FFFF820A.W 
    REPT 6+2
     	NOP			
     ENDR
;	MOVE.B	#$2,$FFFF820A.W
;	MOVE.B	D3,$FFFF820A.W

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

	MOVE.B	D3,(A0)

	MOVE	#$001,$FFFF8240.W
	DCB	87-4,$4E71
	
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71

	REPT	16
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	89,$4E71
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	13,$4E71
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	12,$4E71
	ENDR

	
	CMPI.L	#1,FLAG
	BNE.S	NON
	MOVE.L	A6,DATAPNT	*5
	CLR.L	FLAG
	BRA.S	OUI
NON	MOVE.L	#1,FLAG
OUI
	JSR	AFF_FNT2

	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2

	MOVE.L	VALUE,D0
	MOVE.L	VALUE2,VALUE
	MOVE.L	D0,VALUE2

	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	adda.l	#216+160*5,a1
	LEA	230+48*2(A1),A1
	CLR.L	(A1)
	CLR.L	4(A1)

	move.l	SCREEN,a1
	ADDA.L	VALUE,A1
	adda.l	#216+160*5,a1
	LEA	230+48*2(A1),A1
	CLR.L	(A1)
	CLR.L	4(A1)
	JSR	ZIK+6

	MOVE	#$2300,SR
	CMPI.B	#$39,$FFFFFC02.W
	BEQ	FIN
	RTE


FIN:	
	MOVE	#$2700,SR
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W
	MOVE.B	MFP7,$FFFFFA15.W
	MOVE.B	MFP8,$FFFFFA17.W
	MOVE.B	MFP9,$FFFFFA19.W
	MOVE.B	MFP10,$FFFFFA1F.W
	MOVE.L	ANC_VBL,$70.W
	MOVE.L	SAUVE_TMA,$134.W
	MOVE.L	SAUVE_HBL,$68.W

	MOVE	#$2300,SR

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W

	BSET	#0,$484.W
	BSET	#1,$484.W
	BSET	#2,$484.W

	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	#2,$FFFF820A.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP
	
	PEA	0.W
	TRAP	#1


TB1_IR
     REPT 127
	NOP			
     ENDR
	MOVE.B	#0,$FFFF820A.W	
     REPT 8
     	NOP			
     ENDR
	MOVE.B	#2,$FFFF820A.W	
	CLR.B	$FFFFFA1B.W
	MOVE.L	#INTER_RTE,$120	
	BCLR	#0,$FFFFFA0F.W	
	RTE			


AFF_FNT
 	ADDQ.L	#1,PNT
	CMPI.L	#11,PNT
	BNE.S	OKAY
	MOVE.L	#1,PNT
OKAY	CMPI.L	#1,PNT
	BEQ	PART1
	CMPI.L	#2,PNT
	BEQ	PART1B
	CMPI.L	#3,PNT
	BEQ	PART2
	CMPI.L	#4,PNT
	BEQ	PART2B
	CMPI.L	#5,PNT
	BEQ	PART3
	CMPI.L	#6,PNT
	BEQ	PART3B
	
	CMPI.L	#7,PNT
	BEQ	PART4
	CMPI.L	#8,PNT
	BEQ	PART4B
	CMPI.L	#9,PNT
	BEQ	PART5
	CMPI.L	#10,PNT
	BEQ	PART5B
R2	RTS


PART5	
	move.l	#IMAGE,a0	3
	move.l	MEM_LET,a2	5
	ADDA.L	(a2),a0		4
	move.l	SCREEN,a1	5
	ADDA.L	VALUE,A1	6
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1	4

	MOVE	#50,D7
AFFT1
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE.B	INC+25(A0),INC2(A1)	5
	MOVE.B	INC+27(A0),INC2+2(A1)
	MOVE.B	INC+29(A0),INC2+4(A1)
	MOVE.B	INC+31(A0),INC2+6(A1)

	MOVE.B	INC+32(A0),INC2+1(A1)
	MOVE.B	INC+34(A0),INC2+3(A1)
	MOVE.B	INC+36(A0),INC2+5(A1)
	MOVE.B	INC+38(A0),INC2+7(A1)
	
	MOVE.B	INC+33(A0),INC2+8(A1)
	MOVE.B	INC+35(A0),INC2+10(A1)
	MOVE.B	INC+37(A0),INC2+12(A1)
	MOVE.B	INC+39(A0),INC2+14(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT1
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS

	
PART4
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREEN,a1
	ADDA.L	VALUE,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	0
INC2	SET	0
	MOVE	#50,D7
;	REPT	81
AFFT2	MOVE.B	INC+17(A0),INC2(A1)
	MOVE.B	INC+19(A0),INC2+2(A1)
	MOVE.B	INC+21(A0),INC2+4(A1)
	MOVE.B	INC+23(A0),INC2+6(A1)

	MOVE.B	INC+24(A0),INC2+1(A1)
	MOVE.B	INC+26(A0),INC2+3(A1)
	MOVE.B	INC+28(A0),INC2+5(A1)
	MOVE.B	INC+30(A0),INC2+7(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT2
	MOVEM.L	A0-A2,SAVEA0A1A2

	RTS


PART3
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREEN,a1
	ADDA.L	VALUE,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT3	MOVE.B	INC+9(A0),INC2(A1)
	MOVE.B	INC+11(A0),INC2+2(A1)
	MOVE.B	INC+13(A0),INC2+4(A1)
	MOVE.B	INC+15(A0),INC2+6(A1)

	MOVE.B	INC+16(A0),INC2+1(A1)
	MOVE.B	INC+18(A0),INC2+3(A1)
	MOVE.B	INC+20(A0),INC2+5(A1)
	MOVE.B	INC+22(A0),INC2+7(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT3

	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS


PART2
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREEN,a1
	ADDA.L	VALUE,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	0
INC2	SET	0
	MOVE	#50,D7
;	REPT	81
AFFT4	MOVE.B	INC+1(A0),INC2(A1)
	MOVE.B	INC+3(A0),INC2+2(A1)
	MOVE.B	INC+5(A0),INC2+4(A1)
	MOVE.B	INC+7(A0),INC2+6(A1)

	MOVE.B	INC+8(A0),INC2+1(A1)
	MOVE.B	INC+10(A0),INC2+3(A1)
	MOVE.B	INC+12(A0),INC2+5(A1)
	MOVE.B	INC+14(A0),INC2+7(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT4
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS

PART1
	move.l	#IMAGE,a0	Pointe sur les fontes
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREEN,a1
	ADDA.L	VALUE,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT5	MOVE.B	INC(A0),INC2+1(A1)
	MOVE.B	INC+2(A0),INC2+3(A1)
	MOVE.B	INC+4(A0),INC2+5(A1)
	MOVE.B	INC+6(A0),INC2+7(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT5
	
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS


PART1B	
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	0
INC2	SET	0
	MOVE	#50,D7
;	REPT	81
AFFT6	MOVEM.L	INC(A0),D0-D1		8
	MOVEM.L	D0-D1,INC2(A1)		7
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT6
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS
PART2B	
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	8
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT7	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT7
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS
PART3B	
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	16
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT8	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT8
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS

PART4B	
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	24
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT9	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT9
	MOVEM.L	A0-A2,SAVEA0A1A2
	RTS

PART5B	
	move.l	#IMAGE,a0
	move.l	MEM_LET,a2
	ADDA.L	(a2),a0
	move.l	SCREENA,a1
	ADDA.L	VALUE2,A1
	MOVE.L	A1,ADR_DAR
	adda.l	#230+216+160*7,a1
INC	SET	32
INC2	SET	0
;	REPT	81
	MOVE	#50,D7
AFFT10	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT10
	MOVEM.L	A0-A2,SAVEA0A1A2
		
	RTS

AFF_FNT2
	CMPI.L	#1,PNT
	BEQ	PART1Z
	CMPI.L	#2,PNT
	BEQ	PART1BZ
	CMPI.L	#3,PNT
	BEQ	PART2Z
	CMPI.L	#4,PNT
	BEQ	PART2BZ
	CMPI.L	#5,PNT
	BEQ	PART3Z
	CMPI.L	#6,PNT
	BEQ	PART3BZ
	
	CMPI.L	#7,PNT
	BEQ	PART4Z
	CMPI.L	#8,PNT
	BEQ	PART4BZ
	CMPI.L	#9,PNT
	BEQ	PART5Z
	CMPI.L	#10,PNT
	BEQ	PART5BZ
	RTS


PART5Z
	MOVEM.L	SAVEA0A1A2,A0-A2
	MOVE	#29,D7
AFFT1Z
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE.B	INC+25(A0),INC2(A1)	5
	MOVE.B	INC+27(A0),INC2+2(A1)
	MOVE.B	INC+29(A0),INC2+4(A1)
	MOVE.B	INC+31(A0),INC2+6(A1)

	MOVE.B	INC+32(A0),INC2+1(A1)
	MOVE.B	INC+34(A0),INC2+3(A1)
	MOVE.B	INC+36(A0),INC2+5(A1)
	MOVE.B	INC+38(A0),INC2+7(A1)
	
	MOVE.B	INC+33(A0),INC2+8(A1)
	MOVE.B	INC+35(A0),INC2+10(A1)
	MOVE.B	INC+37(A0),INC2+12(A1)
	MOVE.B	INC+39(A0),INC2+14(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT1Z
	RTS

	
PART4Z
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	0
INC2	SET	0
	MOVE	#29,D7
;	REPT	81
AFFT2Z	MOVE.B	INC+17(A0),INC2(A1)
	MOVE.B	INC+19(A0),INC2+2(A1)
	MOVE.B	INC+21(A0),INC2+4(A1)
	MOVE.B	INC+23(A0),INC2+6(A1)

	MOVE.B	INC+24(A0),INC2+1(A1)
	MOVE.B	INC+26(A0),INC2+3(A1)
	MOVE.B	INC+28(A0),INC2+5(A1)
	MOVE.B	INC+30(A0),INC2+7(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT2Z
	RTS


PART3Z
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT3Z	MOVE.B	INC+9(A0),INC2(A1)
	MOVE.B	INC+11(A0),INC2+2(A1)
	MOVE.B	INC+13(A0),INC2+4(A1)
	MOVE.B	INC+15(A0),INC2+6(A1)

	MOVE.B	INC+16(A0),INC2+1(A1)
	MOVE.B	INC+18(A0),INC2+3(A1)
	MOVE.B	INC+20(A0),INC2+5(A1)
	MOVE.B	INC+22(A0),INC2+7(A1)

;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT3Z
	RTS


PART2Z
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	0
INC2	SET	0
	MOVE	#29,D7
;	REPT	81
AFFT4Z	MOVE.B	INC+1(A0),INC2(A1)
	MOVE.B	INC+3(A0),INC2+2(A1)
	MOVE.B	INC+5(A0),INC2+4(A1)
	MOVE.B	INC+7(A0),INC2+6(A1)

	MOVE.B	INC+8(A0),INC2+1(A1)
	MOVE.B	INC+10(A0),INC2+3(A1)
	MOVE.B	INC+12(A0),INC2+5(A1)
	MOVE.B	INC+14(A0),INC2+7(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT4Z
	RTS

PART1Z
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	0
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT5Z	MOVE.B	INC(A0),INC2+1(A1)
	MOVE.B	INC+2(A0),INC2+3(A1)
	MOVE.B	INC+4(A0),INC2+5(A1)
	MOVE.B	INC+6(A0),INC2+7(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT5Z
	RTS


PART1BZ	
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	0
INC2	SET	0
	MOVE	#29,D7
;	REPT	81
AFFT6Z	MOVEM.L	INC(A0),D0-D1		8
	MOVEM.L	D0-D1,INC2(A1)		7
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT6Z
	RTS
PART2BZ	
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	8
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT7Z	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT7Z
	RTS
PART3BZ	
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	16
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT8Z	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT8Z
	RTS

PART4BZ	
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	24
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT9Z	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT9Z
	RTS

PART5BZ	
	MOVEM.L	SAVEA0A1A2,A0-A2
INC	SET	32
INC2	SET	0
;	REPT	81
	MOVE	#29,D7
AFFT10Z	MOVEM.L	INC(A0),D0-D1
	MOVEM.L	D0-D1,INC2(A1)
;INC	SET	INC+160
;INC2	SET	INC2+230
;	ENDR
	LEA	160(A0),A0
	LEA	230(A1),A1
	DBF	D7,AFFT10Z
		
	addq.l	#4,a2		On passe � une autre lettre
	cmp.L	#$ffff,(a2)
	bne	GO_LET
	lea	TEXTE,a2
GO_LET:	move.l	a2,MEM_LET	On sauvegarde le pointeur

	RTS




SWAP_SCR:	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1
	move.l	d0,SCREEN2
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	rts
		

NOTHING	
	NOP
	NOP
	DCB	115/5,$2090
	RTS

H70
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	4,$4E71
	DCB	85/5,$2090
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	3,$4E71
	DCB	2,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP			 
	RTS	=4 NOPS
H44
	DCB	4,$4E71
	DCB	90/5,$2090
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	3,$4E71
	DCB	2,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP			 
	RTS	=4 NOPS
H24
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	2,$4E71
	DCB	85/5,$2090
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	3,$4E71
	DCB	2,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	REPT	1+2
	NOP
	ENDR
	RTS	=4 NOPS
H2
	DCB	2,$4E71
	DCB	90/5,$2090
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	3,$4E71
	DCB	2,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	REPT	1+2
	NOP			 
	ENDR
	RTS	=4 NOPS
H80
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	35/5,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	DCB	4,$4E71
	DCB	45/5,$2090
	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	DCB	3,$4E71
	DCB	2,$2090
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)
	NOP			 
	RTS





IMAGE	INCBIN	fontes1.dat
	INCBIN	fontes2.dat
	INCBIN	fontes3.dat
	INCBIN	fontes4.dat
TEXTE	INCBIN	BIG.TXT


	
PALETTE	DC.W	$000,$700,$773,$650,$540,$430,$320,$210
	DC.W	$100,$111,$222,$333,$444,$555,$666,$777


DATA	
	DC.L	-256,NOTHING,NOTHING,NOTHING,NOTHING,NOTHING,NOTHING
	DC.L	256,H44,H44,H44,H44,H44,H44
	DC.L	0,H24,H2,H2,H2,H2,NOTHING
	DC.L	0,H24,NOTHING,NOTHING,NOTHING,NOTHING,NOTHING
	DC.L	0,H80,H44,H2,H70,NOTHING,NOTHING
	DC.L	0,H44,H2,H2,NOTHING,NOTHING,NOTHING
	DC.L	0,H24,H24,NOTHING,NOTHING,NOTHING,NOTHING
	DC.L	0,H80,H70,H2,H2,H70,NOTHING
	DC.L	0,H70,H2,H2,H2,NOTHING,NOTHING
	DC.L	0,H24,H24,H24,NOTHING,NOTHING,NOTHING
	DC.L	0,H44,H44,H2,H2,H2,H2
	DC.L	0,H44,H44,NOTHING,NOTHING,NOTHING,NOTHING
	DC.L	256,H24,H24,H24,H24,NOTHING,NOTHING
	DC.L	-256,H80,H80,H80,H44,H44,NOTHING
	DC.L	0,H70,H44,H2,NOTHING,NOTHING,NOTHING
	DC.L	0,H24,H24,H24,H24,H24,NOTHING
	DC.L	0,H44,H44,H44,H2,H2,NOTHING
	DC.L	0,H70,H24,H44,H2,NOTHING,NOTHING
	DC.L	0,H24,H24,H24,H24,H24,H24
	DC.L	0,H80,H70,H70,H24,H2,H70

	DC.L	256,H70,H70,H24,H2,H2,NOTHING
	DC.L	0,H80,H2,H2,H2,H2,NOTHING	
	DC.L	-256,H80,NOTHING,NOTHING,NOTHING,NOTHING,NOTHING
	DC.L	512,H70,H70,H44,NOTHING,NOTHING,NOTHING
	DC.L	-512,H80,H80,H80,H80,NOTHING,NOTHING
	DC.L	0,H44,H44,H44,H44,H24,NOTHING
	DC.L	512,H70,H70,H70,H2,NOTHING,NOTHING
	DC.L	-512,H80,H80,H80,H80,H24,NOTHING
	DC.L	0,H44,H44,H44,H44,H24,H24
	
	DC.L	512,H70,H70,H24,H24,H44,NOTHING
	DC.L	-256,H80,H80,H80,H80,H24,H24
	DC.L	0,H2,H2,H2,H2,NOTHING,NOTHING

	DC.L	-1,-1

COLORS	DC	$111,$222,$333,$444,$555,$666,$777
	DC	$666,$555,$444,$333,$222,$111,$000
ZIK	INCBIN	SICKEST.MUS
LOGO	INCBIN	DARRIAN.PI1	

	SECTION	BSS
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	
PNT	DS.L	1
PNT2	DS.L	1
SCREENA	DS.L	1
SCREEN	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
MFP7	DS.B	1
MFP8	DS.B	1
MFP9	DS.B	1
MFP10	DS.B	1
	DS.B	256+160
BUFFERSCR	DS.B	345*256*2
	ds.b	256+160
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
DATAPNT	DS.L	1
VALUE2	DS.L	1
VALUE	DS.L	1
ASCREEN2	DS.L	1
ASCREEN1	DS.L	1
PLUS	DS.L	1
PLUS3	DS.L	1
MEM_LET	DS.L	1
PART_AFF	DS.L	1
FLAG	DS.L	1
SAUVE_HBL	DS.L	1
SAUVE_TMA	DS.L	1
TAB1DEC	DS.L	8
BUF1DEC	DS.L	((16+2)*156)*8
X_DEP	DS.L	1
PNT_BUF	DS.L	1
ADR_DAR	DS.L	1
SAVEA0A1A2	DS.L	3
PRP_REG	DS.L	2