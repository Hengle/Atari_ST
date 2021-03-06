;Hot, No?
	RSRESET
Y	RS.W	1
X	RS.W	1
PT_MOVE	RS.W	1
TABLE_MOTIFS	RS.W	(1+1)*16*16
BUF_MOTIFS	RS.B	752
BUF_HOTNO	RS.B	160
LONG_BSS	RS.B	1

	OUTPUT	A:\HOT_NO.BIN

LINK = 1	;1 POUR LINKER
DEBUG = 0	;1 POUR DEBUGGER SANS SE FAIRE CHIER, 0 POUR EXECUTER

WAIT	MACRO
	MOVE.W	#\1,D7
\@BCL	DBRA	D7,\@BCL
	ENDM

CPU	MACRO
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	\@PAS_TOUCHE
	MOVE.W	#\1,$FFFF8240.W
\@PAS_TOUCHE	
	ENDM

COUL	MACRO
	MOVE.W	#\2,$FFFF8240+(\1*2).W
	ENDM

	MOVE.L	A0,ADR_MUSIC
	BSR	PREP_ECR
	BSR	PREPARE_HOTNO

	MOVE.L	#VBLR,$70.W
	MOVE.L	#TB0,$120.W

	CLR.W	NB_VBL
	JMP	IT_VBL

FIN	ILLEGAL
	
	*******	V B L  &  P R O C E D U R E S    *******
VBLR	ADDQ.W	#1,NB_VBL
	MOVEM.L	D0-A6,-(SP)
ADR_MUSIC = *+2
	JSR	$12345678
	MOVEM.L	(SP)+,D0-A6
	RTE
	
TB0	RTE

IT_VBL	BSR	VSYNC
	CPU	$700

	MOVE.W	#$545,$FFFF8242.W
	LEA	BSS_DEMO,A6

	MOVE.L	SCREEN2,A0
	LEA	160*8(A0),A0
	MOVEQ	#0,D0
	MOVE.W	#75,D7
	BSR	EFFAC
	MOVE.L	SCREEN2,A0
	LEA	160*108(A0),A0
	MOVEQ	#0,D0
	MOVE.W	#75,D7
	BSR	EFFAC

	BSR	AFF_HOTNO
	BSR	SWAPEC
	COUL	0,0

	JMP	IT_VBL

VSYNC	CMPI.W	#1,NB_VBL
	BLT.S	VSYNC
	CLR.W	NB_VBL
	RTS

EFFAC
.RECOM_EFF	MOVE.W	D0,(A0)
	MOVE.W	D0,8(A0)
	MOVE.W	D0,16(A0)
	MOVE.W	D0,24(A0)
	MOVE.W	D0,32(A0)
	MOVE.W	D0,40(A0)
	MOVE.W	D0,48(A0)
	MOVE.W	D0,56(A0)
	MOVE.W	D0,64(A0)
	MOVE.W	D0,72(A0)
	MOVE.W	D0,80(A0)
	MOVE.W	D0,88(A0)
	MOVE.W	D0,96(A0)
	MOVE.W	D0,104(A0)
	MOVE.W	D0,112(A0)
	MOVE.W	D0,120(A0)
	MOVE.W	D0,128(A0)
	MOVE.W	D0,136(A0)
	MOVE.W	D0,144(A0)
	MOVE.W	D0,152(A0)
	LEA	160(A0),A0
	DBRA	D7,.RECOM_EFF
	RTS

AFF_HOTNO	LEA	MOVE_HOT_NO(PC),A0
	ADDA.W	PT_MOVE(A6),A0
	CMPI.W	#$1234,(A0)
	BNE.S	.FUCK
	BRA	FIN
.FUCK	ADDI.W	#14,PT_MOVE(A6)
	MOVEQ	#0,D2
	MOVE.W	(A0),D2	;LONGUEUR*256
	MOVEQ	#0,D3
	MOVE.W	2(A0),D3	;HAUTEUR*256
	MOVE.L	4(A0),D0
	ASL.L	#8,D0
	MOVEQ	#0,D1
	MOVE.W	#20*256,D1	;Y
	MOVE.W	12(A0),D5
	ASL.W	#8,D5
	SUB.W	D5,D1
	LEA	BUF_HOTNO(A6),A3
	MOVE.L	A0,-(SP)
	BSR	AFF_BLOC
	MOVE.L	(SP)+,A0

	MOVEQ	#0,D2
	MOVE.W	(A0),D2	;LONGUEUR*256
	MOVEQ	#0,D3
	MOVE.W	2(A0),D3	;HAUTEUR*256
	MOVE.L	8(A0),D0
	ASL.L	#8,D0
	MOVEQ	#0,D1
	MOVE.L	#120*256,D1	;Y
	MOVE.W	12(A0),D5
	ASL.W	#8,D5
	SUB.W	D5,D1
	LEA	BUF_HOTNO+(5*16)(A6),A3
	BSR	AFF_BLOC
