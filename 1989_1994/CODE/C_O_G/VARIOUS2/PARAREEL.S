	OPT	D+

ptsin	equ 12		;.l
contrl	equ 4		;.l
x1	equ 38		;.w
y1	equ 40
x2	equ 42
y2	equ 44
bp1	equ 24		;.w
bp2	equ 26
bp3	equ 28
bp4	equ 30
wrt_mod	equ 36		;.w
patt	equ 46		;.l

pmsk	equ 50		;.w

clip	equ 54		;.w

xmn_c	equ 56		;.w
xmx_c	equ 60
ymn_c	equ 58
ymx_c	equ 62
ln_msk	equ 34		;.w
lstlin	equ 32		;.w
LONG = 120-1
HAUT = 120-1


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

	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP	
	MOVE.L	D0,SAUV_SP

	MOVE.W	#163,POS_X
	MOVE.W	#30,POS_Y

	MOVE.L	#BUFFERSCR,D0
	clr.b	D0
	MOVE.L	D0,SCREEN1
	ADD.L	#150*256,D0
	MOVE.L	D0,SCREEN2

	move.l	#e,$8.w
	move.l	#e,$c.w
	move.l	#e,$10.w
	move.l	#e,$14.w
	move #$2300,sr

	move #2,-(sp)
	trap #14
	addq #2,sp
	move.l d0,ecran_gem

	move #4,-(sp)
	trap #14
	addq #2,sp
	move d0,res_save

	CLR	-(sp)
	moveq #-1,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp


	move.l	SCREEN1,d0
	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	
	move.l	SCREEN1,$44e.w

	move #$2700,sr
	move.l $70.w,vbl_save
	move.l $120.w,tb_save

	movem.l $ffff8240.w,d0-d7
	movem.l d0-d7,pal_save

	lea $fffffa07.w,a0
	movep.w (a0),d0
	move d0,mfp_save
	moveq #0,d0

	move.l usp,a6
	move.l a6,uusp

	MOVE.B	$FFFFFA07.W,MFP1
	MOVE.B	$FFFFFA09.W,MFP2
	MOVE.B	$FFFFFA0F.W,MFP3
	MOVE.B	$FFFFFA13.W,MFP4
	MOVE.B	$FFFFFA1B.W,MFP5
	MOVE.B	$FFFFFA21.W,MFP6
	
	CLR.B	$FFFFFA07.W
	CLR.B	$FFFFFA09.W
	
	DC.W	$A00A
	MOVE.B	#$12,$FFFFFC02.W
	
	CLR.B	$FFFFFA1B.W
	BSET	#0,$FFFFFA07.W
	BSET	#0,$FFFFFA13.W

	move.l	#tb,$120.w
	sf	$ffff8242.w
	sf	$ffff8244.w
	sf	$ffff8246.w
	sf	$ffff8248.w
	sf	$ffff8250.w
	bsr demo
e:
	move #$2700,sr
	MOVE.B	#8,$FFFFFC02.W
	MOVE.B	MFP1,$FFFFFA07.W
	MOVE.B	MFP2,$FFFFFA09.W
	MOVE.B	MFP3,$FFFFFA0F.W
	MOVE.B	MFP4,$FFFFFA13.W
	MOVE.B	MFP5,$FFFFFA1B.W
	MOVE.B	MFP6,$FFFFFA21.W


	move.l uusp,a6
	move.l a6,usp
	movem.l pal_save,d0-d7
	movem.l d0-d7,$ffff8240.w
	move.l vbl_save,$70.w
	move.l tb_save,$120.w
	lea $fffffa07.w,a0
	move mfp_save,d0
	movep.w d0,(a0)

	MOVE.L	#$8080000,$FFFF8800.W
	MOVE.L	#$9090000,$FFFF8800.W
	MOVE.L	#$A0A0000,$FFFF8800.W


	move #$2300,sr

	move res_save,-(sp)
	move.l ecran_gem,d0
	move.l d0,-(sp)
	move.l d0,-(sp)
	move #5,-(sp)
	trap #14
	lea 12(sp),sp

	move.l SAUV_SP,-(sp)
	move #$20,-(sp)
	trap #1
	addq #6,sp

	clr -(sp)
	trap #1
	rts





it_vbl:	MOVE	#$777,$FFFF8240.W
	;MOVE	#$001,$FFFF8250.W
	CLR.B	$FFFFFA1B.W
	MOVE.L	#tb,$120.W
;	MOVE.B	#78,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W

	MOVEM.L	D0-D7/A0-6,-(SP)

	move #1,vbl_sync

SWAP

;	MOVE.W	#$700,$FFFF8240.W

	move.l	SCREEN1,d0
	move.l	SCREEN2,SCREEN1		
	move.l	d0,SCREEN2

	lsr.l	#8,d0		
	move.l	#$ffff8201,a0
	movep	d0,(a0)


	MOVEM.L	(SP)+,D0-D7/A0-A6

	cmp.b #$39,$fffffc02.w
	beq	e

	rte

tb
	DCB	127,$4E71
	CLR.B	$FFFF820A.W
	DCB	8,$4E71
	MOVE.B	#2,$FFFF820A.W
	CLR.B	$FFFFFA1B.W
;	MOVE.L	#tb3,$120.W
;	MOVE.B	#2,$FFFFFA21.W
;	MOVE.B	#8,$FFFFFA1B.W
	BCLR	#0,$FFFFFA0F.W
RTE	RTE			

demo:			*******************   --> sr=$2700
	move.l SCREEN1,ad_ecran
	addq.l	#4,ad_ecran

	LEA	EMUL_LINEA,A0
	MOVE.L	A0,D0
		
	move.l a0,lineA_tab

	move.l #pattern,patt(a0)
	move #0,pmsk(a0)
	move #0,wrt_mod(a0)
	move #-1,bp1(a0)
	move #0,bp2(a0)
	move #0,bp3(a0)
	move #0,bp4(a0)

