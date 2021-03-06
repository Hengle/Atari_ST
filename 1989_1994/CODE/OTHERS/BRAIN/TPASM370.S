****************************************************************************
*	UN P'TIT CADEAU (EMPOISONNE ?), MON 1ER T.P. ASSEMBLEUR 370 IBM
*
****************************************************************************
*			ASM01 PARTIE NUMERO 1
****************************************************************************

ASM01	  START
	  PRINT	ON,NOGEN

	  STM	14,12,12,(13)
	  BALR	3,0
	  USING	*,3

	  LM	6,8,=H'0,0,0,-1,256'

	  LA	10,LDETAIL	ZONE=LDETAIL
	  LA	11,51		LONG=51
	  IC	12,=C' '	SAUT=' '

BOUCLE	  LA	7,1(7)		INCREMENTATION DU COMPTEUR PRINCIPAL

	  LH	4,7		CHARGEMENT DU COMPTEUR DANS LE REG 4

	  SRDL	4,4		DOUBLE DECALAGE A DROITE SUR 4 BITS DU REG 4
	  SRL	5,28		DECALAGE DROITE DE 28 BITS DU REG 5

	  IC	6,TABCAR(4)	CHARGEMENT DANS LE REG 6 DU CARACTERE
*				CORRESPONDANT AU QUARTET DE GAUCHE (REG 4)

	  STC	6,LDETAIL+23	METTRE LA LETTRE TROUVEE DANS LA LIGNE DETAIL

	  IC	6,TABCAR(5)	CHARGEMENT DANS LE REG 6 DU CARACTERE
*				CORRESPONDANT AU QUARTET DE DROITE (REG 5)

	  STC	6,LDETAIL+24	METTRE LA LETTRE TROUVEE DANS LA LIGNE DETAIL

	  STC	7,LDETAIL+50	METTRE CARACTERE A EDITER DANS LA LIGNE DETAIL

	  BAL	14,AFFICHE	IMPRESSION

	  BCT	8,BOUCLE	ICI ON DOIT BOUCLER 256 FOIS...

*******************
* 2E PARTIE DU TP *
*******************
	  LA	10,LTIRET	ZONE=LTIRET
	  LA	11,69		LONG=69
	  IC	12,=C'1'	SAUT='1'

	  BAL	14,AFFICHE	IMPRESSION

	  LA	10,LDETAIL2	ZONE=LDETAIL2
	  IC	12,=C' '	SAUT=' '

	  BAL	14,AFFICHE	IMPRESSION

	  MVC	TIRET2(4),TIRET1 RECOPIE DES OCTETS 4 A 8 A PARTIR
*				 DE L'OCTET 0 DE LTIRET

	  MVC	CADRE(4),LDETAIL RECOPIE DES OCTETS 4 A 8 A PARTIR
*				 DE L'OCTET 0 DE LDETAIL2

	  LM	4,5,=F'0'	RAZ DU (4) ET DU (5)
	  LH	7,=H'-1'	INIT DU COMPTEUR PRINCIPAL
	  LA	9,16		VALEUR DE LA BOUCLE PRINCIPALE

BIGLOOP	  LA	10,ENTETE	ADR. DE DEBUT DU TRANSFERT DES VALEURS

	  LA	7,1(7)		INCREMENTATION DU COMPTEUR GENERAL

	  IC	6,TABCAR(9)	POINTE SUR LA VALEUR DE L'ENTETE
	  STC	6,ENTETE	PUIS ECRITURE DANS LA LIGNE DETAIL2

	  L	10,CADRE-2	ADR. D'INITIALISATION DU (10)

	  LA	8,16		VALEUR DE LA PETITE BOUCLE
	  
LITTLOOP  LA	10,4(10)	INCREMENTATION DE 4 DU (10) = POSTE SUIVANT

	  STC	7,CADRE(10)	ECRITURE DE LA VALEUR DU COMPTEUR DANS LDETAIL2

	  LA	7,1(7)		COMPTEUR PRINCIPAL + 1

	  BCT	8,LITTLOOP	ON DOIT BOUCLER 16 FOIS...

	  LA	10,LTIRET	ZONE=LTIRET
	  BAL	14,AFFICHE	IMPRESSION

	  LA	10,LDETAIL2	ZONE=LDETAIL2
	  BAL	14,AFFICHE	IMPRESSION

	  BCT	9,BIGLOOP	ON DOIT BOUCLER 16 FOIS AUSSI...

	  LA	10,LTIRET	ZONE=LTIRET
	  BAL	14,AFFICHE	IMPRESSION

	  LM	14,12,12(13)	RESTAURATION DES REGS
	  BCR	15,14		RETOUR A L'INITIATOR...

********************************
* IMPRESSION DE LA LIGNE DETAIL
********************************
AFFICHE	  ST	14,STACK	SAUVEGARDE DU (14) DANS STACK

	  IMPRIM ZONE=LDETAIL,LONG=51,SAUT=' '

	  L	14,STACK	RESTAURATION DU (14)

	  BR	14		RETOUR AU MAIN

****************************************************************************

TABCAR	  DC	CL16'0123456789ABCDEF'


LDETAIL	  DC	CL51'LA VALEUR HEXADECIMALE .. CORRESPOND AU CARACTERE .'

LDETAIL2  DS	0CL69
	  DC	2C' '
ENTETE	  DC	2C' '
CADRE	  DC	CL65'! 0 ! 1 ! 2 ! 3 ! 4 ! 5 ! 6 ! 7 ! 8 ! 9 ! A ! B ! C*
		 ! D ! E ! F !'


LTIRET	  DS	0CL69
TIRET1	  DC	4C' '
TIRET2	  DC	16CL4'+---'
	  DC	C'+'


STACK	  DS	F

	  END