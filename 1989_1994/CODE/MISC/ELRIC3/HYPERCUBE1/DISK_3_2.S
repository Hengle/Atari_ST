;FEUX D'ARTIFICE
;NB_STARS = 50
X_DEP = 0
Y_DEP = 0

	RSRESET
	;MAX_Y,X,Y,Z
BUF_COOR	RS.L	4*150
PT_1	RS.L	1
ADR_EFF_FEUX	RS.L	1
BUF_PRECALC	RS.B	300000
LONG_BSS_FEUX	RS.B	1

MAIN	
;	CLR.L	-(SP)
;	MOVE.W	#$20,-(SP)
;	TRAP	#1
;	ADDQ.W	#6,SP

;	MOVEQ	#6,D7
;	MOVE.W	#$2100,SR
;.LOW	STOP	#$2100
;	CLR.B	$FFFF8260.W
;	DBRA	D7,.LOW

;	BSR	PREP_ECR

	MOVE.L	A0,ADR_ZIK1
	MOVE.L	A1,SCREEN1
	MOVE.L	A2,SCREEN2
	MOVE.L	A6,ADR_FIN

	MOVE.W	#150,NB_STARS
	BSR	PREPARE_FONTAINE
	MOVE.W	#$752,$FFFF8242.W
	CLR.W	PT_ETAPES
	MOVE.L	#BSS_TOUT_COURT+BUF_PRECALC,BSS_TOUT_COURT+PT_1
	MOVE.L	#BSS_TOUT_COURT+BUF_PRECALC,BSS_TOUT_COURT+ADR_EFF_FEUX

	MOVE.W	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.W	NB_VBL
	MOVE.W	#-1,TIMER_FEUX
	MOVE.L	#VBLR,$70.W
	MOVE.W	#$2300,SR

VBL	BSR	VSYNC
	TST.W	TIMER_FEUX
	BLT.S	.PAS_FADE
	BGT.S	.PAS_ENCORE
	MOVE.W	#3,TIMER_FEUX
	MOVE.L	PT_FADE_FEUX,A0
	MOVE.W	(A0)+,$FFFF8242.W
	CMPI.W	#$1234,(A0)
	BNE.S	.PAS_FIN
	BRA.S	.FINI_FEUX
.PAS_FIN	MOVE.L	A0,PT_FADE_FEUX
.PAS_ENCORE	SUBQ.W	#1,TIMER_FEUX

.PAS_FADE	BSR	PUT_FEUX

	BSR	SWAPEC

	BRA	VBL

.FINI_FEUX	
	MOVE.W	#$2700,SR
ADR_FIN = *+2
	LEA	$12345678,A0
	JMP	(A0)

VSYNC	CMPI.W	#1,NB_VBL
	BLT.S	VSYNC
	CLR.W	NB_VBL
	RTS

VBLR	ADDQ.W	#1,NB_VBL
	MOVEM.L	D0-A6,-(SP)
ADR_ZIK1 = *+2
	JSR	$12345678
	MOVEM.L	(SP)+,D0-A6
	RTE

PUT_FEUX	MOVE.L	BSS_TOUT_COURT+ADR_EFF_FEUX,A0
	MOVE.L	SCREEN2,A1
	MOVEQ	#0,D1
	MOVE.W	(A0)+,D7
.EFF	ADDQ.W	#2,A0
	MOVE.W	(A0)+,D0
	MOVE.W	D1,(A1,D0.W)
	DBRA	D7,.EFF
	MOVE.L	BSS_TOUT_COURT+PT_1,A0
	MOVE.L	A0,BSS_TOUT_COURT+ADR_EFF_FEUX
	MOVE.W	(A0)+,D7
	ADDQ.W	#1,D7
	ADD.W	D7,D7
	ADD.W	D7,D7
	ADDA.W	D7,A0
;	CMPI.L	#$12345678,(A0)
;	BNE.S	.OK
;	LEA	BSS_TOUT_COURT+BUF_PRECALC,A0
.OK	MOVE.L	A0,BSS_TOUT_COURT+PT_1
	MOVE.W	(A0)+,D7	;NB DE PNTS -1
.AFF	MOVE.W	(A0)+,D0
	MOVE.W	(A0)+,D1
	OR.W	D0,(A1,D1.W)
	DBRA	D7,.AFF
	ADDQ.W	#1,PT_ETAPES
	CMPI.W	#250-30,PT_ETAPES
	BNE.S	.TROP_PETIT
	MOVE.L	#PAL_FEUX,PT_FADE_FEUX
	CLR.W	TIMER_FEUX
.TROP_PETIT	RTS

PAL_FEUX	DC.W	$752,$641,$530,$420,$310,$200,$100,0,$1234

EFF_SCR	MOVE.W	#7999,D7
.EFF	CLR.L	(A0)+
	DBRA	D7,.EFF
	RTS

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREP_ECR	MOVE.L	#BUFFER,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREPARE_FONTAINE
	LEA	BSS_TOUT_COURT+BUF_PRECALC,A5

	LEA	BUF_COEFF+(1024*2)+2,A2
	MOVE.W	#256+1024,D0
	MOVE.L	#256*$8000,D6
.RECOM_PUT	MOVE.L	D6,D5
	DIVU.W	D0,D5
	MOVE.W	D5,-(A2)
	CMPI.W	#256,D0
	DBLE 	D0,.RECOM_PUT
	SUBQ.W	#1,(A2)

	LEA	BSS_TOUT_COURT+BUF_COOR,A0
	LEA	DESCRIPT(PC),A1
	MOVE.W	NB_STARS,D7
	SUBQ.W	#1,D7
