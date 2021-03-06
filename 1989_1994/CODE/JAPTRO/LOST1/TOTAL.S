NB_1 = 150
NB_2 = 230
NB_3 = 220

	;RSs POUR LES ETOILES
	RSRESET
BUF_EFF	RS.L	2
BUF_COD	RS.B	12200
BUF_COD2	RS.B	7700
RANG_REG_STARS	RS.L	2
PT_ETAP	RS.W	1

	;RSs POUR STARDUCK
	RSRESET
ADR_EFF	RS.L	2
PT_CRB_X	RS.L	1
PT_CRB_Y	RS.L	1
PT_CRB_Z	RS.L	1
RANG_TRUCS	RS.W	4
BUF_COD_STARDUCK	RS.B	33284
LES_3_TABLES	RS.B	18302
VIDE	RS.B	18302    ;POUR LA MULTIPLICATION PAR 0

	RSRESET
VAL_DEB	RS.W	1
BN	RS.W	1
Z_DEP	RS.W	1
PT_COURBE	RS.L	1
COLOR	RS.W	1
PT_ZONE_AFF	RS.L	1
PT_ZONE_EFF	RS.L	1
PUT_ADRS_TUNNEL	RS.L	(3*30+1)*3

	RSRESET
BUF_Z	RS.W	512
CORES_X	RS.W	56*8*2*3
CORES_Y	RS.W	200+274+200
BUF_MOTIFS	RS.B	1000*55
BUF_OFFSETS	RS.W	1000*56
BUF_SINUS	RS.W	(32*2*32)*2
BUF_PREDEC	RS.B	266240
	RS.W	1000
BUF_COEFF_3D	RS.W	2*1024
TABLE_ADR_COD	RS.L	16*93
CORES_X_2	RS.W	56*8*2*3
CORES_Y_2	RS.W	200+274+200
BUF_COD_TUNNEL	RS.B	310000
	RS.B	256+1280
BUFFER_ECR_1	RS.B	128000+1280
LONG_BSS	RS.B	1

BORD_GAUCHE	MACRO
	MOVE.W	A5,(A5)	;$8260
	MOVE.B	#0,(A5)
	ENDM

BORD_DROIT	MACRO
	MOVE.B	#0,(A6)	;$820A
	MOVE.W	A5,(A6)
	ENDM

STAB	MACRO
	MOVE.W	A5,(A5)	;$8260
	MOVE.B	#0,(A5)
	ENDM

BORD_GAUCHE_DUCK	MACRO
	MOVE.W	A7,(A7)	;$8260
	MOVE.B	#0,(A7)
	ENDM

BORD_DROIT_DUCK	MACRO
	MOVE.B	#0,(A2)	;$820A
	MOVE.W	A7,(A2)
	ENDM

STAB_DUCK	MACRO
	MOVE.W	A7,(A7)	;$8260
	MOVE.B	#0,(A7)
	ENDM

NP	MACRO
	REPT	\1
	NOP
	ENDR
	ENDM


	JMP	MAIN
	DS.B	192
MSG	INCBIN	MSG1.DAT

MAIN	;CLR.L	-(SP)
	;MOVE.W	#$20,-(SP)
	;TRAP	#1
	;ADDQ.W	#6,SP

	;CLR.W	-(SP)
	;PEA	-1.W
	;PEA	-1.W
	;MOVE.W	#5,-(SP)
	;TRAP	#14
	;LEA	12(SP),SP

	MOVE.L	A0,MOD_ZIK1
	MOVE.L	A0,MOD_ZIK2
	MOVE.L	A0,MOD_ZIK2
	MOVE.L	A0,MOD_ZIK3
	MOVE.L	A0,MOD_ZIK4
	MOVE.L	A0,MOD_ZIK5
	MOVE.L	A0,MOD_ZIK6
	MOVE.L	A1,MOD_RET
	LEA	BSS_DEB,A0
	LEA	BSS_END,A1
KLL	CLR.L	(A0)+
	CMP.L	A1,A0
	BLE.S	KLL
;	MOVEQ	#1,D0
;	JSR	ZIK


	MOVE.L	#$01010101,$FFFF8240.W
	JSR	PREP_ECR_STARS

	LEA	MSG,A0
	MOVE.L	SCREEN1,A1
	MOVE	#200-1,D0
AFY2	MOVE	#20-1,D1
AFX2	MOVE	(A0)+,(A1)
	ADDQ	#8,A1
	DBF	D1,AFX2
	DBF	D0,AFY2
	MOVE.L	#VBL_INITIALE,$70.W

	BSR	PREPARE_ALL
	JSR	MET_EN_PLACE
	JSR	MAKE_PREDEC
	JSR	PREPARE_ALL_TUNNEL

	MOVE	#5,BAZOUNGA
	MOVE.L	#VBL_INITIALE2,$70.W
BARRAGE	BRA.S	BARRAGE
	MOVE.L	SCREEN1,A0
	MOVEQ	#0,D0
	MOVE	#7999,D1
KILLIT	MOVE.L	D0,(A0)+
	DBF	D1,KILLIT

	;A FAIRE JUSTE AVANT LES ETOILES
	MOVE.L	#FADE_UP,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
	CLR.W	PT_DEMO

	MOVE.W	#$2700,SR
	MOVE.L	#INTER_RTE,$68.W
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	CLR.B	$FFFFFA13.W
	CLR.B	$FFFFFA15.W
	MOVE.L	#VBLR,$70.W
	MOVE.W	#$2300,SR

JMP	TST.W	PT_DEMO
	BEQ.S	JMP
	CMPI.W	#1,PT_DEMO
	BNE	.TEST_2
	;A FAIRE JUSTE AVANT STARDUCK
	MOVE.L	#VBLR_WAIT,$70.W
	BSR	MET_EN_PLACE_2
	MOVE.L	#CRB_X,PT_CRB_X+BSS_JUSTE
	MOVE.L	#CRB_Y,PT_CRB_Y+BSS_JUSTE
	MOVE.L	#CRB_Z,PT_CRB_Z+BSS_JUSTE
	LEA	EFF_BUF_1,A0
	LEA	EFF_BUF_2,A1
	LEA	ADR_EFF+BSS_JUSTE,A2
	MOVE.L	A0,(A2)+
	MOVE.L	A1,(A2)+
	BSR	MAKE_COD
	MOVE.L	#FADE_UP,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
	MOVE.L	SCREEN1,A0
	MOVEQ	#0,D0
	MOVEQ	#1,D6
.RECOM	MOVE.W	#(64000/32)-1,D7
.EFF_1	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	DBRA	D7,.EFF_1
	MOVE.L	SCREEN2,A0
	DBRA	D6,.RECOM
	CLR.W	PT_DEMO
	MOVE.L	#VBLR_DUCK,$70.W
	BRA	JMP
.TEST_2	CMPI.W	#2,PT_DEMO
	BNE	.TEST_3
	MOVE.L	#VBLR_WAIT,$70.W
	JSR	PREP_ECR_TUNNEL
	BSR	PREPARE_SECOND	
	MOVE.L	#COURBE_TUNNEL,PT_COURBE+BSS_JUSTE
	CLR.W	Z_DEP+BSS_JUSTE
	CLR.W	VAL_DEB+BSS_JUSTE
	CLR.W	BN+BSS_JUSTE
	CLR.W	COLOR+BSS_JUSTE
	MOVE.L	#PUT_ADRS_TUNNEL+12*30+4+BSS_JUSTE,PT_ZONE_AFF+BSS_JUSTE
	MOVE.L	#PUT_ADRS_TUNNEL+BSS_JUSTE,PT_ZONE_EFF+BSS_JUSTE
	MOVE.L	#ENDIT,PUT_ADRS_TUNNEL+BSS_JUSTE
	MOVE.L	#ENDIT,PUT_ADRS_TUNNEL+((3*30+1)*4)*2+BSS_JUSTE
	MOVE.L	SCREEN1,A0
	MOVEQ	#0,D0
	MOVEQ	#1,D6
