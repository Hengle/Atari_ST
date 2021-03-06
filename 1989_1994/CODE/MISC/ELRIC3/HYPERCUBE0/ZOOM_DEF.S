;COD� LE 13 AVRIL 1993 / TAB=16
LONGUEUR = 32
NB_ZOOMS = 120
STEP_INTER_Z = 12
;LONGUEUR=28 : BUF_COD=45000, CORES_2=50000
;LONGUEUR=24 : BUF_COD=32000, CORES_2=53000
;LONGUEUR=20 : BUF_COD=21000, CORES_2=57000
;LONGUEUR=16 : BUF_COD=16000, CORES_2=60000

MAIN	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.W	#6,SP

	CLR.W	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	BSR	PREP_ECR
	BSR	PREP_ZOOMS

	MOVE.W	#$2700,SR
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	MOVE.L	#VBLR,$70.W
	MOVE.W	#$2300,SR

IT_VBL	;BSR	VSYNC
	TST.B	FLAG_NEXT_ZOOM
	BEQ.S	.NO_MAKE
	BSR	PREP_NEXT_ZOOM
.NO_MAKE	BRA	IT_VBL

VSYNC	CMPI.W	#1,NB_VBL
	BLT.S	VSYNC
	CLR.W	NB_VBL
	RTS

GEST_ZOOM	MOVE.L	ADR_EFF_Z,A5
	MOVE.W	NUMER,D0
	ADD.W	D0,D0
	LEA	TABLE_COLORS_Z,A6
	MOVE.W	(A6,D0.W),COLOR_ACTU_Z
	ADD.W	D0,D0
	LEA	ADR_ZOOMS,A6
	MOVE.L	(A6,D0.W),A6	;ADRESSE DU ZOOM
	LEA	CORES_CARR�S_1,A4
	MOVE.L	(A4,D0.W),A4
	LEA	BUF_ANNEX,A3
	ADDA.W	D0,A3
	MOVE.L	(A3)+,(A5)
	MOVEQ	#6,D6
.NEXT_LIGNE	MOVE.L	SCREEN2,A1
	ADDA.W	(A6)+,A1	;A1=ADRESSE ECRAN
	MOVE.W	(A6)+,D7	;NB DE CARR� A TRAITER -1
.RECOM_AFF_LINE	MOVEQ	#0,D0
	MOVE.B	(A6)+,D0	;No DU CARR�
	ADD.W	D0,D0
	MOVE.W	D0,D2
	ADD.W	D2,D2
	ADD.W	D2,D0	;D0=D0*6
	MOVE.L	2(A4,D0.W),A3
	MOVEQ	#0,D1
	MOVE.B	(A6)+,D1
	MOVE.L	A1,A0
	ADDA.W	D1,A0
	JSR	(A3)	ON AFFICHE LE CARR�
	DBRA	D7,.RECOM_AFF_LINE
	DBRA	D6,.NEXT_LIGNE
	MOVE.W	NUMER,D0
	ADDQ.W	#1,D0
	CMPI.W	#NB_ZOOMS,D0
	BLT.S	.FUCK
	ST	FLAG_NEXT_ZOOM
	MOVEQ	#0,D0
.FUCK	MOVE.W	D0,NUMER

	LEA	ADR_EFF_Z,A5
	MOVE.L	(A5)+,D0
	MOVE.L	(A5),-(A5)
	MOVE.L	D0,4(A5)
	RTS

EFFAC_ZOOM	CMPI.B	#2,FLAG_EFFAC_ZOOM
	BEQ.S	.NO_EFFAC
	MOVE.L	SCREEN2,A0
	MOVE.L	ADR_EFF_Z,A1
	ADDA.W	(A1)+,A0
	MOVE.W	(A1),D7
	ADDQ.W	#2,D7
	MOVEQ	#0,D0	
