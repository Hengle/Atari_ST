; Intro cod�e par Zappy/Holocaust pour Robocamp/Vmax.
; Code mi-assembleur, mi-langage machine, (C) 15.07.91
; Routine de scroll: Elric/Holocaust


	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAUV_SP
	
	CLR.W	-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.L	#-1,-(SP)
	MOVE.W	#5,-(SP)
	TRAP	#14
	LEA	12(SP),SP

	CLR.L	PNT2
	CLR.L	PNT
	CLR.L	COLPLUS
	CLR.L	COLP
	MOVE.L	#DATA,CAINE

	
	MOVE.L	#BRAND,$008.W
	MOVE.L	#BRAND,$00C.W
	MOVE.L	#BRAND,$010.W
	MOVE.L	#BRAND,$014.W
	MOVE.L	#BRAND,$018.W
	MOVE.L	#BRAND,$01C.W
	MOVE.L	#BRAND,$020.W
	MOVE.L	#BRAND,$024.W
	
	DC.L	$023800F8
	DC.W	$0484
	
	MOVE.B	$FFFF8201.W,SAUVEC
	MOVE.B	$FFFF8203.W,SAUVEC+1
	
	MOVEM.L	$FFFF8240.W,D0-D7
	MOVEM.L	D0-D7,ANC_PAL
	MOVEM.L	FONT1+2,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	BSR	PREP_ECR
	MOVE.L	#FONT1+34+(160*64)+96,SOV_LET
	CLR.L	POS_LET
	CLR.B	SCRP1

	MOVE.L	$70.W,ANC_VBL
	MOVE.L	#DEIRDRE,$70.W
	
LOOP	JMP	LOOP

BRAND	MOVE.L	ANC_VBL,$70.W

	MOVEM.L	ANC_PAL,D0-D7
	MOVEM.L	D0-D7,$FFFF8240.W
	
	MOVE.B	SAUVEC,$FFFF8201.W
	MOVE.B	SAUVEC+1,$FFFF8203.W
	
	ORI.B	#%00000111,$484.W
	
	MOVE.L	SAUV_SP,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	
	CLR.W	-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	
AMBER	
	MOVE.L	SCREEN2,A0
	DC.L	$D1FC0000
	DC.W	$3E80
	BSR	DECAL
	CMPI.B	#1,SCRP1
	BLO	PART1
	BEQ	PART2
	CMPI.B	#3,SCRP1
	BLO	PART3
	BEQ	PART4
FLORA	BSR	SWAPEC
	DC.W	$4E75
DEIRDRE	JSR	AMBER
	ADDQ.L	#2,CNT
	CMPI.L	#5*50,CNT
	BNE.S	FIONA
	CLR.L	CNT
	MOVE.L	#DARA,$70.W
FIONA	MOVE.L	COLP,D6
	LEA	GRAYSWANDIR,A5
	ADDA.L	COLPLUS,A5
	DC.L	$4DF88240
	DC.L	$103C0018 
	DC.L	$46FC2700
BENEDICT:DC.L	$4A388209
	BEQ.S	BENEDICT
	DC.L	$90388209
	DC.W	$E0A8
	DCB	85,$4E71
	LEA	MERLIN,A0
	MOVE.L	CAINE,A1
	DC.L	$0CA9FFFF
	DC.L	$FFFF0320
	BNE.S	GERARD
	MOVE.L	#DATA,CAINE
	MOVE.L	CAINE,A1
	BRA.S	RANDOM
GERARD	DCB	17-3,$4E71
RANDOM	DC.L	$D1D94E90
	move.l	a1,CAINE
	REPT	$C7
	LEA	MERLIN,A0
	LEA	GRAYSWANDIR,A5
	DC.W	$DBC6
	DC.L	$D1D94E90
	ENDR
	DC.L	$425646FC
	DC.L	$23000C38
 	DC.L	$0039FC02
	BEQ     BRAND
	DC.W	$4E73 