.RECOM2	MOVE.W	#(64000/32)-1,D7
.EFF_12	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	MOVE.L	D0,(A0)+
	DBRA	D7,.EFF_12
	MOVE.L	SCREEN2,A0
	DBRA	D6,.RECOM2
	MOVE.L	#FADE_UP_3,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
	CLR.W	PT_DEMO
	MOVE.L	#VBLR_TUNNEL,$70.W
	BRA	JMP
.TEST_3	CMPI.W	#$1234,PT_DEMO
	BNE	JMP
	;ICI LA DEMO EST TERMIN��!!!
MOD_RET	EQU	*+2
	JMP	MOD_RET
;.PROUT	MOVE.W	#$700,$FFFF8240.W
;	BRA.S	.PROUT
VBL_INITIALE
	MOVEM.L	D0-A6,-(SP)
MOD_ZIK5	EQU	*+2
	JSR	MOD_ZIK5

	LEA	FAD_DEB,A6
MODFDEND	EQU	*+2
	LEA	0(A6),A6
	CMPI	#-1,(A6)
	BEQ.S	.OUT
	SUBQ	#1,BAZOUNGA
	BNE.S	.OUT
	MOVE	#5,BAZOUNGA
	ADDQ	#2,MODFDEND
	MOVE	(A6),$FFFF8242.W
.OUT
	MOVEM.L	(SP)+,D0-A6
	RTE
VBL_INITIALE2
	MOVEM.L	D0-A6,-(SP)
MOD_ZIK6	EQU	*+2
	JSR	MOD_ZIK6

	LEA	FAD_END,A6
AMODFDEND	EQU	*+2
	LEA	0(A6),A6
	CMPI	#-1,(A6)
	BEQ.S	.OUTE
	SUBQ	#1,BAZOUNGA
	BNE.S	.OUT
	MOVE	#5,BAZOUNGA
	ADDQ	#2,AMODFDEND
	MOVE	(A6),$FFFF8242.W
.OUT
	MOVEM.L	(SP)+,D0-A6
	RTE
.OUTE	MOVE	#$4E71,BARRAGE
	BRA.S	.OUT
BAZOUNGA	DC	5
FAD_DEB	DC	$101,$212,$323,$434,$545,$656,$777,-1
FAD_END	DC	$777,$656,$545,$434,$323,$212,$101,-1

VBLR	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W       ; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
	;ICI 33 LIGNES DE LIBRES
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	MOVEQ	#0,D7
	MOVEM.L	D0-D7,$FFFF8240.W
	LEA	BUF_MOTIFS+BSS_PERMANENTE,A0
	LEA	BUF_OFFSETS+BSS_PERMANENTE,A1
	MOVEQ	#0,D0
	MOVE.W	PT_ETAP+BSS_JUSTE,D0
	MOVE.L	D0,D1
	MOVE.L	D1,D2
	MULS.W	#1000,D1
	MULS.W	#2000,D2
	ADDA.L	D1,A0	ADRESSE COURANTE DES MOTIFS
	ADDA.L	D2,A1	ADRESSE COURANTE DES OFFSET
	LEA	RANG_REG_STARS+BSS_JUSTE,A2
	MOVE.L	A0,(A2)+
	MOVE.L	A1,(A2)

	ADDQ.W	#1,D0
	CMPI.W	#55,D0
	BLT.S	.OK
	MOVEQ	#0,D0
.OK	MOVE.W	D0,PT_ETAP+BSS_JUSTE
MOD_ZIK1	EQU	*+2
	JSR	MOD_ZIK1
INTER_RTE	RTE

INTER_TMA:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR
full
	MOVEQ	#16,D0
	LEA	$FFFF8209.W,A0
	LEA	$FFFF820A.W,A6
	LEA	$FFFF8260.W,A3

	MOVEQ	#2,D3
	MOVEQ	#0,D4

	STOP	#$2100

	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHROA:	DBF	D2,SYNCHROA
	NOP

	MOVE.B	D4,(A6)	;820A
	REPT	6
	NOP
	ENDR
	MOVE.B	D3,(A6)	;820A

	;SYNCHRO ICI...
.SYNCHRO	MOVE.B	(A0),D2
	BEQ.S	.SYNCHRO
	SUB.B	D2,D0
	LSL.W	D0,D0

	DCB.W	97-7-7-4-5-35-5,$4E71
	MOVE.L	PT_FADE,A0	5
	MOVE.W	0(A0),$FFFF8242.W	5
	MOVE.W	2(A0),$FFFF8244.W	5
	MOVE.W	0(A0),$FFFF8246.W	5
	MOVE.W	4(A0),$FFFF8248.W	5
	MOVE.W	0(A0),$FFFF824A.W	5
	MOVE.W	2(A0),$FFFF824C.W	5
	MOVE.W	0(A0),$FFFF824E.W	5
	LEA	BUF_EFF+BSS_JUSTE,A4	3	
	MOVE.L	(A4)+,A0	ADRESSE DES OFFSETS 3
	MOVEQ	#0,D0	1
	MOVE.L	SCREEN2,A2	5
	LEA	160+230*135(A2),A2   2
	MOVE.W	#$8260,A5	2
	MOVE.W	#$820A,A6	2
	JSR	BUF_COD2+BSS_JUSTE	5
	BORD_GAUCHE
	LEA	RANG_REG_STARS+BSS_JUSTE,A4	3
	MOVE.L	(A4)+,A0	ADRESSE DES MOTIFS  3
	MOVE.L	(A4)+,A1	ADRESSE DES OFFSETS 3
	NP	88-9
	BORD_DROIT
	NP	13
	STAB
	NP	12-5
	JSR	BUF_COD+BSS_JUSTE	5
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	MOVE.W	#78,D7	2
	NOP
.FULL_COOL	NP	13-3
	STAB
	NP	12
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	DBRA	D7,.FULL_COOL	
	NP	13-4-3
	MOVE.B	#0,(A6)	;$820A
	STAB
	NP	12
	BORD_GAUCHE
	MOVE.W	A5,(A6)
	NP	88-2
	BORD_DROIT
	MOVE.W	#47,D7	2
	NOP
.FULL_COOL2	NP	13-3
	STAB
	NP	12
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	DBRA	D7,.FULL_COOL2

	LEA	RANG_REG_STARS+BSS_JUSTE,A0
	LEA	BUF_EFF+BSS_JUSTE,A2
	MOVE.L	4(A0),(A2)
	MOVE.L	(A2)+,D5	SWAPPING
	MOVE.L	(A2),-(A2)
	MOVE.L	D5,4(A2)
	BSR	SWAPEC

	TST.W	FLAG_WAIT
	BNE.S	.PAS_ENCORE
	MOVE.W	#4,FLAG_WAIT
	ADDQ.W	#1,NB_FADE
	CMPI.W	#8,NB_FADE
	BLT.S	.CONT_FADE
	MOVE.L	PT_FADE,A0
	CMPA.L	#FADE_DOWN,A0
	BLE.S	.OK
	MOVE.W	#1,PT_DEMO
.OK	MOVE.W	#7,NB_FADE
	SUBQ.L	#6,PT_FADE