.EFF	MOVE.W	D0,(A0)
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
	DBRA	D7,.EFF
	TST.B	FLAG_NEXT_ZOOM
	BEQ.S	.NO_EFFAC
	ADDQ.B	#1,FLAG_EFFAC_ZOOM
.NO_EFFAC	RTS

VBLR	MOVEM.L	D0-A6,-(SP)
	MOVE.W	COLOR_ACTU_Z,$FFFF8242.W
	ADDQ.W	#1,NB_VBL
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	.NO_TAB
	MOVE.W	#$300,$FFFF8240.W
.NO_TAB	BSR	EFFAC_ZOOM
	TST.B	FLAG_NEXT_ZOOM
	BNE.S	.NO_AFF
	BSR	GEST_ZOOM
.NO_AFF	BSR	SWAPEC
	CLR.W	$FFFF8240.W
	MOVEM.L	(SP)+,D0-A6
	RTE

SWAPEC	MOVE.L	SCREEN1,D0
	MOVE.L	SCREEN2,SCREEN1
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREP_ECR	MOVE.L	#BUFFER,D0
	CLR.B	D0
	ADDI.W	#32*160,D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000+32*160,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	RTS

PREP_NEXT_ZOOM	CLR.W	ADDIT
	MOVE.L	PT_MESS,A0
	CMPI.B	#-1,(A0)
	BNE.S	.PAS_LOOP
	LEA	MESSAGE(PC),A0
.PAS_LOOP	MOVEQ	#0,D0
	MOVE.B	(A0)+,D0	;TYPE DE FONTE(0-1)
	ADD.W	D0,D0
	ADD.W	D0,D0
	LEA	ADR_FONTS(PC),A5
	MOVE.L	(A5,D0.W),A5	;A1=ADRESSE DES FONTES
	MOVE.B	(A0)+,D0	;D0=N=NB DE LETTRES...
	MOVE.W	D0,D7	;D7=N
	SUBQ.W	#1,D7	;...-1
	MULU.W	#8*LONGUEUR,D0	;D0=LONGUEUR EN X
	LSR.W	#1,D0	;/2
	NEG.W	D0	;D0=X DE D�PART

	LEA	BUF_CALC,A1
	MOVE.W	#-(LONGUEUR*7)/2,D5    ;Y0
	MOVEQ	#6,D6
.NEXT_LIGNE	MOVE.W	D0,D4	;X DE DEPART
	MOVE.L	A0,-(SP)
	MOVEQ	#0,D2	;ZERO CARR�S
	LEA	4(A1),A2
	MOVE.W	D7,D3
.NEXT_LETTRE	MOVE.W	D3,A6
	MOVEQ	#0,D1
	MOVE.B	(A0)+,D1
	SUBI.B	#32,D1
	LSL.W	#3,D1
	MOVE.L	A5,A4
	ADDA.W	D1,A4	;A4=ADR DE LA FONTE
ADDIT = *+2
	ADDA.W	#0,A4
	MOVE.B	(A4)+,D1
	MOVEQ	#7,D3
.NEXT_BIT	BTST	D3,D1
	BEQ.S	.NOTHING
	MOVE.W	D4,(A2)+	;ON POSE LE X
	ADDQ.W	#1,D2	;UN CARR� DE PLUS
.NOTHING	ADDI.W	#LONGUEUR,D4	;X=X+LONGUEUR
	DBRA	D3,.NEXT_BIT
	MOVE.W	A6,D3
	DBRA	D3,.NEXT_LETTRE
	MOVE.L	(SP)+,A0
	MOVE.W	D5,(A1)+
	SUBQ.W	#1,D2
	MOVE.W	D2,(A1)
	MOVE.L	A2,A1
	ADDI.W	#LONGUEUR,D5
	ADDQ.W	#1,ADDIT
	DBRA	D6,.NEXT_LIGNE
	ADDA.W	D7,A0
	ADDQ.W	#1,A0	;A0=PROCHAIN MESSAGE
	MOVE.L	A0,PT_MESS

	LEA	COEFF_3D+(2*(NB_ZOOMS-1)*STEP_INTER_Z)(PC),A0
	LEA	CORES_CARR�S_1,A1
	LEA	BUF_ZOOMS,A6
	LEA	ADR_ZOOMS,A5
	MOVE.W	#NB_ZOOMS-1,D4
