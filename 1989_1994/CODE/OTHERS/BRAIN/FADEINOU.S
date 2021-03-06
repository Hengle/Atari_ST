REGS	REG	D0-D7/A0-A6

***************************************************************************
* FADE OUT : 
* PROCEDURE DE FADE OUT DES PALETTES HAUTES ET BASSES
* PARAMETRES ATTENDUS :
* ADRESSE DE LA PALETTE HAUTE : A0
* ADRESSE DE LA PALETTE BASSE : A1
***************************************************************************
FADE_OUT:
	MOVEM.L	REGS,-(SP)

	MOVE.L	A0,A6			SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DU HAUT
	MOVE.L	A1,A5			SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DU BAS
FADE_AGAIN:
	CLR.W	D6
FADE_WAIT:
	CLR.B	_VBL_ENABLE
FADE_WAIT_1:
	TST.B	_VBL_ENABLE		ATTENDRE 4 VBLS ENTRE LES MODIFS DE PALETTE
	BEQ.S	FADE_WAIT_1
	ADDQ.W	#1,D6
	CMPI.W	#4,D6
	BLE.S	FADE_WAIT

	MOVE.L	A6,A0			DEBUT DE LA PALETTE HAUTE DANS A0
	MOVE.L	A5,A1			DEBUT DE LA PALETTE BASSE DANS A1
	MOVE.L	#15,D3			TRAITER 16 COULEURS
	CLR.W	D4			REMISE A ZERO DU FLAG DE CHANGEMENT
FADE_NEXT:
	MOVE.W	#%0000000100000000,D1	VALEUR A SOUSTRAIRE
	MOVE.W	#%0000111100000000,D0	MASQUE QUARTET DE LA COULEUR COURANTE
	MOVE.W	#%1111000011111111,D5	MASQUE AVANT REMISE A JOUR
	
FADE_BCL:
	* PALETTE DU HAUT

	MOVE.W	(A0),D2			COULEUR DANS D2
	AND.W	D0,D2			MASQUE DES BITS NON DESIRES
	TST.W	D2			TOUS LES BITS A ZERO ?
	BEQ.S	FADE_PALETTE_BAS	OUI, ALORS TRAITER LES SUIVANTS

	SUB.W	D1,D2			SOUSTRAIRE UN NIVEAU DE COULEUR A D2
	AND.W	D5,(A0)			EFFACER LES BITS DU QUARTET A REMPLACER
	OR.W	D2,(A0)			STOCKER NOUVELLE VALEUR DE LA COULEUR
	MOVE.W	#1,D4			FLAG DE CHANGEMENT POSITIONNE

FADE_PALETTE_BAS:

	* PALETTE DU BAS

	MOVE.W	(A1),D2			COULEUR DANS D2
	AND.W	D0,D2			MASQUE DES BITS NON DESIRES
	TST.W	D2			TOUS LES BITS A ZERO ?
	BEQ.S	NEXT_QUARTET		OUI, ALORS TRAITER LES SUIVANTS

	SUB.W	D1,D2			SOUSTRAIRE UN NIVEAU DE COULEUR A D2
	AND.W	D5,(A1)			EFFACER LES BITS DU QUARTET A REMPLACER
	OR.W	D2,(A1)			STOCKER NOUVELLE VALEUR DE LA COULEUR
	MOVE.W	#1,D4			FLAG DE CHANGEMENT POSITIONNE
	
NEXT_QUARTET:
	LSR.W	#4,D1			DECALER D1,D0,D5
	LSR.W	#4,D0
	ROR.W	#4,D5
	TST.W	D1			D1 NUL ?
	BNE.S	FADE_BCL		NON, ON CONTINUE POUR CETTE COULEUR
	ADDQ.L	#2,A0			COULEUR SUIVANTE PALETTE DU HAUT
	ADDQ.L	#2,A1			COULEUR SUIVANTE PALETTE DU BAS
	DBRA	D3,FADE_NEXT		ON Y VA
	TST.W	D4			Y A-T-IL EU UN CHANGEMENT SUR LA PALETTE ? 
	BNE.S	FADE_AGAIN		OUI, ON REFAIT UN TOUR DE PALETTE
	
	MOVEM.L	(SP)+,REGS
	RTS

***************************************************************************
* FADE IN : 
* PROCEDURE DE FADE IN DES PALETTES HAUTES ET BASSES
* PARAMETRES ATTENDUS :
* ADRESSE DE LA PALETTE HAUTE              : A0
* ADRESSE DE LA PALETTE BASSE              : A1
* ADRESSE DE LA PALETTE HAUTE DE REFERENCE : A2
* ADRESSE DE LA PALETTE BASSE DE REFERENCE : A3
***************************************************************************
FADE_IN:
	MOVEM.L	REGS,-(SP)

	MOVE.L	A0,_SAVE_FADE_PAL_TOP	SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DU HAUT
	MOVE.L	A1,_SAVE_FADE_PAL_BOT	SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DU BAS
	MOVE.L	A2,_SAVE_FADE_REF_TOP	SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DE REFERENCE DU HAUT
	MOVE.L	A3,_SAVE_FADE_REF_BOT	SAUVEGARDE ADRESSE DE DEBUT DE LA PALETTE DE REFERENCE DU BAS

