t	
	dc.b	" "
	dc.b	"HI IT'S ME AGAIN TO SERVE YOU.......FUCK TO SELIM THE MUSULMAN FORCE    "
	dc.b	-1
	EVEN

buffl:		
	dc.w	21216,21216,21184,21216,21216,21216,21216,21168
	dc.w	10688,10704,21216,21216,21152,21120,10656,21216	
	
n	set	15840
	rept	10
	dc.w	n
n	set	16+n
	endr

	dc.w	10672,21200,21216,21216,21216,21216,21216	

n	set	0
	rept	10
	dc.w	n
n	set	8*2+n
	endr
	
n	set	5280	
	rept	10
	dc.w	n
n	set	n+16
	endr	
	
n	set	10560	
	rept	6
	dc.w	n
n	set	n+16
	endr	

	section	data
posl	ds.l	1
ptlet	ds.l	1
posc1	ds.l	1
posc2	ds.l	1
indad	ds.w	1
ptdsc	ds.w	1
vsiff	ds.w	1
tdscr1	ds.w	32*21*2*4
tdscr2	ds.w	32*21*2*4
tdscr3	ds.w	32*21*2*4
tdscr4	ds.w	32*21*2*4
	section	text

	
	
	section data

paobj	dc.l	tpoly1,tpoitesp1,tpoly2,tpoitesp2,tpoly3,tpoitesp3,-1

******************cube*********************

tpoly1	dc.w	6-1
	dc.l	face11+2,face12+2,face13+2,face14+2,face15+2,face16+2 	

face11	dc.w	0,$5488,4,0,4,8,12
face12	dc.w	0,$5888,4,16,0,12,28
face13	dc.w	0,$5c88,4,12,8,24,28
face14	dc.w	0,$5888,4,4,20,24,8
face15	dc.w	0,$5c88,4,16,20,4,0 
face16	dc.w	0,$4e71,4,28,24,20,16

tpoitesp1	
	dc.w	8-1
	dc.w	-42,-42,-42		1
	dc.w	-42,42,-42		2
	dc.w	42,42,-42		3	
	dc.w	42,-42,-42		4
	dc.w	-42,-42,42		5	
	dc.w	-42,42,42		6	
	dc.w	42,42,42		7
	dc.w	42,-42,42		8
*****************************************************
tpoly2	dc.w	7-1
	dc.l	face21+2,face22+2,face23+2,face24+2,face25+2,face26+2,face27+2 	

face21	dc.w	0,$5488,4,0,4,8,12	avd
face22	dc.w	0,$5888,4,0,12,32,36	dhaut
face23	dc.w	0,$5888,4,36,32,28,16	dhaut
face24	dc.w	0,$5c88,5,12,8,24,28,32	droit
face25	dc.w	0,$5888,4,4,20,24,8	bas
face26	dc.w	0,$5c88,5,16,20,4,0,36 	gauche	
face27	dc.w	0,$4e71,4,28,24,20,16	arrie

tpoitesp2	
	dc.w	10-1
	dc.w	-40,-15,-25		1=0
	dc.w	-40,32,-25		2=4
	dc.w	40,32,-25		3=8	
	dc.w	40,-15,-25		4=12
	dc.w	-40,-15,25		5=16	
	dc.w	-40,32,25		6=15	
	dc.w	40,32,25		7=24
	dc.w	40,-15,25		8=28
	dc.w	40,-32,0		9=32
	dc.w	-40,-32,0		10=36

********************************************
tpoly3	dc.w	10-1
	dc.l	face31+2,face32+2,face33+2,face34+2,face35+2
	dc.l	face31B+2,face32B+2,face33B+2,face34B+2,face35B+2

face31	dc.w	1,$4E71,3,0,4,8
face32	dc.w	1,$4E71,3,12,16,20
face33	dc.w	1,$4E71,3,24,32,28
face34	dc.w	1,$4E71,3,36,28,44
face35	dc.w	1,$4E71,3,28,40,48
face31B	dc.w	1,$4E71,3,8,4,0
face32B	dc.w	1,$4E71,3,20,16,12
face33B	dc.w	1,$4E71,3,28,32,24
face34B	dc.w	1,$4E71,3,44,28,36
face35B	dc.w	1,$4E71,3,48,40,28

tpoitesp3	
	dc.w	13-1
	dc.w	-60,-40,0	0
	dc.w	-80,0,0	4
	dc.w	-60,40,0	8
	dc.w	-60,-10,0	12
	dc.w	-40,10,0	16
	dc.w	-20,-10,0	20
	dc.w	-20,-40,0	24
	dc.w	0,0,0	28
	dc.w	-20,40,0	32
	dc.w	0,-40,0	36
	dc.w	0,40,0	40
	dc.w	60,-40,0	44
	dc.w	60,40,0	48

****************************************************

	section	bss
ecran1	ds.l	1	
ecran2	ds.l	1
t_points	ds.w	20*2	
tdroit	ds.w	200
tgauch	ds.w	200
ancl	ds.w	1
oldvbl	ds.l	1
stimb	ds.l	1
oldcol	ds.l	8
ecranp	ds.w	40000                                                 