.CONT_FADE	ADDQ.L	#6,PT_FADE
.PAS_ENCORE	SUBQ.W	#1,FLAG_WAIT

	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	.PAS_FIN
	MOVE.L	#FADE_DOWN,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
.PAS_FIN	CLR.W	$FFFF8240.W
	RTE

VBLR_WAIT	MOVEM.L	D0-A6,-(SP)
MOD_ZIK2	EQU	*+2
	JSR	MOD_ZIK2
	MOVEM.L	(SP)+,D0-A6
	RTE

VBLR_DUCK	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W       ; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA_DUCK,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
	;ICI 33 LIGNES DE LIBRES
	MOVEA.L	ADR_EFF+BSS_JUSTE,A1
	MOVEA.L	SCREEN2,A0
	LEA	160+230*135(A0),A0
	MOVEQ	#0,D0
	JSR	(A1)

	MOVEA.L	PT_CRB_Y+BSS_JUSTE,A0
	MOVE.W	(A0)+,D7	;Y_TAPIS
	SUBI.W	#130,D7
	ADD.W	D7,D7
	CMPI.W	#$1234,(A0)
	BNE.S	.FUCK_2
	LEA	CRB_Y,A0
.FUCK_2	CMPI.B	#1,$FFFFFC02.W
	BEQ.S	.STOP_1
	MOVE.L	A0,PT_CRB_Y+BSS_JUSTE
.STOP_1	MOVEA.L	PT_CRB_X+BSS_JUSTE,A5
	MOVE.W	(A5)+,D0
	CMPI.W	#$1234,(A5)
	BNE.S	.FUCK_1
	LEA	CRB_X,A5
.FUCK_1	CMPI.B	#1,$FFFFFC02.W
	BEQ.S	.STOP_2
	MOVE.L	A5,PT_CRB_X+BSS_JUSTE
.STOP_2	MOVE.W	D0,D1
	ANDI.W	#15,D0
	LSR.W	#1,D0	;DECALAGE 0-->7
	MULU.W	#130,D0
	ANDI.W	#$FFF0,D1
	LSR.W	#4,D1	;OFFSET POUR LE SINUS
	ANDI.W	#31,D1
	ADD.W	D1,D1

	MOVE.L	PT_CRB_Z+BSS_JUSTE,A0
	MOVE.W	(A0)+,D2	;Z
	MOVE.W	D2,D3
	ANDI.W	#7,D2
	MULU.W	#130*8,D2
	DIVU.W	#32*8,D3
	SWAP	D3	;RESTE DE LA DIVISION
	LSR.W	#3,D3
	MULU.W	#128,D3
	CMPI.W	#$1234,(A0)
	BNE.S	.FUCK_3
	LEA	CRB_Z,A0
.FUCK_3	CMPI.B	#1,$FFFFFC02.W
	BEQ.S	.STOP_3
	MOVE.L	A0,PT_CRB_Z+BSS_JUSTE
.STOP_3	LEA	RANG_TRUCS+BSS_JUSTE,A0
	MOVE.W	D0,(A0)+
	MOVE.W	D1,(A0)+
	MOVE.W	D2,(A0)+
	MOVE.W	D3,(A0)+
	RTE

INTER_TMA_DUCK:	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR

	MOVEQ	#16,D0
	LEA	$FFFF8209.W,A0
	LEA	$FFFF820A.W,A6
	LEA	$FFFF8260.W,A3

	MOVEQ	#2,D3
	MOVEQ	#0,D4

	STOP	#$2100

	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHROA_DUCK:	DBF	D2,SYNCHROA_DUCK
	NOP

	MOVE.B	D4,(A6)	;820A
	REPT	6
	NOP
	ENDR
	MOVE.B	D3,(A6)	;820A

	;SYNCHRO ICI...
.SYNCHRO	MOVE.B	(A0),D2
	BEQ.S	.SYNCHRO
	SUB.B	D2,D0
	LSL.W	D0,D0

	DCB.W	97-49-5-35-3-5,$4E71
	LEA	BUF_PREDEC+BSS_PERMANENTE,A0	3
	LEA	RANG_TRUCS+BSS_JUSTE,A5	3
	MOVE.W	(A5)+,D0	2
	MOVE.W	(A5)+,D1	2
	MOVE.W	(A5)+,D2	2
	MOVE.W	(A5)+,D3	2
	ADDA.W	D0,A0	2
	ADDA.W	D2,A0	2
	MOVE.L	SCREEN2,A1	5
	LEA	160+230*135(A1),A1	2
	LEA	LES_3_TABLES+BSS_JUSTE,A3   3
	LEA	BUF_SINUS+64+32*32*4+BSS_PERMANENTE,A4   3
	SUBA.W	D1,A4	2
	SUBA.W	D3,A4	2
	LEA	TABLE_LOG-2,A5	3
	MOVE.L	ADR_EFF+BSS_JUSTE,A6	5
	ADDQ.W	#2,A6	2
	MOVE.L	A7,PT_SP	5
	MOVE.L	PT_FADE,A2	5
	MOVE.W	0(A2),$FFFF8242.W	5
	MOVE.W	2(A2),$FFFF8244.W	5
	MOVE.W	0(A2),$FFFF8246.W	5
	MOVE.W	4(A2),$FFFF8248.W	5
	MOVE.W	0(A2),$FFFF824A.W	5
	MOVE.W	2(A2),$FFFF824C.W	5
	MOVE.W	0(A2),$FFFF824E.W	5
	MOVE.W	#$8260,A7	2
	MOVE.W	#$820A,A2	2
	********
	JMP	BSS_JUSTE+BUF_COD_STARDUCK	3
	********
FIN_STARDUCK	BORD_GAUCHE_DUCK
	NP	88
	BORD_DROIT_DUCK
	MOVE.W	#8,D7	2
	NOP
.FULL_COOL	NP	13-3
	STAB_DUCK
	NP	12
	BORD_GAUCHE_DUCK
	NP	88
	BORD_DROIT_DUCK
	DBRA	D7,.FULL_COOL	
	NP	13-4-3
	MOVE.B	#0,(A2)	;$820A
	STAB_DUCK
	NP	12
	BORD_GAUCHE_DUCK
	MOVE.W	A7,(A2)
	NP	88-2
	BORD_DROIT_DUCK
	MOVE.W	#26,D7	2
	NOP
.FULL_COOL2	NP	13-3
	STAB_DUCK
	NP	12
	BORD_GAUCHE_DUCK
	NP	88
	BORD_DROIT_DUCK
	DBRA	D7,.FULL_COOL2
PT_SP = *+2
	LEA	$12345678,A7
	CLR.L	$FFFF8240.W
	CLR.L	$FFFF8244.W
	CLR.L	$FFFF8248.W
	CLR.L	$FFFF824C.W
	CLR.L	$FFFF8250.W
	CLR.L	$FFFF8254.W
	CLR.L	$FFFF8258.W
	CLR.L	$FFFF825C.W
MOD_ZIK3	EQU	*+2
	JSR	MOD_ZIK3
	JSR	SWAPEC
	LEA	ADR_EFF+BSS_JUSTE,A0
	MOVE.L	(A0)+,D0
	MOVE.L	(A0),-(A0)
	MOVE.L	D0,4(A0)

	TST.W	FLAG_WAIT
	BNE.S	.PAS_ENCORE
	MOVE.W	#4,FLAG_WAIT
	ADDQ.W	#1,NB_FADE
	CMPI.W	#8,NB_FADE
	BLT.S	.CONT_FADE
	MOVE.L	PT_FADE,A0
	CMPA.L	#FADE_DOWN,A0
	BLE.S	.OK
	MOVE.W	#2,PT_DEMO
