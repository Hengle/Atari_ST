	CLR.L	LIGNES
	CLR.L	TM
	CLR.L	D0
	
	LEA	BUFFER,A0
	LEA	INSTRUCTIONS,A1
	LEA	BUFFER_FULL,A2
BOUCLE	MOVE	(A1),D2
	MOVE	2(A1),D1
	MOVE	4(A1),D0
	CMP	(A0),D0
	BEQ.S	THATS_IT
	CMPI	#$4E75,(A0)
	BEQ	THE_END
	CMPI	#$ABCD,D0
	BEQ	PROBLEME_NUMERO_UN
	LEA	6*2(A1),A1
	BRA.S	BOUCLE
THATS_IT
	CMPI.L	#0,TM
	BNE.S	PAS_OVER_GAUCHE
	MOVE.L	#$12834E71,(A2)+
	MOVE	#$1283,(A2)+
	MOVE.L	#5,TM
PAS_OVER_GAUCHE
	CMPI.L	#94,TM
	BLE	PARTIE_UN
	CMPI.L	#111,TM
	BLE.S	PARTIE_DEUX
	CMPI.L	#128,TM
	BLE	PARTIE_TROIS


PARTIE_TROIS
	MOVE.L	TM,D4
	ADD.L	D1,D4
	CMPI.L	#128,D4
	BGT.S	TOUJOURS_TROP_GRAND	SI=ALORS CA RENTRE
	BRA	CA_RENTRE
TOUJOURS_TROP_GRAND
	MOVE.L	#128,D4
	MOVE.L	TM,D5
	SUB.L	D5,D4
	CMPI.L	#0,D4
	BEQ.S	DECIDEMENT_PAS_DE_NOP
	SUBQ.L	#1,D4
NOPZ	MOVE	#$4E71,(A2)+
	DBF	D4,NOPZ
DECIDEMENT_PAS_DE_NOP	
	MOVE.L	#$12834E71,(A2)+
	MOVE	#$1284,(A2)+
	MOVE.L	#5,TM
	BRA	CA_RENTRE

PARTIE_DEUX
	MOVE.L	TM,D4
	ADD.L	D1,D4
	CMPI.L	#111,D4
	BGT.S	ENCORE_TROP_GRAND	SI=ALORS CA RENTRE
	BRA	CA_RENTRE
ENCORE_TROP_GRAND
	MOVE.L	#111,D4
	MOVE.L	TM,D5
	SUB.L	D5,D4
	CMPI.L	#0,D4
	BEQ.S	TOUJOURS_PAS_DE_NOP
	SUBQ.L	#1,D4
NOPX	MOVE	#$4E71,(A2)+
	DBF	D4,NOPX
TOUJOURS_PAS_DE_NOP	
	MOVE.L	#$12834E71,(A2)+
	MOVE	#$1284,(A2)+
	MOVE.L	#116,TM
	BRA.S	CA_RENTRE
	
PARTIE_UN
	MOVE.L	TM,D4
	ADD.L	D1,D4
	CMPI.L	#94,D4
	BGT.S	TROP_GRAND	SI=ALORS CA RENTRE
	BRA	CA_RENTRE
TROP_GRAND
	MOVE.L	#94,D4
	MOVE.L	TM,D5
	SUB.L	D5,D4
	CMPI.L	#0,D4
	BEQ.S	PAS_DE_NOP
	SUBQ.L	#1,D4
NOPY	MOVE	#$4E71,(A2)+
	DBF	D4,NOPY
PAS_DE_NOP	
	MOVE.L	#$10831084,(A2)+
	MOVE.L	#98,TM
CA_RENTRE	
	SUBQ	#1,D2
ICI	MOVE	(A0)+,(A2)+
	DBF	D2,ICI
	ADD.L	D1,TM
	LEA	INSTRUCTIONS,A1
	BRA	BOUCLE

THE_END
	MOVE	#$4E75,(A2)
	
	MOVE.L	#TEXTE2,-(SP)
	MOVE	#$9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE	#$7,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	BRA.S	FIN

PROBLEME_NUMERO_UN
	MOVE.L	#TEXTE1,-(SP)
	MOVE	#$9,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE	#$7,-(SP)
	TRAP	#1
	ADDQ.L	#2,SP
	BRA.S	FIN

	NOP

FIN	CLR.L	-(SP)
	TRAP	#1

BUFFER
	REPT	500
	MOVE	#$FFFF,(A0)
	MOVE.L	#$FFFF,(A0)
	ENDR
	RTS

TEXTE1	DC.B	'INSTRUCTION NON RECONNUE.',0
TEXTE2	DC.B	'CA ROULE.',0

INSTRUCTIONS
 DC	4,6,$217C,$FFFF,$FFFF,$0008	;MOVE.L	#$FFFFFFFF,8(A0)
 DC	3,4,$317C,$FFFF,$0008,$0000	;MOVE	#$FFFF,8(A0)
 DC	3,4,$117C,$00FF,$0008,$0000	;MOVE.B	#$FF,8(A0)
 DC	3,5,$20BC,$FFFF,$FFFF,$0000	;MOVE.L	#$FFFFFFFF,(A0)
; 	     22						   (A1)
; 	     24						   (A2)
; 	     26						   (A3)
; 	     28						   (A4)
; 	     2A						   (A5)
; 	     2C						   (A6)
 DC	2,3,$30BC,$FFFF,$0000,$0000	;MOVE	#$FFFF,(A0)
 DC	2,3,$10BC,$00FF,$0000,$0000	;MOVE.B	#$FF,(A0)

 DC	9,9,$ABCD			;FIN

;FULLSCREEN
;1283	MOVE.B	D3,(A1)			2
;	NOP				1	3
;1284	MOVE.B	D4,(A1)			2	5
;	REPT	89			89	94
;	NOP				
;	ENDR
;1084	MOVE.B	D4,(A0)			2	96
;1083	MOVE.B	D3,(A0)			2	98
;	REPT	13			13	111
;	NOP
;	ENDR
;1283	MOVE.B	D3,(A1)			2	113
;	NOP				1	114
;1284	MOVE.B	D4,(A1)			2	116
;	REPT	12			12	128
;	NOP			 
;	ENDR




	SECTION	BSS
LIGNES	DS.L	1
TM	DS.L	1	
BUFFER_FULL
	DS.B	10000
	EVEN