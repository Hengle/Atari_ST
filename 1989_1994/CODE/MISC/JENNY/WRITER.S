	LEA.L 	NEW_PILE,A7
	PEA	0.W
	MOVE 	#$20,-(SP)
	TRAP 	#1
	ADDQ.L 	#6,SP

	CLR.W 	-(SP)
	PEA	-1.W
	PEA	-1.W
	MOVE 	#5,-(SP)
	TRAP 	#14
	LEA.L 	12(SP),SP
	SF	$FFFF8240.W
	SF	$FFFF8242.W
	move.l	#BUFFERSCR,d0
	CLR.B	D0
	move.l	d0,SCREEN1

	move.l	SCREEN1,d0
	lsr.l	#8,d0
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	MOVE.L	#VBL,$70.W
	
VBL_TXT
LOOP_AFF_MES
MOD_ADR	EQU	*+2
	LEA	MESSAGE,A0
	CMPI.B	#-1,(A0)
	BEQ	TERMIN�
	MOVE	#(20*5)-1,D6
ICI	MOVEQ	#0,D0
	MOVE.L	SCREEN1,A5
	LEA	160*60(A5),A5
	LEA	CORRES,A2
MOD	EQU	*+2
	LEA	0(A5),A5
MOD2	EQU	*+2
	LEA	0(A5),A5
	MOVE.B	(A0)+,D0
	SUBI.B	#32,D0
;	TST.B	D0
;	BEQ.S	GO
;	SUBQ.B	#1,D0
GO	LSL.L	#2,D0
	ADDA.L	D0,A2
	MOVE.L	(A2),A2
	MOVEQ	#15,D0
AFF_A_LETTER	MOVE	(A2),(A5)
	LEA	160(A2),A2
	LEA	160(A5),A5
	DBF	D0,AFF_A_LETTER
	ADDQ	#8,MOD
	CMPI	#160,MOD
	BNE.S	OKAY_MAN
	CLR	MOD
	ADD	#160*16,MOD2
OKAY_MAN	DBF	D6,ICI
	MOVE.L	A0,MOD_ADR
	CLR	MOD
	CLR	MOD2
	CLR	PNT_FAD
	CLR	PNT_FADB
FAD1	LEA	FAD_IN,A0
PNT_FAD	EQU	*+2
	LEA	0(A0),A0
	MOVE	(A0),D0
	CMPI	#-1,D0
	BEQ.S	ENDED
	MOVE	D0,MODCOL
;	MOVE.L	#WAIT_A_BIT,MODMOD
;	RTE

WAIT_A_BIT	TST.L	$140.W
	BEQ.S	WAIT_A_BIT
	CLR.L	$140.W
	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#4,PNT_FAD2
	BNE.S	EXI
	ADDQ	#2,PNT_FAD
	CLR.L	PNT_FAD2
EXI	;MOVE.L	#FAD1,MODMOD
	JMP	FAD1

PNT_FAD2	DC.L	0
TIME	DC.L	0
ENDED	ADDQ.L	#1,TIME
;	MOVE.L	#WAIT2,MODMOD
;	RTE
WAIT2	TST.L	$140.W
	BEQ.S	WAIT2
	CLR.L	$140.W
	CMPI.L	#50*4,TIME
	BNE.S	ENDED
	CLR.L	TIME
	CLR.L	PNT_FAD2
FAD2	LEA	FAD_OUT,A0
PNT_FADB	EQU	*+2
	LEA	0(A0),A0
	MOVE	(A0),D0
	CMPI	#-1,D0
	BEQ.S	ENDEDB
	MOVE	D0,MODCOL
WAITB	;MOVE.L	#WAITB__,MODMOD
	;RTE
WAITB__	TST.L	$140.W
	BEQ.S	WAITB
	CLR.L	$140.W
	ADDQ.L	#1,PNT_FAD2
	CMPI.L	#4,PNT_FAD2
	BNE.S	EXIB
	ADDQ	#2,PNT_FADB
	CLR.L	PNT_FAD2
EXIB	;MOVE.L	#FAD2,MODMOD
	;RTE
	BRA.S	FAD2
ENDEDB	CLR.L	TIME
	CLR.L	PNT_FAD2
;	MOVE.L	#LOOP_AFF_MES,MODMOD
;	RTE
	JMP	LOOP_AFF_MES
TERMIN�	BRA.S	TERMIN�

	*	'                    '
MESSAGE
	DC.B	'                    '
	DC.B	'                    '
	DC.B	' HER NAME IS JENNY. '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	'                    '
	DC.B	'                    '
	DC.B	'   LOOK AT HER...   '
	DC.B	"  SHE'S SLEEPING... "
	DC.B	'                    '

	DC.B	'EH? I WONDER IF SHE '
	DC.B	"IS DREAMING OF ME ? "
	DC.B	'                    '
	DC.B	'  ( ZAPPY ON        '
	DC.B	'        KEYBOARD...)'

	DC.B	'                    '
	DC.B	"    LET'S ENTER     "
	DC.B	'                    '
	DC.B	'   IN HER DREAMS !  '
	DC.B	'                    '
	DC.B	'                    '

	DC.B	-1,-1,-1,-1
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	DC.B	'                    '
	EVEN
CORRES
N	SET	0
	REPT	20
	DC.L	FONTES+N
N	SET	N+8
	ENDR

N	SET	0
	REPT	20
	DC.L	FONTES+N+(160*15)
N	SET	N+8
	ENDR

N	SET	0
	REPT	20
	DC.L	FONTES+N+(160*30)
N	SET	N+8
	ENDR
FONTES	INCBIN	FNT.COD
	DS.B	160
	EVEN
FAD_IN
	DC	$000,$111,$222,$333,$444,$555,$666,$777
	DC	-1
FAD_OUT
	DC	$777,$666,$555,$444,$333,$222,$111,$000
	DC	-1
**************************
*A METTRE DS LE FULL
VBL	MOVE.L	#1,$140.W
MODCOL	EQU	*+2
	MOVE	#000,$FFFF8242.W
	RTE

	BSS
	DS.L	256
NEW_PILE	DS.L	1
	DS.B	256
BUFFERSCR	DS.B	32000
SCREEN1	DS.L	1