.OK	MOVE.W	#7,NB_FADE
	SUBQ.L	#6,PT_FADE
.CONT_FADE	ADDQ.L	#6,PT_FADE
.PAS_ENCORE	SUBQ.W	#1,FLAG_WAIT

	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	.PAS_FIN
	MOVE.L	#FADE_DOWN,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
.PAS_FIN	CLR.W	$FFFF8240.W

	RTE

VBLR_TUNNEL	MOVE.B	#0,$FFFFFA19.W
	MOVE.B	#99,$FFFFFA1F.W       ; BORDER HAUT
	MOVE.B	#4,$FFFFFA19.W
	BCLR	#3,$FFFFFA17.W
	MOVE.L	#INTER_TMA_TUNNEL,$134.W
	ORI.B	#$20,$FFFFFA13.W
	ORI.B	#$20,$FFFFFA07.W
	;ICI 33 LIGNES DE LIBRES
	CLR.L	$FFFF8244.W
	CLR.L	$FFFF8250.W
	CLR.L	$FFFF8254.W
	CLR.L	$FFFF8258.W
	CLR.L	$FFFF825C.W

	MOVE.L	PT_ZONE_AFF+BSS_JUSTE,A0
	MOVE.W	VAL_DEB+BSS_JUSTE,D0
	ADD.W	D0,D0
	ADD.W	D0,D0
	LEA	COURBE_TUNNEL,A1
	ADDA.W	D0,A1
	LEA	COURBE_TUNNEL,A2
	MOVE.W	BN+BSS_JUSTE,D0
	ADD.W	D0,D0
	ADD.W	D0,D0
	ADDA.W	D0,A2
	LEA	TABLE_ADR_COD+BSS_PERMANENTE,A3
	MOVE.W	Z_DEP+BSS_JUSTE,D0
	LSL.W	#6,D0
	ADDA.W	D0,A3
	LEA	CORES_Y_2+200*2+135*2+BSS_PERMANENTE,A4

	MOVE.L	#224,D0
	SUB.W	(A1)+,D0	ECART_X
	MOVE.L	#135,D1
	SUB.W	(A1)+,D1	ECART_Y
	MOVE.L	SCREEN2,A6
	LEA	160+230+230*135(A6),A6
	MOVE.W	COLOR+BSS_JUSTE,D5
	MOVEQ	#29,D7
	************
.RECOM_CALC	MOVE.L	D0,D2
	ADD.W	(A2),D2	X(BN+I*3)+ECART_X
	MOVE.L	D1,D3
	ADD.W	2(A2),D3	Y(BN+I*3)+ECART_Y
	;D2 ET D3 SONT LES COORDONN�ES DU CENTRE DU CERCLE A AFFICHER
	SUBI.W	#135,D3
	MOVE.L	D2,D4
	ANDI.W	#15,D2
	ADD.W	D2,D2
	ADD.W	D2,D2
	MOVE.L	(A3,D2.W),(A0)+
	MULS.W	#230,D3
	MOVE.L	A6,A5
	ADDA.W	D5,A5
	EORI.W	#4,D5
	ANDI.W	#-16,D4
	LSR.L	#1,D4
	ADD.L	D3,D4
	ADDA.L	D4,A5
;	MOVE.L	A5,(A0)+
	ADDA.L	#137*230,A5
	MOVE.L	A5,(A0)+
	SUBA.L	#135*230*2,A5
	MOVE.L	A5,(A0)+
	LEA	4*16*3(A3),A3
	LEA	12(A2),A2
	DBRA	D7,.RECOM_CALC
	**********
	MOVE.L	#ENDIT_AFF,(A0)+
	TST.W	Z_DEP+BSS_JUSTE
	BNE.S	.FUCK
	ADDI.W	#3,BN+BSS_JUSTE
.FUCK	SUBQ.W	#1,Z_DEP+BSS_JUSTE
	BGE.S	.FUCK_2
	EORI.W	#4,COLOR+BSS_JUSTE
	ADDI.W	#3,Z_DEP+BSS_JUSTE
.FUCK_2	ADDQ.W	#1,VAL_DEB+BSS_JUSTE
	RTE
BIDUL	DC	0
INTER_TMA_TUNNEL
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE	#$2100,SR

	MOVEQ	#16,D0
	LEA	$FFFF8209.W,A0
	LEA	$FFFF820A.W,A6
	LEA	$FFFF8260.W,A3

	MOVEQ	#2,D3
	MOVEQ	#0,D4

	STOP	#$2100

	MOVE	#$2700,SR
	MOVE	#$2300,(SP)

	MOVEQ	#29,D2
SYNCHROA_TUN:	DBF	D2,SYNCHROA_TUN
	NOP

	MOVE.B	D4,(A6)	;820A
	REPT	6
	NOP
	ENDR
	MOVE.B	D3,(A6)	;820A

	;SYNCHRO ICI...
.SYNCHRO	MOVE.B	(A0),D2
	BEQ.S	.SYNCHRO
	SUB.B	D2,D0
	LSL.W	D0,D0

	DCB.W	97-25-3-23,$4E71
	MOVEQ	#1,D0	1
	MOVEQ	#2,D1	1
	MOVEQ	#4,D2	1
	MOVEQ	#8,D3	1
	MOVEQ	#$10,D4	1
	MOVEQ	#$20,D5	1	
	MOVEQ	#$40,D6	1
	MOVEQ	#$80,D7	1
	MOVE.L	PT_ZONE_EFF+BSS_JUSTE,A0	5
	MOVE.L	(A0)+,A1	3
	MOVE.L	(A0)+,A2	3
	MOVE.L	(A0)+,A3	3
	MOVE.W	#$8260,A5	2
	MOVE.W	#$820A,A6	2
	MOVE.L	PT_FADE,A4	5
	MOVE.W	(A4),$FFFF8242.W	4
	MOVE.L	2(A4),$FFFF8248.W	7
	MOVE.L	2(A4),$FFFF824C.W	7
	JMP	(A1)	2
ENDIT	BORD_GAUCHE
	NP	88
	BORD_DROIT
	NP	13-5
	MOVE.L	PT_ZONE_AFF+BSS_JUSTE,A0	5
	STAB
	NP	12-11
	MOVE.L	(A0)+,A1	3
	MOVE.L	(A0)+,A2	3
	MOVE.L	(A0)+,A3	3
	JMP	(A1)	2
ENDIT_AFF	
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	MOVE.W	#105,D7	2
	NOP
.FULL_COOL	NP	13-3
	STAB
	NP	12
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	DBRA	D7,.FULL_COOL	
	NP	13-4-3
	MOVE.B	#0,(A6)	;$820A
	STAB
	NP	12
	BORD_GAUCHE
	MOVE.W	A5,(A6)
	NP	88-2
	BORD_DROIT
	MOVE.W	#27,D7	2
	NOP
.FULL_COOL2	NP	13-3
	STAB
	NP	12
	BORD_GAUCHE
	NP	88
	BORD_DROIT
	DBRA	D7,.FULL_COOL2

	CLR.W	$FFFF8242.W
	CLR.L	$FFFF8248.W
	CLR.L	$FFFF824C.W