;	move.l #it_vbl,$70.w
	move #$2300,sr
	
	bsr text_convert
	
	lea text_buffer_end,a0
	lea text,a1
	lea font,a2
	moveq #0,d0
	move d0,d1
	move #30-1,d7		;30*5=150
text_lp:
	move.b (a1)+,d0
	move.b 3(a2,d0.w),-(a0)
	move.b 2(a2,d0.w),-(a0)
	move.b 1(a2,d0.w),-(a0)
	move.b 0(a2,d0.w),-(a0)
	move.b d1,-(a0)
	dbra d7,text_lp
	move.l a1,text_pt

	move.l #data_ads,ad_data_pt
	lea compteurs,a3
	
	bsr construction
	
	lea ad_routines,a0
	move.l 16(a0),a2		;routine d'effa�age
	move #-4,(a3)		;images
	move #-20,2(a3)		;compteur pour le scroll du buffer de texte 

	
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	MOVE.L	#it_vbl,$70.w
demo_lp:
	moveq #0,d0
	moveq #1,d1
	moveq #2,d2
	moveq #3,d3
	moveq #4,d4
	move.l text_buff_pt,a5
	move.l SCREEN1,a6
	LEA	-(48+(160*40))(A6),A6
	bsr vsync

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICA

	move #$200,$ffff8240.w
HICA


	jsr (a2)
	move.l (a0)+,a1
	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HIC
	move #$100,$ffff8240.w
HIC
	jsr (a1)

	MOVEM.L	D0-A6,-(SP)

	MOVE.W	POS_X,D0	D0:X
	MOVE.W	POS_Y,D1	D1:Y
	MOVE.W	#LONG,D2	D2:LONGUEUR -1
	MOVE.W	#HAUT,D3	D3:HAUTEUR -1
	MOVE.L	SCREEN1,A2	A1:BASE ECRAN
	MOVE.L	SCREEN1,A6	A6: ADRESSE DU SPRITE 1 PLAN
	LEA	96+160*80(A2),A2
	JSR	AFF_SPR_1_P
;	MOVE.W	#$777,$FFFF8240.W
	CMPI.B	#$3C,$FFFFFC02.W
	BNE.S	TEST_2
	ADDQ.W	#1,POS_X
TEST_2	CMPI.B	#$3B,$FFFFFC02.W
	BNE.S	TEST_3
	SUBQ.W	#1,POS_X
TEST_3
	MOVEM.L	(SP)+,D0-A6

	CMPI.B	#$F,$FFFFFC02.W
	BNE.S	HICq
	move #$007,$ffff8240.w
HICq