.NEXT_ZOOM	LEA	BUF_CALC,A2
	MOVE.L	A6,(A5)+
	MOVEQ	#6,D7
.NEXT_LINE	MOVE.L	(A1),A3
	MOVE.W	(A3)+,D0	;X MIN
	MOVE.W	(A0),D1	;COEFF 3D
	MOVE.W	(A2)+,D2	;Y DE LA LIGNE	
	ADD.W	D2,D2
	MULS.W	D1,D2
	SWAP	D2
	ADDI.W	#100,D2
	CMPI.W	#-32,D2
	BGT.S	.PAS_ENCORE_CLIP_Y
	CLR.W	(A6)+
	MOVE.W	#-1,(A6)+
	MOVE.W	(A2)+,D2
	ADD.W	D2,D2
	ADDA.W	D2,A2
	BRA.S	.ANOTHER_END
.PAS_ENCORE_CLIP_Y
	MULU.W	#160,D2	;Y*160
	MOVE.W	D2,(A6)+	;ON LE POSE
	MOVEQ	#0,D5
	MOVE.W	(A2)+,D2	;NB DE CARR�S-1
	LEA	2(A6),A4
	MOVEQ	#0,D6
.NEXT_X	MOVE.W	(A2)+,D3	;X
	ADD.W	D3,D3
	MULS.W	D1,D3
	SWAP	D3	;X PROJET�
	ADDI.W	#160,D3
	CMPI.W	#320,D3
	BGE.S	.FINITO
	CMP.W	D0,D3
	BLT.S	.HAHA
.RETRY	CMP.W	D0,D3
	BNE.S	.LE_PROCHAIN
	ADDQ.W	#1,D6
	MOVE.B	D5,(A4)+	;No DU CARR�
	TST.W	D0
	BGE.S	.X_POSITIF
	CLR.B	(A4)+	;ZERO SI CLIPPING GAUCHE
	BRA.S	.NOT_YET
.X_POSITIF	ANDI.W	#$FFF0,D0
	LSR.W	#1,D0
	MOVE.B	D0,(A4)+	;L'OFFSET
	BRA.S	.NOT_YET
.LE_PROCHAIN	ADDQ.W	#1,D5
	ADDQ.W	#4,A3
	MOVE.W	(A3)+,D0	;NEXT X
	BRA.S	.RETRY
.NOT_YET	ADDQ.W	#1,D5
	ADDQ.W	#4,A3
	MOVE.W	(A3)+,D0	;NEXT X
.HAHA	DBRA	D2,.NEXT_X
	BRA.S	.APRES_FINITO
.FINITO	ADD.W	D2,D2
	ADDA.W	D2,A2
.APRES_FINITO	SUBQ.W	#1,D6
	MOVE.W	D6,(A6)
	MOVE.L	A4,A6
.ANOTHER_END	DBRA	D7,.NEXT_LINE
	ADDQ.W	#4,A1
	LEA	-STEP_INTER_Z*2(A0),A0
	DBRA	D4,.NEXT_ZOOM

	LEA	COEFF_3D+(2*(NB_ZOOMS-1)*STEP_INTER_Z)(PC),A0
	LEA	BUF_ANNEX,A1
	MOVE.W	#NB_ZOOMS-1,D7
.REPEAT_1	MOVE.W	(A0),D0
	MOVE.W	#-112*2,D1
	MOVE.W	#224*2,D2
	MULS.W	D0,D1
	SWAP	D1
	ADDI.W	#100,D1
	MULU.W	D0,D2
	SWAP	D2
	TST.W	D1
	BGE.S	.Y_POSITIF
	MOVEQ	#0,D1