MOD_ZIK4	EQU	*+2
	JSR	MOD_ZIK4
	BSR	SWAPEC
	MOVE.L	PT_ZONE_EFF+BSS_JUSTE,A0
	CMPA.L	#PUT_ADRS_TUNNEL+BSS_JUSTE,A0
	BNE.S	.GO_AND_GO
	LEA	PUT_ADRS_TUNNEL+((3*30+1)*4)*3+BSS_JUSTE,A0
.GO_AND_GO	LEA	-(3*30+1)*4(A0),A0
	MOVE.L	A0,PT_ZONE_EFF+BSS_JUSTE
	***
	MOVE.L	PT_ZONE_AFF+BSS_JUSTE,A0
	MOVE.L	#ENDIT,(30*3)*4(A0)
	CMPA.L	#PUT_ADRS_TUNNEL+BSS_JUSTE,A0
	BNE.S	.GO_AND_GO2
	LEA	PUT_ADRS_TUNNEL+((3*30+1)*4)*3+BSS_JUSTE,A0
.GO_AND_GO2	LEA	-(3*30+1)*4(A0),A0
	MOVE.L	A0,PT_ZONE_AFF+BSS_JUSTE

	TST.W	FLAG_WAIT
	BNE.S	.PAS_ENCORE
	MOVE.W	#4,FLAG_WAIT
	ADDQ.W	#1,NB_FADE
	CMPI.W	#8,NB_FADE
	BLT.S	.CONT_FADE
	MOVE.L	PT_FADE,A0
	CMPA.L	#FADE_DOWN_3,A0
	BLE.S	.OK
	MOVE.W	#$1234,PT_DEMO
.OK	MOVE.W	#7,NB_FADE
	SUBQ.L	#6,PT_FADE
.CONT_FADE	ADDQ.L	#6,PT_FADE
.PAS_ENCORE	SUBQ.W	#1,FLAG_WAIT

	CMPI.B	#$39,$FFFFFC02.W
	BNE.S	.PAS_FIN
	MOVE.L	#FADE_DOWN_3,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
.PAS_FIN	ADDQ	#1,BIDUL
	;MOVE	#$070,$FFFF8240.W	
	CMPI	#50*30,BIDUL
	BNE.S	.PAS_FIN2
	MOVE.L	#FADE_DOWN_3,PT_FADE
	CLR.W	NB_FADE
	CLR.W	FLAG_WAIT
.PAS_FIN2

	CLR.W	$FFFF8240.W
	RTE

PREP_ECR_TUNNEL	MOVE.L	#BSS_PERMANENTE,D0
	CLR.B	D0
	ADDI.L	#25600,D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#64000+25600,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

EFF_BUF_1	REPT	1024
	MOVE.W	D0,$1234(A0)
	ENDR
	RTS

EFF_BUF_2	REPT	1024
	MOVE.W	D0,$1234(A0)
	ENDR
	RTS

PREP_ECR_STARS	MOVE.L	#BUFFER_ECR_1+BSS_PERMANENTE,D0
	CLR.B	D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#64000+1280,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREPARE_ALL	;ON FABRIQUE CORES_X
	LEA	CORES_X+BSS_PERMANENTE,A0
	MOVE.W	#56*8*2-1,D0
.EFFAC1	CLR.W	(A0)+
	DBRA	D0,.EFFAC1
	MOVEQ	#0,D0	OFFSET DE DEPART
	MOVE.W	#$80,D1	MOTIF DE DEPART
	MOVEQ	#1,D3	PAS D'INCREMENTATION
	MOVE.W	#56*8-1,D7
.CONT_REMP	MOVE.W	D1,(A0)+
	MOVE.W	D0,(A0)+
	LSR.W	#1,D1
	BNE.S	.PAS_VIDE
	MOVE.W	#$80,D1
	ADD.W	D3,D0
	EOR.W	#6,D3
.PAS_VIDE	DBRA	D7,.CONT_REMP
	MOVE.W	#56*8*2-1,D0
.EFFAC2	CLR.W	(A0)+
	DBRA	D0,.EFFAC2
	;ON FABRIQUE CORES_Y
	LEA	CORES_Y+BSS_PERMANENTE,A0
	MOVE.W	#-230*137,D0
	MOVE.W	#199,D7
.REMP1	MOVE.W	D0,(A0)+
	DBRA	D7,.REMP1
	MOVE.W	#-230*135,D0
	MOVE.W	#273,D7
.REMP2	MOVE.W	D0,(A0)+
	ADDI.W	#230,D0
	DBRA	D7,.REMP2
	MOVE.W	#-230*137,D0
	MOVE.W	#199,D7
.REMP3	MOVE.W	D0,(A0)+
	DBRA	D7,.REMP3
	;ON FABRIQUE BUF_Z
	LEA	BUF_Z+BSS_PERMANENTE,A0
	MOVE.W	#NB_1-1,D7
.COLOR_1	CLR.W	(A0)+
	DBRA	D7,.COLOR_1
	MOVE.W	#NB_2-1,D7
.COLOR_2	MOVE.W	#2,(A0)+
	DBRA	D7,.COLOR_2
	MOVE.W	#NB_3-1,D7
.COLOR_3	MOVE.W	#4,(A0)+
	DBRA	D7,.COLOR_3
	;ON PRECALCULE LES ETOILES
	LEA	COEFF_STARS,A1
	LEA	CORES_X+56*8*2*2+BSS_PERMANENTE,A2
	LEA	CORES_Y+200*2+BSS_PERMANENTE,A3
	LEA	BUF_MOTIFS+BSS_PERMANENTE,A4
	LEA	BUF_OFFSETS+BSS_PERMANENTE,A5
	LEA	BUF_Z+BSS_PERMANENTE,A6
	MOVE.L	#(600*256)/55,D6       PAS_Z
	MOVEQ	#0,D7	No DE L'ETAPE
	MOVEQ	#54,D5
.CALC_ETAP	LEA	COOR_STARS,A0
	MOVE.W	#999,D3
.CALC_STARS	MOVE.W	(A0)+,D0	X
	MOVE.W	(A0)+,D1	Y
	MOVE.W	(A0)+,D2	Z
	LSL.L	#8,D2	Z*256
	;A LA PLACE DU SUB ON PEUT METTRE UN ADD.......
	SUB.L	D7,D2
	ASR.L	#8,D2	NEW Z...
	TST.W	D2
	BGE.S	.POSITIF
	MOVE.W	D2,-(SP)
	MOVE.W	#599,D2
	ADD.W	(SP)+,D2
.POSITIF	CMPI.W	#600,D2
	BLT.S	.INF_600
	SUBI.W	#600,D2
.INF_600	ADD.W	D2,D2
	MOVE.W	(A6,D2.W),D4	OFFSET POUR LA COULEUR
	MOVE.W	(A1,D2.W),D2	COEFFICIENT 3D
	MULS.W	D2,D0
	ASR.L	#8,D0	X PROJET�
	ADDI.W	#224,D0
	MULS.W	D2,D1
	ASR.L	#8,D1	Y PROJET�
	ADDI.W	#135,D1
	ADD.W	D0,D0
	ADD.W	D0,D0	X*4
	ADD.W	D1,D1	Y*2
	MOVE.W	(A3,D1.W),D1
	ADD.W	D4,D1
	ADD.W	2(A2,D0.W),D1	OFFSET POUVANT ETRE IMPAIR
	MOVE.W	(A2,D0.W),D0	MOTIF D'UN OCTET
	MOVE.B	D0,(A4)+
	MOVE.W	D1,(A5)+
	DBRA	D3,.CALC_STARS
	ADD.L	D6,D7
	DBRA	D5,.CALC_ETAP

	LEA	BUF_COD+BSS_JUSTE,A0
	MOVE.W	#89,D6