;	clr	$ffff8240.w
	
	addQ #1,(a3)
	bne demo_lp

	move #-4,(a3)
	lea ad_routines,a0
	sub.l d1,text_buff_pt
	
	addQ #1,2(a3)
	bne demo_lp
	
	move #-20,2(a3)
	lea text_buffer_deb,a5
	move.l a5,text_buff_pt
	movem.l 70(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,90(a5)
	movem.l 30(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,50(a5)
	movem.l -10(a5),d0-d7/a1/a6
	movem.l d0-d7/a1/a6,10(a5)
	movem.w -20(a5),d0-d4
	movem.w d0-d4,(a5)
	
	move.l text_pt,a1
	lea font,a6
	moveq #0,d0
	move d0,d1
	move #4-1,d7		;4*5=20
text_lp2:
	move.b (a1)+,d0
	cmp #255,d0
	bne.s forme_change_pas
	
	
	addQ.l #4,ad_data_pt
	cmp.b #255,(a1)
	bne.s forme_suivante
	lea text,a1
	move.l #data_ads,ad_data_pt
forme_suivante:
	bsr construction
	move.b (a1)+,d0
	lea ad_routines,a0
	move.l 16(a0),a2		;routine d'effa�age
	
forme_change_pas:
	move.b 3(a6,d0.w),-(a5)
	move.b 2(a6,d0.w),-(a5)
	move.b 1(a6,d0.w),-(a5)
	move.b 0(a6,d0.w),-(a5)
	move.b d1,-(a5)
	dbra d7,text_lp2
	move.l a1,text_pt
	bra demo_lp
	
	rts
	
text_convert:
	lea text,a0
	moveq #-1,d1
convert_lp:
	moveq #0,d0
	move.b (a0),d0
	cmp.b d1,d0
	bne.S convert_suite
	cmp.b #255,1(a0)
	beq.S convert_fin
	addq #1,a0
	bra.s convert_lp
convert_suite:
	cmp.b #$20,d0
	blo.s int2_conv
	cmp.b #$21,d0
	bhi.s int2_conv
	sub #$20,d0
	bra.S next_octet
int2_conv:
	cmp.b #$41,d0
	blo.s int3_conv
	cmp.b #$5a,d0
	bhi.s int3_conv
	sub #$3f,d0
	bra.S next_octet
int3_conv:
	cmp.b #$30,d0
	blo.s int4_conv
	cmp.b #$39,d0
	bhi.s int4_conv
	sub #$14,d0
	bra.S next_octet
int4_conv:
	cmp.b #$27,d0
	blo.s int5_conv
	cmp.b #$29,d0
	bhi.s int5_conv
	addQ #$2,d0
	bra.S next_octet
int5_conv:
	cmp.b #$2e,d0
	bne.s int6_conv
	subQ #$8,d0
	bra.S next_octet
int6_conv:
	cmp.b #$3a,d0
	bne.s int7_conv
	sub #$13,d0
	bra.S next_octet
int7_conv:
	cmp.b #$2c,d0
	bne.s int8_conv
	subQ #$4,d0
next_octet:
	lsl #2,d0
	move.b d0,(a0)+
	bra.S convert_lp
convert_fin:
	rts
int8_conv:
	jmp	e

vsync:
	move #0,vbl_sync
sync_wait:
	tst vbl_sync
	beq.s sync_wait

	rts
sort_demo:
	addq #4,sp
	rts 

construction:
	movem.l a0-a6/d1/d7,-(sp)
	
	lea off_bolean,a6		;effa�age des bits
	move #125-1,d7		;500 octets
	moveq #0,d6
off_bol_lp:
	move.l d6,(a6)+
	dbra d7,off_bol_lp

	move.l #ad_routines,routs_pt
	lea	PtsFill,a3		;tableau ptsin
	move.l a3,usp
	move.l ad_data_pt,a4
	move.l (a4),a4		;coord des points
	move.l lineA_tab,a6
	lea routines,a5

	move #4-1,d7		;4 pas
pas_lp:
	move d7,-(sp)
	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #32-1,d7		;128 colonnes
col_lp:

	move #$1e1d,(a5)+		;move.b (a5)+,d7
	move #5-1,d6		;5 lignes
ligne_lp:

	move.b d6,d5		;pour obtenir code du btst
	add.b d5,d5
	addq.b #1,d5
	move.b d5,(a5)+
	move.b #7,(a5)+		;btst.l d4/3/2/1/0,d7
	move.l a5,-(sp)
	move #$6700,(a5)+		;beq.s (offset � d�finir)

	move.l (a4),(a3)+	;l,c
	move.l 4(a4),(a3)+	;l+1,c
	move.l 4+24(a4),(a3)+	;l+1,c+1
	move.l 24(a4),(a3)+	;l,c+1
	move.l (a4),(a3)	;l,c
	move.l usp,a3
	addq #4,a4

	move #+30000,d4	;ymin
	move #-30000,d5	;ymax
	move 2(a3),d3	;recherche de ymin et ymax
	cmp d3,d4
	ble.s pas_inf1
	move d3,d4
pas_inf1:
	cmp d3,d5
	bge.s pas_sup1
	move d3,d5
pas_sup1:
	move 6(a3),d3
	cmp d3,d4
	ble.s pas_inf2
	move d3,d4
pas_inf2:
	cmp d3,d5
	bge.s pas_sup2
	move d3,d5
pas_sup2: 
	move 10(a3),d3
	cmp d3,d4
	ble.s pas_inf3
	move d3,d4
pas_inf3:
	cmp d3,d5
	bge.s pas_sup3
	move d3,d5
pas_sup3:	
	move 14(a3),d3
	cmp d3,d4
	ble.s pas_inf4
	move d3,d4
pas_inf4:
	cmp d3,d5
	bge.s pas_sup4
	move d3,d5
pas_sup4:
	sub d4,d5		;ymax-ymin
	move d5,d3		;sauve le compteur en y

	move d4,y1(a6)	;affichage du polygone avec $a006
aff_lp:	
	MOVEM.L	D0-D7/A0-A6,-(A7)
	jsr	FILL1
	MOVEM.L	(A7)+,D0-D7/A0-A6

	addQ #1,y1(a6)
	dbra d5,aff_lp

	REPT 4		;affichage des 4 lignes afin d'obtenir
	move.l (a3)+,x1(a6)	; la meme forme qu'avec polyfill.
	move.l (a3),x2(a6)

            movem.l d0-d7/a0-a6,-(a7)
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	MOVE	x1(a6),D0
	MOVE	y1(a6),D1
	
	MOVE	x2(a6),D2
	MOVE	y2(a6),D3

                bsr     DRAW_A_LINE


                movem.l (a7)+,d0-d7/a0-a6

	ENDR
	
	move.l usp,a3

	move #+30000,d0		;xmin
	move #-30000,d1		;xmax
	move (a3),d2		;recherche de xmin et xmax
	cmp d2,d0
	ble.s xpas_inf1
	move d2,d0
xpas_inf1:
	cmp d2,d1
	bge.s xpas_sup1
	move d2,d1
xpas_sup1:
	move 4(a3),d2
	cmp d2,d0
	ble.s xpas_inf2
	move d2,d0
xpas_inf2:
	cmp d2,d1
	bge.s xpas_sup2
	move d2,d1
xpas_sup2: 
	move 8(a3),d2
	cmp d2,d0
	ble.s xpas_inf3
	move d2,d0
xpas_inf3:
	cmp d2,d1
	bge.s xpas_sup3
	move d2,d1
xpas_sup3:	
	move 12(a3),d2
	cmp d2,d0
	ble.s xpas_inf4
	move d2,d0
xpas_inf4:
	cmp d2,d1
	bge.s xpas_sup4
	move d2,d1
xpas_sup4:
	lsr #4,d0		;on obtient le num�ro du groupe de 16 pixels
	lsr #4,d1
	sub d0,d1		;compteur
	lsl #3,d0		;*8 => offset en x
	muls #160,d4	;ymin*160 => offset en y
	add d4,d0		;offset / ad �cran en .w

	move.l ad_ecran,a0

	move d6,-(sp)
	move d7,-(sp)
	move.l a6,-(sp)
	lea off_bolean,a6
scan_y:			;rep�rage du polygone
	move d0,d4		;sauvegarde des compteurs
	move d1,d2
scan_x:
	move (a0,d4.w),d5
	beq.s or_nul
	clr (a0,d4.w)		;effa�age
	move #$006e,(a5)+		;or #$uuuu,vv(a6)
	move d5,(a5)+		;$uuuu
	move d4,(a5)+		;vv=d16
	move d4,d6		;note l'offset pour l'effa�age (tjs >=0)
	lsr #3,d6
	move d6,d7
	and #$0007,d6
	lsr #3,d7
	bset.b d6,(a6,d7.w)
or_nul:
	addq #8,d4		;groupe suivant
	dbra d2,scan_x

	add #160,d0		;ligne suivante
	dbra d3,scan_y

	move.l (sp)+,a6
	move (sp)+,d7
	move (sp)+,d6

	move.l a5,d0	;on peut calculer l'offset pour beq.s
	move.l (sp)+,a1
	sub.l a1,d0
	subq #2,d0
	cmp #127,d0		;ok pour beq.S ?
	blo.s offset_short
	move #$6700,(a1)+		;beq.l
	move.l a5,a0
	move d0,d1
	addq #2,d0
	lsr #1,d1
off_l_lp:
	move -(a0),2(a0)
	dbra d1,off_l_lp
	move d0,(a1)+
	addq #2,a5
	bra.s off_l_fin
offset_short:
	move.b d0,1(a1)			;offset pour le beq.s
off_l_fin:

	cmp.l #routines+111000,a5
	blo.s mem_ok
	jmp	e
mem_ok:

	dbra d6,ligne_lp
	addq #4,a4

	dbra d7,col_lp
	add #24,a4

	move (sp)+,d7
	move #$4e75,(a5)+		;rts
	dbra d7,pas_lp



	move.l routs_pt,a0
	move.l a5,(a0)+
	move.l a0,routs_pt

	move #$7e00,(a5)+		;moveq #0,d7
	lea off_bolean,a0	;routine d'effa�age: les bits concernent
	moveq #0,d5		; les mots du premier plan,dans l'ordre;
	move #500-1,d7	; bit=1 effacer plan 1 de ce groupe de 16 
off_oct_lp:			; pixels, ne rien faire sinon.
	move.b (a0)+,d5
	moveq #8-1,d6
off_bit_lp:
	btst d6,d5
	beq.s bit_nul_off
	move #$3d47,(a5)+		;move d7,xx(a6)
	move #499,d4
	sub d7,d4
	lsl #3,d4
	add d6,d4
	lsl #3,d4
	move d4,(a5)+			;offset
	
	cmp.l #routines+111000,a5
	blo.s mem_ok2
	jmp	e
mem_ok2:

bit_nul_off:
	dbra d6,off_bit_lp
	dbra d7,off_oct_lp
	
	move #$4e75,(a5)+		;rts

	movem.l (sp)+,a0-a6/d1/d7
	rts

FILL1	MOVEQ.L	#3,D0
	LEA	PtsFill,a0
	LEA	BUF16DA,A1
	
	CLR.W	PNT_261E
LFCA0F4	MOVE.W	6(A0),D1
	MOVE.W	2(A0),D2
	SUB.W	D2,D1
	BEQ.S	LFCA13E
	MOVE.W	EMUL_LINEA-$299A+$29C2,D3
	MOVE.W	D3,D4
	SUB.W	D2,D4
	SUB.W	6(A0),D3
	MOVE.W	D4,D2
	EOR.W	D3,D2
	BPL.S	LFCA13E
	MOVE.W	4(A0),D2
	SUB.W	(A0),D2
	ADD.W	D2,D2
	MULS.W	D2,D4
	DIVS.W	D1,D4
	BPL.S	LFCA12E
	NEG.W	D4
	ADDQ.W	#1,D4
	ASR.W	#1,D4
	NEG.W	D4
	BRA.S	LFCA132
LFCA12E	ADDQ.W	#1,D4
	ASR.W	#1,D4
LFCA132	ADD.W	(A0),D4
	MOVE.W	D4,(A1)+
	ADDQ.W	#1,PNT_261E
LFCA13E	LEA	4(A0),A0
	DBF	D0,LFCA0F4
	MOVE.W	PNT_261E,D0
	BNE.S	LFCA150
	RTS

LFCA150	LEA	BUF16DA,A0
	BSR.S	LFCA1DC
	MOVE.W	PNT_261E,D0
	ASR.W	#1,D0
	SUBQ.W	#1,D0

LFCA16C	MOVE.W	(A1)+,EMUL_LINEA+$26
	MOVE.W	(A1)+,EMUL_LINEA+$2A
	MOVE.W	D0,-(A7)
	MOVE.L	A1,-(A7)
	BSR.S	FILL2
	MOVEA.L	(A7)+,A1
	MOVE.W	(A7)+,D0
	DBF	D0,LFCA16C
	RTS
	
LFCA1DC	SUBQ.W	#2,D0
	BCS.S	LFCA1FC
	MOVE.W	D0,D1
	MOVEA.L	A0,A1
LFCA1E4	MOVE.W	D1,D0
	MOVEA.L	A1,A0
LFCA1E8	MOVE.W	(A0)+,D2
	CMP.W	(A0),D2
	BLE.S	LFCA1F4
	MOVE.W	(A0),-2(A0)
	MOVE.W	D2,(A0)
LFCA1F4	DBF	D0,LFCA1E8
	DBF	D1,LFCA1E4
LFCA1FC	RTS

VALEURS	DC.L	$FFFF7FFF
	DC.L	$3FFF1FFF
	DC.L	$0FFF07FF
	DC.L	$03FF01FF
	DC.L	$00FF007F
	DC.L	$003F001F
	DC.L	$000F0007
	DC.L	$00030001
	DC	$0000


FILL2	
	LEA	EMUL_LINEA-$299A+$299A,A4

	MOVE	$26(A4),D4
	MOVE	$28(A4),D5
	MOVE	$2A(A4),D6

	MOVE.W	D5,D0

	AND.W	50(A4),D0	MASK DU SAMPLE REMPLISSAGE
	ADD.W	D0,D0
	
	MOVEA.L	46(A4),A0	PNTEUR SUR SAMPLE REMPLISSAGE
	ADDA.W	D0,A0	
	
	TST.W	52(A4)	1 OU POLYPLANS
	SNE	D0
	AND.W	#$20,D0
	MOVE.W	D4,D1
	ASR.W	#4,D1
	MOVE.W	D6,D2
	ASR.W	#4,D2
	MOVEQ	#$F,D3
	AND.W	D3,D4
	ADD.W	D4,D4
	MOVE.W	VALEURS(PC,D4.W),D4
	AND.W	D3,D6
	ADD.W	D6,D6
	MOVE.W	VALEURS+2(PC,D6.W),D6
	NOT.W	D6
	SUB.W	D1,D2
	BNE.S	LFCA63C
	AND.W	D6,D4
LFCA63C	

	MOVEA.L	$44E.W,A1
	lea	4(a1),a1
	MULS.W	#160,D5
	ADDA.L	D5,A1

	MOVEA.W	D0,A2

	MOVE.W	#4,D7	NB PLANS
	MOVE	#8,D0
	MULS.W	D0,D1	
	ADDA.L	D1,A1	A1=SCREEN

	LEA	24(A4),A3	VALEUR DE LA COLOR DU PLAN 0

	NOT.W	D4
	NOT.W	D6
LFD1C56	MOVEA.L	A1,A4
	MOVE.W	D2,D5
	MOVE.W	(A0),D3
	ADDA.W	A2,A0
	TST.W	(A3)+
	BNE.S	LFD1C88
	MOVE.W	D4,D1
	AND.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1C7E
	SUBQ.W	#1,D5
	BCS.S	LFD1C78
	CLR.W	D1
LFD1C70	ADDA.W	D0,A4
	MOVE.W	D1,(A4)

	DBF	D5,LFD1C70

LFD1C78	MOVE.W	D6,D1
	ADDA.W	D0,A4
	AND.W	D1,(A4)
LFD1C7E	

	NOT.W	D4
	NOT.W	D6
	RTS

LFD1C88	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D4,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A1)+
	SUBQ.W	#1,D5
	BCS.S	LFD1CAE
	SUBQ.W	#1,D5
	BCS.S	LFD1CA2
LFD1C9A	ADDA.W	D0,A4
	MOVE.W	D3,(A4)
	DBF	D5,LFD1C9A
LFD1CA2	ADDA.W	D0,A4
	MOVE.W	(A4),D1
	EOR.W	D3,D1
	AND.W	D6,D1
	EOR.W	D3,D1
	MOVE.W	D1,(A4)

LFD1CAE	DBF	D7,LFD1C56

	NOT.W	D4
	NOT.W	D6
	RTS


                
DRAW_A_LINE
                cmp.w   d1,d3
                beq     DRAW_HORIZONTAL
                cmp.w   d0,d2
                beq     DRAW_VERTICAL

                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l	$44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0
                move.w  d0,d5
                eor.w   #$0f,d5
                and.w   #$0f,d5
                clr.w   d6
                bset    d5,d6
                move.w  d6,d7           OR Mask
                not.w   d6              AND Mask

                sub.w   d0,d2           u
                sub.w   d1,d3           v

                move.l  #0,a1
                move.l  #0,a2
                move.l  #0,a3
                move.l  #0,a4
                
                tst.w   d2
                bpl.s   .dr_1
                beq.s   .dr_2
                move.w  #-1,a1          d1x
                neg.w   d2              M
                bra.s   .dr_2
.dr_1
                move.w  #1,a1           d1x
.dr_2
                tst.w   d3
                bpl.s   .dr_3
                beq.s   .dr_4
                move.w  #-1,a2          d1y
                neg.w   d3              N
                bra.s   .dr_4
.dr_3
                move.w  #1,a2           d1y
.dr_4
                cmp.w   d2,d3
                blt.s   .dr_5
                move.w  a2,a4           d2y
                exg     d2,d3
                bra.s   .dr_6
.dr_5
                move.w  a1,a3           d2x
.dr_6 
                move.w  d2,d0
                lsr.w   #1,d0           S
                move.w  d2,d1           I

*               d0: S, d1: I, d2: M, d3: N, d6:AND Mask, d7:OR Mask
*               a0: Screen, a1: d1x, a2:d1y, a3:d2x, a5:d2y
.dr_7
*               PLOT THE POINT

                or.w    d7,(a0)

                add.w   d3,d0
                cmp.w   d0,d2
                bgt.s   .dr_8
        
                sub.w   d2,d0
                
                cmp.w   #0,a1
                beq.s   .dr_A5
                bmi.s   .dr_A6
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A5
                addq.l  #8,a0
                bra.s   .dr_A5
.dr_A6
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A5
                subq.l  #8,a0
.dr_A5
                cmp.w   #0,a2
                beq.s   .dr_A3
                bmi.s   .dr_A8
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A8
                lea     -160(a0),a0
                bra.s   .dr_A3
.dr_8
                cmp.w   #0,a3
                beq.s   .dr_A1
                bmi.s   .dr_A2
                ror.w   #1,d6
                ror.w   #1,d7
                bcc.s   .dr_A3
                addq.l  #8,a0
                bra.s   .dr_A3
.dr_A2
                rol.w   #1,d6
                rol.w   #1,d7
                bcc.s   .dr_A3
                subq.l  #8,a0
                bra.s   .dr_A3
.dr_A1
                cmp.w   #0,a4
                bmi.s   .dr_A4
                lea     160(a0),a0
                bra.s   .dr_A3
.dr_A4
                lea     -160(a0),a0
.dr_A3
                dbf     d1,.dr_7        
                rts

DRAW_HORIZONTAL
                cmp.w   d0,d2
                bne.s   .dr_h_1
                rts
.dr_h_1
                bgt.s   .dr_h_2
                exg     d0,d2
.dr_h_2
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                move.w  d2,d3
                move.w  d0,d6
                
                and.w   #$fff0,d6
                lsr.w   #4,d6
                and.w   #$fff0,d2
                lsr.w   #4,d2
                
                sub.w   d6,d2

                lea     PIXEL_TABLE_LEFT,a1
                and.w   #$000f,d0
                lsl.w   #1,d0
                move.w  (a1,d0),d0
                lea     PIXEL_TABLE_RIGHT,a1
                and.w   #$000f,d3
                lsl.w   #1,d3
                move.w  (a1,d3),d3

                tst     d2
                bne.s   .dr_h_7
                
                and.w   d0,d3
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_7
                subq.w  #1,d2
                bne.s   .dr_h_8
                
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7
                bra.s   .dr_h_m_1
.dr_h_8
                move.w  d0,d6
                move.w  d0,d7
                not.w   d7
                bsr.S     .dr_h_m_1

                subq.w  #1,d2
                move.w  #$ffff,d6
                clr.w   d7
.dr_h_9
                bsr.S     .dr_h_m_1
                dbf     d2,.dr_h_9
                
                move.w  d3,d6
                move.w  d3,d7
                not.w   d7

.dr_h_m_1       
                or.w    d6,(a0)
	lea	8(a0),a0
                rts

DRAW_VERTICAL
                cmp.w   d1,d3
                bgt.s   .dr_v_1
                exg     d1,d3
.dr_v_1
                move.w  d0,d5
                move.w  d1,d6
                ext.l   d5
                ext.l   d6
                lsl.w   #1,d6
                lea     SCREEN_Y_TABLE,a0
                move.l  #0,a1
                move.w  (a0,d6),a1
                movea.l  $44e.w,a0
                lea	4(a0),a0
                add.l   a1,a0
                and.l   #$fffffff0,d5
                lsr.w   #1,d5
                add.l   d5,a0

                eor.w   #$0f,d0
                and.w   #$0f,d0
                clr.w   d6
                bset    d0,d6
                move.w  d6,d7           OR Mask
                not.w   d7              AND Mask

                sub.w   d1,d3           Height
.dr_v_m_1
                or.w    d6,(a0)

                lea     160(a0),a0
                dbf     d3,.dr_v_m_1
                rts

	**************************************
	*ROUTINE GENERALE DE DECALAGES 1 PLAN*
	*ENTR�ES... D0:POSITION X SUR L'ECRAN*
	*           D1:POSITION Y SUR L'ECRAN*
	*           D2:LONGUEUR-1 DU SPRITE  *
	*           D3:HAUTEUR-1 DU SPRITE   *
	*           A2:BASE ECRAN            *
	*           A6:ADRESSE DU SPRITE     *
	*  LES CLIPPING X ET Y SONT COMPRIS  *
	* v.0.3  13/05/92   22 H 20  pm      *
	**************************************
AFF_SPR_1_P	MOVE.W	D0,$140.W
	MOVEQ	#0,D5	INCREMENT GAUCHE & DROIT A 0
	MOVEQ	#0,D6
	MOVE.W	D2,D4
	ANDI.W	#$FFF0,D4
	LSR	#4,D4
	MOVE.W	D4,D7
	ADDQ.W	#1,D4
	ADD.W	D4,D4	D4:LONGUEUR EN OCTET D'UNE LIGNE

	TST.W	D0
	BGE.S	X_POSITIF
	MOVE.W	D0,D5
	ANDI.W	#15,D0	D0:DECALAGE
	NEG.W	D5
	SUBQ.W	#1,D5	COMPLEMENT A 2
	ANDI.W	#-16,D5
	LSR	#1,D5
	ADDQ.W	#8,D5	D5:NB D'OCTETS A NE PAS AFFICHER EN DEBUT DE SPRITE
	MOVEQ	#0,D0	X=0
	BRA.S	X_CLIPP�S
X_POSITIF	CMPI.W	#320,D0
	BGE	PAS_SPRITE
	MOVE.W	D0,D6
	ANDI.W	#15,D0	D0:DECALAGE
	ADD.W	D2,D6
	CMPI.W	#320,D6
	BLT.S	X_CLIPP�S
	SUBI.W	#319,D6	D6:NB DE PIXELS A RETIRER A DROITE DU SPRITE
	ANDI.W	#-16,D6
	LSR	#1,D6
	ADDQ.W	#8,D6	D6:NB D'OCTETS A IGNORER EN FIN DE LIGNE
	BRA.S	X_CLIPP�S+2

X_CLIPP�S	MOVEQ	#0,D6
	TST.W	D1
	BGE.S	Y_POSITIF
	NEG.W	D1	D1:NB DE LIGNES A NE PAS AFFICHER AU DEBUT DU SPRITE
	MULU.W	D1,D4
	ADDA.W	D4,A6	A6:NOUVELLE ADRESSE DU SPRITE CLIPP� EN HAUT
	MOVEQ	#0,D1	Y=0
	BRA.S	Y_CLIPP�S
Y_POSITIF	MOVE.W	D1,D4
	CMPI.W	#200,D4
	BGE	PAS_SPRITE
	ADD.W	D3,D4
	CMPI.W	#200,D4
	BLT.S	Y_CLIPP�S
	SUB.W	#199,D4
	SUB.W	D4,D3

Y_CLIPP�S	MOVE.W	D1,D4
	ADD.W	D1,D1
	ADD.W	D1,D1
	ADD.W	D4,D1
	LSL	#5,D1	D1:Y*160
	ADDA.W	D1,A2	A2:ADRESSE ECRAN DESTINATION
	MOVE.W	$140.W,D2
	ANDI.W	#-16,D2
	LSR	#1,D2
	ADDA.W	D2,A2

	;ARRIV� ICI D3 EST LA HAUTEUR DU SPRITE CLIPP� OU PAS
	;           A6 EST L'ADRESSE DU SPRITE CLIPP� OU PAS
	;           A2 EST L'ADRESSE ECRAN DE DESTINATION
	;           D5 EST A 0 OU DIFFERENT DE 0 SI CLIPP� A GAUCHE
	;           D6 EST A 0 OU DIFFERENT DE 0 SI CLIPP� A DROITE
	;           D0 EST LE DECALAGE

;	TST.W	D5
;	BNE.S	PAS_CLIP_GAUCHE
;	NOP

;	TST.W	D6
;	BNE.S	CLIP_NORMAL
;	NOP

CLIP_NORMAL	LEA	LEA_2+2,A0
	LEA	DBRA_2+2,A1

	LEA	TABLE_BRA_2,A4
	MOVE.W	#160,D4
	MOVE.W	D7,D1
	ADDQ.W	#1,D1
	LSL	#3,D1
	SUB.W	D1,D4
	MOVE.W	D4,(A0)

	ADD.W	D7,D7
	ADD.W	D7,D7	D7=NB DE BLOCS DE 16 *4
	MOVE.L	-4(A4,D7.W),A4
;	MOVE.L	A4,D1
;	MOVE.L	A1,D4
;	SUB.W	D4,D1
;	MOVE.W	D1,(A1)	

	MOVEQ	#0,D4	PRECAUTION
	MOVEQ	#0,D1
	LEA	TABLE_MASK,A0
	MOVE.W	D0,D2
	ADD.W	D2,D2
	ADD.W	D2,D2
	MOVE.L	(A0,D2.W),D5	MASK

ROUT_320_NRM	MOVE	(A6),D2
	SWAP	D2
	MOVE	8(A6),D2
	LEA	16(A6),A6

	ROR.L	D0,D2
	MOVE.L	D2,D4
	AND.L	D5,D2
	EOR.L	D2,D4
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	

	JMP	(A4)

ROUT_288_NRM	MOVE.L	(A6)+,D2
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D4
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D4
	OR.L	D1,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	

ROUT_256_NRM	MOVE.L	(A6)+,D2	PLAN 1 + PLAN 1
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D1
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D1
	OR.L	D4,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2


ROUT_224_NRM	MOVE.L	(A6)+,D2
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D4
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D4
	OR.L	D1,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	

ROUT_192_NRM	MOVE.L	(A6)+,D2	PLAN 1 + PLAN 1
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D1
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D1
	OR.L	D4,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2

ROUT_160_NRM	MOVE.L	(A6)+,D2
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D4
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D4
	OR.L	D1,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	

ROUT_128_NRM	MOVE.L	(A6)+,D2	PLAN 1 + PLAN 1
	MOVE	#$700,$FFFF8240.W
	ROR.L	D0,D2
	MOVE.L	D2,D1
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D1
	OR.L	D4,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2

ROUT_96_NRM	MOVE	(A6),D2
	SWAP	D2
	MOVE	8(A6),D2
	LEA	16(A6),A6

	ROR.L	D0,D2
	MOVE.L	D2,D1
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D1
	OR.L	D4,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	

ROUT_64_NRM	MOVE	(A6),D2
	SWAP	D2
	MOVE	8(A6),D2
	LEA	16(A6),A6


	ROR.L	D0,D2
	MOVE.L	D2,D4
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D4
	OR.L	D1,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2

ROUT_32_NRM	MOVE	(A6),D2
	SWAP	D2
	MOVE	8(A6),D2
	LEA	16(A6),A6

	ROR.L	D0,D2
	MOVE.L	D2,D1
	AND.L	D5,D2	D2=MOTIF DE 32 PIXELS DECAL�
	EOR.L	D2,D1
	OR.L	D4,D2
	MOVE.W	D2,8(A2)
	SWAP	D2
	MOVE.W	D2,(A2)
	LEA	16(A2),A2	
	MOVE.W	D1,8(A2)
	SWAP	D1
	MOVE.W	D1,(A2)

	MOVEQ	#0,D4
	MOVEQ	#0,D1
	
	LEA	96(A6),A6
	
LEA_2	LEA	96(A2),A2		LE LEA EST AUTOMODIFI�
DBRA_2	DBRA	D3,ROUT_320_NRM	LE DBRA EST AUTOMODIFI�
	RTS

RIEN	DS.L	1

PAS_SPRITE	RTS

TABLE_BRA_2	DC.L	ROUT_288_NRM
	DC.L	ROUT_256_NRM,ROUT_224_NRM
	DC.L	ROUT_192_NRM,ROUT_160_NRM
	DC.L	ROUT_128_NRM,ROUT_96_NRM
	DC.L	ROUT_64_NRM,ROUT_32_NRM

TABLE_MASK	DC.L	$FFFFFFFF,$7FFFFFFF,$3FFFFFFF,$1FFFFFFF
	DC.L	$0FFFFFFF,$07FFFFFF,$03FFFFFF,$01FFFFFF
	DC.L	$00FFFFFF,$007FFFFF,$003FFFFF,$001FFFFF
	DC.L	$000FFFFF,$0007FFFF,$0003FFFF,$0001FFFF


SCREEN_Y_TABLE
                dc.w    0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240
                dc.w    2400,2560,2720,2880,3040,3200,3360,3520,3680,3840,4000,4160,4320,4480,4640
                dc.w    4800,4960,5120,5280,5440,5600,5760,5920,6080,6240,6400,6560,6720,6880,7040
                dc.w    7200,7360,7520,7680,7840,8000,8160,8320,8480,8640,8800,8960,9120,9280,9440
                dc.w    9600,9760,9920,10080,10240,10400,10560,10720,10880,11040,11200,11360,11520,11680,11840
                dc.w    12000,12160,12320,12480,12640,12800,12960,13120,13280,13440,13600,13760,13920,14080,14240
                dc.w    14400,14560,14720,14880,15040,15200,15360,15520,15680,15840,16000,16160,16320,16480,16640
                dc.w    16800,16960,17120,17280,17440,17600,17760,17920,18080,18240,18400,18560,18720,18880,19040
                dc.w    19200,19360,19520,19680,19840,20000,20160,20320,20480,20640,20800,20960,21120,21280,21440
                dc.w    21600,21760,21920,22080,22240,22400,22560,22720,22880,23040,23200,23360,23520,23680,23840
                dc.w    24000,24160,24320,24480,24640,24800,24960,25120,25280,25440,25600,25760,25920,26080,26240
                dc.w    26400,26560,26720,26880,27040,27200,27360,27520,27680,27840,28000,28160,28320,28480,28640
                dc.w    28800,28960,29120,29280,29440,29600,29760,29920,30080,30240,30400,30560,30720,30880,31040
                dc.w    31200,31360,31520,31680,31840
PIXEL_TABLE_LEFT
                dc.w    %1111111111111111
                dc.w    %0111111111111111
                dc.w    %0011111111111111
                dc.w    %0001111111111111
                dc.w    %0000111111111111
                dc.w    %0000011111111111
                dc.w    %0000001111111111
                dc.w    %0000000111111111
                dc.w    %0000000011111111
                dc.w    %0000000001111111
                dc.w    %0000000000111111
                dc.w    %0000000000011111
                dc.w    %0000000000001111
                dc.w    %0000000000000111
                dc.w    %0000000000000011
                dc.w    %0000000000000001
PIXEL_TABLE_RIGHT
                dc.w    %1000000000000000
                dc.w    %1100000000000000
                dc.w    %1110000000000000
                dc.w    %1111000000000000
                dc.w    %1111100000000000
                dc.w    %1111110000000000
                dc.w    %1111111000000000
                dc.w    %1111111100000000
                dc.w    %1111111110000000
                dc.w    %1111111111000000
                dc.w    %1111111111100000
                dc.w    %1111111111110000
                dc.w    %1111111111111000
                dc.w    %1111111111111100
                dc.w    %1111111111111110
                dc.w    %1111111111111111

MESS_X_COORD    dc.w    0
MESS_Y_COORD    dc.w    0


gg:	addq #2,sp
	rts
		
pattern:	dc.w $ffff

f01:	incbin	wave4.dat	;300738 octets
		
data_ads:	dc.l	f01

text:
	dc.b "                           I THINK THIS IS ONE OF THE MOST PERVERT TORTURE... "
	DC.B	"  I AM QUITE SURE YOU HAVE DIFFICULTIES TO READ !  BUT DO NOT PANIC, IT WILL NOT CONTAIN"
	DC.B	" VERY INTERESTING THINGS OR REVOLUTIONNARY TRICKS...  ( UNLESS YOU WANNA CODE TRIDI ROUTS USING THE MIDI OUTPUT... HAW HAW ! HI ULM ! )"
	
	dc.b "                                "
	dc.b 255,255

	even
font:	
	dc.b %00000,%00000,%00000,%00000	;' '
	dc.b %00000,%11101,%11101,%00000	;!
	dc.b %01111,%10100,%10100,%01111	;a
	dc.b %01010,%10101,%10101,%11111	;b
	dc.b %10001,%10001,%10001,%11111	;c
	dc.b %01110,%10001,%10001,%11111	;d
	dc.b %10001,%10101,%10101,%11111	;e
	dc.b %10000,%10100,%10100,%11111	;f
	dc.b %10110,%10101,%10001,%01110	;g
	dc.b %11111,%00100,%00100,%11111	;h
	dc.b %00000,%10001,%11111,%10001	;i
	dc.b %00000,%10000,%11111,%10001	;j
	dc.b %11011,%00100,%00100,%11111	;k
	dc.b %00001,%00001,%00001,%11111	;l
	dc.b %11111,%01000,%01000,%11111	;m
	dc.b %01111,%10000,%10000,%11111	;n
	dc.b %11111,%10001,%10001,%11111	;o
	dc.b %01000,%10100,%10100,%11111	;p
	dc.b %11111,%10011,%10001,%11111	;q
	dc.b %11101,%10110,%10100,%11111	;r
	dc.b %10010,%10101,%10101,%01001	;s
	dc.b %00000,%10000,%11111,%10000	;t
	dc.b %11111,%00001,%00001,%11111	;u
	dc.b %11110,%00001,%00001,%11110	;v
	dc.b %11111,%00010,%00010,%11111	;w
	dc.b %11011,%00100,%00100,%11011	;x
	dc.b %00000,%11100,%00111,%11100	;y
	dc.b %10001,%11001,%10101,%10011	;z
	dc.b %01110,%10001,%10001,%01110	;0
	dc.b %00000,%00001,%11111,%01001	;1
	dc.b %01001,%10101,%10011,%00001	;2
	dc.b %01010,%10101,%10101,%10001	;3
	dc.b %00010,%11111,%01010,%00110	;4
	dc.b %10010,%10101,%10101,%11101	;5
	dc.b %00010,%10101,%10101,%01110	;6
	dc.b %11000,%10100,%10010,%10001	;7
	dc.b %01010,%10101,%10101,%01010	;8
	dc.b %01110,%10101,%10101,%01001	;9
	dc.b %00000,%00011,%00011,%00000	;.
	dc.b %00000,%01001,%00000,%00000	;:
	dc.b %00000,%00010,%00001,%00000	;,
	dc.b %00000,%00000,%11000,%00000	;'
	dc.b %00000,%10001,%01110,%00000	;(
	dc.b %00000,%01110,%10001,%00000	;)

*equivalence:
*	dc.b " !ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,'()"

	bss
routines
	ds.b 111000
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	

SAUV_SP:		ds.l 1
uusp:		ds.l 1
ad_ecran:	ds.l 1
ecran_gem:	ds.l 1
vbl_save:	ds.l 1
tb_save:	ds.l 1
vbl_sync:	ds.w 1
pal_save:	ds.w 16
res_save:	ds.w 1
mfp_save:	ds.w 1
SAVEA0	DS.L	1
lineA_tab:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
ad_data_pt:	ds.l 1
PNT_261E	DS	1
SAVEA2	DS.L	1
SAVE	DS.L	1
SCREEN1	DS.L	1
SCREEN2	DS.L	1
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
PNT_FAD	DS.L	1
PNT_FAD2	DS.L	1
pntcolor	ds.l	1
off_bolean:	ds.b 500
EMUL_LINEA	DS.B	60
	DS.B	256+10000
BUFFERSCR	DS.B	150*256*2
	ds.b	256

POS_X	DS.W	1
POS_Y	DS.W	1

MFP1	DS.B	1
MFP2	DS.B	1
MFP3	DS.B	1
MFP4	DS.B	1
MFP5	DS.B	1
MFP6	DS.B	1
SAVE_ALL	DS.L	16
BUF16DA	DS.B	512
PtsFill:	ds.b	512