.R	MOVE.L	(A1)+,(A0)+
	LEA	12(A1),A1
	MOVE.L	#X_DEP,(A0)+	;ACT_X
	MOVE.L	#Y_DEP,(A0)+	;ACT_Y
	MOVE.L	#0,(A0)+	;ACT_Z
	DBRA	D7,.R

	MOVE.W	#249,D6
RECOM_BCL	LEA	BSS_TOUT_COURT+BUF_COOR,A0
	LEA	CORES_X(PC),A3
	LEA	CORES_Y(PC),A4
	LEA	BUF_COEFF+506+200,A1
	MOVEQ	#0,D5
	MOVE.L	A5,A6
	ADDQ.W	#2,A5
	MOVE.W	NB_STARS,D7
	SUBQ.W	#1,D7
.REPEAT	ADDQ.W	#4,A0
	MOVE.L	(A0)+,D0	;X
	MOVE.L	(A0)+,D1	;Y
	MOVE.L	(A0)+,D2	;Z
	SWAP	D0
	;ON LAISSE LE Y
	SWAP	D2
	
	ADD.W	D2,D2
	MOVE.W	(A1,D2.W),D2	;COEFFICIENT 3D
	
	ADD.W	D0,D0	;*2
;	ADD.W	D1,D1	;*2
	MULS.W	D2,D0	;X
	MULS.W	D2,D1	;Y
	SWAP	D0
	SWAP	D1
	ADDI.W	#160,D0
	BLT.S	.PAS_AFF
	CMPI.W	#320,D0
	BGE.S	.PAS_AFF
	ADDI.W	#100,D1
	BLT.S	.PAS_AFF
	CMPI.W	#200,D1
	BGE.S	.PAS_AFF
	ADD.W	D0,D0	;*4
	ADD.W	D0,D0
	ADD.W	D1,D1	;*2
	MOVE.W	2(A3,D0.W),D2
	ADD.W	(A4,D1.W),D2
	MOVE.W	(A3,D0.W),D0
	MOVE.W	D0,(A5)+
	MOVE.W	D2,(A5)+
	ADDQ.W	#1,D5
.PAS_AFF	DBRA	D7,.REPEAT

	SUBQ.W	#1,D5
	BGE.S	.OK
	CLR.W	(A6)
	CLR.L	(A5)+
	BRA.S	.NOW
.OK	MOVE.W	D5,(A6)	;POUR LE DBRA .
.NOW
	LEA	DESCRIPT(PC),A0
	LEA	BSS_TOUT_COURT+BUF_COOR,A1
	MOVE.W	NB_STARS,D7
	SUBQ.W	#1,D7
.INCREMENTE	MOVE.L	(A0)+,D0	;TRUE_MAX
	MOVE.L	(A0)+,D1	;V_X
	MOVE.L	(A0)+,D2	;V_Z
	MOVE.L	(A0)+,D3	;PAS_Y

	SUB.L	D3,(A1)	;MAX_Y
	MOVE.L	(A1)+,D4	;D4=MAX_Y
	BGE.S	.MAX_POSITIF
	NEG.L	D4
.MAX_POSITIF	MOVE.L	A0,-(SP)
	MOVEM.L	D0-D1,-(SP)
	LSR.L	#6,D4
	LSR.L	#6,D4
	MOVE.L	D4,D0
	MOVE.L	D4,D1
	ADD.L	D0,D0
	ADD.L	D0,D0
	LEA	TABLE_MULTI,A0
	MOVE.L	(A0,D0.L),D4
	;D4=MAX_Y^2 !!! ( 32 BITS DE VIRGULE ! )
	MOVEM.L	(SP),D0-D1
	LSR.L	#6,D0
	LSR.L	#6,D0
	ADD.L	D0,D0
	ADD.L	D0,D0
	LEA	TABLE_MULTI,A0
	MOVE.L	(A0,D0.L),D0
	SUB.L	D0,D4
	MOVEM.L	(SP)+,D0-D1
	MOVE.L	(SP)+,A0
	ADD.L	D1,(A1)+	;X
	MOVE.L	D4,(A1)+	;Y
	ADD.L	D2,(A1)+	;Z
	DBRA	D7,.INCREMENTE
	DBRA	D6,RECOM_BCL
	MOVE.L	#$12345678,(A5)
	RTS

NB_STARS	DC.W	0
PT_ETAPES	DC.W	0
TIMER_FEUX	DC.W	0
PT_FADE_FEUX	DS.L	1

N	SET	0
TABLE_MULTI	REPT	800
	DC.L	((N*N)/256)*2
N	SET	N+1
	ENDR

CORES_Y
N	SET	0
	REPT	200
	DC.W	N*160
N	SET	N+1
	ENDR

CORES_X	
N	SET	0
	REPT	20
	DC.W	32768,N,16384,N,8192,N,4096,N,2048,N,1024,N,512,N,256,N,128,N,64,N,32,N,16,N,8,N,4,N,2,N,1,N
N	SET	N+8
	ENDR

	;1.L : MAX Y * (2^16)
	;1.L : V_X   * (2^16)
	;1.L : V_Z   * (2^16)
	;1.L : PAS_Y * (2^16)
DESCRIPT	INCBIN	CACA.FIC	

	DCB.W	400,$7FFF
BUF_COEFF	DS.W	1024

	SECTION	BSS
NB_VBL	DS.W	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	32000*2
BSS_TOUT_COURT	DS.B	LONG_BSS_FEUX