.Y_POSITIF	MULU.W	#160,D1
	MOVE.W	D1,(A1)+	;ON POSE LE Y*160
	CMPI.W	#200,D2
	BLE.S	.HAUT_INF_200
	MOVE.W	#200,D2
.HAUT_INF_200	SUBQ.W	#1,D2
	MOVE.W	D2,(A1)+
	LEA	-STEP_INTER_Z*2(A0),A0
	DBRA	D7,.REPEAT_1

	SF	FLAG_NEXT_ZOOM
	SF	FLAG_EFFAC_ZOOM
	RTS

ADR_FONTS	DC.L	FONTS_2,FONTS_2

PREP_ZOOMS	LEA	COEFF_3D+(2*(NB_ZOOMS-1)*STEP_INTER_Z)(PC),A1
	MOVE.W	#$7FFF,COEFF_3D
	LEA	BUF_COD_CARR�S,A2
	LEA	CORES_CARR�S_1,A3
	LEA	CORES_CARR�S_2,A4
	MOVEQ	#NB_ZOOMS-1,D6
.NEXT_ZOOM	LEA	BUF_CALC,A0
	MOVE.W	#-LONGUEUR*48,D0   ;X DE D�PART
	MOVE.W	(A1),D2
	MOVE.W	#160,D3	;ABSCISSE DU CENTRE
	MOVE.L	A4,(A3)+
	MOVEQ	#-1+12*8,D7	;96 CARR�S SUR UNE LIGNE
.FUCK	MOVE.W	D0,D1
	ADD.W	D1,D1
	MULS.W	D2,D1
	SWAP	D1	;X PROJET�
	ADD.W	D3,D1	;X+160:RECENTRAGE
	MOVE.W	D1,(A0)+
	ADDI.W	#LONGUEUR,D0
	DBRA	D7,.FUCK
	MOVEQ	#LONGUEUR,D0
;	CMPI.W	#$7FFF,D2
;	BEQ.S	.ALL_RIGHT
	ADD.W	D0,D0
	MULU.W	D2,D0	;PAS BESOIN DE MULS
	SWAP	D0	;LONGUEUR PROJET�E
	ADDQ.W	#1,D0
.ALL_RIGHT	BSR	MAKE_CARR�S_ON_THE_ACTUAL_LINE
	LEA	-STEP_INTER_Z*2(A1),A1
	DBRA	D6,.NEXT_ZOOM

	MOVE.L	#MESSAGE,PT_MESS
	MOVE.W	#0,NUMER
	LEA	BUF_EFF_Z,A0
	LEA	4(A0),A1
	LEA	ADR_EFF_Z,A2
	MOVE.L	A0,(A2)+
	MOVE.L	A1,(A2)

	ST	FLAG_NEXT_ZOOM
	ST	FLAG_EFFAC_ZOOM
	RTS

MAKE_CARR�S_ON_THE_ACTUAL_LINE
	MOVEM.L	D0-D7,-(SP)
	MOVE.W	D0,D2	;COPY LONGUEUR DANS D2
	LEA	CORES_LONG_CARR�S,A6
	LSL.W	#6,D2
	ADDA.W	D2,A6
	MOVE.W	D0,D2
	LEA	PLACE_DECAL,A0
	CLR.L	(A0)
	CLR.W	4(A0)
	SUBQ.W	#1,D0
	MOVE.L	#$80000000,D1
.RECOM_BSET	OR.L	D1,(A0)
	LSR.L	#1,D1
	DBRA	D0,.RECOM_BSET
	LEA	BUF_CALC,A0
	MOVEQ	#-1+12*8,D7	;96 CARR�S