.NO_AFF	RTS

	;D1: 1.W Y DE BASE + 1.W Y ACTUEL = 1.L !
	;D3: 1.W HAUTEUR*160 + 1.W HAUTEUR-1 = 1.L !
AFF_BLOC	MOVE.L	D1,Y(A6)
	LEA	TABLE_MOTIFS(A6),A0
	MOVE.W	D2,D4
	LSR	#8,D4
;	SUBQ.W	#1,D4
	LSL	#6,D4
	ADDA.W	D4,A0	;A0=ADRESSE DE BASE DE L'INFO SUR LE MOTIF

	MOVEQ	#15,D7

RECOM_ALL	MOVE.L	Y(A6),D1
	MOVE.L	SCREEN2,A4
	MOVE.L	D0,D4
	ASR.L	#8,D4
	CMPI.W	#320,D4
	BGE	NO_MORE
	MOVE.L	D0,D4
	ADD.L	D2,D4
	ASR.L	#8,D4
	CMPI.W	#320,D4
	BGE	CLIP_DROIT
	MOVE.L	D0,D4
	BLT	CLIP_GAUCHE
	ASR.L	#8,D4
	ANDI.W	#$FFF0,D4
	LSR	#1,D4
	ADDA.W	D4,A4	;A4=ADRESSE ECRAN DE LA COLONNE

	MOVE.L	D0,D4
	ASR.L	#8,D4
	ANDI.W	#15,D4
	ADD.W	D4,D4
	ADD.W	D4,D4
	LEA	BUF_MOTIFS(A6),A1
	ADDA.W	(A0,D4.W),A1	;A1=ADRESSE DU MOTIF SUR 1 OU 2 .W
	TST.W	2(A0,D4.W)
	BNE	ROUT_AFF_2
ROUT_AFF_1	MOVE.W	(A1),D6	;D6=MOTIF SUR 1.W
	MOVEQ	#4,D5
.RECOM_COLONNE	MOVE.L	A4,A5
	MOVE.L	D1,D4
	ASR.L	#8,D4
	MULU.W	#160,D4
	ADDA.W	D4,A5
	MOVE.B	(A3)+,D4
	BEQ.S	.NEXT_CARRE_Y
	MOVE.L	D3,D4
	ASR.L	#8,D4
;	SUBQ.W	#1,D4
.RECOP_1	OR.W	D6,(A5)
	LEA	160(A5),A5
	DBRA	D4,.RECOP_1
;	BRA.S	.FUCK
.NEXT_CARRE_Y	ADD.L	D3,D1	;Y=Y+HAUTEUR
.FUCK	DBRA	D5,.RECOM_COLONNE
	BRA	APRES_ROUTS
ROUT_AFF_2	MOVE.W	2(A1),D6
	MOVEQ	#4,D5
.RECOM_COLONNE	MOVE.L	A4,A5
	MOVE.L	D1,D4
	ASR.L	#8,D4
	MULU.W	#160,D4
	ADDA.W	D4,A5
	MOVE.B	(A3)+,D4
	BEQ.S	.NEXT_CARRE_Y
	MOVE.L	D3,D4
	ASR.L	#8,D4
;	SUBQ.W	#1,D4
.RECOP_2	MOVE.W	(A1),D6
	OR.W	D6,(A5)
	MOVE.W	2(A1),D6
	OR.W	D6,8(A5)
	LEA	160(A5),A5
	DBRA	D4,.RECOP_2
;	BRA.S	.FUCK
.NEXT_CARRE_Y	ADD.L	D3,D1	;Y=Y+HAUTEUR
.FUCK	DBRA	D5,.RECOM_COLONNE
APRES_ROUTS	ADD.L	D2,D0
	DBRA	D7,RECOM_ALL
NO_MORE	RTS

CLIP_DROIT	MOVE.L	D0,D4
	ASR.L	#8,D4
	ANDI.W	#$FFF0,D4
	LSR	#1,D4
	ADDA.W	D4,A4	;A4=ADRESSE ECRAN DE LA COLONNE

	MOVE.L	D0,D4
	ASR.L	#8,D4
	ANDI.W	#15,D4
	ADD.W	D4,D4
	ADD.W	D4,D4
	LEA	BUF_MOTIFS(A6),A1
	ADDA.W	(A0,D4.W),A1	;A1=ADRESSE DU MOTIF SUR 1 OU 2 .W
	MOVE.W	2(A1),D6
	MOVEQ	#4,D5
.RECOM_COLONNE	MOVE.L	A4,A5
	MOVE.W	D1,D4
	ASR.W	#8,D4
	MULU.W	#160,D4
	ADDA.W	D4,A5
	MOVE.B	(A3)+,D4
	BEQ.S	.NEXT_CARRE_Y
	MOVE.W	D3,D4
	ASR.W	#8,D4
.RECOP_2	MOVE.W	(A1),D6
	OR.W	D6,(A5)
	LEA	160(A5),A5
	DBRA	D4,.RECOP_2