.COPY_90_LIG	LEA	LIGNE_TYPE,A1
	MOVE.W	#LONG_LIG_TYPE-1,D7
.COPY_COD	MOVE.W	(A1)+,(A0)+
	DBRA	D7,.COPY_COD
	DBRA	D6,.COPY_90_LIG
	LEA	LIGNE_SUP,A1
	MOVE.W	#LONG_LIG_SUP-1,D7
.COPY_COD2	MOVE.W	(A1)+,(A0)+
	DBRA	D7,.COPY_COD2

	LEA	BUF_COD2+BSS_JUSTE,A0
	MOVE.W	#54,D6
.COPY_55_LIG	LEA	LIGNE_TYPE_EFF,A1
	MOVE.W	#LONG_LIG_TYPE_EFF-1,D7
.COPY_COD3	MOVE.W	(A1)+,(A0)+
	DBRA	D7,.COPY_COD3
	DBRA	D6,.COPY_55_LIG
	LEA	LIGNE_EFF_SUP,A1
	MOVE.W	#LONG_LIG_EFF_SUP-1,D7
.COPY_COD4	MOVE.W	(A1)+,(A0)+
	DBRA	D7,.COPY_COD4

	MOVE.L	#BUF_OFFSETS+54*2000+BSS_PERMANENTE,BUF_EFF+BSS_JUSTE
	CLR.W	PT_ETAP
	RTS

LIGNE_TYPE	BORD_GAUCHE
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   1
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   2
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   3
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   4
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   5
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   6
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   7
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   8
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   9
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	NP	3
	BORD_DROIT
	OR.B	D0,(A2,D1.W)	5   10
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	NP	4
	STAB
	OR.B	D0,(A2,D1.W)	5   11
	NP	12-5
	;11 ETOILES PAR LIGNES... HUM... UN EXPLOIT... HUM...
	;DONC 91 LIGNES!
LONG_LIG_TYPE = (*-LIGNE_TYPE)/2

LIGNE_SUP	BORD_GAUCHE
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   1
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   2
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   3
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   4
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   5
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   6
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   7
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   8
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	OR.B	D0,(A2,D1.W)	5   9
	MOVE.B	(A0)+,D0	2
	MOVE.W	(A1)+,D1	2
	NP	3
	BORD_DROIT
	OR.B	D0,(A2,D1.W)	5   10
	NP	13-5
	STAB
	NP	12-4
	RTS
LONG_LIG_SUP = (*-LIGNE_SUP)/2

LIGNE_TYPE_EFF	BORD_GAUCHE
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	1
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	2
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	3
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	4
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	5
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	6
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	7
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	8
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	9
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	10
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	11
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	12
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	13
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	14
	MOVE.W	(A0)+,D1	2
	NP	2
	BORD_DROIT
	MOVE.B	D0,(A2,D1.W)	4	15
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	16
	MOVE.W	(A0)+,D1	2
	NOP
	STAB
	MOVE.B	D0,(A2,D1.W)	4	17
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	18
	NP	2
LONG_LIG_TYPE_EFF = (*-LIGNE_TYPE_EFF)/2

LIGNE_EFF_SUP
	BORD_GAUCHE
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	1
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	2
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	3
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	4
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	5
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	6
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	7
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	8
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	9
	MOVE.W	(A0)+,D1	2
	MOVE.B	D0,(A2,D1.W)	4	10
	NP	88-60
	BORD_DROIT
	NP	13
	STAB
	NP	12-4
	RTS
LONG_LIG_EFF_SUP = (*-LIGNE_EFF_SUP)/2

MAKE_PREDEC	LEA	BUF_PREDEC+BSS_PERMANENTE,A0
	LEA	TABLE_UTIL,A1
	LEA	COEFF_3D,A2
	LEA	BUF_COEFF_3D+BSS_PERMANENTE,A4
	CLR.W	PT_COUL
	SUB.L	A3,A3
	MOVE.W	#32*8-1,D5
.LOOP_Z	MOVE.W	D5,A6
	MOVE.W	(A2),D5	;COEFF_3D
	MOVEQ	#0,D2	;INCREMENT_SUS
	MOVEQ	#7,D7
	MOVEQ	#16,D1	;PAS_X
.LOOP_X2	MOVE.W	(A4),(A0)+
	MOVE.W	#-256,D0	;X_DEP
	ADD.W	D2,D0	;X_DEP+INCREMENT DE DEPART
	MOVEQ	#31,D6
.LOOP_X1	MOVE.W	D0,-(SP)
	MULS.W	D5,D0	;X*COEFF_3D*2^8
	LSR.L	#8,D0
	ADDI.W	#224,D0
	TST.W	D0
	BGE.S	.PAS_CLIP_GAUCHE
	MOVE.W	#-2,D0
	MOVEQ	#0,D4
	BRA.S	.PROUT
.PAS_CLIP_GAUCHE
	CMPI.W	#448,D0
	BLT.S	.PAS_CLIP
	MOVE.W	#-2,D0
	MOVEQ	#0,D4
	BRA.S	.PROUT
.PAS_CLIP	MOVE.W	D0,D4
	ANDI.W	#15,D0
	ADD.W	D0,D0
.PROUT	MOVE.W	(A1,D0.W),(A0)+	;MOTIF
	ANDI.W	#$FFF0,D4
	LSR.W	#1,D4
PT_COUL = *+2
	ADDI.W	#$1234,D4	+COULEUR !
	MOVE.W	D4,(A0)+	;OFFSET ECRAN
	MOVE.W	(SP)+,D0
	ADD.W	D1,D0	;X+PAS_X
	DBRA	D6,.LOOP_X1
	ADDQ.W	#2,D2
	DBRA	D7,.LOOP_X2
	LEA	8(A2),A2	;Z=Z+3
	LEA	8(A4),A4	;Z=Z+3
	MOVE.W	A6,D5
	ADDQ.W	#1,A3
	CMPA.W	#80,A3
	BNE.S	.TEST_2
	MOVE.W	#2,PT_COUL
.TEST_2	CMPA.W	#150,A3
	BNE.S	.PAS_TEST
	MOVE.W	#4,PT_COUL
.PAS_TEST	DBRA	D5,.LOOP_Z
	RTS
	DC.W	0
TABLE_UTIL	DC.W	$8000,$4000,$2000,$1000,$800,$400,$200,$100,$80,$40,$20,$10,8,4,2,1

MET_EN_PLACE	LEA	COEFF_3D,A0
	LEA	BUF_COEFF_3D+BSS_PERMANENTE,A1
	MOVE.W	#999,D7
.R_1	MOVE.W	(A0)+,(A1)+
	;MOVE.W	D0,(A1)+
	DBRA	D7,.R_1

	LEA	BUF_COEFF_3D-1000*2+BSS_PERMANENTE,A0
	MOVE.W	#3*LONG_EXP/2,D0
	MOVE.W	#999,D7
.PUT	MOVE.W	D0,(A0)+
	DBRA	D7,.PUT

	LEA	TABLE_LOG,A0
	LEA	-2(A0),A1
	MOVE.W	#399,D7
.RECOP_LOG	MOVE.W	(A0),D0
	MOVE.W	D0,D1
	ADDI.W	#LONG_EXP/4,D1
	ADD.W	D0,D0
	ADD.W	D1,D1
	MOVE.W	D1,-(A1)
	MOVE.W	D0,(A0)+
	DBRA	D7,.RECOP_LOG

	LEA	BUF_COEFF_3D+BSS_PERMANENTE,A0
	LEA	TABLE_LOG-2,A1
	MOVE.W	#999,D7