.NEXT_X	MOVE.W	(A0)+,D0	;X ECRAN
	MOVEQ	#0,D4	;D4-->D6:REGISTRES
	MOVEQ	#0,D5	;CONTENANT LE GRAF
	MOVEQ	#0,D6	;DU MOTIF DECAL� & CLIPP�

	CMPI.W	#320,D0
	BGE	.NOTHING_HERE
	MOVE.W	D0,D1
	ADD.W	D2,D1
	SUBQ.W	#1,D1
	BLT	.NOTHING_HERE

	MOVE.W	D0,(A4)+	;ON POSE LE X
	MOVE.L	A2,(A4)+	;ON POSE LA ROUTINE
	LEA	PLACE_DECAL(PC),A5
	MOVE.W	D0,D1
	ANDI.W	#15,D1	;DECALAGE
	MOVE.W	D1,D3
	MOVE.W	(A5)+,D4
	MOVE.W	(A5)+,D5
	MOVE.W	(A5),D6
	ROR.L	D1,D4
	ROR.L	D1,D5
	ROR.W	D1,D6	
	SWAP	D4
	OR.W	D4,D5
	SWAP	D5
	OR.W	D5,D6
	SWAP	D4
	SWAP	D5

	MOVE.W	D0,D1
	ADD.W	D2,D1
	SUBQ.W	#1,D1
	CMPI.W	#320,D1
	BLT.S	.NO_RIGHT_CLIP
	;CLIPPING_DROIT
	ANDI.W	#$FFF0,D0
	MOVE.W	#320,D1
	SUB.W	D0,D1
	SUBQ.W	#1,D1
	LSR.W	#4,D1	;NB DE MOTS A AFFICHER
	ADDQ.W	#1,D1
	CMPI.W	#1,D1
	BNE.S	.TEST_2
	MOVEQ	#0,D5
	MOVEQ	#0,D6
	BRA.S	.TRAITE
.TEST_2	MOVEQ	#0,D6
	BRA.S	.TRAITE
.NO_RIGHT_CLIP	TST.W	D0
	BLT.S	.LEFT_CLIP
	ADD.W	D3,D3
	ADD.W	D3,D3
	TST.L	(A6,D3.W)
	BEQ.S	.PREMIERE_FOIS
	MOVE.L	(A6,D3.W),-4(A4)
	BRA.S	.NOTHING_HERE
.PREMIERE_FOIS	MOVE.L	A2,(A6,D3.W)
	BRA.S	.TRAITE
.LEFT_CLIP	;CLIPPING_GAUCHE
	MOVE.W	D0,D1
	NEG.W	D1
	SUBQ.W	#1,D1
	LSR.W	#4,D1
	ADDQ.W	#1,D1	;NB DE MOTS A EFFACER
	CMPI.W	#1,D1
	BNE.S	.TEST_22
	MOVEQ	#0,D4
	BRA.S	.TRAITE
.TEST_22	MOVEQ	#0,D4
	MOVEQ	#0,D5
.TRAITE	BSR	MAK_COD
.NOTHING_HERE	DBRA	D7,.NEXT_X
	MOVEM.L	(SP)+,D0-D7
	RTS

MAK_COD	MOVE.L	A0,-(SP)
	MOVE.W	D2,D3
	SUBQ.W	#1,D3	;HAUTEUR-1
	MOVEQ	#0,D0
	TST.W	D4
	BEQ.S	.OK_1
	ADDQ.W	#1,D0
.OK_1	TST.W	D5
	BEQ.S	.OK_2
	ADDQ.W	#2,D0
.OK_2	TST.W	D6
	BEQ.S	.OK_3
	ADDQ.W	#4,D0
.OK_3	ADD.W	D0,D0
	ADD.W	D0,D0
	LEA	TABLE_ROUTS_ZOOMS(PC),A0
	MOVE.L	(A0,D0.W),A0	;ADRESSE DE LA ROUTINE
	JSR	(A0)
	MOVE.W	#$4E75,(A2)+	;RTS FINAL DE LA ROUTINE
	MOVE.L	(SP)+,A0
	RTS

NO_REG	RTS
REG_D4_D6	RTS            ;CETTE ROUTINE NE SERT A RIEN:CAS IMPOSSIBLE

ONLY_D4	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D4,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