;	BRA.S	.FUCK
.NEXT_CARRE_Y	ADD.W	D3,D1
.FUCK	DBRA	D5,.RECOM_COLONNE
	RTS

CLIP_GAUCHE	ASR.L	#8,D4
	NEG.W	D4
	MOVE.L	D2,D5
	ASR.L	#8,D5
	CMP.W	D5,D4
	BLT	.OK
	ADDQ.W	#5,A3
	BRA	APRES_ROUTS
.OK	;A5=ADRESSE ECRAN DE LA COLONNE
	MOVE.L	D0,D4
	ASR.L	#8,D4
	ANDI.W	#15,D4
	ADD.W	D4,D4
	ADD.W	D4,D4
	LEA	BUF_MOTIFS(A6),A1
	ADDA.W	(A0,D4.W),A1	;A1=ADRESSE DU MOTIF SUR 1 OU 2 .W

	MOVE.W	2(A1),D6
	MOVEQ	#4,D5
.RECOM_COLONNE	MOVE.L	A4,A5
	MOVE.L	D1,D4
	ASR.L	#8,D4
	MULU.W	#160,D4
	ADDA.W	D4,A5
	MOVE.B	(A3)+,D4
	BEQ.S	.NEXT_CARRE_Y
	MOVE.W	D3,D4
	ASR.W	#8,D4
.RECOP_2	OR.W	D6,(A5)
	LEA	160(A5),A5
	DBRA	D4,.RECOP_2
;	BRA.S	.FUCK
.NEXT_CARRE_Y	ADD.L	D3,D1
.FUCK	DBRA	D5,.RECOM_COLONNE
	BRA	APRES_ROUTS

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
	MOVE.L	SCREEN1,A0
	MOVE.W	#15999,D7
.FF	CLR.L	(A0)+
	DBRA	D7,.FF
	RTS

PREPARE_HOTNO	MOVE.L	#$8000,D0
	MOVEQ	#15,D7	;NB DE BOUCLES -1
	MOVEQ	#-1,D6
	MOVE.W	#$4000,D2
	LEA	BUF_MOTIFS+BSS_DEMO,A0
	LEA	TABLE_MOTIFS+BSS_DEMO,A1
	MOVEQ	#0,D4	;OFFSET DE DEPART=0
.NB_MOTIFS	MOVE.W	D7,D5
.RECOP_BETE	MOVE.W	D0,(A0)+
	MOVE.W	D4,(A1)+
	ADDQ.W	#2,D4	;OFFSET=OFFSET+2
	CLR.W	(A1)+	;LONGUEUR: 0 OU -1 !
	ROR.L	#1,D0
	DBRA	D5,.RECOP_BETE
	MOVE.W	D6,D5
	BLT.S	.FUCK2
.RECOP_PAS_BETE	MOVE.L	D0,D1
	SWAP	D1
	MOVE.W	D0,(A0)+
	MOVE.W	D1,(A0)+
	MOVE.W	D4,(A1)+
	ADDQ.W	#4,D4	;OFFSET=OFFSET+4
	NOT.W	(A1)+	;-1 OU N'IMPORTE QUOI D'AUTRE !
	ROR.L	#1,D0
	DBRA	D5,.RECOP_PAS_BETE
.FUCK2	ADDQ.W	#1,D6
	SWAP	D0
	OR.W	D2,D0
	LSR.W	#1,D2
	DBRA	D7,.NB_MOTIFS	

	LEA	BUF_HOTNO+BSS_DEMO,A1
	LEA	HOT(PC),A0
	BSR	TEST_MESS
	LEA	NO_(PC),A0
	BSR	TEST_MESS
	CLR.W	PT_MOVE+BSS_DEMO
	RTS

TEST_MESS	MOVEQ	#15,D1
.BCL_2	MOVEQ	#4,D7
.BCL_1	MOVE.W	(A0)+,D0
	BTST	D1,D0
	BNE.S	.SOMETHING
	CLR.B	(A1)
	BRA.S	.CACA
.SOMETHING	ST	(A1)
.CACA	ADDQ.W	#1,A1
	DBRA	D7,.BCL_1
	LEA	-10(A0),A0
	DBRA	D1,.BCL_2
	RTS

HOT	DC.W	%1001001100111110
	DC.W	%1001010010001000
	DC.W	%1111010010001000
	DC.W	%1001010010001000
	DC.W	%1001001100001000

NO_	DC.W	%1000100110001100
	DC.W	%1100101001010010
	DC.W	%1010101001000100
	DC.W	%1001101001000000
	DC.W	%1000100110000100

MOVE_HOT_NO	INCBIN	DEF_MOVE.HOT
	DC.W	$1234

	SECTION	BSS
	DS.B	256+640
BUFFER	DS.L	16000
SCREEN1	DS.L	1
SCREEN2	DS.L	1
NB_VBL	DS.W	1
;
BSS_DEMO	DS.B	LONG_BSS