DARA:	JSR	AMBER
	ADDQ.L	#2,COLPLUS
	ADDQ.L	#2,PNT
	CMPI.L	#35*2+42*2,PNT
	BNE.S	CORWIN
	CLR.L	PNT
	ADD.L	#35*2+42*2,COLP
	MOVE.L	#DEIRDRE,$70.W
	ADDQ.L	#1,PNT2
	CMPI.L	#14,PNT2
	BNE.S	CORWIN
	CLR.L	COLP
	CLR.L	PNT2
	CLR.L	COLPLUS
	CLR.L	PNT
CORWIN	MOVE.L	COLPLUS,D6
	LEA	GRAYSWANDIR,A5
	ADDA.L	COLPLUS,A5
	DC.L	$4DF88240
	DC.L	$103C0018 
	DC.L	$46FC2700
OBERON:DC.L	$4A388209
	BEQ.S	OBERON
	DC.L	$90388209
	DC.W	$E0A8 
	DCB	85,$4E71
	LEA	MERLIN,A0
	MOVE.L	CAINE,A1
	DC.L	$0CA9FFFF
	DC.L	$FFFF0320
	BNE.S	JULIAN
	MOVE.L	#DATA,CAINE
	MOVE.L	CAINE,A1
	BRA.S	ERIC
JULIAN	DCB	17-3,$4E71
ERIC	DC.L	$D1D94E90
	move.l	a1,CAINE
	REPT	$C7
	LEA	MERLIN,A0
	LEA	GRAYSWANDIR,A5
	DC.W	$DBC6
	DC.L	$D1D94E90
	ENDR
	DC.L	$425646FC
	DC.L	$23000C38
	DC.L	$0039FC02
	BEQ     BRAND
	DC.W	$4E73 
	DCB	3,$4E71
MERLIN	DCB	4,$4E71
	DCB.W	35,$3C9D
	DC.W	$4E75