FADE_IN_AGAIN:
	CLR.W	D6
FADE_IN_WAIT:
	CLR.B	_VBL_ENABLE
FADE_IN_WAIT_1:
	TST.B	_VBL_ENABLE		ATTENDRE 4 VBLS ENTRE LES MODIFS DE PALETTE
	BEQ.S	FADE_IN_WAIT_1
	ADDQ.W	#1,D6
	CMPI.W	#4,D6
	BLE.S	FADE_IN_WAIT

	MOVE.L	_SAVE_FADE_PAL_TOP,A0	ADRESSE DE DEBUT DE LA PALETTE DU HAUT DANS A0
	MOVE.L	_SAVE_FADE_PAL_BOT,A1	ADRESSE DE DEBUT DE LA PALETTE DU BAS DANS A1
	MOVE.L	_SAVE_FADE_REF_TOP,A2	ADRESSE DE DEBUT DE LA PALETTE DE REFERENCE DU HAUT DANS A2
	MOVE.L	_SAVE_FADE_REF_BOT,A3	ADRESSE DE DEBUT DE LA PALETTE DE REFERENCE DU BAS DANS A3

	MOVE.L	#15,D3			TRAITER 16 COULEURS
	CLR.W	D4			REMISE A ZERO DU FLAG DE CHANGEMENT
FADE_IN_NEXT:
	MOVE.W	#%0000000100000000,D1	VALEUR A AJOUTER
	MOVE.W	#%0000111100000000,D0	MASQUE QUARTET DE LA COULEUR COURANTE
	MOVE.W	#%1111000011111111,D5	MASQUE AVANT REMISE A JOUR
	MOVE.W	#2,D7			FAIRE 3 BOUCLES PAR COULEUR
	
FADE_IN_BCL:
	* PALETTE DU HAUT

	MOVE.W	(A0),D2			COULEUR DANS D2
	AND.W	D0,D2			MASQUE DES BITS NON DESIRES
	MOVE.W	(A2),D6			COULEUR DE REFERENCE DANS D6
	AND.W	D0,D6			MASQUE DES BITS NON DESIRES
	CMP.W	D6,D2			COULEUR COURANTE < COULEUR DE REFERENCE ?
	BEQ.S	FADE_IN_PALETTE_BAS	NON, TRAITER L'AUTRE PALETTE

	ADD.W	D1,D2			AJOUTER UN NIVEAU DE COULEUR A D2
	AND.W	D5,(A0)			EFFACER LES BITS DU QUARTET A REMPLACER
	OR.W	D2,(A0)			STOCKER NOUVELLE VALEUR DE LA COULEUR
	MOVE.W	#1,D4			FLAG DE CHANGEMENT POSITIONNE

FADE_IN_PALETTE_BAS:

	* PALETTE DU BAS

	MOVE.W	(A1),D2			COULEUR DANS D2
	AND.W	D0,D2			MASQUE DES BITS NON DESIRES
	MOVE.W	(A3),D6			COULEUR DE REFERENCE DANS D6
	AND.W	D0,D6			MASQUE DES BITS NON DESIRES
	CMP.W	D6,D2			COULEUR COURANTE < COULEUR DE REFERENCE ?
	BEQ.S	NEXT_IN_QUARTET		NON, TRAITER QUARTET SUIVANT

	ADD.W	D1,D2			AJOUTER UN NIVEAU DE COULEUR A D2
	AND.W	D5,(A1)			EFFACER LES BITS DU QUARTET A REMPLACER
	OR.W	D2,(A1)			STOCKER NOUVELLE VALEUR DE LA COULEUR
	MOVE.W	#1,D4			FLAG DE CHANGEMENT POSITIONNE
	
NEXT_IN_QUARTET:
	LSR.W	#4,D1			DECALER D1,D0,D5
	LSR.W	#4,D0
	ROR.W	#4,D5
	DBRA	D7,FADE_IN_BCL		ON CONTINUE POUR CETTE COULEUR
	
	ADDQ.L	#2,A0			COULEUR SUIVANTE PALETTE DU HAUT
	ADDQ.L	#2,A1			COULEUR SUIVANTE PALETTE DU BAS
	ADDQ.L	#2,A2			COULEUR SUIVANTE PALETTE DE REFERENCE DU HAUT
	ADDQ.L	#2,A3			COULEUR SUIVANTE PALETTE DE REFERENCE DU BAS
	DBRA	D3,FADE_IN_NEXT		ON Y VA
	TST.W	D4			Y A-T-IL EU UN CHANGEMENT SUR LA PALETTE ?
	BNE	FADE_IN_AGAIN		OUI, ON REFAIT UN TOUR DE PALETTE
	
	MOVEM.L	(SP)+,REGS
	RTS

_SAVE_FADE_PAL_TOP:
	DC.L	0
_SAVE_FADE_PAL_BOT:
	DC.L	0
_SAVE_FADE_REF_TOP:
	DC.L	0
_SAVE_FADE_REF_BOT:
	DC.L	0

_VBL_ENABLE:
	DC.B	0		* FLAG DE VSYNC ( POSITIONNE EN VBL )
	EVEN