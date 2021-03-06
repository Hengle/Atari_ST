
* 30/04/91 -  ZAPPY
* Scrolle en 8 par 8 l'immense logo HOLOCAUST.
* Fontes 80*XX, inspirees d'un logo de VISION ( Amiga ).


IERA	EQU	$FFFA07
IERB	EQU	$FFFA09
ISRA	EQU	$FFFA0F
IMRA	EQU	$FFFA13
TBCR	EQU	$FFFA1B
TBDR	EQU	$FFFA21
SYNCRO	EQU	$FF820A
COUL_0	EQU	$FF8240
COUL_1	EQU	$FF8242
COUL_2	EQU	$FF8244
COUL_3	EQU	$FF8246
COUL_4	EQU	$FF8248
COUL_5	EQU	$FF824A
COUL_6	EQU	$FF824C
COUL_7	EQU	$FF824E
COUL_8	EQU	$FF8250
COUL_9	EQU	$FF8252
COUL_10	EQU	$FF8254
COUL_11	EQU	$FF8256
COUL_12	EQU	$FF8258
COUL_13	EQU	$FF825A
COUL_14	EQU	$FF825C
COUL_15	EQU	$FF825E
ACIA	EQU	$FFFC02
PSG	EQU	$FF8800


 	SECTION TEXT
DEBUT:	MOVE.L  A7,A5
	LEA.L 	D_PILE,A7
	MOVE.L 	4(A5),A5
	MOVE.L 	$C(A5),D0
	ADD.L 	$14(A5),D0
	ADD.L 	$1C(A5),D0
	ADD.L 	#$100,D0		
	MOVE.L 	D0,-(SP)		
        MOVE.L 	A5,-(SP)
	MOVE.W 	#0,-(SP)
	MOVE.W 	#$4A,-(SP)
	TRAP 	#1
	LEA 	12(SP),SP
	
	CLR.L 	-(SP)			* PASSAGE EN SUPERVISEUR
	MOVE.W 	#$20,-(SP)		*
	TRAP 	#1			*
	ADDQ.L 	#6,SP			*
	MOVE.L 	D0,SAUVE		* SAUVE LA PILE UTILISATEUR
			
	MOVE.B	IERA,MFP1		*
	MOVE.B	IERB,MFP2		*
	MOVE.B	ISRA,MFP3		* SAUVE LES REGISTRES
	MOVE.B	IMRA,MFP4		* UTILISES DU MFP
	MOVE.B	TBCR,MFP5		*
	MOVE.B	TBDR,MFP6		*
	
	CLR.B	IERA			* VIRE TOUTES LES
	CLR.B	IERB			* INTERUPTIONS
	

	;MOVE.L	#BUFFER,D0		* ADRESSE DU BUFFER POUR ECRAN
	;ANDI.L	#$FFFFFF00,D0		* SUPRIME LES 8 BITS "FAIBLE"
	;ADD.L	#512,D0			* ET FAIT MULTIPLE DE 256
	;MOVE.L	D0,ECRAN		* ON SAUVE L'ADRESSE CALCULEE
	
	MOVE.W	#4,-(SP)		* APPEL FONCTION GETREZ
	TRAP 	#14			* XBIOS...
	ADDQ.L	#2,SP			*
	MOVE.W	D0,RES			* SAUVE LA RESOLUTION
	
	MOVE.W	#2,-(SP)		* APPEL FONCTION PHYSBASE
	TRAP 	#14			* XBIOS
	ADDQ.L 	#2,SP			*
	MOVE.L	D0,ANC_ECR		* SAUVE L'ADRESSE ECRAN
	
	MOVE.W 	#0,-(SP)		* BASSE RESOLUTION
	MOVE.L	#-1,-(SP)		* PHYSBASE A ECRAN
	MOVE.L	#-1,-(SP)		* LOGBASE A ECRAN
	MOVE.W 	#5,-(SP)		* FONCTION SETSCREEN
	TRAP 	#14			* DU XBIOS
	LEA.L 	12(SP),SP		*

	LEA.L	COUL_0,A0		* ADRESSE PALETTE SHIFTER
	MOVEM.L	(A0),D0-D7		* RECUPERE LES 16 REGISTRES
	LEA.L	ANC_PAL,A0		* ADRESSE DE SAUVEGARDE
	MOVEM.L	D0-D7,(A0)		* SAUVE LES 16 REGISTRES
	
	
	;MOVEQ	#1,D0			* NETOIE D0
	;JSR	MUSIQUE4		* INITIALISE LA MUSIQUE
	
	
	MOVE.L	$70,ANC_VBL		* SAUVE L'ANCIEN VECTEUR VBL
	MOVE.L	#VBL_IR,$70		* ET PLACE LE MIEN...
	MOVE.L	$120,ANC_TB		* SAUVE ANCIEN VECTEUR TIMER B
	MOVE.L	#TB00_IR,$120		* ET PLACE LE MIEN...
	
	DC.W	$A00A			* CACHE LA SOURIS (LINE A)
	MOVE.B	#$12,ACIA		* INIT CLAV
	
	CLR.B	TBCR			* ARRET DU TIMER B (PLUS PRUDENT)
	BSET	#0,IERA			* AUTORISE LES INTERUPTIONS
	BSET	#0,IMRA			* SUR LE TIMER B


	movem.l	IMAGE+2,d0-d7	;palette...
	movem.l	d0-d7,$ff8240	;...actionn�e

	bsr	SET_SCR		;preparation des ecrans
	lea	TEXTE,a0	;debut du texte dans a0
	move.l	a0,MEM_LET	Position fonte (Table)
	move.w	#0,PART_AFF	(2 Parties)