DECAL	
N	SET	0
	REPT	32
	MOVEM.L	N+8(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N(A0)
	MOVEM.L	N+60(A0),D0-D7/A2-A6
	MOVEM.L	D0-D7/A2-A6,N+52(A0)
	MOVEM.L	N+112(A0),D0-D7/A2-A5
	MOVEM.L	D0-D7/A2-A5,N+104(A0)
N	SET	N+160
	ENDR
	DC.W	$4E75
PART1	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(100*160),A1
N	SET	0
	REPT	32
	MOVE.B	N+9(A0),N(A1)
	MOVE.B	N+11(A0),N+2(A1)
	MOVE.B	N+13(A0),N+4(A1)
	MOVE.B	N+15(A0),N+6(A1)
N	SET	N+160
	ENDR
	BSR	NEW_LET1
	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#153+(100*160),A1
N	SET	0
	REPT	32
	MOVE.B	N(A0),N(A1)
	MOVE.B	N+2(A0),N+2(A1)
	MOVE.B	N+4(A0),N+4(A1)
	MOVE.B	N+6(A0),N+6(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	FLORA
PART2	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(100*160),A1
N	SET	0
	REPT	32
	MOVE.L	N(A0),N(A1)
	MOVE.L	N+4(A0),N+4(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	FLORA
PART3	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(100*160),A1
N	SET	0
	REPT	32
	MOVE.B	N+1(A0),N(A1)
	MOVE.B	N+8(A0),N+1(A1)
	MOVE.B	N+3(A0),N+2(A1)
	MOVE.B	N+10(A0),N+3(A1)
	MOVE.B	N+5(A0),N+4(A1)
	MOVE.B	N+12(A0),N+5(A1)
	MOVE.B	N+7(A0),N+6(A1)
	MOVE.B	N+14(A0),N+7(A1)
N	SET	N+160
	ENDR
	ADDQ.B	#1,SCRP1
	BRA	FLORA
PART4	MOVE.L	SOV_LET,A0
	MOVE.L	SCREEN2,A1
	ADDA.L	#152+(100*160),A1
N	SET	0
	REPT	32
	MOVE.L	N+8(A0),N(A1)
	MOVE.L	N+12(A0),N+4(A1)
N	SET	N+160
	ENDR
	CLR.B	SCRP1
	BRA	FLORA
NEW_LET1	LEA	TEXT1,A0
	ADDA.L	POS_LET,A0
	CMPI.B	#$FF,(A0)
	BNE	SUITNL1
	CLR.L	POS_LET
	LEA	TEXT1,A0
SUITNL1	MOVEQ	#0,D0
	MOVE.B	(A0),D0
	SUBI.B	#32,D0
	LSL.W	#2,D0
	LEA	CORES1,A1
	ADDA.L	D0,A1
	MOVE.L	(A1),SOV_LET
	ADDQ.L	#1,POS_LET
	DC.W	$4E75
SWAPEC	MOVE.L	SCREEN2,D0
	MOVE.L	SCREEN1,SCREEN2
	MOVE.L	D0,SCREEN1
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	DC.W	$4E75
PREP_ECR	MOVE.L	#BUFFER,D0
	ANDI.B	#0,D0
	MOVE.L	D0,SCREEN1
	ADDI.L	#32000,D0
	MOVE.L	D0,SCREEN2
	MOVE.B	SCREEN1+1,$FFFF8201.W
	MOVE.B	SCREEN1+2,$FFFF8203.W
	DC.W	$4E75
	
	SECTION	DATA
	
GRAYSWANDIR	
	DC.W	$100,$200,$300,$400,$500,$600,$700
	DC.W	$710,$720,$730,$740,$750,$760,$770
	DC.W	$771,$772,$773,$774,$775,$776,$777
	DC.W	$677,$577,$477,$377,$277,$177,$077
	DC.W	$066,$055,$044,$033,$022,$011,$001
	DCB.W	42,0
	DC.W	$001,$002,$003,$004,$005,$006,$007
	DC.W	$017,$027,$037,$047,$057,$067,$077
	DC.W	$177,$277,$377,$477,$577,$677,$777
	DC.W	$776,$775,$774,$773,$772,$771,$770
	DC.W	$760,$650,$540,$430,$320,$210,$100
	DCB.W	42,0
	DC.W	$010,$020,$030,$040,$050,$060,$070
	DC.W	$170,$270,$370,$470,$570,$670,$770
	DC.W	$771,$772,$773,$774,$775,$776,$777
	DC.W	$777,$776,$775,$774,$773,$772,$771
	DC.W	$770,$670,$570,$470,$370,$270,$170
	DCB.W	42,0
	DC.W	$000,$100,$210,$320,$430,$540,$650
	DC.W	$760,$761,$762,$763,$764,$765,$766
	DC.W	$767,$757,$747,$737,$727,$717,$707
	DC.W	$706,$705,$704,$703,$702,$701,$601
	DC.W	$501,$401,$301,$201,$101,$001,$000
	DCB.W	42,0
	DC.W	$001,$102,$203,$304,$405,$506,$607
	DC.W	$707,$717,$727,$737,$747,$757,$767
	DC.W	$777,$667,$556,$445,$334,$223,$112
	DC.W	$001,$001,$001,$001,$001,$001,$001
	DC.W	$001,$001,$001,$001,$001,$001,$001
	DCB.W	42,0
	DC.W	$002,$012,$023,$034,$045,$056,$067
	DC.W	$077,$177,$276,$375,$474,$573,$672
	DC.W	$771,$761,$751,$741,$731,$721,$711
	DC.W	$701,$601,$501,$401,$301,$201,$101
	DC.W	$000,$000,$000,$000,$000,$000,$000
	DCB.W	42,0
	DC.W	$010,$020,$030,$040,$050,$060,$070
	DC.W	$071,$171,$172,$272,$273,$373,$374
	DC.W	$474,$475,$575,$576,$676,$677,$777
	DC.W	$776,$766,$666,$665,$655,$555,$554
	DC.W	$544,$444,$344,$244,$144,$044,$033
	DCB.W	42,0
	DC.W	$010,$020,$030,$040,$050,$060,$070
	DC.W	$071,$171,$172,$272,$273,$373,$374
	DC.W	$474,$475,$575,$576,$676,$677,$777
	DC.W	$677,$577,$477,$377,$277,$177,$077
	DC.W	$067,$057,$047,$037,$027,$017,$007
	DCB.W	42,0
	DC.W	$010,$020,$030,$040,$050,$060,$070
	DC.W	$071,$171,$172,$272,$273,$373,$374
	DC.W	$474,$475,$575,$576,$676,$677,$777
	DC.W	$776,$766,$666,$665,$655,$555,$554
	DC.W	$544,$444,$344,$244,$144,$044,$000
	DCB.W	42,0
	DC.W	$010,$020,$030,$040,$050,$060,$070
	DC.W	$071,$171,$172,$272,$273,$373,$374
	DC.W	$474,$475,$575,$576,$676,$677,$777
	DC.W	$677,$577,$477,$377,$277,$177,$077
	DC.W	$067,$057,$047,$037,$027,$017,$007
	DCB.W	42,0
	DC.W	$001,$002,$003,$004,$005,$006,$007
	DC.W	$017,$027,$037,$047,$057,$067,$077
	DC.W	$177,$277,$377,$477,$577,$677,$777
	DC.W	$776,$775,$774,$773,$772,$771,$770
	DC.W	$760,$750,$740,$730,$720,$710,$700
	DCB.W	42,0
	DC.W	$001,$002,$003,$004,$005,$006,$007
	DC.W	$017,$027,$037,$047,$057,$067,$077
	DC.W	$177,$277,$377,$477,$577,$677,$777
	DC.W	$776,$775,$774,$773,$772,$771,$770
	DC.W	$670,$570,$470,$370,$270,$170,$070
	DCB.W	42,0
	DC.W	$001,$002,$003,$004,$005,$006,$007
	DC.W	$017,$027,$037,$047,$057,$067,$077
	DC.W	$177,$277,$377,$477,$577,$677,$777
	DC.W	$776,$775,$774,$773,$772,$771,$770
	DC.W	$760,$750,$740,$730,$720,$710,$700
	DCB.W	42,0
	DC.W	$001,$002,$003,$004,$005,$006,$007
	DC.W	$017,$027,$037,$047,$057,$067,$077
	DC.W	$177,$277,$377,$477,$577,$677,$777
	DC.W	$776,$775,$774,$773,$772,$771,$770
	DC.W	$670,$570,$470,$370,$270,$170,$070
	DCB.W	42,0
	DC.W	$100,$200,$300,$400,$500,$600,$700
	DC.W	$710,$720,$730,$740,$750,$760,$770
	DC.W	$771,$772,$773,$774,$775,$776,$777
	DC.W	$677,$577,$477,$377,$277,$177,$077
	DC.W	$066,$055,$044,$033,$022,$011,$001
DATA	REPT	4
	DCB.L	5,6
	DCB.L	4,4
	DCB.L	3,2
	DCB.L	2,0
	DCB.L	3,-2
	DCB.L	4,-4
	DCB.L	5,-6
	DCB.L	5,-6
	DCB.L	4,-4
	DCB.L	3,-2
	DCB.L	2,0
	DCB.L	3,2
	DCB.L	4,4
	DCB.L	5,6
	ENDR
	DCB.L	5,6
	DCB.L	4,4
	DCB.L	3,2
	DCB.L	2,0
	DCB.L	3,-2
	DCB.L	4,-4
	DCB.L	5,-6
	DCB.L	5,-6
	DCB.L	4,-4
	DCB.L	3,-2
	DCB.L	2,0
	DCB.L	3,2
	DCB.L	1,4
	DC.L	-1
FONT1	INCBIN	Fontes2.PI1

TEXT1	DC.B	"      AFTER THE EMPIRE'S FALL...      AFTER THE DEATH"
	DC.B	" OF THE REPLICANTS...       AT THE END OF THE TIME, "
	DC.B	"AFTER THE HOLOCAUST...        - V M A X -  !!!      "
	DC.B	$FF
	EVEN

CORES1	
	DC.L	FONT1+34+(160*132)	*ESP
	DC.L	FONT1+34+(160*66)+96	*!
	DC.L	FONT1+34+(160*132)	*"
	DC.L	FONT1+34+(160*132)	*#
	DC.L	FONT1+34+(160*132)	*$
	DC.L	FONT1+34+(160*132)	*%
	DC.L	FONT1+34+(160*132)	*&
	DC.L	FONT1+34+(160*66)+144	*'
	DC.L	FONT1+34+(160*132)+16	*(
	DC.L	FONT1+34+(160*132)+32	*)
	DC.L	FONT1+34+(160*132)	**
	DC.L	FONT1+34+(160*132)	*+
	DC.L	FONT1+34+(160*132)+64	*,
	DC.L	FONT1+34+(160*132)+48	*-
	DC.L	FONT1+34+(160*66)+112	*.
	DC.L	FONT1+34+(160*132)	*/
	DC.L	FONT1+34+(160*99)	*0
	DC.L	FONT1+34+(160*99)+16	*1
	DC.L	FONT1+34+(160*99)+32	*2
	DC.L	FONT1+34+(160*99)+48	*3
	DC.L	FONT1+34+(160*99)+64	*4
	DC.L	FONT1+34+(160*99)+80	*5
	DC.L	FONT1+34+(160*99)+96	*6
	DC.L	FONT1+34+(160*99)+112	*7
	DC.L	FONT1+34+(160*99)+128	*8
	DC.L	FONT1+34+(160*99)+144	*9
	DC.L	FONT1+34+(160*132)+80	*:
	DC.L	FONT1+34+(160*132)	*;
	DC.L	FONT1+34+(160*132)	*
	DC.L	FONT1+34+(160*132)	*=
	DC.L	FONT1+34+(160*132)	*
	DC.L	FONT1+34+(160*66)+128	*?
	DC.L	FONT1+34+(160*132)	*@
	DC.L	FONT1+34,FONT1+34+16,FONT1+34+32,FONT1+34+48,FONT1+34+64,FONT1+34+80,FONT1+34+96,FONT1+34+112,FONT1+34+128,FONT1+34+144
	DC.L	FONT1+34+(160*33),FONT1+34+(160*33)+16,FONT1+34+(160*33)+32,FONT1+34+(160*33)+48,FONT1+34+(160*33)+64,FONT1+34+(160*33)+80,FONT1+34+(160*33)+96,FONT1+34+(160*33)+112,FONT1+34+(160*33)+128,FONT1+34+(160*33)+144
	DC.L	FONT1+34+(160*66),FONT1+34+(160*66)+16,FONT1+34+(160*66)+32,FONT1+34+(160*66)+48,FONT1+34+(160*66)+64,FONT1+34+(160*66)+80
	
	SECTION	BSS
PNT2	DS.L	1
PNT	DS.L	1
COLP	DS.L	1	
CNT	DS.L	1	
COLPLUS	DS.L	1
CAINE	DS.L	1
POINT	DS.L	1
ANC_PAL	DS.L	8
SAUV_SP	DS.L	1
ANC_VBL	DS.L	1
POS_LET	DS.L	1
SOV_LET	DS.L	1
SCRP1	DS.B	1
	EVEN
SCREEN1	DS.L	1
SCREEN2	DS.L	1
	DS.B	256
BUFFER	DS.L	16000
	DS.B	256
SAUVEC	DS.W	1	