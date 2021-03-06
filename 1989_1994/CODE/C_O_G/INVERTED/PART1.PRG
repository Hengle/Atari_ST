1110000000000000
	DC.W	%1111000000000000
	DC.W	%1111100000000000
	DC.W	%1111110000000000
	DC.W	%1111111000000000
	DC.W	%1111111100000000
	DC.W	%1111111110000000
	DC.W	%1111111111000000
	DC.W	%1111111111100000
	DC.W	%1111111111110000
	DC.W	%1111111111111000
	DC.W	%1111111111111100
	DC.W	%1111111111111110
	DC.W	%1111111111111111

PNTS
N	SET	32768
	REPT	16
	DC.W	N
N	SET	N/2
	ENDR


ddpx	
n	set	0
	rept	20
	dc.l	trace11+n,trace11+n+8,trace11+n+16,trace11+n+24,trace11+n+32,trace11+n+40
	dc.l	trace11+n+48,trace11+n+56,trace11+n+68,trace11+n+76,trace11+n+84,trace11+n+92
	dc.l	trace11+n+100,trace11+n+108,trace11+n+116,trace11+n+124
n	set	n+136
	endr

fdpx
n	set	20*136
	rept	20
	dc.w 	n,ftrac2-saut-2,n,ftrac3-saut-2
	dc.w 	n,ftrac4-saut-2,n,ftrac5-saut-2
	dc.w 	n,ftrac6-saut-2,n,ftrac7-saut-2
	dc.w 	n,ftrac8-saut-2,n,ftrac9-saut-2
	dc.w 	n,ftrac10-saut-2,n,ftrac11-saut-2
	dc.w 	n,ftrac12-saut-2,n,ftrac13-saut-2
	dc.w 	n,ftrac14-saut-2,n,ftrac15-saut-2
	dc.w 	n,ftrac16-saut-2,n-136,ftrac1-saut-2
n	set	n-136
	endr

posx	
n	set	0
	rept	160/8
	dc.w	n,n,n,n
	dc.w	n,n,n,n
	dc.w	n+1,n+1,n+1,n+1
	dc.w	n+1,n+1,n+1,n+1
n	set	n+8
	endr  

posy:	
	
n	set 	-160*3
	rept	206	
	dc.w	n	
n	set n+160
	endr

ppxpet
	rept	(160/8)
	dc.w	7,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	dc.w	1,7,0,6,0,5,0,4
	dc.w	0,3,0,2,0,1,0,0
	endr

pointsCUBE
	dc	40,40,40
	dc	40,-40,40
	dc	40,-40,40
	dc	-40,-40,40
	dc	-40,-40,40
	dc	-40,40,40
	dc	-40,40,40
	dc	40,40,40
	dc	40,40,-40
	dc	40,-40,-40
	dc	40,-40,-40
	dc	-40,-40,-40
	dc	-40,-40,-40
	dc	-40,40,-40
	dc	-40,40,-40
	dc	40,40,-40
	dc	40,40,40
	dc	40,40,-40
	dc	40,-40,40
	dc	40,-40,-40
	dc	-40,-40,40
	dc	-40,-40,-40
	dc	-40,40,40
	dc	-40,40,-40
	dc	40,40,40
	dc	-40,-40,-40
	dc	40,40,-40
	dc	-40,-40,40
	dc	40,-40,40
	dc	-40,40,-40
	dc	40,-40,-40
	dc	-40,40,40

ZAP	INCBIN	MANGACOL.PI1
sound	incbin	ICC2B.mus
	EVEN

	section bss
DEB_BSS
F_PILE	DS.L 	128	
D_PILE	DS.L 	1	

xe	ds.w 1		;coordonnees spatiales
ye	ds.w 1
ze	ds.w 1

xdep	ds.w 1		;d�placements
ydep	ds.w 1
zdep	ds.w 1

xp	ds.w 1		;coordonnees planes
yp	ds.w 1

new_xe	ds.w 1		;nouvelles coords 
new_ye	ds.w 1		;apr�s rotation
new_ze	ds.w 1

x_angle	ds.w 1		;angles de rotation
y_angle	ds.w 1
z_angle	ds.w 1	
 
z_pt_fuite	ds.w 1		;coordonn�es z du 
			;du point de fuite

var_3d	ds.w 9                  ;tableau pour calculs
POINTEUR	DS.L	1
POINTEUR2	DS.L	1
DATA_X
	DS	NB_POS*NB_PTS*2
BOURRE	DS	1
ANC_VBL	DS.L	1
ANC_TB	DS.L	1
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
	even
CNT	DS.L	1
CNT2	DS.L	1
ZA	DS	1	
PNT_X	DS.L	1
PNT_Y	DS.L	1
PNT	DS.L	1

*LINE_A_EMUL

PNT_261E	DS	1
EMUL_LINEA	DS.B	100
BUF16DA	DS.B	512
BUF299A	DS.B	512
	even
_PTSIN	DS.B	100
	even
	DS.B	256
BUFFERSCR	DS.B	64000
	even
TABLE	DS.L	360
SCREEN1	DS.L	1
SCREEN2	DS.L	1
BUF1	DS.B	8000
BUF2	DS.B	8000
FINAL	DS.L	16
DATAS	DS.B	8000
BUFCOD	DS.B	206000
***
routines
	ds.b 70000
**
lineA_tab:	ds.l 1
routs_pt:	ds.l 1
text_pt:	ds.l 1
text_buff_pt:	ds.l 1
compteurs:	ds.w 2
ad_routines:	ds.l 5
text_buffer:	ds.b 150
text_buffer_deb	equ text_buffer+20
text_buffer_end:ds.l 1
off_bolean:	ds.b 500
SAVE_ALL	DS.L	16
*****
COURB_EC	DS.L	1
TEXT_EC	DS.L	1
COLONNE	DS	1
END_COD

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        