.REPEAT_COEFF	MOVE.W	(A0),D0
	ADD.W	D0,D0
	MOVE.W	(A1,D0.W),D0
	MOVE.W	D0,(A0)+
;	ADDQ.W	#2,A0
	DBRA	D7,.REPEAT_COEFF
	RTS

MAKE_COD	LEA	BSS_JUSTE+BUF_COD_STARDUCK,A0
	MOVEQ	#0,D0	;OFFSET DE DEPART
	MOVEQ	#30,D6
.COPY_ALL	MOVE.W	#LONG_COPY_STD,D7
	LEA	DEB_COD_EX,A1
.COPY_SEQ	CMPI.W	#$1234,(A1)
	BNE.S	.COPY_SIMPLE
	MOVE.W	D0,(A0)+
	ADDQ.W	#4,D0
	ADDQ.W	#2,A1
	BRA.S	.SUITE
.COPY_SIMPLE	MOVE.W	(A1)+,(A0)+
.SUITE	DBRA	D7,.COPY_SEQ
	DBRA	D6,.COPY_ALL
	LEA	DEB_COD_EX_2,A1
	MOVE.W	#LONG_COPY_STD2,D7
.COPY_SEQ2	MOVE.W	(A1)+,(A0)+
	DBRA	D7,.COPY_SEQ2
	RTS

	INCLUDE	DUCK.INT

MET_EN_PLACE_2	LEA	LES_3_TABLES+BSS_JUSTE,A0
	MOVEQ	#0,D0
	MOVEQ	#2,D6
.FINI_RECOP	LEA	TABLE_EXP,A1
	MOVE.W	#(LONG_EXP/4)-1,D7
.RECOP_TABLE	MOVE.L	(A1)+,D0
	ASR.L	#8,D0	;/256
;	ADD.W	D0,D0
;	ADD.W	D0,D0	;*4
	MULS.W	#230,D0	;*160
	CMPI.L	#230*135,D0
	BLE.S	.OK_1
	MOVE.L	#-230*136,D0
.OK_1	CMPI.L	#-230*135,D0
	BGE.S	.OK_2
	MOVE.L	#-230*136,D0
.OK_2	
ADR_CHG_1 = *
	NOP
	MOVE.W	D0,(A0)+
	DBRA	D7,.RECOP_TABLE
	EORI.W	#$A31,ADR_CHG_1	;ASTUCE:NOP=NEG.W D0
	DBRA	D6,.FINI_RECOP

	LEA	VIDE+BSS_JUSTE,A0
	MOVE.W	#3*(LONG_EXP/2)-1,D7
.EFFAC	CLR.B	(A0)+
	DBRA	D7,.EFFAC

	LEA	SINUS,A0
	LEA	BUF_SINUS+BSS_PERMANENTE,A1
	MOVE.L	A1,A3
	MOVE.W	#31,D7
.MULTI	MOVE.L	A1,A2
	MOVEQ	#31,D6
.RECOP	MOVE.W	(A0)+,D0
	ADD.W	D0,D0
	MOVE.W	D0,(A1)+
	DBRA	D6,.RECOP
	MOVEQ	#31,D6
.RECOP2	MOVE.W	(A2)+,(A1)+
	DBRA	D6,.RECOP2	
	DBRA	D7,.MULTI
	MOVE.W	#(32*32*2)-1,D5
.RECOP_ALL	MOVE.W	(A3)+,(A1)+
	DBRA	D5,.RECOP_ALL
	RTS

PREPARE_ALL_TUNNEL
	;ON FABRIQUE CORES_X
	LEA	CORES_X_2+BSS_PERMANENTE,A0
;	MOVE.W	#56*8*2-1,D0
;.EFFAC1	CLR.W	(A0)+
;	DBRA	D0,.EFFAC1
	MOVE.W	#-224,D0	OFFSET DE DEPART
	MOVEQ	#7,D1	MOTIF DE DEPART
	MOVEQ	#1,D3	PAS D'INCREMENTATION
	MOVE.W	#28*16*2-1,D7
.CONT_REMP	MOVE.W	D1,(A0)+
	MOVE.W	D0,(A0)+
	SUBQ.W	#1,D1
	BGE.S	.PAS_NUL
	MOVEQ	#7,D1
	ADD.W	D3,D0
	EORI.W	#6,D3
.PAS_NUL	DBRA	D7,.CONT_REMP
	MOVE.W	#56*8*2-1,D0
.EFFAC2	CLR.W	(A0)+
	DBRA	D0,.EFFAC2
	;ON FABRIQUE CORES_Y
	LEA	CORES_Y_2+BSS_PERMANENTE,A0
	MOVE.W	#-230*137,D0
	MOVE.W	#199,D7
.REMP1	MOVE.W	D0,(A0)+
	DBRA	D7,.REMP1
	MOVE.W	#-230*135,D0
	MOVE.W	#273,D7
.REMP2	MOVE.W	D0,(A0)+
	ADDI.W	#230,D0
	DBRA	D7,.REMP2
	MOVE.W	#-230*137,D0
	MOVE.W	#199,D7
.REMP3	MOVE.W	D0,(A0)+
	DBRA	D7,.REMP3
	;ON CODE LES CERCLES
	LEA	COEFF_3D_TUN,A0
	LEA	CORES_X_2+56*8*2*2+BSS_PERMANENTE,A2
	LEA	BUF_COD_TUNNEL+BSS_PERMANENTE,A5
	LEA	TABLE_ADR_COD+BSS_PERMANENTE,A6
	MOVEQ	#93-20-1,D5
.CODE_ALL_Z	MOVE.W	(A0),D0
	LEA	12(A0),A0	ON SAUTE 6 Z
	MOVEQ	#0,D4	DECALAGE
.MAK_ALL_DEC	LEA	CERCLE,A1
	MOVE.L	A5,(A6)+
	BSR	COPY_BORD_GAUCHE
	MOVEQ	#21,D7	22 ORS=88 NOPS
	BSR	PUT_ORS
	BSR	COPY_BORD_DROIT
	MOVEQ	#2,D7
	BSR	PUT_ORS
	MOVE.W	#$4E71,(A5)+
	BSR	COPY_STAB
	MOVEQ	#2,D7
	BSR	PUT_ORS
	BSR	COPY_BORD_GAUCHE
	MOVEQ	#21,D7	22 ORS=88 NOPS
	BSR	PUT_ORS
	BSR	COPY_BORD_DROIT
	MOVEQ	#2,D7
	BSR	PUT_ORS
	MOVE.W	#$4E71,(A5)+
	BSR	COPY_STAB
	MOVE.L	#$22582458,(A5)+  MOVE.L (A0)+,A1; MOVE.L (A0)+,A2 : 6 NOPS
	MOVE.L	#$26584E71,(A5)+  MOVE.L (A0)+,A3
	MOVE.W	#$4ED1,(A5)+	;JMP	(A1)
	ADDQ.W	#1,D4
	CMPI.W	#16,D4
	BLT.S	.MAK_ALL_DEC
	DBRA	D5,.CODE_ALL_Z
	MOVE.L	A0,MG_1
	MOVE.L	A5,MG_2
	MOVE.L	A6,MG_3
	RTS

PREPARE_SECOND	
MG_1 = *+2
	LEA	$12345678,A0
	LEA	CORES_X_2+56*8*2*2+BSS_PERMANENTE,A2
MG_2 = *+2
	LEA	$12345678,A5
MG_3 = *+2
	LEA	$12345678,A6
	MOVEQ	#19,D5