ONLY_D5	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D5,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

ONLY_D6	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D6,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

ALL_REGS	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D4,(A2)+
	MOVE.W	#$323C,(A2)+	;MOVE.W #$Imm,D1
	MOVE.W	D5,(A2)+
	MOVE.W	#$343C,(A2)+	;MOVE.W #$Imm,D2
	MOVE.W	D6,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	#8,(A2)+
	MOVE.W	#$8568,(A2)+	;OR.W D2,d16(A0)
	MOVE.W	#16,(A2)+
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	D1,(A2)
	ADDQ.W	#8,(A2)+
	MOVE.W	#$8568,(A2)+	;OR.W D2,d16(A0)
	MOVE.W	D1,(A2)
	ADDI.W	#16,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

REG_D4_D5	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D4,(A2)+
	MOVE.W	#$323C,(A2)+	;MOVE.W #$Imm,D1
	MOVE.W	D5,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	#8,(A2)+
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	D1,(A2)
	ADDQ.W	#8,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

REG_D5_D6	MOVE.W	#$303C,(A2)+	;MOVE.W #$Imm,D0
	MOVE.W	D5,(A2)+
	MOVE.W	#$323C,(A2)+	;MOVE.W #$Imm,D1
	MOVE.W	D6,(A2)+
	MOVE.W	#$8150,(A2)+	;OR.W D0,(A0)
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	#8,(A2)+
	SUBQ.W	#1,D3
	MOVE.W	#160,D1
.FIN_RECOP	MOVE.W	#$8168,(A2)+	;OR.W D0,d16(A0)
	MOVE.W	D1,(A2)+
	MOVE.W	#$8368,(A2)+	;OR.W D1,d16(A0)
	MOVE.W	D1,(A2)
	ADDQ.W	#8,(A2)+
	ADDI.W	#160,D1
	DBRA	D3,.FIN_RECOP
	RTS

N	SET	7
TABLE_COLORS_Z	DCB.W	N,$111
	DCB.W	N,$222
	DCB.W	N,$333
	DCB.W	N,$444
	DCB.W	N,$555
	DCB.W	N,$666
	DCB.W	N+15,$777
	DCB.W	N,$767
	DCB.W	N,$757
	DCB.W	N,$646
	DCB.W	N,$535
	DCB.W	N,$424
	DCB.W	N,$313
	DCB.W	N,$202
	DCB.W	N,$101

TABLE_ROUTS_ZOOMS
	DC.L	NO_REG,ONLY_D4,ONLY_D5,REG_D4_D5
	DC.L	ONLY_D6,REG_D4_D6,REG_D5_D6,ALL_REGS

PLACE_DECAL	DS.W	3

MESSAGE	DC.B	1,9,"HOLOCAUST"
	DC.B	1,8,"PRESENTS"
	DC.B	1,5,"A NEW"
	DC.B	1,7,"FUCKING"
	DC.B	1,5,"STUFF",-1
	EVEN

	INCLUDE	FONTS.S

COEFF_3D	INCBIN	COEFF.3D

	SECTION	BSS
COLOR_ACTU_Z	DS.W	1
FLAG_NEXT_ZOOM	DS.B	1
FLAG_EFFAC_ZOOM	DS.B	1
ADR_EFF_Z	DS.L	2
BUF_EFF_Z	DS.W	2*2
NUMER	DS.W	1
PT_MESS	DS.L	1
NB_VBL	DS.W	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.B	64000+96*160
ADR_ZOOMS	DS.L	NB_ZOOMS
BUF_CALC	DS.W	(12*8*8)+(8*2)	;1568 b.
BUF_ANNEX	DS.W	2*NB_ZOOMS
CORES_LONG_CARR�S	DS.L	16*33
CORES_CARR�S_1	DS.L	NB_ZOOMS
CORES_CARR�S_2	DS.B	50000
BUF_COD_CARR�S	DS.B	45000
BUF_ZOOMS	DS.B	46000