BOUCLE:	JMP	BOUCLE

FIN:	
        MOVE.B  #2,SYNCRO
	MOVE.B	#8,ACIA			* REMET LE CLAVIER
	MOVE.B	MFP1,IERA		* RESTAURE LE MFP
	MOVE.B	MFP2,IERB		*
	MOVE.B	MFP3,ISRA		*
	MOVE.B	MFP4,IMRA		*
	MOVE.B	MFP5,TBCR		*
	MOVE.B	MFP6,TBDR		*
	
	MOVE.L	ANC_VBL,$70		* REMET LE VECTEUR VBL
	MOVE.L	ANC_TB,$120		* REMET LE VECTEUR TIMER C
	
	LEA.L	ANC_PAL,A0		* ADRESSE PALETTE SAUVEE
	MOVEM.L	(A0),D0-D7		* RECUPERE LES 16 REGISTRES
	LEA.L	COUL_0,A0		* ADRESSE PALETTE SHIFTER
	MOVEM.L	D0-D7,(A0)		* RESTITUE LES COULEURS
	
	MOVE.W 	RES,-(SP)		* ANCIENNE RESOLUTION
	MOVE.L	ANC_ECR,-(SP)		* ANCIEN ECRAN PHYSIQUE
	MOVE.L	ANC_ECR,-(SP)		* ANCIEN ECRAN LOGIQUE
	MOVE.W 	#5,-(SP)		* FONCTION SETSCREEN
	TRAP 	#14			* DU XBIOS
	LEA.L 	12(SP),SP		* CORRIGE LA PILE
	
	MOVE.L	SAUVE,-(SP)		* RETOUR EN UTILISATEUR
	MOVE.W 	#$20,-(SP)		* AVEC LA FONCTION SUPER
	TRAP 	#1			* DU GEMDOS
	ADDQ.L 	#6,SP			*
	
	PEA	CHUT_DA	   		* ADRESSE DES PARAMETRES
	MOVE.W	#$20,-(A7) 		* FONCTION DOSOUND
	TRAP	#14        		* DU XBIOS
	ADDQ.L	#6,A7      		* CORIGE LA PILE

	CLR.W 	-(SP)			* FIN DU PROGRAMME
	TRAP	#1			* FONCTION PTERM
	




VBL_IR	
        CLR	$FFFF8240.W
	CLR.B	TBCR			* ARRET DU TIMER B
;	MOVE.B	#30,TBDR		* INTERUPTION SUR LIGNE 117  (109)
;	MOVE.B	#8,TBCR			* TIMER C EN EVENT COUNT MODE

        bsr	SWAP_SCR
	bsr	AFF_FNT	
	BSR	SCROLL

;	ST	$FFFF8240.W

full	
	MOVE.L	#$FFFF8209,A3	
	MOVE.L	#$FFFF8260,A1	
	MOVE.L	#$FFFF820A,A0	
	MOVE	#80,D0		* NB DE LIGNES
	MOVEQ	#0,D1		
	MOVEQ	#0,D4
	MOVEQ	#2,D3
	MOVEQ	#$10,D6
	MOVE	#$2700,SR