.CODE_ALL_Z	MOVE.W	(A0),D0
	LEA	12(A0),A0	ON SAUTE 6 Z
	MOVEQ	#0,D4	DECALAGE
.MAK_ALL_DEC	LEA	CERCLE,A1
	MOVE.L	A5,(A6)+
	BSR	COPY_BORD_GAUCHE
	MOVEQ	#21,D7	22 ORS=88 NOPS
	BSR	PUT_ORS
	BSR	COPY_BORD_DROIT
	MOVEQ	#2,D7
	BSR	PUT_ORS
	MOVE.W	#$4E71,(A5)+
	BSR	COPY_STAB
	MOVEQ	#2,D7
	BSR	PUT_ORS
	BSR	COPY_BORD_GAUCHE
	MOVEQ	#21,D7	22 ORS=88 NOPS
	BSR	PUT_ORS
	BSR	COPY_BORD_DROIT
	MOVEQ	#2,D7
	BSR	PUT_ORS
	MOVE.W	#$4E71,(A5)+
	BSR	COPY_STAB
	MOVE.L	#$22582458,(A5)+  MOVE.L (A0)+,A1; MOVE.L (A0)+,A2 : 6 NOPS
	MOVE.L	#$26584E71,(A5)+  MOVE.L (A0)+,A3
	MOVE.W	#$4ED1,(A5)+	;JMP	(A1)
	ADDQ.W	#1,D4
	CMPI.W	#16,D4
	BLT.S	.MAK_ALL_DEC
	DBRA	D5,.CODE_ALL_Z

COPY_BORD_GAUCHE
	MOVE.L	A6,-(SP)
	LEA	.ADR,A6
	MOVE.L	(A6)+,(A5)+
	MOVE.W	(A6)+,(A5)+
	MOVE.L	(SP)+,A6
	RTS
.ADR	BORD_GAUCHE

COPY_BORD_DROIT	MOVE.L	A6,-(SP)
	LEA	.ADR,A6
	MOVE.L	(A6)+,(A5)+
	MOVE.W	(A6)+,(A5)+
	MOVE.L	(SP)+,A6
	RTS
.ADR	BORD_DROIT

COPY_STAB	MOVE.L	A6,-(SP)
	LEA	.ADR,A6
	MOVE.L	(A6)+,(A5)+
	MOVE.W	(A6)+,(A5)+
	MOVE.L	(SP)+,A6
	RTS
.ADR	STAB

PUT_ORS
.CODE_UN_CERCLE	LEA	DIFFERENTS_ORS,A4
	MOVE.W	(A1)+,D1	X
;	ADDI.W	#80,D1
	MOVE.W	(A1)+,D2	Y
;	ADDI.W	#80,D2
	MULS.W	D0,D1
	MULS.W	D0,D2
	ADD.L	D1,D1
	ADD.L	D2,D2
	SWAP	D1	X PROJET�
	SWAP	D2	Y PROJET�
	ADD.W	D4,D1	ON ADDITIONNE LE DECALAGE
	ADD.W	D1,D1
	ADD.W	D1,D1	X*4
	TST.W	D2
	BGE.S	.CONTINUE
	LEA	DIFFERENTS_ORS2,A4
	ADDI.W	#135,D2
	LEA	CORES_Y_2+200*2+135*2+BSS_PERMANENTE,A3
	BRA.S	.START
.CONTINUE	SUBI.W	#135,D2
	LEA	CORES_Y_2+200*2+135*2+BSS_PERMANENTE,A3
.START	ADD.W	D2,D2	Y*2
	MOVE.W	(A2,D1.W),D3	0-->7
	MOVE.W	2(A2,D1.W),D1
	ADD.W	(A3,D2.W),D1	OFFSET ECRAN PEUT-ETRE IMPAIR
	ADD.W	D3,D3
	ADD.W	D3,D3	D3*4
	MOVE.W	(A4,D3.W),(A5)+	INSTRUCTION
	MOVE.W	D1,(A5)+	OFFSET
	DBRA	D7,.CODE_UN_CERCLE
	RTS

DIFFERENTS_ORS	EOR.B	D0,0(A2)
	EOR.B	D1,0(A2)
	EOR.B	D2,0(A2)
	EOR.B	D3,0(A2)
	EOR.B	D4,0(A2)
	EOR.B	D5,0(A2)
	EOR.B	D6,0(A2)
	EOR.B	D7,0(A2)
DIFFERENTS_ORS2	EOR.B	D0,0(A3)
	EOR.B	D1,0(A3)
	EOR.B	D2,0(A3)
	EOR.B	D3,0(A3)
	EOR.B	D4,0(A3)
	EOR.B	D5,0(A3)
	EOR.B	D6,0(A3)
	EOR.B	D7,0(A3)

FADE_UP	DC.W	$000,$000,$000
	DC.W	$101,$000,$000
	DC.W	$202,$000,$000
	DC.W	$313,$101,$000
	DC.W	$424,$202,$000
	DC.W	$535,$313,$101
	DC.W	$646,$424,$202
	DC.W	$757,$535,$313

FADE_DOWN	DC.W	$757,$535,$313
	DC.W	$646,$424,$202
	DC.W	$535,$313,$101
	DC.W	$424,$202,$000
	DC.W	$313,$101,$000
	DC.W	$202,$000,$000
	DC.W	$101,$000,$000
	DC.W	$000,$000,$000

FADE_UP_3	DC.W	$000,$000,$000
	DC.W	$111,$001,$001
	DC.W	$222,$002,$002
	DC.W	$333,$122,$122
	DC.W	$444,$233,$233
	DC.W	$555,$344,$344
	DC.W	$666,$455,$455
	DC.W	$777,$566,$566

FADE_DOWN_3	DC.W	$777,$566,$566
	DC.W	$666,$455,$455
	DC.W	$555,$344,$344
	DC.W	$444,$233,$233
	DC.W	$333,$122,$122
	DC.W	$222,$002,$002
	DC.W	$111,$001,$001
	DC.W	$000,$000,$000

;ZIK	INCBIN	BUGGIN6.MUS

COOR_STARS	INCBIN	STARS.STR

COEFF_STARS	INCBIN	COEFF.STR

CRB_X	INCBIN	COURBE_X.CRB
	DC.W	$1234

CRB_Y	INCBIN	COURBE_Y.CRB
	DC.W	$1234

CRB_Z	INCBIN	COURBE_Z.CRB
	DC.W	$1234

SINUS	INCBIN	DUCK2.SIN

TABLE_EXP	INCBIN	TABLEEXP.DAT
LONG_EXP = *-TABLE_EXP

COEFF_3D	INCBIN	COEFF128.3D

	DCB.W	2500,3*(LONG_EXP/2)
	DC.W	3*(LONG_EXP/2)
TABLE_LOG	INCBIN	TABLELOG.DAT
	DCB.W	300,0

CERCLE	INCBIN	CERCLE4.DAT

COEFF_3D_TUN	INCBIN	COEFF.TUN

COURBE_TUNNEL	INCBIN	COURBE.TUN
FIN_CRB

	SECTION	BSS
	;PT_ECRANS+ PT_FADE
BSS_DEB
NB_VBL	DS.W	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
PT_DEMO	DS.W	1
PT_FADE	DS.L	1
NB_FADE	DS.W	1
FLAG_WAIT	DS.W	1
	;
BSS_JUSTE	DS.B	20000
	;
BSS_PERMANENTE	;DS.B	402000+266240+112000+55000+132000
	DS.B	LONG_BSS
BSS_END