SYNCHRO	MOVE.B	(A3),D7     * SYNCHRO
	BEQ.S	SYNCHRO
	SUB.W	D7,D6		
	LSL.W	D6,D1		

	REPT	2
	NOP	
	ENDR

	REPT	19
	move.l	(a6)+,(a5)+
	ENDR

	
FULLSCREEN

	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)

;	MOVE	(a6)+,$ffff8244.W		
;	MOVE	(a6),$ffff8242.W
;	MOVE	(a6)+,$ffff8244.W	* MOVE.W=4 NOPS
		
	REPT	4
	NOP				
	ENDR
	
	REPT	17
	move.l	(a6)+,(a5)+						 
	ENDR

	MOVE.B	D4,(A0)
	MOVE.B	D3,(A0)
	
	REPT	3		
	NOP
	ENDR
	REPT	2
	move.l	(a6)+,(a5)+
	ENDR
	
	MOVE.B	D3,(A1)
	NOP
	MOVE.B	D4,(A1)


	move.l	(a6)+,(a5)+
	
	REPT	4
	NOP			 
	ENDR

	DBF	D0,FULLSCREEN







	bsr	SCROLL2
	CLR	$FFFF8240.W

	CMPI.B	#$39,$FFFFFC02.W
 	BEQ	FIN
	RTE
	
	
TB00_IR	
        ;MOVE.B  #0,SYNCRO
        ;MOVE.W   #$010,$FF8240
        ;CLR.B	TBCR			* ARRET DU TIMER
	;MOVE.B	#30,TBDR		* PROCHAINE INTERUP DANS 74 LIGNES
	;MOVE.B	#8,TBCR			* PASSE EN EVENT COUNT MODE
	;MOVE.L	#TB01_IR,$120		* NOUVELLE ROUTINE TIMER B
	;BCLR	#0,ISRA			* LIBERE L'INTERUPTION
	RTE				* FIN DE L'INTERUPTION (RETOUR)

;TBF_IR
;     REPT 127
;	NOP				* BOUCLE D'ATTENTE...
;     ENDR
;	MOVE.B	#0,SYNCRO		* PASSAGE EN 60 HZ
;     REPT 8
;     	NOP				* BOUCLE D'ATTENTE
;     ENDR
;	MOVE.B	#2,SYNCRO		* RETOUR EN 50 HZ
;	CLR.B	TBCR			* ARRET DU TIMER B
;	MOVE.L	#TB00_IR,$120		* NOUVELLE ROUTINE TIMER B
;	BCLR	#0,ISRA			* INTERUPTION TRAITEE
;	RTE				* RETOUR
**********************************************************************

**** Procedures ****
SET_SCR:	move.l	#BUFFERSCR,d0	;adresse buffer dans d0
	and.l	#$ffffff00,d0		;adresse multiple de 256
	move.l	d0,SCREEN1		;adresse obtenue dans SCREEN1
	add.l	#64000,d0		;32000 octets plus loin...
	move.l	d0,SCREEN2		;...SCREEN2
	rts				;retour

SWAP_SCR:	move.l	SCREEN1,d0	;adresse Ecran courant dans d0
	move.l	SCREEN2,SCREEN1		;ecran travail sur ecran courant
	move.l	d0,SCREEN2		;ecran courant sur ecran travail
	;l� en fait il a permut� les deux ecrans travail et courant	
	;il a mis l'un sur l'autre et vice-versa,c'est le SWAP-SCREEN
	lsr.l	#8,d0		8*2=16
	move.l	#$ffff8201,a0
	movep	d0,(a0)
	rts
SCROLL:	
        move.l	SCREEN2,a5	Ecran de travail
	LEA	160(A5),A5
	move.l	SCREEN2,a6
	LEA	168(A6),A6
	
	rept	800
	move.l	(a6)+,(a5)+	
	endr
	
	RTS
SCROLL2
* Total � effectuer:   nb lignes * 58
*	= 81*58
	
	
	
	rept 	3059-800                   *=(81*38)-19-scroll
	move.l	(a6)+,(a5)+
	endr



	rts

AFF_FNT:	cmp.w	#1,PART_AFF
	blo	PART1
	beq	PART2
	cmp.w	#3,PART_AFF
	blo	PART3
	beq	PART4
	
PART1:	move.l	#IMAGE+34,a2	Pointe sur les fontes
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1	(8 pixels de large)
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	81
	move.b	INC+9(a2),INC2(a1)
	move.b	INC+11(a2),INC2+2(a1)
	move.b	INC+13(a2),INC2+4(a1)
        move.b  INC+15(a2),INC2+6(a1)  * ok je pense
INC	set	INC+160
INC2	set	INC2+230
	endr
	
	addq.l	#2,a0		On passe � une autre lettre
	cmp.w	#$ffff,(a0)
	bne	GO_LET
	lea	TEXTE,a0
GO_LET:	move.l	a0,MEM_LET	On sauvegarde le pointeur
	
	move.l	#IMAGE+34,a2
	adda.w	(a0),a2
INC	set 	0
INC2	set 	0
	rept 	81
	move.b	INC+0(a2),INC2+1(a1)
	move.b	INC+2(a2),INC2+3(a1)
	move.b	INC+4(a2),INC2+5(a1)  * ok
        move.b  INC+6(a2),INC2+7(a1)
        
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#1,PART_AFF
	bra	FIN_SCRO	
	
PART2:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	81
	move.l	INC(a2),INC2(a1)
	move.w	INC+4(a2),INC2+4(a1)
        move.w  INC+6(a2),INC2+6(a1)      * ok
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#2,PART_AFF
	bra	FIN_SCRO

PART3:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	81
	move.b	INC+1(a2),INC2(a1)	
	move.b	INC+3(a2),INC2+2(a1)	
	move.b	INC+5(a2),INC2+4(a1)
        move.b  INC+7(a2),INC2+6(a1)
	move.b	INC+8(a2),INC2+1(a1)	
	move.b	INC+10(a2),INC2+3(a1)	
	move.b	INC+12(a2),INC2+5(a1)	
        move.b  INC+14(a2),INC2+7(a1)      * ok ?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#3,PART_AFF
	bra	FIN_SCRO

PART4:	move.l	#IMAGE+34,a2
	move.l	MEM_LET,a0
	adda.w	(a0),a2
	move.l	SCREEN2,a1
	adda.l	#216+160,a1
INC	set	0
INC2	set	0
	rept	81
	move.l	INC+8(a2),INC2(a1)
	move.w	INC+12(a2),INC2+4(a1)
        move.w  INC+14(a2),INC2+6(a1)  * ok?
INC	set	INC+160
INC2	set	INC2+230
	endr
	move.w	#0,PART_AFF
	bra	FIN_SCRO

FIN_SCRO	rts	

******************************



	
**** Variables ***

	section   data

TEXTE:	INCBIN	speed.txt
IMAGE:	INCBIN	FNT_80.PI1
	DS.B	160*80  * pour le caractere " "

CHUT_DA	DC.B	7,$FF,6,0,8,0,9,0,$A,0

 	SECTION BSS
 	EVEN
F_PILE	DS.L 	128			* FIN DE LA PILE
D_PILE	DS.L 	1			* DEBUT DE LA PILE
SAUVE	DS.L	1			* SAUVE LA PILE UTILISATEUR
ANC_VBL DS.L	1			* SAUVE LE VECTEUR VBL
ANC_TB	DS.L	1			* SAUVE LE VECTEUR TIMER B
ANC_ECR	DS.L	1			* SAUVE L'ADRESSE DE L'ECRAN
POIROT1	DS.W	1			* COMPTEURS POUR FAIRE DEMARRER
POIROT2	DS.W	1			* LES ANIMATIONS, LES UNES
POIROT3	DS.W	1			* APRES LES AUTRES
POIROT4	DS.W	1			*
RES	DS.W	1			* SAUVE LA RESOLUTION
ANC_PAL	DS.W	16			* SAUVE LA PALETTE
MFP1	DS.B	1			* SAUVE LES REGISTRES DU MFP
MFP2	DS.B	1			*
MFP3	DS.B	1			*
MFP4	DS.B	1			*
MFP5	DS.B	1			*
MFP6	DS.B	1			*
VSYNC	DS.B	1			* POUR LA SYNCRO VERTICALE
	ds.b	256		;tranquille pour les merdes
BUFFERSCR:ds.b	64000*2		;buffer de 64000 octets pour les deux ecrans
				;SCREEN1 et SCREEN2
	ds.b	256		;tranquille pour les merdes II
SCREEN1:	ds.l	1	;ecran	courant
SCREEN2:	ds.l	1	;ecran	travail
MEM_LET:	ds.l	1
PART_AFF:	ds.l    1
		